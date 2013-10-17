<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertSubscriberNotify", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<!--- updateSubscriberNotify --->
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_subscription.insertSubscriberNotify>
<cfelse>
	<cfset returnValue = True>
	<cfloop Index="field" List="subscriberNotifyEmail,subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc">
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

		<!--- user must be valid user for subscriber company or primary company --->
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, qry_selectSubscriber.companyID)>
		<cfif Arguments.userID lte 0>
			<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, qry_selectWebServiceSession.companyID_author)>
			<cfif Arguments.userID lte 0>
				<cfset returnValue = False>
				<cfset returnError = Variables.wslang_subscription.invalidUser>
			</cfif>
		</cfif>

		<cfif returnValue is True>
			<cfset qry_selectUserCompanyList_company = QueryNew("userID")>
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>

			<cfset qry_selectUserList = QueryNew("userID")>
			<cfset temp = QueryAddRow(qry_selectUserList, 1)>
			<cfset temp = QuerySetCell(qry_selectUserList, "userID", ToString(Arguments.userID), 1)>

			<cfset Form = Arguments>
			<cfset URL.subscriberID = Arguments.subscriberID>

			<cfinvoke Component="#Application.billingMapping#data.SubscriberNotify" Method="selectSubscriberNotifyList" ReturnVariable="qry_selectSubscriberNotifyList">
				<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
				<cfinvokeargument Name="userID" Value="#Arguments.userID#">
				<!--- <cfinvokeargument Name="subscriberNotifyStatus" Value="1"> --->
			</cfinvoke>

			<!--- validate notification options --->
			<cfset isAllFormFieldsOk = True>
			<cfloop Index="field" List="subscriberNotifyEmail,subscriberNotifyEmailHtml,subscriberNotifyPdf,subscriberNotifyDoc">
				<cfif Not ListFind("0,1", Arguments[field])>
					<cfset isAllFormFieldsOk = False>
					<cfbreak>
				</cfif>
			</cfloop>

			<cfif Arguments.addressID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddress" ReturnVariable="qry_selectAddress">
					<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
				</cfinvoke>
				
				<cfif qry_selectAddress.addressID is 0
						or Not ListFind("#qry_selectSubscriber.companyID#,#qry_selectWebServiceSession.companyID_author#", qry_selectAddress.companyID)>
					<cfset isAllFormFieldsOk = False>
				</cfif>
			</cfif>

			<cfif Arguments.phoneID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhone" ReturnVariable="qry_selectPhone">
					<cfinvokeargument Name="phoneID" Value="#Arguments.phoneID#">
				</cfinvoke>

				<cfif qry_selectPhone.addressID is 0
						or Not ListFind("#qry_selectSubscriber.companyID#,#qry_selectWebServiceSession.companyID_author#", qry_selectPhone.companyID)
						or qry_selectPhone.phoneType is not "fax">
					<cfset isAllFormFieldsOk = False>
				</cfif>
			</cfif>
			<!--- /validate notification options --->

			<cfif isAllFormFieldsOk is False>
				<cfset returnValue = False>
				<cfset returnError = Variables.wslang_subscription.notificationUser>
			<cfelse>
				<cfif Arguments.addressID is not 0 or Arguments.subscriberNotifyEmail is not 0
						or Arguments.subscriberNotifyEmailHtml is not 0 or Arguments.subscriberNotifyPdf is not 0
						or Arguments.subscriberNotifyDoc is not 0 or Arguments.phoneID is not 0>
					<cfset subscriberNotifyStatus = 1>
				<cfelse>
					<cfset subscriberNotifyStatus = 0>
				</cfif>

				<cfif qry_selectSubscriberNotifyList.RecordCount is 0>
					<cfset notifyMethod = "insertSubscriberNotify">
				<cfelse>
					<cfset notifyMethod = "updateSubscriberNotify">
				</cfif>

				<cfif subscriberNotifyStatus is 1 or notifyMethod is "updateSubscriberNotify">
					<cfinvoke Component="#Application.billingMapping#data.SubscriberNotify" Method="#notifyMethod#" ReturnVariable="isSubscriberNotifyInserted">
						<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
						<cfinvokeargument Name="userID" Value="#Arguments.userID#">
						<cfinvokeargument Name="subscriberNotifyStatus" Value="#subscriberNotifyStatus#">
						<cfif subscriberNotifyStatus is 1>
							<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
							<cfinvokeargument Name="userID_cancel" Value="0">
						<cfelse>
							<cfinvokeargument Name="userID_cancel" Value="#qry_selectWebServiceSession.userID#">
						</cfif>
						<cfinvokeargument Name="addressID" Value="#Arguments.addressID#">
						<cfinvokeargument Name="subscriberNotifyEmail" Value="#Arguments.subscriberNotifyEmail#">
						<cfinvokeargument Name="subscriberNotifyEmailHtml" Value="#Arguments.subscriberNotifyEmailHtml#">
						<cfinvokeargument Name="subscriberNotifyPdf" Value="#Arguments.subscriberNotifyPdf#">
						<cfinvokeargument Name="subscriberNotifyDoc" Value="#Arguments.subscriberNotifyDoc#">
						<cfinvokeargument Name="phoneID" Value="#Arguments.phoneID#">
					</cfinvoke>

					<!--- check for trigger --->
					<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
						<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
						<cfinvokeargument name="doAction" value="#notifyMethod#">
						<cfinvokeargument name="isWebService" value="True">
						<cfinvokeargument name="doControl" value="subscription">
						<cfinvokeargument name="primaryTargetKey" value="subscriberID">
						<cfinvokeargument name="targetID" value="#Arguments.subscriberID#">
					</cfinvoke>
				</cfif><!--- /user notification options have changed --->
			</cfif><!--- /notification options are valid --->
		</cfif><!--- /user is valid --->
	</cfif><!--- /subscriber is valid --->
</cfif><!--- /user is valid and has permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

