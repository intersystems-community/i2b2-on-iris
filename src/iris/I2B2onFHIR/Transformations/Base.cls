Class I2B2onFHIR.Transformations.Base Extends Ens.DataTransform
{

ClassMethod CurrentDT() As %Library.TimeStamp [ Private ]
{
	//update_date=import_date in IRIS
	Q $zdt($h,3)
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

ClassMethod NameChar(json As %DynamicObject) As %Library.String
{
	//"Practitioner.name.family", "Practitioner.name.given", "Practitioner.name.prefix"
	set fam = json.name.family
	set nam = ""
	set prefix = ""
	// И имя и префикс массивы. Выбираем все имена и префиксы или только первый?
	set itr = json.name.given.%GetIterator()
	If itr.%GetNext(.key,.val) {
		S nam = val
	}
	set itr = json.name.prefix.%GetIterator()
	If itr.%GetNext(.key,.val) {
		S prefix = val
	}
	Set result = fam_", "_nam
	if prefix '= "" {
		S result = result_", "_prefix
	}
	Q result
}

ClassMethod ProviderId() As %String [ Private ]
{
	// Автоматически генерируем код следующим образом: 
	//в начале символы 'LCS-I2B2:D0001090' затем какой-то набор чисел. 
	//Пример:LCS-I2B2:D000109065
	Q "LCS-I2B2:D0001090"_$tr($now(),".,")
}

ClassMethod ProviderPath(json As %DynamicObject) As %String [ Private ]
{
	//Concat:('\i2b2\Providers\', Encounter.classHistory.class, '\' , provider_dimension.name_char, '\')
	//A string representing the unique position of a provider in a hierarchical department tree.
	//Example:          \i2b2\Providers\Emergency\Carter, John, MD\
	S $p(result,"\",2)="i2b2"
	S $p(result,"\",3)="Providers"
	S $p(result,"\",4)="" ;Encounter.classHistory.class -- Как получить здесь???
	S $p(result,"\",5)=..NameChar(json)
	S $p(result,"\",6)=""
}

ClassMethod ActiveStatusCD(json As %DynamicObject) As %String [ Private ]
{
	I json.status="planned" Q "PRELIMINARY"
	I json.status="arrived" Q "ACTIVE"
	I json.status="triaged" Q "ACTIVE"
	I json.status="in-progress" Q "ACTIVE"
	I json.status="onleave" Q "NULL"
	I json.status="finished" Q "FINAL"
	I json.status="cancelled" Q "NULL"
	I json.status="entered-in-error" Q "NULL"
	I json.status="unknown" Q "NULL"
	Q "NULL"
}

ClassMethod LengthOfStay(json As %DynamicObject) As %Integer [ Private ]
{
	if json.classHistory.class="inpatient" {
		//calc period from json.classHistory.period
	}
	Q 0
}

ClassMethod InoutCD(json As %DynamicObject) As %String [ Private ]
{
	I json.classHistory.class="inpatient" Q "IP"
	I json.classHistory.class="outpatient" Q "OP"
	I json.classHistory.class="ambulatory" Q "AV"
	I json.classHistory.class="emergency" Q "ED"
	Q ""
}

}

