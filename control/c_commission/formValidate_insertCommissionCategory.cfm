<cfset errorMessage_fields = StructNew()>

<!--- new categories to insert for this commission --->
<cfset Form.categoryID_insert = "">

<!--- former categories in which commission is re-listed --->
<cfset Form.categoryID_updateStatusTrue = "">

<cfloop Index="loopCategoryID" List="#Form.categoryID#">
	<cfif Not ListFind(ValueList(qry_selectCategoryList.categoryID), loopCategoryID)>
		<cfset errorMessage_fields.categoryID = Variables.lang_insertCommissionCategory.categoryID>
		<cfbreak>
	<cfelse>
		<cfset Variables.commCatRow = ListFind(ValueList(qry_selectCommissionCategory.categoryID), loopCategoryID)>
		<cfif Variables.commCatRow is 0>
			<cfset Form.categoryID_insert = ListAppend(Form.categoryID_insert, loopCategoryID)>
		<cfelse><!--- qry_selectCommissionCategory.commissionCategoryStatus[Variables.commCatRow] is 0 --->
			<cfset Form.categoryID_updateStatusTrue = ListAppend(Form.categoryID_updateStatusTrue, loopCategoryID)>
		</cfif>
	</cfif>
</cfloop>

<!--- existing categories for which commission is no longer applied --->
<cfset Form.categoryID_updateStatusFalse = "">
<cfif URL.commissionID is not 0 and IsDefined("qry_selectCommissionCategory")>
	<cfloop Query="qry_selectCommissionCategory">
		<cfif Not ListFind(Form.categoryID, qry_selectCommissionCategory.categoryID)>
			<cfset Form.categoryID_updateStatusFalse = ListAppend(Form.categoryID_updateStatusFalse, qry_selectCommissionCategory.categoryID)>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertCommissionCategory.errorTitle>
	<cfset errorMessage_header = Variables.lang_insertCommissionCategory.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertCommissionCategory.errorFooter>
</cfif>

