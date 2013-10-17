<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
	</cfinvoke>
	<cfparam Name="Form.shippingAddressName" Default="#qry_selectUser.firstName# #qry_selectUser.lastName#">
</cfif>

<cfparam Name="Form.shippingAddressName" Default="">
<cfparam Name="Form.shippingAddress" Default="">
<cfparam Name="Form.shippingAddress2" Default="">
<cfparam Name="Form.shippingCity" Default="">
<cfparam Name="Form.shippingState" Default="">
<cfparam Name="Form.shippingZipCode" Default="">
<cfparam Name="Form.shippingZipCodePlus4" Default="">
<cfparam Name="Form.shippingCountry" Default="United States">
<cfparam Name="Form.invoiceShippingMethod" Default="">
<cfparam Name="Form.invoiceInstructions" Default="">

