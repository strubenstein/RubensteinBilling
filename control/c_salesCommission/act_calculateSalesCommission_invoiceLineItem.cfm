<cfquery Name="qry_selectInvoiceLineItemListForTarget" DBType="query">
	SELECT *
	FROM qry_selectInvoiceLineItemList
	WHERE productID IN (#commissionProductStruct["commission#qry_selectCommissionList.commissionID#"]#)
	ORDER BY invoiceLineItemOrder
</cfquery>

<cfloop Query="qry_selectInvoiceLineItemListForTarget">
	<cfset useThisStage = False>

	<!--- check whether commission stage applies --->
	<!--- if only one stage OR no subscriber, use Stage 1 --->
	<cfif qry_selectCommissionList.commissionHasMultipleStages[stageRow] is 0 or qry_selectInvoiceLineItemListForTarget.subscriptionID is 0>
		<cfif qry_selectCommissionList.commissionStageOrder[stageRow] is 1>
			<cfset useThisStage = True>
		</cfif>
	<cfelse>
		<cfif qry_selectCommissionList.commissionStageOrder[stageRow] gt 1>
			<cfset stageBegin = DateAdd("d", 1, stageEnd)>
		<cfelseif Not StructKeyExists(subscriptionRowStruct, "subscription#qry_selectInvoiceLineItemListForTarget.subscriptionID#")>
			<cfset subscriptionRow = 0>
			<cfset stageBegin = qry_selectSubscriber.subscriberDateCreated>
		<cfelse>
			<cfset subscriptionRow = subscriptionRowStruct["subscription#qry_selectInvoiceLineItemListForTarget.subscriptionID#"]>
			<cfset stageBegin = qry_selectSubscriptionList.subscriptionDateBegin[subscriptionRow]>
		</cfif>

		<cfif qry_selectCommissionList.commissionStageIntervalType[stageRow] is "">
			<cfset stageEnd = Now()>
		<cfelse>
			<cfset stageEnd = DateAdd(qry_selectCommissionList.commissionStageIntervalType[stageRow], qry_selectCommissionList.commissionStageInterval[stageRow], stageBegin)>
		</cfif>
		<cfset stageEndMidnight = CreateDateTime(Year(stageEnd), Month(stageEnd), Day(stageEnd), 23, 59, 00)>

		<cfif effectiveCommissionDate gte stageBegin and effectiveCommissionDate lte stageEndMidnight>
			<cfset useThisStage = True>
		</cfif>
	</cfif>

	<cfif useThisStage is True>
		<cfif qry_selectInvoiceLineItemListForTarget.CurrentRow is not 1
				and qry_selectInvoiceLineItemListForTarget.productID is qry_selectInvoiceLineItemListForTarget.productID[qry_selectInvoiceLineItemListForTarget.CurrentRow - 1]
				and qry_selectInvoiceLineItemListForTarget.subscriptionID is qry_selectInvoiceLineItemListForTarget.subscriptionID[qry_selectInvoiceLineItemListForTarget.CurrentRow - 1]
				and qry_selectInvoiceLineItemListForTarget.priceID is qry_selectInvoiceLineItemListForTarget.priceID[qry_selectInvoiceLineItemListForTarget.CurrentRow - 1]
				and DateDiff("s", qry_selectInvoiceLineItemListForTarget.invoiceLineItemDateCreated[qry_selectInvoiceLineItemListForTarget.CurrentRow - 1], qry_selectInvoiceLineItemListForTarget.invoiceLineItemDateCreated) lt 5>
				<!--- if custom price, how to separate line items, especially if step pricing followed by same product --->
			<cfset salesCommissionBasisTotal = salesCommissionBasisTotal + qry_selectInvoiceLineItemListForTarget.invoiceLineItemSubTotal>
			<cfset salesCommissionBasisQuantity = salesCommissionBasisQuantity + qry_selectInvoiceLineItemListForTarget.invoiceLineItemQuantity>
		<cfelse>
			<cfset salesCommissionBasisTotal = qry_selectInvoiceLineItemListForTarget.invoiceLineItemSubTotal>
			<cfset salesCommissionBasisQuantity = qry_selectInvoiceLineItemListForTarget.invoiceLineItemQuantity>
		</cfif>

		<cfset temp = StructClear(tempInvoiceLineItemStruct)>
		<cfset tempInvoiceLineItemStruct.invoiceLineItemID = qry_selectInvoiceLineItemListForTarget.invoiceLineItemID>
		<cfset tempInvoiceLineItemStruct.salesCommissionInvoiceAmount = qry_selectInvoiceLineItemListForTarget.invoiceLineItemSubTotal>
		<cfset tempInvoiceLineItemStruct.salesCommissionInvoiceQuantity = qry_selectInvoiceLineItemListForTarget.invoiceLineItemQuantity>
		<cfset temp = ArrayAppend(invoiceLineItemArray, tempInvoiceLineItemStruct)>

		<cfif qry_selectInvoiceLineItemListForTarget.CurrentRow is qry_selectInvoiceLineItemListForTarget.RecordCount
				or qry_selectInvoiceLineItemListForTarget.productID is not qry_selectInvoiceLineItemListForTarget.productID[qry_selectInvoiceLineItemListForTarget.CurrentRow + 1]
				or qry_selectInvoiceLineItemListForTarget.subscriptionID is not qry_selectInvoiceLineItemListForTarget.subscriptionID[qry_selectInvoiceLineItemListForTarget.CurrentRow + 1]
				or qry_selectInvoiceLineItemListForTarget.priceID is not qry_selectInvoiceLineItemListForTarget.priceID[qry_selectInvoiceLineItemListForTarget.CurrentRow + 1]
				or DateDiff("s", qry_selectInvoiceLineItemListForTarget.invoiceLineItemDateCreated[qry_selectInvoiceLineItemListForTarget.CurrentRow - 1], qry_selectInvoiceLineItemListForTarget.invoiceLineItemDateCreated) gt 5>
			<cfinclude template="act_calculateSalesCommission_planCalc.cfm">
			<cfinclude template="act_calculateSalesCommission_insert.cfm">

			<cfset salesCommissionCalculatedAmount= 0>
			<cfset temp = ArrayClear(invoiceLineItemArray)>
			<cfset temp = ArrayClear(salesCommissionArray)>
			<cfset salesCommissionArray[1] = StructNew()>
		</cfif><!--- if processing this line item or waiting because of step pricing creating multiple line items --->
	</cfif><!--- if this commission stage applies to this line item --->
</cfloop><!--- /loop thru line items for products for this commission plan --->

