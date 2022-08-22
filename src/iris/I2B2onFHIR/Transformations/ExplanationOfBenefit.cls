Class I2B2onFHIR.Transformations.ExplanationOfBenefit Extends Ens.DataTransform
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.procedureDataTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.explanationOfBenefitDataTransformResponse).%New()



	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}
