Class I2B2.HS.FHIRServer.Storage.Json.InteractionsStrategy Extends HS.FHIRServer.Storage.Json.InteractionsStrategy
{

Parameter StrategyKey As %String = "I2B2Json";

Parameter InteractionsClass As %String = "I2B2.HS.FHIRServer.Storage.Json.Interactions";

/// Returns the classname of the persistent object used store resources for the specified type
Method GetProxyClass(pResourceType As %String) As %String
{
	q:pResourceType="Patient" "I2B2.FHIR.Proxy.Patient"
	q:pResourceType="Practitioner" "I2B2.FHIR.Proxy.Practitioner"
	q:pResourceType="MedicationRequest" "I2B2.FHIR.Proxy.MedicationRequest"
	q ""
}

/// Returns the classname of the persistent object used store older resource versions for the specified type
Method GetProxyVersionClass(pResourceType As %String) As %String
{
	q ..GetProxyClass(pResourceType)  // no version
}

/// @Override
/// @API
/// Returns the classname of the persistent object used store resources for the specified type
Method GetResourceClass(resourceType As %String) As %String [ CodeMode = expression ]
{
..GetProxyClass(resourceType)
}

}
