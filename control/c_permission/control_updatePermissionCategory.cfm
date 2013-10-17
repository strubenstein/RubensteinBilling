<cfinclude template="formParam_insertUpdatePermissionCategory.cfm">
<cfinvoke component="#Application.billingMapping#data.PermissionCategory" method="maxlength_PermissionCategory" returnVariable="maxlength_PermissionCategory" />
<cfinclude template="../../view/v_permission/lang_insertUpdatePermissionCategory.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPermissionCategory")>
	<cfinclude template="formValidate_insertUpdatePermissionCategory.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Permission" Method="updatePermissionCategory" ReturnVariable="isPermissionCategoryUpdated">
			<cfinvokeargument Name="permissionCategoryID" Value="#URL.permissionCategoryID#">
			<cfinvokeargument Name="permissionCategoryName" Value="#Form.permissionCategoryName#">
			<cfinvokeargument Name="permissionCategoryTitle" Value="#Form.permissionCategoryTitle#">
			<cfinvokeargument Name="permissionCategoryDescription" Value="#Form.permissionCategoryDescription#">
			<cfinvokeargument Name="permissionCategoryStatus" Value="#Form.permissionCategoryStatus#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=permission.#Variables.doAction#&permissionCategoryID=#URL.permissionCategoryID#&confirm_permission=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=permission.#Variables.doAction#&permissionCategoryID=#URL.permissionCategoryID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePermissionCategory.formSubmitValue_update>

<cfinclude template="../../view/v_permission/form_insertUpdatePermissionCategory.cfm">
