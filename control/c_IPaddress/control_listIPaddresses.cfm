<cfinvoke Component="#Application.billingMapping#data.IPaddress" Method="selectIPaddressList" ReturnVariable="qry_selectIPaddressList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="../../view/v_IPaddress/lang_listIPaddresses.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateIPaddress,deleteIPaddress")>
<cfset Variables.columnHeaderList = Variables.lang_listIPaddresses_title.IPaddress
		& "^" & Variables.lang_listIPaddresses_title.IPaddressBrowser
		& "^" & Variables.lang_listIPaddresses_title.IPaddressWebService
		& "^" & Variables.lang_listIPaddresses_title.IPaddressDateCreated
		& "^" & Variables.lang_listIPaddresses_title.IPaddressDateUpdated>

<cfif ListFind(Variables.permissionActionList, "updateIPaddress")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listIPaddresses_title.updateIPaddress>
</cfif>
<cfif ListFind(Variables.permissionActionList, "deleteIPaddress")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listIPaddresses_title.deleteIPaddress>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfset Variables.webServiceRestricted = False>
<cfset Variables.browserRestricted = False>

<cfloop Query="qry_selectIPaddressList">
	<cfif qry_selectIPaddressList.IPaddressWebService is 1>
		<cfset Variables.webServiceRestricted = True>
	</cfif>
	<cfif qry_selectIPaddressList.IPaddressBrowser is 1>
		<cfset Variables.browserRestricted = True>
	</cfif>
</cfloop>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_IPaddress/dsp_selectIPaddressList.cfm">
