<cfif qry_selectPermissionCategoryList.RecordCount is 255>
	<cflocation url="index.cfm?method=permission.listPermissionCategories&error_permission=#Variables.doAction#" AddToken="No">
</cfif>

<cfinclude template="formParam_insertUpdatePermissionCategory.cfm">
<cfinvoke component="#Application.billingMapping#data.PermissionCategory" method="maxlength_PermissionCategory" returnVariable="maxlength_PermissionCategory" />
<cfinclude template="../../view/v_permission/lang_insertUpdatePermissionCategory.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPermissionCategory")>
	<cfinclude template="formValidate_insertUpdatePermissionCategory.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- determine order and whether to increment/decrement existing orders --->
		<cfset Variables.incrementPermissionCategoryOrder = False>
		<cfif qry_selectPermissionCategoryList.RecordCount is 0>
			<cfset Variables.permissionCategoryOrder = 1>
		<cfelseif Form.permissionCategoryOrder is 0>
			<cfset Variables.permissionCategoryOrder = qry_selectPermissionCategoryList.RecordCount + 1>
		<cfelse>
			<cfset Variables.incrementPermissionCategoryOrder = True>
			<cfset Variables.permissionCategoryOrder = Form.permissionCategoryOrder>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Permission" Method="insertPermissionCategory" ReturnVariable="permissionCategoryID">
			<cfinvokeargument Name="permissionCategoryName" Value="#Form.permissionCategoryName#">
			<cfinvokeargument Name="permissionCategoryTitle" Value="#Form.permissionCategoryTitle#">
			<cfinvokeargument Name="permissionCategoryDescription" Value="#Form.permissionCategoryDescription#">
			<cfinvokeargument Name="permissionCategoryOrder" Value="#Variables.permissionCategoryOrder#">
			<cfinvokeargument Name="incrementPermissionCategoryOrder" Value="#Variables.incrementPermissionCategoryOrder#">
			<cfinvokeargument Name="permissionCategoryStatus" Value="#Form.permissionCategoryStatus#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=permission.#Variables.doAction#&confirm_permission=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=permission.#Variables.doAction#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePermissionCategory.formSubmitValue_insert>

<cfinclude template="../../view/v_permission/form_insertUpdatePermissionCategory.cfm">
