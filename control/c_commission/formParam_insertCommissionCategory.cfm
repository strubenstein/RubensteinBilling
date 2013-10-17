<cfif URL.commissionID is not 0 and IsDefined("qry_selectCommissionCategory") and Not IsDefined("Form.submitCommissionCategory")>
	<cfset Form.categoryID = "">
	<cfset Form.categoryID_children = "">

	<cfloop Query="qry_selectCommissionCategory">
		<cfif qry_selectCommissionCategory.commissionCategoryStatus is 1>
			<cfset Form.categoryID = ListAppend(Form.categoryID, qry_selectCommissionCategory.categoryID)>
			<cfif qry_selectCommissionCategory.commissionCategoryChildren is 1>
				<cfset Form.categoryID_children = ListAppend(Form.categoryID_children, qry_selectCommissionCategory.categoryID)>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfparam Name="Form.categoryID" Default="">
<cfparam Name="Form.categoryID_children" Default="">

