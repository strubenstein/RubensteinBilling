<!--- shipment info --->
<cfset Variables.isContactTemplate.shipment_subject = False>
<cfset Variables.isContactTemplate.shipment_message = False>

<cfif FindNoCase("<<shipment", qry_selectContactTemplate.contactTemplateSubject)>
	<cfset Variables.isContactTemplate.shipment_subject = True>
</cfif>
<cfif FindNoCase("<<shipment", qry_selectContactTemplate.contactTemplateMessage)>
	<cfset Variables.isContactTemplate.shipment_message = True>
</cfif>

<cfif Variables.isContactTemplate.shipment_subject is True or Variables.isContactTemplate.shipment_message is True>
	<cfinvoke Component="#Application.billingMapping#data.Shipping" Method="selectShipping" ReturnVariable="qry_selectCustomerShipment">
		<cfinvokeargument Name="shippingID" Value="#Variables.shippingID#">
	</cfinvoke>

	<cfif qry_selectCustomerShipment.RecordCount is not 0 and Variables.isContactTemplate.shipment_subject is True>
		<cfif IsDate(qry_selectCustomerShipment.shippingDateSent)>
			<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentDateSent>>", DateFormat(qry_selectCustomerShipment.shippingDateSent, "mmmm dd, yyyy"), "ALL")>
		<cfelse>
			<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentDateSent>>", "N/A", "ALL")>
		</cfif>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentCarrier>>", qry_selectCustomerShipment.shippingCarrier, "ALL")>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentMethod>>", qry_selectCustomerShipment.shippingMethod, "ALL")>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentWeight>>", qry_selectCustomerShipment.shippingWeight, "ALL")>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentTrackingNumber>>", qry_selectCustomerShipment.shippingTrackingNumber, "ALL")>
		<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentInstructions>>", qry_selectCustomerShipment.shippingInstructions, "ALL")>
		<cfif IsDate(qry_selectCustomerShipment.shippingDateReceived)>
			<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentDateReceived>>", DateFormat(qry_selectCustomerShipment.shippingDateReceived, "mmmm dd, yyyy"), "ALL")>
		<cfelse>
			<cfset Form.contactSubject = ReplaceNoCase(Form.contactSubject, "<<shipmentDateReceived>>", "N/A", "ALL")>
		</cfif>
	</cfif>

	<cfif qry_selectCustomerShipment.RecordCount is not 0 and Variables.isContactTemplate.shipment_message is True>
		<cfif IsDate(qry_selectCustomerShipment.shippingDateSent)>
			<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentDateSent>>", DateFormat(qry_selectCustomerShipment.shippingDateSent, "mmmm dd, yyyy"), "ALL")>
		<cfelse>
			<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentDateSent>>", "N/A", "ALL")>
		</cfif>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentCarrier>>", qry_selectCustomerShipment.shippingCarrier, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentMethod>>", qry_selectCustomerShipment.shippingMethod, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentWeight>>", qry_selectCustomerShipment.shippingWeight, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentTrackingNumber>>", qry_selectCustomerShipment.shippingTrackingNumber, "ALL")>
		<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentInstructions>>", qry_selectCustomerShipment.shippingInstructions, "ALL")>
		<cfif IsDate(qry_selectCustomerShipment.shippingDateReceived)>
			<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentDateReceived>>", DateFormat(qry_selectCustomerShipment.shippingDateReceived, "mmmm dd, yyyy"), "ALL")>
		<cfelse>
			<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<shipmentDateReceived>>", "N/A", "ALL")>
		</cfif>
	</cfif>
</cfif><!--- if shipment info --->
