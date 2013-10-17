<cfset errorMessage_fields = StructNew()>

<cfloop Query="qry_selectStatusTargetList">
	<cfset Variables.targetIndex = ListFind(Variables.statusTargetList_id, qry_selectStatusTargetList.primaryTargetID)>
	<cfif Variables.targetIndex is 0>
		<cfset Variables.targetLabel = "n/a">
		<cfset Variables.targetValue = "n/a">
	<cfelse>
		<cfset Variables.targetLabel = ListGetAt(Variables.statusTargetList_label, Variables.targetIndex)>
		<cfset Variables.targetValue = ListGetAt(Variables.statusTargetList_value, Variables.targetIndex)>
	</cfif>

	<cfset targetID = qry_selectStatusTargetList.primaryTargetID>
	<cfloop Index="type" List="Xml,Tab,Html">
		<!--- status must be 0 or 1 --->
		<cfif Not ListFind("0,1", Form["statusTargetExport#type#Status#targetID#"])>
			<cfset errorMessage_fields["statusTargetExport#type#Status#targetID#"] = ReplaceNoCase(Variables.lang_updateStatusTarget["statusTargetExport#type#Status"], "<<TYPE>>", Variables.targetLabel, "ALL")>
		</cfif>

		<!--- if status is checked, name cannot be blank --->
		<cfif Form["statusTargetExport#type#Name#targetID#"] is "" and Form["statusTargetExport#type#Status#targetID#"] is 1>
			<cfset errorMessage_fields["statusTargetExport#type#Name#targetID#"] = ReplaceNoCase(Variables.lang_updateStatusTarget["statusTargetExport#type#Name_blank"], "<<TYPE>>", Variables.targetLabel, "ALL")>

		<!--- name cannot be existing status name, e.g., companyStatus --->
		<cfelseif Form["statusTargetExport#type#Name#targetID#"] is ReplaceNoCase(Variables.targetValue, "ID", "Status", "ONE")>
			<cfset errorMessage_fields["statusTargetExport#type#Name#targetID#"] = ReplaceNoCase(Variables.lang_updateStatusTarget["statusTargetExport#type#Name_default"], "<<TYPE>>", Variables.targetLabel, "ALL")>

		<!--- name must be less than maximum length permitted --->
		<cfelseif Len(Form["statusTargetExport#type#Name#targetID#"]) gt maxlength_StatusTarget["statusTargetExport#type#Name"]>
			<cfset errorMessage_fields["statusTargetExport#type#Name#targetID#"] = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_updateStatusTarget["statusTargetExport#type#Name_maxlength"], "<<TYPE>>", Variables.targetLabel, "ALL"), "<<MAXLENGTH>>", maxlength_StatusTarget["statusTargetExport#type#Name"], "ALL"), "<<LEN>>", Len(Form["statusTargetExport#type#Name#targetID#"]), "ALL")>

		<!--- if xml, must be valid variable name --->
		<cfelseif type is "Xml" and Form["statusTargetExport#type#Name#targetID#"] is not "" and (REFindNoCase("[^A-Za-z0-9_]", Form["statusTargetExport#type#Name#targetID#"]) or Not REFindNoCase("[A-Za-z]", Left(Form["statusTargetExport#type#Name#targetID#"], 1)))>
			<cfset errorMessage_fields["statusTargetExport#type#Name#targetID#"] = ReplaceNoCase(Variables.lang_updateStatusTarget["statusTargetExport#type#Name_valid"], "<<TYPE>>", Variables.targetLabel, "ALL")>
		</cfif>
	</cfloop>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_updateStatusTarget.errorTitle>
	<cfset errorMessage_header = Variables.lang_updateStatusTarget.errorHeader>
	<cfset errorMessage_footer = Variables.lang_updateStatusTarget.errorFooter>
</cfif>

