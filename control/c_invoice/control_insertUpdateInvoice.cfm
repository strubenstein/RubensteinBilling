<!--- 
regionID
languageID
--->

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfset Variables.invoiceDateFieldList = "invoiceDateDue"><!--- invoiceDatePaid,invoiceDateClosed,invoiceDateCompleted --->

<cfinclude template="formParam_insertUpdateInvoice.cfm">
<cfinvoke component="#Application.billingMapping#data.Invoice" method="maxlength_Invoice" returnVariable="maxlength_Invoice" />
<cfinclude template="../../view/v_invoice/lang_insertUpdateInvoice.cfm">
<cfinclude template="../../view/v_shipping/var_shippingMethodList.cfm">

<!--- if coming from user, get company's user is in --->
<cfset Variables.displayCompanyList = False>
<cfif Variables.doAction is "insertInvoice" and URL.control is "user">
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserCompanyList_user" ReturnVariable="qry_selectUserCompanyList_user">
		<cfinvokeargument Name="userID" Value="#Form.userID#">
		<cfinvokeargument Name="userCompanyStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectUserCompanyList_user.RecordCount gt 1>
		<cfset Variables.displayCompanyList = True>
	</cfif>
</cfif>

<!--- select company subscribers --->
<cfif Variables.doAction is "insertInvoice">
	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberList" ReturnVariable="qry_selectSubscriberList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="companyID" Value="#Form.companyID#">
		<cfinvokeargument Name="queryOrderBy" Value="subscriberName">
	</cfinvoke>

	<!--- 
	<cfinvoke Component="#Application.billingMapping#data.PaymentCredit" Method="selectPaymentCreditList" ReturnVariable="qry_selectPaymentCreditList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="companyID" Value="#Form.companyID#">
		<cfinvokeargument Name="paymentCreditStatus" Value="`">
		<cfinvokeargument Name="paymentCreditCompleted" Value="0">
		<cfinvokeargument Name="queryOrderBy" Value="subscriberID">
	</cfinvoke>
	--->
</cfif>

<!--- get users in company for contact --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#Form.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<!--- billing and shipping address --->
<cfset Variables.addressUserID = 0>
<cfif URL.control is "invoice" and Variables.doAction is "updateInvoice">
	<cfset Variables.addressCompanyID = qry_selectInvoice.companyID>
	<cfif qry_selectInvoice.userID is not 0>
		<cfset Variables.addressUserID = qry_selectInvoice.userID>
	</cfif>
<cfelse>
	<cfset Variables.addressCompanyID = URL.companyID>
	<cfif URL.userID is not 0>
		<cfset Variables.addressUserID = URL.userID>
	</cfif>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectShippingAddressList">
	<cfinvokeargument Name="companyID" Value="#Variables.addressCompanyID#">
	<cfif Variables.addressUserID is not 0>
		<cfinvokeargument Name="userID" Value="#Variables.addressUserID#">
	</cfif>
	<cfinvokeargument Name="addressTypeShipping" Value="1">
	<cfinvokeargument Name="addressStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectBillingAddressList">
	<cfinvokeargument Name="companyID" Value="#Variables.addressCompanyID#">
	<cfif Variables.addressUserID is not 0>
		<cfinvokeargument Name="userID" Value="#Variables.addressUserID#">
	</cfif>
	<cfinvokeargument Name="addressTypeBilling" Value="1">
	<cfinvokeargument Name="addressStatus" Value="1">
</cfinvoke>
<!--- /billing and shipping address --->

