<!--- insert BR tags in invoice template for address, contact, and payment messages --->

<cfinclude template="../../view/v_template/var_templateFormFields_#qry_selectTemplate.templateFilename#"><!--- defaultInvoice.cfm --->
<cfinclude template="../../view/v_template/lang_customizeTemplate_defaultInvoice.cfm">

<!--- invoiceLineItemFields_invoiceLineItemDescription_header, --->
<cfset templateXmlObject = XmlParse("<templateXml>#qry_selectTemplate.templateXml#</templateXml>")>

<cfloop Index="field" List="#Variables.templateFormFields#">
	<cfif StructKeyExists(templateXmlObject.templateXml, field)>
		<cfparam Name="Form.#field#" Default="#templateXmlObject.templateXml[field].XmlText#">
	</cfif>
</cfloop>

<cfparam Name="Form.documentTitle" Default="">
<cfparam Name="Form.companyLogo" Default="">
<cfparam Name="Form.companyLegalName" Default="">
<cfparam Name="Form.companySlogan" Default="">
<cfparam Name="Form.companyAddress" Default="">
<cfparam Name="Form.companyContact" Default="">

<cfparam Name="Form.companyFields" Default="">
<cfparam Name="Form.companyFields_companyName_header" Default="">
<cfparam Name="Form.companyFields_companyNameOrDBA" Default="">
<cfparam Name="Form.companyFields_companyID_header" Default="">
<cfparam Name="Form.companyFields_companyIDOrCustomID" Default="">
<cfparam Name="Form.userFields" Default="">
<cfparam Name="Form.userFields_fullName_header" Default="">

<cfparam Name="Form.invoiceFields" Default="">
<cfparam Name="Form.invoiceFields_invoiceID_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceIDorCustomID" Default="">
<cfparam Name="Form.invoiceFields_invoiceDateClosed_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceDateClosed_dateFormat" Default="mmmm dd, yyyy">
<cfparam Name="Form.invoiceFields_invoiceDateDue_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceDateDue_dateFormat" Default="mmmm dd, yyyy">
<cfparam Name="Form.invoiceFields_addressID_billing_header" Default="">
<cfparam Name="Form.invoiceFields_addressID_shipping_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceShippingMethod_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceInstructions_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceTotalLineItem_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceTotalPaymentCredit_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceTotalShipping_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceTotalTax_header" Default="">
<cfparam Name="Form.invoiceFields_invoiceTotal_header" Default="">
<cfparam Name="Form.invoiceFields_paymentForThisInvoice_header" Default="">
<cfparam Name="Form.invoiceFields_paymentSinceLastInvoice_header" Default="">
<cfparam Name="Form.invoiceFields_paymentRefundSinceLastInvoice_header" Default="">

<cfparam Name="Form.invoiceLineItemFields" Default="">
<cfparam Name="Form.invoiceLineItemFields_order" Default="">
<!--- invoiceLineItemOrder,invoiceLineItemName,invoiceLineItemQuantity,invoiceLineItemProductID_custom,invoiceLineItemDateBegin,invoiceLineItemDateEnd,invoiceLineItemPriceNormal,invoiceLineItemPriceUnit,invoiceLineItemSubTotal,invoiceLineItemDiscount,invoiceLineItemTotalTax,invoiceLineItemTotal --->
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemOrder_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemName_header" Default="">
<!--- <cfparam Name="Form.invoiceLineItemFields_invoiceLineItemDescription_header" Default=""> --->
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemQuantity_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemProductID_custom_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemDateBegin_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemDateEnd_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemPriceNormal_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemPriceUnit_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemSubTotal_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemDiscount_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemTotalTax_header" Default="">
<cfparam Name="Form.invoiceLineItemFields_invoiceLineItemTotal_header" Default="">

<cfparam Name="Form.paymentDateScheduled_dateFormat" Default="mmmm dd, yyyy">
<cfparam Name="Form.paymentMethod_creditCardID_text" Default="">
<cfparam Name="Form.paymentMethod_bankID_text" Default="">
<cfparam Name="Form.paymentMethod_other_text" Default="">
<cfparam Name="Form.documentFooter" Default="">

<cfset Variables.dateFormatList = "mmmm dd, yyyy|mmmm dd, yyyy|mm/dd/yyyy|m/d/yyyy|mm/dd/yy|m/d/yyyy|dd/mm/yyyy|d/m/yyyy|dd/mm/yy|d/m/yy">
<cfset Variables.invoiceFields_value = "addressID_billing,addressID_shipping,invoiceShippingMethod,invoiceInstructions,invoiceTotalLineItem,invoiceTotalPaymentCredit,invoiceTotalShipping,invoiceTotalTax,invoiceTotal,paymentForThisInvoice,paymentSinceLastInvoice,paymentRefundSinceLastInvoice">
<cfset Variables.invoiceFields_label = Variables.lang_customizeTemplate.billingAddress
		& "," & Variables.lang_customizeTemplate.shippingAddress
		& "," & Variables.lang_customizeTemplate.invoiceShippingMethod
		& "," & Variables.lang_customizeTemplate.invoiceInstructions
		& "," & Variables.lang_customizeTemplate.invoiceTotalLineItem
		& "," & Variables.lang_customizeTemplate.invoiceTotalCredit
		& "," & Variables.lang_customizeTemplate.invoiceTotalShipping
		& "," & Variables.lang_customizeTemplate.invoiceTotalTax
		& "," & Variables.lang_customizeTemplate.invoiceTotal
		& "," & Variables.lang_customizeTemplate.paymentsThisInvoice
		& "," & Variables.lang_customizeTemplate.paymentsLastInvoice
		& "," & Variables.lang_customizeTemplate.refundLastInvoice>

