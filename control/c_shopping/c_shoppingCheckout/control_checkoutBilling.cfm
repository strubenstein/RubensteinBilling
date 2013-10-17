<cfinclude template="formParam_checkoutBilling.cfm">
<cfinvoke component="#Application.billingMapping#data.Address" method="maxlength_Address" returnVariable="maxlength_Address" />

<cfinvoke component="#Application.billingMapping#data.CreditCard" method="maxlength_CreditCard" returnVariable="maxlength_CreditCard" />
<cfinclude template="../../../view/v_creditCard/var_creditCardTypeList.cfm">
<cfinclude template="../../../view/v_creditCard/var_creditCardExpirationMonthList.cfm">

<!--- state list options --->
<cfset Variables.selectStateOption = 123>
<cfinclude template="../../../view/v_address/var_stateList.cfm">
<cfinclude template="../../../view/v_address/act_stateList.cfm">

<!--- country list options --->
<cfinclude template="../../../view/v_address/var_countryList.cfm">
<cfset Variables.countryList_value = Variables.selectCountry_name_short>
<cfset Variables.countryList_label = Variables.selectCountry_name_short>

<!--- select existing billing address / credit card combinations --->
<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectBillingAddressList">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="creditCardStatus" Value="1">
	<cfinvokeargument Name="creditCardRetain" Value="1">
</cfinvoke>

<cfset Variables.formSubmitName = "submitCheckoutBilling">
<cfset Variables.formSubmitValue = "Submit Billing Info">

<cfset Variables.formSubmitName_submitted = "">
<cfif IsDefined("Form.isFormSubmitted")>
	<cfif IsDefined("Form.#Variables.formSubmitName#")>
		<cfset Variables.formSubmitName_submitted = Variables.formSubmitName>
	<cfelseif qry_selectBillingAddressList.RecordCount is not 0>
		<cfloop Query="qry_selectBillingAddressList">
			<cfif IsDefined("Form.#Variables.formSubmitName##qry_selectBillingAddressList.creditCardID#")>
				<cfset Variables.formSubmitName_submitted = qry_selectBillingAddressList.creditCardID>
				<cfset Variables.billingRow = CurrentRow>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfif IsDefined("Form.isFormSubmitted") and Variables.formSubmitName_submitted is not "">
	<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/lang_checkoutBilling.cfm">
	<cfinclude template="../../../include/function/fn_creditCard.cfm">
	<cfinclude template="formValidate_checkoutBilling.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<!--- insert billing address --->
		<cfif Variables.formSubmitName_submitted is not Variables.formSubmitName>
			<cfset Variables.addressID_billing = qry_selectBillingAddressList.addressID[Variables.billingRow]>
			<cfset Variables.creditCardID = qry_selectBillingAddressList.creditCardID[Variables.billingRow]>
		<cfelse>
			<!--- if billing address is same as shipping address, update address to reflect it is used for both --->
			<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
				<cfinvokeargument Name="invoiceID" Value="#Session.invoiceID#">
			</cfinvoke>

			<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectAddress">
				<cfinvokeargument Name="addressID" Value="#qry_selectInvoice.addressID_shipping#">
			</cfinvoke>

			<cfif qry_selectAddress.address is Form.billingAddress and qry_selectAddress.address2 is Form.billingAddress2
					and qry_selectAddress.city is Form.billingCity and qry_selectAddress.state is Form.billingState
					and qry_selectAddress.zipCode is Form.billingZipCode and qry_selectAddress.zipCodePlus4 is Form.billingZipCodePlus4>
				<cfset Variables.addressID_billing = qry_selectInvoice.addressID_shipping>
				<cfinvoke Component="#Application.billingMapping#data.Address" Method="updateAddress" ReturnVariable="isAddressUpdated">
					<cfinvokeargument Name="addressID" Value="#qry_selectInvoice.addressID_shipping#">
					<cfinvokeargument Name="addressTypeBilling" Value="1">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.Address" Method="insertAddress" ReturnVariable="newAddressID">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="companyID" Value="#Session.companyID#">
					<cfinvokeargument Name="userID_author" Value="0">
					<cfinvokeargument Name="addressStatus" Value="1">
					<cfinvokeargument Name="addressName" Value="#Form.billingAddressName#">
					<cfinvokeargument Name="addressDescription" Value="">
					<cfinvokeargument Name="addressTypeShipping" Value="0">
					<cfinvokeargument Name="addressTypeBilling" Value="1">
					<cfinvokeargument Name="address" Value="#Form.billingAddress#">
					<cfinvokeargument Name="address2" Value="#Form.billingAddress2#">
					<cfinvokeargument Name="address3" Value="">
					<cfinvokeargument Name="city" Value="#Form.billingCity#">
					<cfinvokeargument Name="state" Value="#Form.billingState#">
					<cfinvokeargument Name="zipCode" Value="#Form.billingZipCode#">
					<cfinvokeargument Name="zipCodePlus4" Value="#Form.billingZipCodePlus4#">
					<cfinvokeargument Name="county" Value="">
					<cfinvokeargument Name="country" Value="#Form.billingCountry#">
					<cfinvokeargument Name="regionID" Value="0">
					<cfinvokeargument Name="addressID_parent" Value="0">
					<cfinvokeargument Name="addressID_trend" Value="0">
					<cfinvokeargument Name="addressVersion" Value="1">
				</cfinvoke>

				<cfset Variables.addressID_billing = newAddressID>
			</cfif>

			<!--- insert credit card info --->
			<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="insertCreditCard" ReturnVariable="newCreditCardID">
				<cfinvokeargument Name="addressID" Value="#Variables.addressID_billing#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="userID_author" Value="0">
				<cfinvokeargument Name="creditCardName" Value="#Form.creditCardName#">
				<cfinvokeargument Name="creditCardNumber" Value="#Form.creditCardNumber#">
				<cfinvokeargument Name="creditCardExpirationMonth" Value="#Form.creditCardExpirationMonth#">
				<cfinvokeargument Name="creditCardExpirationYear" Value="#Form.creditCardExpirationYear#">
				<cfinvokeargument Name="creditCardType" Value="#Form.creditCardType#">
				<cfinvokeargument Name="creditCardCVC" Value="#Form.creditCardCVC#">
				<cfinvokeargument Name="creditCardStatus" Value="1">
				<cfinvokeargument Name="creditCardRetain" Value="#Form.creditCardRetain#">
			</cfinvoke>

			<cfset Variables.creditCardID = newCreditCardID>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
			<cfinvokeargument Name="invoiceID" Value="#Session.invoiceID#">
			<cfinvokeargument Name="addressID_billing" Value="#Variables.addressID_billing#">
			<cfinvokeargument Name="creditCardID" Value="#Variables.creditCardID#">
		</cfinvoke>

		<cfset Variables.doAction = "confirm">
	</cfif>
</cfif>

<cfif Variables.doAction is "billing">
	<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/form_checkoutBilling.cfm">
</cfif>

