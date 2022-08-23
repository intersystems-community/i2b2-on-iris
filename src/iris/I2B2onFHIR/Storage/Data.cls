Class I2B2onFHIR.Storage.Data Extends %Persistent
{

/// DataType (patient, visit, etc)
Property type As %String(MAXLEN = "");

/// full file content
Property content As %String(MAXLEN = "");

Storage Default
{
<Data name="dataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>type</Value>
</Value>
<Value name="3">
<Value>content</Value>
</Value>
</Data>
<DataLocation>^I2B2onFHIR.Storage.dataD</DataLocation>
<DefaultData>dataDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^I2B2onFHIR.Storage.dataD</IdLocation>
<IndexLocation>^I2B2onFHIR.Storage.dataI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="content">
<AverageFieldSize>12</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="type">
<AverageFieldSize>12</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^I2B2onFHIR.Storage.dataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
