<cfset Variables.userWhoCausedError = "?">
<cfif IsDefined("Session") and StructKeyExists(Session, "userID") and Session.userID gt 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
	</cfinvoke>

	<cfif qry_selectUser.RecordCount is 1>
		<cfset Variables.userWhoCausedError = "<br>
Company: #qry_selectUser.companyName# (#qry_selectUser.companyID#)<br>
User: #qry_selectUser.username# (#qry_selectUser.userID#) (status = #qry_selectUser.userStatus#)<br>
#qry_selectUser.firstName# #qry_selectUser.lastName#<br>
#qry_selectUser.email#">
	</cfif>
</cfif>

<cfif Application.billingErrorEmail is not "" and (FindNoCase("ajax", GetBaseTemplatePath()) or Not StructKeyExists(Application, "billingShowDebugOutput") or Application.billingShowDebugOutput is False)>
	<cfif Not IsDefined("fn_EmailFrom")>
		<cfinclude template="../function/fn_Email.cfm">
	</cfif>

	<cfmail
		From="#fn_EmailFrom(Application.billingErrorFrom, Application.billingErrorReplyTo)#"
		To="#Application.billingErrorEmail#"
		Subject="#Application.billingErrorSubject# -- #Left(Arguments.Exception.message, 60)#"
		Username="#Application.billingEmailUsername#"
		Password="#Application.billingEmailPassword#"
		Type="html">
<p>Error caused by: #Variables.userWhoCausedError#</p>
Date/Time: #Now()#<br>
Error Type: #Arguments.Exception.type#<br>
Error message associated with the exception: #Arguments.Exception.message#<br>
Details: #Arguments.Exception.detail#<br>
<cfif StructKeyExists(Arguments.Exception, "Sql")><p>SQL: #Arguments.Exception.Sql#</p></cfif>
<cfif StructKeyExists(Arguments.Exception, "queryError")><p>Query Error: #Arguments.Exception.queryError#</p></cfif>
<cfif StructKeyExists(Arguments.Exception, "where")><p>Where: #Arguments.Exception.where#</p></cfif>
<cfif StructKeyExists(Arguments.Exception, "ExtendedInfo")><p>Extended Info: #Arguments.Exception.ExtendedInfo#</p></cfif>
<cfif StructKeyExists(Arguments.Exception, "MissingFileName")><p>Missing File Name: #Arguments.Exception.MissingFileName#</p></cfif>

<p>-------------------------</p>
FORM VARIABLES:<br>
<cfloop index="field" list="#StructKeyList(FORM)#">#field#: <cfif ListFindNoCase("password,creditCardNumber,creditCardCVC,bankAccountNumber,bankRoutingNumber", field)>(intentionally left blank)<cfelseif Not IsSimpleValue(Form[field])>(Complex Value)<cfelse>#FORM[field]#</cfif><br></cfloop>
<p>-------------------------</p>
CGI VARIABLES<Br>
<cfloop index="field" list="#StructKeyList(CGI)#">#field#: #CGI[field]#<br></cfloop>
<p>-------------------------</p>
SESSION VARIABLES:<br>
<cfif IsDefined("Session")><cfloop index="field" list="#StructKeyList(Session)#">#field#: <cfif Not IsSimpleValue(Session[field])>(complex)<cfelse>#Session[field]#</cfif><br></cfloop></cfif>

<cfif IsDefined("Arguments.Exception.TagContext") and Not IsSimpleValue(Arguments.Exception.TagContext)><p><cfdump var="#Arguments.Exception.TagContext#" expand="Yes" label="Arguments.Exception.TagContext"></p></cfif>
	</cfmail>
</cfif><!--- if billingErrorEmail is not "" --->

<cfif StructKeyExists(Application, "billingShowDebugOutput") and Application.billingShowDebugOutput is True
		and FindNoCase("localhost", Application.billingUrl)>
	<cfoutput>
	<div align="left">
	<cfif IsDefined("Session")><cfloop item="field" collection="#Session#">#field#: <cfif IsSimpleValue(Session[field])>#Session[field]#</cfif><br></cfloop></cfif>
	<br>
	<br>
	Date/Time: #Now()#<br>
	Error Type: #Arguments.Exception.type#<br>
	Error message associated with the exception: #Arguments.Exception.message#<br>
	Details: #Arguments.Exception.detail#<br>
	<cfif StructKeyExists(Arguments.Exception, "Sql")><p>SQL: #Arguments.Exception.Sql#</p></cfif>
	<cfif StructKeyExists(Arguments.Exception, "queryError")><p>Query Error: #Arguments.Exception.queryError#</p></cfif>
	<cfif StructKeyExists(Arguments.Exception, "where")><p>Where: #Arguments.Exception.where#</p></cfif>
	<cfif StructKeyExists(Arguments.Exception, "ExtendedInfo")><p>Extended Info: #Arguments.Exception.ExtendedInfo#</p></cfif>
	<cfif StructKeyExists(Arguments.Exception, "MissingFileName")><p>Missing File Name: #Arguments.Exception.MissingFileName#</p></cfif>
	<cfif IsDefined("Arguments.Exception.TagContext") and Not IsSimpleValue(Arguments.Exception.TagContext)><p><cfdump var="#Arguments.Exception.TagContext#" expand="Yes" label="Arguments.Exception.TagContext"></p></cfif>
	<!--- <br><br><cfdump var="#Arguments.Exception#" expand="yes" label="Exception"><br><br><cfdump var="#Arguments.EventName#" expand="yes" label="EventName"> --->
	</div>
	</cfoutput>
<cfelseif FindNoCase("admin\", GetBaseTemplatePath())>
	<cflocation url="#Application.billingUrlRoot#/admin/index.cfm?method=admin.error" AddToken="No">
<cfelse>
	<cflocation url="#Application.billingUrlRoot#/error.cfm" AddToken="No">
</cfif>
