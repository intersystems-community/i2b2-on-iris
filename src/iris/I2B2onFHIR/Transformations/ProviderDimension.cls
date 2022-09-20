Class I2B2onFHIR.Transformations.ProviderDimension Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.ProviderDimensionTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ProviderDimensionTransformResponse).%New()
        set target.downloaddate=..CurrentDT()
        set target.importdate=..CurrentDT()
        set target.namechar=..NameChar(source.json)
        set target.providerblob=""
        set target.providerid=..ProviderID(source.json)
        set target.providerpath=..ProviderPath(source.json)
        set target.sourcesystemcd=..SourceSystemCD(source.json)
        set target.updatedate=..CurrentDT()
        set target.uploadid=..UploadId(source.json)


	} catch e {
		s sc = e.AsStatus()

	}
	q sc
}

ClassMethod ProviderPath(json As %DynamicObject) As %String [ Private ]
{
	
	
	set classcode=$g(^TempSaveData("practitioner",json.id,"class.code"))
	
	
	S $p(result,"\",2)="i2b2"
	S $p(result,"\",3)="Providers"
	S $p(result,"\",4)=classcode ;Encounter.class.code -- Как получить здесь???
	S $p(result,"\",5)=..NameChar(json)
	S $p(result,"\",6)=""
	Q result
}

ClassMethod ProviderID(json As %DynamicObject) As %String [ Private ]
{
	Q "LCS-I2B2:D0001090"_..GenerateNum(json) ;$tr($now(),".,")
}

ClassMethod NameChar(json As %DynamicObject) As %Library.String [ Private ]
{
	s result=""
	I '$IsObject(json.name) Q result
	set itr = json.name.%GetIterator() 
	If itr.%GetNext(.key,.obj) {
		;w !,obj.%ToJSON(),!!
		set fam = obj.family
		set nam = ""
		set prefix = ""
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

