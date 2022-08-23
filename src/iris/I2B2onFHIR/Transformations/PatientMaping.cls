Class I2B2onFHIR.Transformations.PatientMaping Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.PatientMapingTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.PatientMapingTransformResponse).%New()
        set target.downloaddate=""
        set target.importdate=""
        set target.patientide=""
        set target.patientidesource=""
        set target.patientidestatus=""
        set target.patientnum=""
        set target.projectid=""
        set target.sourcesystemcd=""
        set target.updatedate=""
        set target.uploaddate=""
        set target.uploadid=""

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

