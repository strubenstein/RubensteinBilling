<!--- billing address --->
<cfset Variables.isContactTemplate.billingAddress_subject = False>
<cfset Variables.isContactTemplate.billingAddress_message = False>

<cfif FindNoCase("<<billing", qry_selectContactTemplate.contactTemplateSubject)>
	<cfset Variables.isContactTemplate.billingAddress_subject = True>
</cfif>
<cfif FindNoCase("<<billing", qry_selectContactTemplate.contactTemplateMessage)>
	<cfset Variables.isContactTemplate.billingAddress_message = True>
</cfif>

<cfif Variables.isContactTemplate.billingAddress_subject is True or Variables.isContactTemplate.billingAddress_message is True>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectCustomerBillingAddress">
		<cfinvokeargument Name="addressID" Value="#qry_selectCustomerInvoice.addressID_billing#">
	</cfinvoke>

	<cfif qry_selectCustomerBillingAddress.RecordCount is not 0 and Variables.isContactTemplate.billingAddress_message is True>
		<cfset Variables.billingAddressStreet = qry_selectCustomerBillingAddress.address>
		<cfif qry_selectCustomerBillingAddress.address2 is not "">
			<cfset Variables.billingAddressStreet = Variables.billingAddressStreet & Variables.carriageReturn & qry_selectCustomerBillingAddress.address2>
		</cfif>
		<cfif qry_selectCustomerBillingAddress.address3 is not "">
			<cfset Variables.billingAddressStreet = Variables.billingAddressStreet & Variables.carriageReturn & qry_selectCustomerBillingAddress.address3>
		</cfif>

		<cfset Variables.billingAddressFull = Variables.billingAddressStreet & Variables.carriageReturn & qry_selectCustomerBillingAddress.city
				& ", " & qry_selectCustomerBillingAddress.state & " " & qry_selectCustomerBillingAddress.zipCode>
		<cfif qry_selectCustomerBillingAddress.zipCodePlus4 is not "">
			<cfset Variables.billingAddressFull = Variables.billingAddressStreet & "-" & qry_selectCustomerBillingAddress.zipCodePlus4>
		</cfif>
		<cfif Not ListFindNoCase("US,USA,United States", qry_selectCustomerBillingAddress.country)>
			<cfset Variables.billingAddressFull = Variables.billingAddressStreet & Variables.carriageReturn & qry_selectCustomerBillingAddress.country>
		</cfif>

		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingAddressStreet>>", Variables.billingAddressStreet, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingAddressFull>>", Variables.billingAddressFull, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingAddressName>>", qry_selectCustomerBillingAddress.addressName, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingAddress1>>", qry_selectCustomerBillingAddress.address, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingAddress2>>", qry_selectCustomerBillingAddress.address2, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingAddress3>>", qry_selectCustomerBillingAddress.address3, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingCity>>", qry_selectCustomerBillingAddress.city, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingState>>", qry_selectCustomerBillingAddress.state, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingZipCode>>", qry_selectCustomerBillingAddress.zipCode, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingZipCodePlus4>>", qry_selectCustomerBillingAddress.zipCodePlus4, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingCountry>>", qry_selectCustomerBillingAddress.country, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<billingCounty>>", qry_selectCustomerBillingAddress.county, "ALL")>
	</cfif><!--- /replace billing address fields --->
</cfif><!--- /if replacing billing address fields --->
