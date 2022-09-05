/// Base class for all transformations
Class I2B2.FHIR.Transform.MedicationRequest Extends I2B2.FHIR.Transform.Base
{

ClassMethod Transform(source As I2B2.FHIR.Proxy.MedicationRequest, target As HS.FHIR.DTL.vR4.Model.Resource.MedicationRequest) As %Status
{
	s sc = $$$OK
	try {
		s target = ##class(HS.FHIR.DTL.vR4.Model.Resource.MedicationRequest).%New()
		s target.id = source.ResourceId

		s lookup = "I2B2.FHIR.Lookup.MedicationRequest"

		// internal
		s identifier = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Identifier).%New()
		s identifier.value = source.ResourceId
		s identifier.use = ..Lookup(lookup,"identifier_use")
		s identifier.system = ..Lookup(lookup,"identifier_system")
		s assignerDisplay = ..Lookup(lookup,"identifier_assigner_display")
		i assignerDisplay '= "" {
			s identifier.assignerNewObject().display = assignerDisplay
		}
		s typeCodingSystem = ..Lookup(lookup,"identifier_type_coding_system")
		s typeCodingCode = ..Lookup(lookup,"identifier_type_coding_code")
		i (typeCodingSystem '= "")||(typeCodingCode '= "") {
			s coding = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Coding).%New()
			s coding.system = typeCodingSystem
			s coding.code = typeCodingCode
			d identifier.typeNewObject().coding.Insert(coding)
		}
		i $tr(source.ObservationFact.importdate, $c(0)) '= "" {
			s identifier.periodNewObject().start = $e(source.ObservationFact.importdate, 1, 10)
		}
		d target.identifier.Insert(identifier)

		#dim subject As HS.FHIR.DTL.vR4.Model.Base.Reference = ##class(HS.FHIR.DTL.vR4.Model.Base.Reference).%New()
		s subject.reference = "Patient/"_##class(I2B2.FHIR.Proxy.Patient).getResourceIdByPatientId(source.ObservationFact.patientnum)
		s target.subject = subject

		// todo
		s target.intent = "order"
		s target.status = "active"
		#dim medicationCodeableConcept As HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept = ##class(HS.FHIR.DTL.vR4.Model.Datatype.CodeableConcept).%New()
		s target.medicationCodeableConcept = medicationCodeableConcept

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

/// Patient.gender
ClassMethod convertGender(sex) As %String
{
	s sex = ..Lookup("I2B2.FHIR.Lookup.Gender", sex)
	s:sex="" sex = ..Lookup("I2B2.FHIR.Lookup.Gender", "unknown")
	return sex
}

}
