<!--- 
Data necessary to generate a full invoice or receipt:

Invoice
User
Company
Subscriber
Payment information
	- Applied to this invoice
	- Since last invoice
Refunds since last invoice
Credits
Line Items
	- Product Parameters
	- Product Parameter Exception
Taxes
	- Invoice
	- Line Items

INPUT:
Variables.invoiceID
Variables.templateID
--->

<!--- Invoice --->
<cfif URL.control is not "invoice">
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	</cfinvoke>
</cfif>

<!--- Line Items --->
<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
	<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
</cfinvoke>

<!--- Determine if any line items have custom product ID, begin date or end date --->
<cfset Variables.displayInvoiceLineItemProductID_custom = False>
<cfset Variables.displayInvoiceLineItemDateBegin = False>
<cfset Variables.displayInvoiceLineItemDateEnd = False>

<cfif REFind("[A-Za-z0-9]", ValueList(qry_selectInvoiceLineItemList.invoiceLineItemProductID_custom))>
	<cfset Variables.displayInvoiceLineItemProductID_custom = False>
</cfif>
<cfif REFind("[0-9]", ValueList(qry_selectInvoiceLineItemList.invoiceLineItemDateBegin))>
	<cfset Variables.displayInvoiceLineItemDateBegin = False>
</cfif>
<cfif REFind("[0-9]", ValueList(qry_selectInvoiceLineItemList.invoiceLineItemDateEnd))>
	<cfset Variables.displayInvoiceLineItemDateEnd = False>
</cfif>

<!--- Line Item Parameter Options --->
<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemParameterList" ReturnVariable="qry_selectInvoiceLineItemParameterList">
	<cfinvokeargument Name="invoiceLineItemID" Value="#ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID)#">
</cfinvoke>

<!--- Line Item Parameter Options: Text --->
<cfif qry_selectInvoiceLineItemParameterList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="selectProductParameterOption" ReturnVariable="qry_selectProductParameterOption">
		<cfinvokeargument Name="productParameterOptionID" Value="#ValueList(qry_selectInvoiceLineItemParameterList.productParameterOptionID)#">
	</cfinvoke>
</cfif>

<!--- Line Item Parameter Exceptions --->
<cfif REFind("[1-9]", ValueList(qry_selectInvoiceLineItemList.productParameterExceptionID))>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="selectProductParameterException" ReturnVariable="qry_selectProductParameterExceptionList">
		<cfinvokeargument Name="productParameterExceptionID" Value="#ValueList(qry_selectInvoiceLineItemList.productParameterExceptionID)#">
	</cfinvoke>
</cfif>

<cfif qry_selectInvoice.addressID_shipping is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectShippingAddress">
		<cfinvokeargument Name="addressID" Value="#qry_selectInvoice.addressID_shipping#">
	</cfinvoke>
</cfif>

<cfif qry_selectInvoice.addressID_billing is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectBillingAddress">
		<cfinvokeargument Name="addressID" Value="#qry_selectInvoice.addressID_billing#">
	</cfinvoke>
</cfif>

<!--- Company --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
	<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
</cfinvoke>

<!--- User --->
<cfif qry_selectInvoice.userID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#qry_selectInvoice.userID#">
	</cfinvoke>
</cfif>

<!--- get subscriber name --->
<cfset Variables.displaySubscriberName = False>
<cfif qry_selectInvoice.subscriberID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
		<cfinvokeargument Name="subscriberID" Value="#qry_selectInvoice.subscriberID#">
	</cfinvoke>

	<cfif qry_selectSubscriber.RecordCount is 1>
		<cfset Variables.displaySubscriberName = True>
	</cfif>
</cfif>

<!--- initialize list of credit cards and bank accounts --->
<cfset Variables.creditCardID_list = "">
<cfset Variables.bankID_list = "">

<cfif qry_selectInvoice.creditCardID is not 0>
	<cfset Variables.creditCardID_list = qry_selectInvoice.creditCardID>
</cfif>
<cfif qry_selectInvoice.bankID is not 0>
	<cfset Variables.bankID_list = qry_selectInvoice.bankID>
</cfif>

<!--- Payments applied to this invoice --->
<cfinvoke Component="#Application.billingMapping#data.InvoicePayment" Method="selectInvoicePaymentList" ReturnVariable="qry_selectInvoicePaymentList">
	<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="False">
	<cfinvokeargument Name="returnPaymentFields" Value="True">
</cfinvoke>

