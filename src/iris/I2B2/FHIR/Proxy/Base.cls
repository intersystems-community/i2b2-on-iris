Include (HS.FHIRServer.Errors, HS.FHIRServer)

Class I2B2.FHIR.Proxy.Base Extends %RegisteredObject
{

/// Check if resource exists
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Patient/123"
ClassMethod KeyIdxExists(rsrcKey As %String) As %Boolean [ Abstract ]
{
}

/// Get resource
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Patient/123"
ClassMethod KeyIdxOpen(rsrcKey As %String, empty, tSC As %Status) As I2B2.FHIR.Proxy.Base [ Abstract ]
{
}

Method Transform() As %Library.DynamicObject [ Abstract ]
{
}

}
