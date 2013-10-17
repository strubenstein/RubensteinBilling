<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Export Options: </span>
<cfif Application.fn_IsUserAuthorized("listExportTables")><a href="index.cfm?method=export.listExportTables" title="List existing tables that can be exported" class="SubNavLink<cfif Variables.doAction is "listExportTables">On</cfif>">List Export Tables</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertExportTable")> | <a href="index.cfm?method=export.insertExportTable" title="Add new table available for export" class="SubNavLink<cfif Variables.doAction is "insertExportTable">On</cfif>">Add New Export Table</a></cfif>
<cfif Application.fn_IsUserAuthorized("listExportQueries")> | <a href="index.cfm?method=export.listExportQueries" title="List existing queries that can be exported" class="SubNavLink<cfif Variables.doAction is "listExportQueries">On</cfif>">List Export Queries</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertExportQuery")> | <a href="index.cfm?method=export.insertExportQuery" title="Add new query for export" class="SubNavLink<cfif Variables.doAction is "insertExportQuery">On</cfif>">Add New Export Query</a></cfif>
<cfif URL.exportTableID is not 0 and IsDefined("qry_selectExportTable") and Not Find("Query", Variables.doAction)>
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Table Name:</span> <span class="SubNavName">#qry_selectExportTable.exportTableName#</span><br>
	<cfif Application.fn_IsUserAuthorized("updateExportTable")><a href="index.cfm?method=export.updateExportTable&exportTableID=#URL.exportTableID#" title="Update export table information" class="SubNavLink<cfif Variables.doAction is "updateExportTable">On</cfif>">Update Table</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listExportTableFields")><a href="index.cfm?method=export.listExportTableFields&exportTableID=#URL.exportTableID#" title="List existing fields in export table" class="SubNavLink<cfif Variables.doAction is "listExportTableFields">On</cfif>">List Table Fields</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("insertExportTableField")><a href="index.cfm?method=export.insertExportTableField&exportTableID=#URL.exportTableID#" title="Add new field to export table" class="SubNavLink<cfif Variables.doAction is "insertExportTableField">On</cfif>">Add New Table Field</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listExportTableFieldCompany")><a href="index.cfm?method=export.listExportTableFieldCompany&exportTableID=#URL.exportTableID#" title="List existing fields and company-specific options for export table fields" class="SubNavLink<cfif Variables.doAction is "listExportTableFieldCompany">On</cfif>">List Table Field Settings</a></cfif>
	<cfif Application.fn_IsUserAuthorized("updateExportTableFieldCompany")> | <a href="index.cfm?method=export.updateExportTableFieldCompany&exportTableID=#URL.exportTableID#" title="Update company-specific options for export table fields" class="SubNavLink<cfif Variables.doAction is "updateExportTableFieldCompany">On</cfif>">Update Custom Table Field Settings</a></cfif>
</cfif>
<cfif URL.exportQueryID is not 0 and IsDefined("qry_selectExportQuery")>
	<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
	<span class="SubNavObject">Query Name:</span> <span class="SubNavName">#qry_selectExportQuery.exportQueryTitle#</span><br>
	<cfif Application.fn_IsUserAuthorized("updateExportQuery")><a href="index.cfm?method=export.updateExportQuery&exportQueryID=#URL.exportQueryID#" title="Update exoprt query information" class="SubNavLink<cfif Variables.doAction is "updateExportQuery">On</cfif>">Update Query</a> | </cfif>
	<cfif Application.fn_IsUserAuthorized("listExportQueryFields")><a href="index.cfm?method=export.listExportQueryFields&exportQueryID=#URL.exportQueryID#" title="List existing fields included in export query" class="SubNavLink<cfif Variables.doAction is "listExportQueryFields">On</cfif>">List Query Fields</a></cfif>
	<cfif Application.fn_IsUserAuthorized("updateExportQueryFieldCompany")> | <a href="index.cfm?method=export.updateExportQueryFieldCompany&exportQueryID=#URL.exportQueryID#" title="Update company-specific options for export query fields" class="SubNavLink<cfif Variables.doAction is "updateExportQueryFieldCompany">On</cfif>">Update Custom Query Field Settings</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertExportQueryField")>  | <a href="index.cfm?method=export.insertExportQueryField&exportQueryID=#URL.exportQueryID#" title="Add new field to export query (from existing export table)" class="SubNavLink<cfif Variables.doAction is "insertExportQueryField">On</cfif>">Add Fields To Query</a></cfif>
	<!--- listExportQueryFieldCompany --->
</cfif>
</div><br>
</cfoutput>
