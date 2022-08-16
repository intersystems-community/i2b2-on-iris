Class I2B2onFHIR.Operations.SaveDataToI2B2 Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method patientDataSave(pRequest As I2B2onFHIR.Messages.patientDataTransformResponse, Output pResponse As Ens.Response)
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

		set sc=rs.Execute(pRequest.patientnum,2,0,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0)
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
  <MapItem MessageType="I2B2onFHIR.Messages.patientDataTransformResponse">
    <Method>patientDataSave</Method>
  </MapItem>
</MapItems>
}

}
