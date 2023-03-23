Class I2B2onFHIR.Transformations.PatientMaping Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.PatientMapingTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.PatientMapingTransformResponse).%New()
        set target.downloaddate=..DownloadDate(source.json)
        set target.importdate=..CurrentDT()
        set target.patientide=source.json."id"
        set target.patientidesource=..IdeSource()
        set target.patientidestatus=source.json."_deceasedBoolean"."id"
        do ..ProjectID(.projectid)
        set target.projectid=$S(projectid'="":projectid,1:"TEST")
        set target.sourcesystemcd=..SourceSystemCD(source.json)
        set target.updatedate=..CurrentDT()
        set target.uploaddate=..CurrentDT()

        set target.patientnum = ..getI2B2ID("patient", source.json."id",,"patient_dimension")
        set target.uploadid = target.patientnum

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

