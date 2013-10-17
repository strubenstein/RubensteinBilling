<cfoutput>
<form method="post" name="IPaddress" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td>IP Address or Range: </td>
	<td>
		<input type="text" name="IPaddress" value="#HTMLEditFormat(Form.IPaddress)#" size="15" maxlength="#maxlength_IPaddress.IPaddress#">
		 thru <input type="text" name="IPaddress_max" value="#HTMLEditFormat(Form.IPaddress_max)#" size="15" maxlength="#maxlength_IPaddress.IPaddress_max#">
		<div class="TableText"><i>Only enter IP address in 2nd field if entering a range.</i></div>
	</td>
</tr>
<tr>
	<td>Browser Login: </td>
	<td><label><input type="checkbox" name="IPaddressBrowser" value="1"<cfif Form.IPaddressBrowser is 1> checked</cfif>> Users coming from this IP address may log into to the browser-based system</label></td>
</tr>
<tr>
	<td>Web Services Login: </td>
	<td><label><input type="checkbox" name="IPaddressWebService" value="1"<cfif Form.IPaddressWebService is 1> checked</cfif>> Users coming from this IP address may connect via Web Services (assuming user has permission)</label></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitIPaddress" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>