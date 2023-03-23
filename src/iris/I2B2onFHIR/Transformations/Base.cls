Class I2B2onFHIR.Transformations.Base Extends Ens.DataTransform
{

/// ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As Ens.Response) As %Status
ClassMethod Transform(source As Ens.Request, target As Ens.Request) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(Ens.Response).%New()
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

/// 20220824 Denis Bulashev
/// returns new ID for I2B2 record based on FHIR resource name and resource ID
/// in case if record already exists - returns an ID which was generated before
/// this may be used to find an existing parent record and get some date from it
ClassMethod getI2B2ID(resourceName As %String = "", FHIRID As %String = "", i2b2Link = "", tableName = "") As %String
{
	quit ##class(I2B2onFHIR.Utils.Main).getI2B2ID(resourceName, FHIRID, 0, i2b2Link, tableName)
}

ClassMethod CurrentDT() As %Library.TimeStamp [ Private ]
{
	Q $zdt($h,3)
}

ClassMethod UploadId(json As %DynamicObject) As %String [ Private ]
{
	Q ""
}

ClassMethod SourceSystemCD(json As %DynamicObject) As %String [ Private ]
{
	//Demo in IRIS. we can put "Test"
	Q "Test"
}

ClassMethod IdeSource() As %String [ Private ]
{
	Q "care evolution"
}

ClassMethod DownloadDate(json As %DynamicObject) As %Library.TimeStamp [ Private ]
{
	Q ""
}

ClassMethod GenerateNum(json As %DynamicObject) As %Integer [ Private ]
{
	set resourceType = json."resourceType"
	if resourceType '= "" Q $I(^GenerateNum(resourceType))
	Q $I(^GenerateNum)
}

ClassMethod ProjectID(Output ID As %String) As %Status
{
	S ID=""
	S sc = $$$OK
	try {
      set sql = "SELECT project_id FROM ""public"".""pm_project_data"""
      
      set ts = ##class(%SQL.Statement).%New()
      set sc=ts.%Prepare(sql)
      quit:$$$ISERR(sc)

      set tr = ts.%Execute()
      if tr.%Next() {
        set ID = tr.%Get("project_id")
      } 
 	} 
	catch e {
		s sc = e.AsStatus()
	}
	q sc
}

ClassMethod ProviderID() As %Library.String [ Private ]
{
	&sql(select top(1) provider_id INTO :id from "public"."provider_dimension" )
	Q $G(id)
}

ClassMethod EncounterNum(json As %DynamicObject) As %Library.Integer [ Private ]
{
	s encId = $p(json.encounter.reference,"/",2)
	if encId'="" {
		&sql(select top(1) encounter_num INTO :num from "public"."encounter_mapping" where  "encounter_ide" = :encId )
	}
	I $G(num)'="" Q $G(num)
	s patId = $p(json.subject.reference,"/",2)
	if patId'="" {
		&sql(select top(1) encounter_num INTO :num from "public"."encounter_mapping" where  "patient_ide" = :patId )
	}
	Q $G(num)
}

ClassMethod PatientNum(json As %DynamicObject) As %Library.Integer [ Private ]
{
	s patId = $p(json.subject.reference,"/",2)
	&sql(select top(1) patient_num INTO :num from "public"."patient_mapping" where  patient_ide = :patId )
	Q $G(num)
}

}

