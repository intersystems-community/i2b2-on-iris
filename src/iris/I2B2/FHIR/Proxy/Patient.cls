Class I2B2.FHIR.Proxy.Patient Extends I2B2.FHIR.Proxy.Base
{

Property PatientId As %String(MAXLEN = "");

Property Patient As public.patientdimension;

Property MRN As %String(MAXLEN = "");

Property MRNDate As %TimeStamp;

Property LName As %String(MAXLEN = "");

Property FName As %String(MAXLEN = "");

Property Key As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = "Patient/"_{ResourceId}}, SqlComputed ];

Property ResourceType As %String(COLLATION = "") [ InitialExpression = "Patient" ];

Property ResourceId As %String(MAXLEN = "");

ClassMethod getPatientId(pResourceId As %String) As %String
{
	set sql = "SELECT i2b2Link FROM I2B2onFHIR_storage.Ids LEFT JOIN I2B2onFHIR_storage.IdsLinks "_
			  "ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId "_
			  "where tableName='patient_dimension' and i2b2Id=?"

	set ts = ##class(%SQL.Statement).%New()
	set sc=ts.%Prepare(sql)
	i $$$ISERR(sc) $$$ThrowFHIR($$$GeneralError, $system.Status.GetErrorText(sc))

	set tr = ts.%Execute(pResourceId)
	if (tr.%Next() && (tr.i2b2Link '= "")) {
		q $lg(tr.i2b2Link, 1)
	} else {
		q ""
	}
}

ClassMethod getResourceIdByPatientId(pPatientId As %String) As %String
{
	set sql = "SELECT fhirId FROM I2B2onFHIR_storage.Ids LEFT JOIN I2B2onFHIR_storage.IdsLinks "_
			  "ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId "_
			  "where tableName='patient_dimension' and $LISTGET(i2b2Link, 1)=?"

	set ts = ##class(%SQL.Statement).%New()
	set sc=ts.%Prepare(sql)
	i $$$ISERR(sc) $$$ThrowFHIR($$$GeneralError, $system.Status.GetErrorText(sc))

	set tr = ts.%Execute(pPatientId)
	if (tr.%Next()) {
		q tr.fhirId
	} else {
		q ""
	}
}

/// Check if resource exists
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Patient/123"
ClassMethod KeyIdxExists(rsrcKey As %String) As %Boolean
{
	s pResourceId = $p(rsrcKey, "/", 2)

	s patientId = ..getPatientId(pResourceId)
	if patientId'="" {
		q ##class(public.patientdimension).patientdimensionpkExists(patientId)
	} else {
		q 0
	}
}

/// Get resource
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Patient/123"
ClassMethod KeyIdxOpen(rsrcKey As %String, empty, tSC As %Status) As I2B2.FHIR.Proxy.Base
{
	s tSC=$$$OK
	s pResourceType = $p(rsrcKey, "/")
	s pResourceId = $p(rsrcKey, "/", 2)
	s patientId = ..getPatientId(pResourceId)

	i patientId="" {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
	s patientDimension = ##class(public.patientdimension).patientdimensionpkOpen(patientId)
	i '$iso(patientDimension) {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
	s proxy = ..%New()
	s proxy.PatientId = patientId
	s proxy.ResourceId = pResourceId
	s proxy.Patient = patientDimension

	// MRN
	s (SQLCODE,mrn,date) = ""
	&sql(select tval_char, import_date into :mrn, :date from "public".observation_fact where concept_cd = 'PHI:MRN' and patient_num = :patientId)
	i SQLCODE<0 {
		s errText="Ошибка исполнения SQL запроса ""select tval_char from ""public"".observation_fact where concept_cd = 'PHI:MRN' and patient_num = "_patientId_""":"_$SYSTEM.SQL.SQLCODE(SQLCODE)
		s tSC = $$$ERROR($$$GeneralError, errText)
	} else {
		s proxy.MRN = mrn
		s proxy.MRNDate = date
	}

	// Patient.name
	s (lName,fName) = ""
	&sql(select tval_char into :lName from "public".observation_fact where concept_cd = 'PHI:LNAME' and patient_num = :patientId)
	i SQLCODE<0 {
		s errText="Ошибка исполнения SQL запроса ""select tval_char from ""public"".observation_fact where concept_cd = 'PHI:LNAME' and patient_num = "_patientId_""":"_$SYSTEM.SQL.SQLCODE(SQLCODE)
		s tSC = $$$ERROR($$$GeneralError, errText)
	} else {
		s proxy.LName = lName
	}
	&sql(select tval_char into :fName from "public".observation_fact where concept_cd = 'PHI:FNAME' and patient_num = :patientId)
	i SQLCODE<0 {
		s errText="Ошибка исполнения SQL запроса ""select tval_char from ""public"".observation_fact where concept_cd = 'PHI:FNAME' and patient_num = "_patientId_""":"_$SYSTEM.SQL.SQLCODE(SQLCODE)
		s tSC = $$$ERROR($$$GeneralError, errText)
	} else {
		s proxy.FName = fName
	}

	q proxy
}

Method Transform() As %Library.DynamicObject
{
	#dim patientResource As HS.FHIR.DTL.vR4.Model.Resource.Patient
	s sc = ##class(I2B2.FHIR.Transform.Patient).Transform(##this, .patientResource)
	i $$$ISERR(sc) {
		$$$ThrowFHIR($$$GeneralError, $system.Status.GetErrorText(sc))
	} else {
		q ##class(%DynamicObject).%FromJSON(patientResource.ToJSON())
	}
}

}

