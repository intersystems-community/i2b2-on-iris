Class I2B2onFHIR.Processes.ObservationFact Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Parameter DESTINATIONSAVE = "Operations.SaveDataToI2B2";

Parameter DESTINATIONCHECK = "Operations.CheckDataInI2B2";

Method OnRequest(pRequest As I2B2onFHIR.Messages.ObservationFactBPRequest, Output pResponse As Ens.Response) As %Status
{
    set sc = $$$OK
    try {
	    $$$TRACE("ObservationFact start")
		// transform data
		#dim observationFactTransformResponse As I2B2onFHIR.Messages.ObservationFactTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.ObservationFact).Transform(pRequest, .observationFactTransformResponse)


		//ToDO
		// 1 - check that record already exists 
		#dim dataCheckResponse As I2B2onFHIR.Messages.dataCheckBaseResponse
		s sc = ..SendRequestSync(..#DESTINATIONCHECK, observationFactTransformResponse, .dataCheckResponse)
		quit:$$$ISERR(sc)

		// 2 - save new record
		s sc = ..SendRequestSync(..#DESTINATIONSAVE, observationFactTransformResponse, .resp)
		quit:$$$ISERR(sc)
        

        $$$TRACE("ObservationFact end")
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

