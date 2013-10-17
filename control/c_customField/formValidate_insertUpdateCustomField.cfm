<cfset errorMessage_fields = StructNew()>

<cfloop Index="field" List="customFieldStatus,customFieldExportXml,customFieldExportTab,customFieldExportHtml,customFieldInternal">
	<cfif Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_insertUpdateCustomField[field]>
	</cfif>
</cfloop>

<cfif Not ListFind(Variables.customFieldFormTypeList_value, Form.customFieldFormType, "^")>
	<cfset errorMessage_fields.customFieldFormType = Variables.lang_insertUpdateCustomField.customFieldFormType>
</cfif>

<cfif Not ListFind(Variables.customFieldTypeList_value, Form.customFieldType, "^")>
	<cfset errorMessage_fields.customFieldType = Variables.lang_insertUpdateCustomField.customFieldType>
</cfif>

<cfif Trim(Form.customFieldName) is "">
	<cfset errorMessage_fields.customFieldName = Variables.lang_insertUpdateCustomField.customFieldName_blank>
<cfelseif Len(Form.customFieldName) gt maxlength_CustomField.customFieldName>
	<cfset errorMessage_fields.customFieldName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldName_maxlength, "<<MAXLENGTH>>", maxlength_CustomField.customFieldName, "ALL"), "<<LEN>>", Len(Form.customFieldName), "ALL")>
<cfelse><!--- update --->
	<cfinvoke Component="#Application.billingMapping#data.CustomField" Method="checkCustomFieldNameIsUnique" ReturnVariable="isCustomFieldNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
		<cfinvokeargument Name="customFieldName" Value="#Form.customFieldName#">
	</cfinvoke>

	<cfif isCustomFieldNameUnique is False>
		<cfset errorMessage_fields.customFieldName = Variables.lang_insertUpdateCustomField.customFieldName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.customFieldTitle) is "">
	<cfset errorMessage_fields.customFieldTitle = Variables.lang_insertUpdateCustomField.customFieldTitle_blank>
<cfelseif Len(Form.customFieldTitle) gt maxlength_CustomField.customFieldTitle>
	<cfset errorMessage_fields.customFieldTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldTitle_maxlength, "<<MAXLENGTH>>", maxlength_CustomField.customFieldTitle, "ALL"), "<<LEN>>", Len(Form.customFieldTitle), "ALL")>
</cfif>

<cfif Len(Form.customFieldDescription) gt maxlength_CustomField.customFieldDescription>
	<cfset errorMessage_fields.customFieldDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldDescription, "<<MAXLENGTH>>", maxlength_CustomField.customFieldDescription, "ALL"), "<<LEN>>", Len(Form.customFieldDescription), "ALL")>
</cfif>

<cfloop Index="thisPrimaryTargetID" List="#Form.primaryTargetID#">
	<cfif Not ListFind(Variables.customFieldTargetList_value, Application.fn_GetPrimaryTargetKey(thisPrimaryTargetID))>
		<cfset errorMessage_fields.primaryTargetID = Variables.lang_insertUpdateCustomField.primaryTargetID_valid>
	</cfif>
</cfloop>

