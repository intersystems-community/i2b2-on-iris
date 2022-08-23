Class I2B2onFHIR.Transformations.Base Extends Ens.DataTransform
{

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

ClassMethod DownloadDate(json As %DynamicObject) As %Library.TimeStamp [ Private ]
{
	Q ""
}

ClassMethod PatientNum(json As %DynamicObject) As %Integer [ Private ]
{
	// генерим автоматически, произвольный номер
	Q $tr($now(),".,")
}

}

