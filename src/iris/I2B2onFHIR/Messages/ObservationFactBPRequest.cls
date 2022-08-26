Class I2B2onFHIR.Messages.ObservationFactBPRequest Extends Ens.Request [ ProcedureBlock ]
{

Property patientNum As %String(MAXLEN = "");

Storage Default
{
<Data name="ObservationFactBPRequestDefaultData">
<Subscript>"ObservationFactBPRequest"</Subscript>
<Value name="1">
<Value>patientNum</Value>
</Value>
</Data>
<DefaultData>ObservationFactBPRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
