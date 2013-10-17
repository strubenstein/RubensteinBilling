<!--- check whether commission stage applies --->
<!--- if only one stage OR no subscriber, use Stage 1 --->
<cfif qry_selectCommissionList.commissionHasMultipleStages is 0 or qry_selectInvoice.subscriberID is 0>
	<cfif qry_selectCommissionList.commissionStageOrder is 1>
		<cfset useThisStage = True>
	</cfif>
<cfelse>
	<cfif qry_selectCommissionList.commissionStageOrder is 1>
		<cfset stageBegin = qry_selectSubscriber.subscriberDateCreated>
	<cfelse>
		<cfset stageBegin = DateAdd("d", 1, stageEnd)>
	</cfif>

	<cfset stageEnd = DateAdd(qry_selectCommissionList.commissionStageIntervalType, qry_selectCommissionList.commissionStageInterval, stageBegin)>
	<cfset stageEndMidnight = CreateDateTime(Year(stageEnd), Month(stageEnd), Day(stageEnd), 23, 59, 00)>

	<cfif effectiveCommissionDate gte stageBegin and effectiveCommissionDate lte stageEndMidnight>
		<cfset useThisStage = True>
	</cfif>
</cfif>

<cfif useThisStage is True>
	<cfset salesCommissionBasisTotal = 0>
	<cfset salesCommissionBasisQuantity = 0>

	<cfif qry_selectCommissionList.commissionAppliesToExistingProducts is 1>
		<cfset salesCommissionBasisTotal = salesCommissionBasisTotal + invoiceTotalExistingProducts>
		<cfset salesCommissionBasisQuantity = salesCommissionBasisQuantity + invoiceQuantityExistingProducts>
	</cfif>

	<cfif qry_selectCommissionList.commissionAppliesToCustomProducts is 1>
		<cfset salesCommissionBasisTotal = salesCommissionBasisTotal + invoiceTotalCustomProducts>
		<cfset salesCommissionBasisQuantity = salesCommissionBasisQuantity + invoiceQuantityCustomProducts>
	</cfif>

	<cfset invoiceLineItemArray[1] = StructNew()>
	<cfset invoiceLineItemArray[1].invoiceLineItemID = 0>
	<cfset invoiceLineItemArray[1].salesCommissionInvoiceAmount = salesCommissionBasisTotal>
	<cfset invoiceLineItemArray[1].salesCommissionInvoiceQuantity = salesCommissionBasisQuantity>

	<cfinclude template="act_calculateSalesCommission_planCalc.cfm">
	<cfinclude template="act_calculateSalesCommission_insert.cfm">
</cfif><!--- /if commission stage applies --->
