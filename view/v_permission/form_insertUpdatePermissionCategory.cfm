<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.permissionCategory.permissionCategoryTitle.value == "")
	document.permissionCategory.permissionCategoryTitle.value = document.permissionCategory.permissionCategoryName.value;
}
</script>

<form method="post" name="permissionCategory" Action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Order: </td>
	<td>
		<cfif URL.permissionCategoryID is 0>
			<select name="permissionCategoryOrder" size="1">
			<cfloop Query="qry_selectPermissionCategoryList">
				<option value="#qry_selectPermissionCategoryList.permissionCategoryOrder#"<cfif Form.permissionCategoryOrder is qry_selectPermissionCategoryList.permissionCategoryOrder> selected</cfif>>Before ###qry_selectPermissionCategoryList.permissionCategoryOrder#. #HTMLEditFormat(qry_selectPermissionCategoryList.permissionCategoryName)#</option>
			</cfloop>
			<option value="0"<cfif Form.permissionCategoryOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		<cfelse>
			#Form.permissionCategoryOrder#
		</cfif>
	</td>
</tr>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="permissionCategoryStatus" value="1"<cfif Form.permissionCategoryStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="permissionCategoryStatus" value="0"<cfif Form.permissionCategoryStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Name: </td>
	<td><input type="text" name="permissionCategoryName" value="#HTMLEditFormat(Form.permissionCategoryName)#" size="40" maxlength="#maxlength_PermissionCategory.permissionCategoryName#"<cfif Variables.doAction is "insertPermissionCategory"> onBlur="javascript:setTitle();"</cfif>> (must be unique)</td>
</tr>
<tr>
	<td>Title: </td>
	<td><input type="text" name="permissionCategoryTitle" value="#HTMLEditFormat(Form.permissionCategoryTitle)#" size="40" maxlength="#maxlength_PermissionCategory.permissionCategoryTitle#"> (displayed on form when assigning permissions)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="permissionCategoryDescription" value="#HTMLEditFormat(Form.permissionCategoryDescription)#" size="40" maxlength="#maxlength_PermissionCategory.permissionCategoryDescription#"> (for internal purposes)</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitPermissionCategory" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
