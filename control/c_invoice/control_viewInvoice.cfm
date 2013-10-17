<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
	<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
	<cfinvokeargument Name="userID" Value="#qry_selectInvoice.userID#">
</cfinvoke>

<cfset Variables.primaryTargetArray = ArrayNew(1)>
<cfset Variables.primaryTargetArray[1] = Application.fn_GetPrimaryTargetID("invoiceID") & "," & URL.invoiceID>
<cfset Variables.primaryTargetArray[2] = Application.fn_GetPrimaryTargetID("companyID") & "," & qry_selectInvoice.companyID>
<cfset Variables.primaryTargetArray[3] = Application.fn_GetPrimaryTargetID("userID") & "," & qry_selectInvoice.userID>

<cfset Variables.displayPhone = False>
<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhoneList" ReturnVariable="qry_selectPhoneList">
	<cfinvokeargument Name="phoneStatus" Value="1">
	<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
	<cfif qry_selectInvoice.userID is not 0>
		<cfinvokeargument Name="userID" Value="#qry_selectInvoice.userID#">
	</cfif>
</cfinvoke>

<cfif qry_selectPhoneList.RecordCount is not 0>
	<cfset Variables.displayPhone = True>
</cfif>

<cfset Variables.displayCobrand = False>
<cfif qry_selectCompany.cobrandID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
		<cfinvokeargument Name="cobrandID" Value="#qry_selectCompany.cobrandID#">
	</cfinvoke>

	<cfif qry_selectCobrand.RecordCount is 1>
		<cfset Variables.displayCobrand = True>
	</cfif>
</cfif>

<cfset Variables.displayAffiliate = False>
<cfif qry_selectCompany.affiliateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
		<cfinvokeargument Name="affiliateID" Value="#qry_selectCompany.affiliateID#">
	</cfinvoke>

	<cfif qry_selectAffiliate.RecordCount is 1>
		<cfset Variables.displayAffiliate = True>
	</cfif>
</cfif>

<!--- get shipping, billing address --->
<cfset Variables.displayShippingAddress = 0>
<cfset Variables.displayBillingAddress = 0>
<cfif qry_selectInvoice.addressID_shipping is not 0 or qry_selectInvoice.addressID_billing is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
		<cfinvokeargument Name="addressID" Value="#qry_selectInvoice.addressID_shipping#,#qry_selectInvoice.addressID_billing#">
	</cfinvoke>

	<cfloop Query="qry_selectAddressList">
		<cfif qry_selectAddressList.addressID is qry_selectInvoice.addressID_shipping>
			<cfset Variables.displayShippingAddress = CurrentRow>
		<cfelse>
			<cfset Variables.displayBillingAddress = CurrentRow>
		</cfif>
	</cfloop>
</cfif>

<!--- get credit card information --->
<cfset Variables.displayCreditCard = False>
<cfif qry_selectInvoice.creditCardID is not 0 and Application.fn_IsUserAuthorized("viewCreditCard")>
	<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCard" ReturnVariable="qry_selectCreditCard">
		<cfinvokeargument Name="creditCardID" Value="#qry_selectInvoice.creditCardID#">
	</cfinvoke>

	<cfif qry_selectCreditCard.RecordCount is 1>
		<cfset Variables.displayCreditCard = True>
	</cfif>
</cfif>

<!--- get bank information --->
<cfset Variables.displayBank = False>
<cfif qry_selectInvoice.bankID is not 0 and Application.fn_IsUserAuthorized("viewBank")>
	<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBank" ReturnVariable="qry_selectBank">
		<cfinvokeargument Name="bankID" Value="#qry_selectInvoice.bankID#">
	</cfinvoke>

	<cfif qry_selectBank.RecordCount is 1>
		<cfset Variables.displayBank = True>
	</cfif>
</cfif>

<!--- get vendor information, if necessary --->
<cfset Variables.displayVendor = False>
<cfif REFind("[1-9]", ValueList(qry_selectInvoiceLineItemList.vendorID))>
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		<cfinvokeargument Name="vendorID" Value="#ValueList(qry_selectInvoiceLineItemList.vendorID)#">
	</cfinvoke>

	<cfif qry_selectVendorList.RecordCount is not 0>
		<cfset Variables.displayVendor = True>
	</cfif>
</cfif>

<cfset Variables.userStatusRow = 0>
<cfset Variables.companyStatusRow = 0>
<cfset Variables.invoiceStatusRow = 0>

<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="selectStatusHistoryList" ReturnVariable="qry_selectStatusHistoryList">
	<cfinvokeargument Name="primaryTargetArray" Value="#Variables.primaryTargetArray#">
	<cfinvokeargument Name="statusHistoryStatus" Value="1">
</cfinvoke>

<cfloop Query="qry_selectStatusHistoryList">
	<cfif qry_selectStatusHistoryList.primaryTargetID is Application.fn_GetPrimaryTargetID("companyID")>
		<cfset Variables.companyStatusRow = CurrentRow>
	<cfelseif qry_selectStatusHistoryList.primaryTargetID is Application.fn_GetPrimaryTargetID("userID")>
		<cfset Variables.userStatusRow = CurrentRow>
	<cfelseif qry_selectStatusHistoryList.primaryTargetID is Application.fn_GetPrimaryTargetID("invoiceID")>
		<cfset Variables.invoiceStatusRow = CurrentRow>
	</cfif>
</cfloop>

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

<!--- get payment credits --->
<cfset Variables.displayPaymentCredits = False>
<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="selectInvoicePaymentCreditList" ReturnVariable="qry_selectInvoicePaymentCreditList">
	<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
	<cfinvokeargument Name="returnInvoiceFields" Value="False">
	<cfinvokeargument Name="returnPaymentCreditFields" Value="True">
</cfinvoke>
<cfif qry_selectInvoicePaymentCreditList.RecordCount is not 0>
	<cfset Variables.displayPaymentCredits = True>
</cfif>

<cfinclude template="../../view/v_invoice/lang_viewInvoice.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewVendor,viewProduct,listPrices,viewCompany,viewUser,viewSubscriber")>
<cfset Variables.invoiceLineItemColumnList = Variables.lang_viewInvoice_title.invoiceLineItemProductID_custom
		& "^" & Variables.lang_viewInvoice_title.vendorName
		& "^" & Variables.lang_viewInvoice_title.invoiceLineItemName
		& "^" & Variables.lang_viewInvoice_title.invoiceLineItemPriceUnit
		& "^" & Variables.lang_viewInvoice_title.invoiceLineItemQuantity
		& "^" & Variables.lang_viewInvoice_title.invoiceLineItemSubTotal
		& "^" & Variables.lang_viewInvoice_title.invoiceLineItemTotalTax
		& "^" & Variables.lang_viewInvoice_title.invoiceLineItemTotal>
<cfset Variables.invoiceLineItemColumnCount = DecrementValue(2 * ListLen(Variables.invoiceLineItemColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfinclude template="../../view/v_invoice/dsp_selectInvoice.cfm">
<cfinclude template="../../view/v_invoice/dsp_selectInvoice_lineItems.cfm">
