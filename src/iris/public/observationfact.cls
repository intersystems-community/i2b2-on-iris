/// 
Class public.observationfact Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = observation_fact ]
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

Parameter USEEXTENTSET = 1;

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

/// DDL Primary Key Specification
Index observationfactpk On (patientnum, conceptcd, modifiercd, startdate, encounternum, instancenum, providerid) [ PrimaryKey, SqlName = observation_fact_pk, Type = index, Unique ];

Index ofidxallobservationfact On (patientnum, encounternum, conceptcd, startdate, providerid, modifiercd, instancenum, valtypecd, tvalchar, nvalnum, valueflagcd, quantitynum, unitscd, enddate, locationcd, confidencenum) [ SqlName = of_idx_allobservation_fact, Type = index ];

Index ofidxclusteredconcept On conceptcd [ SqlName = of_idx_clusteredconcept, Type = index ];

Index ofidxencounterpatient On (encounternum, patientnum, instancenum) [ SqlName = of_idx_encounter_patient, Type = index ];

Index ofidxmodifier On modifiercd [ SqlName = of_idx_modifier, Type = index ];

Index ofidxsourcesystemcd On sourcesystemcd [ SqlName = of_idx_sourcesystem_cd, Type = index ];

Index ofidxstartdate On (startdate, patientnum) [ SqlName = of_idx_start_date, Type = index ];

Index ofidxuploadid On uploadid [ SqlName = of_idx_uploadid, Type = index ];

Index oftextsearchunique On textsearchindex [ SqlName = of_text_search_unique, Type = index, Unique ];

Index indpatientnum On patientnum;

Index iconceptcdpn On (conceptcd, patientnum);

Storage Default
{
<Data name="observationfactDefaultData">
<Value name="1">
<Value>encounternum</Value>
</Value>
<Value name="2">
<Value>patientnum</Value>
</Value>
<Value name="3">
<Value>conceptcd</Value>
</Value>
<Value name="4">
<Value>providerid</Value>
</Value>
<Value name="5">
<Value>startdate</Value>
</Value>
<Value name="6">
<Value>modifiercd</Value>
</Value>
<Value name="7">
<Value>instancenum</Value>
</Value>
<Value name="8">
<Value>valtypecd</Value>
</Value>
<Value name="9">
<Value>tvalchar</Value>
</Value>
<Value name="10">
<Value>nvalnum</Value>
</Value>
<Value name="11">
<Value>valueflagcd</Value>
</Value>
<Value name="12">
<Value>quantitynum</Value>
</Value>
<Value name="13">
<Value>unitscd</Value>
</Value>
<Value name="14">
<Value>enddate</Value>
</Value>
<Value name="15">
<Value>locationcd</Value>
</Value>
<Value name="16">
<Value>observationblob</Value>
</Value>
<Value name="17">
<Value>confidencenum</Value>
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
<Value>uploadid</Value>
</Value>
<Value name="23">
<Value>textsearchindex</Value>
</Value>
</Data>
<DataLocation>^B5ms.D7Uy.1</DataLocation>
<DefaultData>observationfactDefaultData</DefaultData>
<ExtentLocation>^B5ms.D7Uy</ExtentLocation>
<IdFunction>sequence</IdFunction>
<IdLocation>^B5ms.D7Uy.1</IdLocation>
<Index name="DDLBEIndex">
<Location>^B5ms.D7Uy.2</Location>
</Index>
<Index name="IDKEY">
<Location>^B5ms.D7Uy.1</Location>
</Index>
<Index name="iconceptcdpn">
<Location>^B5ms.D7Uy.13</Location>
</Index>
<Index name="indpatientnum">
<Location>^B5ms.D7Uy.12</Location>
</Index>
<Index name="ipatientnum">
<Location>^B5ms.D7Uy.14</Location>
</Index>
<Index name="observationfactpk">
<Location>^B5ms.D7Uy.3</Location>
</Index>
<Index name="ofidxallobservationfact">
<Location>^B5ms.D7Uy.4</Location>
</Index>
<Index name="ofidxclusteredconcept">
<Location>^B5ms.D7Uy.5</Location>
</Index>
<Index name="ofidxencounterpatient">
<Location>^B5ms.D7Uy.6</Location>
</Index>
<Index name="ofidxmodifier">
<Location>^B5ms.D7Uy.7</Location>
</Index>
<Index name="ofidxsourcesystemcd">
<Location>^B5ms.D7Uy.8</Location>
</Index>
<Index name="ofidxstartdate">
<Location>^B5ms.D7Uy.9</Location>
</Index>
<Index name="ofidxuploadid">
<Location>^B5ms.D7Uy.10</Location>
</Index>
<Index name="oftextsearchunique">
<Location>^B5ms.D7Uy.11</Location>
</Index>
<IndexLocation>^B5ms.D7Uy.I</IndexLocation>
<StreamLocation>^B5ms.D7Uy.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

