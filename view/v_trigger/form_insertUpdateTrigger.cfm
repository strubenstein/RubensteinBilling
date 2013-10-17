<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<form method="post" name="#Variables.formName#" Action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<p class="SubTitle">Action: <code>#URL.triggerAction#</code></p>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="triggerStatus" value="1"<cfif Form.triggerStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="triggerStatus" value="0"<cfif Form.triggerStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Filename: </td>
	<td><input type="text" name="triggerFilename" value="#HTMLEditFormat(Form.triggerFilename)#" size="30" maxlength="#maxlength_Trigger.triggerFilename#"></td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="triggerDescription" value="#HTMLEditFormat(Form.triggerDescription)#" size="50" maxlength="#maxlength_Trigger.triggerDescription#"></td>
</tr>
<tr>
	<td>Begin Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "triggerDateBegin", Form.triggerDateBegin, "", 00, "", 00, "", "am", True)# (defaults to today)</td>
</tr>
<tr>
	<td>End Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "triggerDateEnd", Form.triggerDateEnd, "", 00, "", 00, "", "am", True)# (optional)</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td><input type="submit" name="submitTrigger" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
