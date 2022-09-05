Class I2B2onFHIR.Messages.ExportPractitionerSearch2FhirRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter ENDPOINT = "Practitioner";

Property Identifier As %String(MAXLEN = "");

Property Given As %String(MAXLEN = "");

Property Family As %String(MAXLEN = "");

Property FileName As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "PractitionerSearch"}, SqlComputed, Transient ];

Storage Default
{
<Data name="ExportPractitionerSearch2FhirRequestDefaultData">
<Subscript>"ExportPractitionerSearch2FhirRequest"</Subscript>
<Value name="1">
<Value>Identifier</Value>
</Value>
<Value name="2">
<Value>Given</Value>
</Value>
<Value name="3">
<Value>Family</Value>
</Value>
</Data>
<DefaultData>ExportPractitionerSearch2FhirRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