<!--- validate custom field options --->
<cfset Variables.customFieldOptionCount = 0>
<cfif ListFind("select,selectMultiple,radio,checkbox", Form.customFieldFormType)>
	<cfif Form["customFieldOptionLabel1"] is "" and Form["customFieldOptionValue1"] is "" and Form["customFieldOptionLabel2"] is "" and Form["customFieldOptionValue2"] is "">
		<cfset errorMessage_fields.customFieldOption = Variables.lang_insertUpdateCustomField.customFieldOption_blank>
	<cfelse>
		<cfloop Index="count" From="1" To="#Form.customFieldOptionCount#">
			<cfif Trim(Form["customFieldOptionLabel#count#"]) is "" and count gt 1>
				<cfbreak>
			<cfelse>
				<cfset Variables.customFieldOptionCount = Variables.customFieldOptionCount + 1>
				<cfif Len(Form["customFieldOptionLabel#count#"]) gt maxlength_CustomFieldOption.customFieldOptionLabel>
					<cfset errorMessage_fields["customFieldOptionLabel#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldOptionLabel_maxlength, "<<MAXLENGTH>>", maxlength_CustomFieldOption.customFieldOptionLabel, "ALL"), "<<LEN>>", Len(Form["customFieldOptionLabel#count#"]), "ALL"), "<<COUNT>>", count, "ALL")>
				</cfif>
				<cfif Len(Form["customFieldOptionValue#count#"]) gt maxlength_CustomFieldOption.customFieldOptionValue>
					<cfset errorMessage_fields["customFieldOptionValue#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldOptionValue_maxlength, "<<MAXLENGTH>>", maxlength_CustomFieldOption.customFieldOptionValue, "ALL"), "<<LEN>>", Len(Form["customFieldOptionValue#count#"]), "ALL"), "<<COUNT>>", count, "ALL")>
				<cfelseif Form["customFieldOptionValue#count#"] is not "">
					<cfswitch expression="#Form.customFieldType#">
					<cfcase value="Bit">
						<cfif Not ListFindNoCase("0,1,true,false,yes,no,t,f,y,n", Form["customFieldOptionValue#count#"])>
							<cfset errorMessage_fields["customFieldOptionValue#count#"] = ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldOptionValue_bit, "<<COUNT>>", count, "ALL")>
						</cfif>
					</cfcase>
					<cfcase value="DateTime">
						<cfif Not IsDate(Form["customFieldOptionValue#count#"])>
							<cfset errorMessage_fields["customFieldOptionValue#count#"] = ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldOptionValue_datetime, "<<COUNT>>", count, "ALL")>
						</cfif>
					</cfcase>
					<cfcase value="Decimal">
						<cfif Not IsNumeric(Form["customFieldOptionValue#count#"])>
							<cfset errorMessage_fields["customFieldOptionValue#count#"] = ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldOptionValue_decimal, "<<COUNT>>", count, "ALL")>
						<cfelseif Find(".", Form["customFieldOptionValue#count#"]) and Len(ListLast(Form["customFieldOptionValue#count#"], ".")) gt maxlength_CustomFieldDecimal.customFieldDecimalValue>
							<cfset errorMessage_fields["customFieldOptionValue#count#"] = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldOptionValue_decimalMaxlength, "<<MAXLENGTH>>", maxlength_CustomFieldDecimal.customFieldDecimalValue, "ALL"), "<<COUNT>>", count, "ALL")>
						</cfif>
					</cfcase>
					<cfcase value="Varchar">
						<cfif Len(ListLast(Form["customFieldOptionValue#count#"], ".")) gt maxlength_CustomFieldVarchar.customFieldVarcharValue>
							<cfset errorMessage_fields["customFieldOptionValue#count#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldOptionValue_varcharMaxlength, "<<MAXLENGTH>>", maxlength_CustomFieldVarchar.customFieldVarcharValue, "ALL"), "<<LEN>>", Len(Form["customFieldOptionValue#count#"]), "ALL"), "<<COUNT>>", count, "ALL")>
						</cfif>
					</cfcase>
					<cfcase value="Int">
						<cfif Not Application.fn_IsInteger(Form["customFieldOptionValue#count#"])>
							<cfset errorMessage_fields["customFieldOptionValue#count#"] = ReplaceNoCase(Variables.lang_insertUpdateCustomField.customFieldOptionValue_int, "<<COUNT>>", count, "ALL")>
						</cfif>
					</cfcase>
					</cfswitch>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertCustomField">
		<cfset errorMessage_title = Variables.lang_insertUpdateCustomField.errorTitle_insert>
	<cfelse><!--- updateCustomField --->
		<cfset errorMessage_title = Variables.lang_insertUpdateCustomField.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateCustomField.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateCustomField.errorFooter>
</cfif>

