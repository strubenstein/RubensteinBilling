<cfset Variables.error_forgetLogin = "">
<cfset Variables.confirm_forgetLogin = "">
<cfinclude template="../../../view/v_shopping/v_shoppingLogin/lang_forgetLogin.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.email")>
	<cfif Trim(Form.email) is "">
		<cfset Variables.error_forgetLogin = Variables.lang_forgetLogin.email_blank>
	<cfelseif Variables.doAction is "forgetUsername" and IsDefined("Form.submitForgetUsername")>
		<!--- validate that a single user exists with that email address --->
		<cfinvoke Component="#Application.billingMapping#data.User" Method="checkForgetUsernameOrPassword" ReturnVariable="qry_checkForgetUsernameOrPassword">
			<cfinvokeargument Name="email" Value="#Form.email#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		</cfinvoke>

		<cfif qry_checkForgetUsernameOrPassword.RecordCount is 0>
			<cfset Variables.error_forgetLogin = ReplaceNoCase(Variables.lang_forgetLogin.forgetUsername_none, "<<EMAIL>>", Form.email, "ALL")>
		<cfelseif qry_checkForgetUsernameOrPassword.RecordCount gt 1>
			<cfset Variables.error_forgetLogin = ReplaceNoCase(Variables.lang_forgetLogin.forgetUsername_multiple, "<<EMAIL>>", Form.email, "ALL")>
		<cfelse>
			<cfinclude template="../../../view/v_shopping/v_shoppingLogin/email_forgetUsername.cfm">
			<cfset Variables.confirm_forgetLogin = Variables.doAction>
		</cfif>

	<cfelseif Variables.doAction is "forgetPassword" and IsDefined("Form.submitForgetPassword") and IsDefined("Form.username")>
		<cfif Trim(Form.username) is "">
			<cfset Variables.error_forgetLogin = Variables.lang_forgetLogin.username_blank>
		<cfelse>
			<!--- validate that a single user exists with that username and email address --->
			<cfinvoke Component="#Application.billingMapping#data.User" Method="checkForgetUsernameOrPassword" ReturnVariable="qry_checkForgetUsernameOrPassword">
				<cfinvokeargument Name="email" Value="#Form.email#">
				<cfinvokeargument Name="username" Value="#Form.username#">
				<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			</cfinvoke>

			<cfif qry_checkForgetUsernameOrPassword.RecordCount is 0>
				<cfset Variables.error_forgetLogin = ReplaceNoCase(ReplaceNoCase(Variables.lang_forgetLogin.forgetPassword_none, "<<EMAIL>>", Form.email, "ALL"), "<<USERNAME>>", Form.username, "ALL")>
			<cfelseif qry_checkForgetUsernameOrPassword.RecordCount gt 1>
				<cfset Variables.error_forgetLogin = ReplaceNoCase(ReplaceNoCase(Variables.lang_forgetLogin.forgetPassword_multiple, "<<EMAIL>>", Form.email, "ALL"), "<<USERNAME>>", Form.username, "ALL")>
			<cfelse>
				<!--- 
				Character / Ascii Value
				0-9		48-57
				A-Z		65-90
				a-z		97-122
				--->
				<cfset Variables.newPassword = Chr(RandRange(97,122)) & Chr(RandRange(97,122)) & Chr(RandRange(48,57))
						& Chr(RandRange(65,90)) & Chr(RandRange(65,90)) & Chr(RandRange(48,57)) & Chr(RandRange(48,57))>
				<cfset Variables.newPasswordLength = RandRange(8,13)>
				<cfloop Index="count" From="8" To="#Variables.newPasswordLength#">
					<cfif (count mod 2) is 0>
						<cfset Variables.newPassword = Variables.newPassword & Chr(RandRange(97,122))>
					<cfelse>
						<cfset Variables.newPassword = Variables.newPassword & Chr(RandRange(65,90))>
					</cfif>
				</cfloop>

				<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUser" ReturnVariable="isUserUpdated">
					<cfinvokeargument Name="userID" Value="#qry_checkForgetUsernameOrPassword.userID#">
					<cfinvokeargument Name="password" Value="#Variables.newPassword#">
				</cfinvoke>

				<cfinclude template="../../../view/v_shopping/v_shoppingLogin/email_forgetPassword.cfm">
				<cfset Variables.confirm_forgetLogin = Variables.doAction>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../../../view/v_shopping/v_shoppingLogin/header_forgetLogin.cfm">

<cfif Variables.error_forgetLogin is not "">
	<cfinclude template="../../../view/v_shopping/v_shoppingLogin/error_forgetLogin.cfm">
<cfelseif Variables.confirm_forgetLogin is "forgetUsername">
	<cfinclude template="../../../view/v_shopping/v_shoppingLogin/confirm_forgetUsername.cfm">
<cfelseif Variables.confirm_forgetLogin is "forgetPassword">
	<cfinclude template="../../../view/v_shopping/v_shoppingLogin/confirm_forgetPassword.cfm">
</cfif>

<cfinclude template="../../../view/v_shopping/v_shoppingLogin/form_forgetLogin.cfm">

