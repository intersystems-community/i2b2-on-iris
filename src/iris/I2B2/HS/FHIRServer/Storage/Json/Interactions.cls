Class I2B2.HS.FHIRServer.Storage.Json.Interactions Extends HS.FHIRServer.Storage.Json.Interactions
{

Method Read(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject
{
	//q ##super(pResourceType, pResourceId, pVersionId)
	$$$FSLog("Read: pResourceType="_pResourceType_" pResourceId="_ pResourceId_" pVersionId="_pVersionId)

	s proxy = ..GetProxyObject(pResourceType, pResourceId, pVersionId)

	i $iso(proxy) {
		#dim response As %DynamicObject = proxy.Transform()

		// validate response
		#dim schema As HS.FHIRServer.Schema = ..strategy.schema
		i '$iso(schema) s schema = ##class(HS.FHIRServer.Schema).LoadSchema("HL7v40")
		set resourceValidator = ##class(HS.FHIRServer.Util.ResourceValidator).%New(schema)
		d resourceValidator.ValidateResource(response)
		// return it
		q response

	} else {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotAllowed, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
}

/// GetStorageObject
Method GetResponse(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject [ Internal ]
{
	#dim storageObject As I2B2.FHIR.Proxy.Base = ..FindProxyObject(pResourceType, pResourceId, pVersionId, .tSC)
	if (storageObject = "") {
		if (pVersionId = "") {
			$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
		} else {
			$$$ThrowFHIR($$$HSFHIRErrResourceVersionNotFound, pResourceType , pResourceId , pVersionId, $$$HttpOnlyResponse(404))
		}
	}
	return storageObject
}

/// GetStorageObject
Method GetProxyObject(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As I2B2.FHIR.Proxy.Base [ Internal ]
{
	#dim storageObject As I2B2.FHIR.Proxy.Base = ..FindProxyObject(pResourceType, pResourceId, pVersionId, .tSC)
	if (storageObject = "") {
		if (pVersionId = "") {
			$$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId,$$$OutcomeNotFound)
		} else {
			$$$ThrowFHIR($$$HSFHIRErrResourceVersionNotFound, pResourceType , pResourceId , pVersionId, $$$HttpOnlyResponse(404))
		}
	}
	return storageObject
}

/// FindStorageObject
Method FindProxyObject(pResourceType As %String, pResourceId As %String, pVersionId As %String = "", Output tSC As %Status = "") As I2B2.FHIR.Proxy.Base
{
#def1arg callStorageMethod(%arglist) $classmethod(storageClass,%arglist)
	Set resourceClass = ..strategy.GetProxyClass(pResourceType)
	if resourceClass = "" {
		$$$ThrowFHIR($$$HSFHIRErrResourceNotAllowed, pResourceType, pResourceId,$$$OutcomeNotFound)
	}
	Set resourceVerClass = ..strategy.GetProxyVersionClass(pResourceType)
	Set rsrcKey = $$$BuildRsrcKey(pResourceType, pResourceId)
	Set obj = ""
	$$$FSLog("FindStorageObject: ..strategy="_..strategy.%ClassName(1)_" resourceClass="_resourceClass_" resourceVerClassd="_ resourceVerClass_" rsrcKey="_rsrcKey)
	if $classmethod(resourceClass, "KeyIdxExists", rsrcKey) {
		// We have at least one version.  Get it first ..
		Set obj = $classmethod(resourceClass, "KeyIdxOpen", rsrcKey, , .tSC )
		// There is a current object, is this the one that was asked for?

		/* no version support
		if (pVersionId '= "") && (obj.VersionId '= pVersionId) {
			// If not, go get the requested version
			Set obj = $classmethod(resourceVerClass, "TypeIdVerIdxOpen", pResourceType, pResourceId, pVersionId)
		}
		*/
	}
	return obj
}

/// @Override
Method Search(pResourceType As %String, pCompartment As %String, pCompartmentId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters = "", ByRef pSortKeys = "") As HS.FHIRServer.Util.SearchResult
{
	do ..AddQueriedResourceTypes($lb(pResourceType))
	#dim searchColumn as HS.FHIRServer.Storage.Json.SearchColumn
	// Clear our Temp Table and reset the query level
	Do ##class(HS.FHIRServer.Storage.TempTable).%DeleteExtent()
	kill ^||HS.FHIR.IncludeKeys
	
	Set ..queryLevel = 0
	// ---- Build Temp Result Set for Post Processing  ---
	#dim tResultSet as HS.FHIRServer.Util.SearchResult = ##class(HS.FHIRServer.Util.SearchResult).Create()
	
	
	// If the name of the table is an SQL reserved word (ex: Procedure, Group), it must be quoted.
	// tType should have been validated above IsValidResourceType().
	set tableName = ..getTableForResourceType(pResourceType)
	#dim resourceId As HS.FHIRServer.Storage.Json.SearchColumn = ..findSearchColumn(pResourceType, "_id")
	i '$iso(resourceId) {
		$$$ThrowFHIR(HSFHIRErrParameterNotSupported, "_id")
	}
	Set selectClause = "SELECT STRING('"_pResourceType_"/', "_resourceId.ColumnName_") As Key, "_resourceId.ColumnName_" As ResourceId, '1' As VersionId"
	Set nextColumnIndex = 3
	
	Set sortClause = ..BuildSortClause(.pSortKeys, .selectElements)
	for ord=1:1:selectElements {
		do $I(nextColumnIndex)
		set selectClause = selectClause _ ", " _ selectElements(ord)
	}
	// If there are any _include parameters, include the relevant reference columns in this search
	// NOTE: This supercedes the need for BuildIncludeList() in the Service class
	Do pParameters.GetParameters("_include", .params)
	Set searchStatus = tResultSet.SearchStatus
	Set includeSelectClause = ..buildIncludeSelect(pResourceType, .params, nextColumnIndex, .searchStatus, .includeConfig)
	SEt tResultSet.SearchStatus = searchStatus
	Set selectClause = selectClause _ includeSelectClause
	
	Set fromClause = " FROM "_tableName

	Set paramCount = $Select(pParameters="":0, 1:pParameters.Count())
	Set columns = ..getSearchColumnsForType(pResourceType)
	k arrJoin,arrFrom
	s idExist=0
	if $IsObject(columns) {
		for ord = 1:1:paramCount {
			#dim param as HS.FHIRServer.API.SearchQueryParameter = pParameters.GetAt(ord)
			if param.name = "" continue
			if (param.name = "_id") || (param.name = "identifier") { 
				s idExist=1
			}
			if $D(..spcache(pResourceType, param.name), index) {
				#dim column As I2B2.HS.FHIRServer.Storage.Json.SearchColumn = columns.GetAt(index)
				i column.Join '= "" && '$d(arrJoin(column.Join)) {
					s arrJoin(column.Join)=""
					s fromClause = fromClause_" LEFT JOIN "_column.TableName_" on "_column.Join
				}
				i column.From '= "" && '$d(arrFrom($e(column.From,1,250))) {
					s arrFrom($e(column.From,1,250))=""
					s fromClause = fromClause_" "_column.From
				}
			}		
		}
	}
	i 'idExist {
		if $D(..spcache(pResourceType, "_id"), index) {
			s column = columns.GetAt(index)
			i column.Join '= "" && '$d(arrJoin(column.Join)) {
				s arrJoin(column.Join)=""
				s fromClause = fromClause_" LEFT JOIN "_column.TableName_" on "_column.Join
			}
			i column.From '= "" && '$d(arrFrom($e(column.From,1,250))) {
				s arrFrom($e(column.From,1,250))=""
				s fromClause = fromClause_" "_column.From
			}
		}			
	}
	
	set whereClause = ""
	set tSQLParams = 0
	set whereClauseSeparator = " WHERE "
	if (pCompartment '= "") { 
		// If it is a Compartment search, first emit the selector for the compartment
		Set whereCondition = ..WhereCompartment(pResourceType, pCompartment, pCompartmentId, .tSQLParams)
		if whereCondition '= "" {
			set whereClause = whereClause _ whereClauseSeparator _ whereCondition
			set whereClauseSeparator = " AND "
		}
	}
	

	// Build all of the Where clauses as specified by the search parameters
	// Look for exactly one (non-include) parameter that has OR'd values
	Set unionParamIndex = 0
	for ord = 1:1:paramCount {
		s param = pParameters.GetAt(ord)
		if param.nextInRevChain '= "" Continue
		if param.nextInChain '= "" Continue
		if param.searchParam = "" continue //We only want to union search parameters, not result parameters (like _sort)
		
		if $Find(param.value,",") {
			if unionParamIndex = 0 {
				// Remember which parameter we are union'ing
				set unionParamIndex = ord
			} else {
				// There are more than one parameter with OR'd values, fall back to the original code
				set unionParamIndex = 0
				quit
			}
		}
	}	
	
	for ord = 1:1:paramCount {
		set param = pParameters.GetAt(ord)
		
		if param.nextInRevChain '= "" {
			Set whereCondition = ..WhereRevChain(param, pResourceType, "Key", .tSQLParams)
		} elseif param.nextInChain '= "" {
			Set whereCondition = ..WhereChain(param, pResourceType, .tSQLParams)
		} else {
			Set searchColumn = ..findSearchColumn(pResourceType, param.name)
			if searchColumn = "" {
				// Check to see if this is a shared search parameter
				Set searchColumn = ..findSearchColumn("Resource", param.name)
				if searchColumn = "" {
					Continue
				}
			}
			if searchColumn.Added '=0 {
				$$$FHIRAddError(tResultSet.SearchStatus, $$$ERROR($$$HSFHIRErrInconsistentParamState, param.name, $$$OutcomeIs(200, "warning", "incomplete")))
				
			}
			// Skip the union-param -- we will handle it last
			if ord = unionParamIndex {
				set unionColumn = searchColumn
				Continue
			}
			
			Set tParam = param.name
			Set tModifier = param.modifier
			// TODO:  This is now one at at time, so the clause builders can be simplified
			Set tParamValue = param.value

			// Build a where clause segment for this parameter (dispatch by parameter type)
			Set whereCondition = ..WhereClause(tableName, searchColumn, tModifier, tParamValue, .tSQLParams)
		}
		// Append the segment to the SQL statement
		set whereClause = whereClause _ whereClauseSeparator _ whereCondition
		
		// All subsequent clauses are separated with AND
		set whereClauseSeparator = " AND "
	}

	Set queryString = selectClause _ fromClause _ whereClause

	
	if unionParamIndex '= 0 {
		// If this is a union-ed query, handle it now.
		merge tBaseQueryParams = tSQLParams
		kill tSQLParams
		set baseQueryString = queryString
		set queryString = ""
		
		set param = pParameters.GetAt(unionParamIndex)
		set tParam = param.name
		set tModifier = param.modifier
		set tParamValue = param.value
		
		set vcount = $L(tParamValue,",")
		for ord=1:1:vcount {
			set thisValue = $Piece(tParamValue, ",", ord)
			// Append the SQLParams for the base query
			for iq=1:1:tBaseQueryParams {
				Set tSQLParams($I(tSQLParams)) = tBaseQueryParams(iq)
			}
			// Build the where clause and capture the SQLParams
			set whereCondition = ..WhereClause(tableName, unionColumn, tModifier, thisValue, .tSQLParams)
			// Build one full query
			if queryString '= "" {
				set queryString = queryString _ " union "
			}
			set queryString = queryString _ baseQueryString _ whereClauseSeparator _ whereCondition
		}
		
	}
	Set queryString = queryString _ sortClause
	// ---- End of Query Building, Execute Base Query ---
	
	// Execute
	#dim tSQLResultSet As %SQL.StatementResult = ..runQuery( queryString, .tSQLParams, .tSQLExecute1)
	Set tSQLIDColNum = 1
	Set tSQLResourceIdColNum = 2

	// Create HS.FHIRServer.Util.SearchResult from initial SQL result set.
	// Columns are: ( isDeleted, ID, RsrcType, RsrcId, VersionId, mode [match, include], Verb)

	
	set rsrcClassname = ..strategy.GetResourceClass(pResourceType)

	While tSQLResultSet.%Next() {
		Set rsrcKey = tSQLResultSet.%GetData(1)
		#dim rsrc As I2B2.FHIR.Proxy.Base = $classmethod(rsrcClassname, "KeyIdxOpen", rsrcKey,,.sc)
		$$$ThrowOnError(sc)
		if rsrc.Deleted continue
		
		#; set patientId = $Select(rsrc.ResourceType="Patient":rsrc.ResourceId, 1:..GetPatientCompartmentId(rsrc.Compartments.Serialize()))
		set patientId = $Select(rsrc.ResourceType="Patient":rsrc.ResourceId, 1:"")
		do tResultSet.AddRow(rsrc.Key, rsrc.ResourceType,  rsrc.ResourceId, rsrc.VersionId, "match",,,,patientId)
		
		if $D(includeConfig) {
			// If there are any _include parameters, save the list of target resource keys
			// They will be used to add resources in 'SearchIncludes'
			// NOTE: SearchIncludes does not actually perform a search for includes since the
			// fields needed are acquired from the base search.
			Do ..mapReferencesFrom(rsrcKey, tSQLResultSet, .includeConfig)
		}
	}
	
	// We now have the data extracted from the database into a Temporary Table
	// Do more post-processing which may eliminate rows from the result set
	Do tResultSet.%SetIterator(0)
	return tResultSet
}

