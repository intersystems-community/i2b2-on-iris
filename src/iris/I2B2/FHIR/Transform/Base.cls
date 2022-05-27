/// Base class for all transformations
Class I2B2.FHIR.Transform.Base Extends Ens.DataTransform
{

ClassMethod Transform(source As %RegisteredObject, target As %RegisteredObject) As %Status
{
	q $$$EnsError($$$EnsErrNotImplemented,$$$CurrentClass,$$$CurrentMethod)
}

}
