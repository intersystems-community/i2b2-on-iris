Class I2B2onFHIR.Processes.Main Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Parameter DESTINATION = "Operations.SaveDataToI2B2";

Method OnRequest(pRequest As Ens.StreamContainer, Output pResponse As Ens.Response) As %Status
{
    s sc = $$$OK
    try {
        set json = ""
        while 'pRequest.Stream.AtEnd
        {
            set json = json_pRequest.Stream.Read()
        }
        
        set jsonObj = {}.%FromJSON(json)

        ; check resource type
        set resourceType = jsonObj."resource"."resourceType"
        ; maybe ther is difference
        if (resourceType = "")  {
        	set resourceType = jsonObj."resourceType"
        }
        
        ; process resource type
        if resourceType = "Patient" {
            set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
            set transformRequest.json = jsonObj
            
            set sc = ##class(I2B2onFHIR.Transformations.Patient).Transform(transformRequest, .transformResponse)
            quit:$$$ISERR(sc)

            //if we have no errors - save data
            s sc = ..SendRequestSync(..#DESTINATION, transformResponse, .resp)


        } elseif resourceType = "Procedure" {
            set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
            set transformRequest.json = jsonObj
            
            set sc = ##class(I2B2onFHIR.Transformations.Procedure).Transform(transformRequest, .transformResponse)
            quit:$$$ISERR(sc)

            //if we have no errors - save data
            s sc = ..SendRequestSync(..#DESTINATION, transformResponse, .resp)


        } elseif resourceType = "Practitioner" {
            set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
            set transformRequest.json = jsonObj
            
            set sc = ##class(I2B2onFHIR.Transformations.Practitioner).Transform(transformRequest, .transformResponse)
            quit:$$$ISERR(sc)

            //if we have no errors - save data
            s sc = ..SendRequestSync(..#DESTINATION, transformResponse, .resp)

        } elseif resourceType = "Encounter" {
            set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
            set transformRequest.json = jsonObj
            
            set sc = ##class(I2B2onFHIR.Transformations.Encounter).Transform(transformRequest, .transformResponse)
            quit:$$$ISERR(sc)

            //if we have no errors - save data
            s sc = ..SendRequestSync(..#DESTINATION, transformResponse, .resp)

        } elseif resourceType = "ExplanationOfBenefit" {
            set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
            set transformRequest.json = jsonObj
            
            set sc = ##class(I2B2onFHIR.Transformations.ExplanationOfBenefit).Transform(transformRequest, .transformResponse)
            quit:$$$ISERR(sc)

            //if we have no errors - save data
            s sc = ..SendRequestSync(..#DESTINATION, transformResponse, .resp)

        } elseif resourceType = "Condition" {
            set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
            set transformRequest.json = jsonObj
            
            set sc = ##class(I2B2onFHIR.Transformations.Condition).Transform(transformRequest, .transformResponse)
            quit:$$$ISERR(sc)

            //if we have no errors - save data
            s sc = ..SendRequestSync(..#DESTINATION, transformResponse, .resp)

        } elseif resourceType = "Claim" {
            set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
            set transformRequest.json = jsonObj
            
            set sc = ##class(I2B2onFHIR.Transformations.Claim).Transform(transformRequest, .transformResponse)
            quit:$$$ISERR(sc)

            //if we have no errors - save data
            s sc = ..SendRequestSync(..#DESTINATION, transformResponse, .resp)

        } elseif resourceType = "AuditEvent" {
            set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
            set transformRequest.json = jsonObj
            
            set sc = ##class(I2B2onFHIR.Transformations.AuditEvent).Transform(transformRequest, .transformResponse)
            quit:$$$ISERR(sc)

            //if we have no errors - save data
            s sc = ..SendRequestSync(..#DESTINATION, transformResponse, .resp)

        } elseif resourceType = "" {
            $$$TRACE("Empty resource type")
            s sc = $$$ERROR($$$GeneralError, "Empty resource type")

        } else {
            $$$TRACE("Unknown resource type "_resourceType)
            s sc = $$$ERROR($$$GeneralError, "Unknown resource type "_resourceType)

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

