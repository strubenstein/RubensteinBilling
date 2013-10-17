<cfset Variables.error_login = "">
<cfif Variables.doAction is "logout">
	<cflock Scope="Session" Timeout="5">
		<cfset Session.userID = 0>
		<cfset Session.fullName = "">
		<cfset Session.companyID = 0>
		<cfset Session.username = "">
		<cfset Session.groupID = 0>
	</cflock>

	<cflocation url="index.cfm?method=user.login&confirm_shopping=logout" AddToken="No">

<cfelseif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitLogin") and IsDefined("Form.login_username") and IsDefined("Form.login_password")>
	<cfinclude template="../../../view/v_shopping/v_shoppingLogin/lang_login.cfm">
	<!--- validate username and password are not blank --->
	<!--- validate user: check username/password against database --->
	<!--- ensure user has permission for site --->
	<!--- get user permissions (groups) for site --->
	<cfif Trim(Form.login_username) is "" or Trim(Form.login_password) is "">
		<cfset Variables.error_login = Variables.lang_login.login_blank>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#include.security.Login" Method="checkLogin" ReturnVariable="qry_checkLogin">
			<cfinvokeargument Name="username" Value="#Form.login_username#">
			<cfinvokeargument Name="password" Value="#Form.login_password#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfif IsDefined("Form.login_companyDirectory")>
				<cfinvokeargument Name="companyDirectory" Value="#Form.login_companyDirectory#">
			<cfelse>
				<cfinvokeargument Name="companyDirectory" Value="">
			</cfif>
		</cfinvoke>

		<cfif qry_checkLogin.RecordCount is not 1>
			<cfset Variables.error_login = Variables.lang_login.login_incorrect>
		<cfelseif qry_checkLogin.userStatus is not 1>
			<cfset Variables.error_login = Variables.lang_login.login_noPermission>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#include.security.Login" Method="checkLoginGroup" ReturnVariable="qry_checkLoginGroup">
				<cfinvokeargument Name="userID" Value="#qry_checkLogin.userID#">
				<cfinvokeargument Name="companyID" Value="#qry_checkLogin.companyID#">
			</cfinvoke>

			<cflock Scope="Session" Timeout="5">
				<cfset Session.userID = qry_checkLogin.userID>
				<cfset Session.companyID = qry_checkLogin.companyID>
				<cfset Session.fullName = qry_checkLogin.firstName & " " & qry_checkLogin.lastName>
				<cfset Session.cobrandID = qry_checkLogin.cobrandID>
				<cfset Session.username = Form.login_username>
				<cfif qry_checkLoginGroup.RecordCount is not 0>
					<cfset Session.groupID = ValueList(qry_checkLoginGroup.groupID)>
				<cfelse>
					<cfset Session.groupID = 0>
				</cfif>
			</cflock>

			<!--- if in checkout process, return to checkout process, otherwise display login confirmation--->
			<cfif IsDefined("URL.checkout")>
				<cflocation url="index.cfm?method=checkout.shipping" AddToken="No">
			<cfelseif IsDefined("URL.myAccount")>
				<cflocation url="index.cfm?method=myAccount.accountHome" AddToken="No">
			<cfelse>
				<cfinclude template="../../../view/v_shopping/v_shoppingLogin/confirm_login.cfm">
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfif Session.userID is 0>
	<cfinclude template="../../view/v_shopping/v_shoppingLogin/form_login.cfm">
</cfif>
