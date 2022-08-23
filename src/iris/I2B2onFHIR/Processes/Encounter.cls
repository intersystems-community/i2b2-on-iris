Class I2B2onFHIR.Processes.Encounter Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Parameter DESTINATIONSAVE = "Operations.SaveDataToI2B2";

Parameter DESTINATIONCHECK = "Operations.CheckDataInI2B2";

Method OnRequest(pRequest As I2B2onFHIR.Messages.dataTransformRequestBase, Output pResponse As Ens.Response) As %Status
{
    set sc = $$$OK
    try {
		// encounter_mapping
		// 1 - transform data
		#dim encounterMappingTransformResponse As I2B2onFHIR.Messages.EncounterMappingTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.EncounterMapping).Transform(pRequest, .encounterMappingTransformResponse)
		quit:$$$ISERR(sc)


		// 2 - check if we already have this data
		#dim dataCheckResponse As I2B2onFHIR.Messages.dataCheckBaseResponse
		s sc = ..SendRequestSync(..#DESTINATIONCHECK, encounterMappingTransformResponse, .dataCheckResponse)
		quit:$$$ISERR(sc)


		// 3 - if we do not have this data - save
		if dataCheckResponse.recordId = -1 {
			s sc = ..SendRequestSync(..#DESTINATIONSAVE, encounterMappingTransformResponse, .resp)
			quit:$$$ISERR(sc)
		}



		// visit_dimension
		// 1 - transform data
		#dim visitDimensionTransformResponse As I2B2onFHIR.Messages.VisitDimensionTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.VisitDimension).Transform(pRequest, .visitDimensionTransformResponse)
		quit:$$$ISERR(sc)

		
		// 2 - check if we already have this data
		s sc = ..SendRequestSync(..#DESTINATIONCHECK, visitDimensionTransformResponse, .dataCheckResponse)
		quit:$$$ISERR(sc)

		
		// 3 - if we do not have this data - save
		if dataCheckResponse.recordId = -1 {
			s sc = ..SendRequestSync(..#DESTINATIONSAVE, visitDimensionTransformResponse, .resp)
			quit:$$$ISERR(sc)
		}



        $$$TRACE("Encounter")
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
