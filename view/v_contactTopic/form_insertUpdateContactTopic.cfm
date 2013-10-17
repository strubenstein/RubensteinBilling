<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.contactTopic.contactTopicTitle.value == "")
	document.contactTopic.contactTopicTitle.value = document.contactTopic.contactTopicName.value;
}
</script>

<form method="post" name="contactTopic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "insertContactTopic">
	<tr>
		<td>Order: </td>
		<td>
			<select name="contactTopicOrder" size="1">
			<cfloop Query="qry_selectContactTopicList">
				<option value="#qry_selectContactTopicList.contactTopicOrder#"<cfif Form.contactTopicOrder is qry_selectContactTopicList.contactTopicOrder> selected</cfif>>###qry_selectContactTopicList.contactTopicOrder#. #HTMLEditFormat(qry_selectContactTopicList.contactTopicName)#</option>
			</cfloop>
			<option value="0"<cfif Form.contactTopicOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		</td>
	</tr>
</cfif>

<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="contactTopicStatus" value="1"<cfif Form.contactTopicStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="contactTopicStatus" value="0"<cfif Form.contactTopicStatus is not 1> checked</cfif>>Inactive (not displayed to customer)</label>
	</td>
</tr>
<tr>
	<td>Internal Name: </td>
	<td><input type="text" name="contactTopicName" value="#HTMLEditFormat(Form.contactTopicName)#" size="40" maxlength="#maxlength_ContactTopic.contactTopicName#" onBlur="javascript:setTitle();"></td>
</tr>
<tr>
	<td>Public Name: </td>
	<td><input type="text" name="contactTopicTitle" value="#HTMLEditFormat(Form.contactTopicTitle)#" size="40" maxlength="#maxlength_ContactTopic.contactTopicTitle#"></td>
</tr>
<tr>
	<td>Send Notification To: </td>
	<td><input type="text" name="contactTopicEmail" value="#HTMLEditFormat(Form.contactTopicEmail)#" size="40" maxlength="#maxlength_ContactTopic.contactTopicEmail#"> (separate multiple email addresses with a comma)</td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitContactTopic" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>