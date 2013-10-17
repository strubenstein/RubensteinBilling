<!--- languageID --->

<cfoutput>
<form method="post" name="productLanguageCreate" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="0" cellpadding="2" class="TableText">
<tr>
	<td>Product Name as listed on invoice: </td>
	<td><input type="text" name="productLanguageLineItemName" value="#HTMLEditFormat(Form.productLanguageLineItemName)#" size="50" maxlength="#maxlength_ProductLanguage.productLanguageName#"></td>
</tr>

<tr valign="top">
	<td colspan="2">
		Product summary as listed on invoice: 
		<select name="productLanguageLineItemDescriptionHtml" size="1">
		<option value="0"<cfif Form.productLanguageLineItemDescriptionHtml is not 1> selected</cfif>>text</option>
		<option value="1"<cfif Form.productLanguageLineItemDescriptionHtml is 1> selected</cfif>>html</option>
		</select> 
		(maximum #maxlength_ProductLanguage.productLanguageLineItemDescription# characters)
	</td>
</tr>
<tr valign="top">
	<td colspan="2"><textarea name="productLanguageLineItemDescription" rows="5" cols="90" wrap="soft">#HTMLEditFormat(Form.productLanguageLineItemDescription)#</textarea></td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td>Product Name as displayed on site: </td>
	<td><input type="text" name="productLanguageName" value="#HTMLEditFormat(Form.productLanguageName)#" size="50" maxlength="#maxlength_ProductLanguage.productLanguageName#"></td>
</tr>

<tr valign="top">
	<td colspan="2">
		Product Summary as displayed on site: 
		<select name="productLanguageSummaryHtml" size="1">
		<option value="0"<cfif Form.productLanguageSummaryHtml is not 1> selected</cfif>>text</option>
		<option value="1"<cfif Form.productLanguageSummaryHtml is 1> selected</cfif>>html</option>
		</select> 
		(maximum #maxlength_ProductLanguage.productLanguageSummary# characters)
	</td>
</tr>
<tr valign="top">
	<td colspan="2"><textarea name="productLanguageSummary" rows="5" cols="90" wrap="soft">#HTMLEditFormat(Form.productLanguageSummary)#</textarea></td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr valign="top">
	<td colspan="2">
		Product description as displayed on site: 
		<select name="productLanguageDescriptionHtml" size="1">
		<option value="0"<cfif Form.productLanguageDescriptionHtml is not 1> selected</cfif>>text</option>
		<option value="1"<cfif Form.productLanguageDescriptionHtml is 1> selected</cfif>>html</option>
		</select>
		<cfif maxlength_ProductLanguage.productLanguageDescription is 0>(no size limit)<cfelse>(maximum #maxlength_ProductLanguage.productLanguageDescription# characters)</cfif>
	</td>
</tr>
<tr>
	<td colspan="2"><textarea name="productLanguageDescription" rows="15" cols="90" wrap="soft">#HTMLEditFormat(Form.productLanguageDescription)#</textarea></td>
</tr>

<tr height="40" valign="bottom">
	<td></td>
	<td><input type="submit" name="submitProductLanguage" value="Update Product Language"></td>
</tr>
</table>

</form>
</cfoutput>