Method getSearchColumnsForType(resourceType As %String) As %ListOfObjects(ELEMENTTYPE="I2B2.HS.FHIRServer.Storage.Json.SearchColumn")
{
	if '$D(..spcache(resourceType), columns) {
		i resourceType = "Patient" {
			Set columns = ##class(%ListOfObjects).%New()
			//
			Set columnsXData=##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1)_"||PatientColumnsXData",,.sc)
			i $$$ISERR(sc) $$$ThrowStatus(sc)
			s reader = ##class(%XML.Reader).%New()
			s sc = reader.OpenStream(columnsXData.Data)
			i $$$ISERR(sc) $$$ThrowStatus(sc)
			d reader.Correlate("SearchColumn","I2B2.HS.FHIRServer.Storage.Json.SearchColumn")
			while (reader.Next(.column,.sc)) {
				i $$$ISERR(sc) $$$ThrowStatus(sc)  //q:$$$ISERR(sc)
				
				if column.ParamName = "address-country" {
					s column.ColumnName = "'"_##class(I2B2.FHIR.Transform.Base).Lookup("I2B2.FHIR.Lookup.Patient","address_country")_"'"
				}
				if column.ParamName = "address-use" {
					s column.ColumnName = "'"_##class(I2B2.FHIR.Transform.Base).Lookup("I2B2.FHIR.Lookup.Patient","address_use")_"'"
				}
				
				Do columns.Insert(column)
				Set ..spcache(resourceType, column.ParamName) = columns.Count()
			}
			//
			Set ..spcache(resourceType) = columns
		} elseif (resourceType = "Practitioner") || (resourceType = "MedicationRequest") {
			Set columns = ##class(%ListOfObjects).%New()
			//
			Set columnsXData=##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1)_"||"_resourceType_"ColumnsXData",,.sc)
			i $$$ISERR(sc) $$$ThrowStatus(sc)
			s reader = ##class(%XML.Reader).%New()
			s sc = reader.OpenStream(columnsXData.Data)
			i $$$ISERR(sc) $$$ThrowStatus(sc)
			d reader.Correlate("SearchColumn","I2B2.HS.FHIRServer.Storage.Json.SearchColumn")
			while (reader.Next(.column,.sc)) {
				i $$$ISERR(sc) $$$ThrowStatus(sc)  //q:$$$ISERR(sc)
				Do columns.Insert(column)
				Set ..spcache(resourceType, column.ParamName) = columns.Count()
			}
			//
			Set ..spcache(resourceType) = columns
		} elseif resourceType = "Resource" {
			// do nothing
			Set columns = ##class(%ListOfObjects).%New()
			Set ..spcache(resourceType) = columns
		} else  {
			$$$ThrowFHIR($$$HSFHIRErrResourceTypeUnknown, resourceType)
		}
	}
	return columns
}

