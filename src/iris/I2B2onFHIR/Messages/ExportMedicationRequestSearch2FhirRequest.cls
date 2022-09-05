Class I2B2onFHIR.Messages.ExportMedicationRequestSearch2FhirRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter ENDPOINT = "MedicationRequest";

Property Identifier As %String(MAXLEN = "");

Property FileName As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "MedicationRequestSearch"}, SqlComputed, Transient ];

Storage Default
{
<Data name="ExportMedicationRequestSearch2FhirRequestDefaultData">
<Subscript>"ExportMedicationRequestSearch2FhirRequest"</Subscript>
<Value name="1">
<Value>Identifier</Value>
</Value>
</Data>
<DefaultData>ExportMedicationRequestSearch2FhirRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
