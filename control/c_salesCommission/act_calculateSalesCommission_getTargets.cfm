<!--- generate lists of productIDs --->
<cfquery Name="qry_selectInvoiceLineItemList_products" DBType="query">
	SELECT DISTINCT(productID)
	FROM qry_selectInvoiceLineItemList
	WHERE productID <> 0
</cfquery>
<cfset productList = ValueList(qry_selectInvoiceLineItemList_products.productID)>

<!--- generate lists of productID_parent's --->
<cfquery Name="qry_selectInvoiceLineItemList_productParents" DBType="query">
	SELECT DISTINCT(productID_parent)
	FROM qry_selectInvoiceLineItemList
	WHERE productID_parent <> 0
		AND productID_parent IS NOT NULL
</cfquery>
<cfset productParentList = ValueList(qry_selectInvoiceLineItemList_productParents.productID_parent)>

<!--- generate lists of vendors --->
<cfquery Name="qry_selectInvoiceLineItemList_vendors" DBType="query">
	SELECT DISTINCT(vendorID)
	FROM qry_selectInvoiceLineItemList
	WHERE vendorID <> 0
		AND vendorID IS NOT NULL
</cfquery>

<cfset vendorList = ValueList(qry_selectInvoiceLineItemList_vendors.vendorID)>
<cfif vendorList is not "">
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendorList">
		<cfinvokeargument Name="vendorID" Value="#vendorList#">
	</cfinvoke>
</cfif>

<!--- select total and quantity of custom products --->
<cfquery Name="qry_selectInvoiceLineItemList_custom" DBType="query">
	SELECT SUM(invoiceLineItemSubTotal) AS sumInvoiceLineItemSubTotal,
		SUM(invoiceLineItemQuantity) AS sumInvoiceLineItemQuantity
	FROM qry_selectInvoiceLineItemList
	WHERE productID = 0
</cfquery>

<cfif Not IsNumeric(qry_selectInvoiceLineItemList_custom.sumInvoiceLineItemSubTotal)>
	<cfset invoiceTotalCustomProducts = 0>
	<cfset invoiceQuantityCustomProducts = 0>
<cfelse>
	<cfset invoiceTotalCustomProducts = qry_selectInvoiceLineItemList_custom.sumInvoiceLineItemSubTotal>
	<cfset invoiceQuantityCustomProducts = qry_selectInvoiceLineItemList_custom.sumInvoiceLineItemQuantity>
</cfif>

<!--- get list of categories (and parent categories) of line item products --->
<cfif productList is not "">
	<!--- initialize structure that stores list of categories (including parent categories) for each product --->
	<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="selectProductCategory" ReturnVariable="qry_selectProductCategory">
		<cfinvokeargument Name="productID" Value="#productList#">
		<cfinvokeargument Name="productCategoryStatus" Value="1">
		<cfinvokeargument Name="productCategoryDate" Value="#effectiveCommissionDate#">
	</cfinvoke>

	<!--- Create new query that list product in category(s) and parent category(s) --->
	<cfset qry_selectProductCategoryManual = QueryNew("productID,categoryID,isCategoryParent")>

	<cfloop Query="qry_selectProductCategory">
		<cfset temp = QueryAddRow(qry_selectProductCategoryManual)>
		<cfset temp = QuerySetCell(qry_selectProductCategoryManual, "productID", qry_selectProductCategory.productID)>
		<cfset temp = QuerySetCell(qry_selectProductCategoryManual, "categoryID", qry_selectProductCategory.categoryID)>
		<cfset temp = QuerySetCell(qry_selectProductCategoryManual, "isCategoryParent", 0)>

		<cfif Not ListFind(categoryList, qry_selectProductCategory.categoryID)>
			<cfset categoryList = ListAppend(categoryList, qry_selectProductCategory.categoryID)>
		</cfif>

		<cfset prodID = qry_selectProductCategory.productID>
		<cfloop Index="catID" List="#qry_selectProductCategory.categoryID_parentList#">
			<cfset temp = QueryAddRow(qry_selectProductCategoryManual)>
			<cfset temp = QuerySetCell(qry_selectProductCategoryManual, "productID", prodID)>
			<cfset temp = QuerySetCell(qry_selectProductCategoryManual, "categoryID", catID)>
			<cfset temp = QuerySetCell(qry_selectProductCategoryManual, "isCategoryParent", 1)>

			<cfif Not ListFind(categoryParentList, catID)>
				<cfset categoryParentList = ListAppend(categoryParentList, catID)>
			</cfif>
		</cfloop>
	</cfloop>
