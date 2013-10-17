<cfoutput>
<form method="post" name="insertPhone" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<!--- 
<tr>
	<td>Status: </td>
	<td>
		<label><input type="radio" name="phoneStatus" value="1"<cfif Form.phoneStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label><input type="radio" name="phoneStatus" value="0"<cfif Form.phoneStatus is not 1> checked</cfif>> Inactive</label>
	</td>
</tr>
--->
<tr>
	<td>Phone Type: </td>
	<td>
		<select name="phoneType" size="1">
		<cfloop Index="count" From="1" To="#ListLen(Variables.phoneTypeList_value)#">
			<option value="#HTMLEditFormat(ListGetAt(Variables.phoneTypeList_value, count))#"<cfif Form.phoneType is ListGetAt(Variables.phoneTypeList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.phoneTypeList_label, count))#</option>
		</cfloop>
		</select>
	</td>
</tr>

<tr valign="top">
	<td>Phone Number: </td>
	<td>
		(<input type="text" name="phoneAreaCode" size="3" value="#HTMLEditFormat(Form.phoneAreaCode)#" maxlength="#maxlength_Phone.phoneAreaCode#">) 
		<input type="text" name="phoneNumber" size="8" value="#HTMLEditFormat(Form.phoneNumber)#" maxlength="#maxlength_Phone.phoneNumber#"> 
		ext. <input type="text" name="phoneExtension" size="4" value="#HTMLEditFormat(Form.phoneExtension)#" maxlength="#maxlength_Phone.phoneExtension#">
	</td>
</tr>

<tr>
	<td>Optional Description: </td>
	<td><input type="text" name="phoneDescription" size="40" value="#HTMLEditFormat(Form.phoneDescription)#" maxlength="#maxlength_Phone.phoneDescription#"></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitPhone" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>