/// fixed       Extends Ens.Response -> Extends Ens.Request
Class I2B2onFHIR.Messages.VisitDimensionTransformResponse Extends Ens.Request
{

Property encounternum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2, SqlFieldName = encounter_num ];

Property patientnum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3, SqlFieldName = patient_num ];

Property activestatuscd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = active_status_cd ];

Property startdate As %Library.TimeStamp [ SqlColumnNumber = 5, SqlFieldName = start_date ];

Property enddate As %Library.TimeStamp [ SqlColumnNumber = 6, SqlFieldName = end_date ];

Property inoutcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 7, SqlFieldName = inout_cd ];

Property locationcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = location_cd ];

Property locationpath As %Library.String(MAXLEN = 700) [ SqlColumnNumber = 9, SqlFieldName = location_path ];

Property lengthofstay As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10, SqlFieldName = length_of_stay ];

Property visitblob As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 11, SqlFieldName = visit_blob ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 12, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 13, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 14, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 15, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16, SqlFieldName = upload_id ];

Storage Default
{
<Data name="VisitDimensionTransformResponseDefaultData">
<Subscript>"VisitDimensionTransformResponse"</Subscript>
<Value name="1">
<Value>patientnum</Value>
</Value>
<Value name="2">
<Value>encounternum</Value>
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
</Data>
<DefaultData>VisitDimensionTransformResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
