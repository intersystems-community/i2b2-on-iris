/// fixed       Extends Ens.Response -> Extends Ens.Request
Class I2B2onFHIR.Messages.PatientDimensionTransformResponse Extends Ens.Request
{

Property patientnum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2, SqlFieldName = patient_num ];

Property vitalstatuscd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 3, SqlFieldName = vital_status_cd ];

Property birthdate As %Library.TimeStamp [ SqlColumnNumber = 4, SqlFieldName = birth_date ];

Property deathdate As %Library.TimeStamp [ SqlColumnNumber = 5, SqlFieldName = death_date ];

Property sexcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 6, SqlFieldName = sex_cd ];

Property ageinyearsnum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7, SqlFieldName = age_in_years_num ];

Property languagecd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = language_cd ];

Property racecd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = race_cd ];

Property maritalstatuscd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 10, SqlFieldName = marital_status_cd ];

Property religioncd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 11, SqlFieldName = religion_cd ];

Property zipcd As %Library.String(MAXLEN = 10) [ SqlColumnNumber = 12, SqlFieldName = zip_cd ];

Property statecityzippath As %Library.String(MAXLEN = 700) [ SqlColumnNumber = 13, SqlFieldName = statecityzip_path ];

Property incomecd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 14, SqlFieldName = income_cd ];

Property patientblob As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 15, SqlFieldName = patient_blob ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 16, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 17, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 18, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 19, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20, SqlFieldName = upload_id ];

Storage Default
{
<Data name="PatientDimensionTransformResponseDefaultData">
<Subscript>"PatientDimensionTransformResponse"</Subscript>
<Value name="1">
<Value>patientnum</Value>
</Value>
<Value name="2">
<Value>vitalstatuscd</Value>
</Value>
<Value name="3">
<Value>birthdate</Value>
</Value>
<Value name="4">
<Value>deathdate</Value>
</Value>
<Value name="5">
<Value>sexcd</Value>
</Value>
<Value name="6">
<Value>ageinyearsnum</Value>
</Value>
<Value name="7">
<Value>languagecd</Value>
</Value>
<Value name="8">
<Value>racecd</Value>
</Value>
<Value name="9">
<Value>maritalstatuscd</Value>
</Value>
<Value name="10">
<Value>religioncd</Value>
</Value>
<Value name="11">
<Value>zipcd</Value>
</Value>
<Value name="12">
<Value>statecityzippath</Value>
</Value>
<Value name="13">
<Value>incomecd</Value>
</Value>
<Value name="14">
<Value>patientblob</Value>
</Value>
<Value name="15">
<Value>updatedate</Value>
</Value>
<Value name="16">
<Value>downloaddate</Value>
</Value>
<Value name="17">
<Value>importdate</Value>
</Value>
<Value name="18">
<Value>sourcesystemcd</Value>
</Value>
<Value name="19">
<Value>uploadid</Value>
</Value>
</Data>
<DefaultData>patientDataTransformResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