<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
	<!--- <cfinvokeargument Name="userID" Value="#Session.userID#"> --->
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="creditCardStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
	<!--- <cfinvokeargument Name="userID" Value="#Session.userID#"> --->
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="bankStatus" Value="1">
</cfinvoke>

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="invoiceID">
	<cfinvokeargument name="targetID_formParam" value="#URL.invoiceID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="invoiceID">
	<cfinvokeargument name="targetID_formParam" value="#URL.invoiceID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInvoice")>
	<cfinclude template="formValidate_insertUpdateInvoice.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">

	<cfelseif Variables.doAction is "insertInvoice">
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="insertInvoice" ReturnVariable="newInvoiceID">
			<cfinvokeargument Name="companyID" Value="#Form.companyID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="invoiceStatus" Value="#Form.invoiceStatus#">
			<cfinvokeargument Name="invoiceTotalShipping" Value="#Form.invoiceTotalShipping#">
			<!--- 
			<cfinvokeargument Name="invoiceTotalLineItem" Value="#Form.invoiceTotalLineItem#">
			<cfinvokeargument Name="invoiceTotalTax" Value="#Form.invoiceTotalTax#">
			<cfinvokeargument Name="invoiceTotal" Value="#Form.invoiceTotal#">
			<cfinvokeargument Name="invoiceTotalPaymentCredit" Value="#Form.invoiceTotalPaymentCredit#">
			--->
			<cfswitch expression="#Form.invoiceClosed#">
			<cfcase value="0">
				<cfinvokeargument Name="invoiceClosed" Value="0">
				<cfinvokeargument Name="invoiceCompleted" Value="0">
			</cfcase>
			<cfcase value="1">
				<cfinvokeargument Name="invoiceClosed" Value="1">
				<cfinvokeargument Name="invoiceCompleted" Value="0">
				<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
			</cfcase>
			<cfcase value="2">
				<cfinvokeargument Name="invoiceClosed" Value="1">
				<cfinvokeargument Name="invoiceCompleted" Value="1">
				<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
				<cfinvokeargument Name="invoiceDateCompleted" Value="#Now()#">
			</cfcase>
			</cfswitch>
			<!--- 
			<cfinvokeargument Name="invoiceClosed" Value="#Form.invoiceClosed#">
			<cfinvokeargument Name="invoiceCompleted" Value="#Form.invoiceCompleted#">
			<cfinvokeargument Name="invoiceDateClosed" Value="#Form.invoiceDateClosed#">
			<cfinvokeargument Name="invoiceDateCompleted" Value="#Form.invoiceDateCompleted#">
			--->
			<cfinvokeargument Name="invoicePaid" Value="#Form.invoicePaid#">
			<cfif Form.invoicePaid is not "">
				<cfinvokeargument Name="invoiceDatePaid" Value="#Now()#">
			</cfif>
			<cfinvokeargument Name="invoiceShippingMethod" Value="#Form.invoiceShippingMethod#">
			<cfinvokeargument Name="invoiceInstructions" Value="#Form.invoiceInstructions#">
			<cfinvokeargument Name="invoiceID_custom" Value="#Form.invoiceID_custom#">
			<cfinvokeargument Name="invoiceShipped" Value="#Form.invoiceShipped#">
			<cfinvokeargument Name="invoiceDateDue" Value="#Form.invoiceDateDue#">
			<cfinvokeargument Name="invoiceSent" Value="#Form.invoiceSent#">
			<cfinvokeargument Name="invoiceManual" Value="1">
			<cfinvokeargument Name="addressID_shipping" Value="#Form.addressID_shipping#">
			<cfinvokeargument Name="addressID_billing" Value="#Form.addressID_billing#">
			<cfinvokeargument Name="creditCardID" Value="#Form.creditCardID#">
			<cfinvokeargument Name="bankID" Value="#Form.bankID#">
			<cfinvokeargument Name="subscriberID" Value="#Form.subscriberID#">
		</cfinvoke>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newInvoiceID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newInvoiceID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="invoiceID">
			<cfinvokeargument name="targetID" value="#newInvoiceID#">
		</cfinvoke>

		<cfset Variables.redirectAction = Replace(Variables.formAction, Variables.doAction, "updateInvoice", "ONE")>
		<cflocation url="#Variables.redirectAction#&invoiceID=#newInvoiceID#&confirm_invoice=#Variables.doAction#" AddToken="No">

	<cfelse><!--- updateInvoice --->
		<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="updateInvoice" ReturnVariable="isInvoiceUpdated">
			<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="invoiceStatus" Value="#Form.invoiceStatus#">
			<cfinvokeargument Name="invoiceTotalShipping" Value="#Form.invoiceTotalShipping#">
			<!--- 
			<cfinvokeargument Name="invoiceTotalLineItem" Value="#Form.invoiceTotalLineItem#">
			<cfinvokeargument Name="invoiceTotalTax" Value="#Form.invoiceTotalTax#">
			<cfinvokeargument Name="invoiceTotal" Value="#Form.invoiceTotal#">
			<cfinvokeargument Name="invoiceTotalPaymentCredit" Value="#Form.invoiceTotalPaymentCredit#">
			--->
			<cfswitch expression="#Form.invoiceClosed#">
			<cfcase value="0">
				<cfinvokeargument Name="invoiceClosed" Value="0">
				<cfinvokeargument Name="invoiceCompleted" Value="0">
				<cfinvokeargument Name="invoiceDateClosed" Value="">
				<cfinvokeargument Name="invoiceDateCompleted" Value="">
			</cfcase>
			<cfcase value="1">
				<cfinvokeargument Name="invoiceClosed" Value="1">
				<cfinvokeargument Name="invoiceCompleted" Value="0">
				<cfif Not IsDate(qry_selectInvoice.invoiceDateClosed)>
					<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
				</cfif>
				<cfinvokeargument Name="invoiceDateCompleted" Value="">
			</cfcase>
			<cfcase value="2">
				<cfinvokeargument Name="invoiceClosed" Value="1">
				<cfinvokeargument Name="invoiceCompleted" Value="1">
				<cfif Not IsDate(qry_selectInvoice.invoiceDateClosed)>
					<cfinvokeargument Name="invoiceDateClosed" Value="#Now()#">
				</cfif>
				<cfif Not IsDate(qry_selectInvoice.invoiceDateCompleted)>
					<cfinvokeargument Name="invoiceDateCompleted" Value="#Now()#">
				</cfif>
			</cfcase>
			</cfswitch>
			<!--- 
			<cfinvokeargument Name="invoiceClosed" Value="#Form.invoiceClosed#">
			<cfinvokeargument Name="invoiceCompleted" Value="#Form.invoiceCompleted#">
			<cfinvokeargument Name="invoiceDateClosed" Value="#Form.invoiceDateClosed#">
			<cfinvokeargument Name="invoiceDateCompleted" Value="#Form.invoiceDateCompleted#">
			--->
			<cfinvokeargument Name="invoicePaid" Value="#Form.invoicePaid#">
			<cfif Form.invoicePaid is "">
				<cfinvokeargument Name="invoiceDatePaid" Value="">
			<cfelseif Form.invoicePaid is 0 and Not IsDate(qry_selectInvoice.invoiceDatePaid)>
				<cfinvokeargument Name="invoiceDatePaid" Value="#Now()#">
			<cfelseif Form.invoicePaid is 1 and (Not IsDate(qry_selectInvoice.invoiceDatePaid) or qry_selectInvoice.invoicePaid is not 1)>
				<cfinvokeargument Name="invoiceDatePaid" Value="#Now()#">
			</cfif>
			<cfinvokeargument Name="invoiceShippingMethod" Value="#Form.invoiceShippingMethod#">
			<cfinvokeargument Name="invoiceInstructions" Value="#Form.invoiceInstructions#">
			<cfinvokeargument Name="invoiceID_custom" Value="#Form.invoiceID_custom#">
			<cfinvokeargument Name="invoiceShipped" Value="#Form.invoiceShipped#">
			<cfinvokeargument Name="invoiceDateDue" Value="#Form.invoiceDateDue#">
			<cfinvokeargument Name="invoiceSent" Value="#Form.invoiceSent#">
			<cfinvokeargument Name="invoiceManual" Value="#Form.invoiceManual#">
			<cfinvokeargument Name="addressID_shipping" Value="#Form.addressID_shipping#">
			<cfinvokeargument Name="addressID_billing" Value="#Form.addressID_billing#">
			<cfinvokeargument Name="creditCardID" Value="#Form.creditCardID#">
			<cfinvokeargument Name="bankID" Value="#Form.bankID#">
		</cfinvoke>

		<!--- Insert custom fields and status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.invoiceID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.invoiceID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="invoiceID">
			<cfinvokeargument name="targetID" value="#URL.invoiceID#">
		</cfinvoke>

		<cflocation url="#Variables.formAction#&confirm_invoice=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertUpdateInvoice">
<cfset Variables.nowDateTime = fn_NowDateTimeIn5MinuteInterval(Now())>
<cfset Variables.nowDateTime_ampm = fn_ConvertFrom24HourFormat(Hour(Variables.nowDateTime))>
<cfset Variables.nowDateTime_hh = ListFirst(Variables.nowDateTime_ampm, '|')>
<cfset Variables.nowDateTime_tt = ListLast(Variables.nowDateTime_ampm, '|')>

<cfif Variables.doAction is "insertInvoice">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateInvoice.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateInvoice.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_invoice/form_insertUpdateInvoice.cfm">
