Class I2B2onFHIR.Storage.Ids Extends %Persistent
{

/// resourceName (patient, encounter, etc)
Property resourceName As %String(MAXLEN = "");

/// FHIR ID (34564f01-09ac-479c-9df5-1028bbe54e7b)
Property fhirId As %String(MAXLEN = "");

/// I2B2 ID (1,2,3,...)
Property i2b2Id As %String(MAXLEN = "");

/// Property i2b2Link As %String;
Storage Default
{
<Data name="IdsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>resourceName</Value>
</Value>
<Value name="3">
<Value>fhirId</Value>
</Value>
<Value name="4">
<Value>i2b2Id</Value>
</Value>
<Value name="5">
<Value>i2b2Link</Value>
</Value>
</Data>
<DataLocation>^I2B2onFHIR.Storage.IdsD</DataLocation>
<DefaultData>IdsDefaultData</DefaultData>
<Description>
<![CDATA[Property i2b2Link As %String;]]></Description>
<ExtentSize>0</ExtentSize>
<IdLocation>^I2B2onFHIR.Storage.IdsD</IdLocation>
<IndexLocation>^I2B2onFHIR.Storage.IdsI</IndexLocation>
<StreamLocation>^I2B2onFHIR.Storage.IdsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
