<!--- credit card --->
<cfset Arguments.creditCardID = 0>
<cfif ListFind(Arguments.insertExtendedFieldTypeList, "creditCardID") and ListFind(permissionActionList, "insertCreditCard")>
	<cfset Arguments.addressID = Arguments.addressID_billing>
	<cfset Form.addressID = Arguments.addressID>
	<cfset URL.creditCardID = 0>
	<cfset returnValue = 0>

	<cfinclude template="../ws_creditCard/wsact_insertCreditCard.cfm">
	<cfif returnValue gt 0>
		<cfset Arguments.creditCardID = returnValue>
		<cfset returnValueXml = returnValueXml & "<creditCardID>#Arguments.creditCardID#</creditCardID>">
	</cfif>
</cfif>

<!--- bank --->
<cfset Arguments.bankID = 0>
<cfif ListFind(Arguments.insertExtendedFieldTypeList, "bankID") and ListFind(permissionActionList, "insertBank")>
	<cfset Arguments.addressID = 0>
	<cfset Form.addressID = Arguments.addressID>
	<cfset URL.bankID = 0>
	<cfset returnValue = 0>

	<cfinclude template="../ws_bank/wsact_insertBank.cfm">
	<cfif returnValue gt 0>
		<cfset Arguments.bankID = returnValue>
		<cfset returnValueXml = returnValueXml & "<bankID>#Arguments.bankID#</bankID>">
	</cfif>
</cfif>
