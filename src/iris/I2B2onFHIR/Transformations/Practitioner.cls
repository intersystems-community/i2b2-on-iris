Class I2B2onFHIR.Transformations.Practitioner Extends Ens.DataTransform
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.practitionerDataTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.practitionerDataTransformResponse).%New()
        set target.downloaddate=..CurrentDT()
        set target.importdate=..CurrentDT()
        set target.namechar=..NameChar(source.json)
        set target.providerblob=""
        set target.providerid=..ProviderId()
        set target.providerpath=..ProviderPath(source.json)
        set target.sourcesystemcd="TEST"
        set target.updatedate=..CurrentDT()
        set target.uploadid=source.json.id


	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod CurrentDT() As %Library.TimeStamp [ Private ]
{
	//update_date=import_date in IRIS
	Q $zdt($h,3)
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

}

