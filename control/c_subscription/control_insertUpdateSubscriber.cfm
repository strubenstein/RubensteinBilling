<!--- 
regionID
languageID
--->

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfset Variables.subscriberDateFieldList = "subscriberDateProcessNext,subscriberDateProcessLast">
<cfinvoke component="#Application.billingMapping#data.Subscriber" method="maxlength_Subscriber" returnVariable="maxlength_Subscriber" />

<cfif URL.subscriberID is not 0>
	<!--- get subscriber payment information --->
	<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="selectSubscriberPaymentList" ReturnVariable="qry_selectSubscriberPaymentList">
		<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
		<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
	</cfinvoke>
</cfif>

<cfinclude template="formParam_insertUpdateSubscriber.cfm">

<!--- if coming from user, get company's user is in --->
<cfset Variables.displayCompanyList = False>
<cfif Variables.doAction is "insertSubscriber" and URL.control is "user">
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserCompanyList_user" ReturnVariable="qry_selectUserCompanyList_user">
		<cfinvokeargument Name="userID" Value="#Form.userID#">
		<cfinvokeargument Name="userCompanyStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectUserCompanyList_user.RecordCount gt 1>
		<cfset Variables.displayCompanyList = True>
	</cfif>
</cfif>

<!--- get users in company for contact --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#Form.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<!--- billing and shipping address --->
<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectShippingAddressList">
	<cfinvokeargument Name="companyID" Value="#Form.companyID#">
	<cfif Form.userID is not 0>
		<cfinvokeargument Name="userID" Value="#Form.userID#">
	</cfif>
	<cfinvokeargument Name="addressTypeShipping" Value="1">
	<cfinvokeargument Name="addressStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectBillingAddressList">
	<cfinvokeargument Name="companyID" Value="#Form.companyID#">
	<cfif Form.userID is not 0>
		<cfinvokeargument Name="userID" Value="#Form.userID#">
	</cfif>
	<cfinvokeargument Name="addressTypeBilling" Value="1">
	<cfinvokeargument Name="addressStatus" Value="1">
</cfinvoke>
<!--- /billing and shipping address --->

<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
	<!--- <cfinvokeargument Name="userID" Value="#Form.userID#"> --->
	<cfinvokeargument Name="companyID" Value="#Form.companyID#">
	<cfinvokeargument Name="creditCardStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
	<!--- <cfinvokeargument Name="userID" Value="#Form.userID#"> --->
	<cfinvokeargument Name="companyID" Value="#Form.companyID#">
	<cfinvokeargument Name="bankStatus" Value="1">
</cfinvoke>

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="subscriberID">
	<cfinvokeargument name="targetID_formParam" value="#URL.subscriberID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="subscriberID">
	<cfinvokeargument name="targetID_formParam" value="#URL.subscriberID#">
</cfinvoke>

