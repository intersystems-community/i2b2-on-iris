Class I2B2onFHIR.Transformations.PatientDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.PatientDimensionTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.PatientDimensionTransformResponse).%New()
        set target.sexcd = ..SexCD(source.json) //source.json."gender"
        set target.patientnum = ..PatientNum(source.json) ;source.json
        set target.vitalstatuscd = ..VitalStatusCD(source.json) //source.json."deceasedBoolean"
        set target.birthdate = source.json."birthDate"
        set target.deathdate = ..DeathDate(source.json) ;source.json
        set target.ageinyearsnum = ..AgeInYearsNum(source.json)
        set target.languagecd = source.json.communication.language.text
        set target.racecd = ..RaceCD(source.json)
        set target.maritalstatuscd = source.json.maritalStatus.text
        set target.religioncd = source.json.extension."valueCodeableConcept".coding.code
        set target.zipcd = source.json.address."postalCode"
        set target.statecityzippath = ..StateCityZipPath(source.json)
        set target.incomecd = ..IncomeCD(source.json)
        set target.patientblob = ..PatientBlob(source.json)
        set target.updatedate = ..CurrentDT()
        set target.downloaddate = ..DownloadDate(source.json)
        set target.importdate = ..CurrentDT()
        set target.sourcesystemcd = ..SourceSystemCD(source.json)
        set target.uploadid = ..UploadId(source.json)

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

