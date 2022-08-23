Class I2B2onFHIR.Transformations.Patient Extends Ens.DataTransform
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.patientDataTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.patientDataTransformResponse).%New()
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

ClassMethod UploadId(json As %DynamicObject) As %String [ Private ]
{
	//is empty IN IRIS.  I think that there should be an ID from care evolution, but it should be an int type
	Q ""
}

ClassMethod SourceSystemCD(json As %DynamicObject) As %String [ Private ]
{
	//Demo in IRIS. we can put "Test"
	Q "Test"
}

ClassMethod DownloadDate(json As %DynamicObject) As %Library.TimeStamp [ Private ]
{
	Q ""
}

ClassMethod PatientBlob(json As %DynamicObject) As %String [ Private ]
{
	//is empty in IRIS
	Q ""
}

ClassMethod IncomeCD(json As %DynamicObject) As %String [ Private ]
{
	// пусто
	Q ""
}

ClassMethod StateCityZipPath(json As %DynamicObject) As %String [ Private ]
{
	//state\city\zip code\
	S zip = json.address."postalCode"
	S city = json.address.city
	S state = json.address.state
	Q state_"\"_city_"\"_zip
}

ClassMethod RaceCD(json As %DynamicObject) As %String [ Private ]
{
	Q ""
}

ClassMethod AgeInYearsNum(json As %DynamicObject) As %Integer [ Private ]
{
	S birthday = json."birthDate"
	S birthday=$tr(birthday,"-/ ")
	// нужно брать не "сейчас", а дату study date/first visit
	S now=$zdt(+$h,8)
	Q (now-birthday)\10000
}

ClassMethod DeathDate(json As %DynamicObject) As %Library.TimeStamp [ Private ]
{
	Q ""
}

ClassMethod VitalStatusCD(json As %DynamicObject) As %String [ Private ]
{
	//IF Patient.deceasedDateTime IS NOT NULL THEN 'N'
	if json."deceasedDateTime" '= "" Q "N"
	Q "Y"
}

ClassMethod PatientNum(json As %DynamicObject) As %Integer [ Private ]
{
	// генерим автоматически, произвольный номер
	Q $tr($now(),".,")
}

ClassMethod SexCD(json As %DynamicObject) As %String [ Private ]
{
	set sex = json."gender"
	Q $select(sex = "Female":"F", sex = "Male":"M", 1:"")
}

ClassMethod CurrentDT() As %Library.TimeStamp [ Private ]
{
	//update_date=import_date in IRIS
	Q $zdt($h,3)
}

}

