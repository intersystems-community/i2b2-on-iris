Class I2B2onFHIR.Transformations.ObservationFact Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.ObservationFactBPRequest, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	s sc = $$$OK
	try {
		$$$TRACE("ObservationFact Transform. Start")
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()	
	
		
		set sc = ##class(I2B2onFHIR.Utils.Main).getIDfromTable("""public"".""patient_dimension""", "patient_num", source.patientNum, .ID)
		if $$$ISERR(sc) Q
		#dim patient as public.patientdimension = $$$NULLOREF
		if ID > 0 {
			set patient = ##class(public.patientdimension).%OpenId(ID)
		}
	
		#dim provider as public.providerdimension = ##class(public.providerdimension).%New()
		set provider.providerid = ..ProviderID()
				
		#dim concept as public.conceptdimension = $$$NULLOREF
		if $IsObject(patient) {
			set sc = ##class(I2B2onFHIR.Utils.Main).getIDfromTable("""public"".""concept_dimension""", "upload_id", patient.uploadid, .ID)
		}
		if $$$ISERR(sc) Q
		if ID > 0 {
			set concept = ##class(public.conceptdimension).%OpenId(ID)
		}	
		$$$TRACE("ObservationFact Transform. DEMOGRAPHICS PART")
	
		// DEMOGRAPHICS PART
		For Method = "AGE","DATEB","DATED","LANGUAGE","MARITAL","RACE","RELIGION","SEX","VITAL" {
			set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
			set ok = $CLASSMETHOD(..%ClassName(1),Method,source, patient, provider, concept, .record)
			$$$TRACE("ObservationFact Transform. "_Method_" return "_ok)
			if $$$ISOK(ok) {
				s ok=record.%ValidateObject()
				if $$$ISOK(ok) {
					do target.data.Insert(record)
				}
				else  {
					$$$LOGWARNING("ObservationFact Transform. "_Method_". %ValidateObject return "_$system.Status.GetErrorText(ok))
				}
			}
		}
		$$$TRACE("ObservationFact Transform. PHI")
		
		// PHI
		
		For Method = "FIRSTNAME","LASTNAME","MRN" {
			set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
			set ok = $CLASSMETHOD(..%ClassName(1),Method,source, patient, .record)
			$$$TRACE("ObservationFact Transform. "_Method_" return "_ok)
			if $$$ISOK(ok) {
				s ok=record.%ValidateObject()
				if $$$ISOK(ok) {
					do target.data.Insert(record)
				}
				else  {
					$$$LOGWARNING("ObservationFact Transform. "_Method_". %ValidateObject return "_$system.Status.GetErrorText(ok))
				}				
			}
		}
		
	} catch e {
		s sc = e.AsStatus()
	}
	$$$TRACE("ObservationFact Transform. End")
	q sc
}

ClassMethod GetEncounterFirst(patient As public.patientdimension) As public.visitdimension
{
	#dim counter as public.visitdimension = $$$NULLOREF
	if '$IsObject(patient) Q counter
	S pnum = patient.patientnum
	&sql(select top(1) ID INTO :id from "public"."visit_dimension" where  patient_num = :pnum order by start_date )
	if id = "" Q counter
	Q ##class(public.visitdimension).%OpenId(id)
}

ClassMethod GetEncounterLast(patient As public.patientdimension) As public.visitdimension
{
	#dim counter as public.visitdimension = $$$NULLOREF
	if '$IsObject(patient) Q counter
	S pnum = patient.patientnum
	&sql(select top(1) ID INTO :id from "public"."visit_dimension" where  patient_num = :pnum order by start_date DESC )
	if id = "" Q counter
	Q ##class(public.visitdimension).%OpenId(id)
}

/// for all patients
ClassMethod AGE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	
	
	$$$TRACE("ObservationFact Transform. AGE")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)
	
	s record.patientnum = source.patientNum
		

	s:$IsObject(patient) record.conceptcd="DEM|AGE:"_patient.ageinyearsnum		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=""		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="N"		//
	s record.valueflagcd=""		//
	Q $$$OK
}

/// for all patients
ClassMethod DATEB(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. DATEB")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)
	
	s record.patientnum = source.patientNum
	
	s:$IsObject(patient) record.conceptcd="DEM|DATE:"_patient.birthdate  //DEM|DATE:BIRTH
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date
	s:$IsObject(patient) record.tvalchar = patient.birthdate
	s:$IsObject(patient) record.nvalnum=$tr(patient.birthdate," -:",".")				

	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=""		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="D"		//
	s record.valueflagcd=""		//	
	Q $$$OK
}

