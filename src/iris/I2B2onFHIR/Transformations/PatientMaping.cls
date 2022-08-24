Class I2B2onFHIR.Transformations.PatientMaping Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.PatientMapingTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.PatientMapingTransformResponse).%New()
        set target.downloaddate=..DownloadDate(source.json)
        set target.importdate=..CurrentDT()
        set target.patientide=source.json."ID"
        set target.patientidesource=..IdeSource()
        set target.patientidestatus=source.json."deceasedBoolean"."ID"
        set target.patientnum=..GenerateNum(source.json)
        set target.projectid=""
        set target.sourcesystemcd=..SourceSystemCD(source.json)
        set target.updatedate=..CurrentDT()
        set target.uploaddate=..CurrentDT()
        set target.uploadid=..UploadId(source.json)

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