<cfinclude template="../../view/v_subscription/lang_insertUpdateSubscriber.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitSubscriber")>
	<cfinclude template="formValidate_insertUpdateSubscriber.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">

	<cfelseif Variables.doAction is "insertSubscriber">
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="insertSubscriber" ReturnVariable="newSubscriberID">
			<cfinvokeargument Name="companyID" Value="#Form.companyID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="userID_cancel" Value="0">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="subscriberName" Value="#Form.subscriberName#">
			<cfinvokeargument Name="subscriberID_custom" Value="#Form.subscriberID_custom#">
			<cfinvokeargument Name="subscriberStatus" Value="#Form.subscriberStatus#">
			<cfinvokeargument Name="subscriberCompleted" Value="0">
			<cfinvokeargument Name="subscriberDateProcessNext" Value="#Form.subscriberDateProcessNext#">
			<cfinvokeargument Name="subscriberDateProcessLast" Value="">
			<cfinvokeargument Name="addressID_billing" Value="#Form.addressID_billing#">
			<cfinvokeargument Name="addressID_shipping" Value="#Form.addressID_shipping#">
		</cfinvoke>

		<cfif Form.bankID is not 0 or Form.creditCardID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="insertSubscriberPayment" ReturnVariable="isSubscriberPaymentInserted">
				<cfinvokeargument Name="subscriberID" Value="#newSubscriberID#">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
				<cfinvokeargument Name="userID_cancel" Value="0">
				<cfinvokeargument Name="creditCardID" Value="#Form.creditCardID#">
				<cfinvokeargument Name="bankID" Value="#Form.bankID#">
				<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
			</cfinvoke>
		</cfif>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newSubscriberID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newSubscriberID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="subscriberID">
			<cfinvokeargument name="targetID" value="#newSubscriberID#">
		</cfinvoke>

		<cfset Variables.redirectAction = Replace(Variables.formAction, Variables.doAction, "updateSubscriber", "ONE")>
		<cflocation url="#Variables.redirectAction#&subscriberID=#newSubscriberID#&confirm_subscription=#Variables.doAction#" AddToken="No">

	<cfelse><!--- updateSubscriber --->
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="updateSubscriber" ReturnVariable="isSubscriberUpdated">
			<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
			<cfinvokeargument Name="userID" Value="#Form.userID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfif Form.subscriberStatus is 0>
				<cfinvokeargument Name="userID_cancel" Value="#Session.userID#">
			</cfif>
			<cfinvokeargument Name="subscriberName" Value="#Form.subscriberName#">
			<cfinvokeargument Name="subscriberID_custom" Value="#Form.subscriberID_custom#">
			<cfinvokeargument Name="subscriberStatus" Value="#Form.subscriberStatus#">
			<cfinvokeargument Name="subscriberCompleted" Value="#Form.subscriberCompleted#">
			<cfinvokeargument Name="subscriberDateProcessNext" Value="#Form.subscriberDateProcessNext#">
			<cfinvokeargument Name="subscriberDateProcessLast" Value="#Form.subscriberDateProcessLast#">
			<cfinvokeargument Name="addressID_billing" Value="#Form.addressID_billing#">
			<cfinvokeargument Name="addressID_shipping" Value="#Form.addressID_shipping#">
		</cfinvoke>

		<!--- if value different than existing value--->
		<cfif qry_selectSubscriberPaymentList.bankID is not Form.bankID or qry_selectSubscriberPaymentList.creditCardID is not Form.creditCardID>
			<cfif qry_selectSubscriberPaymentList.RecordCount is 1 and (qry_selectSubscriberPaymentList.bankID is not 0 or qry_selectSubscriberPaymentList.creditCardID is not 0)>
				<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="updateSubscriberPayment" ReturnVariable="isSubscriberPaymentUpdated">
					<cfinvokeargument Name="subscriberPaymentID" Value="#qry_selectSubscriberPaymentList.subscriberPaymentID#">
					<cfinvokeargument Name="subscriberPaymentStatus" Value="0">
					<cfinvokeargument Name="userID_cancel" Value="#Session.userID#">
				</cfinvoke>
			</cfif>

			<cfif Form.bankID is not 0 or Form.creditCardID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="insertSubscriberPayment" ReturnVariable="isSubscriberPaymentInserted">
					<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
					<cfinvokeargument Name="userID_author" Value="#Session.userID#">
					<cfinvokeargument Name="userID_cancel" Value="0">
					<cfinvokeargument Name="creditCardID" Value="#Form.creditCardID#">
					<cfinvokeargument Name="bankID" Value="#Form.bankID#">
					<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
				</cfinvoke>
			</cfif>
		</cfif>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.subscriberID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.subscriberID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="subscriberID">
			<cfinvokeargument name="targetID" value="#URL.subscriberID#">
		</cfinvoke>

		<cflocation url="#Variables.formAction#&confirm_subscription=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertUpdateSubscriber">
<cfset Variables.nowDateTime = fn_NowDateTimeIn5MinuteInterval(Now())>
<cfset Variables.nowDateTime_ampm = fn_ConvertFrom24HourFormat(Hour(Variables.nowDateTime))>
<cfset Variables.nowDateTime_hh = ListFirst(Variables.nowDateTime_ampm, '|')>
<cfset Variables.nowDateTime_tt = ListLast(Variables.nowDateTime_ampm, '|')>

<cfif Variables.doAction is "insertSubscriber">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateSubscriber.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateSubscriber.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_subscription/form_insertUpdateSubscriber.cfm">
