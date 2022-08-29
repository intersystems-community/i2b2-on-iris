Class I2B2onFHIR.Transformations.ObservationFact Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.ObservationFactBPRequest, target As I2B2onFHIR.Messages.ObservationFactTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.ObservationFactTransformResponse).%New()

		For Method = "AGE","DATEB","DATED","LANGUAGE","MARITAL","RACE","RELIGION","SEX","VITAL" {
			set record = ##class(I2B2onFHIR.Messages.ObservationFactItem).%New()
			set ok = $CLASSMETHOD(..%ClassName(1),Method,source, .record)
			if $$$ISOK(ok) {
				//do target.data.Insert(record)
			}
		}
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

/// for all patients
ClassMethod AGE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date

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
	Q $$$OK
}

/// for all patients
ClassMethod DATEB(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date
	s record.tvalchar=""
	s record.nvalnum=""				

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
	s record.valtypecd="D"		//
	s record.valueflagcd=""		//	Q $$$OK
}

/// only for patients with a filled in date of death: Patient_dimension.death_date
ClassMethod DATED(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date
	s record.tvalchar=""
	s record.nvalnum=""				

	s record.confidencenum=""	//
	s record.downloaddate=""	//
	s record.locationcd="@"		//
	s record.modifiercd="@"	//
	s record.observationblob=""		//
	s record.quantitynum=""		//
	s record.sourcesystemcd="DEMOGRAPHIC|TEST"	//
	s record.textsearchindex=""	//
	s record.unitscd="@"		//
	s record.importdate=..CurrentDT()	//	
	s record.updatedate=..CurrentDT()	//
	s record.uploadid="" 		//
	s record.valtypecd="D"		//
	s record.valueflagcd=""		//	Q $$$OK
}

/// only for patients with a filled in Patient_dimension.language_cd
ClassMethod LANGUAGE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date

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
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	Q $$$OK
}

/// only for patients with a filled in  Patient_dimension.language_cd
ClassMethod MARITAL(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date

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
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	Q $$$OK
}

/// only for patients with a filled in  Patient_dimension.language_cd
ClassMethod RACE(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date

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
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	Q $$$OK
}

/// only for patients with a filled in  Patient_dimension.language_cd
ClassMethod RELIGION(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date

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
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	Q $$$OK
}

/// for all patients
ClassMethod SEX(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date

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
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	Q $$$OK
}

/// only for patients with a filled in Patient_dimension.vital_status_cd
ClassMethod VITAL(source As I2B2onFHIR.Messages.ObservationFactBPRequest, Output record As I2B2onFHIR.Messages.ObservationFactItem) As %Status [ Private ]
{
	s record.patientnum = source.patientNum

	s record.conceptcd=""
	s record.encounternum=""
	s record.providerid=""
	s record.instancenum=""
	s record.startdate=""
	s record.enddate=""		//observation_fact.start_date

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
	s record.valtypecd="T"		//
	s record.valueflagcd=""		//	Q $$$OK
	Q $$$OK
}

}

