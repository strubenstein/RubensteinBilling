<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermissionList" ReturnVariable="qry_selectPermissionList">
	<cfinvokeargument Name="permissionCategoryID" Value="#URL.permissionCategoryID#">
</cfinvoke>

<cfif qry_selectPermissionList.RecordCount is 32>
	<cflocation url="index.cfm?method=permission.listPermissionCategories&error_permission=insertPermission_categoryMax" AddToken="No">
</cfif>

<cfinclude template="formParam_insertUpdatePermission.cfm">
<cfinvoke component="#Application.billingMapping#data.Permission" method="maxlength_Permission" returnVariable="maxlength_Permission" />
<cfinvoke component="#Application.billingMapping#data.PermissionAction" method="maxlength_PermissionAction" returnVariable="maxlength_PermissionAction" />
<cfinclude template="../../view/v_permission/lang_insertUpdatePermission.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPermission")>
	<cfinclude template="formValidate_insertUpdatePermission.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- determine order and whether to increment/decrement existing orders --->
		<cfset Variables.incrementPermissionOrder = False>
		<cfif qry_selectPermissionList.RecordCount is 0>
			<cfset Variables.permissionOrder = 1>
		<cfelseif Form.permissionOrder is 0>
			<cfset Variables.permissionOrder = qry_selectPermissionList.RecordCount + 1>
		<cfelse>
			<cfset Variables.incrementPermissionOrder = True>
			<cfset Variables.permissionOrder = Form.permissionOrder>
		</cfif>

		<cfset Variables.permissionBinaryNumber = 2 ^ qry_selectPermissionList.RecordCount>

		<cfinvoke Component="#Application.billingMapping#data.Permission" Method="insertPermission" ReturnVariable="isPermissionInserted">
			<cfinvokeargument Name="permissionCategoryID" Value="#URL.permissionCategoryID#">
			<cfinvokeargument Name="permissionSuperuserOnly" Value="#Form.permissionSuperuserOnly#">
			<cfinvokeargument Name="permissionBinaryNumber" Value="#Variables.permissionBinaryNumber#">
			<cfinvokeargument Name="permissionName" Value="#Form.permissionName#">
			<cfinvokeargument Name="permissionTitle" Value="#Form.permissionTitle#">
			<cfinvokeargument Name="permissionDescription" Value="#Form.permissionDescription#">
			<cfinvokeargument Name="permissionOrder" Value="#Variables.permissionOrder#">
			<cfinvokeargument Name="incrementPermissionOrder" Value="#Variables.incrementPermissionOrder#">
			<cfinvokeargument Name="permissionStatus" Value="#Form.permissionStatus#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="permissionAction" Value="#Form.permissionAction#">
		</cfinvoke>

		<cfinclude template="../../include/security/act_applicationPermissionStruct.cfm">

		<cflocation url="index.cfm?method=permission.#Variables.doAction#&permissionCategoryID=#URL.permissionCategoryID#&confirm_permission=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=permission.#Variables.doAction#&permissionCategoryID=#URL.permissionCategoryID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePermission.formSubmitValue_insert>

<cfinclude template="../../view/v_permission/form_insertUpdatePermission.cfm">
