/// 
Class public.setuploadstatus Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = set_upload_status ]
{

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2, SqlFieldName = upload_id ];

Property settypeid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3, SqlFieldName = set_type_id ];

Property sourcecd As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 4, SqlFieldName = source_cd ];

Property noofrecord As %Library.BigInt [ SqlColumnNumber = 5, SqlFieldName = no_of_record ];

Property loadedrecord As %Library.BigInt [ SqlColumnNumber = 6, SqlFieldName = loaded_record ];

Property deletedrecord As %Library.BigInt [ SqlColumnNumber = 7, SqlFieldName = deleted_record ];

Property loaddate As %Library.TimeStamp [ Required, SqlColumnNumber = 8, SqlFieldName = load_date ];

Property enddate As %Library.TimeStamp [ SqlColumnNumber = 9, SqlFieldName = end_date ];

Property loadstatus As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 10, SqlFieldName = load_status ];

Property message As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 11 ];

Property inputfilename As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 12, SqlFieldName = input_file_name ];

Property logfilename As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 13, SqlFieldName = log_file_name ];

Property transformname As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 14, SqlFieldName = transform_name ];

/// Foreign Key fkupsettypeid created via DDL
ForeignKey fkupsettypeid(settypeid) References public.settype(pkstid) [ SqlName = fk_up_set_type_id ];

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

/// DDL Primary Key Specification
Index pkupupstatusidsettypeid On (uploadid, settypeid) [ PrimaryKey, SqlName = pk_up_upstatus_idsettypeid, Type = index, Unique ];

Parameter USEEXTENTSET = 1;

Storage Default
{
<Data name="setuploadstatusDefaultData">
<Value name="1">
<Value>uploadid</Value>
</Value>
<Value name="2">
<Value>settypeid</Value>
</Value>
<Value name="3">
<Value>sourcecd</Value>
</Value>
<Value name="4">
<Value>noofrecord</Value>
</Value>
<Value name="5">
<Value>loadedrecord</Value>
</Value>
<Value name="6">
<Value>deletedrecord</Value>
</Value>
<Value name="7">
<Value>loaddate</Value>
</Value>
<Value name="8">
<Value>enddate</Value>
</Value>
<Value name="9">
<Value>loadstatus</Value>
</Value>
<Value name="10">
<Value>message</Value>
</Value>
<Value name="11">
<Value>inputfilename</Value>
</Value>
<Value name="12">
<Value>logfilename</Value>
</Value>
<Value name="13">
<Value>transformname</Value>
</Value>
</Data>
<DataLocation>^B5ms.Jns4.1</DataLocation>
<DefaultData>setuploadstatusDefaultData</DefaultData>
<ExtentLocation>^B5ms.Jns4</ExtentLocation>
<IdFunction>sequence</IdFunction>
<IdLocation>^B5ms.Jns4.1</IdLocation>
<Index name="DDLBEIndex">
<Location>^B5ms.Jns4.2</Location>
</Index>
<Index name="IDKEY">
<Location>^B5ms.Jns4.1</Location>
</Index>
<Index name="pkupupstatusidsettypeid">
<Location>^B5ms.Jns4.3</Location>
</Index>
<IndexLocation>^B5ms.Jns4.I</IndexLocation>
<StreamLocation>^B5ms.Jns4.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