XData PatientColumnsXData
{
<Columns>
<SearchColumn>
<ParamName>_id</ParamName>
<ColumnName>I2B2onFHIR_storage.Ids.fhirId</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
<From>JOIN I2B2onFHIR_storage.IdsLinks
on $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 1)=patient_dimension.patient_num 
and I2B2onFHIR_storage.IdsLinks.tableName='patient_dimension'
JOIN I2B2onFHIR_storage.Ids 
ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId</From>
</SearchColumn>
<SearchColumn>
<ParamName>identifier</ParamName>
<ColumnName>I2B2onFHIR_storage.Ids.fhirId</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
<From>JOIN I2B2onFHIR_storage.IdsLinks
on $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 1)=patient_dimension.patient_num 
and I2B2onFHIR_storage.IdsLinks.tableName='patient_dimension'
JOIN I2B2onFHIR_storage.Ids 
ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId</From>
</SearchColumn>
<SearchColumn>
<ParamName>birthdate</ParamName>
<ColumnName>patient_dimension.birth_date</ColumnName>
<DataType>dateTime</DataType>
<Type>date</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>death-date</ParamName>
<ColumnName>patient_dimension.death_date</ColumnName>
<DataType>dateTime</DataType>
<Type>date</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>deceased</ParamName>
<ColumnName>patient_dimension.death_date</ColumnName>
<DataType>string</DataType>
<Type>exist</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>address-country</ParamName>
<ColumnName>'US'</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>address-use</ParamName>
<ColumnName>'home'</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>address-state</ParamName>
<ColumnName>$PIECE(statecityzip_path, '\', 2)</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>address-city</ParamName>
<ColumnName>$PIECE(statecityzip_path, '\', 3)</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>address-postalcode</ParamName>
<ColumnName>$PIECE(statecityzip_path, '\', 4)</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>address</ParamName>
<ColumnName>statecityzip_path</ColumnName>
<DataType>string</DataType>
<Type>token</Type>
<isMultiValue>1</isMultiValue>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>gender</ParamName>
<ColumnName>replace(replace(sex_cd,'M','male'),'F','female')</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>patient_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>given</ParamName>
<ColumnName>fname.tval_char</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>observation_fact fname</TableName>
<Join>patient_dimension.patient_num = fname.patient_num and fname.concept_cd = 'PHI:FNAME'</Join>
</SearchColumn>
<SearchColumn>
<ParamName>family</ParamName>
<ColumnName>lname.tval_char</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>observation_fact lname</TableName>
<Join>patient_dimension.patient_num = lname.patient_num and lname.concept_cd = 'PHI:LNAME'</Join>
</SearchColumn>
</Columns>
}

XData PractitionerColumnsXData
{
<Columns>
<SearchColumn>
<ParamName>family</ParamName>
<ColumnName>$PIECE(provider_dimension.name_char, ', ', 1)</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>provider_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>given</ParamName>
<ColumnName>$PIECE(provider_dimension.name_char, ', ', 2)</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>provider_dimension</TableName>
</SearchColumn>
<SearchColumn>
<ParamName>_id</ParamName>
<ColumnName>I2B2onFHIR_storage.Ids.fhirId</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>provider_dimension</TableName>
<From>JOIN I2B2onFHIR_storage.IdsLinks
on $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 1)=provider_dimension.provider_path 
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 2)=provider_dimension.provider_id
and I2B2onFHIR_storage.IdsLinks.tableName='provider_dimension'
JOIN I2B2onFHIR_storage.Ids 
ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId</From>
</SearchColumn>
<SearchColumn>
<ParamName>identifier</ParamName>
<ColumnName>I2B2onFHIR_storage.Ids.fhirId</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>provider_dimension</TableName>
<From>JOIN I2B2onFHIR_storage.IdsLinks
on $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 1)=provider_dimension.provider_path 
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 2)=provider_dimension.provider_id
and I2B2onFHIR_storage.IdsLinks.tableName='provider_dimension'
JOIN I2B2onFHIR_storage.Ids 
ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId</From>
</SearchColumn>
</Columns>
}

