<cfif Not Application.fn_IsIntegerPositive(URL.productID)>
	<cflocation url="index.cfm?method=commission.listCommissionProducts&commissionID=#URL.commissionID#&error_commission=invalidProduct" AddToken="No">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Product" Method="checkProductPermission" ReturnVariable="isProductPermission">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfif isProductPermission is False>
		<cflocation url="index.cfm?method=commission.listCommissionProducts&commissionID=#URL.commissionID#&error_commission=invalidProduct" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CommissionProduct" Method="selectCommissionProduct" ReturnVariable="qry_selectCommissionProduct">
			<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="commissionProductStatus" Value="1">
		</cfinvoke>

		<cfif qry_selectCommissionProduct.RecordCount is 0>
			<cflocation url="index.cfm?method=commission.listCommissionProducts&commissionID=#URL.commissionID#&error_commission=productDoesNotApply" AddToken="No">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.CommissionProduct" Method="updateCommissionProduct" ReturnVariable="isCommissionProductUpdated">
				<cfinvokeargument Name="commissionProductID" Value="#qry_selectCommissionProduct.commissionProductID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="commissionProductStatus" Value="0">
			</cfinvoke>

			<cflocation url="index.cfm?method=commission.listCommissionProducts&commissionID=#URL.commissionID#&confirm_commission=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>
