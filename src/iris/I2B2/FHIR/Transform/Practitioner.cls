/// Base class for all transformations
Class I2B2.FHIR.Transform.Practitioner Extends I2B2.FHIR.Transform.Base
{

ClassMethod Transform(source As I2B2.FHIR.Proxy.Practitioner, target As HS.FHIR.DTL.vR4.Model.Resource.Practitioner) As %Status
{
	s sc = $$$OK
	try {
		s target = ##class(HS.FHIR.DTL.vR4.Model.Resource.Practitioner).%New()
		s target.id = source.ResourceId

		s lookup = "I2B2.FHIR.Lookup.Practitioner"

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
		i $tr(source.Provider.importdate, $c(0)) '= "" {
			s identifier.periodNewObject().start = $e(source.Provider.importdate, 1, 10)
		}
		d target.identifier.Insert(identifier)

		// name
		i (source.Provider.namechar '= "") {
			s humanName = ##class(HS.FHIR.DTL.vR4.Model.Datatype.HumanName).%New()
			s humanName.use = ..Lookup(lookup,"name_use")
			s humanName.family = $ZSTRIP($p(source.Provider.namechar, ",", 1), "<>W")
			s given = $ZSTRIP($p(source.Provider.namechar, ",", 2), "<>W")
			d:given'="" humanName.given.Insert(given)
			s suffix = $ZSTRIP($p(source.Provider.namechar, ",", 3), "<>W")
			d:suffix'="" humanName.suffix.Insert(suffix)
			d target.name.Insert(humanName)
		}


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
