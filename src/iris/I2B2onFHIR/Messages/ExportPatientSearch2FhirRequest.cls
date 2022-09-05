Class I2B2onFHIR.Messages.ExportPatientSearch2FhirRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter ENDPOINT = "Patient";

Property Identifier As %String(MAXLEN = "");

Property BirthDate As %String(MAXLEN = "");

Property DeathDate As %String(MAXLEN = "");

Property Deceased As %String(MAXLEN = "");

Property AddressCountry As %String(MAXLEN = "");

Property AddressUse As %String(MAXLEN = "");

Property AddressState As %String(MAXLEN = "");

Property AddressCity As %String(MAXLEN = "");

Property AddressPostalcode As %String(MAXLEN = "");

Property Address As %String(MAXLEN = "");

Property Gender As %String(MAXLEN = "");

Property Given As %String(MAXLEN = "");

Property Family As %String(MAXLEN = "");

Property FileName As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "PatientSearch"}, SqlComputed, Transient ];

Storage Default
{
<Data name="ExportPatientSearch2FhirRequestDefaultData">
<Subscript>"ExportPatientSearch2FhirRequest"</Subscript>
<Value name="1">
<Value>Identifier</Value>
</Value>
<Value name="2">
<Value>BirthDate</Value>
</Value>
<Value name="3">
<Value>DeathDate</Value>
</Value>
<Value name="4">
<Value>Deceased</Value>
</Value>
<Value name="5">
<Value>AddressCountry</Value>
</Value>
<Value name="6">
<Value>AddressUse</Value>
</Value>
<Value name="7">
<Value>AddressState</Value>
</Value>
<Value name="8">
<Value>AddressCity</Value>
</Value>
<Value name="9">
<Value>AddressPostalcode</Value>
</Value>
<Value name="10">
<Value>Address</Value>
</Value>
<Value name="11">
<Value>Gender</Value>
</Value>
<Value name="12">
<Value>Given</Value>
</Value>
<Value name="13">
<Value>Family</Value>
</Value>
</Data>
<DefaultData>ExportPatientSearch2FhirRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
