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
		<cfinclude Template="../include/config/act_setApplicationVariables.cfm">
	</cfif>
	</cfsilent>

	<cfreturn True>
</cffunction>

<cffunction name="onSessionStart" returnType="void">

</cffunction>

<cffunction name="onSessionEnd" returnType="void">
    <cfargument name="SessionScope" required="True">
    <cfargument name="ApplicationScope" required="False">

</cffunction>

<cffunction name="onRequestStart">
    <cfargument type="String" name="targetPage" required="true">

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
