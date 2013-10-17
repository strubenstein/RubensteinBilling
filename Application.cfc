<!---
Latest information on this project can be found at http://www.strubenstein.com/

Copyright (c) 2013 Steven Rubenstein

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software 
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
--->

<cfcomponent displayName="Application.cfc for billing application">

<cfsilent>
<cfset This.name = "Billing">
<cfset This.LoginStorage = "Session">
<cfset This.SessionManagement = True>
<cfset This.SetClientCookies = True>
<cfset This.SetDomainCookies = True>
<cfset This.ClientManagement = False>
<cfset This.SessionTimeout = CreateTimeSpan(0, 0, 20, 0)>
</cfsilent>

<cffunction name="onApplicationStart" returnType="boolean">
	<cfsilent>
	<cfif Not FileExists(ExpandPath("initialize.cfm"))>
		<cfinclude Template="include/config/act_setApplicationVariables.cfm">
	</cfif>

	<cfif Application.billingTrackLoginSessions is True>
		<cfinvoke component="#Application.billingMapping#data.LoginSession" method="updateLoginSessionDateEnd" returnVariable="isLoginSessionFixed">
			<cfinvokeargument name="loginSessionTimeout" value="0">
		</cfinvoke>
	</cfif>
	</cfsilent>

	<cfreturn True>
</cffunction>

<cffunction name="onSessionStart" returnType="void">
	<cfsilent>
	<!---
	<cfif FindNoCase("localhost", Application.billingUrl)>
		<cfcookie name="cfid" value="#session.cfid#">
		<cfcookie name="cftoken" value="#session.cftoken#">
		<cfcookie name="jsessionid" value="#session.sessionid#">
	</cfif>
	--->

	<cflock Scope="Session" Timeout="10">
		<cfset Session.userID = 0>
		<cfset Session.username = "">
		<cfset Session.fullName = "">
		<cfset Session.companyID = 0>
		<cfset Session.affiliateID = 0>
		<cfset Session.cobrandID = 0>
		<cfif StructKeyExists(Application, "billingSuperuserCompanyID")>
			<cfset Session.companyID_author = Application.billingSuperuserCompanyID>
			<cfset Session.companyDirectory = Application.billingSuperuserCompanyDirectory>
		</cfif>
		<cfset Session.groupID = 0>
		<cfset Session.userEmailVerified = 0>
		<cfset Session.showAdvancedSearch = False>
		<cfset Session.loginSessionID = 0>
		<cfset Session.cobrandID_list = 0>
		<cfset Session.affiliateID_list = 0>
	</cflock>
	</cfsilent>
</cffunction>

<cffunction name="onSessionEnd" returnType="void">
    <cfargument name="SessionScope" required="True">
    <cfargument name="ApplicationScope" required="False">

	<cfsilent>
	<cfif Arguments.SessionScope.userID is not 0 and Application.billingTrackLoginSessions is True>
		<cflock name="appLock#Arguments.SessionScope.userID#" timeout="5" type="Exclusive">
			<cfquery Name="qry_updateLoginSessionTimeout" Datasource="#Arguments.ApplicationScope.billingDsn#" Username="#Arguments.ApplicationScope.billingDsnUsername#" Password="#Arguments.ApplicationScope.billingDsnPassword#">
				UPDATE avLoginSession
				SET loginSessionDateEnd = GetDate(),
					loginSessionTimeout = <cfqueryparam value="1" cfsqltype="#Arguments.ApplicationScope.billingSql.cfSqlType_bit#">
				WHERE userID = <cfqueryparam value="#Arguments.SessionScope.userID#" cfsqltype="cf_sql_integer">
					AND loginSessionDateEnd IS NULL
					AND loginSessionCurrent = <cfqueryparam value="1" cfsqltype="#Arguments.ApplicationScope.billingSql.cfSqlType_bit#">
					<cfif StructKeyExists(Arguments.SessionScope, "loginSessionID") and Arguments.SessionScope.loginSessionID is not 0>
						AND loginSessionID = <cfqueryparam value="#Arguments.SessionScope.loginSessionID#" cfsqltype="cf_sql_integer">
					</cfif>
			</cfquery>
		</cflock>
	</cfif>
	</cfsilent>
