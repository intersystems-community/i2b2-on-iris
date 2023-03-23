Class I2B2onFHIR.Operations.CheckDataInI2B2 Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Parameter INVOCATION = "Queue";

/// this method has a bit separate logic
/// it checks a list of data and remove data if it exists
Method observationFactCheck(pRequest As I2B2onFHIR.Messages.ObservationFactTransformResponse, Output pResponse As I2B2onFHIR.Messages.dataCheckBaseResponse)
{
    s sc = $$$OK
    try {
      set pResponse = ##class(I2B2onFHIR.Messages.dataCheckBaseResponse).%New()
      set pResponse.recordId = ""

      #dim record As I2B2onFHIR.Messages.ObservationFactItem

      for elemNum = 1:1:pRequest.data.Count() {
        set record = pRequest.data.GetAt(elemNum)
        
        set sql = "DELETE FROM ""public"".""observation_fact"" WHERE encounter_num = ? AND patient_num = ? AND concept_cd = ? AND provider_id = ?"
        
        set ts = ##class(%SQL.Statement).%New()
        set sc=ts.%Prepare(sql)
        quit:$$$ISERR(sc)

        set tr = ts.%Execute(record.encounternum, record.patientnum, record.conceptcd, record.providerid )
      }

	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method providerDimensionCheck(pRequest As I2B2onFHIR.Messages.ProviderDimensionTransformResponse, Output pResponse As I2B2onFHIR.Messages.dataCheckBaseResponse)
{
    s sc = $$$OK
    try {
      set pResponse = ##class(I2B2onFHIR.Messages.dataCheckBaseResponse).%New()

      set sql = "SELECT %ID FROM ""public"".""provider_dimension"" WHERE upload_id = ?"
  
      set ts = ##class(%SQL.Statement).%New()
      set sc=ts.%Prepare(sql)
      quit:$$$ISERR(sc)

      set tr = ts.%Execute(pRequest.uploadid)
      if tr.%Next() {
        set pResponse.recordId = tr.%D
      
      } else {
        set pResponse.recordId = -1
      
      }
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method visitDimensionCheck(pRequest As I2B2onFHIR.Messages.VisitDimensionTransformResponse, Output pResponse As I2B2onFHIR.Messages.dataCheckBaseResponse)
{
    s sc = $$$OK
    try {
      set pResponse = ##class(I2B2onFHIR.Messages.dataCheckBaseResponse).%New()

      set sql = "SELECT %ID FROM ""public"".""visit_dimension"" WHERE upload_id = ?"
  
      set ts = ##class(%SQL.Statement).%New()
      set sc=ts.%Prepare(sql)
      quit:$$$ISERR(sc)

      set tr = ts.%Execute(pRequest.uploadid)
      if tr.%Next() {
        set pResponse.recordId = tr.ID
      
      } else {
        set pResponse.recordId = -1
      
      }
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method encounterMappingCheck(pRequest As I2B2onFHIR.Messages.EncounterMappingTransformResponse, Output pResponse As I2B2onFHIR.Messages.dataCheckBaseResponse)
{
    s sc = $$$OK
    try {
      set pResponse = ##class(I2B2onFHIR.Messages.dataCheckBaseResponse).%New()

      set sql = "SELECT %ID FROM ""public"".""encounter_mapping"" WHERE upload_id = ?"
  
      set ts = ##class(%SQL.Statement).%New()
      set sc=ts.%Prepare(sql)
      quit:$$$ISERR(sc)

      set tr = ts.%Execute(pRequest.uploadid)
      if tr.%Next() {
        set pResponse.recordId = tr.ID
      
      } else {
        set pResponse.recordId = -1
      
      }
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method patientMapingCheck(pRequest As I2B2onFHIR.Messages.PatientMapingTransformResponse, Output pResponse As I2B2onFHIR.Messages.dataCheckBaseResponse)
{
    s sc = $$$OK
    try {
      set pResponse = ##class(I2B2onFHIR.Messages.dataCheckBaseResponse).%New()

      set sql = "SELECT %ID FROM ""public"".""patient_mapping"" WHERE upload_id = ?"
  
      set ts = ##class(%SQL.Statement).%New()
		  set sc=ts.%Prepare(sql)
		  quit:$$$ISERR(sc)

		  set tr = ts.%Execute(pRequest.uploadid)
		  if tr.%Next() {
        set pResponse.recordId = tr.ID
        
      } else {
        set pResponse.recordId = -1
      
      }
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

Method patientDimensionCheck(pRequest As I2B2onFHIR.Messages.PatientDimensionTransformResponse, Output pResponse As I2B2onFHIR.Messages.dataCheckBaseResponse)
{
    s sc = $$$OK
    try {
        set pResponse = ##class(I2B2onFHIR.Messages.dataCheckBaseResponse).%New()

        ;s sql = "SELECT patient_num FROM ""public"".""patient_dimension"" WHERE upload_id = ?"
        set sql = "SELECT %ID FROM ""public"".""patient_dimension"" WHERE upload_id = ?"
		
        set ts = ##class(%SQL.Statement).%New()
		set sc=ts.%Prepare(sql)
		quit:$$$ISERR(sc)

		set tr = ts.%Execute(pRequest.uploadid)
		if tr.%Next() {
            set pResponse.recordId = tr.ID
        
        } else {
            set pResponse.recordId = -1
        
        }
	} catch e {
		s sc = e.AsStatus()
	}
	q sc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="I2B2onFHIR.Messages.ObservationFactTransformResponse">
    <Method>observationFactCheck</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.ProviderDimensionTransformResponse">
    <Method>providerDimensionCheck</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.VisitDimensionTransformResponse">
    <Method>visitDimensionCheck</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.EncounterMappingTransformResponse">
    <Method>encounterMappingCheck</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.PatientDimensionTransformResponse">
    <Method>patientDimensionCheck</Method>
  </MapItem>

  <MapItem MessageType="I2B2onFHIR.Messages.PatientMapingTransformResponse">
    <Method>patientMapingCheck</Method>
  </MapItem>

</MapItems>
}

}

