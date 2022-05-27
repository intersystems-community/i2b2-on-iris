Class I2B2.FHIR.Install [ Abstract, Language = objectscript ]
{

ClassMethod Install()
{
	try {
		Set appKey = "/i2b2/fhir/r4"
		Set strategyClass = "I2B2.HS.FHIRServer.Storage.Json.InteractionsStrategy"
		Set metadataConfigKey = "HL7v40"
		Do ##class(HS.FHIRServer.Installer).InstallInstance(appKey, strategyClass, metadataConfigKey)

		#dim strategy As HS.FHIRServer.API.InteractionsStrategy
		#dim configData AS HS.FHIRServer.API.ConfigData
		Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(appKey)
		Set configData = strategy.GetServiceConfigData()
		Set configData.DebugMode = 4
		Do strategy.SaveServiceConfigData(configData)
	} catch ex {
		Write $system.Status.GetErrorText(ex.AsStatus())
	}
	Quit
}

ClassMethod LoadDefData(FileName As %String, Nsp As %String = "")
{
	If (Nsp = "") {
		Set Nsp = $namespace
	}
	Write "Loading test data, this may take time", !
	Set sc = ##class(%Library.Global).Import(Nsp, "*", FileName, 7)
	If $$$ISERR(sc) {
		Write $system.Status.GetErrorText(sc)
	} else {
		Write "Test data loaded successfully", !
	}
	Quit
}

}
