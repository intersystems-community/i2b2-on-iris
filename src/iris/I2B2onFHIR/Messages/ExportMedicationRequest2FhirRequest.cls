Class I2B2onFHIR.Messages.ExportMedicationRequest2FhirRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter ENDPOINT = "MedicationRequest";

Property Identifier As %String(MAXLEN = "");

Property FileName As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "MedicationRequest-"_{Identifier}}, SqlComputed, Transient ];

Storage Default
{
<Data name="ExportMedicationRequest2FhirRequestDefaultData">
<Subscript>"ExportMedicationRequest2FhirRequest"</Subscript>
<Value name="1">
<Value>Identifier</Value>
</Value>
</Data>
<DefaultData>ExportMedicationRequest2FhirRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
