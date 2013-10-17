<cfset errorMessage_fields = StructNew()>

<!--- 
<cfif Not ListFind("0,1", Form.addressStatus)>
	<cfset errorMessage_fields.addressStatus = Variables.lang_insertAddress.addressStatus>
</cfif>
--->

<!--- Form.regionID --->

<cfif Not ListFind("0,1", Form.addressTypeShipping)>
	<cfset errorMessage_fields.addressTypeShipping = Variables.lang_insertAddress.addressTypeShipping>
</cfif>
<cfif Not ListFind("0,1", Form.addressTypeBilling)>
	<cfset errorMessage_fields.addressTypeBilling = Variables.lang_insertAddress.addressTypeBilling>
</cfif>
<!--- 
<cfif Form.addressTypeBilling is not 1 and Form.addressTypeShipping is not 1>
	<cfset errorMessage_fields.addressType = Variables.lang_insertAddress.addressType>
</cfif>
--->

<cfif Len(Form.addressName) gt maxlength_Address.addressName>
	<cfset errorMessage_fields.addressName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.addressName_maxlength, "<<MAXLENGTH>>", maxlength_Address.addressName, "ALL"), "<<LEN>>", Len(Form.addressName), "ALL")>
<!--- 
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="checkAddressNameIsUnique" ReturnVariable="isAddressNameUnique">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		<cfinvokeargument Name="userID" Value="#URL.userID#">
		<cfinvokeargument Name="addressID" Value="#URL.addressID#">
		<cfinvokeargument Name="addressName" Value="#Form.addressName#">
	</cfinvoke>

	<cfif isAddressNameUnique is False>
		<cfset errorMessage_fields.addressName = Variables.lang_insertAddress.addressName_unique>
	</cfif>
--->
</cfif>

<cfif Len(Form.addressDescription) gt maxlength_Address.addressName>
	<cfset errorMessage_fields.addressDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.addressDescription, "<<MAXLENGTH>>", maxlength_Address.addressName, "ALL"), "<<LEN>>", Len(Form.addressDescription), "ALL")>
</cfif>

<cfif Trim(Form.address) is "">
	<cfset errorMessage_fields.address = Variables.lang_insertAddress.address_blank>
<cfelseif Len(Form.address) gt maxlength_Address.address>
	<cfset errorMessage_fields.address = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.address_maxlength, "<<MAXLENGTH>>", maxlength_Address.address, "ALL"), "<<LEN>>", Len(Form.address), "ALL")>
</cfif>

<cfif Len(Form.address2) gt maxlength_Address.address2>
	<cfset errorMessage_fields.address2 = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.address2, "<<MAXLENGTH>>", maxlength_Address.address2, "ALL"), "<<LEN>>", Len(Form.address2), "ALL")>
</cfif>

<cfif Len(Form.address3) gt maxlength_Address.address3>
	<cfset errorMessage_fields.address3 = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.address3, "<<MAXLENGTH>>", maxlength_Address.address3, "ALL"), "<<LEN>>", Len(Form.address3), "ALL")>
</cfif>

<cfif Trim(Form.city) is "">
	<cfset errorMessage_fields.city = Variables.lang_insertAddress.city_blank>
<cfelseif Len(Form.city) gt maxlength_Address.city>
	<cfset errorMessage_fields.city = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.city_maxlength, "<<MAXLENGTH>>", maxlength_Address.city, "ALL"), "<<LEN>>", Len(Form.city), "ALL")>
</cfif>

<cfif Trim(Form.stateOther) is not "">
	<cfif Len(Form.stateOther) gt maxlength_Address.state>
		<cfset errorMessage_fields.state = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.state_maxlength, "<<MAXLENGTH>>", maxlength_Address.state, "ALL"), "<<LEN>>", Len(Form.stateOther), "ALL")>
	<cfelse>
		<cfset Form.state = Form.stateOther>
	</cfif>
<cfelseif Trim(Form.state) is "">
	<cfset errorMessage_fields.state = Variables.lang_insertAddress.state_blank>
<cfelseif Len(Form.state) gt maxlength_Address.state>
	<cfset errorMessage_fields.state = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.state_maxlength, "<<MAXLENGTH>>", maxlength_Address.state, "ALL"), "<<LEN>>", Len(Form.state), "ALL")>
<cfelseif Not ListFind(Variables.selectStateList_value, Form.state)>
	<cfset errorMessage_fields.state = Variables.lang_insertAddress.state_valid>
</cfif>

<cfif Trim(Form.zipCode) is "">
	<cfset errorMessage_fields.zipCode = Variables.lang_insertAddress.zipCode_blank>
<cfelseif Len(Form.zipCode) gt maxlength_Address.zipCode>
	<cfset errorMessage_fields.zipCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.zipCode_maxlength, "<<MAXLENGTH>>", maxlength_Address.zipCode, "ALL"), "<<LEN>>", Len(Form.zipCode), "ALL")>
<cfelseif REFindNoCase("[^A-Za-z0-9 -]", Form.zipCode)>
	<cfset errorMessage_fields.zipCode = Variables.lang_insertAddress.zipCode_valid>
</cfif>

<cfif Len(Form.zipCodePlus4) gt maxlength_Address.zipCodePlus4>
	<cfset errorMessage_fields.zipCodePlus4 = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.zipCodePlus4, "<<MAXLENGTH>>", maxlength_Address.zipCodePlus4, "ALL"), "<<LEN>>", Len(Form.zipCodePlus4), "ALL")>
</cfif>

<cfif Len(Form.county) gt maxlength_Address.county>
	<cfset errorMessage_fields.county = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.county, "<<MAXLENGTH>>", maxlength_Address.county, "ALL"), "<<LEN>>", Len(Form.county), "ALL")>
</cfif>

<cfif Trim(Form.countryOther) is not "">
	<cfif Len(Form.countryOther) gt maxlength_Address.country>
		<cfset errorMessage_fields.country = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.country_maxlength, "<<MAXLENGTH>>", maxlength_Address.country, "ALL"), "<<LEN>>", Len(Form.countryOther), "ALL")>
	<cfelse>
		<cfset Form.country = Form.countryOther>
	</cfif>
<cfelseif Trim(Form.country) is "">
	<cfset errorMessage_fields.country = Variables.lang_insertAddress.country_blank>
<cfelseif Len(Form.country) gt maxlength_Address.country>
	<cfset errorMessage_fields.country = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertAddress.country_maxlength, "<<MAXLENGTH>>", maxlength_Address.country, "ALL"), "<<LEN>>", Len(Form.country), "ALL")>
<cfelseif Not ListFind(Variables.countryList_value, Form.country)>
	<cfset errorMessage_fields.country = Variables.lang_insertAddress.country_valid>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.addressID is 0>
		<cfset errorMessage_title = Variables.lang_insertAddress.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertAddress.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertAddress.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertAddress.errorFooter>
</cfif>

