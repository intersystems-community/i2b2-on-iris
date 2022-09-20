Class I2B2onFHIR.Transformations.MedicationRequest Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()
        
        for method = "AT","DOSE","FREQ","ROUTE" {
			set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
			
			S record.encounternum=..EncounterNum(source.json)
			s record.patientnum = ..PatientNum(source.json)
			s record.conceptcd=..ConceptCD(source.json)
			s record.providerid=..ProviderID()
				
			set encounter = ##class(public.visitdimension).visitdimensionpkOpen(record.encounternum,record.patientnum)
			if '$IsObject(encounter) s sc=$$$ERROR("Cannot open visit_dimension for encounter_num="_record.encounternum_" and patient_num="_record.patientnum) Q		 
		 
			s record.startdate = encounter.startdate
			set ok = $CLASSMETHOD(..%ClassName(1),method, source.json, encounter, .record)
			if $$$ISOK(ok) {
				s ok=record.%ValidateObject()
				if $$$ISOK(ok) {
					do target.data.Insert(record)
				}
				else  {
					$$$LOGWARNING("MedicationRequest Transform. "_method_". %ValidateObject return "_$system.Status.GetErrorText(ok))
				}				
			}     
			   
        }

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod AT(json As %DynamicObject, encounter As public.visitdimension, ByRef record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
		s record.enddate = encounter.enddate
		s record.locationcd = encounter.locationcd
		
		s record.modifiercd="@"
		
		s record.instancenum="1"		
		s record.valtypecd=""
		s record.tvalchar=""
		s record.nvalnum=""
		s record.valueflagcd=""
		s record.quantitynum=""
		s record.unitscd=""
		s record.confidencenum=""
		s record.downloaddate=..CurrentDT()
		s record.observationblob=""
		s record.sourcesystemcd=..SourceSystemCD(json)
		s record.textsearchindex=""
		s record.importdate=..CurrentDT()	
		s record.updatedate=..CurrentDT()
		s record.uploadid=""
		
		Q $$$OK
}

ClassMethod DOSE(json As %DynamicObject, encounter As public.visitdimension, ByRef record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
		s record.enddate = encounter.enddate
		s record.locationcd = encounter.locationcd
		
		s record.modifiercd="MED:DOSE"
		
		s record.instancenum="1"		
		s record.valtypecd="T"
		s record.tvalchar=..tValChar(json,record.modifiercd)
		s record.nvalnum=""
		s record.valueflagcd=""
		s record.quantitynum=""
		
		s unit = json.MedicationRequest.dosageInstruction.doseAndRate.low.code
		
		s record.unitscd=$S(unit'="":unit,1:"@")
		s record.confidencenum=""
		s record.downloaddate=..CurrentDT()
		s record.observationblob=""
		s record.sourcesystemcd=..SourceSystemCD(json)
		s record.textsearchindex=""
		s record.importdate=..CurrentDT()	
		s record.updatedate=..CurrentDT()
		s record.uploadid=""
		
		Q $$$OK
}

ClassMethod FREQ(json As %DynamicObject, encounter As public.visitdimension, ByRef record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
		s record.enddate = encounter.enddate
		s record.locationcd = encounter.locationcd
		
		s record.modifiercd="MED:FREQ"
		
		s record.instancenum="1"		
		s record.valtypecd="T"
		s record.tvalchar=..tValChar(json,record.modifiercd)
		s record.nvalnum=""
		s record.valueflagcd=""
		s record.quantitynum=""
		s record.unitscd=""
		s record.confidencenum=""
		s record.downloaddate=..CurrentDT()
		s record.observationblob=""
		s record.sourcesystemcd=..SourceSystemCD(json)
		s record.textsearchindex=""
		s record.importdate=..CurrentDT()	
		s record.updatedate=..CurrentDT()
		s record.uploadid=""
		
		Q $$$OK
}

ClassMethod ROUTE(json As %DynamicObject, encounter As public.visitdimension, ByRef record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
		s record.enddate = encounter.enddate
		s record.locationcd = encounter.locationcd
		
		s record.modifiercd="MED:ROUTE"
		
		s record.instancenum="1"		
		s record.valtypecd="T"
		s record.tvalchar=..tValChar(json,record.modifiercd)
		s record.nvalnum=""
		s record.valueflagcd=""
		s record.quantitynum=""
		s record.unitscd=""
		s record.confidencenum=""
		s record.downloaddate=..CurrentDT()
		s record.observationblob=""
		s record.sourcesystemcd=..SourceSystemCD(json)
		s record.textsearchindex=""
		s record.importdate=..CurrentDT()	
		s record.updatedate=..CurrentDT()
		s record.uploadid=""
		
		Q $$$OK
}

ClassMethod tValChar(json As %DynamicObject, modifier As %String = "") As %Library.String [ Private ]
{
	S res = json.MedicationRequest.dosageInstruction.text
	if modifier="MED:DOSE" Q res
	if modifier="MED:FREQ" {
		S val = json.MedicationRequest.dosageInstruction.timing.code.coding."0".display
	}
	elseif modifier="MED:ROUTE" {
		s val=json.MedicationRequest.dosageInstruction.route.coding."0".display
	}
	else  {
		s val=""
	}
	if val'="" s res=val
	
	Q res
}

ClassMethod ConceptCD(json As %DynamicObject) As %Library.String [ Private ]
{
	
	set system("http://hl7.org/fhir/sid/ndc")=$lb(1,"NDC")
	set system("http://www.nlm.nih.gov/research/umls/rxnorm")=$lb(2,"RXNORM")
	set system("http://fhir.carevolution.com/codes/z-RxNorm-DONOTUSE/OrderableItem")=$lb(3,"RXNORM")
	set system("http://fhir.carevolution.com/codes/NextGen-NDC/OrderableItem")=$lb(4,"NDC")
	
	S foundObj=""
	set lastObj=""
	if '$IsObject(json) Q ""
	if '$IsObject(json.medicationCodeableConcept.coding) Q ""
	S itr = json.medicationCodeableConcept.coding.%GetIterator()
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

