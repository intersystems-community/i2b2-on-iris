Include (HS.FHIRServer.Errors, HS.FHIRServer)

Class I2B2.FHIR.Proxy.Base Extends %RegisteredObject
{

/// Set to 1 if this resource is deleted. The value 1 will only appear on the
/// current version if it was deleted. Set to an integer greater than 1 to
/// temporarily indicate the Bundle transaction id that created the resource.
Property Deleted As %Integer [ InitialExpression = 0 ];

Property VersionId As %String [ InitialExpression = "1" ];

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
