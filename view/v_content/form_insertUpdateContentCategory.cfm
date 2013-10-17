<cfoutput>
<form method="post" name="insertContentCategory" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "insertContentCategory">
	<tr>
		<td>Order: </td>
		<td>
			<select name="contentCategoryOrder" size="1">
			<cfloop Query="qry_selectContentCategoryList">
				<option value="#qry_selectContentCategoryList.contentCategoryOrder#"<cfif Form.contentCategoryOrder is qry_selectContentCategoryList.contentCategoryOrder> selected</cfif>>Before ###qry_selectContentCategoryList.contentCategoryOrder#. #HTMLEditFormat(qry_selectContentCategoryList.contentCategoryName)#</option>
			</cfloop>
			<option value="0"<cfif Form.contentCategoryOrder is 0> selected</cfif>>-- Last Category --</option>
			</select>
		</td>
	</tr>
</cfif>

<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="contentCategoryStatus" value="1"<cfif Form.contentCategoryStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label style="color: red"><input type="radio" name="contentCategoryStatus" value="0"<cfif Form.contentCategoryStatus is not 1> checked</cfif>> Inactive</label>
	</td>
</tr>

<tr>
	<td>Category Name: </td>
	<td><input type="text" name="contentCategoryName" size="50" value="#HTMLEditFormat(Form.contentCategoryName)#" maxlength="#maxlength_ContentCategory.contentCategoryName#"> (must be unique)</td>
</tr>

<tr>
	<td>Category Code: </td>
	<td><input type="text" name="contentCategoryCode" size="25" value="#HTMLEditFormat(Form.contentCategoryCode)#" maxlength="#maxlength_ContentCategory.contentCategoryCode#"> (must be unique; used for querying)</td>
</tr>

<tr>
	<td>Optional Description: </td>
	<td><input type="text" name="contentCategoryDescription" size="50" value="#HTMLEditFormat(Form.contentCategoryDescription)#" maxlength="#maxlength_ContentCategory.contentCategoryDescription#"></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitContentCategory" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>