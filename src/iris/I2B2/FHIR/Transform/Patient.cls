/// Base class for all transformations
Class I2B2.FHIR.Transform.Patient Extends I2B2.FHIR.Transform.Base
{

ClassMethod Transform(source As I2B2.FHIR.Proxy.Patient, target As HS.FHIR.DTL.vR4.Model.Resource.Patient) As %Status
{
	s sc = $$$OK
	try {
		s target = ##class(HS.FHIR.DTL.vR4.Model.Resource.Patient).%New()
		s target.id = source.PatientId

		s patientId = source.PatientId
		s lookup = "I2B2.FHIR.Lookup.Patient"

		// internal
		s identifier = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Identifier).%New()
		s identifier.value = patientId
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
		i $tr(source.Patient.importdate, $c(0)) '= "" {
			s identifier.periodNewObject().start = $e(source.Patient.importdate, 1, 10)
		}
		d target.identifier.Insert(identifier)

		// MRN
		i source.MRN '= "" {
			s identifier = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Identifier).%New()
			s identifier.value = source.MRN
			s identifier.use = ..Lookup(lookup,"identifier-mrn_use")
			s identifier.system = ..Lookup(lookup,"identifier-mrn_system")
			s assignerDisplay = ..Lookup(lookup,"identifier-mrn_assigner_display")
			i assignerDisplay '= "" {
				s identifier.assignerNewObject().display = assignerDisplay
			}
			s typeCodingSystem = ..Lookup(lookup,"identifier-mrn_type_coding_system")
			s typeCodingCode = ..Lookup(lookup,"identifier-mrn_type_coding_code")
			i (typeCodingSystem '= "")||(typeCodingCode '= "") {
				s coding = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Coding).%New()
				s coding.system = typeCodingSystem
				s coding.code = typeCodingCode
				d identifier.typeNewObject().coding.Insert(coding)
			}
			s date = source.MRNDate
			s:date="" date=$tr(source.Patient.importdate, $c(0))
			i date '= "" {
				s identifier.periodNewObject().start = $e(date, 1, 10)
			}
			d target.identifier.Insert(identifier)
		}

		//
		s target.birthDate = $e($tr(source.Patient.birthdate, $c(0)), 1, 10)

		// Patient.name
		i (source.LName '= "")||(source.FName '= "") {
			s humanName = ##class(HS.FHIR.DTL.vR4.Model.Datatype.HumanName).%New()
			s humanName.use = ..Lookup(lookup,"name_use")
			s humanName.family = source.LName
			d:source.FName'="" humanName.given.Insert(source.FName)
			d target.name.Insert(humanName)
		}

		// Patient.deceased. deceasedBoolean
		// Patient.deceased.deceasedDateTime
		i $tr(source.Patient.deathdate, $c(0)) '= "" {
			s target.deceasedBoolean = 1
			s target.deceasedDateTime = $e(source.Patient.deathdate, 1, 10)
		} else {
			s target.deceasedBoolean = 0
		}

		// Patient.gender
		s sex = source.Patient.sexcd
		s sex = ..Lookup("I2B2.FHIR.Lookup.Gender", sex)
		s:sex="" sex = ..Lookup("I2B2.FHIR.Lookup.Gender", "unknown")
		s target.gender = sex

		// Patient.extension: patient-nationality
		i $tr(source.Patient.racecd, $c(0)) '= "" {
			s data = ..Lookup("I2B2.FHIR.Lookup.RacePatientNationality", source.Patient.racecd)
			s:data="" data = ..Lookup("I2B2.FHIR.Lookup.RacePatientNationality", "unknown")
			i data '= "" {
				s extension = ##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()
				s extension.url = ..Lookup(lookup,"patient-nationality_url")
				s extension.valueCodingNewObject().system = ..Lookup(lookup,"patient-nationality_system")
				s extension.valueCoding.code = $p(data, "~")
				s extension.valueCoding.display = $p(data, "~", 2, *)
				d target.extension.Insert(extension)
			}
		}

#;		// Patient.extension: us-core-race
#;		i $tr(source.Patient.racecd, $c(0)) '= "" {
#;			s race = ..Lookup("I2B2.FHIR.Lookup.Race", source.Patient.racecd)
#;			i race '= "" {
#;				s extension = ##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()
#;				s extension.url = ..Lookup(lookup,"us-core-race_url")
#;				s extension.valueCodingNewObject().system = ..Lookup(lookup,"us-core-race_system")
#;				s extension.valueCoding.code = $p(race, "~")
#;				s extension.valueCoding.display = $p(race, "~", 2, *)
#;				d target.extension.Insert(extension)
#;			}
#;		}

		// Patient.extension: patient-religion
		i $tr(source.Patient.religioncd, $c(0)) '= "" {
			s data = ..Lookup("I2B2.FHIR.Lookup.Religion", source.Patient.religioncd)
			i data '= "" {
				s extension = ##class(HS.FHIR.DTL.vR4.Model.Base.Extension).%New()
				s extension.url = ..Lookup(lookup,"patient-religion_url")
				s extension.valueCodingNewObject().system = ..Lookup(lookup,"patient-religion_system")
				s extension.valueCoding.code = $p(data, "~")
				s extension.valueCoding.display = $p(data, "~", 2, *)
				d target.extension.Insert(extension)
			}
		}

		// Patient.communication.language
		// Patient.communication.preferred
		i $tr(source.Patient.languagecd, $c(0)) '= "" {
			s data = ..Lookup("I2B2.FHIR.Lookup.CommunicationLanguage", source.Patient.languagecd)
			i data '= "" {
				s communication = ##class(HS.FHIR.DTL.vR4.Model.Element.Patient.communication).%New()
				s communication.preferred = 1
				s coding = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Coding).%New()
				s coding.system = ..Lookup(lookup,"communication-language_system")
				s coding.code = $p(data, "~")
				s coding.display = $p(data, "~", 2, *)
				d communication.languageNewObject().coding.Insert(coding)
				d target.communication.Insert(communication)
			}
		}

		// Patient.maritalStatus
		s data = ""
		i $tr(source.Patient.maritalstatuscd, $c(0)) '= "" {
			s data = ..Lookup("I2B2.FHIR.Lookup.MaritalStatus", source.Patient.maritalstatuscd)
		}
		s:data="" data = ..Lookup("I2B2.FHIR.Lookup.MaritalStatus", "unknown")
		i data '= "" {
			s coding = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Coding).%New()
			s coding.system = ..Lookup(lookup,"marital-status_system")
			s coding.code = $p(data, "~")
			s coding.display = $p(data, "~", 2, *)
			d target.maritalStatusNewObject().coding.Insert(coding)
		}

		// Patient.address
		s statecityzippath = $tr(source.Patient.statecityzippath, $c(0))
		i $l(statecityzippath, "\") > 4 {
			s address = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Address).%New()
			s address.use = ..Lookup(lookup,"address_use")
			s address.type = ..Lookup(lookup,"address_type")
			s address.city = $p(statecityzippath, "\", 3)
			s address.state = $p(statecityzippath, "\", 2)
			s address.postalCode = $tr(source.Patient.zipcd, $c(0))
			s address.country = ..Lookup(lookup,"address_country")
			d target.address.Insert(address)
		}

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

}
