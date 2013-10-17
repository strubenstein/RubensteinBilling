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
--->

<cfset Variables.invoiceID = 0>
<cfinclude template="../../view/v_invoice/lang_previewInvoiceTemplate.cfm">

<!--- Invoice --->
<cfset qry_selectInvoice = QueryNew("invoiceID,userID,companyID,invoiceClosed,invoiceDateClosed,invoiceSent,invoiceDatePaid,invoicePaid,invoiceTotal,invoiceTotalTax,invoiceTotalLineItem,invoiceTotalPaymentCredit,invoiceTotalShipping,invoiceShipped,invoiceCompleted,invoiceDateCompleted,invoiceStatus,languageID,invoiceDateDue,invoiceID_custom,invoiceManual,userID_author,companyID_author,regionID,invoiceShippingMethod,invoiceInstructions,addressID_shipping,addressID_billing,creditCardID,bankID,subscriberID,invoiceDateCreated,invoiceDateUpdated")>
<cfset temp = QueryAddRow(qry_selectInvoice, 1)>
<!--- set value of 0 ---><cfloop Index="field" List="invoiceID,invoiceSent,invoiceTotalTax,invoiceTotalShipping,invoiceShipped,invoiceCompleted,languageID,invoiceManual,userID_author,companyID_author,regionID,bankID,"><cfset temp = QuerySetCell(qry_selectInvoice, field, 0, 1)></cfloop>
<!--- set value of 1 ---><cfloop Index="field" List="userID,companyID,invoiceClosed,invoiceStatus,addressID_shipping,addressID_billing,subscriberID,creditCardID"><cfset temp = QuerySetCell(qry_selectInvoice, field, 1, 1)></cfloop>
<!--- set date value to now ---><cfloop Index="field" List="invoiceDateClosed,invoiceDateCreated,invoiceDateUpdated,invoiceDateDue"><cfset temp = QuerySetCell(qry_selectInvoice, field, Now(), 1)></cfloop>
<!--- set value to blank ---><cfloop Index="field" List="invoicePaid,invoiceDatePaid,invoiceDateCompleted,invoiceShippingMethod"><cfset temp = QuerySetCell(qry_selectInvoice, field, "", 1)></cfloop>
<cfset temp = QuerySetCell(qry_selectInvoice, "invoiceTotal", 75.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoice, "invoiceTotalLineItem", 85.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoice, "invoiceTotalPaymentCredit", 10.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoice, "invoiceID_custom", "123456789", 1)>
<cfset temp = QuerySetCell(qry_selectInvoice, "invoiceInstructions", Variables.lang_previewInvoiceTemplate_title.invoiceInstructions, 1)>

