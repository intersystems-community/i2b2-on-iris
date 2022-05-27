Class I2B2.HS.FHIRServer.Storage.Json.InteractionsStrategy Extends HS.FHIRServer.Storage.Json.InteractionsStrategy
{

Parameter StrategyKey As %String = "I2B2Json";

Parameter InteractionsClass As %String = "I2B2.HS.FHIRServer.Storage.Json.Interactions";

/// @API
/// Returns the classname of the persistent object used store resources for the specified type
Method GetProxyClass(pResourceType As %String) As %String
{
	i pResourceType = "Patient" {
		q "I2B2.FHIR.Proxy.Patient"
	} else {
		q ""
	}
}

/// Returns the classname of the persistent object used store older resource versions for the specified type
Method GetProxyVersionClass(pResourceType As %String) As %String
{
	q ..GetProxyClass(pResourceType)  // no version
}

}
