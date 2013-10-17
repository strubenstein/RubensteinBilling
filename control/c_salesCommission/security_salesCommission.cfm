<cfif URL.salesCommissionID is not 0>
	<cfif Not Application.fn_IsIntegerPositive(URL.salesCommissionID)>
		<cflocation url="index.cfm?method=#URL.control#.listSalesCommissions&error_salesCommission=invalidSalesCommission" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="checkSalesCommissionPermission" ReturnVariable="isSalesCommissionPermission">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="salesCommissionID" Value="#URL.salesCommissionID#">
		</cfinvoke>

		<cfif isSalesCommissionPermission is False>
			<cflocation url="index.cfm?method=#URL.control#.listSalesCommissions&error_salesCommission=invalidSalesCommission" AddToken="No">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="selectSalesCommission" ReturnVariable="qry_selectSalesCommission">
				<cfinvokeargument Name="salesCommissionID" Value="#URL.salesCommissionID#">
			</cfinvoke>
		</cfif>
	</cfif>
<cfelseif Not ListFind("listSalesCommissions,insertSalesCommission", Variables.doAction)>
	<cflocation url="index.cfm?method=#URL.control#.listSalesCommissions&error_salesCommission=invalidSalesCommission" AddToken="No">
</cfif>