<!--- Line Items --->
<cfset qry_selectInvoiceLineItemList = QueryNew("invoiceLineItemID,invoiceID,invoiceLineItemName,invoiceLineItemDescription,invoiceLineItemDescriptionHtml,productID,priceID,priceStageID,priceVolumeDiscountID,categoryID,invoiceLineItemQuantity,invoiceLineItemPriceUnit,invoiceLineItemPriceNormal,invoiceLineItemSubTotal,invoiceLineItemDiscount,invoiceLineItemTotal,invoiceLineItemTotalTax,invoiceLineItemOrder,invoiceLineItemStatus,userID,subscriptionID,invoiceLineItemManual,regionID,invoiceLineItemProductIsBundle,invoiceLineItemProductInBundle,productParameterExceptionID,invoiceLineItemProductID_custom,invoiceLineItemDateBegin,invoiceLineItemDateEnd,invoiceLineItemDateCreated,invoiceLineItemDateUpdated,userID_cancel,invoiceLineItemID_parent,invoiceLineItemID_trend,vendorID,productCode,productID_custom,productName,productPrice,productWeight,authorFirstName,authorLastName,authorUserID_custom,cancelFirstName,cancelLastName,cancelUserID_custom,priceStageText,priceStageDescription")>
<cfset Variables.lineItemCount = 5>
<cfset temp = QueryAddRow(qry_selectInvoiceLineItemList, Variables.lineItemCount)>
<cfloop Index="count" From="1" To="#Variables.lineItemCount#">
	<cfset Variables.thisCount = count>
	<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemOrder", Variables.thisCount, Variables.thisCount)>
	<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemName", "Sample Item " & Variables.thisCount, Variables.thisCount)>
	<!--- set value of 0 ---><cfloop Index="field" List="invoiceLineItemID,invoiceID,productID,priceID,priceStageID,priceVolumeDiscountID,categoryID,invoiceLineItemDescriptionHtml,invoiceLineItemDiscount,invoiceLineItemTotalTax,userID,subscriptionID,invoiceLineItemManual,regionID,invoiceLineItemProductIsBundle,invoiceLineItemProductInBundle,productParameterExceptionID,userID_cancel,invoiceLineItemID_parent,invoiceLineItemID_trend,vendorID,productWeight,productPrice"><cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, field, 0, Variables.thisCount)></cfloop>
	<!--- set value of 1 ---><cfloop Index="field" List="invoiceLineItemStatus"><cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, field, 1, Variables.thisCount)></cfloop>
	<!--- set date value to now ---><cfloop Index="field" List="invoiceLineItemDateBegin,invoiceLineItemDateEnd,invoiceLineItemDateCreated,invoiceLineItemDateUpdated"><cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, field, Now(), Variables.thisCount)></cfloop>
	<!--- set value to blank ---><cfloop Index="field" List="invoiceLineItemDescription,productCode,productID_custom,productName,authorFirstName,authorLastName,authorUserID_custom,cancelFirstName,cancelLastName,cancelUserID_custom,priceStageText,priceStageDescription"><cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, field, "", Variables.thisCount)></cfloop>
</cfloop>

<!--- line item 1 --->
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemProductID_custom", "12345", 1)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemQuantity", 1, 1)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceUnit", 10.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceNormal", 10.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemSubTotal", 10.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemTotal", 10.00, 1)>

<!--- line item 2 --->
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemProductID_custom", "ABCDE", 2)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemQuantity", 2, 2)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceUnit", 12.50, 2)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceNormal", 12.50, 2)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemSubTotal", 25.00, 2)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemTotal", 25.00, 2)>

<!--- line item 3 --->
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemProductID_custom", "ABC123", 3)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemQuantity", 1, 3)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceUnit", 24.00, 3)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceNormal", 24.00, 3)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemSubTotal", 24.00, 3)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemTotal", 24.00, 3)>

<!--- line item 4 --->
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemProductID_custom", "XYZ", 4)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemQuantity", 3, 4)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceUnit", 7.00, 4)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceNormal", 7.00, 4)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemSubTotal", 21.00, 4)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemTotal", 21.00, 4)>

<!--- line item 5--->
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemProductID_custom", "12345", 5)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemQuantity", 1, 5)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceUnit", 5.00, 5)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemPriceNormal", 5.00, 5)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemSubTotal", 5.00, 5)>
<cfset temp = QuerySetCell(qry_selectInvoiceLineItemList, "invoiceLineItemTotal", 5.00, 5)>

<!--- Determine if any line items have custom product ID, begin date or end date --->
<cfset Variables.displayInvoiceLineItemProductID_custom = True>
<cfset Variables.displayInvoiceLineItemDateBegin = True>
<cfset Variables.displayInvoiceLineItemDateEnd = True>

<!--- Line Item Parameter Options --->
<cfset qry_selectInvoiceLineItemParameterList = QueryNew("invoiceLineItemID,productParameterOptionID")>

<!--- Line Item Parameter Options: Text --->
<!--- Line Item Parameter Exceptions --->

