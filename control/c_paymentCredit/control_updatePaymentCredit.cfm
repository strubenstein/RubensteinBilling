<cfinclude template="../../include/function/fn_datetime.cfm">

<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="paymentCategoryType" Value="credit">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList" ReturnVariable="qry_selectSubscriberList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
	<cfinvokeargument Name="queryOrderBy" Value="subscriberName">
</cfinvoke>

<cfset Variables.updatePaymentFieldList = "paymentCreditStatus,paymentCreditName,paymentCreditID_custom,paymentCreditDescription,paymentCategoryID">
<cfset Variables.displaySubscriberList = False>
<cfset Variables.displaySubscriptionList = False>
<cfset Variables.displayInvoiceLineItemList = False>

<cfif IsDate(qry_selectPaymentCredit.paymentCreditDateBegin) and DateCompare(Now(), qry_selectPaymentCredit.paymentCreditDateBegin) is -1>
	<cfset Variables.updatePaymentFieldList = ListAppend(Variables.updatePaymentFieldList, "paymentCreditDateBegin,paymentCreditAppliedMaximum,paymentCreditRollover,paymentCreditNegativeInvoice")>
</cfif>

<cfinclude template="formParam_insertUpdatePaymentCredit.cfm">
<cfinvoke component="#Application.billingMapping#data.PaymentCredit" method="maxlength_PaymentCredit" returnVariable="maxlength_PaymentCredit" />
<cfinclude template="../../view/v_paymentCredit/lang_insertUpdatePaymentCredit.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPaymentCredit")>
	<cfinclude template="formValidate_insertUpdatePaymentCredit.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="updatePaymentCredit" ReturnVariable="isPaymentCreditUpdated">
			<cfinvokeargument Name="paymentCreditID" Value="#URL.paymentCreditID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="paymentCreditAmount" Value="#Form.paymentCreditAmount#">
			<cfinvokeargument Name="paymentCreditStatus" Value="#Form.paymentCreditStatus#">
			<cfinvokeargument Name="paymentCreditName" Value="#Form.paymentCreditName#">
			<cfinvokeargument Name="paymentCreditID_custom" Value="#Form.paymentCreditID_custom#">
			<cfinvokeargument Name="paymentCreditDescription" Value="#Form.paymentCreditDescription#">
			<cfloop Index="field" List="subscriberID,paymentCreditDateBegin,paymentCreditDateEnd,paymentCreditAppliedMaximum,paymentCategoryID,paymentCreditRollover,paymentCreditNegativeInvoice">
				<cfif ListFind(Variables.updatePaymentFieldList, field)>
					<cfinvokeargument Name="#field#" Value="#Form[field]#">
				</cfif>
			</cfloop>
		</cfinvoke>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="paymentCreditID">
			<cfinvokeargument name="targetID" value="#URL.paymentCreditID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#&paymentCreditID=#URL.paymentCreditID#&confirm_payment=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertPaymentCredit">
<cfset Variables.formAction = Variables.formAction & "&paymentCreditID=#URL.paymentCreditID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePaymentCredit.formSubmitValue_update>

<cfinclude template="../../view/v_paymentCredit/form_insertUpdatePaymentCredit.cfm">
