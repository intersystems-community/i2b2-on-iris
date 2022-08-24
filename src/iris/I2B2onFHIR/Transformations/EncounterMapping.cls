Class I2B2onFHIR.Transformations.EncounterMapping Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.EncounterMappingTransformResponse) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(I2B2onFHIR.Messages.EncounterMappingTransformResponse).%New()
        set target.downloaddate=..CurrentDT()
        set target.encounteride=source.json."ID"
        set target.encounteridesource=..IdeSource()
        set target.encounteridestatus="A"
        set target.encounternum=..getI2B2ID("encounter", source.json."ID") //..GenerateNum(source.json)
        set target.importdate=..CurrentDT()
        set target.patientide=""		//patient_mapping.patient_ide
        set target.patientidesource=""	//patient_mapping.patient_ide_source
        set target.projectid=""			//PM_PROJECT_DATA.project_id  //???
        set target.sourcesystemcd=..SourceSystemCD(source.json)
        set target.updatedate=..CurrentDT()  //??? //записываем даты обновлений
        set target.uploaddate=..CurrentDT()
        set target.uploadid=..UploadId(source.json)

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