<cfif qry_selectInvoice.addressID_shipping is not 0>
	<cfset qry_selectShippingAddress = QueryNew("companyID,userID,userID_author,addressID_parent,addressID_trend,addressName,addressDescription,addressTypeShipping,addressTypeBilling,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country,addressStatus,addressVersion,regionID,addressDateCreated,addressDateUpdated")>
	<cfset temp = QueryAddRow(qry_selectShippingAddress, 1)>
	<!--- set value of 0 ---><cfloop Index="field" List="companyID,userID,userID_author,addressID_parent,addressID_trend,addressTypeBilling,regionID"><cfset temp = QuerySetCell(qry_selectShippingAddress, field, 0, 1)></cfloop>
	<!--- set value of 1 ---><cfloop Index="field" List="addressTypeShipping,addressStatus,addressVersion"><cfset temp = QuerySetCell(qry_selectShippingAddress, field, 1, 1)></cfloop>
	<!--- set date value of now ---><cfloop Index="field" List="addressDateCreated,addressDateUpdated"><cfset temp = QuerySetCell(qry_selectShippingAddress, field, Now(), 1)></cfloop>
	<!--- set value of blank ---><cfloop Index="field" List="addressDescription,address3,county,country"><cfset temp = QuerySetCell(qry_selectShippingAddress, field, "", 1)></cfloop>
	<cfset temp = QuerySetCell(qry_selectShippingAddress, "addressName", Variables.lang_previewInvoiceTemplate_title.addressName, 1)>
	<cfset temp = QuerySetCell(qry_selectShippingAddress, "address", Variables.lang_previewInvoiceTemplate_title.address, 1)>
	<cfset temp = QuerySetCell(qry_selectShippingAddress, "address2", Variables.lang_previewInvoiceTemplate_title.address2, 1)>
	<cfset temp = QuerySetCell(qry_selectShippingAddress, "city", Variables.lang_previewInvoiceTemplate_title.city, 1)>
	<cfset temp = QuerySetCell(qry_selectShippingAddress, "state", Variables.lang_previewInvoiceTemplate_title.state, 1)>
	<cfset temp = QuerySetCell(qry_selectShippingAddress, "zipCode", Variables.lang_previewInvoiceTemplate_title.zipCode, 1)>
	<cfset temp = QuerySetCell(qry_selectShippingAddress, "zipCodePlus4", Variables.lang_previewInvoiceTemplate_title.zipCodePlus4, 1)>
</cfif>

<cfif qry_selectInvoice.addressID_billing is not 0>
	<cfset qry_selectBillingAddress = QueryNew("companyID,userID,userID_author,addressID_parent,addressID_trend,addressName,addressDescription,addressTypeShipping,addressTypeBilling,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country,addressStatus,addressVersion,regionID,addressDateCreated,addressDateUpdated")>
	<cfset temp = QueryAddRow(qry_selectBillingAddress, 1)>
	<!--- set value of 0 ---><cfloop Index="field" List="companyID,userID,userID_author,addressID_parent,addressID_trend,addressTypeShipping,regionID"><cfset temp = QuerySetCell(qry_selectBillingAddress, field, 0, 1)></cfloop>
	<!--- set value of 1 ---><cfloop Index="field" List="addressTypeBilling,addressStatus,addressVersion"><cfset temp = QuerySetCell(qry_selectBillingAddress, field, 1, 1)></cfloop>
	<!--- set date value of now ---><cfloop Index="field" List="addressDateCreated,addressDateUpdated"><cfset temp = QuerySetCell(qry_selectBillingAddress, field, Now(), 1)></cfloop>
	<!--- set value of blank ---><cfloop Index="field" List="addressDescription,address3,county,country"><cfset temp = QuerySetCell(qry_selectBillingAddress, field, "", 1)></cfloop>
	<cfset temp = QuerySetCell(qry_selectBillingAddress, "addressName", Variables.lang_previewInvoiceTemplate_title.addressName, 1)>
	<cfset temp = QuerySetCell(qry_selectBillingAddress, "address", Variables.lang_previewInvoiceTemplate_title.address, 1)>
	<cfset temp = QuerySetCell(qry_selectBillingAddress, "address2", Variables.lang_previewInvoiceTemplate_title.address2, 1)>
	<cfset temp = QuerySetCell(qry_selectBillingAddress, "city", Variables.lang_previewInvoiceTemplate_title.city, 1)>
	<cfset temp = QuerySetCell(qry_selectBillingAddress, "state", Variables.lang_previewInvoiceTemplate_title.state, 1)>
	<cfset temp = QuerySetCell(qry_selectBillingAddress, "zipCode", Variables.lang_previewInvoiceTemplate_title.zipCode, 1)>
	<cfset temp = QuerySetCell(qry_selectBillingAddress, "zipCodePlus4", Variables.lang_previewInvoiceTemplate_title.zipCodePlus4, 1)>
