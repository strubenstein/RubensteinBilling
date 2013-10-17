<cfoutput>
<form method="post" name="insertCobrandHeader" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="0" cellpadding="2" class="TableText">
<tr>
	<td>Cobrand Header:&nbsp;</td>
	<td>
		<select name="cobrandHeaderHtml" size="1">
		<option value="0"<cfif Form.cobrandHeaderHtml is not 1> selected</cfif>>text</option>
		<option value="1"<cfif Form.cobrandHeaderHtml is 1> selected</cfif>>html</option>
		</select> (select format type)
	</td>
</tr>
<tr>
	<td colspan="2"><textarea name="cobrandHeaderText" rows="12" cols="60">#HTMLEditFormat(Form.cobrandHeaderText)#</textarea></td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td>Cobrand Footer:&nbsp;</td>
	<td>
		<select name="cobrandFooterHtml" size="1">
		<option value="0"<cfif Form.cobrandFooterHtml is not 1> selected</cfif>>text</option>
		<option value="1"<cfif Form.cobrandFooterHtml is 1> selected</cfif>>html</option>
		</select> (select format type)
	</td>
<tr>
	<td colspan="2"><textarea name="cobrandFooterText" rows="8" cols="60">#HTMLEditFormat(Form.cobrandFooterText)#</textarea></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitCobrandHeader" value="Update Header &amp; Footer"></td>
</tr>
</table>
</form>
</cfoutput>

