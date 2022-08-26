Class I2B2onFHIR.Processes.ObservationFact Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pRequest As I2B2onFHIR.Messages.ObservationFactBPRequest, Output pResponse As Ens.Response) As %Status
{
    set sc = $$$OK
    try {
		// transform data
		#dim dataTransformResponse As I2B2onFHIR.Messages.ObservationFactTransformResponse
		set sc = ##class(I2B2onFHIR.Transformations.ObservationFact).Transform(pRequest, .dataTransformResponse)


		//ToDO
		// 1 - check that record already exists

		// 2 - save new record

        

        $$$TRACE("ObservationFact")
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