<cfset Variables.invoiceLineItemFields_value = "invoiceLineItemOrder,invoiceLineItemProductID_custom,invoiceLineItemName,invoiceLineItemQuantity,invoiceLineItemDateBegin,invoiceLineItemDateEnd,invoiceLineItemPriceNormal,invoiceLineItemPriceUnit,invoiceLineItemSubTotal,invoiceLineItemDiscount,invoiceLineItemTotalTax,invoiceLineItemTotal">
<cfset Variables.invoiceLineItemFields_label = Variables.lang_customizeTemplate.invoiceLineItemOrder
		& "," & Variables.lang_customizeTemplate.invoiceLineItemID_custom
		& "," & Variables.lang_customizeTemplate.invoiceLineItemName
		& "," & Variables.lang_customizeTemplate.invoiceLineItemQuantity
		& "," & Variables.lang_customizeTemplate.invoiceLineItemDateBegin
		& "," & Variables.lang_customizeTemplate.invoiceLineItemDateEnd
		& "," & Variables.lang_customizeTemplate.invoiceLineItemPriceNormal
		& "," & Variables.lang_customizeTemplate.invoiceLineItemPriceUnit
		& "," & Variables.lang_customizeTemplate.invoiceLineItemSubTotal
		& "," & Variables.lang_customizeTemplate.invoiceLineItemDiscount
		& "," & Variables.lang_customizeTemplate.invoiceLineItemTax
		& "," & Variables.lang_customizeTemplate.invoiceLineItemTotal>


<cfif IsDefined("Form.isFormSubmitted") and (IsDefined("Form.submitCustomizeTemplate") or IsDefined("Form.submitPreviewTemplate"))>
	<!--- Validate date fields use valid date format --->
	<cfloop Index="field" List="invoiceFields_invoiceDateClosed_dateFormat,invoiceFields_invoiceDateDue_dateFormat,paymentDateScheduled_dateFormat">
		<cfif Not ListFind(Variables.dateFormatList, Form[field])>
			<cfset Form[field] = "mmmm dd, yyyy">
		</cfif>
	</cfloop>

	<!--- validate the list of line item fields are all valid line item fields --->
	<cfloop Index="field" List="#Form.invoiceLineItemFields#">
		<cfif Not ListFind(Variables.invoiceLineItemFields_value, field)>
			<cfset Form.invoiceLineItemFields = "">
			<cfbreak>
		</cfif>
	</cfloop>

	<!--- validate the order of the line item fields are all valid line item fields --->
	<cfloop Index="field" List="#Form.invoiceLineItemFields_order#">
		<cfif Not ListFind(Variables.invoiceLineItemFields_value, field)>
			<cfset Form.invoiceLineItemFields_order = Form.invoiceLineItemFields>
			<cfbreak>
		</cfif>
	</cfloop>

	<!--- update template --->
	<cfif IsDefined("Form.submitCustomizeTemplate")>
		<cfset Variables.newTemplateXml = "">
		<cfloop Index="field" List="#Variables.templateFormFields#">
			<cfset Variables.newTemplateXml = Variables.newTemplateXml & "<#field#>" & XmlFormat(Form[field]) & "</#field#>">
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#data.Template" Method="updateTemplate" ReturnVariable="isTemplateUpdated">
			<cfinvokeargument Name="templateID" Value="#URL.templateID#">
			<cfinvokeargument Name="templateXml" Value="#Variables.newTemplateXml#">
		</cfinvoke>

		<cflocation url="index.cfm?method=template.#Variables.doAction#&templateID=#URL.templateID#&confirm_template=#Variables.doAction#" AddToken="No">

	<!--- preview template with form options --->
	<cfelse>
		<cfinclude template="../c_invoice/act_previewInvoiceTemplate.cfm">

		<!--- convert template XML options into simpler structure --->
		<cfset Variables.templateStruct = StructNew()>
		<cfloop Index="field" List="#Variables.templateFormFields#">
			<cfset Variables.templateStruct[field] = Form[field]>
		</cfloop>

		<cfoutput>#Variables.lang_customizeTemplate.header_preview#</cfoutput>
		<cfinclude template="../../include/template/#qry_selectTemplate.templateFilename#"><!--- defaultInvoice.cfm --->
		<cfoutput>#Variables.lang_customizeTemplate.header_customize#</cfoutput>
	</cfif>
</cfif>

<cfset Variables.formName = "invoiceTemplate">
<cfset Variables.formAction = "index.cfm?method=template.#Variables.doAction#&templateID=#URL.templateID#">
<cfset Variables.formSubmitValue = Variables.lang_customizeTemplate.formSubmitValue_save>
<cfset Variables.formPreviewValue = Variables.lang_customizeTemplate.formSubmitValue_preview>

<cfinclude template="../../view/v_template/form_customizeTemplate_#qry_selectTemplate.templateFilename#"><!--- defaultInvoice.cfm --->

