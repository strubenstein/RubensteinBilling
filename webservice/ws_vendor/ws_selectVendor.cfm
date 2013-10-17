<cfinclude template="wslang_vendor.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewVendor", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_vendor.viewVendor>
<cfelse>
	<cfset Arguments.vendorID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.vendorID, Arguments.vendorID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.vendorID) is 1 and Arguments.vendorID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_vendor.invalidVendor>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendor">
			<cfinvokeargument Name="vendorID" Value="#Arguments.vendorID#">
			<cfinvokeargument Name="returnVendorDescription" Value="#Arguments.returnVendorDescription#">
		</cfinvoke>

		<cfset returnValue = qry_selectVendor>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

