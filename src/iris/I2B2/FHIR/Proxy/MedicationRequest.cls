Class I2B2.FHIR.Proxy.MedicationRequest Extends I2B2.FHIR.Proxy.Base
{

Property ObservationFact As public.observationfact;

Property Key As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "MedicationRequest/"_{ResourceId}}, SqlComputed ];

Property ResourceType As %String(COLLATION = "") [ InitialExpression = "MedicationRequest" ];

Property ResourceId As %String(MAXLEN = "");

ClassMethod getResourceIds(pResourceId As %String) As %String
{
	set sql = "SELECT i2b2Link FROM I2B2onFHIR_storage.Ids LEFT JOIN I2B2onFHIR_storage.IdsLinks "_
			  "ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId "_
			  "where tableName='observation_fact' and fhirId=?"

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
		q ##class(public.observationfact).observationfactpkExists($lg(resourceIds, 1), $lg(resourceIds, 2), $lg(resourceIds, 3), $lg(resourceIds, 4), $lg(resourceIds, 5), $lg(resourceIds, 6), $lg(resourceIds, 7))
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

	i resourceIds="" {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
	s observationFact = ##class(public.observationfact).observationfactpkOpen($lg(resourceIds, 1), $lg(resourceIds, 2), $lg(resourceIds, 3), $lg(resourceIds, 4), $lg(resourceIds, 5), $lg(resourceIds, 6), $lg(resourceIds, 7))
	i '$iso(observationFact) {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
	s proxy = ..%New()
	s proxy.ResourceId = pResourceId
	s proxy.ObservationFact = observationFact

	q proxy
}

Method Transform() As %Library.DynamicObject
{
	#dim medicationRequest As HS.FHIR.DTL.vR4.Model.Resource.MedicationRequest
	s sc = ##class(I2B2.FHIR.Transform.MedicationRequest).Transform(##this, .medicationRequest)
	i $$$ISERR(sc) {
		$$$ThrowFHIR($$$GeneralError, $system.Status.GetErrorText(sc))
	} else {
		q ##class(%DynamicObject).%FromJSON(medicationRequest.ToJSON())
	}
}

}
