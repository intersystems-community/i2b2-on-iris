Class I2B2onFHIR.Transformations.ProviderDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.ProviderDimensionTransformResponse) As %Status
{
	;K ^tmpDBG
	s sc = $$$OK
	;S ^tmpDBG($I(^tmpDBG),"ProviderDimension Transform. Start")=source.json.%ToJSON()
	try {
        set target = ##class(I2B2onFHIR.Messages.ProviderDimensionTransformResponse).%New()
        set target.downloaddate=..CurrentDT()
        set target.importdate=..CurrentDT()
        set target.namechar=..NameChar(source.json)
        set target.providerblob=""
        set target.providerid=..ProviderId(source.json)
        set target.providerpath=..ProviderPath(source.json)
        set target.sourcesystemcd=..SourceSystemCD(source.json)
        set target.updatedate=..CurrentDT()
        set target.uploadid=..UploadId(source.json)
       	;S ^tmpDBG($I(^tmpDBG),"ProviderDimension Transform. Try is OK")=""


	} catch e {
		s sc = e.AsStatus()
		;S ^tmpDBG($I(^tmpDBG),"ProviderDimension Transform. Err")=sc

	}
	;S ^tmpDBG($I(^tmpDBG),"ProviderDimension Transform. End")=sc
	q sc
}

ClassMethod ProviderPath(json As %DynamicObject) As %String [ Private ]
{
	//Concat:('\i2b2\Providers\', Encounter.class.code, '\' , provider_dimension.name_char, '\')
	//A string representing the unique position of a provider in a hierarchical department tree.
	//Example:          \i2b2\Providers\Emergency\Carter, John, MD\
	
	
	set classcode=$g(^TempSaveData("practitioner",json.id),"class.code")
	
	
	S $p(result,"\",2)="i2b2"
	S $p(result,"\",3)="Providers"
	S $p(result,"\",4)=classcode ;Encounter.class.code -- Как получить здесь???
	S $p(result,"\",5)=..NameChar(json)
	S $p(result,"\",6)=""
	Q result
}

ClassMethod ProviderId(json As %DynamicObject) As %String [ Private ]
{
	// Автоматически генерируем код следующим образом: 
	//в начале символы 'LCS-I2B2:D0001090' затем какой-то набор чисел. 
	//Пример:LCS-I2B2:D000109065
	Q "LCS-I2B2:D0001090"_..GenerateNum(json) ;$tr($now(),".,")
}

ClassMethod NameChar(json As %DynamicObject) As %Library.String [ Private ]
{
	s result=""
	//"Practitioner.name.family", "Practitioner.name.given", "Practitioner.name.prefix"
	I '$IsObject(json.name) Q result
	set itr = json.name.%GetIterator() 
	If itr.%GetNext(.key,.obj) {
		;w !,obj.%ToJSON(),!!
		set fam = obj.family
		set nam = ""
		set prefix = ""
		// И имя и префикс массивы. Выбираем все имена и префиксы или только первый?
		if $IsObject(obj.given) {
			set itr = obj.given.%GetIterator()
			s key=""
			If itr.%GetNext(.key,.val) {
				S nam = val
			}
		}
		if $IsObject(obj.prefix) {
			set itr = obj.prefix.%GetIterator()
			s key=""
			If itr.%GetNext(.key,.val) {
				S prefix = val
			}
		}
		Set result = fam_", "_nam
		if $g(prefix) '= "" {
			S result = result_", "_prefix
		}
	}
	Q result
}

}

