Class I2B2onFHIR.Processes.Encounter Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Parameter DESTINATIONSAVE = "Operations.SaveDataToI2B2";

Parameter DESTINATIONCHECK = "Operations.CheckDataInI2B2";

Method OnRequest(pRequest As I2B2onFHIR.Messages.dataTransformRequestBase, Output pResponse As I2B2onFHIR.Messages.dataCreateResponse) As %Status
{
    set sc = $$$OK
    try {
		set pResponse = ##class(I2B2onFHIR.Messages.dataCreateResponse).%New()

		// encounter_mapping
		$$$TRACE("Create encounter_mapping table")
		// 1 - transform data
		#dim encounterMappingTransformResponse As I2B2onFHIR.Messages.EncounterMappingTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.EncounterMapping).Transform(pRequest, .encounterMappingTransformResponse)
		$$$TRACE("EncounterMapping.Transform = "_sc)
		quit:$$$ISERR(sc)

		// check whether we have a patient for this encounter or not
        set refType = $p(pRequest.json."subject"."reference", "/", 1)
        set refId = $p(pRequest.json."subject"."reference", "/", 2)
        set patientnum = ##class(I2B2onFHIR.Utils.Main).getI2B2ID(refType, refId,1,,"patient_dimension")
		$$$TRACE("EncounterMapping getI2B2ID patientnum = "_patientnum)
		quit:patientnum="" /// patient not found - skip record
		set pResponse.patientNum = patientnum


		// 2 - check if we already have this data
		#dim dataCheckResponse As I2B2onFHIR.Messages.dataCheckBaseResponse
		s sc = ..SendRequestSync(..#DESTINATIONCHECK, encounterMappingTransformResponse, .dataCheckResponse)
		$$$TRACE("EncounterMapping SendRequestSync Check data = "_sc)
		quit:$$$ISERR(sc)


		// 3 - if we do not have this data - save
		if dataCheckResponse.recordId = -1 {
			s sc = ..SendRequestSync(..#DESTINATIONSAVE, encounterMappingTransformResponse, .resp)
			$$$TRACE("EncounterMapping SendRequestSync Save data = "_sc)
			quit:$$$ISERR(sc)
		}



		// visit_dimension
		$$$TRACE("Create visit_dimension table")
		// 1 - transform data
		#dim visitDimensionTransformResponse As I2B2onFHIR.Messages.VisitDimensionTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.VisitDimension).Transform(pRequest, .visitDimensionTransformResponse)
		$$$TRACE("VisitDimension.Transform = "_sc)
		quit:$$$ISERR(sc)

		
		// 2 - check if we already have this data
		s sc = ..SendRequestSync(..#DESTINATIONCHECK, visitDimensionTransformResponse, .dataCheckResponse)
		$$$TRACE("VisitDimension SendRequestSync Check data = "_sc)
		quit:$$$ISERR(sc)

		
		// 3 - if we do not have this data - save
		if dataCheckResponse.recordId = -1 {
			s sc = ..SendRequestSync(..#DESTINATIONSAVE, visitDimensionTransformResponse, .resp)
			$$$TRACE("VisitDimension SendRequestSync Save data = "_sc)
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

