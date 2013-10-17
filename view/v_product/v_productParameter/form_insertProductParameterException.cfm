<cfoutput>
<form method="post" name="insertProductParameterException" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<div class="MainText">
Description: <input type="text" name="productParameterExceptionDescription" value="#HTMLEditFormat(Form.productParameterExceptionDescription)#" size="50" maxlength="#maxlength_ProductParameterException.productParameterExceptionDescription#"><br>
<br>
<b>Select the parameter combinations that trigger this exception.</b><br>
<div class="TableText">
- The exception applies to any combination that includes the selected options.<br>
&nbsp; &nbsp; So if the customer selects the option(s) along with any other options, the exception is triggered.<br>
&nbsp; &nbsp; For instance, if there are 2 parameters, <i>color</i> and <i>size</i> where the color <i>purple</i> is more expensive<br>
&nbsp; &nbsp; regardless of the size, simply selecting the color purple will trigger the exception for all sizes.<br>
- To exclude a combination, you must select at least two parameter options.
<cfif qry_selectProductParameterList.RecordCount gt 4><br>- You may select a maximum of 4 parameter options.</cfif>
</div>
</div>

<p>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfloop Query="qry_selectProductParameterList">
	<cfset Variables.parameterOptionRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterID), qry_selectProductParameterList.productParameterID)>
	<cfif Variables.parameterOptionRow is not 0>
		<tr valign="top">
			<td>#qry_selectProductParameterList.productParameterName#: </td>
			<td>
				<cfset Variables.thisParameterID = qry_selectProductParameterList.productParameterID>
				<select name="productParameterOptionID" size="1">
				<option value="0">-- SELECT OPTION --</option>
				<cfloop Query="qry_selectProductParameterOptionList" StartRow="#Variables.parameterOptionRow#">
					<cfif qry_selectProductParameterOptionList.productParameterID is not Variables.thisParameterID><cfbreak></cfif>
					<option value="#qry_selectProductParameterOptionList.productParameterOptionID#"<cfif ListFind(Form.productParameterOptionID, qry_selectProductParameterOptionList.productParameterOptionID)> selected</cfif>>#HTMLEditFormat(qry_selectProductParameterOptionList.productParameterOptionLabel)#</option>
				</cfloop>
				</select>
			</td>
		</tr>
	</cfif>
</cfloop>
</table>
</p>

<p>
<b>Select the result of the exception: excluded, price premium or text warning.</b><br>
The warning is displayed to the customer and may be combined with the other options.<br>
It is recommended since it is used to display the exception to the customer.
</p>

<p>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Excluded: </td>
	<td>
		<cfif qry_selectProductParameterList.RecordCount is 1>
			<div class="TableText">N/A - You must have at least 2 parameters to exclude a combination.</div>
		<cfelse>
			<label><input type="checkbox" name="productParameterExceptionExcluded" value="1"<cfif Form.productParameterExceptionExcluded is 1> checked</cfif>>
			Check if this combination of parameters is not available.</label>
		</cfif>
	</td>
</tr>
<tr>
	<td>Price Premium: </td>
	<td>$<input type="text" name="productParameterExceptionPricePremium" value="#HTMLEditFormat(Form.productParameterExceptionPricePremium)#" size="10"> (enter negative number if discount; #maxlength_ProductParameterException.productParameterExceptionPricePremium# decimal places max)</td>
</tr>
<tr>
	<td>Text Warning: </td>
	<td><input type="text" name="productParameterExceptionText" value="#HTMLEditFormat(Form.productParameterExceptionText)#" size="50" maxlength="#maxlength_ProductParameterException.productParameterExceptionDescription#"></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitProductParameterException" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>