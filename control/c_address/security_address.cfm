<cfif Not Application.fn_IsIntegerNonNegative(URL.addressID)>
	<cflocation url="#Variables.addressActionList#&error_address=noAddress" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.companyID) or (URL.companyID is not 0 and Not ListFind("company,user", URL.control))>
	<cflocation url="#Variables.addressActionList#&error_address=invalidCompany" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.userID) or (URL.userID is not 0 and Not ListFind("user,company", URL.control))>
	<cflocation url="#Variables.addressActionList#&error_address=invalidUser" AddToken="No">
<cfelseif URL.userID is 0 and URL.companyID is 0>
	<cflocation url="#Variables.addressActionList#&error_address=invalidCompany" AddToken="No">
<cfelseif URL.addressID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="checkAddressPermission" ReturnVariable="isAddressPermission">
		<cfinvokeargument Name="addressID" Value="#URL.addressID#">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		<cfif URL.userID is not 0>
			<cfinvokeargument Name="userID" Value="#URL.userID#">
		</cfif>
	</cfinvoke>

	<cfif isAddressPermission is False>
		<cflocation url="#Variables.addressActionList#&error_address=invalidAddress" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectAddress">
			<cfinvokeargument Name="addressID" Value="#URL.addressID#">
		</cfinvoke>

		<cfif qry_selectAddress.companyID is not URL.companyID and qry_selectAddress.userID is not URL.userID>
			<cflocation url="#Variables.addressActionList#&error_address=invalidAddress" AddToken="No">
		<cfelseif qry_selectAddress.addressStatus is 0 and Variables.doAction is "insertAddress">
			<cflocation url="#Variables.addressActionList#&error_address=invalidAddressStatus" AddToken="No">
		</cfif>
	</cfif>
<cfelseif Not ListFind("listAddresses,listAddressesAll,insertAddress", Variables.doAction)>
	<cflocation url="#Variables.addressActionList#&error_address=noAddress" AddToken="No">
</cfif>
