/// fixed       Extends Ens.Response -> Extends Ens.Request
Class I2B2onFHIR.Messages.EncounterMappingTransformResponse Extends Ens.Request
{

Property encounteride As %Library.String(MAXLEN = 200) [ Required, SqlColumnNumber = 2, SqlFieldName = encounter_ide ];

Property encounteridesource As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 3, SqlFieldName = encounter_ide_source ];

Property projectid As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 4, SqlFieldName = project_id ];

Property encounternum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5, SqlFieldName = encounter_num ];

Property patientide As %Library.String(MAXLEN = 200) [ Required, SqlColumnNumber = 6, SqlFieldName = patient_ide ];

Property patientidesource As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 7, SqlFieldName = patient_ide_source ];

Property encounteridestatus As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = encounter_ide_status ];

Property uploaddate As %Library.TimeStamp [ SqlColumnNumber = 9, SqlFieldName = upload_date ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 10, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 11, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 12, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 13, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14, SqlFieldName = upload_id ];

Storage Default
{
<Data name="EncounterMappingTransformResponseDefaultData">
<Subscript>"EncounterMappingTransformResponse"</Subscript>
<Value name="1">
<Value>encounteride</Value>
</Value>
<Value name="2">
<Value>encounteridesource</Value>
</Value>
<Value name="3">
<Value>projectid</Value>
</Value>
<Value name="4">
<Value>encounternum</Value>
</Value>
<Value name="5">
<Value>patientide</Value>
</Value>
<Value name="6">
<Value>patientidesource</Value>
</Value>
<Value name="7">
<Value>encounteridestatus</Value>
</Value>
<Value name="8">
<Value>uploaddate</Value>
</Value>
<Value name="9">
<Value>updatedate</Value>
</Value>
<Value name="10">
<Value>downloaddate</Value>
</Value>
<Value name="11">
<Value>importdate</Value>
</Value>
<Value name="12">
<Value>sourcesystemcd</Value>
</Value>
<Value name="13">
<Value>uploadid</Value>
</Value>
</Data>
<DefaultData>EncounterMappingTransformResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
