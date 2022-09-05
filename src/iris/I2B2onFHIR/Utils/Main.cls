Class I2B2onFHIR.Utils.Main
{

/// d ##class(I2B2onFHIR.Utils.Main).clearIndexcesTables()
ClassMethod clearIndexcesTables()
{
	s SQL = "TRUNCATE TABLE I2B2onFHIR_storage.IdsLinks"
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""
	set tr = ts.%Execute()

	s SQL = "TRUNCATE TABLE I2B2onFHIR_storage.Ids"
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""
	set tr = ts.%Execute()
}

/// d ##class(I2B2onFHIR.Utils.Main).generateLinksForTestData()
ClassMethod generateLinksForTestData()
{
	w "Processing patient_mapping",!
	; Index patientmappingpk On (patientide, patientidesource, projectid)
	
	s SQL = "SELECT %ID, patient_ide, patient_ide_source, project_id, patient_num FROM patient_mapping"
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute()
	;do tr.%Display()
	while tr.%Next() {
		set recId = tr.ID
		; try to recieve fhir ID from ids table
		; all records are different
		set fhirId = ..getFhirRecordID("patient", tr."patient_num")

		;w "|"_fhirId_"|",!

		if fhirId = "" {
			; create record in ids table
			; bad way !!!
			set idsCls = ##class(I2B2onFHIR.Storage.Ids).%New()
			set idsCls.resourceName = "patient"
			set idsCls.fhirId = ##class(%SYSTEM.Util).CreateGUID()
			set idsCls.i2b2Id = tr."patient_num"
			set sc = idsCls.%Save()
			if $$$ISERR(sc) w "Data saving error",!  q
			set lastInsertId = idsCls.%Id()
		
		} else {
			set lastInsertId = fhirId

		}
		; check if we already have such record and remove it
		s SQL = "DELETE FROM I2B2onFHIR_Storage.IdsLinks WHERE tableName = ? AND idsId = ?"
		set ts = ##class(%SQL.Statement).%New()
		set sc = ts.%Prepare(SQL)
		quit:$$$ISERR(sc)
		set tr2 = ts.%Execute(lastInsertId, "patient_mapping")

		set idsLinksCls = ##class(I2B2onFHIR.Storage.IdsLinks).%New()
		set idsLinksCls.idsId = lastInsertId
		set idsLinksCls.tableName = "patient_mapping"
		set idsLinksCls.i2b2Link = $lb(tr."patient_ide", tr."patient_ide_source", tr."project_id")
		set sc = idsLinksCls.%Save()
		if $$$ISERR(sc) w "Data saving error",!  q
	}
	
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	w !,!,"Processing patient_dimension",!
	; Index patientdimensionpk On patientnum
	
	s SQL = "SELECT %ID, patient_num FROM patient_dimension"
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute()
	;do tr.%Display()
	while tr.%Next() {
		set recId = tr.ID
		; try to recieve fhir ID from ids table
		set fhirId = ..getFhirRecordID("patient", tr."patient_num")

		;w "|"_fhirId_"|",!

		if fhirId = "" {
			; create record in ids table
			; bad way !!!
			set idsCls = ##class(I2B2onFHIR.Storage.Ids).%New()
			set idsCls.resourceName = "patient"
			set idsCls.fhirId = ##class(%SYSTEM.Util).CreateGUID()
			set idsCls.i2b2Id = tr."patient_num"
			set sc = idsCls.%Save()
			if $$$ISERR(sc) w "Data saving error",!  q
			set lastInsertId = idsCls.%Id()
		
		} else {
			set lastInsertId = fhirId

		}
		; check if we already have such record and remove it
		s SQL = "DELETE FROM I2B2onFHIR_Storage.IdsLinks WHERE tableName = ? AND idsId = ?"
		set ts = ##class(%SQL.Statement).%New()
		set sc = ts.%Prepare(SQL)
		quit:$$$ISERR(sc)
		set tr2 = ts.%Execute(lastInsertId, "patient_dimension")


		set idsLinksCls = ##class(I2B2onFHIR.Storage.IdsLinks).%New()
		set idsLinksCls.idsId = lastInsertId
		set idsLinksCls.tableName = "patient_dimension"
		set idsLinksCls.i2b2Link = $lb(tr."patient_num")
		set sc = idsLinksCls.%Save()
		if $$$ISERR(sc) w "Data saving error",!  q
	}

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	w !,!,"Processing encounter_mapping",!
	; Index encountermappingpk On (encounteride, encounteridesource, projectid, patientide, patientidesource)
	
	s SQL = "SELECT %ID, encounter_num, encounter_ide, encounter_ide_source, project_id, patient_ide, patient_ide_source FROM encounter_mapping"
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute()
	;do tr.%Display()
	while tr.%Next() {
		set recId = tr.ID
		; try to recieve fhir ID from ids table
		set fhirId = ..getFhirRecordID("encounter", tr."encounter_num")

		;w "|"_fhirId_"|",!

		if fhirId = "" {
			; create record in ids table
			; bad way !!!
			set idsCls = ##class(I2B2onFHIR.Storage.Ids).%New()
			set idsCls.resourceName = "encounter"
			set idsCls.fhirId = ##class(%SYSTEM.Util).CreateGUID()
			set idsCls.i2b2Id = tr."encounter_num"
			set sc = idsCls.%Save()
			if $$$ISERR(sc) w "Data saving error",!  q
			set lastInsertId = idsCls.%Id()
		
		} else {
			set lastInsertId = fhirId

		}
		; check if we already have such record and remove it
		s SQL = "DELETE FROM I2B2onFHIR_Storage.IdsLinks WHERE tableName = ? AND idsId = ?"
		set ts = ##class(%SQL.Statement).%New()
		set sc = ts.%Prepare(SQL)
		quit:$$$ISERR(sc)
		set tr2 = ts.%Execute(lastInsertId, "encounter_mapping")


		set idsLinksCls = ##class(I2B2onFHIR.Storage.IdsLinks).%New()
		set idsLinksCls.idsId = lastInsertId
		set idsLinksCls.tableName = "encounter_mapping"
		set idsLinksCls.i2b2Link = $lb(tr."encounter_ide", tr."encounter_ide_source", tr."project_id", tr."patient_ide", tr."patient_ide_source")
		set sc = idsLinksCls.%Save()
		if $$$ISERR(sc) w "Data saving error",!  q
	}

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	w !,!,"Processing visit_dimension",!
	; Index visitdimensionpk On (encounternum, patientnum)
	
	s SQL = "SELECT %ID, encounter_num, patient_num FROM visit_dimension"
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute()
	;do tr.%Display()
	while tr.%Next() {
		set recId = tr.ID
		; try to recieve fhir ID from ids table
		set fhirId = ..getFhirRecordID("encounter", tr."encounter_num")

		;w "|"_fhirId_"|",!

		if fhirId = "" {
			; create record in ids table
			; bad way !!!
			set idsCls = ##class(I2B2onFHIR.Storage.Ids).%New()
			set idsCls.resourceName = "encounter"
			set idsCls.fhirId = ##class(%SYSTEM.Util).CreateGUID()
			set idsCls.i2b2Id = tr."encounter_num"
			set sc = idsCls.%Save()
			if $$$ISERR(sc) w "Data saving error",!  q
			set lastInsertId = idsCls.%Id()
		
		} else {
			set lastInsertId = fhirId

		}
		; check if we already have such record and remove it
		s SQL = "DELETE FROM I2B2onFHIR_Storage.IdsLinks WHERE tableName = ? AND idsId = ?"
		set ts = ##class(%SQL.Statement).%New()
		set sc = ts.%Prepare(SQL)
		quit:$$$ISERR(sc)
		set tr2 = ts.%Execute(lastInsertId, "visit_dimension")


		set idsLinksCls = ##class(I2B2onFHIR.Storage.IdsLinks).%New()
		set idsLinksCls.idsId = lastInsertId
		set idsLinksCls.tableName = "visit_dimension"
		set idsLinksCls.i2b2Link = $lb(tr."encounter_num", tr."patient_num")
		set sc = idsLinksCls.%Save()
		if $$$ISERR(sc) w "Data saving error",!  q
	}

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	w "Processing provider_dimension",!
	; Index providerdimensionpk On (providerpath, providerid)
	
	s resourceName="practitioner"
	s SQL = "SELECT provider_path, provider_id FROM provider_dimension"
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute()
	;do tr.%Display()
	s i2b2Id = 0
	while tr.%Next() {
		#; set recId = tr.ID
		; try to recieve fhir ID from ids table
		; all records are different
		#; set fhirId = ..getFhirRecordID(resourceName, tr."patient_num")

		#; ;w "|"_fhirId_"|",!

		#; if fhirId = "" {
			; create record in ids table
			; bad way !!!
			set idsCls = ##class(I2B2onFHIR.Storage.Ids).%New()
			set idsCls.resourceName = resourceName
			set idsCls.fhirId = ##class(%SYSTEM.Util).CreateGUID()
			set idsCls.i2b2Id = $i(i2b2Id)   //tr."patient_num"
			set sc = idsCls.%Save()
			if $$$ISERR(sc) w "Data saving error",!  q
			set lastInsertId = idsCls.%Id()
		
		#; } else {
		#; 	set lastInsertId = fhirId

		#; }
		#; ; check if we already have such record and remove it
		#; s SQL = "DELETE FROM I2B2onFHIR_Storage.IdsLinks WHERE tableName = ? AND idsId = ?"
		#; set ts = ##class(%SQL.Statement).%New()
		#; set sc = ts.%Prepare(SQL)
		#; quit:$$$ISERR(sc)
		#; set tr2 = ts.%Execute("provider_dimension", lastInsertId)

		set idsLinksCls = ##class(I2B2onFHIR.Storage.IdsLinks).%New()
		set idsLinksCls.idsId = lastInsertId
		set idsLinksCls.tableName = "provider_dimension"
		set idsLinksCls.i2b2Link = $lb(tr."provider_path", tr."provider_id")
		set sc = idsLinksCls.%Save()
		if $$$ISERR(sc) w "Data saving error",!  q
	}

	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	; Index observationfactpk On (patientnum, conceptcd, modifiercd, startdate, encounternum, instancenum, providerid)
	s resourceName="medicationRequest"
	s tableName="observation_fact"
	w !,!,"Processing "_tableName,!
	
	s SQL = "SELECT patient_num, concept_cd, modifier_cd, start_date, encounter_num, instance_num, provider_id FROM "_tableName
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute()
	;do tr.%Display()
	s i2b2Id = 0
	while tr.%Next() {
		#; set recId = tr.ID
		; try to recieve fhir ID from ids table
		; all records are different
		#; set fhirId = ..getFhirRecordID(resourceName, tr."patient_num")

		#; ;w "|"_fhirId_"|",!

		#; if fhirId = "" {
			; create record in ids table
			; bad way !!!
			set idsCls = ##class(I2B2onFHIR.Storage.Ids).%New()
			set idsCls.resourceName = resourceName
			set idsCls.fhirId = ##class(%SYSTEM.Util).CreateGUID()
			set idsCls.i2b2Id = $i(i2b2Id)   //tr."patient_num"
			set sc = idsCls.%Save()
			if $$$ISERR(sc) w "Data saving error",!  q
			set lastInsertId = idsCls.%Id()
		
		#; } else {
		#; 	set lastInsertId = fhirId

		#; }
		#; ; check if we already have such record and remove it
		#; s SQL = "DELETE FROM I2B2onFHIR_Storage.IdsLinks WHERE tableName = ? AND idsId = ?"
		#; set ts = ##class(%SQL.Statement).%New()
		#; set sc = ts.%Prepare(SQL)
		#; quit:$$$ISERR(sc)
		#; set tr2 = ts.%Execute(tableName, lastInsertId)

		set idsLinksCls = ##class(I2B2onFHIR.Storage.IdsLinks).%New()
		set idsLinksCls.idsId = lastInsertId
		set idsLinksCls.tableName = tableName
		set idsLinksCls.i2b2Link = $lb(tr."patient_num", tr."concept_cd", tr."modifier_cd", tr."start_date", tr."encounter_num", tr."instance_num", tr."provider_id")
		set sc = idsLinksCls.%Save()
		if $$$ISERR(sc) w "Data saving error",!  q
	}
}

/// Returns %ID for record by resourceName AND I2B2ID
ClassMethod getFhirRecordID(resourceName As %String = "", I2B2ID As %String = "") As %String
{
	set SQL = "SELECT %ID FROM I2B2onFHIR_storage.Ids WHERE resourceName = ? AND i2b2Id = ?"

	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute(resourceName, I2B2ID)
	;do tr.%Display()
	if tr.%Next() {
		set ret = tr."ID"
	
	} else {
		set ret =""
	
	}
	q ret
}

/// Returns FHIR id by resourceName AND I2B2ID
ClassMethod getFhirID(resourceName As %String = "", I2B2ID As %String = "") As %String
{
	set SQL = "SELECT fhirId FROM I2B2onFHIR_storage.Ids WHERE resourceName = ? AND i2b2Id = ?"

	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute(resourceName, I2B2ID)
	;do tr.%Display()
	if tr.%Next() {
		set ret = tr."fhirId"
	
	} else {
		set ret =""
	
	}
	q ret
}

/// Method is used to init start values for counters
/// in order to avoid creating duplicate ids in tables for new patients
/// 
/// d ##class(I2B2onFHIR.Utils.Main).initCounters()
ClassMethod initCounters()
{
	for table = "patient_mapping","patient_dimension","encounter_mapping","visit_dimension" {
		s maxId = ..getMaxId(table)
		if maxId'="" {
			s ^Ids(table) = maxId
		}
	}
}

