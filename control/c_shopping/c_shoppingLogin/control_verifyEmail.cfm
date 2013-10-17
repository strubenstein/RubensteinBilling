<cfset Variables.error_verifyEmail = "">
<cfinclude template="../../../view/v_shopping/v_shoppingLogin/lang_verifyEmail.cfm">

<cfif IsDefined("URL.isFormSubmitted") and IsDefined("URL.userEmailVerifyCode")>
	<cfif Trim(URL.userEmailVerifyCode) is "">
		<cfset Variables.error_verifyEmail = Variables.lang_verifyEmail.blank>
	</cfif>
<cfelseif Trim(CGI.QUERY_STRING) is "">
	<cfset Variables.error_verifyEmail = Variables.lang_verifyEmail.blank>
<cfelse>
	<cfset URL.userEmailVerifyCode = Trim(CGI.QUERY_STRING)>
</cfif>

<cfif Variables.error_verifyEmail  is "">
	<cfquery Name="qry_checkUserEmailVerified" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID, email, username, firstName, lastName,
			userEmailVerified, userEmailDateVerified
		FROM avUser
		WHERE userEmailVerifyCode = <cfqueryparam Value="#URL.userEmailVerifyCode#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif qry_checkUserEmailVerified.RecordCount is 0>
		<cfset Variables.error_verifyEmail = Variables.lang_verifyEmail.invalid>
	<cfelseif qry_checkUserEmailVerified.RecordCount gt 1>
		<cfset Variables.error_verifyEmail = Variables.lang_verifyEmail.multiple>
	<cfelseif qry_checkUserEmailVerified.userEmailVerified is "">
		<cfset Variables.error_verifyEmail = Variables.lang_verifyEmail.notRequired>
	<cfelseif qry_checkUserEmailVerified.userEmailVerified is 1>
		<cfset Variables.error_verifyEmail = Variables.lang_verifyEmail.alreadyVerified>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUser" ReturnVariable="isUserUpdated">
			<cfinvokeargument Name="userID" Value="#qry_checkUserEmailVerified.userID#">
			<cfinvokeargument Name="userEmailVerified" Value="1">
			<cfinvokeargument Name="userEmailDateVerified" Value="#Now()#">
		</cfinvoke>

		<cfinclude TEMPLATE="../../../view/v_shopping/v_shoppingLogin/confirm_verifyEmail.cfm">

		<cfinclude TEMPLATE="system/userList.cfm">
		<cfif emailUsernamePassword EQ 1 OR emailUserAgreement EQ 1>
			<cfset password = checkUser.password>
			<cfset username = checkUser.username>
			<cfset email = checkUser.email>
			<cfinclude TEMPLATE="email/emailUserRegister.cfm">
		</cfif>
	</cfif>
</cfif>

<cfif Variables.error_verifyEmail is not "">
	<cfinclude TEMPLATE="../../../view/v_shopping/v_shoppingLogin/form_verifyEmail.cfm">
</cfif>

