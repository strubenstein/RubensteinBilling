<!--- 
Confirm purchase:

Display shopping cart items and total price
Display shipping address
Display billing info

display invoice total
shipping information
shipping price

Confirm everything is correct, with links to edit
Continue and submit order

AFTER CONFIRMING:
Display receipt/purchase confirmation to buyer
	order #?
Update invoice to reflect it has been submitted
Send email receipt to buyer
Notify client / determine who to notify
Reset Session.invoiceID = 0
Clear cart
--->

<!--- get shopping cart items --->
<cfinclude template="../c_shoppingCart/act_setAllCartInfo.cfm">

<!--- get invoice information --->
<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
	<cfinvokeargument Name="invoiceID" Value="#Session.invoiceID#">
</cfinvoke>

<!--- get shipping address --->
<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectShippingAddressList">
	<cfinvokeargument Name="addressID" Value="#qry_selectInvoice.addressID_shipping#">
</cfinvoke>

<!--- get billing address and credit card information --->
<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCard" ReturnVariable="qry_selectBillingAddressList">
	<cfinvokeargument Name="creditCardID" Value="#qry_selectInvoice.creditCardID#">
</cfinvoke>

<!--- display confirmation page or receipt/purchase confirmation to buyer --->
<cfset Variables.theShoppingCart = Session.shoppingCart>
<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/form_checkoutConfirm.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCheckoutConfirm") and Session.invoiceID is not 0>
	<!--- Update invoice to reflect it has been submitted --->
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
		<cfinvokeargument Name="invoiceID" Value="#Session.invoiceID#">
		<cfinvokeargument Name="invoiceClosed" Value="1">
		<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
	</cfinvoke>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfif Session.affiliateID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
			<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID#">
		</cfinvoke>
	</cfif>

	<cfif Session.cobrandID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
			<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID#">
		</cfinvoke>
	</cfif>

	<!--- get content options for email confirmation to buyer --->
	<cfinvoke Component="#Application.billingMapping#data.ContentCompany" Method="selectContentCompanyList" ReturnVariable="qry_selectContentCompanyList">
		<cfinvokeargument Name="contentCode" Value="confirmBuyerEmailFromName,confirmBuyerEmailFromAddress,confirmBuyerEmailReplyTo,confirmBuyerEmailSubject,confirmBuyerEmailHeader,confirmBuyerEmailFooter,confirmBuyerEmailCC,confirmBuyerEmailBCC">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="languageID" Value="">
		<cfinvokeargument Name="contentCompanyStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectContentCompanyList.RecordCount is not 0>
		<cfset Variables.contentCodeRow = StructNew()>
		<cfloop Query="qry_selectContentCompanyList">
			<cfset Variables.contentCodeRow[qry_selectContentCompanyList.contentCode] = qry_selectContentCompanyList.CurrentRow>
		</cfloop>

		<cfinclude template="../../../include/function/fn_Email.cfm">
		<cfset Variables.emailFrom = fn_EmailFrom(qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailFromName], qry_selectContentCompanyList.contentCompanyText[Variables.contentCodeRow.confirmBuyerEmailFromAddress])>
		<cfset Variables.emailType = "html">

		<!--- Send email receipt to buyer --->
		<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/email_checkoutConfirmToBuyer.cfm">

		<!--- Notify primary user of client --->
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="userIsPrimaryContact" Value="True">
		</cfinvoke>

		<cfif qry_selectUserCompanyList_company.RecordCount is 1 and qry_selectUserCompanyList_company.email is not "">
			<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/email_checkoutConfirmToClient.cfm">
		</cfif>
	</cfif>

	<!--- Notify vendors of purchase --->
	<cfinclude template="act_notifyVendorOfPurchase.cfm">

	<!--- Reset Session.invoiceID = 0 --->
	<cflock Scope="Session" Timeout="5">
		<cfset Session.invoiceID = 0>
	</cflock>

	<!--- Clear cart --->
	<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" Method="deleteAllItemsFromCart" />
</cfif>

