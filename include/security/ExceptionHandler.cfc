<cfcomponent displayName="ExceptionHandler">

<cffunction name="exceptionHandlerEmail" access="public" output="no" returnType="boolean">
	<cfargument name="cfcatchError" type="any" required="yes">
	<cfargument name="cfcatchErrorSubject" type="string" required="no" default="">

	<cfset var userWhoCausedError = "?">

	<cfif StructKeyExists(Session, "userID") and Session.userID gt 0>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
		</cfinvoke>

		<cfif qry_selectUser.RecordCount is 1>
			<cfset userWhoCausedError = "<br>
Company: #qry_selectUser.companyName# (#qry_selectUser.companyID#)<br>
User: #qry_selectUser.username# (#qry_selectUser.userID#) (status = #qry_selectUser.userStatus#)<br>
#qry_selectUser.firstName# #qry_selectUser.lastName#<br>
#qry_selectUser.email#">
		</cfif>
	</cfif>

	<cfif Application.billingErrorEmail is not "" and (Not StructKeyExists(Application, "billingShowDebugOutput") or Application.billingShowDebugOutput is False)>
		<cfif Not IsDefined("fn_EmailFrom")>
			<cfinclude template="../function/fn_Email.cfm">
		</cfif>

		<cfif Arguments.cfcatchErrorSubject is "">
			<cfset Arguments.cfcatchErrorSubject = Left(Arguments.cfcatchError.message, 60)>
		</cfif>

		<cfmail
			From="#fn_EmailFrom(Application.billingErrorFrom, Application.billingErrorReplyTo)#"
			To="#Application.billingErrorEmail#"
			Subject="#Application.billingErrorSubject# -- #Arguments.cfcatchErrorSubject#"
			Username="#Application.billingEmailUsername#"
			Password="#Application.billingEmailPassword#"
			Type="html">
<p>Error caused by: #userWhoCausedError#</p>
Date/Time: #Now()#<br>
Error Type: #Arguments.cfcatchError.type#<br>
Error message associated with the exception: #Arguments.cfcatchError.message#<br>
Details: #Arguments.cfcatchError.detail#<br>
<cfif StructKeyExists(Arguments.cfcatchError, "Sql")><p>SQL: #Arguments.cfcatchError.Sql#</p></cfif>
<cfif StructKeyExists(Arguments.cfcatchError, "queryError")><p>Query Error: #Arguments.cfcatchError.queryError#</p></cfif>
<cfif StructKeyExists(Arguments.cfcatchError, "where")><p>Where: #Arguments.cfcatchError.where#</p></cfif>
<cfif StructKeyExists(Arguments.cfcatchError, "ExtendedInfo")><p>Extended Info: #Arguments.cfcatchError.ExtendedInfo#</p></cfif>
<cfif StructKeyExists(Arguments.cfcatchError, "MissingFileName")><p>Missing File Name: #Arguments.cfcatchError.MissingFileName#</p></cfif>

<p>-------------------------</p>
FORM VARIABLES:<br>
<cfloop index="field" list="#StructKeyList(FORM)#">#field#: <cfif ListFindNoCase("password,creditCardNumber,creditCardCVC,bankAccountNumber,bankRoutingNumber", field)>(intentionally left blank)<cfelseif Not IsSimpleValue(Form[field])>(Complex Value)<cfelse>#FORM[field]#</cfif><br></cfloop>
<p>-------------------------</p>
CGI VARIABLES<Br>
<cfloop index="field" list="#StructKeyList(CGI)#">#field#: #CGI[field]#<br></cfloop>
<p>-------------------------</p>
SESSION VARIABLES:<br>
<cfloop index="field" list="#StructKeyList(Session)#">#field#: <cfif Not IsSimpleValue(Session[field])>(complex)<cfelse>#Session[field]#</cfif><br></cfloop>

<cfif StructKeyExists(Arguments.cfcatchError, "TagContext") and Not IsSimpleValue(Arguments.cfcatchError.TagContext)><p><cfdump var="#Arguments.cfcatchError.TagContext#" expand="Yes" label="Arguments.cfcatchError.TagContext"></p></cfif>
	</cfmail>
</cfif><!--- if billingErrorEmail is not "" --->

	<cfreturn True>
</cffunction>

</cfcomponent>

