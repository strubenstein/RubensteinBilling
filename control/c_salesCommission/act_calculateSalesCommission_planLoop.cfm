<!--- select commission plan stages --->
<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommission" ReturnVariable="qry_selectCommissionList">
	<cfinvokeargument Name="commissionID" Value="#ValueList(qry_selectCommissionListForTarget.commissionID)#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommissionVolumeDiscount" ReturnVariable="qry_selectCommissionVolumeDiscount">
	<cfinvokeargument Name="commissionStageID" Value="#ValueList(qry_selectCommissionList.commissionStageID)#">
</cfinvoke>

<!--- Determine whether commission stage applies. --->
<!--- Invoice-based or period-based? --->
<!--- Invoice-level or line-item level --->
<!--- Calculation method: percent, dollar, volume --->
<!--- Volume: dollar or quantity, steps --->
<!--- Total commission? --->
<!--- Minimum or maximum sales commission --->

<cfloop Query="qry_selectCommissionList">
	<cfset temp = ArrayClear(salesCommissionArray)>
	<cfset salesCommissionArray[1] = StructNew()>
	<cfset temp = ArrayClear(invoiceLineItemArray)>

	<cfset useThisStage = False>
	<cfset salesCommissionID_existing = "">
	<cfset salesCommissionCalculatedAmount= 0>

	<cfset thisCommissionID = qry_selectCommissionList.commissionID>
	<cfset thisStageID = qry_selectCommissionList.commissionStageID>
	<cfset stageRow = qry_selectCommissionList.CurrentRow>

	<!--- lock this commission stage / salesperson combination for period-based commissions that may involve this invoice --->
	<cflock Timeout="10" Name="salesCommission#qry_selectCommissionList.commissionStageID#_#thisPrimaryTargetID#_#thisTargetID#">

	<cfswitch expression="#qry_selectCommissionList.commissionPeriodOrInvoiceBased#:#qry_selectCommissionList.commissionAppliesToInvoice#">
	<cfcase value="1:1"><!--- invoice-based, invoice-level --->
		<cfinclude template="act_calculateSalesCommission_invoiceInvoice.cfm">
	</cfcase>
	<cfcase value="1:0"><!--- invoice-based, line-item level --->
		<cfif commissionProductStruct["commission#qry_selectCommissionList.commissionID#"] is not "">
			<cfinclude template="act_calculateSalesCommission_invoiceLineItem.cfm">
		</cfif>
	</cfcase>
	<cfcase value="0:1"><!--- period-based, invoice-level --->
		<cfinclude template="act_calculateSalesCommission_periodInvoice.cfm">
	</cfcase>
	<cfcase value="0:0"><!--- period-based, line-item level --->
		<cfif commissionProductStruct["commission#qry_selectCommissionList.commissionID#"] is not "">
			<cfinclude template="act_calculateSalesCommission_periodLineItem.cfm">
		</cfif>
	</cfcase>
	</cfswitch>

	</cflock><!--- /close lock on this commission stage / salesperson combination --->
</cfloop><!--- /loop thru sales commission plans (and stages) for target --->
