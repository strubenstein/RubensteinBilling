<cfset errorMessage_fields = StructNew()>

<!--- Form.regionID --->
<!--- 
<cfif Form.isNewShippingAddress is 0 and IsDefined("Form.shippingAddressID") and IsNumeric(Form.shippingAddressID)>
	<cfif Not ListFind(ValueList(qry_selectShippingAddressList.addressID), Form.shippingAddressID)>
		<cfset errorMessage_fields.addressID = Variables.lang_checkoutShipping.addressID>
	</cfif>
<cfelse><!--- new address --->
	<cfset Form.isNewShippingAddress = 1>
--->

<cfif Trim(Form.shippingAddressName) is "">
	<cfset errorMessage_fields.addressName = Variables.lang_checkoutShipping.addressName_blank>
<cfelseif Len(Form.shippingAddressName) gt maxlength_Address.addressName>
	<cfset errorMessage_fields.addressName = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.addressName_maxlength, "<<MAXLENGTH>>", maxlength_Address.addressName, "ALL"), "<<LEN>>", Len(Form.shippingAddressName), "ALL")>
<!--- 
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="checkAddressNameIsUnique" ReturnVariable="isAddressNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="addressName" Value="#Form.shippingAddressName#">
	</cfinvoke>

	<cfif isAddressNameUnique is False>
		<cfset errorMessage_fields.addressName = Variables.lang_checkoutShipping.addressName_unique>
	</cfif>
--->
</cfif>

<cfif Trim(Form.shippingAddress) is "">
	<cfset errorMessage_fields.address = Variables.lang_checkoutShipping.address_blank>
<cfelseif Len(Form.shippingAddress) gt maxlength_Address.address>
	<cfset errorMessage_fields.address = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.address_maxlength, "<<MAXLENGTH>>", maxlength_Address.address, "ALL"), "<<LEN>>", Len(Form.shippingAddress), "ALL")>
</cfif>

<cfif Len(Form.shippingAddress2) gt maxlength_Address.address2>
	<cfset errorMessage_fields.address2 = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.address2, "<<MAXLENGTH>>", maxlength_Address.address2, "ALL"), "<<LEN>>", Len(Form.shippingAddress2), "ALL")>
</cfif>

<cfif Trim(Form.shippingCity) is "">
	<cfset errorMessage_fields.city = Variables.lang_checkoutShipping.city_blank>
<cfelseif Len(Form.shippingCity) gt maxlength_Address.city>
	<cfset errorMessage_fields.city = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.city_maxlength, "<<MAXLENGTH>>", maxlength_Address.city, "ALL"), "<<LEN>>", Len(Form.shippingCity), "ALL")>
</cfif>

<cfif Trim(Form.shippingState) is "">
	<cfset errorMessage_fields.state = Variables.lang_checkoutShipping.state_blank>
<cfelseif Len(Form.shippingState) gt maxlength_Address.state>
	<cfset errorMessage_fields.state = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.state_maxlength, "<<MAXLENGTH>>", maxlength_Address.state, "ALL"), "<<LEN>>", Len(Form.shippingState), "ALL")>
<cfelseif Not ListFind(Variables.selectStateList_value, Form.shippingState)>
	<cfset errorMessage_fields.state = Variables.lang_checkoutShipping.state_valid>
</cfif>

<cfif Trim(Form.shippingZipCode) is "">
	<cfset errorMessage_fields.zipCode = Variables.lang_checkoutShipping.zipCode_blank>
<cfelseif Len(Form.shippingZipCode) gt maxlength_Address.zipCode>
	<cfset errorMessage_fields.zipCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.zipCode_maxlength, "<<MAXLENGTH>>", maxlength_Address.zipCode, "ALL"), "<<LEN>>", Len(Form.shippingZipCode), "ALL")>
</cfif>

<cfif Len(Form.shippingZipCodePlus4) gt maxlength_Address.zipCodePlus4>
	<cfset errorMessage_fields.zipCodePlus4 = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.zipCodePlus4, "<<MAXLENGTH>>", maxlength_Address.zipCodePlus4, "ALL"), "<<LEN>>", Len(Form.shippingZipCodePlus4), "ALL")>
</cfif>

<cfif Trim(Form.shippingCountry) is "">
	<cfset errorMessage_fields.country = Variables.lang_checkoutShipping.country_blank>
<cfelseif Len(Form.shippingCountry) gt maxlength_Address.country>
	<cfset errorMessage_fields.country = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.country_maxlength, "<<MAXLENGTH>>", maxlength_Address.country, "ALL"), "<<LEN>>", Len(Form.shippingCountry), "ALL")>
<cfelseif Not ListFind(Variables.countryList_value, Form.shippingCountry)>
	<cfset errorMessage_fields.country = Variables.lang_checkoutShipping.country_valid>
</cfif>
<!--- </cfif> --->

<cfif Form.invoiceShippingMethod is not "" and Not ListFind(Variables.shippingMethodList_value, Form.invoiceShippingMethod)>
	<cfset errorMessage_fields.invoiceShippingMethod = Variables.lang_checkoutShipping.invoiceShippingMethodList_valid>
</cfif>

<cfif Len(Form.invoiceInstructions) gt maxlength_Invoice.invoiceInstructions>
	<cfset errorMessage_fields.invoiceInstructions = ReplaceNoCase(ReplaceNoCase(Variables.lang_checkoutShipping.invoiceInstructions_maxlength, "<<MAXLENGTH>>", maxlength_Invoice.invoiceInstructions, "ALL"), "<<LEN>>", Len(Form.invoiceInstructions), "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.method is "checkout">
		<cfset errorMessage_title = Variables.lang_checkoutShipping.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_checkoutShipping.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_checkoutShipping.errorHeader>
	<cfset errorMessage_footer = Variables.lang_checkoutShipping.errorFooter>
</cfif>