</cfif>

<!--- Company --->
<cfset qry_selectCompany = QueryNew("userID,companyName,companyDBA,companyURL,languageID,companyPrimary,companyStatus,affiliateID,cobrandID,companyID_custom,companyID_parent,companyID_author,companyIsCustomer,companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsTaxExempt,companyDirectory,companyDateCreated,companyDateUpdated")>
<cfset temp = QueryAddRow(qry_selectCompany, 1)>
<!--- set value of 0 ---><cfloop Index="field" List="languageID,companyPrimary,companyID_parent,companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsTaxExempt"><cfset temp = QuerySetCell(qry_selectCompany, field, 0, 1)></cfloop>
<!--- set value of 1 ---><cfloop Index="field" List="userID,affiliateID,cobrandID,companyStatus,companyID_author,companyIsCustomer"><cfset temp = QuerySetCell(qry_selectCompany, field, 1, 1)></cfloop>
<!--- set date value of now ---><cfloop Index="field" List="companyDateCreated,companyDateUpdated"><cfset temp = QuerySetCell(qry_selectCompany, field, Now(), 1)></cfloop>
<!--- set value of blank ---><cfloop Index="field" List="companyDirectory,companyURL"><cfset temp = QuerySetCell(qry_selectCompany, field, "", 1)></cfloop>
<cfset temp = QuerySetCell(qry_selectCompany, "companyName", Variables.lang_previewInvoiceTemplate_title.companyName, 1)>
<cfset temp = QuerySetCell(qry_selectCompany, "companyDBA", Variables.lang_previewInvoiceTemplate_title.companyDBA, 1)>
<cfset temp = QuerySetCell(qry_selectCompany, "companyID_custom", Variables.lang_previewInvoiceTemplate_title.companyID_custom, 1)>

<!--- User --->
<cfif qry_selectInvoice.userID is not 0>
	<cfset qry_selectUser = QueryNew("userID,companyID,username,password,userStatus,firstName,middleName,lastName,suffix,salutation,email,languageID,userID_custom,jobTitle,jobDepartment,jobDivision,userNewsletterStatus,userNewsletterHtml,userID_author,userDateCreated,userDateUpdated")>
	<cfset temp = QueryAddRow(qry_selectUser, 1)>
	<!--- set value of 0 ---><cfloop Index="field" List="languageID,userNewsletterStatus,userNewsletterHtml,userID_author"><cfset temp = QuerySetCell(qry_selectUser, field, 0, 1)></cfloop>
	<!--- set value of 1 ---><cfloop Index="field" List="userID,companyID,userStatus"><cfset temp = QuerySetCell(qry_selectUser, field, 1, 1)></cfloop>
	<!--- set date value of now ---><cfloop Index="field" List="userDateCreated,userDateUpdated"><cfset temp = QuerySetCell(qry_selectUser, field, Now(), 1)></cfloop>
	<!--- set value of blank ---><cfloop Index="field" List="password,middleName,suffix,salutation,jobDivision,jobDepartment"><cfset temp = QuerySetCell(qry_selectUser, field, "", 1)></cfloop>
	<cfset temp = QuerySetCell(qry_selectUser, "username", Variables.lang_previewInvoiceTemplate_title.username, 1)>
	<cfset temp = QuerySetCell(qry_selectUser, "firstName", Variables.lang_previewInvoiceTemplate_title.firstName, 1)>
	<cfset temp = QuerySetCell(qry_selectUser, "lastName", Variables.lang_previewInvoiceTemplate_title.lastName, 1)>
	<cfset temp = QuerySetCell(qry_selectUser, "email", Variables.lang_previewInvoiceTemplate_title.email, 1)>
	<cfset temp = QuerySetCell(qry_selectUser, "userID_custom", Variables.lang_previewInvoiceTemplate_title.userID_custom, 1)>
	<cfset temp = QuerySetCell(qry_selectUser, "jobTitle", Variables.lang_previewInvoiceTemplate_title.jobTitle, 1)>
