<cfcomponent DisplayName="SalesCommissionCalculate" Hint="Manages calculating sales commissions">

<cffunction Name="calculateSalesCommission" Access="public" Output="No" ReturnType="boolean" Hint="Calculates sales commissions due on a particular invoice, subscriber, line item or subscription.">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">

	<cfset var returnValue = False>
	<!--- <cfset var qry_selectInvoice = QueryNew("blank")> --->
	<cfset var qry_checkSalesCommissionForInvoice = QueryNew("blank")>

	<!--- control_calculateSalesCommission.cfm --->
	<!--- stores list of products that each commission plan may be applied to --->
	<cfset var commissionProductStruct = StructNew()>
	<cfset var commissionID_appliedList = "">
	<cfset var salesCommissionArray = ArrayNew(1)>
	<cfset var invoiceLineItemArray = ArrayNew(1)>
	<cfset var tempInvoiceLineItemStruct = StructNew()>

	<!--- act_calculateSalesCommission_getInvoice.cfm --->
	<!--- <cfset var qry_selectInvoiceLineItemList = QueryNew("blank")> --->
	<!--- <cfset var qry_selectCompany = QueryNew("blank")> --->
	<!--- <cfset var qry_selectSubscriber = QueryNew("blank")> --->
	<cfset var qry_selectSubscriptionListFromInvoice = QueryNew("blank")>
	<cfset var subscriptionRowStruct = StructNew()>
	<!--- <cfset var qry_selectSubscriptionList = QueryNew("blank")> --->
	<cfset var effectiveCommissionDate = Now()>

	<!--- act_calculateSalesCommission_getTargets.cfm --->
	<cfset var productList = "">			<!--- list of unique non-zero productID's in invoice --->
	<cfset var productParentList = "">	<!--- list of unique non-zero productID_parent's in invoice --->
	<cfset var categoryList = "">			<!--- list of unique categories that products are listed in directly --->
	<cfset var categoryParentList = "">	<!--- list of unique parent categories that products are listed in subcategories of --->
	<cfset var commissionTargetList = "">	<!--- list of salespeople, affiliate and cobrand; vendors are not included in list --->
	<cfset var commissionCustomerStruct = StructNew()>
	<cfset var qry_selectInvoiceLineItemList_products = QueryNew("blank")>
	<cfset var qry_selectInvoiceLineItemList_productParents = QueryNew("blank")>
	<cfset var qry_selectInvoiceLineItemList_vendors = QueryNew("blank")>
	<cfset var vendorList = "">
	<!--- <cfset var qry_selectVendorList = QueryNew("blank")> --->
	<cfset var qry_selectInvoiceLineItemList_custom = QueryNew("blank")>
	<cfset var invoiceTotalCustomProducts = 0>
	<cfset var invoiceQuantityCustomProducts = 0>
	<!--- <cfset var qry_selectProductCategory = QueryNew("blank")> --->
	<cfset var qry_selectProductCategoryManual = QueryNew("blank")>
	<cfset var prodID = 0>
	<!--- <cfset var qry_selectAffiliate = QueryNew("blank")> --->
	<!--- <cfset var qry_selectCobrand = QueryNew("blank")> --->
	<!--- <cfset var qry_selectCommissionCustomerList = QueryNew("blank")> --->
	<cfset var periodIntervalDateBegin = StructNew()>
	<cfset var periodIntervalDateEnd = StructNew()>
	<cfset var calcDate = Now()>

	<!--- act_calculateSalesCommission_affCobUser.cfm --->
	<cfset var thisPrimaryTargetID = 0>
	<cfset var thisPrimaryTargetKey = "">
	<cfset var thisTargetID = 0>
	<!--- <cfset var qry_selectCommissionListForTarget = QueryNew("blank")> --->
	<cfset var commissionProductValueList = "">
	<cfset var commissionCategoryValueList = "">
	<cfset var commissionCustomerRow = 0>
	<cfset var salesCommissionCustomerPercent = 1>
	<cfset var commissionCustomerDateEnd = Now()>
	<cfset var thisDate = Now()>
	<cfset var salespersonDateCreated = Now()>
	<cfset var commissionCustomerID = 0>
	<cfset var userRow = 0>

	<!--- act_calculateSalesCommission_matchLineItems.cfm --->
	<cfset var productsWithCommissionPlan = "">
	<cfset var qryman_selectCount = QueryNew("blank")>
	<cfset var invoiceQuantityExistingProducts = 0>
	<cfset var invoiceTotalExistingProducts = 0>

	<!--- act_calculateSalesCommission_planLoop.cfm --->
	<!--- <cfset var qry_selectCommissionList = QueryNew("blank")> --->
	<!--- <cfset var qry_selectCommissionVolumeDiscount = QueryNew("blank")> --->
	<cfset var useThisStage = False>
	<cfset var salesCommissionID_existing = "">
	<cfset var salesCommissionCalculatedAmount= 0>
	<cfset var thisCommissionID = 0>
	<cfset var thisStageID = 0>
	<cfset var stageRow = 0>

	<!--- act_calculateSalesCommission_invoiceInvoice.cfm --->
	<cfset var stageBegin = Now()>
	<cfset var stageEnd = Now()>
	<cfset var stageEndMidnight = Now()>
	<cfset var salesCommissionBasisTotal = 0>
	<cfset var salesCommissionBasisQuantity = 0>

	<!--- act_calculateSalesCommission_planCalc.cfm --->
	<cfset var beginRow = 0>
	<cfset var counter = 1>
	<cfset var quantityRemaining = 0>
	<cfset var subTotalRemaining = 0>

	<!--- act_calculateSalesCommission_insert.cfm --->
	<cfset var scArrayCount = 0>
	<cfset var salesCommissionID_new = 0>
	<!--- <cfset var newSalesCommissionID = 0> --->

	<!--- act_calculateSalesCommission_invoiceLineItem.cfm --->
	<cfset var qry_selectInvoiceLineItemListForTarget = QueryNew("blank")>
	<cfset var subscriptionRow = 0>

	<!--- act_calculateSalesCommission_periodInvoice.cfm --->
	<cfset var qry_checkSalesCommissionForPeriod = QueryNew("blank")>
	<cfset var qry_selectSalesCommissionInvoiceSum = QueryNew("blank")>

	<!--- act_calculateSalesCommission_periodLineItem.cfm --->

	<!--- act_calculateSalesCommission_vendor.cfm --->
	<cfset var vendorProductList = "">
	<cfset var vendorProductParentList = "">
	<cfset var vendorCategoryList = "">
	<cfset var vendorCategoryParentList = "">
	<cfset var vendorRow = 0>

	<cfinclude template="act_calculateSalesCommission_checkInvoicePaid.cfm">

	<cfif returnValue is True>
		<cfinclude template="control_calculateSalesCommission.cfm">
	</cfif>

	<cfreturn returnValue>
</cffunction>

</cfcomponent>
