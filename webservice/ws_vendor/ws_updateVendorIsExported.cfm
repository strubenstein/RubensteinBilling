<cfinclude template="wslang_vendor.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportVendors", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_vendor.exportVendors>
<cfelse>
	<cfset Arguments.vendorID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.vendorID, Arguments.vendorID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.vendorID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_vendor.invalidVendor>
	<cfelseif Arguments.vendorIsExported is not "" and Not ListFind("0,1", Arguments.vendorIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_vendor.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="updateVendorIsExported" ReturnVariable="isVendorExported">
			<cfinvokeargument Name="vendorID" Value="#Arguments.vendorID#">
			<cfinvokeargument Name="vendorIsExported" Value="#Arguments.vendorIsExported#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif>
</cfif>