</cfif>

<!--- add company affiliate and cobrand to target list --->
<cfif qry_selectCompany.affiliateID is not 0>
	<cfset commissionTargetList = ListAppend(commissionTargetList, Application.fn_GetPrimaryTargetID("affiliateID") & "_" & qry_selectCompany.affiliateID)>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
		<cfinvokeargument Name="affiliateID" Value="#qry_selectCompany.affiliateID#">
	</cfinvoke>
</cfif>

<cfif qry_selectCompany.cobrandID is not 0>
	<cfset commissionTargetList = ListAppend(commissionTargetList, Application.fn_GetPrimaryTargetID("cobrandID") & "_" & qry_selectCompany.cobrandID)>
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
		<cfinvokeargument Name="cobrandID" Value="#qry_selectCompany.cobrandID#">
	</cfinvoke>
</cfif>

<!--- select customer salesperson(s) --->
<cfinvoke Component="#Application.billingMapping#data.CommissionCustomer" Method="selectCommissionCustomerList" ReturnVariable="qry_selectCommissionCustomerList">
	<cfinvokeargument Name="companyID_author" Value="#qry_selectInvoice.companyID_author#">
	<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
	<cfinvokeargument Name="commissionCustomerStatus" Value="1">
	<cfif qry_selectInvoice.subscriberID is not 0>
		<cfinvokeargument Name="subscriberID" Value="#qry_selectInvoice.subscriberID#">
	<cfelseif qry_selectInvoice.userID is not 0>
		<cfinvokeargument Name="userID" Value="#qry_selectInvoice.userID#">
	</cfif>
	<cfinvokeargument Name="commissionCustomerDate" Value="#effectiveCommissionDate#">
</cfinvoke>

<cfloop Query="qry_selectCommissionCustomerList">
	<!--- store salesperson row for later data retrieval --->
	<cfset commissionCustomerStruct["#qry_selectCommissionCustomerList.primaryTargetID#_#qry_selectCommissionCustomerList.targetID#"] = qry_selectCommissionCustomerList.CurrentRow>
	<!--- add salesperson to list; only add once in case returned in multiple rows --->
	<cfif Not ListFind(commissionTargetList, qry_selectCommissionCustomerList.primaryTargetID & "_" & qry_selectCommissionCustomerList.targetID)>
		<cfset commissionTargetList = ListAppend(commissionTargetList, qry_selectCommissionCustomerList.primaryTargetID & "_" & qry_selectCommissionCustomerList.targetID)>
	</cfif>
</cfloop>

<!--- generate date ranges for various periods --->
<cfset calcDate = DateAdd("d", 1 - DayOfWeek(Now()), Now())>
<cfset periodIntervalDateBegin.ww = CreateDateTime(Year(calcDate), Month(calcDate), Day(calcDate), 00, 00, 00)>
<cfset calcDate = DateAdd("d", 6, periodIntervalDateBegin.ww)>
<cfset periodIntervalDateEnd.ww = CreateDateTime(Year(calcDate), Month(calcDate), Day(calcDate), 23, 59, 00)>

<cfset periodIntervalDateBegin.m = CreateDateTime(Year(Now()), Month(Now()), 01, 00, 00, 00)>
<cfset periodIntervalDateEnd.m = CreateDateTime(Year(Now()), Month(Now()), DaysInMonth(Now()), 23, 59, 00)>

<cfset periodIntervalDateBegin.q = CreateDateTime(Year(Now()), 1 + (3 * DecrementValue(Quarter(Now()))), 01, 00, 00, 00)>
<cfset calcDate = DateAdd("m", 2, periodIntervalDateBegin.q)>
<cfset periodIntervalDateEnd.q = CreateDateTime(Year(Now()), Month(calcDate), DaysInMonth(calcDate), 23, 59, 00)>

<cfset periodIntervalDateBegin.yyyy = CreateDateTime(Year(Now()), 01, 01, 00, 00, 00)>
<cfset periodIntervalDateEnd.yyyy = CreateDateTime(Year(Now()), 12, 31, 23, 59, 00)>