/// Method gets max id from the exiting table
/// 
/// w ##class(I2B2onFHIR.Utils.Main).getMaxId("patient_mapping")
ClassMethod getMaxId(tblName = "")
{
	; SELECT MAX(patient_num) FROM patient_mapping
	; SELECT MAX(patient_num) FROM patient_dimension
	; SELECT MAX(encounter_num) FROM encounter_mapping
	; SELECT MAX(encounter_num) FROM visit_dimension
	; --- SELECT * FROM provider_dimension --- is not possible
	; --- SELECT * FROM observation_fact --- is not possible
	;
	
	set tblName = $ZCVT(tblName,"L")
	if tblName = "patient_mapping" {
		s SQL = "SELECT MAX(patient_num) FROM patient_mapping"

	} elseif tblName = "patient_dimension" {
		s SQL = "SELECT MAX(patient_num) FROM patient_dimension"

	} elseif tblName = "encounter_mapping" {
		s SQL = "SELECT MAX(encounter_num) FROM encounter_mapping"

	} elseif tblName = "visit_dimension" {
		s SQL = "SELECT MAX(encounter_num) FROM visit_dimension"
 
	} else {
		s SQL = ""
	}

	if SQL = "" q ""


	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(SQL)
	quit:$$$ISERR(sc) ""

	set tr = ts.%Execute()
	;do tr.%Display()
	if tr.%Next() {
		set ret = tr."Aggregate_1"
	
	} else {
		set ret =""
	
	}

	quit ret
}

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
/// i2b2Link - $lb with fields from primary key for the table which we create
/// tableName - name of the table, to store i2b2Link for separate tables (patient_mapping, patient_dimension, etc)
/// 
/// w ##class(I2B2onFHIR.Utils.Main).getI2B2ID(1,2,0,$lb(1,2,3))
ClassMethod getI2B2ID(resourceName As %String = "", FHIRID As %String = "", searchFlag = 0, i2b2Link = "", tableName = "") As %String
{
	quit:resourceName="" ""
	quit:FHIRID="" ""

	set resourceName = $ZCVT(resourceName,"L")
	set FHIRID = $ZCVT(FHIRID,"L")

	set ret = ""

	// check if record already exists
	set sql = "SELECT i2b2Id FROM I2B2onFHIR_storage.Ids WHERE resourceName = ? AND fhirId = ?"
	set sql = 	"SELECT * FROM I2B2onFHIR_storage.Ids "_
				"LEFT JOIN I2B2onFHIR_storage.IdsLinks "_
				"ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId "_
				"WHERE resourceName = ? AND fhirId = ? AND tableName = ?"
  
	set ts = ##class(%SQL.Statement).%New()
	set sc = ts.%Prepare(sql)
	quit:$$$ISERR(sc) ret

	set tr = ts.%Execute(resourceName, FHIRID, tableName)
	if tr.%Next() {
		set ret = tr.i2b2Id
	
	} else {
        if searchFlag = 0 {
			// check if we already have this ID
			set sql = "SELECT %ID, i2b2Id FROM I2B2onFHIR_storage.Ids WHERE resourceName = ? AND fhirId = ?"
		
			set ts = ##class(%SQL.Statement).%New()
			set sc = ts.%Prepare(sql)
			quit:$$$ISERR(sc) ret

			set tr = ts.%Execute(resourceName, FHIRID)
			if tr.%Next() {
				w "1111",!
				set ret = tr.i2b2Id
				set i2b2Id = tr.i2b2Id
				set lastInserId = tr.ID
			
			} else {
				w "2222",!
				// new record i2b2Link
				s sql = "INSERT INTO I2B2onFHIR_storage.Ids (resourceName, fhirId, i2b2Id) VALUES (?,?,?)"
				
				set rs=##class(%ResultSet).%New()
				Set sc=rs.Prepare(sql)
				quit:$$$ISERR(sc) ret
				
				set i2b2Id = $i(^Ids(resourceName))
				set tr=rs.Execute(resourceName, FHIRID, i2b2Id)
				set lastInserId = %ROWID
			}			
			

			; save link
			; check if record exists...

			s sql = "INSERT INTO I2B2onFHIR_storage.IdsLinks  (i2b2Link, idsId, tableName) VALUES (?,?,?)"
			set rs=##class(%ResultSet).%New()
			set sc=rs.Prepare(sql)
			quit:$$$ISERR(sc) ret
			
			if i2b2Link="" {
				set i2b2Link = $lb(i2b2Id)
			}
			set tr2=rs.Execute(i2b2Link, lastInserId, tableName)
			
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
        set ID = tr.ID
      } 
 	} 
	catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}
