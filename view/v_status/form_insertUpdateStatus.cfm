<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.insertUpdateStatus.statusTitle.value == "")
	document.insertUpdateStatus.statusTitle.value = document.insertUpdateStatus.statusName.value;
}
</script>

<form method="post" name="insertUpdateStatus" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "insertStatus">
	<tr>
		<td>Order: </td>
		<td>
			<select name="statusOrder" size="1">
			<cfloop Query="qry_selectStatusList">
				<option value="#qry_selectStatusList.statusOrder#"<cfif Form.statusOrder is qry_selectStatusList.statusOrder> selected</cfif>>###qry_selectStatusList.statusOrder#. #HTMLEditFormat(qry_selectStatusList.statusName)#</option>
			</cfloop>
			<option value="0"<cfif Form.statusOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		</td>
	</tr>
</cfif>

<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="statusStatus" value="1"<cfif Form.statusStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="statusStatus" value="0"<cfif Form.statusStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Internal Name: </td>
	<td><input type="text" name="statusName" value="#HTMLEditFormat(Form.statusName)#" size="40" maxlength="#maxlength_Status.statusName#" onBlur="javascript:setTitle();"> (must be unique; used for export value)</td>
</tr>
<tr>
	<td>Public Name: </td>
	<td><input type="text" name="statusTitle" value="#HTMLEditFormat(Form.statusTitle)#" size="40" maxlength="#maxlength_Status.statusTitle#"> (displayed to customer; can be re-used)</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="statusID_custom" value="#HTMLEditFormat(Form.statusID_custom)#" size="20" maxlength="#maxlength_Status.statusID_custom#"></td>
</tr>
<!--- 
<tr>
	<td>Display to Customer: </td>
	<td><label><input type="checkbox" name="statusDisplayToCustomer" value="1"<cfif Form.statusDisplayToCustomer is 1> checked</cfif>>Display status to customer</label></td>
</tr>
--->
<tr>
	<td>Description: </td>
	<td><input type="text" name="statusDescription" value="#HTMLEditFormat(Form.statusDescription)#" size="40" maxlength="#maxlength_Status.statusDescription#"></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitStatus" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>