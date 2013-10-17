<cfinclude template="wslang_address.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewAddress", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_address.viewAddress>
<cfelseif Not Application.fn_IsIntegerList(Arguments.addressID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_address.invalidAddress>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="checkAddressPermission" ReturnVariable="isAddressPermission">
		<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
	</cfinvoke>

	<cfif isAddressPermission is False>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_address.addressNotExist>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectAddress">
			<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
		</cfinvoke>

		<cfset returnValue = qry_selectAddress>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

