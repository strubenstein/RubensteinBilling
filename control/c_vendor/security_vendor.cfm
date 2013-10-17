<cfif Not Application.fn_IsIntegerNonNegative(URL.vendorID)>
	<cflocation url="index.cfm?method=vendor.listVendors&error_vendor=noVendor" AddToken="No">
<cfelseif URL.vendorID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="checkVendorPermission" ReturnVariable="isVendorPermission">
		<cfinvokeargument Name="vendorID" Value="#URL.vendorID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	</cfinvoke>

	<cfif isVendorPermission is False>
		<cflocation url="index.cfm?method=vendor.listVendors&error_vendor=invalidVendor" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendor">
			<cfinvokeargument Name="vendorID" Value="#URL.vendorID#">
			<cfif ListFind("viewVendor,updateVendor", Variables.doAction)>
				<cfinvokeargument Name="returnVendorDescription" Value="True">
			<cfelse>
				<cfinvokeargument Name="returnVendorDescription" Value="False">
			</cfif>
		</cfinvoke>

		<cfif URL.control is "company" and qry_selectVendor.companyID is not URL.companyID>
			<cflocation url="index.cfm?method=vendor.listVendors&error_vendor=invalidVendor" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listVendors,listCompanyVendors,insertVendor", Variables.doAction)>
	<cflocation url="index.cfm?method=vendor.listVendors&error_vendor=noVendor" AddToken="No">
</cfif>
