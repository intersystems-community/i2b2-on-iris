Class I2B2onFHIR.Transformations.EncounterMapping Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.EncounterMappingTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.EncounterMappingTransformResponse).%New()
        set target.downloaddate=""
        set target.encounteride=""
        set target.encounteridesource=""
        set target.encounteridestatus=""
        set target.encounternum=""
        set target.importdate=""
        set target.patientide=""
        set target.patientidesource=""
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

