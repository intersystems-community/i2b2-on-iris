Class I2B2onFHIR.Transformations.Procedure Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()
        
		set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
		s record.patientnum = "-1"

		s record.conceptcd=""
		s record.providerid=""
		s record.instancenum="1"
		s record.startdate = ""
		s record.enddate = ""

		S record.encounternum="-1"
		s record.confidencenum=""	//
		s record.downloaddate=""	//
		s record.locationcd="@"		//
		s record.modifiercd="@"	//
		s record.nvalnum=""		//
		s record.observationblob=""		//
		s record.quantitynum=""		//
		s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
		s record.textsearchindex=""	//
		s record.tvalchar=""		//
		s record.unitscd="@"		//
		s record.importdate=..CurrentDT()	//	
		s record.updatedate=..CurrentDT()	//
		s record.uploadid="" 		//
		s record.valtypecd="N"		//
		s record.valueflagcd=""		//	
		
		do target.data.Insert(record) 
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