XData MedicationRequestColumnsXData
{
<Columns>
<SearchColumn>
<ParamName>_id</ParamName>
<ColumnName>I2B2onFHIR_storage.Ids.fhirId</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>observation_fact</TableName>
<From>JOIN I2B2onFHIR_storage.IdsLinks
on $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 1)=observation_fact.patient_num 
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 2)=observation_fact.concept_cd
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 3)=observation_fact.modifier_cd
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 4)=observation_fact.start_date
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 5)=observation_fact.encounter_num
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 6)=observation_fact.instance_num
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 7)=observation_fact.provider_id
and I2B2onFHIR_storage.IdsLinks.tableName='observation_fact'
JOIN I2B2onFHIR_storage.Ids 
ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId</From>
</SearchColumn>
<SearchColumn>
<ParamName>identifier</ParamName>
<ColumnName>I2B2onFHIR_storage.Ids.fhirId</ColumnName>
<DataType>string</DataType>
<Type>string</Type>
<Added>0</Added>
<TableName>observation_fact</TableName>
<From>JOIN I2B2onFHIR_storage.IdsLinks
on $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 1)=observation_fact.patient_num 
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 2)=observation_fact.concept_cd
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 3)=observation_fact.modifier_cd
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 4)=observation_fact.start_date
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 5)=observation_fact.encounter_num
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 6)=observation_fact.instance_num
and $LISTGET(I2B2onFHIR_storage.IdsLinks.i2b2Link, 7)=observation_fact.provider_id
and I2B2onFHIR_storage.IdsLinks.tableName='observation_fact'
JOIN I2B2onFHIR_storage.Ids 
ON I2B2onFHIR_storage.Ids.ID = I2B2onFHIR_storage.IdsLinks.idsId</From>
</SearchColumn>
</Columns>
}

