<!--- determine which productID's have their own commissions. calculate invoice total for commission purposes. --->
<cfset productsWithCommissionPlan = "">

<cfloop Query="qry_selectCommissionListForTarget">
	<!--- set initial value of list of products for each commission to blank --->
	<cfif CurrentRow is 1 or qry_selectCommissionListForTarget.commissionID is not qry_selectCommissionListForTarget.commissionID[CurrentRow - 1]>
		<cfset commissionProductStruct["commission#qry_selectCommissionListForTarget.commissionID#"] = "">
	</cfif>

	<!---- IF commission plan is line-item level (not invoice-level) and is a different product/commission or category/commission than the previous row --->
	<cfif qry_selectCommissionListForTarget.commissionAppliesToInvoice is 0
			and (CurrentRow is 1
				or qry_selectCommissionListForTarget.commissionID is not qry_selectCommissionListForTarget.commissionID[CurrentRow - 1]
				or qry_selectCommissionListForTarget.productID is not qry_selectCommissionListForTarget.productID[CurrentRow - 1]
				or qry_selectCommissionListForTarget.categoryID is not qry_selectCommissionListForTarget.categoryID[CurrentRow - 1])>
		<!--- if commission applies to a product --->
		<cfif Application.fn_IsIntegerPositive(qry_selectCommissionListForTarget.productID)>
			<cfset productsWithCommissionPlan = ListAppend(productsWithCommissionPlan, qry_selectCommissionListForTarget.productID)>
			<cfset commissionProductStruct["commission#qry_selectCommissionListForTarget.commissionID#"] = ListAppend(commissionProductStruct["commission#qry_selectCommissionListForTarget.commissionID#"], qry_selectCommissionListForTarget.productID)>

			<!--- if applies to child products, select child products from invoice --->
			<cfif qry_selectCommissionListForTarget.commissionProductChildren is 1>
				<cfquery Name="qryman_selectCount" DBType="query">
					SELECT DISTINCT(productID)
					FROM qry_selectInvoiceLineItemList
					WHERE productID_parent = #qry_selectCommissionListForTarget.productID#
						<cfif thisPrimaryTargetKey is "vendorID">
							AND vendorID = #thisTargetID#
						</cfif>
				</cfquery>

				<cfif qryman_selectCount.RecordCount is not 0>
					<cfset commissionProductStruct["commission#qry_selectCommissionListForTarget.commissionID#"] = ListAppend(commissionProductStruct["commission#qry_selectCommissionListForTarget.commissionID#"], ValueList(qryman_selectCount.productID))>
					<cfset productsWithCommissionPlan = ListAppend(productsWithCommissionPlan, ValueList(qryman_selectCount.productID))>
				</cfif>
			</cfif><!--- /commission plan applies to child products --->
		</cfif><!--- /commission plan applies to product --->

		<cfif Application.fn_IsIntegerPositive(qry_selectCommissionListForTarget.categoryID)>
			<!--- if categories or parent categories, select matching products --->
			<cfquery Name="qryman_selectCount" DBType="query">
				SELECT DISTINCT(productID)
				FROM qry_selectProductCategoryManual
				WHERE categoryID = #qry_selectCommissionListForTarget.categoryID#
					<cfif qry_selectCommissionListForTarget.commissionCategoryChildren is 0>
						AND isCategoryParent = 0
					</cfif>
					<cfif thisPrimaryTargetKey is "vendorID">
						AND productID IN (#vendorProductList#)
					</cfif>
			</cfquery>

			<cfif qryman_selectCount.RecordCount is not 0>
				<cfset commissionProductStruct["commission#qry_selectCommissionListForTarget.commissionID#"] = ListAppend(commissionProductStruct["commission#qry_selectCommissionListForTarget.commissionID#"], ValueList(qryman_selectCount.productID))>
				<cfset productsWithCommissionPlan = ListAppend(productsWithCommissionPlan, ValueList(qryman_selectCount.productID))>
			</cfif>
		</cfif><!--- /commission plan applies to category --->
	</cfif><!---- /commission plan is line-item level (not invoice-level) --->
</cfloop><!--- /loop thru commission plans --->

<!--- select sum of line items from invoice without line-item commissions --->
<cfquery Name="qryman_selectCount" DBType="query">
	SELECT SUM(invoiceLineItemSubTotal) AS sumInvoiceLineItemSubTotal,
		SUM(invoiceLineItemQuantity) AS sumInvoiceLineItemQuantity
	FROM qry_selectInvoiceLineItemList
	WHERE productID <> 0
		<cfif productsWithCommissionPlan is not "">
			AND productID NOT IN (#productsWithCommissionPlan#)
		</cfif>
		<cfif thisPrimaryTargetKey is "vendorID">
			AND vendorID = #thisTargetID#
		</cfif>
</cfquery>

<cfif Not IsNumeric(qryman_selectCount.sumInvoiceLineItemQuantity)>
	<cfset invoiceQuantityExistingProducts = 0>
<cfelse>
	<cfset invoiceQuantityExistingProducts = qryman_selectCount.sumInvoiceLineItemQuantity>
</cfif>

<cfif thisPrimaryTargetKey is "vendorID">
	<cfset invoiceTotalExistingProducts = qryman_selectCount.sumInvoiceLineItemSubTotal>
<cfelseif Not IsNumeric(qryman_selectCount.sumInvoiceLineItemSubTotal)>
	<cfset invoiceTotalExistingProducts = 0>
<cfelse><!--- if not vendor, subtract payment credits from total --->
	<cfset invoiceTotalExistingProducts = Max(0, qryman_selectCount.sumInvoiceLineItemSubTotal - qry_selectInvoice.invoiceTotalPaymentCredit)>
</cfif>

<cfif Not IsNumeric(invoiceTotalExistingProducts)>
	<cfset invoiceTotalExistingProducts = 0>
</cfif>