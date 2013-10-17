<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermissionAction" ReturnVariable="qry_selectPermissionAction">
	<cfinvokeargument Name="permissionID" Value="#URL.permissionID#">
</cfinvoke>

<cfinclude template="formParam_insertUpdatePermission.cfm">
<cfinvoke component="#Application.billingMapping#data.Permission" method="maxlength_Permission" returnVariable="maxlength_Permission" />
<cfinvoke component="#Application.billingMapping#data.PermissionAction" method="maxlength_PermissionAction" returnVariable="maxlength_PermissionAction" />
<cfinclude template="../../view/v_permission/lang_insertUpdatePermission.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPermission")>
	<cfinclude template="formValidate_insertUpdatePermission.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Permission" Method="updatePermission" ReturnVariable="isPermissionUpdated">
			<cfinvokeargument Name="permissionID" Value="#URL.permissionID#">
			<cfinvokeargument Name="permissionSuperuserOnly" Value="#Form.permissionSuperuserOnly#">
			<cfinvokeargument Name="permissionName" Value="#Form.permissionName#">
			<cfinvokeargument Name="permissionTitle" Value="#Form.permissionTitle#">
			<cfinvokeargument Name="permissionDescription" Value="#Form.permissionDescription#">
			<cfinvokeargument Name="permissionStatus" Value="#Form.permissionStatus#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="permissionAction" Value="#Form.permissionAction#">
		</cfinvoke>

		<cfinclude template="../../include/security/act_applicationPermissionStruct.cfm">

		<cflocation url="index.cfm?method=permission.#Variables.doAction#&permissionID=#URL.permissionID#&confirm_permission=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=permission.#Variables.doAction#&permissionID=#URL.permissionID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePermission.formSubmitValue_update>

<cfinclude template="../../view/v_permission/form_insertUpdatePermission.cfm">