/// @Override
Method getTableForResourceType(resourceType As %String) As %String
{
	q:resourceType="Patient" "patient_dimension"
	q:resourceType="Practitioner" "provider_dimension"
	q:resourceType="MedicationRequest" "observation_fact"
	$$$ThrowFHIR($$$HSFHIRErrResourceTypeUnknown, resourceType)
}

Method WhereClause(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pVals, ByRef pSQLParams) As %String
{
	Set tParamType = pSearchColumn.Type
	if (tParamType = "exist") {
		return ..WhereExist(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
	}
	return ##super(pParentTableName, pSearchColumn, pModifier, pVals, .pSQLParams)
}

Method WhereExist(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	// Get the parameter name
	//set paramName = pSearchColumn.ParamName
	set fieldName = pSearchColumn.ColumnName
	Set whereClause = "("_$s((pValue=1)||(pValue="true"):"NOT ",1:"")_fieldName_" IS NULL)"
	Return whereClause
}

/// @Overwrite
Method WhereDate(pParentTableName As %String, pSearchColumn As HS.FHIRServer.Storage.Json.SearchColumn, pModifier As %String, pValue As %String, ByRef pSQLParams) As %String
{
	// Generate the SQL query code for 'date' type search parameters
	// http://www.hl7.org/fhir/search.html#date
	
	$$$FSLog("Param: "_pSearchColumn.ParamName _ ", value: " _ pValue _ ", mod: " _ pModifier)
	
	Set dataType = pSearchColumn.DataType
	Set isPeriodParameter = (dataType = "Period")
	set fieldName = pSearchColumn.ColumnName
	set isColl = pSearchColumn.isMultiValue
	// Get the parameter name
	set paramName = pSearchColumn.ParamName
	set fieldQTName = $Select($SYSTEM.SQL.IsReservedWord(fieldName):$Char(34)_fieldName_$Char(34), 1:fieldName)
	
	// SQL fragments for checking if indexed value length is a date or a full timestamp.
	set collIfShortVal = $Select(dataType'="date":"LENGTH(%VALUE)<11 AND ", 1:"")
	set collIfLongVal = $Select(((dataType="date")||(dataType="dateTime")):"LENGTH(%VALUE)>10 AND ", 1:"")
	#define ifShortPropVal(%fn) $Select(dataType'="date":"LENGTH("_%fn_")<11 AND ", 1:"")
	#define ifLongPropVal(%fn) $Select(((dataType="date")||(dataType="dateTime")):"LENGTH("_%fn_")>10 AND ", 1:"")

	// A search value is supposed to select a target value if the implied ranges intersect at
	//  at all. For example, a search value "gt2012-06-15" should select a stored value of "2012"
	//  because the range of the search value (everything after 2012-06-15) intersects the implied
	//  range of the target value (2012-01-01T00:00:00 to 2012-12-31T23:59:59). This is handled
	//  automatically for upper bounds (lt,le) because a less precise value sorts before a 
	//  more precise value. For lower bounds (gt,ge), however, we must explicitly include a condition
	//  to select less precise values, ie, for "gt2012-06-15", we must include a condition like:
	//  "%VALUE IN ('2012-06','2012')"
	
	// Some values are indexed as periods. Periods have explicit start and end times, and both the
	//  start time and the end time are stored and indexed in the search table. All searchable periods
	//  in the data model are indexed as periods. Additionally some values that are not periods
	//  are indexed as periods, because the searchable property is an "[x]" property and one of
	//  the types that it may be is a period and at least one is not. Ex: The "onset" parameter
	//  of Condition searches both onsetPeriod and onsetDateTime. In this case, non-period values
	//  are indexed as periods by using implicit start and end times. The way searching on periods
	//  works is, if the seach contains a lower bound (gt, ge), then we query on the "End" value.
	//  If it contains an upper bound (lt, le), then we query on the "Start" value. "Equals" as
	//  it pertains to periods means (per the spec) "the range of the search value fully contains
	//  the range of the target value", which in this case means that the first instant of the
	//  search value comes before the stored "Start" value, and the last instant of the search
	//  value comes after the "End" value.
	
	
	// If the special case above does not apply, then process each condition individually.
	set tSearchVal = pValue
	set whereClause = ""
	set valueCount = $L(tSearchVal,",")
	set saveFieldName = fieldName
	for tJ=1:1:valueCount {
		// gt, ge, lt, le handling modifies field name, restore it.
		set fieldName = saveFieldName
		set tOneSearchVal = $P(tSearchVal,",",tJ)
		if (tJ'=1) { 
			set whereClause = whereClause_") OR (" 
		} else {
			set whereClause = whereClause_"(" 
		}
		// The value should have a prefix, however if it does not, treat that as "equal"
		if ($E(tOneSearchVal,1,2) ? 2A) {
			set tPrefix = $ZCVT($E(tOneSearchVal,1,2),"L")
			if (",eq,ne,gt,lt,ge,le,sa,eb,ap," '[ (","_tPrefix_",")) { 
				$$$ThrowFHIR($$$HSFHIRErrInvalidPrefixValue, paramName, tPrefix, $$$OutcomeInvalid(400))
			}
			set tOneSearchVal = $E(tOneSearchVal,3,*)
		}
		elseif (pModifier '="" ) { s tPrefix = pModifier}
		else { set tPrefix = "eq" }
		set tOrigSearchVal = tOneSearchVal
		set firstInstant = ..FirstInstant(tOrigSearchVal)
		set lastInstant = ..LastInstant(tOrigSearchVal)
		// tOneSearchVal is returned here as a "filled-in" and
		// UTC-converted version of the original search value.
		Do ..ValidateDate(paramName, .tOneSearchVal)

		if (tPrefix = "eq") {
			set ifShortPropVal = $Select(isColl:collIfShortVal, 1: $$$ifShortPropVal(fieldQTName))
			set ifLongPropVal = $Select(isColl:collIfLongVal, 1: $$$ifLongPropVal(fieldQTName))
			if (isPeriodParameter) {
				if isColl {
					set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_..#PERIODSTARTSUFFIX_") (%VALUE >= ?) AND FOR SOME %ELEMENT("_fieldName_..#PERIODENDSUFFIX_") (%VALUE <= ?))"
				}
				else {
					set whereClause = whereClause_" ("_fieldName_..#PERIODSTARTSUFFIX_" >= ? AND "_fieldName_..#PERIODENDSUFFIX_" <= ?)"
				}
				set pSQLParams($I(pSQLParams)) = $tr(firstInstant,"TZ"," ")
				set pSQLParams($I(pSQLParams)) = $tr(lastInstant,"TZ"," ")
			}
			else {
				if isColl {
					set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldQTName_") (" _ ifLongPropVal _ "%VALUE >= ? AND %VALUE <= ?))"
				} else {
					set whereClause = whereClause_" (" _ ifLongPropVal _fieldQTName_" >= ? AND "_fieldQTName_" <= ?)"
				}
				set pSQLParams($I(pSQLParams)) = $tr(firstInstant,"TZ"," ")
				set pSQLParams($I(pSQLParams)) = $tr(lastInstant,"TZ"," ")
				set whereClause = whereClause _ " OR"
				if $Length(tOrigSearchVal) = 4 {
					if isColl {
						set whereClause = whereClause _ " (FOR SOME %ELEMENT("_fieldQTName_") ("_ifShortPropVal_"%VALUE %STARTSWITH ?))"
					} else {
						set whereClause = whereClause _ " (" _ ifShortPropVal _ fieldQTName _ " %STARTSWITH ?)"
					}
					set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
					
				} elseIf $Length(tOrigSearchVal) = 7 {
					if isColl {
						set whereClause = whereClause _ " (FOR SOME %ELEMENT("_fieldQTName_") ("_ifShortPropVal_"%VALUE %STARTSWITH ? OR %VALUE = ?))"
					} else {
						set whereClause = whereClause _ " (" _ ifShortPropVal _ fieldQTName _ " %STARTSWITH ?) OR (" _ fieldQTName _ " = ?)"
					}
					set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
					set pSQLParams($I(pSQLParams)) = $Extract(tOrigSearchVal, 1, 4)
					
				} else {
					if isColl {
						set whereClause = whereClause _ " (FOR SOME %ELEMENT("_fieldQTName_") ("_ifShortPropVal_"%VALUE IN (?, ?, ?)))"
					} else {
						set whereClause = whereClause _ " (" _ ifShortPropVal _ fieldQTName _ " IN (?, ?, ?))"
					}
					set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
					set pSQLParams($I(pSQLParams)) = $Extract(tOrigSearchVal, 1, 7)
					set pSQLParams($I(pSQLParams)) = $Extract(tOrigSearchVal, 1, 4)
				}
			}
		}
		
		elseif (tPrefix = "ne") {
			set ifShortPropVal = $Select(isColl:collIfShortVal, 1: $$$ifShortPropVal(fieldQTName))
			set ifLongPropVal = $Select(isColl:collIfLongVal, 1: $$$ifLongPropVal(fieldQTName))
			if (isPeriodParameter) {
				// Per the standard, "not equal" as it applies to periods means: "the range of the search
				// value does not fully contain the range of the target value". So return results where the
				// period start is less than the first instant of the search value, or the period end is
				// greater than the last instant of the search value.
				if isColl {
					set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_..#PERIODSTARTSUFFIX_") (%VALUE < ?) OR FOR SOME %ELEMENT("_fieldName_..#PERIODENDSUFFIX_") (%VALUE > ?))"
				}
				else {
					set whereClause = whereClause_" ("_fieldName_..#PERIODSTARTSUFFIX_" < ? OR "_fieldName_..#PERIODENDSUFFIX_" > ?)"
				}
				set pSQLParams($I(pSQLParams)) = $tr(firstInstant,"TZ"," ")
				set pSQLParams($I(pSQLParams)) = $tr(lastInstant,"TZ"," ")
			}
			else {
				if isColl {
					set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldQTName_") (" _ ifLongPropVal _ "%VALUE < ? OR %VALUE > ?))"
				} else {
					set whereClause = whereClause_" (" _ ifLongPropVal _fieldQTName_" < ? OR "_fieldQTName_" > ?)"
				}
				set pSQLParams($I(pSQLParams)) = $tr(firstInstant,"TZ"," ")
				set pSQLParams($I(pSQLParams)) = $tr(lastInstant,"TZ"," ")
				set whereClause = whereClause _ " OR"
				if $Length(tOrigSearchVal) = 4 {
					if isColl {
						set whereClause = whereClause _ " (FOR SOME %ELEMENT("_fieldQTName_") ("_ifShortPropVal_"NOT %VALUE %STARTSWITH ?))"
					} else {
						set whereClause = whereClause _ " (" _ ifShortPropVal _ "NOT " _ fieldQTName _ " %STARTSWITH ?)"
					}
					set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
					
				} elseIf $Length(tOrigSearchVal) = 7 {
					if isColl {
						set whereClause = whereClause _ " (FOR SOME %ELEMENT("_fieldQTName_") ("_ifShortPropVal_"NOT %VALUE %STARTSWITH ? AND NOT %VALUE = ?))"
					} else {
						set whereClause = whereClause _ " (" _ ifShortPropVal _ "NOT " _ fieldQTName _ " %STARTSWITH ?) AND (NOT " _ fieldQTName _ " = ?)"
					}
					set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
					set pSQLParams($I(pSQLParams)) = $Extract(tOrigSearchVal, 1, 4)
					
				} else {
					if isColl {
						set whereClause = whereClause _ " (FOR SOME %ELEMENT("_fieldQTName_") ("_ifShortPropVal_"NOT %VALUE IN (?, ?, ?)))"
					} else {
						set whereClause = whereClause _ " (" _ ifShortPropVal _ "NOT " _ fieldQTName _ " IN (?, ?, ?))"
					}
					set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
					set pSQLParams($I(pSQLParams)) = $Extract(tOrigSearchVal, 1, 7)
					set pSQLParams($I(pSQLParams)) = $Extract(tOrigSearchVal, 1, 4)
				}
			}
		}
		
		elseif (tPrefix = "gt")||(tPrefix = "ge") {
			// For "gt" ("greater than"):
			// -If search val is "2012", we want everything from 2013 on.
			// -If search val is "2012-06", we want everything from 2012-07 on, including "2012".
			// -If search val is "2012-06-15", we want everything from 2012-06-16 on, including "2012-06" and "2012"
			// -We cannot simply do "%VALUE > ?" with the parameter being the original search value because then
			//  "gt2012" will select "2012-06", which is wrong. So we increment the search value and do "%VALUE >= ?".
			// -Then, Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
			//
			// For "ge" ("greather than or equal to"):
			// -If search val is "2012", we want everything from 2012 on.
			// -If search val is "2012-06", we want everything from 2012-06 on, including "2012".
			// -If search val is "2012-06-15" we want everything from 2012-06-15 on, include "2012-06" and "2012".
			// -So most of what we want is encompassed by "%VALUE >= ?" on the original search value.
			// -Then, Depending on the search value, we may need an additional "IN" or "=" condition. See note above.
			//
			// Therefore, the only different between "ge" and "gt" is that "gt" must have the original search value
			//  incremented before being used in the query.
			//
			// The only thing that changes for periods is that we want to search the "End" column for the period.
			
			Set fieldName = $Select(isPeriodParameter: fieldName_..#PERIODENDSUFFIX, 1: fieldQTName)
			set ifShortPropVal = $Select(isColl:collIfShortVal, 1: $$$ifShortPropVal(fieldName))
			set ifLongPropVal = $Select(isColl:collIfLongVal, 1: $$$ifLongPropVal(fieldName))
			if isColl {
				set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") (%VALUE >= ?))"
			} else {
				set whereClause = whereClause_" ("_fieldName_" >= ?)"
			}
			set pSQLParams($I(pSQLParams)) = $Select(tPrefix="gt":..IncrementDateTime(lastInstant), 1:lastInstant)
			If tPrefix = "ge" {
				set whereClause = whereClause _ " OR"
				set pSQLParams($I(pSQLParams)) = $tr(firstInstant,"TZ"," ")
				set pSQLParams($I(pSQLParams)) = $tr(lastInstant,"TZ"," ")
				if $L(tOrigSearchVal)>9 {
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 10)
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 7)
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 4)
					set IN = "(?, ?, ?)"
				} elseif $L(tOrigSearchVal)=7 {
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 7)
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 4)
					set IN = "(?, ?)"
				} else {
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 4)
					set IN = "(?)"
				}
				if isColl {
					set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") ((%VALUE >= ? AND %VALUE <= ?) OR (%VALUE IN " _ IN _ ")))"
					if $L(tOrigSearchVal)<11 {
						if ((dataType = "date") || (dataType = "dateTime")) {
							set whereClause = whereClause _ " OR (FOR SOME %ELEMENT("_fieldName_") (" _ ifShortPropVal _ "%VALUE %STARTSWITH ?))"
							set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
						}
					}
				} else {
					set whereClause = whereClause _ " ("_fieldName_" >= ? AND "_fieldName_" <= ?) OR (" _fieldName _ " IN " _ IN _ ")"
					if $L(tOrigSearchVal)<11 {
						if ((dataType = "date") || (dataType = "dateTime")) {
							set whereClause = whereClause _ " OR (" _ ifShortPropVal _ fieldName _ " %STARTSWITH ?)"
							set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
						}
					}
				}
			}
		}
		
		elseif (tPrefix = "lt")||(tPrefix = "le") {
			// For "lt" ("less than"):
			// -If search val is "2012", we want everything prior to 2012.
			// -If search val is "2012-06", we want everything prior to 2012-06, including "2012".
			// -If search val is "2012-06-15, we want everything prior to 2012-06-15, including "2012-06" and "2012".
			// -All of this is encompassed by "%VALUE < ?". For example, if the search is "lt2012-06", a value of "2012" will
			//  be selected because "2012" sorts before "2012-06".
			//
			// For "le" ("less than or equal to"):
			// -If search val is "2012", we want everything prior to 2013, including "2012-06" and "2012-06-15".
			// -If search val is "2012-06", we want everything prior to 2012-07, including "2012" and "2012-06-15".
			// -If search val is "2012-06-15", we want everything prior to 2012-06-16, including "2012" and "2012-06".
			// -If we increment the search value, then all of this is encompassed by "%VALUE < ?".
			//
			// Therefore, the only difference between "lt" and "le" is that "le" must have the original search value
			//  incremented before being used in the query.
			//
			// The only thing that changes for periods is that we want to search the "Start" column for the period.
			
			// If the param name is a SQL reserved word, it needs to be quoted in the "IS NOT NULL" part.
			
			set fieldName = $Select(isPeriodParameter: fieldName_..#PERIODSTARTSUFFIX, 1: fieldQTName)
			set ifShortPropVal = $Select(isColl:collIfShortVal, 1: $$$ifShortPropVal(fieldName))
			set ifLongPropVal = $Select(isColl:collIfLongVal, 1: $$$ifLongPropVal(fieldName))
			if isColl {
				set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") ("_ifLongPropVal_"%VALUE < ?))"
			} else {
				set whereClause = whereClause_" ("_ifLongPropVal_fieldName_" < ?)"
			}
			set pSQLParams($I(pSQLParams)) = $tr($Select(tPrefix="le":..IncrementDateTime(firstInstant), 1:firstInstant),"TZ"," ")
			if ($L(tOrigSearchVal)<11) && ((dataType = "date") || (dataType = "dateTime")) {
				if isColl {
					set whereClause = whereClause _ " OR (FOR SOME %ELEMENT("_fieldName_") (" _ ifShortPropVal _ "%VALUE < ? AND %VALUE IS NOT NULL))"
				} else {
					set whereClause = whereClause _ " OR (" _ ifShortPropVal _ fieldName_" < ? AND " _ fieldName _ " IS NOT NULL)"
				}
				set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
			}
			If tPrefix = "le" {
				set whereClause = whereClause _ " OR"
				set pSQLParams($I(pSQLParams)) = $tr(firstInstant,"TZ"," ")
				set pSQLParams($I(pSQLParams)) = $tr(lastInstant,"TZ"," ")
				if $L(tOrigSearchVal)>9 {
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 10)
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 7)
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 4)
					set IN = "(?, ?, ?)"
				} elseif $L(tOrigSearchVal)=7 {
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 7)
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 4)
					set IN = "(?, ?)"
				} else {
					set pSQLParams($I(pSQLParams)) = $E(tOrigSearchVal, 1, 4)
					set IN = "(?)"
				}
				if isColl {
					set whereClause = whereClause_" (FOR SOME %ELEMENT("_fieldName_") ((%VALUE >= ? AND %VALUE <= ?) OR (%VALUE IN " _ IN _ ")))"
					if $L(tOrigSearchVal)<11 {
						if ((dataType = "date") || (dataType = "dateTime")) {
							set whereClause = whereClause _ " OR (FOR SOME %ELEMENT("_fieldName_") (" _ ifShortPropVal _ "%VALUE %STARTSWITH ?))"
							set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
						}
					}
				} else {
					set whereClause = whereClause _ " ("_fieldName_" >= ? AND "_fieldName_" <= ?) OR (" _fieldName _ " IN " _ IN _ ")"
					if $L(tOrigSearchVal)<11 {
						if ((dataType = "date") || (dataType = "dateTime")) {
							set whereClause = whereClause _ " OR (" _ ifShortPropVal _ fieldName _ " %STARTSWITH ?)"
							set pSQLParams($I(pSQLParams)) = $tr(tOrigSearchVal,"TZ"," ")
						}
					}
				}
			}
		}
		else { 
			$$$ThrowFHIR($$$HSFHIRErrPrefixValueNotSupported, paramName, tPrefix, $$$OutcomeNotSupported(400))
		}
			
		set whereClause = whereClause_") "
	}	// loop over OR-ed together conditions
	if valueCount > 1 {
		set whereClause = "(" _ whereClause _ ")"	
	}
	return whereClause
}

}
