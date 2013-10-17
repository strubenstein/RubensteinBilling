<cfoutput>
<form method="post" name="insertUpdateTriggerAction" Action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Order: </td>
	<td>
		<cfif URL.triggerAction is "">
			<select name="triggerActionOrder" size="1">
			<cfloop Query="qry_selectTriggerActionList">
				<option value="#qry_selectTriggerActionList.triggerActionOrder#"<cfif Form.triggerActionOrder is qry_selectTriggerActionList.triggerActionOrder> selected</cfif>>Before ###qry_selectTriggerActionList.triggerActionOrder#. #HTMLEditFormat(qry_selectTriggerActionList.triggerAction)#</option>
			</cfloop>
			<option value="0"<cfif Form.triggerActionOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		<cfelse>
			#Form.triggerActionOrder#
		</cfif>
	</td>
</tr>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="triggerActionStatus" value="1"<cfif Form.triggerActionStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="triggerActionStatus" value="0"<cfif Form.triggerActionStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr valign="top">
	<td>Server Mgr Only: </td>
	<td>
		<label><input type="checkbox" name="triggerActionSuperuserOnly" value="1"<cfif Form.triggerActionSuperuserOnly is 1> checked</cfif>> 
		If checked, permission is available only to users of company that manages<br>
		&nbsp; &nbsp; &nbsp;  this server and is not displayed on trigger form for other users or groups.</label>
	</td>
</tr>
<tr>
	<td>Module: </td>
	<td>
		<select name="triggerActionControl_select" size="1">
		<option value="">-- SELECT MODULE --</option>
		<cfloop Query="qry_selectTriggerActionList">
			<cfif CurrentRow is 1 or qry_selectTriggerActionList.triggerActionControl is not qry_selectTriggerActionList.triggerActionControl[CurrentRow - 1]>
				<option value="#qry_selectTriggerActionList.triggerActionControl#"<cfif Form.triggerActionControl_select is qry_selectTriggerActionList.triggerActionControl> selected</cfif>>#HTMLEditFormat(qry_selectTriggerActionList.triggerActionControl)#</option>
			</cfif>
		</cfloop>
		</select>
		<i>New</i>: <input type="text" name="triggerActionControl_text" value="#HTMLEditFormat(Form.triggerActionControl_text)#" size="20" maxlength="#maxlength_TriggerAction.triggerActionControl#">
	</td>
</tr>
<tr>
	<td>Action: </td>
	<td><cfif URL.triggerAction is not ""><b><code>#URL.triggerAction#</code></b><cfelse><input type="text" name="triggerAction" value="#HTMLEditFormat(Form.triggerAction)#" size="40" maxlength="#maxlength_TriggerAction.triggerAction#"></cfif></td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="triggerActionDescription" value="#HTMLEditFormat(Form.triggerActionDescription)#" size="40" maxlength="#maxlength_TriggerAction.triggerActionDescription#"></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitTriggerAction" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
