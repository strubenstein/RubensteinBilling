<cfoutput>
<script language="JavaScript">
function setTitle () {
	if (document.#Variables.formName#.customFieldTitle.value == "")
	document.#Variables.formName#.customFieldTitle.value = document.#Variables.formName#.customFieldName.value;
}

function setValue (count) {
	var fieldNameLabel = eval("document.#Variables.formName#.customFieldOptionLabel" + count);
	var fieldNameValue = eval("document.#Variables.formName#.customFieldOptionValue" + count);

	if (fieldNameValue.value == "")
		fieldNameValue.value = fieldNameLabel.value;
}

function hideOptions()
{
	var target = "advancedSearch";
	obj=(document.all) ? document.all[target] : document.getElementById(target);
	obj.style.display = 'none';
}

function showOptions()
{
	var target = "advancedSearch";
	obj=(document.all) ? document.all[target] : document.getElementById(target);
	obj.style.display = 'inline';
}
</script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td>Field Type: <div class="TableText">(cannot be<br>changed)</div></td>
	<td>
		<cfif Variables.doAction is "insertCustomField">
			<cfloop Index="count" From="1" To="#ListLen(Variables.customFieldTypeList_value, "^")#">
				<label><input type="radio" name="customFieldType" value="#ListGetAt(Variables.customFieldTypeList_value, count, "^")#"<cfif Form.customFieldType is ListGetAt(Variables.customFieldTypeList_value, count, "^")> checked</cfif>>#ListGetAt(Variables.customFieldTypeList_label, count, "^")#</label><br>
			</cfloop>
		<cfelse>
			<cfset Variables.typeRow = ListFind(Variables.customFieldTypeList_value, Form.customFieldType, "^")>
			<cfif Variables.typeRow is 0>
				#Form.customFieldType# (?)
			<cfelse>
				#ListGetAt(Variables.customFieldTypeList_label, Variables.typeRow, "^")#
			</cfif>
		</cfif>
	</td>
</tr>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="customFieldStatus" value="1"<cfif Form.customFieldStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="customFieldStatus" value="0"<cfif Form.customFieldStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr valign="top">
	<td>Name: </td>
	<td>
		<input type="text" name="customFieldName" value="#HTMLEditFormat(Form.customFieldName)#" size="50" maxlength="#maxlength_CustomField.customFieldName#" onBlur="javascript:setTitle();"> (must be unique)
	 	<div class="SmallText">If using for data import/export, use a valid variable name: A-Z, 0-9 and underscore only; first character must be a letter.</div>
	 </td>
</tr>
<tr>
	<td>Include in: </td>
	<td>
		<label><input type="checkbox" name="customFieldExportXml" value="1"<cfif Form.customFieldExportXml is 1> checked</cfif>>XML export</label> &nbsp; &nbsp; 
		<label><input type="checkbox" name="customFieldExportTab" value="1"<cfif Form.customFieldExportTab is 1> checked</cfif>>Tab-delimited export</label> &nbsp; &nbsp; 
		<!--- <label><input type="checkbox" name="customFieldExportHtml" value="1"<cfif Form.customFieldExportHtml is 1> checked</cfif>>Display in browser</label> --->
	 </td>
</tr>
<tr>
	<td>Internal: </td>
	<td>
		<label><input type="radio" name="customFieldInternal" value="1"<cfif Form.customFieldInternal is 1> checked</cfif>>Internal use only</label> &nbsp; &nbsp; 
		<label><input type="radio" name="customFieldInternal" value="0"<cfif Form.customFieldInternal is not 1> checked</cfif>>Available to customers</label> <font class="TableText">(<i>assuming they have access to custom fields in general</i>)</font>
	</td>
</tr>
<tr>
	<td>Title: </td>
	<td><input type="text" name="customFieldTitle" value="#HTMLEditFormat(Form.customFieldTitle)#" size="50" maxlength="#maxlength_CustomField.customFieldTitle#"> (displayed name; can be re-used)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="customFieldDescription" value="#HTMLEditFormat(Form.customFieldDescription)#" size="50" maxlength="#maxlength_CustomField.customFieldDescription#"> (for internal purposes)</td>
</tr>
<tr valign="top">
	<td>Target(s) that<br>field applies to: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="MainText"><tr valign="top"><td>
		<cfloop Index="count" From="1" To="#ListLen(Variables.customFieldTargetList_value)#">
			<cfset Variables.tableID = Application.fn_GetPrimaryTargetID(ListGetAt(Variables.customFieldTargetList_value, count))>
			<label><input type="checkbox" name="primaryTargetID" value="#Variables.tableID#"<cfif ListFind(Form.primaryTargetID, Variables.tableID)> checked</cfif>>#ListGetAt(Variables.customFieldTargetList_label, count)#</label><br>
			<cfif (count mod 3) is 0 and count is not ListLen(Variables.customFieldTargetList_value)></td><td width="5">&nbsp;</td><td></cfif>
		</cfloop>
		</td></tr></table>
	</td>
</tr>
<tr valign="top">
	<td>Form Type: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="MainText"><tr valign="top"><td>
		<cfloop Index="count" From="1" To="#ListLen(Variables.customFieldFormTypeList_value, "^")#">
			<cfset Variables.thisValue = ListGetAt(Variables.customFieldFormTypeList_value, count, "^")>
			<cfif count is 4></td><td width="5">&nbsp;</td><td></cfif>
			<label><input type="radio" name="customFieldFormType" value="#Variables.thisValue#"<cfif Form.customFieldFormType is Variables.thisValue> checked</cfif><cfif ListFind("text,textarea", Variables.thisValue)> onClick="hideOptions();"<cfelse> onClick="showOptions();"</cfif>>#ListGetAt(Variables.customFieldFormTypeList_label, count, "^")#</label><br>
		</cfloop>
		</td></tr></table>
	</td>
</tr>
</table>
<br>

<table border="0" cellspacing="0" cellpadding="3" id="advancedSearch"<cfif ListFind("text,textarea", Form.customFieldFormType)> style="display:none;"</cfif>>
<tr><td class="MainText" colspan="4" nowrap><b>Custom Field Options (<i>for select, radio and checkbox form types</i>)</b></td></tr>
<tr class="TableHeader" valign="bottom">
	<th>##</th>
	<th>Label Displayed<br>To Customer</th>
	<th>Value Stored<br>Internally</th>
	<th>Switch<br>Order</th>
</tr>

<cfloop Index="count" From="1" To="#Form.customFieldOptionCount#">
	<tr class="TableText" align="center"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td><b>#count#:</b></td>
		<td><input type="text" name="customFieldOptionLabel#count#" value="#HTMLEditFormat(Form["customFieldOptionLabel#count#"])#" size="20" maxlength="#maxlength_CustomFieldOption.customFieldOptionLabel#"<cfif Form["customFieldOptionLabel#count#"] is ""> onBlur="javascript:setValue(#count#);"</cfif>></td>
		<td><input type="text" name="customFieldOptionValue#count#" value="#HTMLEditFormat(Form["customFieldOptionValue#count#"])#" size="20" maxlength="#maxlength_CustomFieldOption.customFieldOptionValue#"></td>
		<td align="center">
			<cfif count is Form.customFieldOptionCount>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
			<cfelse>
				<input type="image" name="submitMoveCustomFieldOptionDown#count#" src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0">
			</cfif>
			<cfif count is 1>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
			<cfelse>
				<input type="image" name="submitMoveCustomFieldOptionUp#count#" src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0">
			</cfif>
		</td>
	</tr>
</cfloop>

<tr>
	<td colspan="5" class="TableText">
		Change ## of Options: <input type="text" name="customFieldOptionCount" value="#Form.customFieldOptionCount#" size="4"> 
		<input type="submit" name="submitCustomFieldOptionCount" value="Go"><br>
		Note: If value stored is blank, display name is used automatically.<br>
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Do not use commas in the value.
	</td>
</tr>
</table>

<p><input type="submit" name="submitCustomField" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>

