/// 
Class public.conceptdimension Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = concept_dimension ]
{

Property conceptpath As %Library.String(MAXLEN = 700) [ Required, SqlColumnNumber = 2, SqlFieldName = concept_path ];

Property conceptcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 3, SqlFieldName = concept_cd ];

Property namechar As %Library.String(MAXLEN = 2000) [ SqlColumnNumber = 4, SqlFieldName = name_char ];

Property conceptblob As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 5, SqlFieldName = concept_blob ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 6, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 7, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 8, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10, SqlFieldName = upload_id ];

Parameter USEEXTENTSET = 1;

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

Index cdidxuploadid On uploadid [ SqlName = cd_idx_uploadid, Type = index ];

/// DDL Primary Key Specification
Index conceptdimensionpk On conceptpath [ PrimaryKey, SqlName = concept_dimension_pk, Type = index, Unique ];

Index indconceptcd On conceptcd;

Index inamechar On namechar;

Storage Default
{
<Data name="conceptdimensionDefaultData">
<Value name="1">
<Value>conceptpath</Value>
</Value>
<Value name="2">
<Value>conceptcd</Value>
</Value>
<Value name="3">
<Value>namechar</Value>
</Value>
<Value name="4">
<Value>conceptblob</Value>
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
<DataLocation>^B5ms.COqR.1</DataLocation>
<DefaultData>conceptdimensionDefaultData</DefaultData>
<ExtentLocation>^B5ms.COqR</ExtentLocation>
<IdFunction>sequence</IdFunction>
<IdLocation>^B5ms.COqR.1</IdLocation>
<Index name="DDLBEIndex">
<Location>^B5ms.COqR.2</Location>
</Index>
<Index name="IDKEY">
<Location>^B5ms.COqR.1</Location>
</Index>
<Index name="cdidxuploadid">
<Location>^B5ms.COqR.4</Location>
</Index>
<Index name="conceptdimensionpk">
<Location>^B5ms.COqR.3</Location>
</Index>
<Index name="iConceptpath">
<Location>^B5ms.COqR.7</Location>
</Index>
<Index name="inamechar">
<Location>^B5ms.COqR.8</Location>
</Index>
<Index name="indconceptcd">
<Location>^B5ms.COqR.5</Location>
</Index>
<Index name="indconceptcdft">
<Location>^B5ms.COqR.6</Location>
</Index>
<IndexLocation>^B5ms.COqR.I</IndexLocation>
<StreamLocation>^B5ms.COqR.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
