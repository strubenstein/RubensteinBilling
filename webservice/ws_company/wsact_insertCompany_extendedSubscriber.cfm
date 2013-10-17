<cfset qry_selectUserCompanyList_company = QueryNew("userID")>
<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>

<cfset qry_selectBankList = QueryNew("bankID")>
<cfset temp = QueryAddRow(qry_selectBankList, 1)>
<cfset temp = QuerySetCell(qry_selectBankList, "bankID", ToString(Arguments.bankID), 1)>

<cfset qry_selectCreditCardList = QueryNew("creditCardID")>
<cfset temp = QueryAddRow(qry_selectCreditCardList, 1)>
<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardID", ToString(Arguments.creditCardID), 1)>

<cfset qry_selectBillingAddressList = QueryNew("addressID")>
<cfset temp = QueryAddRow(qry_selectBillingAddressList, 1)>
<cfset temp = QuerySetCell(qry_selectBillingAddressList, "addressID", ToString(Arguments.addressID_billing), 1)>

<cfset qry_selectShippingAddressList = QueryNew("addressID")>
<cfset temp = QueryAddRow(qry_selectShippingAddressList, 1)>
<cfset temp = QuerySetCell(qry_selectShippingAddressList, "addressID", ToString(Arguments.addressID_shipping), 1)>

<cfif Arguments.creditCardID is not 0 and Arguments.bankID is not 0>
	<cfif Arguments.subscriberPaymentViaCreditCard is True>
		<cfset Arguments.bankID = 0>
	<cfelseif Arguments.subscriberPaymentViaBank is True>
		<cfset Arguments.creditCardID = 0>
	<cfelse>
		<cfset Arguments.bankID = 0>
		<cfset Arguments.creditCardID = 0>
	</cfif>
</cfif>

<cfset returnValue = 0>
<cfinclude template="../ws_subscription/wsact_insertSubscriber.cfm">
<cfif returnValue gt 0>
	<cfset Arguments.subscriberID = returnValue>
	<cfset returnValueXml = returnValueXml & "<subscriberID>#Arguments.subscriberID#</subscriberID>">

	<!--- subscriber notify --->
	<cfif ListFind(permissionActionList, "insertSubscriberNotify")
			and (Arguments.subscriberNotifyEmail is 1 or Arguments.subscriberNotifyEmailHtml is 1 or Arguments.subscriberNotifyPdf is 1
				or Arguments.subscriberNotifyDoc is 1 or Arguments.subscriberNotifyFax is 1
				or Arguments.subscriberNotifyBillingAddress is 1 or Arguments.subscriberNotifyShippingAddress is 1)>
		<cfset Arguments.phoneID = Arguments.faxID>
		<cfinclude template="../ws_subscription/wsact_insertSubscriberNotify.cfm">
	</cfif>

	<!--- subscriber custom fields --->
	<cfif Trim(Arguments.customField_subscriber) is not "">
		<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="primaryTargetKey" Value="subscriberID">
			<cfinvokeargument Name="targetID" Value="#Arguments.subscriberID#">
			<cfinvokeargument Name="customField" Value="#Arguments.customField_company#">
		</cfinvoke>
	</cfif>

	<!--- subscriber custom status --->
	<cfif Arguments.statusID_subscriber is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID_subscriber") or ListFind(Arguments.useCustomIDFieldList, "statusID_subscriber_custom")>
		<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
			<cfinvokeargument Name="primaryTargetKey" Value="subscriberID">
			<cfinvokeargument Name="targetID" Value="#Arguments.subscriberID#">
			<cfinvokeargument Name="useCustomIDFieldList" Value="#ReplaceNoCase(ReplaceNoCase(Arguments.useCustomIDFieldList, 'statusID_subscriber', 'statusID', '"ALL'), 'statusID_subscriber_custom', 'statusID_custom', 'ALL')#">
			<cfinvokeargument Name="statusID" Value="#Arguments.statusID_subscriber#">
			<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_subscriber_custom#">
			<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment_subscriber#">
		</cfinvoke>
	</cfif><!--- /custom status for subscriber --->

	<!--- check for trigger --->
	<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
		<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
		<cfinvokeargument name="doAction" value="insertCompany">
		<cfinvokeargument name="isWebService" value="True">
		<cfinvokeargument name="doControl" value="company">
		<cfinvokeargument name="primaryTargetKey" value="companyID">
		<cfinvokeargument name="targetID" value="#Arguments.companyID#">
	</cfinvoke>
</cfif><!--- /subscriber was successfully created --->
