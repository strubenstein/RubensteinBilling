<cfoutput>
<form method="post" name="exportTable" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "insertExportTable">
	<tr>
		<td>Order: </td>
		<td>
			<select name="exportTableOrder" size="1">
			<cfloop Query="qry_selectExportTableList">
				<option value="#qry_selectExportTableList.exportTableOrder#"<cfif Form.exportTableOrder is qry_selectExportTableList.exportTableOrder> selected</cfif>>Before ###qry_selectExportTableList.exportTableOrder#. #HTMLEditFormat(qry_selectExportTableList.exportTableName)#</option>
			</cfloop>
			<option value="0"<cfif Form.exportTableOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		</td>
	</tr>
</cfif>

<tr>
	<td>Primary Target: </td>
	<td>
	<cfif Variables.doAction is "insertExportTable">
		<select name="primaryTargetID" size="1">
		<option value="0">-- PRIMARY TARGET --</option>
		<cfloop Query="qry_selectPrimaryTargetList">
			<cfif Not ListFind(ValueList(qry_selectExportTableList.primaryTargetID), qry_selectPrimaryTargetList.primaryTargetID)>
				<option value="#qry_selectPrimaryTargetList.primaryTargetID#"<cfif Form.primaryTargetID is qry_selectPrimaryTargetList.primaryTargetID> selected</cfif>>#HTMLEditFormat(qry_selectPrimaryTargetList.primaryTargetTable)#</option>
			</cfif>
		</cfloop>
		</select>
	<cfelse>
		#qry_selectPrimaryTarget.primaryTargetTable#
	</cfif>
	</td>
</tr>

<tr valign="top">
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="exportTableStatus" value="1"<cfif Form.exportTableStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="exportTableStatus" value="0"<cfif Form.exportTableStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Table Name: </td>
	<td><input type="text" name="exportTableName" value="#HTMLEditFormat(Form.exportTableName)#" size="30" maxlength="#maxlength_ExportTable.exportTableName#"> (displayed to customer)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="exportTableDescription" value="#HTMLEditFormat(Form.exportTableDescription)#" size="50" maxlength="#maxlength_ExportTable.exportTableDescription#"> (optional)</td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitExportTable" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
