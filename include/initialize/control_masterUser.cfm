<cfinclude template="../function/fn_IsValidEmail.cfm">

<cfinclude template="formParam_masterUser.cfm">
<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />
<cfinvoke component="#Application.billingMapping#data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />

<cfset errorMessage_fields = StructNew()>
<cfset isAllFormFieldsOk = False>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitMasterUser")>
	<cfinclude template="../../view/v_company/lang_insertUpdateCompany.cfm">
	<cfinclude template="../../view/v_user/lang_insertUpdateUser.cfm">
	<cfinclude template="formValidate_masterUser.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif Not StructKeyExists(Application, "fn_GetPrimaryTargetID")>
			<cfinclude template="../config/fn_GetPrimaryTargetID.cfm">
		</cfif>

		<!--- insert master user --->
		<cfinvoke Component="#Application.billingMapping#data.User" Method="insertUser" ReturnVariable="newUserID">
			<cfinvokeargument Name="companyID" Value="#Application.billingSuperuserCompanyID#">
			<cfinvokeargument Name="username" Value="#Form.username#">
			<cfinvokeargument Name="password" Value="#Form.password#">
			<cfinvokeargument Name="userStatus" Value="1">
			<cfinvokeargument Name="firstName" Value="#Form.firstName#">
			<cfinvokeargument Name="lastName" Value="#Form.lastName#">
			<cfinvokeargument Name="email" Value="#Form.email#">
			<cfinvokeargument Name="userID_custom" Value="">
			<cfinvokeargument Name="userNewsletterStatus" Value="1">
			<cfinvokeargument Name="userNewsletterHtml" Value="1">
			<cfinvokeargument Name="userID_author" Value="0">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.User" Method="insertUserCompany" ReturnVariable="isUserCompanyInserted">
			<cfinvokeargument Name="userID" Value="#newUserID#">
			<cfinvokeargument Name="companyID" Value="#Application.billingSuperuserCompanyID#">
			<cfinvokeargument Name="userCompanyStatus" Value="1">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
			<cfinvokeargument Name="companyID" Value="#Application.billingSuperuserCompanyID#">
			<cfinvokeargument Name="companyName" Value="#Form.companyName#">
			<cfinvokeargument Name="userID" Value="#newUserID#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermissionList" ReturnVariable="qry_selectPermissionList">
			<cfinvokeargument Name="permissionStatus" Value="1">
		</cfinvoke>

		<cfset Variables.permissionCategoryStruct = StructNew()>
		<cfloop Query="qry_selectPermissionList">
			<cfif Not StructKeyExists(Variables.permissionCategoryStruct, "permCat_#qry_selectPermissionList.permissionCategoryID#")>
				<cfset Variables.permissionCategoryStruct["permCat_#qry_selectPermissionList.permissionCategoryID#"] = qry_selectPermissionList.permissionBinaryNumber>
			<cfelse>
				<cfset Variables.permissionCategoryStruct["permCat_#qry_selectPermissionList.permissionCategoryID#"] = Variables.permissionCategoryStruct["permCat_#qry_selectPermissionList.permissionCategoryID#"] + qry_selectPermissionList.permissionBinaryNumber>
			</cfif>
		</cfloop>

		<!--- insert all permissions for user --->
		<cfinvoke Component="#Application.billingMapping#data.PermissionTarget" Method="insertPermissionTarget" ReturnVariable="isPermissionTargetInserted">
			<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("userID")#">
			<cfinvokeargument Name="targetID" Value="#newUserID#">
			<cfinvokeargument Name="userID" Value="0">
			<cfinvokeargument Name="permissionCategoryStruct" Value="#Variables.permissionCategoryStruct#">
		</cfinvoke>

		<!--- insert all permissions for company --->
		<cfinvoke Component="#Application.billingMapping#data.PermissionTarget" Method="insertPermissionTarget" ReturnVariable="isPermissionTargetInserted">
			<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("companyID")#">
			<cfinvokeargument Name="targetID" Value="#Application.billingSuperuserCompanyID#">
			<cfinvokeargument Name="userID" Value="0">
			<cfinvokeargument Name="permissionCategoryStruct" Value="#Variables.permissionCategoryStruct#">
		</cfinvoke>

		<cfoutput>
		<p class="ConfirmationMessage">Master user successfully created and granted full permissions.<br>Initialization completed!</p>
		<p class="ErrorMessage">Be sure to delete this initialize.cfm file and the include/initialize/ directory.</p>
		<p class="MainText"><b><a href="#Application.billingSecureUrl#/admin/index.cfm?resetApplicationVariables=True">Log into Billing Admin</a></b></p>
		<p class="MainText"><b>For company directory, use &quot;default&quot;.</b></p>
		</cfoutput>
	</cfif>
</cfif>

<cfif isAllFormFieldsOk is False>
	<cfinclude template="form_masterUser.cfm">
</cfif>
