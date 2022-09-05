Class I2B2onFHIR.Messages.ExportPatient2FhirRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter ENDPOINT = "Patient";

Property Identifier As %String(MAXLEN = "");

Property FileName As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "Patient-"_{Identifier}}, SqlComputed, Transient ];

Storage Default
{
<Data name="ExportPatient2FhirRequestDefaultData">
<Subscript>"ExportPatient2FhirRequest"</Subscript>
<Value name="1">
<Value>Identifier</Value>
</Value>
</Data>
<DefaultData>ExportPatient2FhirRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
