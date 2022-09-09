Class I2B2onFHIR.Transformations.MedicationRequest Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()
        
		set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
		
		S record.encounternum=..EncounterNum(source.json)
		s record.patientnum = ..PatientNum(source.json)
		s record.conceptcd=..ConceptCD(source.json)
		s record.providerid=..ProviderID()
		s record.modifiercd=..ModifierCD(source.json)	
		
		set encounter = ##class(public.visitdimension).visitdimensionpkOpen(record.encounternum,record.patientnum)
				 
		s record.startdate = encounter.startdate
		s record.enddate = encounter.enddate
		s record.locationcd = encounter.locationcd
		
		
		s record.instancenum="1"		
		s record.valtypecd="T"
		s record.tvalchar=""
		s record.nvalnum=""
		s record.valueflagcd=""
		s record.quantitynum=""
		s record.unitscd="@"
		s record.confidencenum=""
		s record.downloaddate=""
		s record.observationblob=""
		s record.sourcesystemcd=..SourceSystemCD(json)
		s record.textsearchindex=""
		s record.importdate=..CurrentDT()	
		s record.updatedate=..CurrentDT()
		s record.uploadid=""
		
		do target.data.Insert(record)        

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

