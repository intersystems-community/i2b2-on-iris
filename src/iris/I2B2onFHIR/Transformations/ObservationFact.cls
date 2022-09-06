Class I2B2onFHIR.Transformations.ObservationFact Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.ObservationFactBPRequest, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	;K ^tmpDBG
	s sc = $$$OK
	try {
		$$$TRACE("ObservationFact Transform. Start")
		;S ^tmpDBG($I(^tmpDBG),"ObservationFact Transform. Start")=""
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()	
	
		set sc = ##class(I2B2onFHIR.Utils.Main).getIDfromTable("""public"".""visit_dimension""", "patient_num", source.patientNum, .ID)
		if $$$ISERR(sc) Q
		#dim counter as public.visitdimension = $$$NULLOREF
		if ID > 0 {
			set counter = ##class(public.visitdimension).%OpenId(ID)
		}
		
		set sc = ##class(I2B2onFHIR.Utils.Main).getIDfromTable("""public"".""patient_dimension""", "patient_num", source.patientNum, .ID)
		if $$$ISERR(sc) Q
		#dim patient as public.patientdimension = $$$NULLOREF
		if ID > 0 {
			set patient = ##class(public.patientdimension).%OpenId(ID)
		}
		
		// хардкод для демонстрации
		#dim provider as public.providerdimension = ##class(public.providerdimension).%New()
		set provider.providerid = 1
		
		//#dim provider as public.providerdimension = $$$NULLOREF
		/*if $IsObject(counter) {
			set sc = ##class(I2B2onFHIR.Utils.Main).getIDfromTable("""public"".""provider_dimension""", "upload_id", counter.uploadid, .ID)
		}
		if $$$ISERR(sc) Q
		if ID > 0 {
			set provider = ##class(public.providerdimension).%OpenId(ID)
		}
		*/	
		
		#dim concept as public.conceptdimension = $$$NULLOREF
		if $IsObject(counter) {
			set sc = ##class(I2B2onFHIR.Utils.Main).getIDfromTable("""public"".""concept_dimension""", "upload_id", counter.uploadid, .ID)
		}
		if $$$ISERR(sc) Q
		if ID > 0 {
			set concept = ##class(public.conceptdimension).%OpenId(ID)
		}	
		$$$TRACE("ObservationFact Transform. 1")
	
		;S ^tmpDBG($I(^tmpDBG),"ObservationFact Transform. 1")=""

		For Method = "AGE","DATEB","DATED","LANGUAGE","MARITAL","RACE","RELIGION","SEX","VITAL" {
			set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
			set ok = $CLASSMETHOD(..%ClassName(1),Method,source, patient, counter, provider, concept, .record)
			$$$TRACE("ObservationFact Transform. "_Method_" return "_ok)
			;S ^tmpDBG($I(^tmpDBG),"ObservationFact Transform. "_Method)=$lb(ok,record)
			if $$$ISOK(ok) {
				do target.data.Insert(record)
			}
		}
		$$$TRACE("ObservationFact Transform. 2")
		;S ^tmpDBG($I(^tmpDBG),"ObservationFact Transform. 2")=""
	} catch e {
		s sc = e.AsStatus()
		;S ^tmpDBG($I(^tmpDBG),"ObservationFact Transform. Err")=sc
	}
	$$$TRACE("ObservationFact Transform. End")
	;S ^tmpDBG($I(^tmpDBG),"ObservationFact Transform. End")=""
	q sc
}

/// for all patients
ClassMethod AGE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	
	
	$$$TRACE("ObservationFact Transform. AGE")
	
	s record.patientnum = source.patientNum

	s:$IsObject(patient) record.conceptcd="DEM|AGE:"_patient.ageinyearsnum		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=""	//
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
ClassMethod DATEB(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. DATEB")
	
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
	s record.downloaddate=""	//
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
ClassMethod DATED(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. DATED")
	
	if $IsObject(patient),patient.deathdate = "" Q $$$ERROR("Patient is alive")
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
	s record.downloaddate=""	//
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
ClassMethod LANGUAGE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. LANGUAGE")
	
	if $IsObject(patient),patient.languagecd = "" Q $$$ERROR("languagecd is empty")
	s record.patientnum = source.patientNum

	s:$IsObject(patient) record.conceptcd="DEM|LANGUAGE:"_patient.languagecd		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date
	
	s record.confidencenum=""	//
	s record.downloaddate=""	//
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
ClassMethod MARITAL(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. MARITAL")
	
	if $IsObject(patient),patient.languagecd = "" Q $$$ERROR("languagecd is empty")
	s record.patientnum = source.patientNum

	s:$IsObject(patient) record.conceptcd="DEM|MARITAL:"_patient.languagecd		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=""	//
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
ClassMethod RACE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. RACE")
	
	if $IsObject(patient),patient.languagecd = "" Q $$$ERROR("languagecd is empty")
	s record.patientnum = source.patientNum

	s:$IsObject(patient) record.conceptcd="DEM|RACE:"_patient.racecd		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=""	//
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
ClassMethod RELIGION(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. RELIGION")
	
	if $IsObject(patient),patient.languagecd = "" Q $$$ERROR("languagecd is empty")
	s record.patientnum = source.patientNum

	s:$IsObject(patient) record.conceptcd="DEM|RELIGION:"_patient.religioncd		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=""	//
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
ClassMethod SEX(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. SEX")
	
	s record.patientnum = source.patientNum

	s:$IsObject(patient) record.conceptcd="DEM|SEX:"_$zcvt(patient.sexcd,"L")		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=""	//
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
ClassMethod VITAL(source As I2B2onFHIR.Messages.ObservationFactBPRequest, patient As public.patientdimension, counter As public.visitdimension, provider As public.providerdimension, concept As public.conceptdimension, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	$$$TRACE("ObservationFact Transform. VITAL")
	
	s record.patientnum = source.patientNum

	s:$IsObject(patient) record.conceptcd="DEM|VITAL:"_$zcvt(patient.vitalstatuscd,"L")		//concept.conceptcd_":"_patient.ageinyearsnum //???
	s:$IsObject(counter) record.encounternum=counter.encounternum 
	s:$IsObject(provider) record.providerid=provider.providerid
	s record.instancenum="1"
	s:$IsObject(counter) record.startdate = counter.startdate	//visit_dimension.start_date //???
	s:$IsObject(counter) record.enddate = record.startdate		//observation_fact.start_date

	s record.confidencenum=""	//
	s record.downloaddate=""	//
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

}

