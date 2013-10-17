<!--- 
<cfif URL.categoryID gt 0 and URL.productID gt 0>
	<cfset URL.error_commission = "bothProductAndCategory">
	<cfset URL.categoryID = 0>
	<cfset URL.productID = 0>
	<cfset Variables.doAction = "listCommissions">
<cfelseif URL.categoryID gt 0 and URL.control is not "category" and URL.action is not "insertCommissionCategory">
	<cfset URL.error_commission = "controlCategory">
	<cfset URL.categoryID = 0>
	<cfset Variables.doAction = "listCommissions">
<cfelseif URL.productID gt 0 and URL.control is not "product" and Not ListFind("insertCommissionProduct,updateCommissionProduct", URL.action)>
	<cfset URL.error_commission = "controlProduct">
	<cfset URL.productID = 0>
	<cfset Variables.doAction = "listCommissions">
</cfif>
--->

<cfif URL.commissionID is not 0>
	<cfif Not Application.fn_IsIntegerPositive(URL.commissionID)>
		<cflocation url="index.cfm?method=#URL.control#.listCommissions&error_commission=invalidCommission" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Commission" Method="checkCommissionPermission" ReturnVariable="isCommissionPermission">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
			<!--- 
			<cfif Variables.doAction is not "listCommissions">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
			</cfif>
			--->
		</cfinvoke>

		<cfif isCommissionPermission is False>
			<cflocation url="index.cfm?method=#URL.control#.listCommissions&error_commission=invalidCommission" AddToken="No">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommission" ReturnVariable="qry_selectCommission">
				<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
			</cfinvoke>
		</cfif>
	</cfif>
<cfelseif Not ListFind("listCommissions,insertCommission,insertCommissionCustomer,viewCommissionCustomer,updateCommissionCustomer,updateCommissionCustomerStatus", Variables.doAction)>
	<cflocation url="index.cfm?method=#URL.control#.listCommissions&error_commission=invalidCommission" AddToken="No">
</cfif>
