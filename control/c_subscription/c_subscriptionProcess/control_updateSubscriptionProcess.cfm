<!--- 
subscriber processing - 
possible to have multiple subcriberprocessID's waiting
do not redirect if existing open subscriberProcessID
--->

<cfif Not IsDate(qry_selectSubscriber.subscriberDateProcessNext)>
	<cflocation url="index.cfm?method=subscription.viewSubscriber&subscriberID=#URL.subscriberID#&error_subscription=#Variables.doAction#" AddToken="No">
</cfif>

<!--- included from control_subscription.cfm, so URL.subscriberID is validated --->
<!--- if subscriber process not yet recorded for next processing date, insert now --->
<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="selectSubscriberProcessList" ReturnVariable="qry_selectSubscriberProcessList">
	<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
	<!--- <cfinvokeargument Name="subscriberProcessCurrent" Value="1"> --->
	<cfinvokeargument Name="subscriberProcessDate" Value="#qry_selectSubscriber.subscriberDateProcessNext#">
	<!--- <cfinvokeargument Name="subscriberProcessAllQuantitiesEntered" Value="1"> --->
</cfinvoke>

<!--- select variable quantity subscriptions for subscriber --->
<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
	<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
	<cfinvokeargument Name="subscriptionStatus" Value="1">
	<cfinvokeargument Name="subscriptionCompleted" Value="0">
	<cfinvokeargument Name="subscriptionQuantityVaries" Value="1">
	<cfinvokeargument Name="subscriptionDateProcessNext" Value="#qry_selectSubscriber.subscriberDateProcessNext#">
</cfinvoke>

<!--- if no variable-quantity subscriptions, no need to submit form --->
<cfif qry_selectSubscriptionList.RecordCount is 0>
	<cflocation url="index.cfm?method=subscription.viewSubscriber&subscriberID=#URL.subscriberID#&error_subscription=#Variables.doAction#" AddToken="No">
</cfif>

<!--- select custom prices for subscriptions --->
<cfif REFind("[1-9]", ValueList(qry_selectSubscriptionList.priceID))>
	<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPrice" ReturnVariable="qry_selectPriceList">
		<cfinvokeargument Name="priceID" Value="#ValueList(qry_selectSubscriptionList.priceID)#">
	</cfinvoke>
</cfif>

<!--- for each subscription, determine list of applicable price stages for this billing period --->
<cfinclude template="act_processSubscription_priceStage.cfm">
<cfset subscriptionID_priceStageIDList = subscriptionID_priceStageIDList>

<cfif qry_selectSubscriberProcessList.RecordCount is 1>
	<cfset URL.subscriberProcessID = qry_selectSubscriberProcessList.subscriberProcessID>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="insertSubscriberProcess" ReturnVariable="newSubscriberProcessID">
		<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
		<cfinvokeargument Name="subscriberProcessCurrent" Value="1">
		<cfinvokeargument Name="subscriberProcessDate" Value="#qry_selectSubscriber.subscriberDateProcessNext#">
		<cfinvokeargument Name="invoiceID" Value="0">
		<cfinvokeargument Name="subscriberProcessExistingInvoice" Value="0">
		<cfinvokeargument Name="subscriberProcessStatus" Value="1">
		<cfinvokeargument Name="subscriberProcessAllQuantitiesEntered" Value="0">
	</cfinvoke>

	<cfset URL.subscriberProcessID = newSubscriberProcessID>
</cfif>

<!--- select existing subscription quantities --->
<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="selectSubscriptionProcessList" ReturnVariable="qry_selectSubscriptionProcessList">
	<cfinvokeargument Name="subscriberProcessID" Value="#URL.subscriberProcessID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.SubscriptionProcess" method="maxlength_SubscriptionProcess" returnVariable="maxlength_SubscriptionProcess" />
