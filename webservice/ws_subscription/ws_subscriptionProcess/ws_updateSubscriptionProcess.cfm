<cfinclude template="wslang_subscriptionProcess.cfm">
<cfinvoke component="#Application.billingMapping#data.SubscriptionProcess" method="maxlength_SubscriptionProcess" returnVariable="maxlength_SubscriptionProcess" />

<cfinclude template="../../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateSubscriptionProcess", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_subscriptionProcess.updateSubscriptionProcess>
<cfelseif Not IsNumeric(Arguments.subscriptionProcessQuantity) or Arguments.subscriptionProcessQuantity lt 0
		or (Find(".", Arguments.subscriptionProcessQuantity) and Len(ListLast(Arguments.subscriptionProcessQuantity, ".")) gt maxlength_SubscriptionProcess.subscriptionProcessQuantity)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_subscriptionProcess.subscriptionQuantity>
<cfelse>
	<cfset returnValue = True>
	<cfloop Index="field" List="subscriptionProcessQuantityFinal">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.subscriptionID = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriptionID, Arguments.subscriptionID_custom, Arguments.useCustomIDFieldList)>
	<cfif ListLen(Arguments.subscriptionID) is 1 and Arguments.subscriptionID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_subscriptionProcess.invalidSubscription>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscription" ReturnVariable="qry_selectSubscriptionList">
			<cfinvokeargument Name="subscriptionID" Value="#Arguments.subscriptionID#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
			<cfinvokeargument Name="subscriberID" Value="#qry_selectSubscriptionList.subscriberID#">
		</cfinvoke>

		<cfif qry_selectSubscriber.subscriberStatus is 0
				or Not IsDate(qry_selectSubscriber.subscriberDateProcessNext)
				or qry_selectSubscriptionList.subscriptionStatus is 0
				or qry_selectSubscriptionList.subscriptionCompleted is 1
				or Not Application.fn_IsIntegerNonNegative(Arguments.priceStageID)
				or (qry_selectSubscriptionList.priceID is 0 and Arguments.priceStageID gt 0)>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_subscriptionProcess.subscriptionOptions>
		<cfelseif qry_selectSubscriptionList.subscriptionQuantityVaries is 0>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_subscriptionProcess.subscriptionQuantityVaries>
		<cfelseif qry_selectSubscriptionList.subscriptionIsRollup is 1>
			<cfset returnValue = False>
			<cfset returnError = Variables.wslang_subscriptionProcess.subscriptionIsRollup>
		<cfelseif qry_selectSubscriptionList.priceID is not 0>
			<!--- select custom prices for subscriptions --->
			<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPrice" ReturnVariable="qry_selectPriceList">
				<cfinvokeargument Name="priceID" Value="#qry_selectSubscriptionList.priceID#">
			</cfinvoke>

			<!--- validate dates and price stage --->
			<cfif Arguments.priceStageID is 0 and qry_selectPriceList.RecordCount is 1>
				<cfset Arguments.priceStageID = qry_selectPriceList.priceStageID>
			<cfelseif Not ListFind(ValueList(qry_selectPriceList.priceStageID), Arguments.priceStageID)>
				<cfset returnValue = False>
				<cfset returnError = Variables.wslang_subscriptionProcess.invalidPriceStage>
			</cfif>
		</cfif>

		<cfif returnValue is True>
			<!--- determine subscriberProcessID --->
			<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="selectSubscriberProcessList" ReturnVariable="qry_selectSubscriberProcessList">
				<cfinvokeargument Name="subscriberID" Value="#qry_selectSubscriptionList.subscriberID#">
				<cfinvokeargument Name="subscriberProcessDate" Value="#qry_selectSubscriber.subscriberDateProcessNext#">
			</cfinvoke>

			<!--- if do not already have subscriberProcessID for this billing period, create it now --->
			<cfif qry_selectSubscriberProcessList.RecordCount is 0>
				<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="insertSubscriberProcess" ReturnVariable="newSubscriberProcessID">
					<cfinvokeargument Name="subscriberID" Value="#qry_selectSubscriptionList.subscriberID#">
					<cfinvokeargument Name="subscriberProcessCurrent" Value="1">
					<cfinvokeargument Name="subscriberProcessDate" Value="#qry_selectSubscriber.subscriberDateProcessNext#">
					<cfinvokeargument Name="invoiceID" Value="0">
					<cfinvokeargument Name="subscriberProcessExistingInvoice" Value="0">
					<cfinvokeargument Name="subscriberProcessStatus" Value="1">
					<cfinvokeargument Name="subscriberProcessAllQuantitiesEntered" Value="0">
				</cfinvoke>

				<cfset subscriberProcessID = newSubscriberProcessID>
				<cfset thisMethod = "insertSubscriptionProcess">

			<cfelse><!--- if existing subscriberProcessID, check if subscription is areadly listed --->
				<cfset subscriberProcessID = qry_selectSubscriberProcessList.subscriberProcessID>
				<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="selectSubscriptionProcessList" ReturnVariable="qry_selectSubscriptionProcessList">
					<cfinvokeargument Name="subscriberProcessID" Value="#subscriberProcessID#">
					<cfinvokeargument Name="subscriptionID" Value="#Arguments.subscriptionID#">
					<cfinvokeargument Name="priceStageID" Value="#Arguments.priceStageID#">
				</cfinvoke>

				<cfif qry_selectSubscriptionProcessList.RecordCount is 0>
					<cfset thisMethod = "insertSubscriptionProcess">
				<cfelse>
					<cfset thisMethod = "updateSubscriptionProcess">
				</cfif>
			</cfif>

			<!--- insert/update subscription quantity --->
			<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="#thisMethod#" ReturnVariable="isSubscriptionProcessUUpdated">
				<cfinvokeargument Name="subscriberProcessID" Value="#subscriberProcessID#">
				<cfinvokeargument Name="subscriptionID" Value="#Arguments.subscriptionID#">
				<cfinvokeargument Name="priceStageID" Value="#Arguments.priceStageID#">
				<cfinvokeargument Name="subscriptionProcessQuantity" Value="#Arguments.subscriptionProcessQuantity#">
				<cfinvokeargument Name="subscriptionProcessQuantityFinal" Value="#Arguments.subscriptionProcessQuantityFinal#">
			</cfinvoke>

			<!--- check if all subscriptions are done. if so, update! --->
			<cfif Arguments.subscriptionProcessQuantityFinal is 1>
				<!--- any other variable-quantity subscriptions for this subscriber period? --->
				<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList_vary">
					<cfinvokeargument Name="subscriberID" Value="#qry_selectSubscriptionList.subscriberID#">
					<cfinvokeargument Name="subscriptionStatus" Value="1">
					<cfinvokeargument Name="subscriptionCompleted" Value="0">
					<cfinvokeargument Name="subscriptionQuantityVaries" Value="1">
					<cfinvokeargument Name="subscriptionIsRollup" Value="0">
					<cfinvokeargument Name="subscriptionDateProcessNext" Value="#qry_selectSubscriber.subscriberDateProcessNext#">
				</cfinvoke>

				<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="selectSubscriptionProcessList" ReturnVariable="qry_selectSubscriptionProcessList">
					<cfinvokeargument Name="subscriberProcessID" Value="#subscriberProcessID#">
					<cfinvokeargument Name="subscriptionProcessQuantityFinal" Value="1">
					<cfinvokeargument Name="subscriptionIsRollup" Value="0">
				</cfinvoke>

				<cfif qry_selectSubscriptionList_vary.RecordCount is qry_selectSubscriptionProcessList.RecordCount>
					<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="updateSubscriberProcess" ReturnVariable="isSubscriberProcessUpdated">
						<cfinvokeargument Name="subscriberProcessID" Value="#subscriberProcessID#">
						<cfinvokeargument Name="subscriberProcessAllQuantitiesEntered" Value="1">
					</cfinvoke>
				</cfif>
			</cfif><!--- /subscription is valid --->

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="updateSubscriptionProcess">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="subscription">
				<cfinvokeargument name="primaryTargetKey" value="subscriberProcessID">
				<cfinvokeargument name="targetID" value="#subscriberProcessID#">
			</cfinvoke>
		</cfif><!--- /subscription is valid --->
	</cfif><!--- /subscription is valid --->
</cfif><!--- /subscription is valid --->

<cfinclude template="../../webserviceSession/wsact_updateWebServiceSession.cfm">

