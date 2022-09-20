Class I2B2onFHIR.Transformations.VisitDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.VisitDimensionTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.VisitDimensionTransformResponse).%New()
        set target.activestatuscd= ..ActiveStatusCD(source.json)
        set target.downloaddate=..CurrentDT()
        S dt=source.json.period.end
        S t = $p(dt,"T",2)
        set dlm = $e(t,9)
        set target.enddate=$tr($p(dt,dlm,1,*-1),"T"," ")
        set target.importdate=..CurrentDT()
        set target.inoutcd=..InoutCD(source.json)
        set target.locationcd=source.json.location."0".location.display
        set target.locationpath=""
        set refType = $p(source.json."subject"."reference", "/", 1)
        set refId = $p(source.json."subject"."reference", "/", 2)
        set target.patientnum=##class(I2B2onFHIR.Utils.Main).getI2B2ID(refType, refId, 1,,"patient_dimension")
        set target.sourcesystemcd=..SourceSystemCD(source.json)
        S dt=source.json.period.start
        S t = $p(dt,"T",2)
        set dlm = $e(t,9)
        set target.startdate=$tr($p(dt,dlm,1,*-1),"T"," ")
        set target.updatedate=..CurrentDT()
        
        set target.lengthofstay=..LengthOfStay(source.json,target.inoutcd,target.startdate,target.enddate)
        
        set target.encounternum= ..getI2B2ID("encounter", source.json."id",$lb(target.patientnum),"visit_dimension")
        set target.uploadid = target.encounternum
        set target.visitblob=""
        
        do ..TempSaveData(source.json)
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod TempSaveData(json As %DynamicObject) As %Status [ Private ]
{
	S itr = json.participant.%GetIterator()
	while itr.%GetNext(.key,.value) {
		s val = value."individual"."reference"
		i val="" continue
		S ^TempSaveData($zcvt($p(val,"/"),"L"),$p(val,"/",2))=json.id
		if json.class.code '= "" {
			S ^TempSaveData($zcvt($p(val,"/"),"L"),$p(val,"/",2),"class.code")=json.class.code
		}
	}
	Q $$$OK
}

ClassMethod ActiveStatusCD(json As %DynamicObject) As %String [ Private ]
{
	q ..Lookup("lookup.visitdimention.activestatus",json.status,"NULL",2)
}

ClassMethod LengthOfStay(json As %DynamicObject, inoutcd As %String, startdate As %Library.TimeStamp, enddate As %Library.TimeStamp) As %Integer [ Private ]
{
	if inoutcd '= "Observation or Inpatient Hospital care",inoutcd '= "Inpatient" Q 0
	if enddate = "" Q 1
	set ed = $TR($P(enddate," "),"-/ ")	
	set sd = $TR($P(startdate," "),"-/ ")
	if ed=sd Q 1
	Q ed-sd
}

ClassMethod InoutCD(json As %DynamicObject) As %String
{
	
	S result = json.class.code
	I result '= "" Q result
	
	
	S urls("http://fhir.carevolution.com/codes/CPT/PatientClass")=1
	S urls("http://careevolution.com/fhircodes#PatientClass")=2
 	S urls("http://fhir.carevolution.com/codes/NextGen/PatientClass")=3
	S urls("http://fhir.carevolution.com/codes/FHIR-STU3/PatientClass")=4
 	S urls("http://fhir.carevolution.com/codes/FhirCodes/PatientClass")=5
 	S urls("http://fhir.carevolution.com/codes/Facets/PatientClass")=6
 	S urls("http://anthem.com/codes/CDA-CL_KHEALTH_M_KMDSYNTHETIC/PatientClass")=7
  	S urls("urn:oid:1.2.840.114350.1.13.300.3.7.4.698084.30")=8
	
	S lbresult=$$RecursiveSearch(json,.urls)
	
	Q $lg(lbresult,2)
	
	
RecursiveSearch(jsonObj,URLS)
	I '$IsObject(jsonObj) Q ""
	I jsonObj.system'="" {
		S prio = +$G(URLS(jsonObj.system))
		s value = jsonObj.display
		I value="" {
			s value = jsonObj.code
		}
		S result = $lb(prio,value)
	}
	else  {
		S result = ""
		S itr = jsonObj.%GetIterator()
		while itr.%GetNext(.key,.obj) {
			S tmpres=$$RecursiveSearch(obj,.URLS)
			if result="" {
				s result=tmpres
			}
			else  {
				if $lg(tmpres,1)>0,$lg(tmpres,1)<$lg(result,1) {
					s result=tmpres
				}
			}
		}
	}
	
	Q result
}

}

