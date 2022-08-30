Class I2B2onFHIR.Processes.Practitioner Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Parameter DESTINATIONSAVE = "Operations.SaveDataToI2B2";

Parameter DESTINATIONCHECK = "Operations.CheckDataInI2B2";

Method OnRequest(pRequest As I2B2onFHIR.Messages.dataTransformRequestBase, Output pResponse As I2B2onFHIR.Messages.dataCreateResponse) As %Status
{
    set sc = $$$OK
	try {
		set pResponse = ##class(I2B2onFHIR.Messages.dataCreateResponse).%New()

		// provider_dimension
		$$$TRACE("Create provider_dimension table")
		// 1 - transform data
		#dim providerDimensionTransformResponse As I2B2onFHIR.Messages.ProviderDimensionTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.ProviderDimension).Transform(pRequest, .providerDimensionTransformResponse)
		quit:$$$ISERR(sc)


		// 2 - check if we already have this data
		#dim dataCheckResponse As I2B2onFHIR.Messages.dataCheckBaseResponse
		s sc = ..SendRequestSync(..#DESTINATIONCHECK, providerDimensionTransformResponse, .dataCheckResponse)
		quit:$$$ISERR(sc)

		// 3 - if we do not have this data - save
		if dataCheckResponse.recordId = -1 {
			s sc = ..SendRequestSync(..#DESTINATIONSAVE, providerDimensionTransformResponse, .resp)
			quit:$$$ISERR(sc)
		}
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