</cfif>

<!--- get subscriber name --->
<cfset Variables.displaySubscriberName = False>
<cfif qry_selectInvoice.subscriberID is not 0>
	<cfset qry_selectSubscriber = QueryNew("companyID,userID,userID_author,userID_cancel,companyID_author,subscriberName,subscriberID_custom,subscriberCompleted,subscriberStatus,subscriberDateProcessNext,subscriberDateProcessLast,subscriberDateCreated,subscriberDateUpdated,addressID_billing,addressID_shipping")>
	<cfset temp = QueryAddRow(qry_selectSubscriber, 1)>
	<!--- set value of 0 ---><cfloop Index="field" List="userID_author,userID_cancel,subscriberCompleted,addressID_billing,addressID_shipping"><cfset temp = QuerySetCell(qry_selectSubscriber, field, 0, 1)></cfloop>
	<!--- set value of 1 ---><cfloop Index="field" List="companyID,userID,companyID_author,subscriberStatus"><cfset temp = QuerySetCell(qry_selectSubscriber, field, 1, 1)></cfloop>
	<!--- set date value of now ---><cfloop Index="field" List="subscriberDateProcessNext,subscriberDateProcessLast,subscriberDateCreated,subscriberDateUpdated"><cfset temp = QuerySetCell(qry_selectSubscriber, field, Now(), 1)></cfloop>
	<cfset temp = QuerySetCell(qry_selectSubscriber, "subscriberName", Variables.lang_previewInvoiceTemplate_title.subscriberName, 1)>
	<cfset temp = QuerySetCell(qry_selectSubscriber, "subscriberID_custom", Variables.lang_previewInvoiceTemplate_title.subscriberID_custom, 1)>

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
<cfset qry_selectInvoicePaymentList = QueryNew("invoiceID,paymentID,invoicePaymentManual,invoicePaymentAmount,invoicePaymentDate,invoicePaymentUserID,firstName,lastName,userID_custom,paymentUserID,paymentCompanyID,userID_author,companyID_author,paymentManual,creditCardID,bankID,merchantAccountID,paymentCheckNumber,paymentID_custom,paymentStatus,paymentApproved,paymentAmount,paymentDescription,paymentMessage,paymentMethod,paymentProcessed,paymentDateReceived,paymentDateScheduled,paymentCategoryID,paymentIsRefund,paymentID_refund,subscriberID,subscriberProcessID,paymentDateCreated,paymentDateUpdated")>
<cfset temp = QueryAddRow(qry_selectInvoicePaymentList, 1)>
<!--- set value of 0 ---><cfloop Index="field" List="invoiceID,invoicePaymentManual,invoicePaymentUserID,paymentUserID,paymentCompanyID,userID_author,paymentManual,bankID,paymentCheckNumber,paymentCategoryID,paymentIsRefund,paymentID_refund"><cfset temp = QuerySetCell(qry_selectInvoicePaymentList, field, 0, 1)></cfloop>
<!--- set value of 1 ---><cfloop Index="field" List="paymentID,companyID_author,creditCardID,merchantAccountID,paymentStatus,paymentApproved,paymentProcessed,subscriberID,subscriberProcessID"><cfset temp = QuerySetCell(qry_selectInvoicePaymentList, field, 1, 1)></cfloop>
<!--- set date value of now ---><cfloop Index="field" List="invoicePaymentDate,paymentDateCreated,paymentDateUpdated,paymentDateReceived,paymentDateScheduled"><cfset temp = QuerySetCell(qry_selectInvoicePaymentList, field, Now(), 1)></cfloop>
<!--- set value of blank ---><cfloop Index="field" List="firstName,lastName,userID_custom,paymentID_custom,paymentDescription,paymentMessage"><cfset temp = QuerySetCell(qry_selectInvoicePaymentList, field, "", 1)></cfloop>
<cfset temp = QuerySetCell(qry_selectInvoicePaymentList, "invoicePaymentAmount", 75.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoicePaymentList, "paymentAmount", "75.00", 1)>
<cfset temp = QuerySetCell(qry_selectInvoicePaymentList, "paymentMethod", Variables.lang_previewInvoiceTemplate_title.paymentMethod, 1)>

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


