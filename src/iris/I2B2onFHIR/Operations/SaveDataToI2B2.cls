Class I2B2onFHIR.Operations.SaveDataToI2B2 Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method providerDimensionSave(pRequest As I2B2onFHIR.Messages.ProviderDimensionTransformResponse, Output pResponse As Ens.Response)
{
    s sc = $$$OK
    try {
        #dim rs As EnsLib.SQL.GatewayResultSet

        s sql = "INSERT INTO ""public"".""provider_dimension"" (provider_id, provider_path, name_char, "_
                "provider_blob, update_date, download_date, import_date, sourcesystem_cd, upload_id) "_
                "VALUES (?,?,?,?,?,?,?,?,?)"
		

		set rs=##class(%ResultSet).%New()
		Set sc=rs.Prepare(sql)
		quit:$$$ISERR(sc)

		set sc=rs.Execute(pRequest.providerid, pRequest.providerpath, pRequest.namechar, pRequest.providerblob, pRequest.updatedate,
                      pRequest.updatedate, pRequest.downloaddate, pRequest.importdate, pRequest.sourcesystemcd, pRequest.uploadid)
		quit:$$$ISERR(sc)


	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method visitDimensionSave(pRequest As I2B2onFHIR.Messages.VisitDimensionTransformResponse, Output pResponse As Ens.Response)
{
    s sc = $$$OK
    try {
        #dim rs As EnsLib.SQL.GatewayResultSet

        s sql = "INSERT INTO ""public"".""visit_dimension"" (encounter_num, patient_num, active_status_cd, start_date, "_
                "end_date, inout_cd, location_cd, location_path, length_of_stay, visit_blob, update_date, download_date, "_
                "import_date, sourcesystem_cd, upload_id) "_
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
		

		set rs=##class(%ResultSet).%New()
		Set sc=rs.Prepare(sql)
		quit:$$$ISERR(sc)

		set sc=rs.Execute(pRequest.encounternum, pRequest.patientnum, pRequest.activestatuscd, pRequest.startdate, pRequest.enddate,
                      pRequest.inoutcd, pRequest.locationcd, pRequest.locationpath, pRequest.lengthofstay, pRequest.visitblob, pRequest.updatedate,
                      pRequest.downloaddate, pRequest.importdate, pRequest.sourcesystemcd, pRequest.uploadid)
		quit:$$$ISERR(sc)


	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method encounterMappingSave(pRequest As I2B2onFHIR.Messages.EncounterMappingTransformResponse, Output pResponse As Ens.Response)
{
    s sc = $$$OK
    try {
        #dim rs As EnsLib.SQL.GatewayResultSet

        s sql = "INSERT INTO ""public"".""encounter_mapping"" (encounter_ide, encounter_ide_source, project_id, "_
                "encounter_num, patient_ide, patient_ide_source, encounter_ide_status, upload_date, update_date, download_date, "_
                "import_date, sourcesystem_cd, upload_id) "_
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
		

		set rs=##class(%ResultSet).%New()
		Set sc=rs.Prepare(sql)
		quit:$$$ISERR(sc)

		set sc=rs.Execute(pRequest.encounteride, pRequest.encounteridesource, pRequest.projectid, pRequest.encounternum, pRequest.patientide,
                      pRequest.patientidesource, pRequest.encounteridesource, pRequest.encounteridestatus, pRequest.uploaddate, pRequest.updatedate,
                      pRequest.downloaddate, pRequest.importdate, pRequest.sourcesystemcd, pRequest.uploadid)
		quit:$$$ISERR(sc)


	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method patientMappingSave(pRequest As I2B2onFHIR.Messages.PatientMapingTransformResponse, Output pResponse As Ens.Response)
{
    s sc = $$$OK
    try {
        #dim rs As EnsLib.SQL.GatewayResultSet

        s sql = "INSERT INTO ""public"".""patient_mapping"" (patient_ide, patient_ide_source, patient_num, patient_ide_status, "_
              "project_id, upload_date, update_date, download_date, import_date, sourcesystem_cd, upload_id) "_
              "VALUES (?,?,?,?,?,?,?,?,?,?,?)"
		

		set rs=##class(%ResultSet).%New()
		Set sc=rs.Prepare(sql)
		quit:$$$ISERR(sc)

		set sc=rs.Execute(pRequest.patientide, pRequest.patientidesource, pRequest.patientnum, pRequest.patientidestatus, 
                      pRequest.projectid, pRequest.uploaddate, pRequest.updatedate, pRequest.downloaddate, pRequest.importdate, 
                      pRequest.sourcesystemcd, pRequest.uploadid)
		quit:$$$ISERR(sc)


	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method patientDataSave(pRequest As I2B2onFHIR.Messages.PatientDimensionTransformResponse, Output pResponse As Ens.Response)
{
    s sc = $$$OK
    try {
        #dim rs As EnsLib.SQL.GatewayResultSet

        s sql = "INSERT INTO ""public"".""patient_dimension"" (patient_num, vital_status_cd, birth_date, death_date, sex_cd, age_in_years_num, language_cd,  "_
            "race_cd, marital_status_cd, religion_cd, zip_cd, statecityzip_path, income_cd, patient_blob, update_date, download_date, "_
            " import_date, sourcesystem_cd, upload_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
		

		set rs=##class(%ResultSet).%New()
		Set sc=rs.Prepare(sql)
		quit:$$$ISERR(sc)

		set sc=rs.Execute(pRequest.patientnum, pRequest.vitalstatuscd, pRequest.birthdate, pRequest.deathdate, pRequest.sexcd, pRequest.ageinyearsnum, pRequest.languagecd,
                      pRequest.racecd, pRequest.maritalstatuscd, pRequest.religioncd, pRequest.zipcd, pRequest.statecityzippath, pRequest.incomecd,
                      pRequest.patientblob, pRequest.updatedate, pRequest.downloaddate, pRequest.importdate, pRequest.sourcesystemcd, pRequest.uploadid)
        $$$TRACE(sc)
		quit:$$$ISERR(sc)


	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="I2B2onFHIR.Messages.ProviderDimensionTransformResponse">
    <Method>providerDimensionSave</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.VisitDimensionTransformResponsee">
    <Method>visitDimensionSave</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.EncounterMappingTransformResponse">
    <Method>encounterMappingSave</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.PatientMapingTransformResponse">
    <Method>patientMappingSave</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.PatientDimensionTransformResponse">
    <Method>patientDataSave</Method>
  </MapItem>
</MapItems>
}

}
