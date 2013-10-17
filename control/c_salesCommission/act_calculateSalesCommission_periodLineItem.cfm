<!--- check whether commission stage applies --->
<!--- if only one stage OR no subscriber, use Stage 1 --->
<cfif qry_selectCommissionList.commissionHasMultipleStages is 0 or qry_selectInvoice.subscriberID is 0>
	<cfif qry_selectCommissionList.commissionStageOrder is 1>
		<cfset useThisStage = True>
	</cfif>
<cfelse>
	<cfif qry_selectCommissionList.commissionStageOrder is 1>
		<cfset stageBegin = salespersonDateCreated>
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

	<cfquery Name="qry_selectInvoiceLineItemListForTarget" DBType="query">
		SELECT *
		FROM qry_selectInvoiceLineItemList
		WHERE productID IN (#commissionProductStruct["commission#qry_selectCommissionList.commissionID#"]#)
		ORDER BY invoiceLineItemOrder
	</cfquery>

	<cfloop Query="qry_selectInvoiceLineItemListForTarget">
		<cfset salesCommissionBasisTotal = salesCommissionBasisTotal + qry_selectInvoiceLineItemListForTarget.invoiceLineItemSubTotal>
		<cfset salesCommissionBasisQuantity = salesCommissionBasisQuantity + qry_selectInvoiceLineItemListForTarget.invoiceLineItemQuantity>

		<cfset temp = StructClear(tempInvoiceLineItemStruct)>
		<cfset tempInvoiceLineItemStruct.invoiceLineItemID = qry_selectInvoiceLineItemListForTarget.invoiceLineItemID>
		<cfset tempInvoiceLineItemStruct.salesCommissionInvoiceAmount = qry_selectInvoiceLineItemListForTarget.invoiceLineItemSubTotal>
		<cfset tempInvoiceLineItemStruct.salesCommissionInvoiceQuantity = qry_selectInvoiceLineItemListForTarget.invoiceLineItemQuantity>
	</cfloop>

	<!--- Get sum of all invoices in period and current salesCommissionID for salesperson/commissionID/stage/time period --->
	<cfquery Name="qry_checkSalesCommissionForPeriod" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT salesCommissionID
		FROM avSalesCommission
		WHERE salesCommissionFinalized = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND commissionStageID = <cfqueryparam Value="#qry_selectCommissionList.commissionStageID#" cfsqltype="cf_sql_integer">
			AND primaryTargetID = <cfqueryparam Value="#thisPrimaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#thisTargetID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkSalesCommissionForPeriod.RecordCount is not 0>
		<cfset salesCommissionID_existing = ValueList(qry_checkSalesCommissionForPeriod.salesCommissionID)>
		<cfquery Name="qry_selectSalesCommissionInvoiceSum" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT SUM(salesCommissionInvoiceAmount) AS sumSalesCommissionInvoiceAmount,
				SUM(salesCommissionInvoiceQuantity) AS sumSalesCommissionInvoiceQuantity
			FROM avSalesCommissionInvoice
			WHERE salesCommissionID IN (<cfqueryparam Value="#salesCommissionID_existing#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfif IsNumeric(qry_selectSalesCommissionInvoiceSum.sumSalesCommissionInvoiceAmount)>
			<cfset salesCommissionBasisTotal = salesCommissionBasisTotal + qry_selectSalesCommissionInvoiceSum.sumSalesCommissionInvoiceAmount>
			<cfset salesCommissionBasisQuantity = salesCommissionBasisQuantity + qry_selectSalesCommissionInvoiceSum.sumSalesCommissionInvoiceQuantity>
		</cfif>
	</cfif>

	<cfinclude template="act_calculateSalesCommission_planCalc.cfm">
	<cfinclude template="act_calculateSalesCommission_insert.cfm">
</cfif><!--- if this commission stage applies to this line item --->

