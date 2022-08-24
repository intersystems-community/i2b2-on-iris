Class I2B2onFHIR.Transformations.Base Extends Ens.DataTransform
{

ClassMethod Transform(source As I2B2onFHIR.Messages.dataTransformRequestBase, target As Ens.Response) As %Status
{
	s sc = $$$OK
	try {
        set target = ##class(Ens.Response).%New()
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
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
	Q $tr($now(),".,")
}

}