<cfset qry_selectLastInvoice = QueryNew("invoiceID,userID,companyID,invoiceClosed,invoiceDateClosed,invoiceSent,invoiceDatePaid,invoicePaid,invoiceTotal,invoiceTotalTax,invoiceTotalLineItem,invoiceTotalPaymentCredit,invoiceTotalShipping,invoiceShipped,invoiceCompleted,invoiceDateCompleted,invoiceStatus,languageID,invoiceDateDue,invoiceID_custom,invoiceManual,userID_author,companyID_author,regionID,invoiceShippingMethod,invoiceInstructions,addressID_shipping,addressID_billing,creditCardID,bankID,subscriberID,invoiceDateCreated,invoiceDateUpdated")>
<cfset temp = QueryAddRow(qry_selectLastInvoice, 1)>

<cfif qry_selectLastInvoice.RecordCount is 1>
	<!--- Payments since last invoice --->
	<cfset qry_selectPaymentsSinceLastInvoice = QueryNew("paymentID,userID,companyID,userID_author,paymentManual,creditCardID,bankID,merchantAccountID,paymentCheckNumber,paymentID_custom,paymentStatus,paymentAmount,paymentApproved,paymentDescription,paymentMessage,paymentMethod,paymentProcessed,paymentDateReceived,paymentDateScheduled,paymentCategoryID,subscriberID,subscriberProcessID,paymentIsRefund,paymentID_refund,paymentDateCreated,paymentDateUpdated,authorFirstName,authorLastName,authorUserID_custom,targetFirstName,targetLastName,targetUserID_custom,targetCompanyName,targetCompanyID_custom,subscriberName,subscriberID_custom")>
	<cfset temp = QueryAddRow(qry_selectPaymentsSinceLastInvoice, 1)>
	<!--- set value of 0 ---><cfloop Index="field" List="userID_author,paymentManual,bankID,merchantAccountID,paymentCheckNumber,paymentCategoryID,paymentID_refund,paymentIsRefund"><cfset temp = QuerySetCell(qry_selectPaymentsSinceLastInvoice, field, 0, 1)></cfloop>
	<!--- set value of 1 ---><cfloop Index="field" List="paymentID,userID,companyID,creditCardID,paymentStatus,paymentApproved,paymentProcessed,subscriberID,subscriberProcessID"><cfset temp = QuerySetCell(qry_selectPaymentsSinceLastInvoice, field, 1, 1)></cfloop>
	<!--- set date value of now ---><cfloop Index="field" List="paymentDateReceived,paymentDateCreated,paymentDateUpdated"><cfset temp = QuerySetCell(qry_selectPaymentsSinceLastInvoice, field, Now(), 1)></cfloop>
	<!--- set value of blank ---><cfloop Index="field" List="paymentID_custom,paymentDescription,paymentMessage,paymentDateScheduled,authorFirstName,authorLastName,authorUserID_custom,targetFirstName,targetLastName,targetUserID_custom,targetCompanyName,targetCompanyID_custom,subscriberName,subscriberID_custom"><cfset temp = QuerySetCell(qry_selectPaymentsSinceLastInvoice, field, "", 1)></cfloop>
	<cfset temp = QuerySetCell(qry_selectPaymentsSinceLastInvoice, "paymentAmount", 72.50, 1)>
	<cfset temp = QuerySetCell(qry_selectPaymentsSinceLastInvoice, "paymentMethod", Variables.lang_previewInvoiceTemplate_title.paymentMethod, 1)>


	<!--- Refunds since last invoice --->
	<cfset qry_selectPaymentRefundsSinceLastInvoice = QueryNew("paymentID,userID,companyID,userID_author,paymentManual,creditCardID,bankID,merchantAccountID,paymentCheckNumber,paymentID_custom,paymentStatus,paymentAmount,paymentApproved,paymentDescription,paymentMessage,paymentMethod,paymentProcessed,paymentDateReceived,paymentDateScheduled,paymentCategoryID,subscriberID,subscriberProcessID,paymentIsRefund,paymentID_refund,paymentDateCreated,paymentDateUpdated,authorFirstName,authorLastName,authorUserID_custom,targetFirstName,targetLastName,targetUserID_custom,targetCompanyName,targetCompanyID_custom,subscriberName,subscriberID_custom")>
	<cfset temp = QueryAddRow(qry_selectPaymentRefundsSinceLastInvoice, 1)>
	<!--- set value of 0 ---><cfloop Index="field" List="userID_author,paymentManual,bankID,merchantAccountID,paymentCheckNumber,paymentCategoryID,paymentID_refund"><cfset temp = QuerySetCell(qry_selectPaymentRefundsSinceLastInvoice, field, 0, 1)></cfloop>
	<!--- set value of 1 ---><cfloop Index="field" List="paymentID,userID,companyID,creditCardID,paymentStatus,paymentApproved,paymentProcessed,subscriberID,subscriberProcessID,paymentIsRefund"><cfset temp = QuerySetCell(qry_selectPaymentRefundsSinceLastInvoice, field, 1, 1)></cfloop>
	<!--- set date value of now ---><cfloop Index="field" List="paymentDateReceived,paymentDateCreated,paymentDateUpdated"><cfset temp = QuerySetCell(qry_selectPaymentRefundsSinceLastInvoice, field, Now(), 1)></cfloop>
	<!--- set value of blank ---><cfloop Index="field" List="paymentID_custom,paymentDescription,paymentMessage,paymentDateScheduled,authorFirstName,authorLastName,authorUserID_custom,targetFirstName,targetLastName,targetUserID_custom,targetCompanyName,targetCompanyID_custom,subscriberName,subscriberID_custom"><cfset temp = QuerySetCell(qry_selectPaymentRefundsSinceLastInvoice, field, "", 1)></cfloop>
	<cfset temp = QuerySetCell(qry_selectPaymentRefundsSinceLastInvoice, "paymentAmount", 14.75, 1)>
	<cfset temp = QuerySetCell(qry_selectPaymentRefundsSinceLastInvoice, "paymentMethod", Variables.lang_previewInvoiceTemplate_title.paymentMethod, 1)>
