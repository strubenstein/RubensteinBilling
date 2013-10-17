<!--- loop thru vendors --->
<cfloop Index="thisVendorID" List="#vendorList#">
	<cfset thisPrimaryTargetKey = "vendorID">
	<cfset thisPrimaryTargetID = Application.fn_GetPrimaryTargetID("vendorID")>
	<cfset thisTargetID = thisVendorID>

	<cfset temp = StructClear(commissionProductStruct)>
	<cfset vendorProductList = "">
	<cfset vendorProductParentList = "">
	<cfset vendorCategoryList = "">
	<cfset vendorCategoryParentList = "">

	<!--- select vendor products --->
	<cfquery Name="qryman_selectCount" DBType="query">
		SELECT DISTINCT(productID)
		FROM qry_selectInvoiceLineItemList
		WHERE vendorID = #thisTargetID#
			AND productID <> 0
	</cfquery>
	<cfset vendorProductList = ValueList(qryman_selectCount.productID)>

	<!--- if vendor has any products in this invoice --->
	<cfif vendorProductList is not "">
		<!--- select vendor parent products --->
		<cfquery Name="qryman_selectCount" DBType="query">
			SELECT DISTINCT(productID_parent)
			FROM qry_selectInvoiceLineItemList
			WHERE vendorID = #thisTargetID#
				AND productID_parent <> 0
		</cfquery>
		<cfset vendorProductParentList = ValueList(qryman_selectCount.productID_parent)>

		<!--- select categories for vendor products --->
		<cfquery Name="qryman_selectCount" DBType="query">
			SELECT DISTINCT(categoryID)
			FROM qry_selectProductCategoryManual
			WHERE productID IN (#vendorProductList#)
				AND isCategoryParent = 0
		</cfquery>
		<cfset vendorCategoryList = ValueList(qryman_selectCount.categoryID)>

		<cfquery Name="qryman_selectCount" DBType="query">
			SELECT DISTINCT(categoryID)
			FROM qry_selectProductCategoryManual
			WHERE productID IN (#vendorProductList#)
				AND isCategoryParent = 1
		</cfquery>
		<cfset vendorCategoryParentList = ValueList(qryman_selectCount.categoryID)>

		<!--- select commission plans that apply to vendor and products --->
		<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="selectCommissionListForTarget" ReturnVariable="qry_selectCommissionListForTarget">
			<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID_author#">
			<cfinvokeargument Name="primaryTargetID" Value="#thisPrimaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#thisTargetID#">
			<cfinvokeargument Name="commissionDate" Value="#effectiveCommissionDate#">
			<cfif vendorProductList is not "">
				<cfinvokeargument Name="productID" Value="#vendorProductList#">
			</cfif>
			<cfif vendorProductParentList is not "">
				<cfinvokeargument Name="productID_parent" Value="#vendorProductParentList#">
			</cfif>
			<cfif vendorCategoryList is not "">
				<cfinvokeargument Name="categoryID" Value="#vendorCategoryList#">
			</cfif>
			<cfif vendorCategoryParentList is not "">
				<cfinvokeargument Name="categoryID_parent" Value="#vendorCategoryParentList#">
			</cfif>
		</cfinvoke>

		<cfif qry_selectCommissionListForTarget.RecordCount is not 0>
			<cfinclude template="act_calculateSalesCommission_matchLineItems.cfm">

			<!--- CALCULATE SALES COMMISSIONS --->
			<cfset commissionCustomerID = 0>
			<cfset vendorRow = ListFind(ValueList(qry_selectVendorList.vendorID), thisTargetID)>
			<cfif vendorRow is 0>
				<cfset salespersonDateCreated = effectiveCommissionDate>
			<cfelse>
				<cfset salespersonDateCreated = qry_selectVendorList.vendorDateCreated[vendorRow]>
			</cfif>

			<cfinclude template="act_calculateSalesCommission_planLoop.cfm">
		</cfif><!--- /vendor has commission plans --->
	</cfif><!--- /vendor has products in this invoice --->
</cfloop><!--- /loop thru vendors --->

