Class I2B2.HS.FHIRServer.Storage.Json.Interactions Extends HS.FHIRServer.Storage.Json.Interactions
{

Method Read(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject
{
	//q ##super(pResourceType, pResourceId, pVersionId)
	$$$FSLog("Read: pResourceType="_pResourceType_" pResourceId="_ pResourceId_" pVersionId="_pVersionId)

	s proxy = ..GetProxyObject(pResourceType, pResourceId, pVersionId)

	i $iso(proxy) {
		#dim response As %DynamicObject = proxy.Transform()

		// validate response
		#dim schema As HS.FHIRServer.Schema = ..strategy.schema
		i '$iso(schema) s schema = ##class(HS.FHIRServer.Schema).LoadSchema("HL7v40")
		set resourceValidator = ##class(HS.FHIRServer.Util.ResourceValidator).%New(schema)
		d resourceValidator.ValidateResource(response)
		// return it
		q response

	} else {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotAllowed, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
}

/// GetStorageObject
Method GetResponse(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject [ Internal ]
{
	#dim storageObject As I2B2.FHIR.Proxy.Base = ..FindProxyObject(pResourceType, pResourceId, pVersionId, .tSC)
	if (storageObject = "") {
		if (pVersionId = "") {
			$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
		} else {
			$$$ThrowFHIR($$$HSFHIRErrResourceVersionNotFound, pResourceType , pResourceId , pVersionId, $$$HttpOnlyResponse(404))
		}
	}
	return storageObject
}

/// GetStorageObject
Method GetProxyObject(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As I2B2.FHIR.Proxy.Base [ Internal ]
{
	#dim storageObject As I2B2.FHIR.Proxy.Base = ..FindProxyObject(pResourceType, pResourceId, pVersionId, .tSC)
	if (storageObject = "") {
		if (pVersionId = "") {
			$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
		} else {
			$$$ThrowFHIR($$$HSFHIRErrResourceVersionNotFound, pResourceType , pResourceId , pVersionId, $$$HttpOnlyResponse(404))
		}
	}
	return storageObject
}

/// FindStorageObject
Method FindProxyObject(pResourceType As %String, pResourceId As %String, pVersionId As %String = "", Output tSC As %Status = "") As I2B2.FHIR.Proxy.Base
{
#def1arg callStorageMethod(%arglist) $classmethod(storageClass,%arglist)
	Set resourceClass = ..strategy.GetProxyClass(pResourceType)
	if resourceClass = "" {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotAllowed, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
	Set resourceVerClass = ..strategy.GetProxyVersionClass(pResourceType)
	Set rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId)
	Set obj = ""
	$$$FSLog("FindStorageObject: ..strategy="_..strategy.%ClassName(1)_" resourceClass="_resourceClass_" resourceVerClassd="_ resourceVerClass_" rsrcKey="_rsrcKey)
	if $classmethod(resourceClass, "KeyIdxExists", rsrcKey) {
		// We have at least one version.  Get it first ..
		Set obj = $classmethod(resourceClass, "KeyIdxOpen", rsrcKey, , .tSC )
		// There is a current object, is this the one that was asked for?

		/* no version support
		if (pVersionId '= "") && (obj.VersionId '= pVersionId) {
			// If not, go get the requested version
			Set obj = $classmethod(resourceVerClass, "TypeIdVerIdxOpen", pResourceType, pResourceId, pVersionId)
		}
		*/
	}
	return obj
}

}
