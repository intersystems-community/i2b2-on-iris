/// 
Class public.providerdimension Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = provider_dimension ]
{

Property providerid As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 2, SqlFieldName = provider_id ];

Property providerpath As %Library.String(MAXLEN = 700) [ Required, SqlColumnNumber = 3, SqlFieldName = provider_path ];

Property namechar As %Library.String(MAXLEN = 850) [ SqlColumnNumber = 4, SqlFieldName = name_char ];

Property providerblob As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 5, SqlFieldName = provider_blob ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 6, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 7, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 8, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10, SqlFieldName = upload_id ];

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

Index pdidxnamechar On (providerid, namechar) [ SqlName = pd_idx_name_char, Type = index ];

Index pdidxuploadid On uploadid [ SqlName = pd_idx_uploadid, Type = index ];

/// DDL Primary Key Specification
Index providerdimensionpk On (providerpath, providerid) [ PrimaryKey, SqlName = provider_dimension_pk, Type = index, Unique ];

Parameter USEEXTENTSET = 1;

Storage Default
{
<Data name="providerdimensionDefaultData">
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
<DataLocation>^B5ms.D9P9.1</DataLocation>
<DefaultData>providerdimensionDefaultData</DefaultData>
<ExtentLocation>^B5ms.D9P9</ExtentLocation>
<IdFunction>sequence</IdFunction>
<IdLocation>^B5ms.D9P9.1</IdLocation>
<Index name="DDLBEIndex">
<Location>^B5ms.D9P9.2</Location>
</Index>
<Index name="IDKEY">
<Location>^B5ms.D9P9.1</Location>
</Index>
<Index name="pdidxnamechar">
<Location>^B5ms.D9P9.4</Location>
</Index>
<Index name="pdidxuploadid">
<Location>^B5ms.D9P9.5</Location>
</Index>
<Index name="providerdimensionpk">
<Location>^B5ms.D9P9.3</Location>
</Index>
<IndexLocation>^B5ms.D9P9.I</IndexLocation>
<StreamLocation>^B5ms.D9P9.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
