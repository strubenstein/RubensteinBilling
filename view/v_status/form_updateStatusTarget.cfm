<cfoutput>
<p class="MainText">
For each target type, select whether to include this field in the export method.<br>
You must check the checkbox for the custom status option to be exported.
</p>

<form method="post" name="statusTarget" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="1" cellspacing="0" cellpadding="3">
<tr class="TableHeader" valign="bottom">
	<th rowspan="2">Target Type</th>
	<th colspan="2">XML Export</th>
	<th colspan="2">Tab-Delimited Export</th>
	<!--- <th>Browser Display</th> --->
</tr>
<tr class="TableHeader" valign="bottom">
	<th>?</th>
	<th>Variable Name</th>
	<th>?</th>
	<th>Column Header</th>
	<!--- 
	<th>?</th>
	<th>Column Header</th>
	--->
</tr>

<cfloop Query="qry_selectStatusTargetList">
	<cfset Variables.targetIndex = ListFind(Variables.statusTargetList_id, qry_selectStatusTargetList.primaryTargetID)>
	<tr class="MainText"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><cfif Variables.targetIndex is 0>n/a<cfelse>#ListGetAt(Variables.statusTargetList_label, Variables.targetIndex)#</cfif></td>
		<td><input type="checkbox" name="statusTargetExportXmlStatus#qry_selectStatusTargetList.primaryTargetID#" value="1"<cfif Form["statusTargetExportXmlStatus#qry_selectStatusTargetList.primaryTargetID#"] is 1> checked</cfif>></td>
		<td><input type="text" name="statusTargetExportXmlName#qry_selectStatusTargetList.primaryTargetID#" value="#HTMLEditFormat(Form["statusTargetExportXmlName#qry_selectStatusTargetList.primaryTargetID#"])#" size="20" maxlength="#maxlength_StatusTarget.statusTargetExportXmlName#"></td>
		<td><input type="checkbox" name="statusTargetExportTabStatus#qry_selectStatusTargetList.primaryTargetID#" value="1"<cfif Form["statusTargetExportTabStatus#qry_selectStatusTargetList.primaryTargetID#"] is 1> checked</cfif>></td>
		<td><input type="text" name="statusTargetExportTabName#qry_selectStatusTargetList.primaryTargetID#" value="#HTMLEditFormat(Form["statusTargetExportTabName#qry_selectStatusTargetList.primaryTargetID#"])#" size="20" maxlength="#maxlength_StatusTarget.statusTargetExportTabName#"></td>
		<!--- 
		<td><input type="checkbox" name="statusTargetExportHtmlStatus#qry_selectStatusTargetList.primaryTargetID#" value="1"<cfif Form["statusTargetExportHtmlStatus#qry_selectStatusTargetList.primaryTargetID#"] is 1> checked</cfif>></td>
		<td><input type="text" name="statusTargetExportHtmlName#qry_selectStatusTargetList.primaryTargetID#" value="#HTMLEditFormat(Form["statusTargetExportHtmlName#qry_selectStatusTargetList.primaryTargetID#"])#" size="20" maxlength="#maxlength_StatusTarget.statusTargetExportHtmlName#"></td>
		--->
	</tr>
</cfloop>
<tr height="40"><td colspan="7" align="center"><input type="submit" name="submitStatusTarget" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td></tr>
</table>
</form>
</cfoutput>
