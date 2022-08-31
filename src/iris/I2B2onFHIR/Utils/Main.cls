Class I2B2onFHIR.Utils.Main
{

/// w ##class(I2B2onFHIR.Utils.Main).testGetI2B2ID()
/// test method
ClassMethod testGetI2B2ID(resourceName As %String = "", FHIRID As %String = "", searchFlag = 0, i2b2Link) As %String
{
	s cls = ##class(I2B2onFHIR.Storage.Ids).%OpenId(2)
	s lb = cls.i2b2Link
	w $lg(lb,1),!
	w $lg(lb,2),!
	w $lg(lb,3),!
}

/// 20220824 Denis Bulashev
/// returns new ID for I2B2 record based on FHIR resource name and resource ID
/// in case if record already exists - returns an ID which was generated before
/// this may be used to find an existing parent record and get some date from it
/// 
/// searchFlag [0/1] - if 1 - doesn't create a new record in the table and return empty string
/// 
/// w ##class(I2B2onFHIR.Utils.Main).getI2B2ID(1,2,0,$lb(1,2,3))
ClassMethod getI2B2ID(resourceName As %String = "", FHIRID As %String = "", searchFlag = 0, i2b2Link = "") As %String
{
	quit:resourceName="" ""
	quit:FHIRID="" ""

	set resourceName = $ZCVT(resourceName,"L")
	set FHIRID = $ZCVT(FHIRID,"L")

	set ret = ""

	// check if record already exists
	set sql = "SELECT i2b2Id FROM I2B2onFHIR_storage.Ids WHERE resourceName = ? AND fhirId = ?"
  
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(sql)
	quit:$$$ISERR(sc) ret

	set tr = ts.%Execute(resourceName, FHIRID)
	if tr.%Next() {
		set ret = tr.i2b2Id
	
	} else {
        if searchFlag = 0 {
            // new record
            s sql = "INSERT INTO I2B2onFHIR_storage.Ids (resourceName, fhirId, i2b2Id, i2b2Link) VALUES (?,?,?,?)"
            
            set rs=##class(%ResultSet).%New()
            Set sc=rs.Prepare(sql)
            quit:$$$ISERR(sc) ret

            set i2b2Id = $i(^Ids(resourceName))
			/*if i2b2Link="" {
				set i2b2Link = $lb(i2b2Id)
			}*/
			if ",patient,encounter,"[(","_resourceName_",") {
				set i2b2Link = $lb(i2b2Id)_i2b2Link
			}
            set sc=rs.Execute(resourceName, FHIRID, i2b2Id, i2b2Link)
            quit:$$$ISERR(sc) ret

            set ret = i2b2Id

        } else {
            set ret = ""

        }

	}

	q ret
}

/// Select from Table and return ID for Field with Value
ClassMethod getIDfromTable(Table As %String = "", Field As %String = "", Value As %String = "", Output ID As %String) As %Status
{
	set ID = -1
	if Table = "" Q $$$ERROR("Empty Table name")
	if Field = "" Q $$$ERROR("Empty Field name")
	if Value = "" Q $$$ERROR("Empty Value")
	set sc = $$$OK
	set ID = -1
    try {
      set sql = "SELECT %ID FROM "_Table_" WHERE "_Field_" = ?"
      
      set ts = ##class(%SQL.Statement).%New()
      set sc=ts.%Prepare(sql)
      quit:$$$ISERR(sc)

      set tr = ts.%Execute(Value)
      if tr.%Next() {
        set ID = tr.%ID
      } 
 	} 
	catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}

