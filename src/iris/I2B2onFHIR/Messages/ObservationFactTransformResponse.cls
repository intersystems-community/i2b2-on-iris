/// fixed       Extends Ens.Response -> Extends Ens.Request
Class I2B2onFHIR.Messages.ObservationFactTransformResponse Extends Ens.Request
{

Property data As list Of I2B2onFHIR.Messages.ObservationFactItem;

Storage Default
{
<Data name="ObservationFactTransformResponseDefaultData">
<Subscript>"ObservationFactTransformResponse"</Subscript>
<Value name="1">
<Value>data</Value>
</Value>
</Data>
<DefaultData>ObservationFactTransformResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
