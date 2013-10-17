<cfoutput>
<cfif Variables.doAction is "insertGroup">
	<table border="0" width="600"><tr><td class="MainText">
	<p>Groups enable you to combine users and/or companies into a single collection for the purposes of assigning permissions to them. A user/company is granted the combined permissions of all individual permissions they are granted plus the permissions from all groups they are in. If a company is added to a group, the group's permissions are granted to all users in that company. Groups are also useful for granting custom pricing to the collection of users/companies.</p>
	<p>The group <i>category</i> is used solely to assist you in organizing similar groups. It has no functional use. Suggested uses are for categorizing groups into employees, vendors, partners, etc.</p>
	</td></tr></table>
</cfif>

<form method="post" name="insertUpdateGroup" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td>Status: </td>
	<td>
		<label><input type="radio" name="groupStatus" value="1"<cfif Form.groupStatus is 1> checked</cfif>> 
		Active - All users/companies in this group have this group's permissions.</label><br>
		<label><input type="radio" name="groupStatus" value="0"<cfif Form.groupStatus is not 1> checked</cfif>> 
		Disabled - Users/companies in this group do <i>NOT</i> benefit from this group's permissions</label>
	</td>
</tr>
<tr>
	<td>Group Name: </td>
	<td><input type="text" name="groupName" value="#HTMLEditFormat(Form.groupName)#" size="30" maxlength="#maxlength_Group.groupName#"></td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="groupID_custom" value="#HTMLEditFormat(Form.groupID_custom)#" size="30" maxlength="#maxlength_Group.groupID_custom#"> (optional; must be unique; for integration purposes)</td>
</tr>
<tr>
	<td>Category: </td>
	<td>
		<select name="groupCategory_select" size="1">
		<option value="">-- SELECT CATEGORY --</option>
		<cfloop Query="qry_selectGroupCategoryList">
			<option value="#HTMLEditFormat(qry_selectGroupCategoryList.groupCategory)#"<cfif Form.groupCategory_select is qry_selectGroupCategoryList.groupCategory> selected</cfif>>#HTMLEditFormat(qry_selectGroupCategoryList.groupCategory)#</option>
		</cfloop>
		</select>
		<i>New</i>: <input type="text" name="groupCategory_text" value="#HTMLEditFormat(Form.groupCategory_text)#" size="15" maxlength="#maxlength_Group.groupCategory#">
	</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="groupDescription" value="#HTMLEditFormat(Form.groupDescription)#" size="50" maxlength="#maxlength_Group.groupDescription#"> (optional)</td>
</tr>
</table>

<!--- Insert custom fields and custom status forms if necessary --->
<cfif isStatusExist is True>
	<cfinvoke component="#objInsertStatusHistory#" method="form_insertStatusHistory" returnVariable="isStatusHistoryForm" />
</cfif>
<cfif isCustomFieldValueExist is True>
	<cfinvoke component="#objInsertCustomFieldValue#" method="form_insertCustomFieldValue" returnVariable="isCustomFieldValueForm" />
</cfif>

<p><input type="submit" name="submitInsertUpdateGroup" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>