Class I2B2onFHIR.Processes.Patient Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Parameter DESTINATIONSAVE = "Operations.SaveDataToI2B2";

Parameter DESTINATIONCHECK = "Operations.CheckDataInI2B2";

Method OnRequest(pRequest As I2B2onFHIR.Messages.dataTransformRequestBase, Output pResponse As Ens.Response) As %Status
{
    set sc = $$$OK
	try {
		// patient mapping
		// 1 - transform data
		#dim patientMappingTransformResponse As I2B2onFHIR.Messages.PatientMapingTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.PatientMaping).Transform(pRequest, .patientMappingTransformResponse)
		quit:$$$ISERR(sc)


		// 2 - check if we already have this data
		#dim dataCheckResponse As I2B2onFHIR.Messages.dataCheckBaseResponse
		s sc = ..SendRequestSync(..#DESTINATIONCHECK, patientMappingTransformResponse, .dataCheckResponse)
		quit:$$$ISERR(sc)

		// 3 - if we do not have this data - save
		if dataCheckResponse.recordId = -1 {
			s sc = ..SendRequestSync(..#DESTINATIONSAVE, patientMappingTransformResponse, .resp)
			quit:$$$ISERR(sc)
		}


		
		// patient dimension
		// 1 - transform data
		#dim patientDimensionTransformResponse As I2B2onFHIR.Messages.PatientDimensionTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.PatientDimension).Transform(pRequest, .patientDimensionTransformResponse)
		quit:$$$ISERR(sc)

		// check if we already have this data
		s sc = ..SendRequestSync(..#DESTINATIONCHECK, patientDimensionTransformResponse, .dataCheckResponse)
		quit:$$$ISERR(sc)

		//if we do not have this data - save
		if dataCheckResponse.recordId = -1 {
			s sc = ..SendRequestSync(..#DESTINATIONSAVE, patientDimensionTransformResponse, .resp)
			quit:$$$ISERR(sc)
		}

		
		$$$TRACE("Patient")
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
