Class I2B2onFHIR.Transformations.VisitDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.VisitDimensionTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.VisitDimensionTransformResponse).%New()
        set target.activestatuscd= ..ActiveStatusCD(source.json)
        set target.downloaddate=..CurrentDT()
        set target.encounternum=..PatientNum(source.json)
        set target.enddate=source.json.period.end
        set target.importdate=..CurrentDT()
        set target.inoutcd=..InoutCD(source.json)
        set target.lengthofstay=..LengthOfStay(source.json)
        set target.locationcd=source.json.location.location.display
        set target.locationpath=""
        set target.patientnum=..PatientNum(source.json)
        set target.sourcesystemcd="Test"
        set target.startdate=source.json.period.start
        set target.updatedate=..CurrentDT()
        set target.uploadid="" ;is empty IN IRIS.  I think that there should be an ID from care evolution, but it should be an int type
        set target.visitblob=""
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