<!--- add to list of credit cards and bank accounts --->
<cfloop Query="qry_selectInvoicePaymentList">
	<cfif qry_selectInvoicePaymentList.creditCardID is not 0>
		<cfset Variables.creditCardID_list = ListAppend(Variables.creditCardID_list, qry_selectInvoicePaymentList.creditCardID)>
	</cfif>
	<cfif qry_selectInvoicePaymentList.bankID is not 0>
		<cfset Variables.bankID_list = ListAppend(Variables.bankID_list, qry_selectInvoicePaymentList.bankID)>
	</cfif>
</cfloop>

<!--- get last invoice closed before this invoice --->
<cfif IsDate(qry_selectInvoice.invoiceDateClosed)>
	<cfset Variables.dateTo = qry_selectInvoice.invoiceDateClosed>
<cfelse>
	<cfset Variables.dateTo = qry_selectInvoice.invoiceDateCreated>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoiceList" ReturnVariable="qry_selectLastInvoice">
	<cfinvokeargument Name="companyID_author" Value="#qry_selectInvoice.companyID_author#">
	<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
	<cfinvokeargument Name="subscriberID" Value="#qry_selectInvoice.subscriberID#">
	<cfinvokeargument Name="invoiceClosed" Value="1">
	<cfinvokeargument Name="invoiceID_not" Value="#Variables.invoiceID#">
	<cfinvokeargument Name="invoiceDateTo" Value="#Variables.dateTo#">
	<cfinvokeargument Name="invoiceDateType" Value="invoiceDateClosed">
	<cfinvokeargument Name="queryOrderBy" Value="invoiceDateClosed_d">
	<cfinvokeargument Name="queryDisplayPerPage" Value="1">
	<cfinvokeargument Name="queryPage" Value="1">
	<cfinvokeargument Name="queryOrderBy" Value="invoiceDateClosed_d">
	<cfinvokeargument Name="queryDisplayResults" Value="False">
</cfinvoke>

<cfif qry_selectLastInvoice.RecordCount is 1>
	<cfif IsDate(qry_selectLastInvoice.invoiceDateClosed)>
		<cfset Variables.dateFrom = qry_selectLastInvoice.invoiceDateClosed>
	<cfelse>
		<cfset Variables.dateFrom = qry_selectLastInvoice.invoiceDateCreated>
	</cfif>

	<!--- Payments since last invoice --->
	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPaymentList" ReturnVariable="qry_selectPaymentsSinceLastInvoice">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
		<cfinvokeargument Name="subscriberID" Value="#qry_selectInvoice.subscriberID#">
		<cfinvokeargument Name="paymentIsRefund" value="0">
		<cfinvokeargument Name="paymentStatus" value="1">
		<cfinvokeargument Name="paymentApproved" value="1">
		<cfinvokeargument Name="paymentDateReceived_from" value="#Variables.dateFrom#">
		<cfinvokeargument Name="paymentDateReceived_to" value="#Variables.dateTo#">
		<cfinvokeargument Name="queryOrderBy" Value="paymentDateReceived">
		<cfinvokeargument Name="queryDisplayPerPage" Value="0">
		<cfinvokeargument Name="queryPage" Value="0">
	</cfinvoke>

	<!--- add to list of credit cards and bank accounts --->
	<cfloop Query="qry_selectPaymentsSinceLastInvoice">
		<cfif qry_selectPaymentsSinceLastInvoice.creditCardID is not 0 and Not ListFind(Variables.creditCardID_list, qry_selectPaymentsSinceLastInvoice.creditCardID)>
			<cfset Variables.creditCardID_list = ListAppend(Variables.creditCardID_list, qry_selectPaymentsSinceLastInvoice.creditCardID)>
		</cfif>
		<cfif qry_selectPaymentsSinceLastInvoice.bankID is not 0 and Not ListFind(Variables.bankID_list, qry_selectPaymentsSinceLastInvoice.bankID)>
			<cfset Variables.bankID_list = ListAppend(Variables.bankID_list, qry_selectPaymentsSinceLastInvoice.bankID)>
		</cfif>
	</cfloop>

	<!--- Refunds since last invoice --->
	<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPaymentList" ReturnVariable="qry_selectPaymentRefundsSinceLastInvoice">
		<cfinvokeargument Name="companyID_author" value="#Session.companyID_author#">
		<cfinvokeargument Name="companyID" value="#qry_selectInvoice.companyID#">
		<cfinvokeargument Name="subscriberID" value="#qry_selectInvoice.subscriberID#">
		<cfinvokeargument Name="paymentIsRefund" value="1">
		<cfinvokeargument Name="paymentStatus" value="1">
		<cfinvokeargument Name="paymentApproved" value="1">
		<cfinvokeargument Name="paymentDateReceived_from" value="#Variables.dateFrom#">
		<cfinvokeargument Name="paymentDateReceived_to" value="#Variables.dateTo#">
		<cfinvokeargument Name="queryOrderBy" Value="paymentDateReceived">
		<cfinvokeargument Name="queryDisplayPerPage" Value="0">
		<cfinvokeargument Name="queryPage" Value="0">
	</cfinvoke>

	<!--- add to list of credit cards and bank accounts --->
	<cfloop Query="qry_selectPaymentRefundsSinceLastInvoice">
		<cfif qry_selectPaymentRefundsSinceLastInvoice.creditCardID is not 0 and Not ListFind(Variables.creditCardID_list, qry_selectPaymentRefundsSinceLastInvoice.creditCardID)>
			<cfset Variables.creditCardID_list = ListAppend(Variables.creditCardID_list, qry_selectPaymentRefundsSinceLastInvoice.creditCardID)>
		</cfif>
		<cfif qry_selectPaymentRefundsSinceLastInvoice.bankID is not 0 and Not ListFind(Variables.bankID_list, qry_selectPaymentRefundsSinceLastInvoice.bankID)>
			<cfset Variables.bankID_list = ListAppend(Variables.bankID_list, qry_selectPaymentRefundsSinceLastInvoice.bankID)>
		</cfif>
	</cfloop>
