<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertSubscriber", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_subscription.insertSubscriber>
<cfelse>
	<cfloop Index="field" List="subscriberStatus,subscriberCompleted">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset returnValue = 0>
	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.companyID lte 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_subscription.invalidCompany>
	</cfif>

	<cfif (Arguments.userID is not 0 or Arguments.userID_custom is not "") and returnValue is 0>
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
		<cfif Arguments.userID lte 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_subscription.invalidUser>
		<cfelse>
			<cfset qry_selectUserCompanyList_company = QueryNew("userID")>
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
		</cfif>
	</cfif>

	<cfif returnValue is 0>
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
		<cfset URL.companyID = Arguments.companyID>
		<cfset URL.userID = Arguments.userID>
		<cfinclude template="wsact_insertSubscriber.cfm">

		<!--- if subscriber was created, check custom fields and custom status --->
		<cfif returnValue gt 0>
			<cfset Arguments.subscriberID = returnValue>

			<!--- custom fields --->
			<cfif Trim(Arguments.customField) is not "">
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="subscriberID">
					<cfinvokeargument Name="targetID" Value="#Arguments.subscriberID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif Arguments.statusID is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
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
				<cfinvokeargument name="doAction" value="insertSubscriber">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="company">
				<cfinvokeargument name="primaryTargetKey" value="subscriberID">
				<cfinvokeargument name="targetID" value="#Arguments.subscriberID#">
			</cfinvoke>

			<cfset returnValue = Arguments.subscriberID>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

