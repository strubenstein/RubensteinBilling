<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="../../view/v_payment/var_paymentMethodList.cfm">

<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfif Variables.doAction is "updatePayment">
		<cfinvokeargument Name="paymentCategoryType" Value="payment">
	<cfelse>
		<cfinvokeargument Name="paymentCategoryType" Value="refund">
	</cfif>
</cfinvoke>

<cfset Variables.updatePaymentFieldList = "paymentStatus,paymentApproved,paymentID_custom,paymentDescription">
<cfset Variables.displayMerchantAccounts = False>
<cfif IsDate(qry_selectPayment.paymentDateScheduled) and DateCompare(Now(), qry_selectPayment.paymentDateScheduled) is -1>
	<cfinvoke Component="#Application.billingMapping#data.MerchantAccount" Method="selectMerchantAccountList" ReturnVariable="qry_selectMerchantAccountList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="merchantAccountStatus" Value="1">
		<cfinvokeargument Name="returnMerchantFields" Value="True">
	</cfinvoke>

	<cfif qry_selectMerchantAccountList.RecordCount is not 0>
		<cfset Variables.displayMerchantAccounts = True>
		<cfset Variables.updatePaymentFieldList = ListAppend(Variables.updatePaymentFieldList, "paymentDateScheduled,paymentProcessed,merchantAccountID")>
	</cfif>
</cfif>

<!--- 
<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
	<cfinvokeargument Name="companyID" Value="#qry_selectPayment.companyID#">
	<cfinvokeargument Name="bankStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
	<cfinvokeargument Name="companyID" Value="#qry_selectPayment.companyID#">
	<cfinvokeargument Name="creditCardStatus" Value="1">
</cfinvoke>
--->

<cfset displaySubscriberList = False>
<cfset displaySubscriptionList = False>
<cfset displayInvoiceLineItemList = False>

<cfinclude template="formParam_insertUpdatePayment.cfm">
<cfinvoke component="#Application.billingMapping#data.Payment" method="maxlength_Payment" returnVariable="maxlength_Payment" />
<cfinclude template="../../view/v_payment/lang_insertUpdatePayment.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPayment")>
	<cfinclude template="formValidate_insertUpdatePayment.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="updatePayment" ReturnVariable="isPaymentUpdated">
			<cfinvokeargument Name="paymentID" Value="#URL.paymentID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="paymentID_custom" Value="#Form.paymentID_custom#">
			<cfinvokeargument Name="paymentStatus" Value="#Form.paymentStatus#">
			<cfinvokeargument Name="paymentApproved" Value="#Form.paymentApproved#">
			<cfinvokeargument Name="paymentDescription" Value="#Form.paymentDescription#">
			<cfif ListFind(Variables.updatePaymentFieldList, "paymentDateScheduled")>
				<cfinvokeargument Name="merchantAccountID" Value="#Form.merchantAccountID#">
				<cfinvokeargument Name="paymentProcessed" Value="#Form.paymentProcessed#">
				<cfinvokeargument Name="paymentDateScheduled" Value="#Form.paymentDateScheduled#">
			<cfelseif Variables.displayMerchantAccounts is False and qry_selectPayment.merchantAccountID is not 0>
				<cfinvokeargument Name="merchantAccountID" Value="0">
				<cfinvokeargument Name="paymentProcessed" Value="0">
				<cfinvokeargument Name="paymentDateScheduled" Value="">
			</cfif>
			<cfinvokeargument Name="paymentCategoryID" Value="#Form.paymentCategoryID#">
		</cfinvoke>

		<cfif Form.paymentProcessed is 0>
			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#Session.companyID#">
				<cfinvokeargument name="doAction" value="#Variables.doAction#">
				<cfinvokeargument name="isWebService" value="False">
				<cfinvokeargument name="doControl" value="#Variables.doControl#">
				<cfinvokeargument name="primaryTargetKey" value="paymentID">
				<cfinvokeargument name="targetID" value="#URL.paymentID#">
			</cfinvoke>

			<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&paymentID=#URL.paymentID#&confirm_payment=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cfmodule Template="../../include/merchant/act_processPayment.cfm" paymentID="#URL.paymentID#">
			<cfif Variables.doAction is "updatePayment">
				<cfset Variables.redirectAction = "viewPayment">
			<cfelse>
				<cfset Variables.redirectAction = "viewPaymentRefund">
			</cfif>

			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#Session.companyID#">
				<cfinvokeargument name="doAction" value="#Variables.doAction#">
				<cfinvokeargument name="isWebService" value="False">
				<cfinvokeargument name="doControl" value="#Variables.doControl#">
				<cfinvokeargument name="primaryTargetKey" value="paymentID">
				<cfinvokeargument name="targetID" value="#URL.paymentID#">
			</cfinvoke>

			<cfif isPaymentApproved is 1>
				<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&paymentID=#URL.paymentID#&confirm_payment=#Variables.doAction#_approve" AddToken="No">
			<cfelse>
				<cflocation url="index.cfm?method=#URL.control#.#Variables.redirectAction##Variables.urlParameters#&paymentID=#URL.paymentID#&confirm_payment=#Variables.doAction#_reject" AddToken="No">
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formName = "insertPayment">
<cfset Variables.formAction = Variables.formAction & "&paymentID=#URL.paymentID#">

<cfif Variables.doAction is "updatePayment">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePayment.formSubmitValue_updatePayment>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePayment.formSubmitValue_updateRefund>
</cfif>

<cfinclude template="../../view/v_payment/form_insertUpdatePayment.cfm">
