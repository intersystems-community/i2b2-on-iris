Class I2B2onFHIR.Messages.ObservationFactItem Extends (%Persistent, %XML.Adaptor)
{

Property encounternum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2, SqlFieldName = encounter_num ];

Property patientnum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3, SqlFieldName = patient_num ];

Property conceptcd As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 4, SqlFieldName = concept_cd ];

Property providerid As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 5, SqlFieldName = provider_id ];

Property startdate As %Library.TimeStamp [ Required, SqlColumnNumber = 6, SqlFieldName = start_date ];

Property modifiercd As %Library.String(MAXLEN = 100) [ InitialExpression = "@", Required, SqlColumnNumber = 7, SqlFieldName = modifier_cd ];

Property instancenum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ InitialExpression = 1, Required, SqlColumnNumber = 8, SqlFieldName = instance_num ];

Property valtypecd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = valtype_cd ];

Property tvalchar As %Library.String(MAXLEN = 255) [ SqlColumnNumber = 10, SqlFieldName = tval_char ];

Property nvalnum As %Library.Numeric(MAXVAL = 9999999999999.99999, MINVAL = -9999999999999.99999, SCALE = 5) [ SqlColumnNumber = 11, SqlFieldName = nval_num ];

Property valueflagcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 12, SqlFieldName = valueflag_cd ];

Property quantitynum As %Library.Numeric(MAXVAL = 9999999999999.99999, MINVAL = -9999999999999.99999, SCALE = 5) [ SqlColumnNumber = 13, SqlFieldName = quantity_num ];

Property unitscd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 14, SqlFieldName = units_cd ];

Property enddate As %Library.TimeStamp [ SqlColumnNumber = 15, SqlFieldName = end_date ];

Property locationcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 16, SqlFieldName = location_cd ];

Property observationblob As %Library.String(MAXLEN = 2147483647) [ SqlColumnNumber = 17, SqlFieldName = observation_blob ];

Property confidencenum As %Library.Numeric(MAXVAL = 9999999999999.99999, MINVAL = -9999999999999.99999, SCALE = 5) [ SqlColumnNumber = 18, SqlFieldName = confidence_num ];

Property updatedate As %Library.TimeStamp [ SqlColumnNumber = 19, SqlFieldName = update_date ];

Property downloaddate As %Library.TimeStamp [ SqlColumnNumber = 20, SqlFieldName = download_date ];

Property importdate As %Library.TimeStamp [ SqlColumnNumber = 21, SqlFieldName = import_date ];

Property sourcesystemcd As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 22, SqlFieldName = sourcesystem_cd ];

Property uploadid As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23, SqlFieldName = upload_id ];

// deleted Required for presintation

Property textsearchindex As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ InitialExpression = "nextval('observation_fact_text_search_index_seq'::regclass)", SqlColumnNumber = 24, SqlFieldName = text_search_index ];

Storage Default
{
<Data name="ObservationFactItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>encounternum</Value>
</Value>
<Value name="3">
<Value>patientnum</Value>
</Value>
<Value name="4">
<Value>conceptcd</Value>
</Value>
<Value name="5">
<Value>providerid</Value>
</Value>
<Value name="6">
<Value>startdate</Value>
</Value>
<Value name="7">
<Value>modifiercd</Value>
</Value>
<Value name="8">
<Value>instancenum</Value>
</Value>
<Value name="9">
<Value>valtypecd</Value>
</Value>
<Value name="10">
<Value>tvalchar</Value>
</Value>
<Value name="11">
<Value>nvalnum</Value>
</Value>
<Value name="12">
<Value>valueflagcd</Value>
</Value>
<Value name="13">
<Value>quantitynum</Value>
</Value>
<Value name="14">
<Value>unitscd</Value>
</Value>
<Value name="15">
<Value>enddate</Value>
</Value>
<Value name="16">
<Value>locationcd</Value>
</Value>
<Value name="17">
<Value>observationblob</Value>
</Value>
<Value name="18">
<Value>confidencenum</Value>
</Value>
<Value name="19">
<Value>updatedate</Value>
</Value>
<Value name="20">
<Value>downloaddate</Value>
</Value>
<Value name="21">
<Value>importdate</Value>
</Value>
<Value name="22">
<Value>sourcesystemcd</Value>
</Value>
<Value name="23">
<Value>uploadid</Value>
</Value>
<Value name="24">
<Value>textsearchindex</Value>
</Value>
</Data>
<DataLocation>^I2B2onFHIRC600.ObservationE083D</DataLocation>
<DefaultData>ObservationFactItemDefaultData</DefaultData>
<IdLocation>^I2B2onFHIRC600.ObservationE083D</IdLocation>
<IndexLocation>^I2B2onFHIRC600.ObservationE083I</IndexLocation>
<StreamLocation>^I2B2onFHIRC600.ObservationE083S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
