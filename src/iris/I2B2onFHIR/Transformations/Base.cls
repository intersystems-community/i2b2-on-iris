Class I2B2onFHIR.Transformations.Base Extends Ens.DataTransform
{

/// ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As Ens.Response) As %Status
ClassMethod Transform(source As Ens.Request, target As Ens.Response) As %Status
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
ClassMethod getI2B2ID(resourceName As %String = "", FHIRID As %String = "") As %String
{
	quit ##class(I2B2onFHIR.Utils.Main).getI2B2ID(resourceName, FHIRID)
}

ClassMethod CurrentDT() As %Library.TimeStamp [ Private ]
{
	//update_date=import_date in IRIS
	Q $zdt($h,3)
}

ClassMethod UploadId(json As %DynamicObject) As %String [ Private ]
{
	//is empty IN IRIS.  I think that there should be an ID from care evolution, but it should be an int type
	Q ""
}

ClassMethod SourceSystemCD(json As %DynamicObject) As %String [ Private ]
{
	//Demo in IRIS. we can put "Test"
	Q "Test"
}

ClassMethod IdeSource() As %String [ Private ]
{
	//Demo in IRIS. we can put "Test"
	Q "care evolution"
}

ClassMethod DownloadDate(json As %DynamicObject) As %Library.TimeStamp [ Private ]
{
	Q ""
}

ClassMethod GenerateNum(json As %DynamicObject) As %Integer [ Private ]
{
	// генерим автоматически, произвольный номер
	set resourceType = jsonObj."resourceType"
	if resourceType '= "" Q $I(^GenerateNum(resourceType))
	Q $I(^GenerateNum)
}

}

