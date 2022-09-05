Class I2B2onFHIR.Processes.ExportFhir2File Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Parameter DESTINATIONGETFHIR = "I2B2onFHIR.Operations.GetFHIR";

Parameter DESTINATIONSAVEFHIR = "I2B2onFHIR.Operations.SaveFHIR";

Parameter BASEURL = "i2b2/fhir/r4/";

Parameter ACCEPTHEADER = "application/json";

Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
    set sc = $$$OK
	#dim getRequest As EnsLib.HTTP.GenericMessage
	#dim getResponse As EnsLib.HTTP.GenericMessage
	#dim saveRequest As Ens.StreamContainer
	#dim saveResponse As %Persistent
	try {
		s pResponse = ##class(Ens.Response).%New()

		// Get patient, practitioner, medication reqest
		if pRequest.%IsA("I2B2onFHIR.Messages.ExportPatient2FhirRequest") 
		   || pRequest.%IsA("I2B2onFHIR.Messages.ExportPractitioner2FhirRequest")
		   || pRequest.%IsA("I2B2onFHIR.Messages.ExportMedicationRequest2FhirRequest") {
			// Get FHIR
			s getRequest = ##class(EnsLib.HTTP.GenericMessage).%New()
			d getRequest.HTTPHeaders.SetAt(..#BASEURL_pRequest.%GetParameter("ENDPOINT")_"/"_pRequest.Identifier, "url")
			d getRequest.HTTPHeaders.SetAt("GET", "httprequest")
			d getRequest.HTTPHeaders.SetAt(..#ACCEPTHEADER, "Accept")
			s sc = ..SendRequestSync(..#DESTINATIONGETFHIR, getRequest, .getResponse)
			q:$$$ISERR(sc)
			i '$iso(getResponse)||'$iso(getResponse.Stream)||(getResponse.Stream.Size '> 0) {
				s sc = $$$ERROR($$$GeneralError, "Empty response")
				q
			}
			// Save FHIR to file
			s saveRequest = ##class(Ens.StreamContainer).%New(getResponse.Stream)
			s saveRequest.OriginalFilename = pRequest.FileName
			s sc = ..SendRequestSync(..#DESTINATIONSAVEFHIR, saveRequest, .saveResponse)

		// Search patients
		} elseif pRequest.%IsA("I2B2onFHIR.Messages.ExportPatientSearch2FhirRequest") {
			// Get FHIR
			s getRequest = ##class(EnsLib.HTTP.GenericMessage).%New()
			d getRequest.HTTPHeaders.SetAt(..#BASEURL_pRequest.%GetParameter("ENDPOINT")_"/_search", "url")
			// search params
			s iparams=0
			d:pRequest.Identifier'="" getRequest.HTTPHeaders.SetAt("identifier="_pRequest.Identifier, "IParams_"_$i(iparams))
			d:pRequest.BirthDate'="" getRequest.HTTPHeaders.SetAt("birthdate="_pRequest.BirthDate, "IParams_"_$i(iparams))
			d:pRequest.DeathDate'="" getRequest.HTTPHeaders.SetAt("death-date="_pRequest.DeathDate, "IParams_"_$i(iparams))
			d:pRequest.Deceased'="" getRequest.HTTPHeaders.SetAt("deceased="_pRequest.Deceased, "IParams_"_$i(iparams))
			d:pRequest.AddressCountry'="" getRequest.HTTPHeaders.SetAt("address-country="_pRequest.AddressCountry, "IParams_"_$i(iparams))
			d:pRequest.AddressUse'="" getRequest.HTTPHeaders.SetAt("address-use="_pRequest.AddressUse, "IParams_"_$i(iparams))
			d:pRequest.AddressState'="" getRequest.HTTPHeaders.SetAt("address-state="_pRequest.AddressState, "IParams_"_$i(iparams))
			d:pRequest.AddressCity'="" getRequest.HTTPHeaders.SetAt("address-city="_pRequest.AddressCity, "IParams_"_$i(iparams))
			d:pRequest.AddressPostalcode'="" getRequest.HTTPHeaders.SetAt("address-postalcode="_pRequest.AddressPostalcode, "IParams_"_$i(iparams))
			d:pRequest.Address'="" getRequest.HTTPHeaders.SetAt("address="_pRequest.Address, "IParams_"_$i(iparams))
			d:pRequest.Gender'="" getRequest.HTTPHeaders.SetAt("gender="_pRequest.Gender, "IParams_"_$i(iparams))
			d:pRequest.Given'="" getRequest.HTTPHeaders.SetAt("given="_pRequest.Given, "IParams_"_$i(iparams))
			d:pRequest.Family'="" getRequest.HTTPHeaders.SetAt("family="_pRequest.Family, "IParams_"_$i(iparams))
			d getRequest.HTTPHeaders.SetAt(iparams, "iparams")

			d getRequest.HTTPHeaders.SetAt(..#ACCEPTHEADER, "Accept")
			s sc = ..SendRequestSync(..#DESTINATIONGETFHIR, getRequest, .getResponse)
			q:$$$ISERR(sc)
			i '$iso(getResponse)||'$iso(getResponse.Stream)||(getResponse.Stream.Size '> 0) {
				s sc = $$$ERROR($$$GeneralError, "Empty response")
				q
			}
			// Save FHIR to file
			s saveRequest = ##class(Ens.StreamContainer).%New(getResponse.Stream)
			s saveRequest.OriginalFilename = pRequest.FileName
			s sc = ..SendRequestSync(..#DESTINATIONSAVEFHIR, saveRequest, .saveResponse)

		// Search practitioner
		} elseif pRequest.%IsA("I2B2onFHIR.Messages.ExportPractitionerSearch2FhirRequest") {
			// Get FHIR
			s getRequest = ##class(EnsLib.HTTP.GenericMessage).%New()
			d getRequest.HTTPHeaders.SetAt(..#BASEURL_pRequest.%GetParameter("ENDPOINT")_"/_search", "url")
			// search params
			s iparams=0
			d:pRequest.Identifier'="" getRequest.HTTPHeaders.SetAt("identifier="_pRequest.Identifier, "IParams_"_$i(iparams))
			d:pRequest.Given'="" getRequest.HTTPHeaders.SetAt("given="_pRequest.Given, "IParams_"_$i(iparams))
			d:pRequest.Family'="" getRequest.HTTPHeaders.SetAt("family="_pRequest.Family, "IParams_"_$i(iparams))
			d getRequest.HTTPHeaders.SetAt(iparams, "iparams")

			d getRequest.HTTPHeaders.SetAt(..#ACCEPTHEADER, "Accept")
			s sc = ..SendRequestSync(..#DESTINATIONGETFHIR, getRequest, .getResponse)
			q:$$$ISERR(sc)
			i '$iso(getResponse)||'$iso(getResponse.Stream)||(getResponse.Stream.Size '> 0) {
				s sc = $$$ERROR($$$GeneralError, "Empty response")
				q
			}
			// Save FHIR to file
			s saveRequest = ##class(Ens.StreamContainer).%New(getResponse.Stream)
			s saveRequest.OriginalFilename = pRequest.FileName
			s sc = ..SendRequestSync(..#DESTINATIONSAVEFHIR, saveRequest, .saveResponse)

		// Search medication request
		} elseif pRequest.%IsA("I2B2onFHIR.Messages.ExportMedicationRequestSearch2FhirRequest") {
			// Get FHIR
			s getRequest = ##class(EnsLib.HTTP.GenericMessage).%New()
			d getRequest.HTTPHeaders.SetAt(..#BASEURL_pRequest.%GetParameter("ENDPOINT")_"/_search", "url")
			// search params
			s iparams=0
			d:pRequest.Identifier'="" getRequest.HTTPHeaders.SetAt("identifier="_pRequest.Identifier, "IParams_"_$i(iparams))
			d getRequest.HTTPHeaders.SetAt(iparams, "iparams")

			d getRequest.HTTPHeaders.SetAt(..#ACCEPTHEADER, "Accept")
			s sc = ..SendRequestSync(..#DESTINATIONGETFHIR, getRequest, .getResponse)
			q:$$$ISERR(sc)
			i '$iso(getResponse)||'$iso(getResponse.Stream)||(getResponse.Stream.Size '> 0) {
				s sc = $$$ERROR($$$GeneralError, "Empty response")
				q
			}
			// Save FHIR to file
			s saveRequest = ##class(Ens.StreamContainer).%New(getResponse.Stream)
			s saveRequest.OriginalFilename = pRequest.FileName
			s sc = ..SendRequestSync(..#DESTINATIONSAVEFHIR, saveRequest, .saveResponse)
		} else {
			s sc = $$$ERROR($$$GeneralError, "Unsupported request: "_pRequest.%ClassName(1))
		}
		
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
