Class I2B2.HS.FHIRServer.Storage.Json.SearchColumn Extends (HS.FHIRServer.Storage.Json.SearchColumn, %XML.Adaptor)
{

Property Join As %String(MAXLEN = "");

Storage Default
{
<Data name="SearchColumnDefaultData1">
<Subscript>"SearchColumn"</Subscript>
<Value name="1">
<Value>Join</Value>
</Value>
</Data>
<DefaultData>SearchColumnDefaultData1</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
