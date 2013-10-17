<!--- address: billing and maybe shipping --->
<cfset Arguments.addressID_billing = 0>
<cfset Arguments.addressID_shipping = 0>
<cfset URL.addressID = 0>
<cfset Variables.doAction = "insertAddress">

<cfif ListFind(Arguments.insertExtendedFieldTypeList, "addressID_billing") and ListFind(permissionActionList, "insertAddress")>
	<cfloop Index="field" List="addressName,addressDescription,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country">
		<cfset Arguments[field] = Arguments["#field#_billing"]>
	</cfloop>

	<cfset Variables.doAction = "insertAddress">
	<cfset Arguments.addressTypeBilling = 1>
	<cfif Arguments.shippingAddressSameAsBillingAddress is True>
		<cfset Arguments.addressTypeShipping = 1>
	<cfelse>
		<cfset Arguments.addressTypeShipping = 0>
	</cfif>

	<cfset returnValue = 0>
	<cfinclude template="../ws_address/wsact_insertUpdateAddress.cfm">
	<cfif returnValue gt 0>
		<cfset Arguments.addressID_billing = returnValue>
		<cfset returnValueXml = returnValueXml & "<addressID_billing>#Arguments.addressID_billing#</addressID_billing>">

		<cfif Arguments.addressTypeShipping is 1>
			<cfset Arguments.addressID_shipping = Arguments.addressID_billing>
			<cfset returnValueXml = returnValueXml & "<addressID_shipping>#Arguments.addressID_shipping#</addressID_shipping>">
		</cfif>
	</cfif>
</cfif>

<!--- shipping address --->
<cfif Arguments.addressID_shipping is 0 and ListFind(Arguments.insertExtendedFieldTypeList, "addressID_shipping") and ListFind(permissionActionList, "insertAddress")>
	<cfloop Index="field" List="addressName,addressDescription,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country">
		<cfset Arguments[field] = Arguments["#field#_shipping"]>
	</cfloop>

	<cfset Variables.doAction = "insertAddress">
	<cfset Arguments.addressTypeBilling = 0>
	<cfset Arguments.addressTypeShipping = 1>

	<cfset returnValue = 0>
	<cfinclude template="../ws_address/wsact_insertUpdateAddress.cfm">
	<cfif returnValue gt 0>
		<cfset Arguments.addressID_shipping = returnValue>
		<cfset returnValueXml = returnValueXml & "<addressID_shipping>#Arguments.addressID_shipping#</addressID_shipping>">
	</cfif>
</cfif>
