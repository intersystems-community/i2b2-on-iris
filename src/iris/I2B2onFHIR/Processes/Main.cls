Class I2B2onFHIR.Processes.Main Extends Ens.BusinessProcess [ ClassType = persistent ]
{

/*
ToDo:
Унаследуй трансформации от базового класса и вынеси туда общие методы
*/
Parameter DESTINATION = "Operations.SaveDataToI2B2";

Parameter TARGETPATIENT = "Processes.Patient";

Parameter TARGETENCOUNTER = "Processes.Encounter";

Parameter TARGETPRACTITIONER = "Processes.Practitioner";

Parameter TARGETOBSERVATIONFACT = "Processes.ObservationFact";

Parameter OBSERVATIONFACTSAVE = "Operations.SaveDataToI2B2";

Parameter OBSERVATIONFACTCHECK = "Operations.CheckDataInI2B2";

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
        ;set resourceType = jsonObj."resource"."resourceType"
        set resourceType = jsonObj."resourceType"

        set resourceType = $ZCVT(resourceType,"L")

        // check resource type
        // skip unknown resources
        if ",patient,encounter,practitioner,observation,condition,procedure,medicationrequest,"'[(","_resourceType_","){
            
            // generate error ???
            $$$TRACE("Unknown resource type "_resourceType)
            quit
        }


        // work with data storage
        // 1 check that we do not have such record in the table
        set sql = "SELECT %ID FROM I2B2onFHIR_Storage.data WHERE type = ? AND content = ?"
        set ts = ##class(%SQL.Statement).%New()
		set sc=ts.%Prepare(sql)
		quit:$$$ISERR(sc)
		set tr = ts.%Execute(resourceType, json)
        if 'tr.%Next() {
            
            // 2 put new data to the storage
            set SQL = "INSERT INTO I2B2onFHIR_Storage.data (type, content) VALUES (?, ?)"
            set ts = ##class(%SQL.Statement).%New()
            set sc = ts.%Prepare(SQL)
            quit:$$$ISERR(sc)
            set tr = ts.%Execute(resourceType, json)
        }

        set patientsList = ""
        // 2 process records in particular order
        for dataType = "patient", "encounter", "practitioner", "observation" {
            
            set target = $s(dataType = "patient":..#TARGETPATIENT, dataType = "encounter":..#TARGETENCOUNTER, dataType = "practitioner":..#TARGETPRACTITIONER, 1:"")
            continue:target=""


            set SQL = "SELECT ID, content FROM I2B2onFHIR_Storage.data WHERE type = ?"
            set ts2 = ##class(%SQL.Statement).%New()
            set sc = ts2.%Prepare(SQL)
            continue:$$$ISERR(sc)
            set tr2 = ts2.%Execute(dataType)
            while tr2.%Next() {
                $$$TRACE(dataType_"|"_$e(tr2.content,1,100))

                /// process data
                set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
                set transformRequest.json = jsonObj

                /// process data
                #dim dataCreateResponse As I2B2onFHIR.Messages.dataCreateResponse
                s sc = ..SendRequestSync(target, transformRequest, .dataCreateResponse)
                
                /// ??? delete record from data table anyway
                ///continue:$$$ISERR(sc)
                do ##class(I2B2onFHIR.Storage.Data).%DeleteId(tr2.ID)
               
                continue:$$$ISERR(sc)
                
                if dataCreateResponse.patientNum'="" {
                    set patientsList(dataCreateResponse.patientNum) = ""
                }
                
            }
        }


        ; separate files, which are not connected with patients directly
        ; there is no separate Process right now, because logic is simple
        for dataType = "observation", "condition", "procedure", "medicationrequest" {
            set SQL = "SELECT ID, content FROM I2B2onFHIR_Storage.data WHERE type = ?"
            set ts2 = ##class(%SQL.Statement).%New()
            set sc = ts2.%Prepare(SQL)
            continue:$$$ISERR(sc)
            set tr2 = ts2.%Execute(dataType)
            while tr2.%Next() {
                $$$TRACE(dataType)
                
                set transformRequest = ##class(I2B2onFHIR.Messages.dataTransformRequestBase).%New()
                set transformRequest.json = jsonObj

		        #dim observationFactTransformResponse As I2B2onFHIR.Messages.ObservationFactTransformResponse
		
                ; call transformation
                if dataType = "observation" {
                    set sc = ##class(I2B2onFHIR.Transformations.ObservationFile).Transform(transformRequest, .observationFactTransformResponse)
                    $$$TRACE("Transform status = "_sc)
                
                }elseif dataType = "condition" {
                    set sc = ##class(I2B2onFHIR.Transformations.Condition).Transform(transformRequest, .observationFactTransformResponse)
                    $$$TRACE("Transform status = "_sc)

                }elseif dataType = "procedure" {
                    set sc = ##class(I2B2onFHIR.Transformations.Procedure).Transform(transformRequest, .observationFactTransformResponse)
                    $$$TRACE("Transform status = "_sc)

                }elseif dataType = "medicationrequest" {
                    set sc = ##class(I2B2onFHIR.Transformations.MedicationRequest).Transform(transformRequest, .observationFactTransformResponse)
                    $$$TRACE("Transform status = "_sc)

                } else {
                    $$$TRACE("Unknown file type "_dataType)
	                /// delete unknown file type record from data table
	                do ##class(I2B2onFHIR.Storage.Data).%DeleteId(tr2.ID)                    
                    continue
                }

                /// ??? delete record from data table anyway
                do ##class(I2B2onFHIR.Storage.Data).%DeleteId(tr2.ID)
				continue:$$$ISERR(sc)
                // skip empty messages
                continue:observationFactTransformResponse.data.Count()<1

                // 1 - check that record already exists 
                #dim dataCheckResponse As I2B2onFHIR.Messages.dataCheckBaseResponse
                s sc = ..SendRequestSync(..#OBSERVATIONFACTCHECK, observationFactTransformResponse, .dataCheckResponse)
                $$$TRACE("dataCheckResponse status = "_sc)
                continue:$$$ISERR(sc)

                // 2 - save new record
                s sc = ..SendRequestSync(..#OBSERVATIONFACTSAVE, observationFactTransformResponse, .resp)
                $$$TRACE("Save New Record status = "_sc)
                continue:$$$ISERR(sc)
            }
        }
		// WARNING!!! May be need correct!
		s sc=$$$OK

        #dim observationFactRequest As I2B2onFHIR.Messages.ObservationFactBPRequest
        // create/update observation fact
        set patientNum="" for { set patientNum = $o(patientsList(patientNum)) quit:patientNum=""
            set observationFactRequest = ##class(I2B2onFHIR.Messages.ObservationFactBPRequest).%New()
            set observationFactRequest.patientNum = patientNum
            
            s sc = ..SendRequestSync(..#TARGETOBSERVATIONFACT, observationFactRequest, .observationFactResponse)
            
            quit:$$$ISERR(sc)
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