</cfif>

<!--- Credits --->
<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCreditList" ReturnVariable="qry_selectInvoicePaymentCreditList">
	<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="False">
	<cfinvokeargument Name="returnPaymentCreditFields" Value="True">
</cfinvoke>

<!--- Credit Cards --->
<cfif Variables.creditCardID_list is not "">
	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
		<cfinvokeargument Name="creditCardID" Value="#Variables.creditCardID_list#">
		<cfinvokeargument Name="returnCompanyFields" Value="False">
	</cfinvoke>
</cfif>

<!--- Banks --->
<cfif Variables.bankID_list is not "">
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
		<cfinvokeargument Name="bankID" Value="#Variables.bankID_list#">
		<cfinvokeargument Name="returnCompanyFields" Value="False">
	</cfinvoke>
</cfif>

<!--- select template used to generate invoice --->
<!--- 
<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplate">
	<cfinvokeargument Name="companyID" Value="0,#qry_selectInvoice.companyID_author#">
	<cfinvokeargument Name="templateType" Value="Invoice">
	<cfinvokeargument Name="templateStatus" Value="1">
	<cfinvokeargument Name="templateDefault" Value="1">
	<cfinvokeargument Name="returnTemplateXML" Value="True">
</cfinvoke>
--->

<cfparam Name="Variables.templateID" Default="0">
<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplate" ReturnVariable="qry_selectTemplate">
	<cfinvokeargument Name="templateID" Value="#Variables.templateID#">
	<cfinvokeargument Name="returnTemplateXML" Value="True">
</cfinvoke>

<!--- convert template XML options into simpler structure --->
<cfset Variables.templateStruct = StructNew()>
<cfinclude template="../../view/v_template/var_templateFormFields_#qry_selectTemplate.templateFilename#"><!--- defaultInvoice.cfm --->
<cfset templateXmlObject = XmlParse("<templateXml>#qry_selectTemplate.templateXml#</templateXml>")>
<cfloop Index="field" List="#Variables.templateFormFields#">
	<cfif StructKeyExists(templateXmlObject.templateXml, field)>
		<cfset Variables.templateStruct[field] = templateXmlObject.templateXml[field].XmlText>
	<cfelse>
		<cfset Variables.templateStruct[field] = "">
	</cfif>
</cfloop>

<cfinclude template="../../include/template/#qry_selectTemplate.templateFilename#"><!--- defaultInvoice.cfm --->

<!--- 
<cfset Variables.primaryTargetArray = ArrayNew(1)>
<cfset Variables.primaryTargetArray[1] = Application.fn_GetPrimaryTargetID("invoiceID") & "," & URL.invoiceID>
<cfset Variables.primaryTargetArray[2] = Application.fn_GetPrimaryTargetID("companyID") & "," & qry_selectInvoice.companyID>
<cfset Variables.primaryTargetArray[3] = Application.fn_GetPrimaryTargetID("userID") & "," & qry_selectInvoice.userID>
--->

