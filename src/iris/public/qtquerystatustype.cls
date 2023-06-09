/// 
Class public.qtquerystatustype Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = qt_query_status_type ]
{

Property statustypeid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2, SqlFieldName = status_type_id ];

Property name As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 3 ];

Property description As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

/// DDL Primary Key Specification
Index qtquerystatustypepkey On statustypeid [ PrimaryKey, SqlName = qt_query_status_type_pkey, Type = index, Unique ];

Parameter USEEXTENTSET = 1;

Storage Default
{
<Data name="qtquerystatustypeDefaultData">
<Value name="1">
<Value>statustypeid</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>description</Value>
</Value>
</Data>
<DataLocation>^B5ms.BVTS.1</DataLocation>
<DefaultData>qtquerystatustypeDefaultData</DefaultData>
<ExtentLocation>^B5ms.BVTS</ExtentLocation>
<IdFunction>sequence</IdFunction>
<IdLocation>^B5ms.BVTS.1</IdLocation>
<Index name="DDLBEIndex">
<Location>^B5ms.BVTS.2</Location>
</Index>
<Index name="IDKEY">
<Location>^B5ms.BVTS.1</Location>
</Index>
<Index name="qtquerystatustypepkey">
<Location>^B5ms.BVTS.3</Location>
</Index>
<IndexLocation>^B5ms.BVTS.I</IndexLocation>
<StreamLocation>^B5ms.BVTS.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
