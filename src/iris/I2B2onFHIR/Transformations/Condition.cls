Class I2B2onFHIR.Transformations.Condition Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	k ^tmpdbg
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()
        
		set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
		S record.encounternum=..EncounterNum(source.json)
		s record.patientnum = ..PatientNum(source.json)
		s record.conceptcd=..ConceptCD(source.json)
		s record.providerid=..ProviderID()
		s record.modifiercd=..ModifierCD(source.json)	
		set encounter = ##class(public.visitdimension).visitdimensionpkOpen(record.encounternum,record.patientnum)
				 
		s record.startdate = encounter.startdate
		s record.enddate = encounter.enddate
		s record.locationcd = encounter.locationcd
		
		s record.instancenum="1"		
		s record.valtypecd="T"
		s record.tvalchar=""
		s record.nvalnum=""
		s record.valueflagcd=""
		s record.quantitynum=""
		s record.unitscd="@"
		s record.confidencenum=""
		s record.downloaddate=""
		s record.observationblob=""
		s record.sourcesystemcd=..SourceSystemCD(source.json)
		s record.textsearchindex=""
		s record.importdate=..CurrentDT()	
		s record.updatedate=..CurrentDT()
		s record.uploadid=""
		do target.data.Insert(record)        

	} catch e {
		s sc = e.AsStatus()
		s ^tmpdbg("err")=sc
	}
	q sc
}

ClassMethod ConceptCD(json As %DynamicObject) As %Library.String [ Private ]
{
	
	set system("http://careevolution.com/fhircodes#DiagnosisCode")=$lb(6,"fhircodes")
	set system("http://fhir.carevolution.com/codes/CTKDemo/CTKDemoProblemType")=$lb(7,"CTKDemo")
	set system("http://fhir.carevolution.com/codes/DemoNamespace/DiagnosisCode")=$lb(8,"DemoNamespace")
	set system("http://fhir.carevolution.com/codes/Horizon/DiagnosisCode")=$lb(9,"Horizon")
	set system("http://fhir.carevolution.com/codes/Lourdes-Burlington-Invision-NS/DiagnosisCode")=$lb(10,"LBINS")
	set system("http://fhir.carevolution.com/codes/z-SNOMED-DONOTUSE/DiagnosisCode")=$lb(4,"SNOMED")
	set system("http://snomed.info/sct")=$lb(5,"Snomed")
	set system("http://hl7.org/fhir/sid/icd-10")=$lb(1,"ICD10")
	set system("http://hl7.org/fhir/sid/icd-10-cm")=$lb(2,"ICD10")
	set system("http://hl7.org/fhir/sid/icd-9-cm")=$lb(3,"ICD9")
	
	S foundObj=""
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
	}
	if foundObj="" Q ""
	if foundObj.code="" Q ""
	
	S code = "%"_foundObj.code	
	&sql(SELECT top(1) "concept_cd" INTO :concept FROM "public"."concept_dimension" where "concept_cd" LIKE :code)
	if $g(concept)'="" Q concept

	s concept = $lg(system(foundObj.system),2)_":"_foundObj.code
	
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

ClassMethod ModifierCD(json As %DynamicObject) As %Library.String [ Private ]
{
	S val = json.category."0".coding."0".display
	I val'="" Q val
	S val = json.category."0".coding."0".code
	Q val
}

}

