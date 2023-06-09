/// 
Class public.i2b2 Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = i2b2 ]
{

Property chlevel As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2, SqlFieldName = c_hlevel ];

Property cfullname As %Library.String(MAXLEN = 700) [ Required, SqlColumnNumber = 3, SqlFieldName = c_fullname ];

Property cname As %Library.String(MAXLEN = 2000) [ Required, SqlColumnNumber = 4, SqlFieldName = c_name ];

Property csynonymcd As %Library.String(MAXLEN = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = c_synonym_cd ];

Property cvisualattributes As %Library.String(MAXLEN = 3) [ Required, SqlColumnNumber = 6, SqlFieldName = c_visualattributes ];

Property ctotalnum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7, SqlFieldName = c_totalnum ];

Property cbasecode As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = c_basecode ];

Property cmetadataxml As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 9, SqlFieldName = c_metadataxml ];

Property cfacttablecolumn As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 10, SqlFieldName = c_facttablecolumn ];

Property ctablename As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 11, SqlFieldName = c_tablename ];

Property ccolumnname As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 12, SqlFieldName = c_columnname ];

Property ccolumndatatype As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 13, SqlFieldName = c_columndatatype ];

Property coperator As %Library.String(MAXLEN = 10) [ Required, SqlColumnNumber = 14, SqlFieldName = c_operator ];

Property cdimcode As %Library.String(MAXLEN = 700) [ Required, SqlColumnNumber = 15, SqlFieldName = c_dimcode ];

Property ccomment As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 16, SqlFieldName = c_comment ];

Property ctooltip As %Library.String(MAXLEN = 900) [ SqlColumnNumber = 17, SqlFieldName = c_tooltip ];

Property mappliedpath As %Library.String(MAXLEN = 700) [ Required, SqlColumnNumber = 18, SqlFieldName = m_applied_path ];

Property updatedate As %Library.TimeStamp [ Required, SqlColumnNumber = 19, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 20, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 21, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 22, SqlFieldName = sourcesystem_cd ];

Property valuetypecd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 23, SqlFieldName = valuetype_cd ];

Property mexclusioncd As %Library.String(MAXLEN = 25) [ SqlColumnNumber = 24, SqlFieldName = m_exclusion_cd ];

Property cpath As %Library.String(MAXLEN = 700) [ SqlColumnNumber = 25, SqlFieldName = c_path ];

Property csymbol As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 26, SqlFieldName = c_symbol ];

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

Index metaappliedpathidxi2b2 On mappliedpath [ SqlName = meta_applied_path_idx_i2b2, Type = index ];

Index metaexclusionidxi2b2 On mexclusioncd [ SqlName = meta_exclusion_idx_i2b2, Type = index ];

Index metafullnameidxi2b2 On cfullname [ SqlName = meta_fullname_idx_i2b2, Type = index ];

Index metahlevelidxi2b2 On chlevel [ SqlName = meta_hlevel_idx_i2b2, Type = index ];

Index metasynonymidxi2b2 On csynonymcd [ SqlName = meta_synonym_idx_i2b2, Type = index ];

Parameter USEEXTENTSET = 1;

Storage Default
{
<Data name="i2b2DefaultData">
<Value name="1">
<Value>chlevel</Value>
</Value>
<Value name="2">
<Value>cfullname</Value>
</Value>
<Value name="3">
<Value>cname</Value>
</Value>
<Value name="4">
<Value>csynonymcd</Value>
</Value>
<Value name="5">
<Value>cvisualattributes</Value>
</Value>
<Value name="6">
<Value>ctotalnum</Value>
</Value>
<Value name="7">
<Value>cbasecode</Value>
</Value>
<Value name="8">
<Value>cmetadataxml</Value>
</Value>
<Value name="9">
<Value>cfacttablecolumn</Value>
</Value>
<Value name="10">
<Value>ctablename</Value>
</Value>
<Value name="11">
<Value>ccolumnname</Value>
</Value>
<Value name="12">
<Value>ccolumndatatype</Value>
</Value>
<Value name="13">
<Value>coperator</Value>
</Value>
<Value name="14">
<Value>cdimcode</Value>
</Value>
<Value name="15">
<Value>ccomment</Value>
</Value>
<Value name="16">
<Value>ctooltip</Value>
</Value>
<Value name="17">
<Value>mappliedpath</Value>
</Value>
<Value name="18">
<Value>updatedate</Value>
</Value>
<Value name="19">
<Value>downloaddate</Value>
</Value>
<Value name="20">
<Value>importdate</Value>
</Value>
<Value name="21">
<Value>sourcesystemcd</Value>
</Value>
<Value name="22">
<Value>valuetypecd</Value>
</Value>
<Value name="23">
<Value>mexclusioncd</Value>
</Value>
<Value name="24">
<Value>cpath</Value>
</Value>
<Value name="25">
<Value>csymbol</Value>
</Value>
</Data>
<DataLocation>^B5ms.E5sH.1</DataLocation>
<DefaultData>i2b2DefaultData</DefaultData>
<ExtentLocation>^B5ms.E5sH</ExtentLocation>
<IdFunction>sequence</IdFunction>
<IdLocation>^B5ms.E5sH.1</IdLocation>
<Index name="DDLBEIndex">
<Location>^B5ms.E5sH.2</Location>
</Index>
<Index name="IDKEY">
<Location>^B5ms.E5sH.1</Location>
</Index>
<Index name="metaappliedpathidxi2b2">
<Location>^B5ms.E5sH.3</Location>
</Index>
<Index name="metaexclusionidxi2b2">
<Location>^B5ms.E5sH.4</Location>
</Index>
<Index name="metafullnameidxi2b2">
<Location>^B5ms.E5sH.5</Location>
</Index>
<Index name="metahlevelidxi2b2">
<Location>^B5ms.E5sH.6</Location>
</Index>
<Index name="metasynonymidxi2b2">
<Location>^B5ms.E5sH.7</Location>
</Index>
<IndexLocation>^B5ms.E5sH.I</IndexLocation>
<StreamLocation>^B5ms.E5sH.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
