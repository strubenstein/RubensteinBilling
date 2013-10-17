<cfinvoke Component="#Application.billingMapping#data.CommissionCategory" Method="selectCommissionCategory" ReturnVariable="qry_selectCommissionCategory">
	<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="formParam_insertCommissionCategory.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCommissionCategory")>
	<cfinclude template="../../view/v_commission/lang_insertCommissionCategory.cfm">
	<cfinclude template="formValidate_insertCommissionCategory.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<cfloop Index="loopCategoryID" List="#Form.categoryID_insert#">
			<cfinvoke Component="#Application.billingMapping#data.CommissionCategory" Method="insertCommissionCategory" ReturnVariable="isCommissionCategoryInserted">
				<cfinvokeargument Name="categoryID" Value="#loopCategoryID#">
				<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="commissionCategoryStatus" Value="1">
				<cfif ListFind(Form.categoryID_children, loopCategoryID)>
					<cfinvokeargument Name="commissionCategoryChildren" Value="1">
				<cfelse>
					<cfinvokeargument Name="commissionCategoryChildren" Value="0">
				</cfif>
			</cfinvoke>
		</cfloop>

		<cfloop Index="loopCategoryID" List="#Form.categoryID_updateStatusTrue#">
			<cfset Variables.commCatRow = ListFind(ValueList(qry_selectCommissionCategory.categoryID), loopCategoryID)>
			<cfinvoke Component="#Application.billingMapping#data.CommissionCategory" Method="updateCommissionCategory" ReturnVariable="isCommissionCategoryUpdated">
				<cfinvokeargument Name="commissionCategoryID" Value="#qry_selectCommissionCategory.commissionCategoryID[Variables.commCatRow]#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="commissionCategoryStatus" Value="1">
				<cfif ListFind(Form.categoryID_children, loopCategoryID)>
					<cfinvokeargument Name="commissionCategoryChildren" Value="1">
				<cfelse>
					<cfinvokeargument Name="commissionCategoryChildren" Value="0">
				</cfif>
			</cfinvoke>
		</cfloop>

		<cfloop Index="loopCategoryID" List="#Form.categoryID_updateStatusFalse#">
			<cfset Variables.commCatRow = ListFind(ValueList(qry_selectCommissionCategory.categoryID), loopCategoryID)>
			<cfinvoke Component="#Application.billingMapping#data.CommissionCategory" Method="updateCommissionCategory" ReturnVariable="isCommissionCategoryUpdated">
				<cfinvokeargument Name="commissionCategoryID" Value="#qry_selectCommissionCategory.commissionCategoryID[Variables.commCatRow]#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="commissionCategoryStatus" Value="0">
			</cfinvoke>
		</cfloop>

		<cflocation url="index.cfm?method=commission.#Variables.doAction#&commissionID=#URL.commissionID#&confirm_commission=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "commissionCategory">
<cfif Variables.doAction is "viewCommissionCategory">
	<cfset Variables.formAction = "">
<cfelse>
	<cfset Variables.formAction = "index.cfm?method=commission.#Variables.doAction#&commissionID=#URL.commissionID#">
</cfif>

<cfinclude template="../../view/v_commission/form_insertCommissionCategory.cfm">
