Class I2B2onFHIR.Transformations.ObservationFile Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()
        
		set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
		S record.encounternum=..EncounterNum(source.json)
		s record.patientnum = ..PatientNum(source.json)
		s record.conceptcd=..ConceptCD(source.json)
		s record.providerid=..ProviderID()
		s record.modifiercd="@"	
		set encounter = ##class(public.visitdimension).visitdimensionpkOpen(record.encounternum,record.patientnum)
		if '$IsObject(encounter) s sc=$$$ERROR("Cannot open visit_dimension for encounter_num="_record.encounternum_" and patient_num="_record.patientnum) Q		 
		s record.startdate = encounter.startdate
		s record.enddate = encounter.enddate
		s record.locationcd = encounter.locationcd
		
		s record.instancenum="1"		
		s record.valtypecd="N"
		s record.tvalchar="E"
		s record.nvalnum=source.json.valueQuantity.code
		s record.valueflagcd=..ValueFlag(source.json)
		s record.quantitynum=""
		s record.unitscd=source.json.valueQuantity.code
		s record.confidencenum=""
		s record.downloaddate=..CurrentDT()
		s record.observationblob=""
		s record.sourcesystemcd=..SourceSystemCD(source.json)
		s record.textsearchindex=""
		s record.importdate=..CurrentDT()	
		s record.updatedate=..CurrentDT()
		s record.uploadid=""
		s ok=record.%ValidateObject()
		if $$$ISOK(ok) {
			do target.data.Insert(record)  
		}
		else  {
			$$$LOGWARNING("ObservationFile Transform. %ValidateObject return "_$system.Status.GetErrorText(ok))
		}      

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod ValueFlag(json As %DynamicObject) As %Library.String [ Private ]
{
	if '$IsObject(json.interpretation) Q ""
	if '$IsObject(json.interpretation."0".coding) Q ""
	Q json.interpretation."0".coding."0".display
}

ClassMethod ConceptCD(json As %DynamicObject) As %Library.String [ Private ]
{
	
	set system("http://anthem.com/codes/TNMCD/ProcedureCode")=$lb(4,"TNMCD")
	set system("http://fhir.carevolution.com/codes/DemoNamespace/LabObservationType")=$lb(5,"DemoNamespace")
	set system("http://fhir.carevolution.com/codes/HolyCross-Meditech-NS/LabObservationType")=$lb(6,"HCMNS")
	set system("http://fhir.carevolution.com/codes/Lourdes-Burlington-Sunquest-NS/LabObservationType")=$lb(7,"LBSNS")
	set system("http://fhir.carevolution.com/codes/Lourdes-Camden-Sunquest-NS/LabObservationType")=$lb(8,"LCSNS")
	set system("http://fhir.carevolution.com/codes/Lourdes-Sunquest-NS-HL7-2-3/LabObservationType")=$lb(9,"LSNS")
	set system("http://fhir.carevolution.com/codes/NextGen-LabCorp/LabObservationType")=$lb(3,"NextGen")
	set system("http://fhir.carevolution.com/codes/z-LOINC-DONOTUSE/LabObservationType")=$lb(2,"LOINC")
	set system("http://loinc.org")=$lb(1,"LOINC")
	set system("urn:oid:1.2.3.4.5.6.1.13.5.1.7.2.768282")=$lb(10,"oid:1.2.3.4.5.6.1.13.5.1.7.2.768282")	
	
	set foundObj=""
	set lastObj=""
	if '$IsObject(json) Q ""
	if '$IsObject(json.code.coding) Q ""
	S itr = json.code.coding.%GetIterator()
	while itr.%GetNext(.key,.obj) {
		if obj.system'="",$d(system(obj.system)) {
			if foundObj="" {
				S foundObj = obj
			}
			else  {
				if ($lg(system(obj.system),1) < $lg(system(foundObj.system),1)) {
					S foundObj = obj
				}
			}
			if $lg(system(foundObj.system),1) = 1 quit
		}
		S lastObj=obj
	}
	s concept = ""
	if foundObj'="",foundObj.code'="" {
		S code = "%"_foundObj.code	
		&sql(SELECT top(1) "concept_cd" INTO :concept FROM "public"."concept_dimension" where "concept_cd" LIKE :code)
		
		if $g(concept)'="" QUIT concept
		s concept = $lg(system(foundObj.system),2)_":"_foundObj.code

	}	
	else  {
		S foundObj=lastObj
		S system=$S($F(foundObj.system,":"):$P(foundObj.system,":",2),1:foundObj.system)
		I $E(system,1,2)="//" s system=$e(system,3,*)
		s concept = system_":"_foundObj.code
	}
	//codelookuppk On (tablecd, columncd, codecd)
	if ##class(public.codelookup).codelookuppkExists("OBSERVATION_FACT","CONCEPT_CD",concept) Q concept
	
	s lookup = ##class(public.codelookup).%New()
	s lookup.tablecd = "OBSERVATION_FACT"
	s lookup.columncd = "CONCEPT_CD"
	S lookup.codecd = concept
	S lookup.downloaddate=..CurrentDT()
	s lookup.importdate=..CurrentDT()
	s lookup.lookupblob=foundObj.system
	s lookup.namechar=foundObj.display
	s lookup.sourcesystemcd=..SourceSystemCD(json)
	s lookup.updatedate=..CurrentDT()
	s lookup.uploaddate=""
	s lookup.uploadid=""
	d lookup.%Save()

	Q concept
}

}