</cfif>

<!--- Credits --->
<cfset qry_selectInvoicePaymentCreditList = QueryNew("invoicePaymentCreditID,invoiceID,paymentCreditID,invoicePaymentCreditManual,invoicePaymentCreditDate,invoicePaymentCreditText,invoicePaymentCreditAmount,invoicePaymentCreditRolloverPrevious,invoicePaymentCreditRolloverNext,invoicePaymentCreditUserID,firstName,lastName,userID_custom,paymentCreditUserID,paymentCreditCompanyID,userID_author,companyID_author,paymentCreditAmount,paymentCreditStatus,paymentCreditName,paymentCreditID_custom,paymentCreditDescription,paymentCreditDateBegin,paymentCreditDateEnd,paymentCreditAppliedMaximum,paymentCreditAppliedCount,paymentCategoryID,paymentCreditRollover,paymentCreditNegativeInvoice,subscriberID,paymentCreditCompleted,paymentCreditDateCreated,paymentCreditDateUpdated")>
<cfset temp = QueryAddRow(qry_selectInvoicePaymentCreditList, 1)>
<!--- set value of 0 ---><cfloop Index="field" List="invoiceID,invoicePaymentCreditManual,invoicePaymentCreditRolloverPrevious,invoicePaymentCreditRolloverNext,invoicePaymentCreditUserID,paymentCreditUserID,paymentCreditCompanyID,userID_author,paymentCreditAppliedMaximum,paymentCreditAppliedCount,paymentCategoryID,paymentCreditRollover,paymentCreditNegativeInvoice,paymentCreditCompleted"><cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, field, 0, 1)></cfloop>
<!--- set value of 1 ---><cfloop Index="field" List="invoicePaymentCreditID,paymentCreditID,companyID_author,paymentCreditStatus,subscriberID"><cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, field, 1, 1)></cfloop>
<!--- set date value of now ---><cfloop Index="field" List="invoicePaymentCreditDate,paymentCreditDateCreated,paymentCreditDateUpdated"><cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, field, Now(), 1)></cfloop>
<!--- set value of blank ---><cfloop Index="field" List="firstName,lastName,userID_custom,paymentCreditDescription,paymentCreditDateBegin,paymentCreditDateEnd"><cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, field, "", 1)></cfloop>
<cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, "paymentCreditAmount", 10.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, "invoicePaymentCreditAmount", 10.00, 1)>
<cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, "paymentCreditName", Variables.lang_previewInvoiceTemplate_title.paymentCreditName, 1)>
<cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, "invoicePaymentCreditText", Variables.lang_previewInvoiceTemplate_title.invoicePaymentCreditText, 1)>
<cfset temp = QuerySetCell(qry_selectInvoicePaymentCreditList, "paymentCreditID_custom", Variables.lang_previewInvoiceTemplate_title.paymentCreditID_custom, 1)>

