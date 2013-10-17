<cfoutput>
<html>
<head>
	<title>#Application.billingSiteTitle#</title>
	<link rel="stylesheet" type="text/css" href="#Application.billingUrl#/billing.css">
</head>

<body bgcolor="white" text="Black" marginwidth="0" marginheight="0" topmargin="0" leftmargin="10">
</cfoutput>

<cfif Not IsDefined("Form.isFormSubmitted") or Not IsDefined("Form.submitLogin") or Not IsDefined("Form.login_username") or Not IsDefined("Form.login_password")>
	<cfinclude template="form_login.cfm">
	<cfabort>
<cfelseif Trim(Form.login_username) is "" or Trim(Form.login_password) is "">
	<cfoutput><p class="ErrorMessage">You must enter both your username and password.</p></cfoutput>
	<cfinclude template="form_login.cfm">
	<cfabort>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#include.security.Login" Method="processLogin" ReturnVariable="loginResult">
		<cfinvokeargument Name="username" Value="#Form.login_username#">
		<cfinvokeargument Name="password" Value="#Form.login_password#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfif IsDefined("Form.login_companyDirectory")>
			<cfinvokeargument Name="companyDirectory" Value="#Form.login_companyDirectory#">
		<cfelse>
			<cfinvokeargument Name="companyDirectory" Value="">
		</cfif>
	</cfinvoke>

	<cfif loginResult is not "True">
		<cfoutput><p class="ErrorMessage">#loginResult#</p></cfoutput>
		<cfabort>
	<cfelseif Not IsDefined("URL.method")>
		<cflocation url="index.cfm?method=admin.main" AddToken="No">
	<cfelse>
		<cflocation url="#CGI.Script_Name#?#CGI.Query_String#" AddToken="No">
	</cfif>
</cfif>

