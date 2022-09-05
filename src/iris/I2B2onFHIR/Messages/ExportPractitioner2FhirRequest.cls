Class I2B2onFHIR.Messages.ExportPractitioner2FhirRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter ENDPOINT = "Practitioner";

Property Identifier As %String(MAXLEN = "");

Property FileName As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "Practitioner-"_{Identifier}}, SqlComputed, Transient ];

Storage Default
{
<Data name="ExportPractitioner2FhirRequestDefaultData">
<Subscript>"ExportPractitioner2FhirRequest"</Subscript>
<Value name="1">
<Value>Identifier</Value>
</Value>
</Data>
<DefaultData>ExportPractitioner2FhirRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
