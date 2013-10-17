<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateSubscriber", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_subscription.updateSubscriber>
<cfelse>
	<cfset returnValue = True>
	<cfloop Index="field" List="subscriberStatus,subscriberCompleted">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.subscriberID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_subscription.invalidSubscriber>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
		</cfinvoke>

		<cfset Arguments.companyID = qry_selectSubscriber.companyID>

		<cfif (Arguments.userID is not 0 or Arguments.userID_custom is not "")>
			<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
			<cfif Arguments.userID lte 0>
				<cfset returnValue = False>
				<cfset returnError = Variables.wslang_subscription.invalidUser>
			<cfelse>
				<cfset qry_selectUserCompanyList_company = QueryNew("userID")>
				<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
				<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
			</cfif>
		</cfif>

		<cfif returnValue is True>
			<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="selectSubscriberPaymentList" ReturnVariable="qry_selectSubscriberPaymentList">
				<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
				<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
			</cfinvoke>

			<!--- billing and shipping address --->
			<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectShippingAddressList">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfif Arguments.userID is not 0>
					<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				</cfif>
				<cfinvokeargument Name="addressTypeShipping" Value="1">
				<cfinvokeargument Name="addressStatus" Value="1">
			</cfinvoke>
			
			<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectBillingAddressList">
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfif Arguments.userID is not 0>
					<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				</cfif>
				<cfinvokeargument Name="addressTypeBilling" Value="1">
				<cfinvokeargument Name="addressStatus" Value="1">
			</cfinvoke>
			<!--- /billing and shipping address --->
	
			<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
				<!--- <cfinvokeargument Name="userID" Value="#Arguments.userID#"> --->
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="creditCardStatus" Value="1">
			</cfinvoke>
	
			<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
				<!--- <cfinvokeargument Name="userID" Value="#Arguments.userID#"> --->
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
				<cfinvokeargument Name="bankStatus" Value="1">
			</cfinvoke>

			<cfset Form = Arguments>
			<cfset URL.subscriberID = Arguments.subscriberID>
			<cfset URL.companyID = qry_selectSubscriber.companyID>
			<cfset URL.userID = qry_selectSubscriber.userID>
			<cfset URL.control = "">

			<cfset Variables.doAction = "updateSubscriber">
			<cfset Variables.displayCompanyList = False>
			<cfset Variables.updateFieldList_valid = "userID,subscriberName,subscriberStatus,subscriberCompleted,subscriberDateProcessNext,subscriberDateProcessLast,addressID_billing,addressID_shipping">

			<cfloop Index="field" List="#Variables.updateFieldList_valid#">
				<cfif Not IsDefined("Form.#field#") or Not ListFind(Arguments.updateFieldList, field)>
				<cfset Form[field] = Evaluate("qry_selectSubscriber.#field#")>
				</cfif>
			</cfloop>

			<cfif Not IsDefined("fn_FormValidateDateTime")>
				<cfinclude template="../../include/function/fn_datetime.cfm">
			</cfif>
			<cfset Variables.subscriberDateFieldList = "subscriberDateProcessNext,subscriberDateProcessLast">

			<cfloop Index="field" List="subscriberDateProcessNext,subscriberDateProcessLast">
				<cfif Not IsDate(Arguments[field])>
					<cfset Form["#field#_date"] = "">
					<cfset Form["#field#_hh"] = "12">
					<cfset Form["#field#_mm"] = "00">
					<cfset Form["#field#_tt"] = "am">
				<cfelse>
					<cfset hour_ampm = fn_ConvertFrom24HourFormat(Hour(Arguments[field]))>
					<cfset Form["#field#_date"] = DateFormat(Arguments[field], 'mm/dd/yyyy')>
					<cfset Form["#field#_hh"] = ListFirst(hour_ampm, '|')>
					<cfset Form["#field#_mm"] = Minute(Arguments[field])>
					<cfset Form["#field#_tt"] = ListLast(hour_ampm, '|')>
				</cfif>
			</cfloop>

			<cfinvoke component="#Application.billingMapping#data.Subscriber" method="maxlength_Subscriber" returnVariable="maxlength_Subscriber" />
			<cfinclude template="../../control/c_subscription/formParam_insertUpdateSubscriber.cfm">
			<cfinclude template="../../view/v_subscription/lang_insertUpdateSubscriber.cfm">
			<cfinclude template="../../control/c_subscription/formValidate_insertUpdateSubscriber.cfm">

			<cfif isAllFormFieldsOk is False>
				<cfset returnValue = False>
				<cfset returnError = "">
				<cfloop Collection="#errorMessage_fields#" Item="field">
					<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
				</cfloop>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="updateSubscriber" ReturnVariable="isSubscriberUpdated">
					<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfif ListFind(Arguments.updateFieldList, Arguments.subscriberStatus) and Arguments.subscriberStatus is 0>
						<cfinvokeargument Name="userID_cancel" Value="#qry_selectWebServiceSession.userID#">
					</cfif>
					<cfloop Index="field" List="#Variables.updateFieldList_valid#">
						<cfif ListFind(Arguments.updateFieldList, field)>
							<cfinvokeargument Name="#field#" Value="#Arguments[field]#">
						</cfif>
					</cfloop>
				</cfinvoke>

				<!--- if value different than existing value--->
				<cfif qry_selectSubscriberPaymentList.bankID is not Arguments.bankID or qry_selectSubscriberPaymentList.creditCardID is not Arguments.creditCardID>
					<cfif qry_selectSubscriberPaymentList.RecordCount is 1 and (qry_selectSubscriberPaymentList.bankID is not 0 or qry_selectSubscriberPaymentList.creditCardID is not 0)>
						<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="updateSubscriberPayment" ReturnVariable="isSubscriberPaymentUpdated">
							<cfinvokeargument Name="subscriberPaymentID" Value="#qry_selectSubscriberPaymentList.subscriberPaymentID#">
							<cfinvokeargument Name="subscriberPaymentStatus" Value="0">
							<cfinvokeargument Name="userID_cancel" Value="#qry_selectWebServiceSession.userID#">
						</cfinvoke>
					</cfif>

					<cfif Arguments.bankID is not 0 or Arguments.creditCardID is not 0>
						<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="insertSubscriberPayment" ReturnVariable="isSubscriberPaymentInserted">
							<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
							<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
							<cfinvokeargument Name="userID_cancel" Value="0">
							<cfinvokeargument Name="creditCardID" Value="#Arguments.creditCardID#">
							<cfinvokeargument Name="bankID" Value="#Arguments.bankID#">
							<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
						</cfinvoke>
					</cfif>
				</cfif>

				<!--- custom fields --->
				<cfif Trim(Arguments.customField) is not "" and ListFind(Arguments.updateFieldList, "customField")>
					<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
						<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
						<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
						<cfinvokeargument Name="primaryTargetKey" Value="subscriberID">
						<cfinvokeargument Name="targetID" Value="#Arguments.subscriberID#">
						<cfinvokeargument Name="customField" Value="#Arguments.customField#">
					</cfinvoke>
				</cfif>

				<!--- custom status --->
				<cfif ListFind(Arguments.updateFieldList, "statusID")>
					<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
						<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
						<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
						<cfinvokeargument Name="primaryTargetKey" Value="subscriberID">
						<cfinvokeargument Name="targetID" Value="#Arguments.subscriberID#">
						<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
						<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
						<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
						<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
					</cfinvoke>
				</cfif>

				<!--- check for trigger --->
				<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
					<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
					<cfinvokeargument name="doAction" value="updateSubscriber">
					<cfinvokeargument name="isWebService" value="True">
					<cfinvokeargument name="doControl" value="subscription">
					<cfinvokeargument name="primaryTargetKey" value="subscriberID">
					<cfinvokeargument name="targetID" value="#Arguments.subscriberID#">
				</cfinvoke>

				<cfset returnValue = True>
			</cfif><!--- /form fields validated --->
		</cfif><!--- /subscriber user is valid --->
	</cfif><!--- /subscriber is valid --->
</cfif><!--- /user is logged in and has permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

