Class I2B2onFHIR.Messages.dataCreateResponse Extends Ens.Response
{

Property patientNum As %String;

Storage Default
{
<Data name="dataCreateResponseDefaultData">
<Subscript>"dataCreateResponse"</Subscript>
<Value name="1">
<Value>patientNum</Value>
</Value>
</Data>
<DefaultData>dataCreateResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
