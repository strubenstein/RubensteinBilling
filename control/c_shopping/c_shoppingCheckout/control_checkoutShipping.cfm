<cfinclude template="formParam_checkoutShipping.cfm">
<cfinvoke component="#Application.billingMapping#data.Address" method="maxlength_Address" returnVariable="maxlength_Address" />
<cfinvoke component="#Application.billingMapping#data.Invoice" method="maxlength_Invoice" returnVariable="maxlength_Invoice" />
<cfinclude template="../../../view/v_shipping/var_shippingMethodList.cfm">

<!--- state list options --->
<cfset Variables.selectStateOption = 123>
<cfinclude template="../../../view/v_address/var_stateList.cfm">
<cfinclude template="../../../view/v_address/act_stateList.cfm">

<!--- country list options --->
<cfinclude template="../../../view/v_address/var_countryList.cfm">
<cfset Variables.countryList_value = Variables.selectCountry_name_short>
<cfset Variables.countryList_label = Variables.selectCountry_name_short>

<!--- select existing shipping addresses --->
<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectShippingAddressList">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="addressTypeShipping" Value="1">
	<cfinvokeargument Name="addressStatus" Value="1">
</cfinvoke>

<cfset Variables.formSubmitName = "submitCheckoutShipping">
<cfset Variables.formSubmitValue = "Submit Shipping Address">

<cfset Variables.formSubmitName_submitted = "">
<cfif IsDefined("Form.isFormSubmitted")>
	<cfif IsDefined("Form.#Variables.formSubmitName#")>
		<cfset Variables.formSubmitName_submitted = Variables.formSubmitName>
	<cfelseif qry_selectShippingAddressList.RecordCount is not 0>
		<cfloop Query="qry_selectShippingAddressList">
			<cfif IsDefined("Form.#Variables.formSubmitName##qry_selectShippingAddressList.addressID#")>
				<cfset Variables.formSubmitName_submitted = qry_selectShippingAddressList.addressID>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif IsDefined("Form.isFormSubmitted") and Variables.formSubmitName_submitted is not "">
	<cfif Variables.formSubmitName_submitted is Variables.formSubmitName>
		<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/lang_checkoutShipping.cfm">
		<cfinclude template="formValidate_checkoutShipping.cfm">
		<cfset Variables.addressID_shipping = 0>
	<cfelse>
		<cfset isAllFormFieldsOk = True>
		<cfset Variables.addressID_shipping = Variables.formSubmitName_submitted>
	</cfif>

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<!--- insert shipping address --->
		<cfif Variables.addressID_shipping is 0>
			<cfinvoke Component="#Application.billingMapping#data.Address" Method="insertAddress" ReturnVariable="newAddressID">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="userID_author" Value="0">
				<cfinvokeargument Name="addressStatus" Value="1">
				<cfinvokeargument Name="addressName" Value="#Form.shippingAddressName#">
				<cfinvokeargument Name="addressDescription" Value="">
				<cfinvokeargument Name="addressTypeShipping" Value="1">
				<cfinvokeargument Name="addressTypeBilling" Value="0">
				<cfinvokeargument Name="address" Value="#Form.shippingAddress#">
				<cfinvokeargument Name="address2" Value="#Form.shippingAddress2#">
				<cfinvokeargument Name="address3" Value="">
				<cfinvokeargument Name="city" Value="#Form.shippingCity#">
				<cfinvokeargument Name="state" Value="#Form.shippingState#">
				<cfinvokeargument Name="zipCode" Value="#Form.shippingZipCode#">
				<cfinvokeargument Name="zipCodePlus4" Value="#Form.shippingZipCodePlus4#">
				<cfinvokeargument Name="county" Value="">
				<cfinvokeargument Name="country" Value="#Form.shippingCountry#">
				<cfinvokeargument Name="regionID" Value="0">
				<cfinvokeargument Name="addressID_parent" Value="0">
				<cfinvokeargument Name="addressID_trend" Value="0">
				<cfinvokeargument Name="addressVersion" Value="1">
			</cfinvoke>

			<cfset Variables.addressID_shipping = newAddressID>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
			<cfinvokeargument Name="invoiceID" Value="#Session.invoiceID#">
			<cfinvokeargument Name="addressID_shipping" Value="#Variables.addressID_shipping#">
			<cfinvokeargument Name="invoiceShippingMethod" Value="#Form.invoiceShippingMethod#">
			<cfinvokeargument Name="invoiceInstructions" Value="#Form.invoiceInstructions#">
		</cfinvoke>

		<cfset Variables.doAction = "billing">
	</cfif>
</cfif>

<cfif Variables.doAction is "shipping">
	<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/form_checkoutShipping.cfm">
</cfif>
