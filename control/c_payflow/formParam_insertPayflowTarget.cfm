<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfset Form.payflowID = "">
	<cfloop Query="qry_selectPayflowTarget">
		<cfif qry_selectPayflowTarget.payflowTargetStatus is 1>
			<cfset Form.payflowID = ListAppend(Form.payflowID, qry_selectPayflowTarget.payflowID)>
			<cfset Form["payflowTargetDateBegin#qry_selectPayflowTarget.payflowID#_date"] = DateFormat(qry_selectPayflowTarget.payflowTargetDateBegin, "mm/dd/yyyy")>
			<cfif qry_selectPayflowTarget.payflowTargetDateEnd is "">
				<cfset Form["payflowTargetDateEnd#qry_selectPayflowTarget.payflowID#_date"] = "">
			<cfelse>
				<cfset Form["payflowTargetDateEnd#qry_selectPayflowTarget.payflowID#_date"] = DateFormat(qry_selectPayflowTarget.payflowTargetDateEnd, "mm/dd/yyyy")>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfparam Name="Form.payflowID" Default="">
<cfloop Query="qry_selectPayflowList">
	<cfparam Name="Form.payflowTargetDateBegin#qry_selectPayflowList.payflowID#_date" Default="">
	<cfparam Name="Form.payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date" Default="">
</cfloop>
