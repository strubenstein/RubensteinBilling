<cfinclude template="wslang_subscriptionProcess.cfm">
<cfinclude template="../../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("updateSubscriptionProcess", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_subscriptionProcess.updateSubscriptionProcess>
<cfelse>
	<cfloop Index="field" List="subscriptionProcessQuantityFinal">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	<cfif ListLen(Arguments.subscriberID) is 1 and Arguments.subscriberID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_subscriptionProcess.invalidSubscriber>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
		</cfinvoke>

		<cfif qry_selectSubscriber.subscriberStatus is 0 or Not IsDate(qry_selectSubscriber.subscriberDateProcessNext)>
			<cfset returnValue = QueryNew("error")>
			<cfset returnError = Variables.wslang_subscriptionProcess.notScheduled>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
				<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
				<cfinvokeargument Name="subscriptionStatus" Value="1">
				<cfinvokeargument Name="subscriptionCompleted" Value="0">
				<cfinvokeargument Name="subscriptionQuantityVaries" Value="1">
				<cfinvokeargument Name="subscriptionDateProcessNext" Value="#qry_selectSubscriber.subscriberDateProcessNext#">
			</cfinvoke>

			<cfif qry_selectSubscriptionList.RecordCount is 0>
				<cfset returnValue = qry_selectSubscriptionList>
			<cfelse>
				<!--- select custom prices for subscriptions --->
				<cfif REFind("[1-9]", ValueList(qry_selectSubscriptionList.priceID))>
					<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPrice" ReturnVariable="qry_selectPriceList">
						<cfinvokeargument Name="priceID" Value="#ValueList(qry_selectSubscriptionList.priceID)#">
					</cfinvoke>
				</cfif>

				<!--- for each subscription, determine list of applicable price stages for this billing period --->
				<cfinclude template="../../../control/c_subscription/c_subscriptionProcess/act_processSubscription_priceStage.cfm">

				<!--- Create new query since subscriptions may be listed in multiple rows if multiple price stages --->
				<!--- <cfset qry_selectSubscriptionProcessList = QueryNew("subscriberID,subscriptionID,subscriptionID_custom,subscriptionName,productID,priceID,priceID_custom,priceName,priceStageID,priceStageOrder,priceStageText,priceStageDescription,subscriptionPriceStageDateBegin,subscriptionPriceStageDateEnd,subscriptionQuantity,subscriptionQuantityVaries,subscriptionPriceUnit,subscriptionPriceNormal,subscriptionDiscount,subscriptionDateBegin,subscriptionDateEnd,subscriptionAppliedMaximum,subscriptionAppliedCount,subscriptionIntervalType,subscriptionInterval,subscriptionDateProcessNext,subscriptionDateProcessLast,subscriptionOrder,subscriptionProductID_custom,subscriptionProRate,subscriptionEndByDateOrAppliedMaximum,subscriptionContinuesAfterEnd,vendorID,productCode,productID_custom,productName,productPrice")> --->

				<!--- If Arguments.subscriptionProcessQuantityFinal is not "", determine which subscriptions should be returned --->
				<cfif Not ListFind("0,1", Arguments.subscriptionProcessQuantityFinal)>
					<cfset subscriptionID_list = ValueList(qry_selectSubscriptionList.subscriptionID)>
				<cfelse>
					<cfset subscriptionID_list = "">
					<!--- get current subscriberProcessID --->
					<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="selectSubscriberProcessList" ReturnVariable="qry_selectSubscriberProcess">
						<cfinvokeargument Name="subscriberID" Value="#qry_selectSubscriptionList.subscriberID[1]#">
						<cfinvokeargument Name="subscriberProcessCurrent" Value="1">
					</cfinvoke>

					<!--- if no subscriber process yet, all quantities are NOT final --->
					<cfif qry_selectSubscriberProcess.RecordCount is 0>
						<!--- return non-finalized quantities, which is all subscriptions --->
						<cfif Arguments.subscriptionProcessQuantityFinal is 0>
							<cfset subscriptionID_list = ValueList(qry_selectSubscriptionList.subscriptionID)>
						<!--- return finalized quantities, which is none --->
						<cfelse>
							<cfset subscriptionID_list = "">
						</cfif>
					<cfelse>
						<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="selectSubscriptionProcessList" ReturnVariable="qry_selectSubscriptionProcessList">
							<cfinvokeargument Name="subscriberProcessID" Value="#qry_selectSubscriberProcess.subscriberProcessID#">
							<cfinvokeargument Name="subscriptionProcessQuantityFinal" Value="#Arguments.subscriptionProcessQuantityFinal#">
						</cfinvoke>

						<!--- loop thru subscriptions and only add those in the list to be processed today --->
						<cfloop Query="qry_selectSubscriptionProcessList">
							<cfif ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), qry_selectSubscriptionProcessList.subscriptionID)>
								<cfset subscriptionID_list = ListAppend(subscriptionID_list, qry_selectSubscriptionProcessList.subscriptionID)>	
							</cfif>
						</cfloop>
					</cfif><!--- /if subscriber process does not yet exist for this billing period --->
				</cfif><!--- /if selecting only those subscriptions that are or are not finalized --->

				<cfloop Index="thisSubscriptionID" List="#subscriptionID_list#">
					<cfset thisSubscriptionRow = ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), thisSubscriptionID)>
					<cfloop Index="loopPriceStageID" List="#subscriptionID_priceStageIDList["subscription#thisSubscriptionID#"]#">
						<cfset temp = QueryAddRow(qry_selectSubscriptionProcessList, 1)>
						<!--- add existing necessary query fields to new query --->
						<cfloop Index="field" List="subscriberID,subscriptionID,subscriptionID_custom,subscriptionName,productID,priceID,subscriptionQuantity,subscriptionQuantityVaries,subscriptionPriceUnit,subscriptionPriceNormal,subscriptionDiscount,subscriptionDateBegin,subscriptionDateEnd,subscriptionAppliedMaximum,subscriptionAppliedCount,subscriptionIntervalType,subscriptionInterval,subscriptionDateProcessNext,subscriptionDateProcessLast,subscriptionOrder,subscriptionProductID_custom,subscriptionProRate,subscriptionEndByDateOrAppliedMaximum,subscriptionContinuesAfterEnd,vendorID,productCode,productID_custom,productName,productPrice">
							<cfset temp = QuerySetCell(qry_selectSubscriptionProcessList, field, Evaluate("qry_selectSubscriptionList.#field#[#thisSubscriptionRow#]"))>
						</cfloop>

						<!--- determine begin date of price stage --->
						<cfif qry_selectSubscriptionList.priceID[thisSubscriptionRow] is not 0>
							<cfset subscriptionPriceStageDateBegin = priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateBegin>
						<cfelseif IsDate(qry_selectSubscriptionList.subscriptionDateProcessLast[thisSubscriptionRow])>
							<cfset subscriptionPriceStageDateBegin = qry_selectSubscriptionList.subscriptionDateProcessLast[thisSubscriptionRow]>
						<cfelse>
							<cfset subscriptionPriceStageDateBegin = qry_selectSubscriptionList.subscriptionDateBegin[thisSubscriptionRow]>
						</cfif>

						<!--- determine end date of price stage --->
						<cfset subscriptionPriceStageDateEnd = "">
						<cfif qry_selectSubscriptionList.priceID[thisSubscriptionRow] is 0>
							 <cfif IsDate(qry_selectSubscriptionList.subscriptionDateEnd[thisSubscriptionRow]) and DateCompare(qry_selectSubscriptionList.subscriptionDateEnd[thisSubscriptionRow], qry_selectSubscriptionList.subscriptionDateProcessNext[thisSubscriptionRow]) is -1>
								<cfset subscriptionPriceStageDateEnd = qry_selectSubscriptionList.subscriptionDateEnd[thisSubscriptionRow]>
							<cfelse>
								<cfset subscriptionPriceStageDateEnd = qry_selectSubscriptionList.subscriptionDateProcessNext[thisSubscriptionRow]> 
							</cfif>
						<cfelseif Not IsDate(priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateEnd)>
							<cfset subscriptionPriceStageDateEnd = "">
						<cfelse>
							<cfset subscriptionPriceStageDateEnd = priceStageStruct["priceStage#loopPriceStageID#"].priceStageDateEnd>
						</cfif>

						<!--- add price stage begin/end dates to query--->
						<cfset temp = QuerySetCell(qry_selectSubscriptionProcessList, "subscriptionPriceStageDateBegin", subscriptionPriceStageDateBegin)>
						<cfset temp = QuerySetCell(qry_selectSubscriptionProcessList, "subscriptionPriceStageDateEnd", subscriptionPriceStageDateEnd)>

						<!--- add custom price fields to query --->
						<cfif qry_selectSubscriptionList.priceID[thisSubscriptionRow] is not 0>
							<cfset priceStageRow = priceStageStruct["priceStage#loopPriceStageID#"].priceStageRow>
							<cfloop Index="field" List="priceID_custom,priceName,priceStageID,priceStageOrder,priceStageText,priceStageDescription">
								<cfset temp = QuerySetCell(qry_selectSubscriptionProcessList, field, Evaluate("qry_selectPriceList.#field#[#priceStageRow#]"))>
							</cfloop>
						</cfif>
 					</cfloop><!--- /loop thru price stages for each subscription --->
 				</cfloop><!--- /loop thru subscriptions --->

				<cfset returnValue = qry_selectSubscriptionProcessList>
			</cfif><!--- /no variable-quantity subscriptions to be processed --->
		</cfif><!--- /if subscriber is scheduled to be processed --->
	</cfif><!--- /if valid subscriber --->
</cfif><!--- /if user has permission --->

<cfinclude template="../../webserviceSession/wsact_updateWebServiceSession.cfm">

