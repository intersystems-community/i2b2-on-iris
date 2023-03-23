Class I2B2onFHIR.Messages.conceptDataTransformResponse Extends Ens.Response
{

Property namechar As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 2, SqlFieldName = name_char ];

Property conceptcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 3, SqlFieldName = concept_cd ];

Property conceptpath As %Library.String(MAXLEN = 700) [ SqlColumnNumber = 4, SqlFieldName = concept_path ];

Property conceptblob As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 5, SqlFieldName = concept_blob ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 6, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 7, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 8, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16, SqlFieldName = upload_id ];

Storage Default
{
<Data name="conceptDataTransformResponseDefaultData">
<Subscript>"conceptDataTransformResponse"</Subscript>
<Value name="1">
<Value>encounternum</Value>
</Value>
<Value name="2">
<Value>patientnum</Value>
</Value>
<Value name="3">
<Value>activestatuscd</Value>
</Value>
<Value name="4">
<Value>startdate</Value>
</Value>
<Value name="5">
<Value>enddate</Value>
</Value>
<Value name="6">
<Value>inoutcd</Value>
</Value>
<Value name="7">
<Value>locationcd</Value>
</Value>
<Value name="8">
<Value>locationpath</Value>
</Value>
<Value name="9">
<Value>lengthofstay</Value>
</Value>
<Value name="10">
<Value>visitblob</Value>
</Value>
<Value name="11">
<Value>updatedate</Value>
</Value>
<Value name="12">
<Value>downloaddate</Value>
</Value>
<Value name="13">
<Value>importdate</Value>
</Value>
<Value name="14">
<Value>sourcesystemcd</Value>
</Value>
<Value name="15">
<Value>uploadid</Value>
</Value>
<Value name="16">
<Value>conceptcd</Value>
</Value>
<Value name="17">
<Value>conceptpath</Value>
</Value>
<Value name="18">
<Value>conceptblob</Value>
</Value>
<Value name="19">
<Value>namechar</Value>
</Value>
</Data>
<DefaultData>conceptDataTransformResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
