<cfoutput>
<form method="post" name="insertTemplate" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td valign="top">Template Type: </td>
	<td>
		<cfif URL.templateID is 0>
			<!--- 
			<select name="templateType" size="1">
			<cfloop Index="count" From="1" To="#ListLen(Variables.var_templateTypeList_value)#">
				<option value="#HTMLEditFormat(ListGetAt(Variables.var_templateTypeList_value, count))#"<cfif Form.templateType is ListGetAt(Variables.var_templateTypeList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.var_templateTypeList_label, count))#</option>
			</cfloop>
			</select>
			<table border="0" cellspacing="0" cellpadding="0" class="MainText"><tr valign="top"><td>
			--->
			<cfloop Index="count" From="1" To="#ListLen(Variables.var_templateTypeList_value)#">
				<label><input type="radio" name="templateType" value="#ListGetAt(Variables.var_templateTypeList_value, count)#"<cfif Form.templateType is ListGetAt(Variables.var_templateTypeList_value, count)> checked</cfif>>#ListGetAt(Variables.var_templateTypeList_label, count)#</label><br>
				<!--- <cfif count is 3></td><td width="20">&nbsp;</td><td></cfif> --->
			</cfloop>
			<!--- </td></tr></table> --->
		<cfelse>
			<cfset Variables.typePosition = ListFind(Variables.var_templateTypeList_value, Form.templateType)>
			<cfif Variables.typePosition is not 0>
				<b>#ListGetAt(Variables.var_templateTypeList_label, Variables.typePosition)#</b>
			<cfelseif Form.templateType is "">
				(<i>no template type</i>)
			<cfelse>
				<b>#Form.templateType#</b>
			</cfif>
		</cfif>
	</td>
</tr>
<tr>
	<td>Template Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="templateStatus" value="1"<cfif Form.templateStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="templateStatus" value="0"<cfif Form.templateStatus is not 1> checked</cfif>> Disabled</label>
	</td>
</tr>
<tr valign="top">
	<td>Template Name: </td>
	<td>
		<input type="text" name="templateName" value="#HTMLEditFormat(Form.templateName)#" size="50" maxlength="#maxlength_Template.templateName#"> (must be unique)
		<cfif Variables.doAction is "copyTemplate"><div class="TableText"><i>Original</i>: #qry_selectTemplate.templateName#</div></cfif>
	</td>
</tr>
<cfif Variables.doAction is not "copyTemplate">
	<tr>
		<td>Template Filename: </td>
		<td><input type="text" name="templateFilename" value="#HTMLEditFormat(Form.templateFilename)#" size="20" maxlength="#maxlength_Template.templateFilename#"></td>
	</tr>
</cfif>
<tr>
	<td>Template Description: </td>
	<td><input type="text" name="templateDescription" value="#HTMLEditFormat(Form.templateDescription)#" size="50" maxlength="#maxlength_Template.templateDescription#"></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitTemplate" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>

</form>
</cfoutput>

