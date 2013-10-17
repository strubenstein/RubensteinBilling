<cfif URL.productID is not 0>
	<cfif Not Application.fn_IsIntegerPositive(URL.productID)>
		<cflocation url="index.cfm?method=commission.#Variables.doAction#&commissionID=#URL.commissionID#&error_commission=invalidProduct" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="checkProductPermission" ReturnVariable="isProductPermission">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		</cfinvoke>

		<cfif isProductPermission is False>
			<cflocation url="index.cfm?method=commission.#Variables.doAction#&commissionID=#URL.commissionID#&error_commission=invalidProduct" AddToken="No">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.CommissionProduct" Method="selectCommissionProduct" ReturnVariable="qry_selectCommissionProduct">
				<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="commissionProductStatus" Value="1">
			</cfinvoke>

			<cfif qry_selectCommissionProduct.RecordCount is not 0>
				<cflocation url="index.cfm?method=commission.#Variables.doAction#&commissionID=#URL.commissionID#&error_commission=productAlreadyApplies" AddToken="No">
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.CommissionProduct" Method="insertCommissionProduct" ReturnVariable="isCommissionProductInserted">
					<cfinvokeargument Name="productID" Value="#URL.productID#">
					<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="commissionProductStatus" Value="1">
					<cfif IsDefined("URL.includeProductChildren") and ListFind("0,1", URL.includeProductChildren)>
						<cfinvokeargument Name="commissionProductChildren" Value="#URL.includeProductChildren#">
					</cfif>
				</cfinvoke>

				<cflocation url="index.cfm?method=commission.#Variables.doAction#&commissionID=#URL.commissionID#&confirm_commission=#Variables.doAction#" AddToken="No">
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfset URL.categoryID = "">
<cfset Variables.doControl = "product">
<cfset Variables.commissionID_not = URL.commissionID>
<cfset Variables.doAction = "listProducts">
<cfinclude template="../control.cfm">
