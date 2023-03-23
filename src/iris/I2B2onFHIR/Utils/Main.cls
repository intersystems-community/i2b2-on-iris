Class I2B2onFHIR.Utils.Main
{

/// 20220824 Denis Bulashev
/// returns new ID for I2B2 record based on FHIR resource name and resource ID
/// in case if record already exists - returns an ID which was generated before
/// this may be used to find an existing parent record and get some date from it
/// 
/// searchFlag [0/1] - if 1 - doesn't create a new record in the table and return empty string
ClassMethod getI2B2ID(resourceName As %String = "", FHIRID As %String = "", searchFlag = 0) As %String
{
	quit:resourceName="" ""
	quit:FHIRID="" ""

	set resourceName = $ZCVT(resourceName,"L")
	set FHIRID = $ZCVT(FHIRID,"L")

	set ret = ""

	// check if record already exists
	set sql = "SELECT %ID FROM public_storage.Ids WHERE resourceName = ? AND fhirId = ?"
  
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(sql)
	quit:$$$ISERR(sc) ret

	set tr = ts.%Execute(resourceName, FHIRID)
	if tr.%Next() {
		set ret = tr.%ID
	
	} else {
        if searchFlag = 0 {
            // new record
            s sql = "INSERT INTO public_storage.Ids (resourceName, fhirId, birth_date, i2b2Id) VALUES (?,?,?)"
            
            set rs=##class(%ResultSet).%New()
            Set sc=rs.Prepare(sql)
            quit:$$$ISERR(sc) ret

            set i2b2Id = $i(^Ids(resourceName))
            set sc=rs.Execute(resourceName, FHIRID, i2b2Id)
            quit:$$$ISERR(sc) ret

            set ret = i2b2Id

        } else {
            set ret = ""

        }

	}

	q ret
}

}
