<cfoutput>
<script language="JavaScript">
function setText () {
	if (document.#Variables.formName#.productParameterText.value == "")
	document.#Variables.formName#.productParameterText.value = document.#Variables.formName#.productParameterName.value;
}

function setValue (count) {
	var fieldNameLabel = eval("document.#Variables.formName#.productParameterOptionLabel" + count);
	var fieldNameValue = eval("document.#Variables.formName#.productParameterOptionValue" + count);

	if (fieldNameValue.value == "")
		fieldNameValue.value = fieldNameLabel.value;
}
</script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Order: </td>
	<td>
		<cfif URL.productParameterID is 0>
			<select name="productParameterOrder" size="1">
			<cfloop Query="qry_selectProductParameterList">
				<option value="0"<cfif Form.productParameterOrder is qry_selectProductParameterList.productParameterOrder> selected</cfif>>BEFORE ###qry_selectProductParameterList.productParameterOrder#. #HTMLEditFormat(qry_selectProductParameterList.productParameterName)#</option>
			</cfloop>
			<option value="0"<cfif Form.productParameterOrder is 0> selected</cfif>>-- LAST --</option>
			</select> 
			(order in which parameter is listed when selecting)
		<cfelse>
			#Form.productParameterOrder# <font class="TableText">(<i>to change, switch order via list of parameters</i>)</font>
		</cfif>
	</td>
</tr>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="productParameterStatus" value="1"<cfif Form.productParameterStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="productParameterStatus" value="0"<cfif Form.productParameterStatus is not 1> checked</cfif>>Not Active</label>
	</td>
</tr>
<tr>
	<td>Required: </td>
	<td>
		<label style="color: green"><input type="radio" name="productParameterRequired" value="1"<cfif Form.productParameterRequired is 1> checked</cfif>>Yes</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="productParameterRequired" value="0"<cfif Form.productParameterRequired is not 1> checked</cfif>>No</label>
	</td>
</tr>
<tr>
	<td>Name: </td>
	<td>
		<input type="text" name="productParameterName" value="#HTMLEditFormat(Form.productParameterName)#" size="30" maxlength="#maxlength_ProductParameter.productParameterName#" onBlur="javascript:setText();"> (internal; must be unique for product)
	 	<div class="SmallText">If using for data import/export, use a valid variable name: A-Z, 0-9 and underscore only; first character must be a letter.</div>
	</td>
</tr>
<tr>
	<td>Text: </td>
	<td><input type="text" name="productParameterText" value="#HTMLEditFormat(Form.productParameterText)#" size="30" maxlength="#maxlength_ProductParameter.productParameterText#"> (displayed to customer)</td>
</tr>
<tr>
	<td>Include in: </td>
	<td>
		<label><input type="checkbox" name="productParameterExportXml" value="1"<cfif Form.productParameterExportXml is 1> checked</cfif>>XML export</label> &nbsp; &nbsp; 
		<label><input type="checkbox" name="productParameterExportTab" value="1"<cfif Form.productParameterExportTab is 1> checked</cfif>>Tab-delimited export</label> &nbsp; &nbsp; 
		<!--- <label><input type="checkbox" name="productParameterExportHtml" value="1"<cfif Form.productParameterExportHtml is 1> checked</cfif>>Display in browser</label> --->
	 </td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="productParameterDescription" value="#HTMLEditFormat(Form.productParameterDescription)#" size="40" maxlength="#maxlength_ProductParameter.productParameterDescription#"> (internal)</td>
</tr>
<tr>
	<td>Image: </td>
	<td><input type="text" name="productParameterImage" value="#HTMLEditFormat(Form.productParameterImage)#" size="40" maxlength="#maxlength_ProductParameter.productParameterImage#"> (url to optional image that explains/describes parameter)</td>
</tr>
<tr valign="top">
	<td>Code: </td>
	<td>
		<label><input type="checkbox" name="productParameterCodeStatus" value="1"<cfif Form.productParameterCodeStatus is 1> checked</cfif>> Add code from selected parameter option to product custom ID</label><br>
		&nbsp; &nbsp; &nbsp; <i>Code Order</i>: 
		<cfif URL.productParameterID is 0>
			<select name="productParameterCodeOrder" size="1">
			<cfloop Query="qry_selectProductParameterList">
				<cfif qry_selectProductParameterList.productParameterCodeOrder is not 0>
					<option value="#qry_selectProductParameterList.productParameterCodeOrder#"<cfif Form.productParameterCodeOrder is qry_selectProductParameterList.productParameterCodeOrder> selected</cfif>>BEFORE ###qry_selectProductParameterList.productParameterCodeOrder#. #HTMLEditFormat(qry_selectProductParameterList.productParameterCodeOrder)#</option>
				</cfif>
			</cfloop>
			<option value="0"<cfif Form.productParameterCodeOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		<cfelseif Form.productParameterCodeOrder is not 0>
			#Form.productParameterCodeOrder# <font class="TableText">(<i>to change, switch order via list of parameters</i>)</font>
		<cfelse>
			<font class="TableText">(<i>If enabled, will be added to end of list. Order can be switched via the list of parameters.</i>)</font>
		</cfif>
	</td>
</tr>
</table>
<br>

<div class="MainText"><b>Parameter Options</b></div>
<table border="0" cellspacing="0" cellpadding="3">
<tr class="TableHeader" valign="bottom">
	<th>##</th>
	<th>Label Displayed<br>To Customer</th>
	<th>Value Stored<br>Internally</th>
	<th>Code Added To<br>Custom Product ID</th>
	<th>Optional URL to Image<br>That Describes Option</th>
	<th>Switch<br>Order</th>
</tr>

<cfloop Index="count" From="1" To="#Form.productParameterOptionCount#">
	<tr class="TableText" align="center"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><b>#count#:</b></td>
		<td><input type="text" name="productParameterOptionLabel#count#" value="#HTMLEditFormat(Form["productParameterOptionLabel#count#"])#" size="20" maxlength="#maxlength_ProductParameterOption.productParameterOptionLabel#"<cfif Form["productParameterOptionLabel#count#"] is ""> onBlur="javascript:setValue(#count#);"</cfif>></td>
		<td><input type="text" name="productParameterOptionValue#count#" value="#HTMLEditFormat(Form["productParameterOptionValue#count#"])#" size="20" maxlength="#maxlength_ProductParameterOption.productParameterOptionValue#"></td>
		<td><input type="text" name="productParameterOptionCode#count#" value="#HTMLEditFormat(Form["productParameterOptionCode#count#"])#" size="5" maxlength="#maxlength_ProductParameterOption.productParameterOptionCode#"></td>
		<td><input type="text" name="productParameterOptionImage#count#" value="#HTMLEditFormat(Form["productParameterOptionImage#count#"])#" size="30" maxlength="#maxlength_ProductParameterOption.productParameterOptionImage#"></td>
		<td align="center">
			<cfif count is Form.productParameterOptionCount>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
			<cfelse>
				<input type="image" name="submitMoveProductParameterOptionDown#count#" src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0">
			</cfif>
			<cfif count is 1>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
			<cfelse>
				<input type="image" name="submitMoveProductParameterOptionUp#count#" src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0">
			</cfif>
		</td>
	</tr>
</cfloop>

<tr>
	<td colspan="5" class="TableText">
		Change ## of Options: <input type="text" name="productParameterOptionCount" value="#Form.productParameterOptionCount#" size="4"> 
		<input type="submit" name="submitProductParameterOptionCount" value="Go"><br>
		Note: If value stored is blank, display name is used automatically.
	</td>
</tr>
</table>

<p><input type="submit" name="submitProductParameter" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>
