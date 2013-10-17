<!--- shipping address --->
<cfset Variables.isContactTemplate.shippingAddress_subject = False>
<cfset Variables.isContactTemplate.shippingAddress_message = False>

<cfif FindNoCase("<<shipping", qry_selectContactTemplate.contactTemplateSubject)>
	<cfset Variables.isContactTemplate.shippingAddress_subject = True>
</cfif>
<cfif FindNoCase("<<shipping", qry_selectContactTemplate.contactTemplateMessage)>
	<cfset Variables.isContactTemplate.shippingAddress_message = True>
</cfif>

<cfif Variables.isContactTemplate.shippingAddress_subject is True or Variables.isContactTemplate.shippingAddress_message is True>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectCustomerShippingAddress">
		<cfinvokeargument Name="addressID" Value="#qry_selectCustomerInvoice.addressID_shipping#">
	</cfinvoke>

	<cfif qry_selectCustomerShippingAddress.RecordCount is not 0 and Variables.isContactTemplate.shippingAddress_message is True>
		<cfset Variables.shippingAddressStreet = qry_selectCustomerShippingAddress.address>
		<cfif qry_selectCustomerShippingAddress.address2 is not "">
			<cfset Variables.shippingAddressStreet = Variables.shippingAddressStreet & Variables.carriageReturn & qry_selectCustomerShippingAddress.address2>
		</cfif>
		<cfif qry_selectCustomerShippingAddress.address3 is not "">
			<cfset Variables.shippingAddressStreet = Variables.shippingAddressStreet & Variables.carriageReturn & qry_selectCustomerShippingAddress.address3>
		</cfif>

		<cfset Variables.shippingAddressFull = Variables.shippingAddressStreet & Variables.carriageReturn & qry_selectCustomerShippingAddress.city
				& ", " & qry_selectCustomerShippingAddress.state & " " & qry_selectCustomerShippingAddress.zipCode>
		<cfif qry_selectCustomerShippingAddress.zipCodePlus4 is not "">
			<cfset Variables.shippingAddressFull = Variables.shippingAddressStreet & "-" & qry_selectCustomerShippingAddress.zipCodePlus4>
		</cfif>
		<cfif Not ListFindNoCase("US,USA,United States", qry_selectCustomerShippingAddress.country)>
			<cfset Variables.shippingAddressFull = Variables.shippingAddressStreet & Variables.carriageReturn & qry_selectCustomerShippingAddress.country>
		</cfif>

		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingAddressStreet>>", Variables.shippingAddressStreet, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingAddressFull>>", Variables.shippingAddressFull, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingAddressName>>", qry_selectCustomerShippingAddress.addressName, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingAddress1>>", qry_selectCustomerShippingAddress.address, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingAddress2>>", qry_selectCustomerShippingAddress.address2, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingAddress3>>", qry_selectCustomerShippingAddress.address3, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingCity>>", qry_selectCustomerShippingAddress.city, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingState>>", qry_selectCustomerShippingAddress.state, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingZipCode>>", qry_selectCustomerShippingAddress.zipCode, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingZipCodePlus4>>", qry_selectCustomerShippingAddress.zipCodePlus4, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingCountry>>", qry_selectCustomerShippingAddress.country, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shippingCounty>>", qry_selectCustomerShippingAddress.county, "ALL")>
	</cfif><!--- /replace shipping address fields --->
</cfif><!--- /if replacing shipping address fields --->
