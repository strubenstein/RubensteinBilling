<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.permissionStatus)>
	<cfset errorMessage_fields.permissionStatus = Variables.lang_insertUpdatePermission.permissionStatus>
</cfif>

<cfif Not ListFind("0,1", Form.permissionSuperuserOnly)>
	<cfset errorMessage_fields.permissionSuperuserOnly = Variables.lang_insertUpdatePermission.permissionSuperuserOnly>
</cfif>

<cfif Trim(Form.permissionName) is "">
	<cfset errorMessage_fields.permissionName = Variables.lang_insertUpdatePermission.permissionName_blank>
<cfelseif Len(Form.permissionName) gt maxlength_Permission.permissionName>
	<cfset errorMessage_fields.permissionName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePermission.permissionName_maxlength, "<<MAXLENGTH>>", maxlength_Permission.permissionName, "ALL"), "<<LEN>>", Len(Form.permissionName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Permission" Method="checkPermissionNameIsUnique" ReturnVariable="isPermissionNameUnique">
		<cfinvokeargument Name="permissionName" Value="#Form.permissionName#">
		<cfif URL.permissionID is not 0>
			<cfinvokeargument Name="permissionID" Value="#URL.permissionID#">
		</cfif>
	</cfinvoke>

	<cfif isPermissionNameUnique is False>
		<cfset errorMessage_fields.permissionName = Variables.lang_insertUpdatePermission.permissionName_unique>
	</cfif>
</cfif>

<cfif Trim(Form.permissionTitle) is "">
	<cfset errorMessage_fields.permissionTitle = Variables.lang_insertUpdatePermission.permissionTitle_blank>
<cfelseif Len(Form.permissionTitle) gt maxlength_Permission.permissionTitle>
	<cfset errorMessage_fields.permissionTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePermission.permissionTitle_maxlength, "<<MAXLENGTH>>", maxlength_Permission.permissionTitle, "ALL"), "<<LEN>>", Len(Form.permissionTitle), "ALL")>
</cfif>

<cfif Len(Form.permissionDescription) gt maxlength_Permission.permissionDescription>
	<cfset errorMessage_fields.permissionDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdatePermission.permissionDescription_maxlength, "<<MAXLENGTH>>", maxlength_Permission.permissionDescription, "ALL"), "<<LEN>>", Len(Form.permissionDescription), "ALL")>
</cfif>

<cfif Variables.doAction is "insertPermission" and Form.permissionOrder is not 0 and (Not Application.fn_IsIntegerPositive(Form.permissionOrder) or Form.permissionOrder gt qry_selectPermissionList.RecordCount)>
	<cfset errorMessage_fields.permissionOrder = Variables.lang_insertUpdatePermission.permissionOrder>
</cfif>

<cfif Form.permissionAction is not "">
	<cfset Variables.actionList = "">
	<cfloop Index="thisAction" List="#Trim(Form.permissionAction)#" Delimiters=",#Chr(10)#">
		<cfset theAction = Trim(thisAction)>
		<cfif Len(theAction) gt maxlength_PermissionAction.permissionAction>
			<cfset errorMessage_fields.permissionAction = ReplaceNoCase(Variables.lang_insertUpdatePermission.permissionAction_maxlength, "<<MAXLENGTH>>", maxlength_Permission.permissionAction, "ALL")>
		<cfelseif REFindNoCase("[^A-Za-z0-9]", theAction) or IsNumeric(Left(theAction, 1))>
			<cfset errorMessage_fields.permissionAction = Variables.lang_insertUpdatePermission.permissionAction_valid>
		<cfelseif ListFindNoCase(Variables.actionList, theAction)>
			<cfset errorMessage_fields.permissionAction = Variables.lang_insertUpdatePermission.permissionAction_repeat>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Permission" Method="checkPermissionActionIsUnique" ReturnVariable="isPermissionActionUnique">
				<cfinvokeargument Name="permissionAction" Value="#theAction#">
				<cfinvokeargument Name="permissionID" Value="#URL.permissionID#">
			</cfinvoke>

			<cfif isPermissionActionUnique is False>
				<cfset errorMessage_fields.permissionAction = Variables.lang_insertUpdatePermission.permissionAction_unique>
			<cfelse>
				<cfset Variables.actionList = ListAppend(Variables.actionList, theAction)>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.permissionCategoryID is 0>
		<cfset errorMessage_title = Variables.lang_insertUpdatePermission.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdatePermission.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdatePermission.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdatePermission.errorFooter>
</cfif>
