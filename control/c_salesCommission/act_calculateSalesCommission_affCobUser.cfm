<!--- loop thru non-vendor salesperson targets --->
<cfloop Index="commTarget" List="#commissionTargetList#">
	<cfset thisPrimaryTargetID = ListFirst(commTarget, "_")>
	<cfset thisPrimaryTargetKey = Application.fn_GetPrimaryTargetKey(thisPrimaryTargetID)>
	<cfset thisTargetID = ListLast(commTarget, "_")>

	<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="selectCommissionListForTarget" ReturnVariable="qry_selectCommissionListForTarget">
		<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID_author#">
		<cfinvokeargument Name="primaryTargetID" Value="#thisPrimaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#thisTargetID#">
		<cfinvokeargument Name="commissionDate" Value="#effectiveCommissionDate#">
		<cfif productList is not "">
			<cfinvokeargument Name="productID" Value="#productList#">
		</cfif>
		<cfif productParentList is not "">
			<cfinvokeargument Name="productID_parent" Value="#productParentList#">
		</cfif>
		<cfif categoryList is not "">
			<cfinvokeargument Name="categoryID" Value="#categoryList#">
		</cfif>
		<cfif categoryParentList is not "">
			<cfinvokeargument Name="categoryID_parent" Value="#categoryParentList#">
		</cfif>
	</cfinvoke>

	<cfif qry_selectCommissionListForTarget.RecordCount is not 0>
		<cfset commissionProductValueList = ValueList(qry_selectCommissionListForTarget.productID)>
		<cfset commissionCategoryValueList = ValueList(qry_selectCommissionListForTarget.categoryID)>

		<!--- loop thru line items to calculate invoice total and determine which line items (products) are processed separately --->
		<cfinclude template="act_calculateSalesCommission_matchLineItems.cfm">

		<cfif Not StructKeyExists(commissionCustomerStruct, thisPrimaryTargetID & "_" & thisTargetID)><!--- affiliate,cobrandID --->
			<cfset commissionCustomerRow = 0>
			<cfset salesCommissionCustomerPercent = 1>
			<cfset commissionCustomerDateEnd = CreateDateTime(2099, 12, 31, 23, 59, 00)>
		<cfelse>
			<cfset commissionCustomerRow = commissionCustomerStruct["#thisPrimaryTargetID#_#thisTargetID#"]>
			<cfset salesCommissionCustomerPercent = qry_selectCommissionCustomerList.commissionCustomerPercent[commissionCustomerRow]>

			<cfset thisDate = qry_selectCommissionCustomerList.commissionCustomerDateEnd[commissionCustomerRow]>
			<cfif thisDate is "">
				<cfset commissionCustomerDateEnd = CreateDateTime(2099, 12, 31, 23, 59, 00)>
			<cfelse>
				<cfset commissionCustomerDateEnd = CreateDateTime(Year(thisDate), Month(thisDate), Day(thisDate), 23, 59, 00)>
			</cfif>
		</cfif>

		<!--- CALCULATE SALES COMMISSIONS --->
		<!--- select invoice line items for this vendor that have line-item commission plans --->
		<!--- 
		<cfif productsWithCommissionPlan is "">
			<cfset qry_selectInvoiceLineItemListForTarget = qry_selectInvoiceLineItemList>
		<cfelse>
			<cfquery Name="qry_selectInvoiceLineItemListForTarget" DBType="query">
				SELECT *
				FROM qry_selectInvoiceLineItemList
				WHERE productID IN (#productsWithCommissionPlan#)
				ORDER BY invoiceLineItemOrder
			</cfquery>
		</cfif>
		--->

		<cfswitch expression="#thisPrimaryTargetKey#">
		<cfcase value="affiliateID">
			<cfset salespersonDateCreated = qry_selectAffiliate.affiliateDateCreated>
			<cfset commissionCustomerID = 0>
		</cfcase>
		<cfcase value="cobrandID">
			<cfset salespersonDateCreated = qry_selectCobrand.cobrandDateCreated>
			<cfset commissionCustomerID = 0>
		</cfcase>
		<cfcase value="userID">
			<cfif Not StructKeyExists(commissionCustomerStruct, "#qry_selectCommissionCustomerList.primaryTargetID#_#qry_selectCommissionCustomerList.targetID#")>
				<cfset salespersonDateCreated = effectiveCommissionDate>
				<cfset commissionCustomerID = 0>
			<cfelse>
				<cfset userRow = commissionCustomerStruct["#qry_selectCommissionCustomerList.primaryTargetID#_#qry_selectCommissionCustomerList.targetID#"]>
				<cfset salespersonDateCreated = qry_selectCommissionCustomerList.userDateCreated[userRow]>
				<cfset commissionCustomerID = qry_selectCommissionCustomerList.commissionCustomerID[userRow]>
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfset salespersonDateCreated = effectiveCommissionDate>
			<cfset commissionCustomerID = 0>
		</cfdefaultcase>
		</cfswitch>

		<cfinclude template="act_calculateSalesCommission_planLoop.cfm">
	</cfif><!--- /commission plans exist for this target --->
</cfloop><!--- /loop thru possible commission targets --->
