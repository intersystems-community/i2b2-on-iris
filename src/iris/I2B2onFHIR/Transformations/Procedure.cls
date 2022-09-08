Class I2B2onFHIR.Transformations.Procedure Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()
        
		set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
		
		S record.encounternum="-1"
		s record.patientnum = "-1"
		s record.conceptcd=""
		s record.providerid=""
		s record.modifiercd=""	
		s record.startdate = ""
		s record.enddate = ""
		s record.locationcd=""		// visit_dimension.location_cd
		
		
		s record.instancenum="1"		
		s record.valtypecd="T"		//
		s record.tvalchar=""		//
		s record.nvalnum=""		//
		s record.valueflagcd=""		//	
		s record.quantitynum=""		//
		s record.unitscd="@"		//
		s record.confidencenum=""	//
		s record.downloaddate=""	//
		s record.observationblob=""		//
		s record.sourcesystemcd="TEST"	//
		s record.textsearchindex=""	//
		s record.importdate=..CurrentDT()	//	
		s record.updatedate=..CurrentDT()	//
		s record.uploadid=""
		
		do target.data.Insert(record) 
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

