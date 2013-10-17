<cfset Variables.importCountSuccess = 0>
<cfset Variables.importCountFail = 0>

<cfloop Index="rowCount" From="#Variables.firstRow#" To="#Variables.importRowCount#">
	<cfset Variables.thisImportDataRow = ListGetAt(importFileContent, rowCount, Chr(10))>
	<cfset Variables.thisColumnCount = ListLen(Variables.thisImportDataRow, Variables.importFileSeparator)>

	<cfset Variables.importDataStruct.useCustomIDFieldList = "">
	<cfset Variables.importDataStruct.insertExtendedFieldTypeList = "">
	<cfset Variables.importDataStruct.customField = "">

	<cfloop Index="colCount" From="1" To="#ArrayLen(Variables.importFieldsArray)#">
		<cfset Variables.thisRowDataOk = True>
		<cfset Variables.thisField = Variables.importFieldsArray[colCount]>

		<cfif Variables.thisField is not "">
			<cfif Variables.thisColumnCount lt colCount>
				<cfif Left(Variables.thisField, 12) is not "customField_">
					<cfset Variables.importDataStruct[Variables.thisField] = "">
				</cfif>
			<cfelse>
				<cfset Variables.thisFieldValue = Trim(ListGetAt(Variables.thisImportDataRow, colCount, Variables.importFileSeparator))>
				<cfif Left(Variables.thisField, 12) is "customField_">
					<cfset Variables.thisCustomField = Mid(Variables.thisField, 13, Len(Variables.thisField) - 12)>
					<cfset Variables.importDataStruct.customField = Variables.importDataStruct.customField & "<#Variables.thisCustomField#>" & Variables.thisFieldValue & "</#Variables.thisCustomField#>">
				<cfelse>
					<!--- date --->
					<cfset Variables.booleanPosition = ListFind(Variables.importFieldList_boolean, Variables.thisField)>
					<cfif Variables.booleanPosition is not 0><!--- boolean --->
						<cfif Variables.thisFieldValue is "">
							<cfset Variables.importDataStruct[Variables.thisField] = ListGetAt(Variables.importFieldList_booleanDefault, Variables.booleanPosition)>
						<cfelseif ListFindNoCase("Yes,Y,True,T,1", Variables.thisFieldValue)>
							<cfset Variables.importDataStruct[Variables.thisField] = "True">
						<cfelseif ListFindNoCase("No,N,False,F,0", Variables.thisFieldValue)>
							<cfset Variables.importDataStruct[Variables.thisField] = "False">
						<cfelse>
							<cfset Variables.thisRowDataOk = False>
						</cfif>
					<cfelse><!--- numeric or string --->
						<cfset Variables.numericPosition = ListFind(Variables.importFieldList_numeric, Variables.thisField)>
						<cfif Variables.numericPosition is 0><!--- string --->
							<cfset Variables.importDataStruct[Variables.thisField] = Variables.thisFieldValue>
						<!--- numeric --->
						<cfelseif Variables.thisFieldValue is "">
							<cfset Variables.importDataStruct[Variables.thisField] = ListGetAt(Variables.importFieldList_numericDefault, Variables.numericPosition)>
						<cfelseif Not IsNumeric(Variables.thisFieldValue)>
							<cfset Variables.importDataStruct[Variables.thisField] = Variables.thisFieldValue>
						<cfelse>
							<cfset Variables.thisRowDataOk = False>
						</cfif>
					</cfif>
				</cfif>

				<!--- will insert extraneous ID_custom fields such as companyID_custom when inserting company, but will just be ignored anyway. --->
				<cfif Right(Variables.thisField, 7) is "_custom" and Variables.thisFieldValue is not "">
					<cfset Variables.importDataStruct.useCustomIDFieldList = ListAppend(Variables.importDataStruct.useCustomIDFieldList, Left(Variables.thisField, Len(Variables.thisField) - 7))>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>

	<cfif Variables.thisRowDataOk is False>
		<cfset newItemID = -1>
	<cfelse>
		<cfif Variables.importDataStruct.customField is not "">
			<cfset Variables.importDataStruct.customField = "<customField>" & Variables.importDataStruct.customField & "<customField>">
		</cfif>

		<!--- for extended insert functions, determine which extended fields to include in list --->
		<cfset Variables.importDataStruct.insertExtendedFieldTypeList = "">
		<cfinclude template="act_importData_extendedFieldList.cfm">

		<cfinvoke Component="#Application.billingMapping#webservice.#Variables.importWebserviceComponent#" Method="#Variables.importWebserviceMethod#" ArgumentCollection="#Variables.importDataStruct#" ReturnVariable="newItemID" />
		<!--- #objImport# --->
	</cfif>

	<cfif Application.fn_IsIntegerPositive(newItemID) or (Not IsNumeric(newItemID) and newItemID is not "<xml></xml>")>
		<cfset Variables.importCountSuccess = Variables.importCountSuccess + 1>
	<cfelse>
		<cfset Variables.importCountFail = Variables.importCountFail + 1>
		<cfset Variables.importDataFailed = ListAppend(Variables.importDataFailed, Variables.thisImportDataRow, Chr(10))>
	</cfif>
</cfloop>

