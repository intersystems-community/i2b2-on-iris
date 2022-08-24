Class I2B2onFHIR.Transformations.VisitDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.VisitDimensionTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.VisitDimensionTransformResponse).%New()
        set target.activestatuscd= ..ActiveStatusCD(source.json)
        set target.downloaddate=..CurrentDT()
        set target.encounternum="" //encounter_mapping.encounter_num //..PatientNum(source.json)
        set target.enddate=source.json.period.end
        set target.importdate=..CurrentDT()
        set target.inoutcd=..InoutCD(source.json)
        set target.lengthofstay=..LengthOfStay(source.json)
        set target.locationcd=source.json.location.location.display
        set target.locationpath=""
        set target.patientnum="" //patient_mapping.patient_num //..PatientNum(source.json)
        set target.sourcesystemcd=..SourceSystemCD(source.json)
        set target.startdate=source.json.period.start
        set target.updatedate=..CurrentDT()
        set target.uploadid= ..UploadId(source.json) ;is empty IN IRIS.  I think that there should be an ID from care evolution, but it should be an int type
        set target.visitblob=""
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod ActiveStatusCD(json As %DynamicObject) As %String [ Private ]
{
	I json.status="planned" Q "PRELIMINARY"
	I json.status="arrived" Q "ACTIVE"
	I json.status="triaged" Q "ACTIVE"
	I json.status="in-progress" Q "ACTIVE"
	I json.status="onleave" Q "NULL"
	I json.status="finished" Q "FINAL"
	I json.status="cancelled" Q "NULL"
	I json.status="entered-in-error" Q "NULL"
	I json.status="unknown" Q "NULL"
	Q "NULL"
}

ClassMethod LengthOfStay(json As %DynamicObject) As %Integer [ Private ]
{
	if json.classHistory.class="inpatient" {
		//calc period from json.classHistory.period
	}
	Q 0
}

ClassMethod InoutCD(json As %DynamicObject) As %String [ Private ]
{
	I json.classHistory.class="inpatient" Q "IP"
	I json.classHistory.class="outpatient" Q "OP"
	I json.classHistory.class="ambulatory" Q "AV"
	I json.classHistory.class="emergency" Q "ED"
	Q ""
}

}

