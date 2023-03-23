Class I2B2onFHIR.Storage.IdsLinks Extends %Persistent
{

/// id from I2B2onFHIR.Storage.Ids table
Property idsId As %String(MAXLEN = "");

/// Name of the table (patient_dimension, patient_mapping, encounter_mapping, etc)
Property tableName As %String(MAXLEN = "");

/// list with PK from table to link to the particular row
Property i2b2Link As %String(MAXLEN = "");

Index i2b2LinkIndex On i2b2Link;

Storage Default
{
<Data name="IdsLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>idsId</Value>
</Value>
<Value name="3">
<Value>tableName</Value>
</Value>
<Value name="4">
<Value>i2b2Link</Value>
</Value>
</Data>
<DataLocation>^I2B2onFHIR.Storage.IdsLinksD</DataLocation>
<DefaultData>IdsLinksDefaultData</DefaultData>
<ExtentSize>0</ExtentSize>
<IdLocation>^I2B2onFHIR.Storage.IdsLinksD</IdLocation>
<IndexLocation>^I2B2onFHIR.Storage.IdsLinksI</IndexLocation>
<StreamLocation>^I2B2onFHIR.Storage.IdsLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
