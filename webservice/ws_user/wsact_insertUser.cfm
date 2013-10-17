<cfset Variables.doAction = "insertUser">
<cfset URL.userID = 0>

<cfset Form.salutation_select = "">
<cfset Form.salutation_text = Arguments.salutation>
<cfset Form.suffix_select = "">
<cfset Form.suffix_text = Arguments.suffix>
<cfset Form.jobDepartment_select = "">
<cfset Form.jobDepartment_text = Arguments.jobDepartment>
<cfset Form.passwordVerify = Arguments.password>

<cfif Not IsDefined("fn_IsValidEmail")>
	<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
</cfif>

<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />
<cfinclude template="../../view/v_user/lang_insertUpdateUser.cfm">
<cfinclude template="../../control/c_user/formValidate_insertUpdateUser.cfm">

<cfif isAllFormFieldsOk is False>
	<cfset returnValue = -1>
	<cfset returnError = "">
	<cfloop Collection="#errorMessage_fields#" Item="field">
		<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
	</cfloop>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="insertUser" ReturnVariable="newUserID">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="username" Value="#Arguments.username#">
		<cfinvokeargument Name="password" Value="#Arguments.password#">
		<cfinvokeargument Name="userStatus" Value="#Arguments.userStatus#">
		<cfinvokeargument Name="firstName" Value="#Arguments.firstName#">
		<cfinvokeargument Name="middleName" Value="#Arguments.middleName#">
		<cfinvokeargument Name="lastName" Value="#Arguments.lastName#">
		<cfinvokeargument Name="suffix" Value="#Arguments.suffix#">
		<cfinvokeargument Name="salutation" Value="#Arguments.salutation#">
		<cfinvokeargument Name="email" Value="#Arguments.email#">
		<cfinvokeargument Name="userID_custom" Value="#Arguments.userID_custom#">
		<cfinvokeargument Name="jobTitle" Value="#Arguments.jobTitle#">
		<cfinvokeargument Name="jobDepartment" Value="#Arguments.jobDepartment#">
		<cfinvokeargument Name="jobDivision" Value="#Arguments.jobDivision#">
		<cfinvokeargument Name="userNewsletterStatus" Value="#Arguments.userNewsletterStatus#">
		<cfinvokeargument Name="userNewsletterHtml" Value="#Arguments.userNewsletterHtml#">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.User" Method="insertUserCompany" ReturnVariable="isUserCompanyInserted">
		<cfinvokeargument Name="userID" Value="#newUserID#">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="userCompanyStatus" Value="1">
	</cfinvoke>

	<cfset returnValue = newUserID>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

