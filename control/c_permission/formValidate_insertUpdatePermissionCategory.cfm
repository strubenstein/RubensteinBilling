<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.permissionCategoryStatus)>
	<cfset errorMessage_fields.permissionCategoryStatus = Variables.lang_insertUpdatePermissionCategory.permissionCategoryStatus>
</cfif>

<cfif Trim(Form.permissionCategoryName) is "">
	<cfset errorMessage_fields.permissionCategoryName = Variables.lang_insertUpdatePermissionCategory.permissionCategoryName_blank>
<cfelseif Len(Form.permissionCategoryName) gt maxlength_PermissionCategory.permissionCategoryName>
	<cfset errorMessage_fields.permissionCategoryName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePermissionCategory.permissionCategoryName_maxlength, "<<MAXLENGTH>>", maxlength_PermissionCategory.permissionCategoryName, "ALL"), "<<LEN>>", Len(Form.permissionCategoryName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Permission" Method="checkPermissionCategoryNameIsUnique" ReturnVariable="isPermissionCategoryNameUnique">
		<cfinvokeargument Name="permissionCategoryName" Value="#Form.permissionCategoryName#">
		<cfif URL.permissionCategoryID is not 0>
			<cfinvokeargument Name="permissionCategoryID" Value="#URL.permissionCategoryID#">
		</cfif>
	</cfinvoke>

	<cfif isPermissionCategoryNameUnique is False>
		<cfset errorMessage_fields.permissionCategoryName = Variables.lang_insertUpdatePermissionCategory.permissionCategoryName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.permissionCategoryTitle) is "">
	<cfset errorMessage_fields.permissionCategoryTitle = Variables.lang_insertUpdatePermissionCategory.permissionCategoryTitle_blank>
<cfelseif Len(Form.permissionCategoryTitle) gt maxlength_PermissionCategory.permissionCategoryTitle>
	<cfset errorMessage_fields.permissionCategoryTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePermissionCategory.permissionCategoryTitle_maxlength, "<<MAXLENGTH>>", maxlength_PermissionCategory.permissionCategoryTitle, "ALL"), "<<LEN>>", Len(Form.permissionCategoryTitle), "ALL")>
</cfif>

<cfif Len(Form.permissionCategoryDescription) gt maxlength_PermissionCategory.permissionCategoryDescription>
	<cfset errorMessage_fields.permissionCategoryDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePermissionCategory.permissionCategoryDescription_maxlength, "<<MAXLENGTH>>", maxlength_PermissionCategory.permissionCategoryDescription, "ALL"), "<<LEN>>", Len(Form.permissionCategoryDescription), "ALL")>
</cfif>

<cfif Form.permissionCategoryOrder is not 0 and (Not Application.fn_IsIntegerPositive(Form.permissionCategoryOrder)
		or Form.permissionCategoryOrder gt qry_selectPermissionCategoryList.RecordCount)>
	<cfset errorMessage_fields.permissionCategoryOrder = Variables.lang_insertUpdatePermissionCategory.permissionCategoryOrder>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.permissionCategoryID is 0>
		<cfset errorMessage_title = Variables.lang_insertUpdatePermissionCategory.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdatePermissionCategory.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdatePermissionCategory.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePermissionCategory.errorFooter>
</cfif>
