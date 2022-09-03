Class I2B2.FHIR.Proxy.Practitioner Extends I2B2.FHIR.Proxy.Base
{

Property ProviderId As %String(MAXLEN = "");

Property ProviderPath As %Library.String(MAXLEN = "");

Property Provider As public.providerdimension;

Property Key As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "Practitioner/"_{ResourceId}}, SqlComputed ];

Property ResourceType As %String(COLLATION = "") [ InitialExpression = "Practitioner" ];

Property ResourceId As %String(MAXLEN = "");

/// Check if resource exists
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Practitioner/123"
ClassMethod KeyIdxExists(rsrcKey As %String) As %Boolean
{
	q 1
	s pResourceId = $p(rsrcKey, "/", 2)
	// get data from I2B2onFHIR.Storage.Ids
	#; s pProviderId = 
	#; s pProviderPath = 
	#; q ##class(public.providerdimension).providerdimensionpkExists(pProviderPath, pProviderId)
}

/// Get resource
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Practitioner/123"
ClassMethod KeyIdxOpen(rsrcKey As %String, empty, tSC As %Status) As I2B2.FHIR.Proxy.Base
{
	s tSC=$$$OK
	s pResourceType = $p(rsrcKey, "/")
	s pResourceId = $p(rsrcKey, "/", 2)
	// get data from I2B2onFHIR.Storage.Ids
	s pProviderId = "LCS-I2B2:D000109060"
	s pProviderPath = "\i2b2\Providers\Medicine\Primary Care\Welby, Marcus, MD\"

	s providerDimension = ##class(public.providerdimension).providerdimensionpkOpen(pProviderPath, pProviderId)
	i '$iso(providerDimension) {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
	s proxy = ..%New()
	s proxy.ResourceId = pResourceId
	s proxy.ProviderId = pProviderId
	s proxy.ProviderPath = pProviderPath
	s proxy.Provider = providerDimension

	q proxy
}

Method Transform() As %Library.DynamicObject
{
	#dim providerResource As HS.FHIR.DTL.vR4.Model.Resource.Practitioner
	s sc = ##class(I2B2.FHIR.Transform.Practitioner).Transform(##this, .providerResource)
	i $$$ISERR(sc) {
		$$$ThrowFHIR($$$GeneralError, $system.Status.GetErrorText(sc))
	} else {
		q ##class(%DynamicObject).%FromJSON(providerResource.ToJSON())
	}
}

}