</cffunction>

<cffunction name="onRequestStart">
    <cfargument type="String" name="targetPage" required="true">

	<cfsilent>
	<cfif Not FileExists(ExpandPath("initialize.cfm")) and IsDefined("URL.resetApplicationVariables") and URL.resetApplicationVariables is "True">
		<cfinclude Template="include/config/act_setApplicationVariables.cfm">
	<cfelseif Find("scheduled" & Application.billingFilePathSlash, GetBaseTemplatePath())
			and (Not IsDefined("URL.IamTheScheduler") or URL.IamTheScheduler is not True)>
		<cflocation url="#Application.billingUrl#" AddToken="No">
	</cfif>

	<cfif IsDefined("URL.resetSession")
			or Not StructKeyExists(Session, "userID") or Not StructKeyExists(Session, "username")
			or Not StructKeyExists(Session, "fullName")  or Not StructKeyExists(Session, "companyID")
			or Not StructKeyExists(Session, "affiliateID") or Not StructKeyExists(Session, "cobrandID")
			or Not StructKeyExists(Session, "companyID_author") or Not StructKeyExists(Session, "companyDirectory")
			or Not StructKeyExists(Session, "groupID") or Not StructKeyExists(Session, "userEmailVerified")
			or Not StructKeyExists(Session, "showAdvancedSearch") or Not StructKeyExists(Session, "loginSessionID")>
		<cflock Scope="Session" Timeout="10">
			<cfparam Name="Session.userID" Default="0">
			<cfparam Name="Session.username" Default="0">
			<cfparam Name="Session.fullName" Default="">
			<cfparam Name="Session.companyID" Default="0">
			<cfparam Name="Session.affiliateID" Default="0">
			<cfparam Name="Session.cobrandID" Default="0">
			<cfif StructKeyExists(Application, "billingSuperuserCompanyID")>
				<cfparam Name="Session.companyID_author" Default="#Application.billingSuperuserCompanyID#">
				<cfparam Name="Session.companyDirectory" Default="#Application.billingSuperuserCompanyDirectory#">
			</cfif>
			<cfparam Name="Session.groupID" Default="0">
			<cfparam Name="Session.userEmailVerified" Default="0">
			<cfparam Name="Session.showAdvancedSearch" Default="False">
			<cfparam Name="Session.loginSessionID" Default="0">
			<cfparam Name="Session.cobrandID_list" Default="0">
			<cfparam Name="Session.affiliateID_list" Default="0">
		</cflock>
	</cfif>

	<!--- for Macs, trim all non-file upload form fields --->
	<cfparam name="CGI.HTTP_USER_AGENT" default="">
	<cfif CGI.HTTP_USER_AGENT CONTAINS "Mac" and IsDefined("FORM")>
		<cfloop index="field" LIST="#StructKeyList(FORM)#">
			<cfif Right(field, 4) is not "File">
				<cfset Form[field] = Trim(Form[field])>
	 		</cfif>
		</cfloop>
	</cfif>
	</cfsilent>
</cffunction>

<cffunction name="onRequestEnd" returnType="void">
    <cfargument type="String" name="targetPage" required="true">

</cffunction>

<cffunction name="onError" returnType="void">
    <cfargument name="Exception" required="true">
    <cfargument name="EventName" type="String" required="true">

	<cfinclude template="include/security/act_exceptionHandler.cfm">
</cffunction>

<cffunction name="onMissingTemplate" returnType="boolean">
    <cfargument type="string" name="targetPage" required="true">

	<cflocation url="/" addToken="no">

    <cfreturn True>
</cffunction>

</cfcomponent>
