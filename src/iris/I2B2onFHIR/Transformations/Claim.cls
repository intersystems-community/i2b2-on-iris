Class I2B2onFHIR.Transformations.Claim Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.claimDataTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.claimDataTransformResponse).%New()



	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}
