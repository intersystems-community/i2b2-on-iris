Class I2B2onFHIR.Transformations.PatientDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.PatientDimensionTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.PatientDimensionTransformResponse).%New()
        set target.sexcd = ..SexCD(source.json)
        set target.vitalstatuscd = ..VitalStatusCD(source.json)
        set target.birthdate = source.json."birthDate"
        set target.deathdate =  source.json."deceasedDateTime"
        set target.ageinyearsnum = ..AgeInYearsNum(source.json)
        set target.languagecd = ..LanguageCD(source.json)
        set target.racecd = ..RaceCD(source.json)
        set target.maritalstatuscd = source.json.maritalStatus.coding."0".display
        set target.religioncd = ..ReligionCD(source.json)
        set target.zipcd = source.json.address."0".postalCode
        set target.statecityzippath = ..StateCityZipPath(source.json)
        set target.incomecd = ""
        set target.patientblob = ""
        set target.updatedate = ..CurrentDT()
        set target.downloaddate = ..CurrentDT()
        set target.importdate = ..CurrentDT()
        set target.sourcesystemcd = ..SourceSystemCD(source.json)
        
        set target.patientnum = ..getI2B2ID("patient", source.json.id,,"patient_dimension")
        set target.uploadid = target.patientnum

		do ..TempSaveData(source.json)
		
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod TempSaveData(json As %DynamicObject) As %Status [ Private ]
{
	
	set resourceType = $zcvt(json."resourceType","L")
	
	S itr = json.identifier.%GetIterator()
	while itr.%GetNext(.key,.value) {
		I value.system '= "http://fhir.carevolution.com/identifiers/CareEvolution/MRN/CACode" continue
	
		S ^TempSaveData(resourceType,json.id)=""
		S ^TempSaveData(resourceType,json.id,"mrn")=value.value
	}
	
	I '$IsObject(json.name) Q $$$OK
	S ^TempSaveData(resourceType,json.id,"family")=json.name."0".family
	
	I '$IsObject(json.name."0".given) Q $$$OK
	S ^TempSaveData(resourceType,json.id,"name")=json.name."0".given."0"
	Q $$$OK
}

ClassMethod MaritalStatus(json As %DynamicObject) As %String [ Private ]
{
	s status = ""
	if '$IsObject(json.maritalStatus) Q status
	if '$IsObject(json.maritalStatus.coding) Q status
	Q json.maritalStatus.coding."0".display
}

ClassMethod LanguageCD(json As %DynamicObject) As %String [ Private ]
{
	set lang = ""
	if '$IsObject(json.communication) Q lang
	set itr = json.communication.%GetIterator()
	while itr.%GetNext(.key,.val) {
		if '$IsObject(val) continue
		if '$IsObject(val.language) continue
		set lang = val.language.coding."0".display
		if lang '= "" quit
	}
	quit lang
}

ClassMethod RaceCD(json As %DynamicObject) As %String [ Private ]
{
		
	set race = ""

	if '$IsObject(json.extension) Q race
	set itr = json.extension.%GetIterator()
	while itr.%GetNext(.key,.val) {
		if '$IsObject(val) continue
		if val.url '= "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race" continue
		if '$IsObject(val.extension) continue
		set race = val.extension."0".valueCoding.display
		if race '= "" Q
		set race = val.extension."0".valueString
		if race '= "" Q
	}
	Q race
}

ClassMethod ReligionCD(json As %DynamicObject) As %String [ Private ]
{
	set religion = ""
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
	if json."deceasedDateTime" '= "" Q "N"
	Q "Y"
}

ClassMethod AgeInYearsNum(json As %DynamicObject) As %Integer [ Private ]
{
	S birthday = json."birthDate"
	I birthday="" Q 0
	S birthday=$tr(birthday,"-/ ")
	S now = $p(json."meta"."lastUpdated","T")
	S now=$tr(now,"-/ ")
	S:now="" now=$zdt(+$h,8)
	Q (now-birthday)\10000
}

ClassMethod StateCityZipPath(json As %DynamicObject) As %String [ Private ]
{
	S zip = json.address."0"."postalCode"
	S city = json.address."0".city
	S state = json.address."0".state
	I zip="",city="",state="" Q ""
	Q state_"\"_city_"\"_zip
}

}

