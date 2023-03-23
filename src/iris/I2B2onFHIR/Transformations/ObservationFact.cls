Class I2B2onFHIR.Transformations.ObservationFact Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.ObservationFactBPRequest, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()

		// create AGE
		set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%new()
		// transform and fill data
		do target.data.Insert(record)


		// create DATE (B)
		set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%new()
		// transform and fill data
		do target.data.Insert(record)


		// create DATE (D)
		set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%new()
		// transform and fill data
		do target.data.Insert(record)


		/// etc for other fields


	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}
