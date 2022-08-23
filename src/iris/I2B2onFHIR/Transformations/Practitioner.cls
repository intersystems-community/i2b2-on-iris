Class I2B2onFHIR.Transformations.Practitioner Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.practitionerDataTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.practitionerDataTransformResponse).%New()
        set target.downloaddate=..CurrentDT()
        set target.importdate=..CurrentDT()
        set target.namechar=..NameChar(source.json)
        set target.providerblob=""
        set target.providerid=..ProviderId()
        set target.providerpath=..ProviderPath(source.json)
        set target.sourcesystemcd="TEST"
        set target.updatedate=..CurrentDT()
        set target.uploadid=""


	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

