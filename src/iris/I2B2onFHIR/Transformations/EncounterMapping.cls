Class I2B2onFHIR.Transformations.EncounterMapping Extends I2B2onFHIR.Transformations.Base
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As I2B2onFHIR.Messages.EncounterMappingTransformResponse) As %Status
{
	s sc = $$$OK
	try {
		
		set ref = source.json.subject.reference
		if $zcvt($P(ref,"/"),"L")'="patient" s sc=$$$ERROR("No patient reference") Q
		set patRef=$P(ref,"/",2)
		set sc = ##class(I2B2onFHIR.Utils.Main).getIDfromTable("""public"".""patientmapping""", "upload_id", patRef, .ID)
		if $$$ISERR(sc) Q
		#dim patient as public.patientmapping = $$$NULLOREF
		if ID > 0 {
			set patient = ##class(public.patientmapping).%OpenId(ID)
		}
		
        set target = ##class(I2B2onFHIR.Messages.EncounterMappingTransformResponse).%New()
        set target.downloaddate=..CurrentDT()
        set target.encounteride=source.json.id
        set target.encounteridesource=..IdeSource()
        set target.encounteridestatus="A"
        set target.projectid="TEST"		//PM_PROJECT_DATA.project_id  //???
        if ..ProjectID(.projectid) {
	        set target.projectid=projectid
        }
        set target.importdate=..CurrentDT()
        set target.patientide=patient.patientide		//patient_mapping.patient_ide
        set target.patientidesource=patient.patientidesource	//patient_mapping.patient_ide_source			
        set target.sourcesystemcd=..SourceSystemCD(source.json)
        set target.updatedate=..CurrentDT()  //??? //записываем даты обновлений
        set target.uploaddate=..CurrentDT()
        //Index encountermappingpk On (encounteride, encounteridesource, projectid, patientide, patientidesource) [ PrimaryKey, SqlName = encounter_mapping_pk, Type = index, Unique ];
        set target.encounternum=..getI2B2ID("encounter", source.json.id,$lb(target.encounteride, target.encounteridesource, target.projectid, target.patientide, target.patientidesource)) //..GenerateNum(source.json)
        set target.uploadid = target.encounternum //..getI2B2ID("encounter", source.json.id) //..UploadId(source.json)
        

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

