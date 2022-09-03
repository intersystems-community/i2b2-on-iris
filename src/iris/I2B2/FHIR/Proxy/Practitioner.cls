Class I2B2.FHIR.Proxy.Practitioner Extends I2B2.FHIR.Proxy.Base
{

Property ProviderId As %String(MAXLEN = "");

Property ProviderPath As %Library.String(MAXLEN = "");

Property Provider As public.providerdimension;

Property Key As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "Practitioner/"_{ResourceId}}, SqlComputed ];

Property ResourceType As %String(COLLATION = "") [ InitialExpression = "Practitioner" ];

Property ResourceId As %String(MAXLEN = "");

ClassMethod getResourceIds(pResourceId As %String) As %String
{
	set sql = "SELECT i2b2Link FROM I2B2onFHIR_storage.Ids LEFT JOIN I2B2onFHIR_storage.IdsLinks "_
			  "ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId "_
			  "where tableName='provider_dimension' and fhirId=?"

	set ts = ##class(%SQL.Statement).%New()
	set sc=ts.%Prepare(sql)
	i $$$ISERR(sc) $$$ThrowFHIR($$$GeneralError, $system.Status.GetErrorText(sc))

	set tr = ts.%Execute(pResourceId)
	if (tr.%Next() && (tr.i2b2Link '= "")) {
		q tr.i2b2Link
	} else {
		q ""
	}
}

/// Check if resource exists
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Practitioner/123"
ClassMethod KeyIdxExists(rsrcKey As %String) As %Boolean
{
	s pResourceId = $p(rsrcKey, "/", 2)

	s resourceIds = ..getResourceIds(pResourceId)
	if resourceIds'="" {
		q ##class(public.providerdimension).providerdimensionpkExists($lg(resourceIds, 1), $lg(resourceIds, 2))
	} else {
		q 1
	}
}

/// Get resource
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Practitioner/123"
ClassMethod KeyIdxOpen(rsrcKey As %String, empty, tSC As %Status) As I2B2.FHIR.Proxy.Base
{
	s tSC=$$$OK
	s pResourceType = $p(rsrcKey, "/")
	s pResourceId = $p(rsrcKey, "/", 2)
	// get data from I2B2onFHIR.Storage.Ids
	s resourceIds = ..getResourceIds(pResourceId)
	s pProviderPath = $lg(resourceIds, 1)
	s pProviderId = $lg(resourceIds, 2)

	i resourceIds="" {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
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
