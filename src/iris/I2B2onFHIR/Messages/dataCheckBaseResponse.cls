Class I2B2onFHIR.Messages.dataCheckBaseResponse Extends Ens.Response
{

Property recordId As %Library.Integer;

Storage Default
{
<Data name="dataCheckBaseResponseDefaultData">
<Subscript>"dataCheckBaseResponse"</Subscript>
<Value name="1">
<Value>recordExists</Value>
</Value>
<Value name="2">
<Value>recordId</Value>
</Value>
</Data>
<DefaultData>dataCheckBaseResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
