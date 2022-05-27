Class I2B2.FHIR.Proxy.Patient Extends I2B2.FHIR.Proxy.Base
{

Property PatientId As %String(MAXLEN = "");

Property Patient As public.patientdimension;

Property MRN As %String(MAXLEN = "");

Property MRNDate As %TimeStamp;

Property LName As %String(MAXLEN = "");

Property FName As %String(MAXLEN = "");

/// Check if resource exists
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Patient/123"
ClassMethod KeyIdxExists(rsrcKey As %String) As %Boolean
{
	s pResourceId = $p(rsrcKey, "/", 2)
	q ##class(public.patientdimension).patientdimensionpkExists(pResourceId)
}

/// Get resource
/// rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId), for example: "Patient/123"
ClassMethod KeyIdxOpen(rsrcKey As %String, empty, tSC As %Status) As I2B2.FHIR.Proxy.Base
{
	s pResourceType = $p(rsrcKey, "/")
	s (patientId, pResourceId) = $p(rsrcKey, "/", 2)

	s patientDimension = ##class(public.patientdimension).patientdimensionpkOpen(pResourceId)
	i '$iso(patientDimension) {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
	s proxy = ..%New()
	s proxy.PatientId = pResourceId
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
