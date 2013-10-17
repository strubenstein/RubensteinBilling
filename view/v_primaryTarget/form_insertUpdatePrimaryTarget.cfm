<cfoutput>
<form method="post" name="primaryTarget" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="primaryTargetStatus" value="1"<cfif Form.primaryTargetStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="primaryTargetStatus" value="0"<cfif Form.primaryTargetStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Table Name: </td>
	<td><input type="text" name="primaryTargetTable" value="#HTMLEditFormat(Form.primaryTargetTable)#" size="40" maxlength="#maxlength_PrimaryTarget.primaryTargetTable#"></td>
</tr>
<tr>
	<td>Primary Key Field: </td>
	<td><input type="text" name="primaryTargetKey" value="#HTMLEditFormat(Form.primaryTargetKey)#" size="40" maxlength="#maxlength_PrimaryTarget.primaryTargetKey#"></td>
</tr>
<tr>
	<td>Public Display Name: </td>
	<td><input type="text" name="primaryTargetName" value="#HTMLEditFormat(Form.primaryTargetName)#" size="40" maxlength="#maxlength_PrimaryTarget.primaryTargetName#"></td>
</tr>
<tr>
	<td>Internal Description: </td>
	<td><input type="text" name="primaryTargetDescription" value="#HTMLEditFormat(Form.primaryTargetDescription)#" size="40" maxlength="#maxlength_PrimaryTarget.primaryTargetDescription#"></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitPrimaryTarget" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>