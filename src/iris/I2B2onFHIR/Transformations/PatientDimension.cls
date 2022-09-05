Class I2B2onFHIR.Transformations.PatientDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.PatientDimensionTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.PatientDimensionTransformResponse).%New()
        set target.sexcd = ..SexCD(source.json) //source.json."gender"
        set target.vitalstatuscd = ..VitalStatusCD(source.json) //source.json."deceasedBoolean"
        set target.birthdate = source.json."birthDate"
        set target.deathdate =  source.json."deceasedDateTime"
        set target.ageinyearsnum = ..AgeInYearsNum(source.json)
        set target.languagecd = ..LanguageCD(source.json)
        set target.racecd = ..RaceCD(source.json) ;source.json.extension.extension.display
        set target.maritalstatuscd = source.json.maritalStatus.text
        set target.religioncd = ..ReligionCD(source.json) ;source.json.extension."valueCodeableConcept".coding.code
        set target.zipcd = source.json.address."0".postalCode
        set target.statecityzippath = ..StateCityZipPath(source.json)
        set target.incomecd = ""
        set target.patientblob = ""
        set target.updatedate = ..CurrentDT()
        set target.downloaddate = ..DownloadDate(source.json)
        set target.importdate = ..CurrentDT()
        set target.sourcesystemcd = ..SourceSystemCD(source.json)
        
        //Index patientdimensionpk On patientnum [ PrimaryKey, SqlName = patient_dimension_pk, Type = index, Unique ];
        set target.patientnum = ..getI2B2ID("patient", source.json.id,,"patient_dimension") //..UploadId(source.json)
        set target.uploadid = target.patientnum

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod LanguageCD(json As %DynamicObject) As %String [ Private ]
{
	set lang = ""
	//source.json.communication.[].language.text ??
	//source.json.communication.[].language.coding.[].display 
	//source.json.communication.[].language.coding.[].code
	//S ^tmpJSON($I(^tmpJSON))=json.%ToJSON()
	
	if '$IsObject(json.communication) Q lang
	set itr = json.communication.%GetIterator()
	while itr.%GetNext(.key,.val) {
		if '$IsObject(val) continue
		if '$IsObject(val.language) continue
		//if 'val.preferred continue
		set lang = val.language.text ;coding."0".code
		if lang '= "" quit
	}
	
	quit lang
}

ClassMethod RaceCD(json As %DynamicObject) As %String [ Private ]
{
	set race = ""
	//extension.extension.display
	if '$IsObject(json.extension) Q race
	set itr = json.extension.%GetIterator()
	while itr.%GetNext(.key,.val) {
		if '$IsObject(val) continue
		if '$IsObject(val.extension) continue
		set race = val.extension."0".valueCoding.display
		if race '= "" 
	}
	Q race
}

ClassMethod ReligionCD(json As %DynamicObject) As %String [ Private ]
{
	set religion = ""
	//extension.valueCodeableConcept.coding.code
	if '$IsObject(json.extension) Q religion
	set itr = json.extension.%GetIterator()
	while itr.%GetNext(.key,.val) {
		if '$IsObject(val) continue
		if '$IsObject(val."valueCodeableConcept") continue
		set religion = val."valueCodeableConcept".coding."0".code
		if religion '= "" quit
	}
	Q religion
}

ClassMethod SexCD(json As %DynamicObject) As %String [ Private ]
{
	set sex = $zcvt(json."gender","L")
	Q $select(sex = "female":"F", sex = "male":"M", 1:"")
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
	I birthday="" Q 0
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
	S zip = json.address."0"."postalCode"
	S city = json.address."0".city
	S state = json.address."0".state
	I zip="",city="",state="" Q ""
	Q state_"\"_city_"\"_zip
}

}

