<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	<cfif Variables.doControl is "user" or URL.userID is not 0>
		<cfinvokeargument Name="userID" Value="#URL.userID#">
		<cfinvokeargument Name="companyIDorUserID" Value="False">
	</cfif>
	<cfif Variables.doAction is not "listAddressesAll">
		<cfinvokeargument Name="addressStatus" Value="1">
	</cfif>
</cfinvoke>

<cfset Variables.addressActionUpdate = Replace(Variables.formAction, URL.action, "insertAddress", "ONE")>
<cfset Variables.addressActionView = Replace(Variables.formAction, URL.action, "viewAddress", "ONE")>
<cfset Variables.addressActionList = Replace(Variables.formAction, URL.action, "listAddresses", "ONE")>
<cfset Variables.addressActionListAll = Replace(Variables.formAction, URL.action, "listAddressesAll", "ONE")>

<cfset Variables.addressActionStatusActive = Replace(Variables.formAction, URL.action, "updateAddressStatus1", "ONE")>
<cfset Variables.addressActionStatusArchived = Replace(Variables.formAction, URL.action, "updateAddressStatus0", "ONE")>
<cfset Variables.addressActionTypeBillingYes = Replace(Variables.formAction, URL.action, "updateAddressTypeBilling1", "ONE")>
<cfset Variables.addressActionTypeBillingNo = Replace(Variables.formAction, URL.action, "updateAddressTypeBilling0", "ONE")>
<cfset Variables.addressActionTypeShippingYes = Replace(Variables.formAction, URL.action, "updateAddressTypeShipping1", "ONE")>
<cfset Variables.addressActionTypeShippingNo = Replace(Variables.formAction, URL.action, "updateAddressTypeShipping0", "ONE")>

<cfinclude template="../../view/v_address/lang_listAddresses.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("insertAddress,viewAddress,listAddresses,listAddressesAll,updateAddressStatus0,updateAddressStatus1,updateAddressTypeBilling0,updateAddressTypeBilling1,updateAddressTypeShipping0,updateAddressTypeShipping1")>

<cfset Variables.addressColumnList = Variables.lang_listAddresses_title.addressName
		& "^" & Variables.lang_listAddresses_title.addressVersion
		& "^" & Variables.lang_listAddresses_title.companyID
		& "^" & Variables.lang_listAddresses_title.addressTypeBilling
		& "^" & Variables.lang_listAddresses_title.addressTypeShipping
		& "^" & Variables.lang_listAddresses_title.addressStatus
		& "^" & Variables.lang_listAddresses_title.addressCity
		& "^" & Variables.lang_listAddresses_title.addressDateCreated
		& "^" & Variables.lang_listAddresses_title.addressDateUpdated>

<cfif ListFind(Variables.permissionActionList, "insertAddress")>
	<cfset Variables.addressColumnList = Variables.addressColumnList & "^" & Variables.lang_listAddresses_title.insertAddress>
</cfif>
<cfif ListFind(Variables.permissionActionList, "viewAddress")>
	<cfset Variables.addressColumnList = Variables.addressColumnList & "^" & Variables.lang_listAddresses_title.viewAddress>
</cfif>
<cfset Variables.addressColumnCount = DecrementValue(2 * ListLen(Variables.addressColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_address/dsp_selectAddressList.cfm">