<!--- Credit Cards --->
<cfif Variables.creditCardID_list is not "">
	<cfset qry_selectCreditCardList = QueryNew("creditCardID,companyID,userID,userID_author,addressID,creditCardName,creditCardNumber,creditCardType,creditCardExpirationMonth,creditCardExpirationYear,creditCardCVC,creditCardStatus,creditCardDescription,creditCardRetain,creditCardDateCreated,creditCardDateUpdated,addressName,addressDescription,addressTypeShipping,addressTypeBilling,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country,addressStatus,addressVersion,regionID,addressDateCreated,addressDateUpdated,firstName,lastName,userID_custom")>
	<cfset temp = QueryAddRow(qry_selectCreditCardList, 1)>
	<!--- set value of 0 ---><cfloop Index="field" List="userID_author,addressID,addressTypeBilling,addressTypeShipping,regionID,addressStatus,addressVersion"><cfset temp = QuerySetCell(qry_selectCreditCardList, field, 0, 1)></cfloop>
	<!--- set value of 1 ---><cfloop Index="field" List="creditCardID,companyID,userID,creditCardStatus,creditCardRetain"><cfset temp = QuerySetCell(qry_selectCreditCardList, field, 1, 1)></cfloop>
	<!--- set date value of now ---><cfloop Index="field" List="creditCardDateCreated,creditCardDateUpdated,addressDateCreated,addressDateUpdated"><cfset temp = QuerySetCell(qry_selectCreditCardList, field, Now(), 1)></cfloop>
	<!--- set value of blank ---><cfloop Index="field" List="creditCardCVC,creditCardDescription,addressName,addressDescription,address,address2,address3,city,state,zipCode,zipCodePlus4,county,country,firstName,lastName,userID_custom"><cfset temp = QuerySetCell(qry_selectCreditCardList, field, "", 1)></cfloop>
	<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardName", Variables.lang_previewInvoiceTemplate_title.creditCardName, 1)>
	<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardNumber", Variables.lang_previewInvoiceTemplate_title.creditCardNumber, 1)>
	<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardType", Variables.lang_previewInvoiceTemplate_title.creditCardType, 1)>
	<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardExpirationMonth", Variables.lang_previewInvoiceTemplate_title.creditCardExpirationMonth, 1)>
	<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardExpirationYear", Variables.lang_previewInvoiceTemplate_title.creditCardExpirationYear, 1)>
</cfif>

<!--- Banks --->

