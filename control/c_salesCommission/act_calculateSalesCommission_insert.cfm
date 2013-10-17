<cfset scArrayCount = ArrayLen(salesCommissionArray)>

<!--- check commission min/max --->
<cfif qry_selectCommissionList.commissionStageAmountMinimum is not 0 and salesCommissionCalculatedAmount lt qry_selectCommissionList.commissionStageAmountMinimum>
	<cfset salesCommissionArray[1].salesCommissionAmount = qry_selectCommissionList.commissionStageAmountMinimum>
	<cfset scArrayCount = 1><!--- if step method --->
<cfelseif qry_selectCommissionList.commissionStageAmountMaximum is not 0 and salesCommissionCalculatedAmount gt qry_selectCommissionList.commissionStageAmountMaximum>
	<cfset salesCommissionArray[1].salesCommissionAmount = qry_selectCommissionList.commissionStageAmountMaximum>
	<cfset scArrayCount = 1><!--- if step method --->
<cfelse>
	<cfloop Index="count" From="1" To="#scArrayCount#">
		<cfset salesCommissionArray[count].salesCommissionAmount = salesCommissionArray[count].salesCommissionCalculatedAmount>
	</cfloop>
</cfif>

<cfif scArrayCount lt ArrayLen(salesCommissionArray)>
	<cfset salesCommissionArray[1].commissionVolumeDiscountID = salesCommissionArray[ArrayLen(salesCommissionArray)].commissionVolumeDiscountID>
</cfif>

<cfloop Index="count" From="1" To="#scArrayCount#">
	<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="insertSalesCommission" ReturnVariable="newSalesCommissionID">
		<cfinvokeargument Name="commissionID" Value="#thisCommissionID#">
		<cfinvokeargument Name="primaryTargetID" Value="#thisPrimaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#thisTargetID#">
		<cfinvokeargument Name="userID_author" Value="#Session.userID#">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectInvoice.companyID_author#">
		<!--- multiply commission times percentage that salesperson receives --->
		<cfinvokeargument Name="salesCommissionAmount" Value="#Application.fn_setDecimalPrecision(salesCommissionArray[count].salesCommissionAmount * salesCommissionCustomerPercent, 2)#">
		<cfif qry_selectCommissionList.commissionPeriodOrInvoiceBased is 0><!--- period-based; finalize via scheduled script --->
			<cfinvokeargument Name="salesCommissionFinalized" Value="0">
			<cfinvokeargument Name="salesCommissionDateFinalized" Value="">
			<cfinvokeargument Name="salesCommissionDateBegin" Value="#periodIntervalDateBegin[qry_selectCommissionList.commissionPeriodIntervalType[stageRow]]#">
			<cfinvokeargument Name="salesCommissionDateEnd" Value="#periodIntervalDateEnd[qry_selectCommissionList.commissionPeriodIntervalType[stageRow]]#">
		<cfelse><!--- invoice-based; finalized now --->
			<cfinvokeargument Name="salesCommissionFinalized" Value="1">
			<cfinvokeargument Name="salesCommissionDateFinalized" Value="#CreateODBCDateTime(Now())#">
			<cfinvokeargument Name="salesCommissionDateBegin" Value="">
			<cfinvokeargument Name="salesCommissionDateEnd" Value="">
		</cfif>
		<cfinvokeargument Name="salesCommissionPaid" Value="">
		<cfinvokeargument Name="salesCommissionDatePaid" Value="">
		<cfinvokeargument Name="salesCommissionStatus" Value="1">
		<cfinvokeargument Name="salesCommissionManual" Value="0">
		<cfinvokeargument Name="salesCommissionBasisTotal" Value="#salesCommissionBasisTotal#">
		<cfinvokeargument Name="salesCommissionBasisQuantity" Value="#salesCommissionBasisQuantity#">
		<!--- multiply calculated commission times percentage that salesperson receives --->
		<cfinvokeargument Name="salesCommissionCalculatedAmount" Value="#Application.fn_setDecimalPrecision(salesCommissionArray[count].salesCommissionCalculatedAmount * salesCommissionCustomerPercent, 2)#">
		<cfinvokeargument Name="commissionStageID" Value="#thisStageID#">
		<cfinvokeargument Name="commissionVolumeDiscountID" Value="#salesCommissionArray[count].commissionVolumeDiscountID#">
	</cfinvoke>

	<cfset salesCommissionID_new = newSalesCommissionID>

	<!--- if changed commission plan products within period, old invoices still apply --->
	<cfif salesCommissionID_existing is not ""><!--- if "updating" existing period-based commission, copy related invoices to new calculation and delete old records --->
		<cfquery Name="qry_copySalesCommissionInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avSalesCommissionInvoice
			(
				salesCommissionID,
				invoiceID,
				invoiceLineItemID,
				commissionCustomerID,
				salesCommissionInvoiceAmount,
				salesCommissionInvoiceQuantity
			)
			SELECT 
				<cfqueryparam Value="#salesCommissionID_new#" cfsqltype="cf_sql_integer">,
				invoiceID,
				invoiceLineItemID,
				commissionCustomerID,
				salesCommissionInvoiceAmount,
				salesCommissionInvoiceQuantity
			FROM avSalesCommissionInvoice
			WHERE salesCommissionID = <cfqueryparam Value="#ListFirst(salesCommissionID_existing)#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>

	<!--- insert for each line item --->
	<cfloop Index="count2" From="1" To="#ArrayLen(invoiceLineItemArray)#">
		<cfinvoke Component="#Application.billingMapping#data.SalesCommissionInvoice" Method="insertSalesCommissionInvoice" ReturnVariable="isSalesCommissionInvoiceInserted">
			<cfinvokeargument Name="salesCommissionID" Value="#salesCommissionID_new#">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
			<cfinvokeargument Name="invoiceLineItemID" Value="#invoiceLineItemArray[count2].invoiceLineItemID#">
			<cfinvokeargument Name="salesCommissionInvoiceAmount" Value="#invoiceLineItemArray[count2].salesCommissionInvoiceAmount#">
			<cfinvokeargument Name="salesCommissionInvoiceQuantity" Value="#invoiceLineItemArray[count2].salesCommissionInvoiceQuantity#">
			<cfinvokeargument Name="commissionCustomerID" Value="#commissionCustomerID#">
		</cfinvoke>
	</cfloop><!--- /loop thru line items for this commission plan calculation --->

	<!--- add to list of commission plans that have been applied --->
	<cfif Not ListFind(commissionID_appliedList, thisCommissionID)>
		<cfset commissionID_appliedList = ListAppend(commissionID_appliedList, thisCommissionID)>
	</cfif>
</cfloop><!--- /loop thru sales commission line items (multiple if step method) --->

<!--- if "updating" existing period-based sales commission, delete old records --->
<cfif salesCommissionID_existing is not "">
	<cfquery Name="qry_deleteSalesCommission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avSalesCommission WHERE salesCommissionID IN (<cfqueryparam Value="#salesCommissionID_existing#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfquery Name="qry_deleteSalesCommissionInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avSalesCommissionInvoice WHERE salesCommissionID IN (<cfqueryparam Value="#salesCommissionID_existing#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>
</cfif>
