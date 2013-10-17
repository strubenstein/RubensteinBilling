<cfinclude template="wslang_cobrand.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewCobrand", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_cobrand.viewCobrand>
<cfelse>
	<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.cobrandID) is 1 and Arguments.cobrandID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_cobrand.invalidCobrand>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
			<cfinvokeargument Name="cobrandID" Value="#Arguments.cobrandID#">
		</cfinvoke>

		<cfset returnValue = qry_selectCobrand>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

