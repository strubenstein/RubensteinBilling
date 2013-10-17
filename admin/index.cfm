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

<cfif IsDefined("Form.logout") or IsDefined("URL.logout")>
	<cfinclude template="../include/security/act_logout.cfm">
<cfelse>
	<cfinclude template="../include/security/act_authenticate.cfm">
</cfif>

<cfparam Name="URL.method" Default="admin.main">
<cfset URL.control = ListFirst(URL.method, ".")>
<cfset URL.action = ListLast(URL.method, ".")>

<cfset Variables.doControl = URL.control>
<cfset Variables.doAction = URL.action>
<cfset Variables.doURL = "index.cfm?method=#URL.method#">

<cfinclude template="../view/v_adminMain/header_admin.cfm">
<cfinclude template="../view/v_adminMain/nav_admin.cfm">

<cfinclude template="../control/control.cfm">
<cfinclude template="../view/v_adminMain/footer_admin.cfm">
<cfinclude template="../control/c_adminMain/act_recentPages.cfm">