/// only for patients with a filled in date of death: Patient_dimension.death_date
ClassMethod DATED(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. DATED")
	
	if $IsObject(patient),patient.deathdate = "" Q $$$ERROR("Patient is alive")
	#dim counter as public.visitdimension = ..GetEncounterLast(patient)

	s record.patientnum = source.patientNum
	
	s:$IsObject(patient) record.conceptcd="DEM|DATE:"_patient.deathdate  //DEM|DATE:DEATH
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date  самого  последнего  визита // необходим перебор?
	s record.enddate = record.startdate		//observation_fact.start_date
	s:$IsObject(patient) record.tvalchar = patient.deathdate
	s:$IsObject(patient) record.nvalnum=$tr(patient.deathdate," -:",".")				

	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="D"		//
	s record.valueflagcd=""		//	
	Q $$$OK
}

/// only for patients with a filled in Patient_dimension.language_cd
ClassMethod LANGUAGE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. LANGUAGE")
	
	if $IsObject(patient),patient.languagecd = "" Q $$$ERROR("languagecd is empty")
	
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)	
	
	s record.patientnum = source.patientNum
	
	s:$IsObject(patient) record.conceptcd="DEM|LANGUAGE:"_patient.languagecd		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date
	
	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=""		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	
	Q $$$OK
}

/// only for patients with a filled in  Patient_dimension.language_cd
ClassMethod MARITAL(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. MARITAL")
	
	if $IsObject(patient),patient.maritalstatuscd = "" Q $$$ERROR("maritalstatuscd is empty")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)

	s record.patientnum = source.patientNum
	
	s:$IsObject(patient) record.conceptcd="DEM|MARITAL:"_patient.maritalstatuscd		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=""		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	
	Q $$$OK
}

/// only for patients with a filled in  Patient_dimension.language_cd
ClassMethod RACE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. RACE")
	
	if $IsObject(patient),patient.racecd = "" Q $$$ERROR("racecd is empty")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)


	s record.patientnum = source.patientNum
	
	s:$IsObject(patient) record.conceptcd="DEM|RACE:"_patient.racecd		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=""		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	
	Q $$$OK
}

/// only for patients with a filled in  Patient_dimension.language_cd
ClassMethod RELIGION(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. RELIGION")
	
	if $IsObject(patient),patient.religioncd = "" Q $$$ERROR("religioncd is empty")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)
	
	s record.patientnum = source.patientNum
	
	s:$IsObject(patient) record.conceptcd="DEM|RELIGION:"_patient.religioncd		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=""		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	
	Q $$$OK
}

/// for all patients
ClassMethod SEX(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. SEX")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)
	
	s record.patientnum = source.patientNum
	
	s:$IsObject(patient) record.conceptcd="DEM|SEX:"_$zcvt(patient.sexcd,"L")		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=""		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	
	Q $$$OK
}

/// only for patients with a filled in Patient_dimension.vital_status_cd
ClassMethod VITAL(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. VITAL")
	
	if $IsObject(patient),patient.vitalstatuscd = "" Q $$$ERROR("vitalstatuscd is empty")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)

	s record.patientnum = source.patientNum

	s:$IsObject(patient) record.conceptcd="DEM|VITAL:"_$zcvt(patient.vitalstatuscd,"L")		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=""		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	
	Q $$$OK
}

ClassMethod FIRSTNAME(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. FIRSTNAME")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)
	
	s record.patientnum = source.patientNum
	
	s record.conceptcd="PHI:FNAME"
	s record.providerid="@"
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	S record.encounternum="-1"  //**
	s record.confidencenum=""	
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="PHI|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=$lg(..GetPatientData(record.patientnum),2)
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//

	Q $$$OK
}

ClassMethod LASTNAME(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	
	$$$TRACE("ObservationFact Transform. LASTNAME")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)
	
	s record.patientnum = source.patientNum
	

	s record.conceptcd="PHI:LNAME"
	s record.providerid="@"
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	S record.encounternum="-1"
	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="PHI|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=$lg(..GetPatientData(record.patientnum),3)
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//
	Q $$$OK
}

ClassMethod MRN(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. MRN")
	#dim counter as public.visitdimension = ..GetEncounterFirst(patient)
	
	s record.patientnum = source.patientNum
	

	s:$IsObject(patient) record.conceptcd="PHI:MRN"
	s record.providerid="@"
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	S record.encounternum="-1"
	s record.confidencenum=""	//
	s record.downloaddate=..CurrentDT()	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.nvalnum=""		//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="PHI|TEST"	//
	s record.textsearchindex=""	//
	s record.tvalchar=$lg(..GetPatientData(record.patientnum),1)		//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//
	Q $$$OK
}

ClassMethod GetPatientData(patientNum As %String) As %List [ Private ]
{
	&sql(select top(1) patient_ide INTO :id from "public"."patient_mapping" where patient_num = :patientNum )
	I id = "" Q $lb()
	S mrn=$g(^TempSaveData("patient",id,"mrn"))
	S name=$g(^TempSaveData("patient",id,"name"))
	S family=$g(^TempSaveData("patient",id,"family"))
	Q $lb(mrn,name,family)
}

}

