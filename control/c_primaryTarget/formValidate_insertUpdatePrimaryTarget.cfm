<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.primaryTargetStatus)>
	<cfset errorMessage_fields.primaryTargetStatus = Variables.lang_insertUpdatePrimaryTarget.primaryTargetStatus>
</cfif>

<cfif Trim(Form.primaryTargetTable) is "">
	<cfset errorMessage_fields.primaryTargetTable = Variables.lang_insertUpdatePrimaryTarget.primaryTargetTable_blank>
<cfelseif Len(Form.primaryTargetTable) gt maxlength_PrimaryTarget.primaryTargetTable>
	<cfset errorMessage_fields.primaryTargetTable = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrimaryTarget.primaryTargetTable_maxlength, "<<MAXLENGTH>>", maxlength_PrimaryTarget.primaryTargetTable, "ALL"), "<<LEN>>", Len(Form.primaryTargetTable), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="checkPrimaryTargetTableIsUnique" ReturnVariable="isPrimaryTargetTableUnique">
		<cfinvokeargument Name="primaryTargetTable" Value="#Form.primaryTargetTable#">
		<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
	</cfinvoke>

	<cfif isPrimaryTargetTableUnique is False>
		<cfset errorMessage_fields.primaryTargetTable = Variables.lang_insertUpdatePrimaryTarget.primaryTargetTable_unique>
	</cfif>
</cfif>

<cfif Trim(Form.primaryTargetKey) is "">
	<cfset errorMessage_fields.primaryTargetKey = Variables.lang_insertUpdatePrimaryTarget.primaryTargetKey_blank>
<cfelseif Len(Form.primaryTargetKey) gt maxlength_PrimaryTarget.primaryTargetKey>
	<cfset errorMessage_fields.primaryTargetKey = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrimaryTarget.primaryTargetKey_maxlength, "<<MAXLENGTH>>", maxlength_PrimaryTarget.primaryTargetKey, "ALL"), "<<LEN>>", Len(Form.primaryTargetKey), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="checkPrimaryTargetKeyIsUnique" ReturnVariable="isPrimaryTargetKeyUnique">
		<cfinvokeargument Name="primaryTargetKey" Value="#Form.primaryTargetKey#">
		<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
	</cfinvoke>

	<cfif isPrimaryTargetKeyUnique is False>
		<cfset errorMessage_fields.primaryTargetKey = Variables.lang_insertUpdatePrimaryTarget.primaryTargetKey_unique>
	</cfif>
</cfif>

<cfif Trim(Form.primaryTargetName) is "">
	<cfset errorMessage_fields.primaryTargetName = Variables.lang_insertUpdatePrimaryTarget.primaryTargetName_blank>
<cfelseif Len(Form.primaryTargetName) gt maxlength_PrimaryTarget.primaryTargetName>
	<cfset errorMessage_fields.primaryTargetName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrimaryTarget.primaryTargetName_maxlength, "<<MAXLENGTH>>", maxlength_PrimaryTarget.primaryTargetName, "ALL"), "<<LEN>>", Len(Form.primaryTargetName), "ALL")>
</cfif>

<cfif Len(Form.primaryTargetDescription) gt maxlength_PrimaryTarget.primaryTargetDescription>
	<cfset errorMessage_fields.primaryTargetDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePrimaryTarget.primaryTargetDescription_maxlength, "<<MAXLENGTH>>", maxlength_PrimaryTarget.primaryTargetDescription, "ALL"), "<<LEN>>", Len(Form.primaryTargetDescription), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.primaryTargetID is 0>
		<cfset errorMessage_title = Variables.lang_insertUpdatePrimaryTarget.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdatePrimaryTarget.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdatePrimaryTarget.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePrimaryTarget.errorFooter>
</cfif>

