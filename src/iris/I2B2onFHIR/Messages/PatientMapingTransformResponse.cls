/// error fixed         Extends Ens.Response -> Extends Ens.Request
Class I2B2onFHIR.Messages.PatientMapingTransformResponse Extends Ens.Request
{

Property patientide As %Library.String(MAXLEN = 200) [ Required, SqlColumnNumber = 2, SqlFieldName = patient_ide ];

Property patientidesource As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 3, SqlFieldName = patient_ide_source ];

Property patientnum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4, SqlFieldName = patient_num ];

Property patientidestatus As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 5, SqlFieldName = patient_ide_status ];

Property projectid As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 6, SqlFieldName = project_id ];

Property uploaddate As %Library.TimeStamp [ SqlColumnNumber = 7, SqlFieldName = upload_date ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 8, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 9, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 10, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 11, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12, SqlFieldName = upload_id ];

Storage Default
{
<Data name="PatientMapingTransformResponseDefaultData">
<Subscript>"PatientMapingTransformResponse"</Subscript>
<Value name="1">
<Value>patientide</Value>
</Value>
<Value name="2">
<Value>patientidesource</Value>
</Value>
<Value name="3">
<Value>patientnum</Value>
</Value>
<Value name="4">
<Value>patientidestatus</Value>
</Value>
<Value name="5">
<Value>projectid</Value>
</Value>
<Value name="6">
<Value>uploaddate</Value>
</Value>
<Value name="7">
<Value>updatedate</Value>
</Value>
<Value name="8">
<Value>downloaddate</Value>
</Value>
<Value name="9">
<Value>importdate</Value>
</Value>
<Value name="10">
<Value>sourcesystemcd</Value>
</Value>
<Value name="11">
<Value>uploadid</Value>
</Value>
</Data>
<DefaultData>PatientMapingTransformResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
