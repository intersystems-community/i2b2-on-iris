Class I2B2onFHIR.Messages.providerDataTransformResponse Extends Ens.Response
{

/// ??? UNUSED ???
Property providerid As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 2, SqlFieldName = provider_id ];

Property providerpath As %Library.String(MAXLEN = 700) [ Required, SqlColumnNumber = 3, SqlFieldName = provider_path ];

Property namechar As %Library.String(MAXLEN = 850) [ SqlColumnNumber = 4, SqlFieldName = name_char ];

Property providerblob As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 5, SqlFieldName = provider_blob ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 6, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 7, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 8, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10, SqlFieldName = upload_id ];

Storage Default
{
<Data name="providerDataTransformResponseDefaultData">
<Subscript>"providerDataTransformResponse"</Subscript>
<Value name="1">
<Value>providerid</Value>
</Value>
<Value name="2">
<Value>providerpath</Value>
</Value>
<Value name="3">
<Value>namechar</Value>
</Value>
<Value name="4">
<Value>providerblob</Value>
</Value>
<Value name="5">
<Value>updatedate</Value>
</Value>
<Value name="6">
<Value>downloaddate</Value>
</Value>
<Value name="7">
<Value>importdate</Value>
</Value>
<Value name="8">
<Value>sourcesystemcd</Value>
</Value>
<Value name="9">
<Value>uploadid</Value>
</Value>
</Data>
<DefaultData>providerDataTransformResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
