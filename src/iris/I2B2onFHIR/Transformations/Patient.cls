Class I2B2onFHIR.Transformations.Patient Extends Ens.DataTransform
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.patientDataTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.patientDataTransformResponse).%New()

        set target.sexcd = source.json."resource"."gender"
		set target.patientnum = $e($tr($h,",",""),3,12)




	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}
