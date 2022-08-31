Class I2B2onFHIR.Transformations.PatientDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.PatientDimensionTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.PatientDimensionTransformResponse).%New()
        set target.sexcd = ..SexCD(source.json) //source.json."gender"
        //set target.patientnum =..getI2B2ID("patient", source.json.id) //patient_mapping.patient_num //..PatientNum(source.json) ;source.json
        set target.vitalstatuscd = ..VitalStatusCD(source.json) //source.json."deceasedBoolean"
        set target.birthdate = source.json."birthDate"
        set target.deathdate =  source.json."deceasedDateTime"
        set target.ageinyearsnum = ..AgeInYearsNum(source.json)
        set target.languagecd = source.json.communication.language.text
        set target.racecd = source.json.extension.extension.display
        set target.maritalstatuscd = source.json.maritalStatus.text
        set target.religioncd = source.json.extension."valueCodeableConcept".coding.code
        set target.zipcd = source.json.address."0".postalCode
        set target.statecityzippath = ..StateCityZipPath(source.json)
        set target.incomecd = ""
        set target.patientblob = ""
        set target.updatedate = ..CurrentDT()
        set target.downloaddate = ..DownloadDate(source.json)
        set target.importdate = ..CurrentDT()
        set target.sourcesystemcd = ..SourceSystemCD(source.json)
        
        //Index patientdimensionpk On patientnum [ PrimaryKey, SqlName = patient_dimension_pk, Type = index, Unique ];
        set target.uploadid = ..getI2B2ID("patient", source.json.id) //..UploadId(source.json)
        set target.patientnum = target.uploadid

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod SexCD(json As %DynamicObject) As %String [ Private ]
{
	set sex = json."gender"
	Q $select(sex = "Female":"F", sex = "Male":"M", 1:"")
}

ClassMethod VitalStatusCD(json As %DynamicObject) As %String [ Private ]
{
	//IF Patient.deceasedDateTime IS NOT NULL THEN 'N'
	if json."deceasedDateTime" '= "" Q "N"
	Q "Y"
}

ClassMethod AgeInYearsNum(json As %DynamicObject) As %Integer [ Private ]
{
	S birthday = json."birthDate"
	S birthday=$tr(birthday,"-/ ")
	// нужно брать не "сейчас", а дату study date/first visit
	//calculate from study date/first visit: 
	//start_date.visit_dimension - Patient_dimension.birth_date
	S now=$zdt(+$h,8)
	Q (now-birthday)\10000
}

ClassMethod StateCityZipPath(json As %DynamicObject) As %String [ Private ]
{
	//state\city\zip code\
	S zip = json.address."postalCode"
	S city = json.address.city
	S state = json.address.state
	Q state_"\"_city_"\"_zip
}

}

