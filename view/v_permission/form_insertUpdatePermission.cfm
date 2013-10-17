<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.insertUpdatePermission.permissionTitle.value == "")
		document.insertUpdatePermission.permissionTitle.value = document.insertUpdatePermission.permissionName.value;
}
</script>

<form method="post" name="insertUpdatePermission" Action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Order: </td>
	<td>
		<cfif URL.permissionID is 0>
			<select name="permissionOrder" size="1">
			<cfloop Query="qry_selectPermissionList">
				<option value="#qry_selectPermissionList.permissionOrder#"<cfif Form.permissionOrder is qry_selectPermissionList.permissionOrder> selected</cfif>>Before ###qry_selectPermissionList.permissionOrder#. #HTMLEditFormat(qry_selectPermissionList.permissionName)#</option>
			</cfloop>
			<option value="0"<cfif Form.permissionOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		<cfelse>
			#Form.permissionOrder#
		</cfif>
	</td>
</tr>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="permissionStatus" value="1"<cfif Form.permissionStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="permissionStatus" value="0"<cfif Form.permissionStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr valign="top">
	<td>Server Mgr Only: </td>
	<td>
		<label><input type="checkbox" name="permissionSuperuserOnly" value="1"<cfif Form.permissionSuperuserOnly is 1> checked</cfif>> 
		If checked, permission is available only to users of company that manages<br>
		&nbsp; &nbsp; &nbsp;  this server and is not displayed on permission form for other users or groups.</label>
	</td>
</tr>
<tr>
	<td>Name: </td>
	<td><input type="text" name="permissionName" value="#HTMLEditFormat(Form.permissionName)#" size="40" maxlength="#maxlength_Permission.permissionName#"<cfif Variables.doAction is "insertPermission"> onBlur="javascript:setTitle();"</cfif>> (must be unique)</td>
</tr>
<tr>
	<td>Title: </td>
	<td><input type="text" name="permissionTitle" value="#HTMLEditFormat(Form.permissionTitle)#" size="40" maxlength="#maxlength_Permission.permissionTitle#"> (displayed on form when assigning permissions)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="permissionDescription" value="#HTMLEditFormat(Form.permissionDescription)#" size="40" maxlength="#maxlength_Permission.permissionDescription#"> (for internal purposes)</td>
</tr>
<tr>
	<td>Action(s): </td>
	<td class="TableText">(Separate actions by comma or carriage return. Actions may be up to #maxlength_PermissionAction.permissionAction# characters.)</td>
</tr>
<tr>
	<td colspan="2"><textarea name="permissionAction" rows="7" cols="60" wrap="off">#HTMLEditFormat(Trim(Form.permissionAction))#</textarea></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitPermission" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