<cfinclude template="formParam_updateSubscriptionProcess.cfm">
<cfinclude template="../../../view/v_subscription/v_subscriptionProcess/lang_updateSubscriptionProcess.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitSubscriptionProcess")>
	<cfinclude template="formValidate_updateSubscriptionProcess.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<cfset Variables.subscriberProcessAllQuantitiesEntered = 1>
		<cfloop Query="qry_selectSubscriptionList">
			<cfif qry_selectSubscriptionList.subscriptionIsRollup is 0>
				<cfset Variables.thisSubscriptionID = qry_selectSubscriptionList.subscriptionID>
				<cfloop Index="loopPriceStageID" List="#subscriptionID_priceStageIDList["subscription#Variables.thisSubscriptionID#"]#">
					<cfif ListFind(Form.subscriptionProcessQuantityFinal, Variables.thisSubscriptionID & "_" & loopPriceStageID)>
						<cfset Variables.thisSubscriptionProcessQuantityFinal = 1>
					<cfelse>
						<cfset Variables.thisSubscriptionProcessQuantityFinal = 0>
						<cfset Variables.subscriberProcessAllQuantitiesEntered = 0>
					</cfif>

					<cfset Variables.thisSubscriptionProcessQuantity  = Form["subscriptionProcessQuantity#Variables.thisSubscriptionID#_#loopPriceStageID#"]>
					<cfset Variables.subProcRow = ListFind(ValueList(qry_selectSubscriptionProcessList.subscriptionID_priceStageID), "#Variables.thisSubscriptionID#_#loopPriceStageID#")>

					<!--- if subscription already listed, update; otherwise, insert --->
					<cfif Variables.subProcRow is not 0>
						<cfset Variables.thisMethod = "updateSubscriptionProcess">
					<cfelse>
						<cfset Variables.thisMethod = "insertSubscriptionProcess">
					</cfif>

					<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="#Variables.thisMethod#" ReturnVariable="isSubscriptionProcessUpdated">
						<cfinvokeargument Name="subscriberProcessID" Value="#URL.subscriberProcessID#">
						<cfinvokeargument Name="subscriptionID" Value="#qry_selectSubscriptionList.subscriptionID#">
						<cfinvokeargument Name="priceStageID" Value="#loopPriceStageID#">
						<cfinvokeargument Name="subscriptionProcessQuantity" Value="#Variables.thisSubscriptionProcessQuantity#">
						<cfinvokeargument Name="subscriptionProcessQuantityFinal" Value="#Variables.thisSubscriptionProcessQuantityFinal#">
					</cfinvoke>
				</cfloop><!--- /loop thru price stages for subscription --->
			</cfif><!--- /if not roll to --->
		</cfloop><!--- /loop thru subscriptions --->

			<!--- 
			<cfif Variables.subProcRow is not 0>
				<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="updateSubscriptionProcess" ReturnVariable="isSubscriptionProcessUpdated">
					<cfinvokeargument Name="subscriberProcessID" Value="#URL.subscriberProcessID#">
					<cfinvokeargument Name="subscriptionID" Value="#qry_selectSubscriptionList.subscriptionID#">
					<cfinvokeargument Name="priceStageID" Value="0">
					<cfinvokeargument Name="subscriptionProcessQuantity" Value="#Variables.thisSubscriptionProcessQuantity#">
					<cfinvokeargument Name="subscriptionProcessQuantityFinal" Value="#Variables.thisSubscriptionProcessQuantityFinal#">
				</cfinvoke>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="insertSubscriptionProcess" ReturnVariable="isSubscriptionProcessUpdated">
					<cfinvokeargument Name="subscriberProcessID" Value="#URL.subscriberProcessID#">
					<cfinvokeargument Name="subscriptionID" Value="#qry_selectSubscriptionList.subscriptionID#">
					<cfinvokeargument Name="priceStageID" Value="0">
					<cfinvokeargument Name="subscriptionProcessQuantity" Value="#Variables.thisSubscriptionProcessQuantity#">
					<cfinvokeargument Name="subscriptionProcessQuantityFinal" Value="#Variables.thisSubscriptionProcessQuantityFinal#">
				</cfinvoke>
			</cfif>
			--->

		<!--- if all quantities are final, update subscriber process to reflect such so it can be processed --->
		<cfif Variables.subscriberProcessAllQuantitiesEntered is 1>
			<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="updateSubscriberProcess" ReturnVariable="isSubscriberProcessUpdated">
				<cfinvokeargument Name="subscriberProcessID" Value="#URL.subscriberProcessID#">
				<cfinvokeargument Name="subscriberProcessAllQuantitiesEntered" Value="1">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfset Variables.doAction = "updateSubscriptionProcess">
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="updateSubscriptionProcess">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="subscription">
			<cfinvokeargument name="primaryTargetKey" value="subscriberProcessID">
			<cfinvokeargument name="targetID" value="#URL.subscriberProcessID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=subscription.#Variables.doAction#&subscriberID=#URL.subscriberID#&confirm_subscription=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "updateSubscriptionProcess">
<cfset Variables.columnHeaderList = Variables.lang_updateSubscriptionProcess_title.subscriptionOrder
		& "^" & Variables.lang_updateSubscriptionProcess_title.subscriptionName
		& "^" & Variables.lang_updateSubscriptionProcess_title.subscriptionDateBegin
		& "^" & Variables.lang_updateSubscriptionProcess_title.subscriptionDateEnd
		& "^" & Variables.lang_updateSubscriptionProcess_title.subscriptionPriceUnit
		& "^" & Variables.lang_updateSubscriptionProcess_title.subscriptionQuantity
		& "^" & Variables.lang_updateSubscriptionProcess_title.subscriptionProcessQuantity
		& "^" & Variables.lang_updateSubscriptionProcess_title.subscriptionProcessQuantityFinal>
<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../../view/v_subscription/v_subscriptionProcess/form_updateSubscriptionProcess.cfm">
