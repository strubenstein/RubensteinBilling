<cfinclude template="../../include/function/fn_datetime.cfm">

<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="paymentCategoryType" Value="credit">
</cfinvoke>

<cfset Variables.displaySubscriberList = False>
<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList" ReturnVariable="qry_selectSubscriberList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
	<cfinvokeargument Name="queryOrderBy" Value="subscriberName">
</cfinvoke>
<cfif qry_selectSubscriberList.RecordCount is not 0>
	<cfset Variables.displaySubscriberList = True>
</cfif>

<!--- 
productID_subscriptionID - Retrieve list of products that may be the source of the credit:
- If Variables.invoiceID: avInvoice.invoiceLineItemName
- avSubscription.subscriptionName
--->
<cfset Variables.displaySubscriptionList = False>
<cfif qry_selectSubscriberList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
		<cfinvokeargument Name="subscriberID" Value="#ValueList(qry_selectSubscriberList.subscriberID)#">
		<cfinvokeargument Name="subscriptionID_parent" Value="0">
	</cfinvoke>

	<cfif qry_selectSubscriptionList.RecordCount is not 0>
		<cfset Variables.displaySubscriptionList = True>
	</cfif>
</cfif>

<cfset Variables.displayInvoiceLineItemList = False>
<cfif Variables.invoiceID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
		<cfinvokeargument Name="invoiceID" Value="#Variables.invoiceID#">
		<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectInvoiceLineItemList.RecordCount is not 0>
		<cfset Variables.displayInvoiceLineItemList = True>
	</cfif>
</cfif>

<cfset Variables.updatePaymentFieldList = "">
<cfinclude template="formParam_insertUpdatePaymentCredit.cfm">
<cfinvoke component="#Application.billingMapping#data.PaymentCredit" method="maxlength_PaymentCredit" returnVariable="maxlength_PaymentCredit" />
<cfinclude template="../../view/v_paymentCredit/lang_insertUpdatePaymentCredit.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPaymentCredit")>
	<cfinclude template="formValidate_insertUpdatePaymentCredit.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="insertPaymentCredit" ReturnVariable="newPaymentCreditID">
			<cfinvokeargument Name="userID" Value="#Variables.userID#">
			<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="paymentCreditAmount" Value="#Form.paymentCreditAmount#">
			<cfinvokeargument Name="paymentCreditStatus" Value="#Form.paymentCreditStatus#">
			<cfinvokeargument Name="paymentCreditName" Value="#Form.paymentCreditName#">
			<cfinvokeargument Name="paymentCreditID_custom" Value="#Form.paymentCreditID_custom#">
			<cfinvokeargument Name="paymentCreditDescription" Value="#Form.paymentCreditDescription#">
			<cfinvokeargument Name="paymentCreditDateBegin" Value="#Form.paymentCreditDateBegin#">
			<cfinvokeargument Name="paymentCreditDateEnd" Value="#Form.paymentCreditDateEnd#">
			<cfinvokeargument Name="paymentCreditAppliedMaximum" Value="#Form.paymentCreditAppliedMaximum#">
			<cfinvokeargument Name="paymentCreditAppliedCount" Value="0">
			<cfinvokeargument Name="subscriberID" Value="#Form.subscriberID#">
			<cfinvokeargument Name="paymentCategoryID" Value="#Form.paymentCategoryID#">
			<cfinvokeargument Name="paymentCreditRollover" Value="#Form.paymentCreditRollover#">
			<cfinvokeargument Name="paymentCreditNegativeInvoice" Value="#Form.paymentCreditNegativeInvoice#">
		</cfinvoke>

		<!--- if invoice discount for existing invoice, apply credit to invoice and update invoice totals --->
		<cfif URL.control is "invoice" and IsDefined("URL.invoiceID") and Application.fn_IsIntegerPositive(URL.invoiceID)>
			<cfif qry_selectInvoice.invoiceTotal gte Form.paymentCreditAmount>
				<cfset Variables.invoicePaymentCreditAmount = Form.paymentCreditAmount>
				<cfset Variables.invoicePaymentCreditRolloverNext = 0>
			<cfelse>
				<cfset Variables.invoicePaymentCreditAmount = qry_selectInvoice.invoiceTotal>
				<cfset Variables.invoicePaymentCreditRolloverNext = 1>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.InvoicePaymentCredit" Method="insertInvoicePaymentCredit" ReturnVariable="isInvoicePaymentCreditInserted">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="invoicePaymentCreditManual" Value="1">
				<cfinvokeargument Name="paymentCreditID" Value="#newPaymentCreditID#">
				<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
				<cfinvokeargument Name="invoicePaymentCreditAmount" Value="#Variables.invoicePaymentCreditAmount#">
				<cfinvokeargument Name="invoicePaymentCreditRolloverPrevious" Value="0">
				<cfinvokeargument Name="invoicePaymentCreditRolloverNext" Value="#Variables.invoicePaymentCreditRolloverNext#">
				<cfinvokeargument Name="invoicePaymentCreditText" Value="#Form.paymentCreditName#">
			</cfinvoke>
		</cfif>

		<cfif Form.invoiceLineItemID is not "">
			<cfloop Index="lineItemID" List="#Form.invoiceLineItemID#">
				<cfset Variables.lineItemRow = ListFind(ValueList(qry_selectInvoiceLineItemList.invoiceLineItemID), lineItemID)>
				<cfinvoke Component="#Application.billingMapping#data.PaymentCreditProduct" Method="insertPaymentCreditProduct" ReturnVariable="isPaymentCreditProductInserted">
					<cfinvokeargument Name="paymentCreditID" Value="#newPaymentCreditID#">
					<cfinvokeargument Name="productID" Value="#qry_selectInvoiceLineItemList.productID[Variables.lineItemRow]#">
					<cfinvokeargument Name="subscriptionID" Value="#qry_selectInvoiceLineItemList.subscriptionID[Variables.lineItemRow]#">
					<cfinvokeargument Name="invoiceLineItemID" Value="#lineItemID#">
				</cfinvoke>
			</cfloop>
		</cfif>

		<cfif Form.subscriptionID is not "">
			<cfloop Index="subID" List="#Form.subscriptionID#">
				<cfset Variables.subRow = ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), subID)>
				<cfinvoke Component="#Application.billingMapping#data.PaymentCreditProduct" Method="insertPaymentCreditProduct" ReturnVariable="isPaymentCreditProductInserted">
					<cfinvokeargument Name="paymentCreditID" Value="#newPaymentCreditID#">
					<cfinvokeargument Name="productID" Value="#qry_selectSubscriptionList.productID[Variables.subRow]#">
					<cfinvokeargument Name="subscriptionID" Value="#subID#">
					<cfinvokeargument Name="invoiceLineItemID" Value="0">
				</cfinvoke>
			</cfloop>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="paymentCreditID">
			<cfinvokeargument name="targetID" value="#newPaymentCreditID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&confirm_paymentCredit=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertPaymentCredit">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePaymentCredit.formSubmitValue_insert>

<cfinclude template="../../view/v_paymentCredit/form_insertUpdatePaymentCredit.cfm">
