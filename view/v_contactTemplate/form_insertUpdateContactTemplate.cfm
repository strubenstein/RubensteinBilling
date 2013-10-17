<cfoutput>

<script language="JavaScript">
<!-- Begin
theContactTemplateOrder = new Array(
<cfset Variables.thisPrimaryTargetID = 0>
<cfset Variables.primaryTargetRow = ListFind(ValueList(qry_selectContactTemplateList.primaryTargetID), Variables.thisPrimaryTargetID)>
new Array(
<cfif Variables.primaryTargetRow is 0>
	new Array("-- LAST --", 0)
<cfelse>
	<cfloop Query="qry_selectContactTemplateList" StartRow="#Variables.primaryTargetRow#">
		<cfif qry_selectContactTemplateList.primaryTargetID is not Variables.thisPrimaryTargetID><cfbreak></cfif>
		new Array("Before ###qry_selectContactTemplateList.contactTemplateOrder#. #qry_selectContactTemplateList.contactTemplateName#", #qry_selectContactTemplateList.contactTemplateOrder#),
	</cfloop>
	new Array("-- LAST --", 0)
</cfif>
),
<cfloop Query="qry_selectPrimaryTargetList">
	new Array(
	<cfset Variables.thisPrimaryTargetID = qry_selectPrimaryTargetList.primaryTargetID>
	<cfset Variables.primaryTargetRow = ListFind(ValueList(qry_selectContactTemplateList.primaryTargetID), Variables.thisPrimaryTargetID)>
	<cfif Variables.primaryTargetRow is 0>
		new Array("-- LAST --", 0)
	<cfelse>
		<cfloop Query="qry_selectContactTemplateList" StartRow="#Variables.primaryTargetRow#">
			<cfif qry_selectContactTemplateList.primaryTargetID is not Variables.thisPrimaryTargetID><cfbreak></cfif>
			new Array("Before ###qry_selectContactTemplateList.contactTemplateOrder#. #qry_selectContactTemplateList.contactTemplateName#", #qry_selectContactTemplateList.contactTemplateOrder#),
		</cfloop>
		new Array("-- LAST --", 0)
	</cfif>
	)<cfif qry_selectPrimaryTargetList.CurrentRow is not qry_selectPrimaryTargetList.RecordCount>,</cfif>
</cfloop>
);

function fillSelectFromArray(selectCtrl, itemArray, goodPrompt, badPrompt, defaultItem)
{
	var i, j;
	var prompt;

	// empty existing items
	for (i = selectCtrl.options.length; i >= 0; i--) {
		selectCtrl.options[i] = null; 
	}

	prompt = (itemArray != null) ? goodPrompt : badPrompt;
	if (prompt == null) {
		j = 0;
	}
	else {
		selectCtrl.options[0] = new Option(prompt);
		j = 1;
	}

	if (itemArray != null) {
		// add new items
		for (i = 0; i < itemArray.length; i++) {
			selectCtrl.options[j] = new Option(itemArray[i][0]);
			if (itemArray[i][1] != null) {
				selectCtrl.options[j].value = itemArray[i][1]; 
			}
			j++;
		}

		// select first item (prompt) for sub list
		selectCtrl.options[0].selected = true;
   }
}
//  End -->
</script>

<form method="post" name="contactTemplate" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Target: </td>
	<td>
		<!--- 
		<cfif Variables.doAction is "insertContactTemplate" and URL.primaryTargetID is 0>
			All Contact Management (no specific target)
		<cfelseif Variables.doAction is "insertContactTemplate" and URL.primaryTargetID is not -1>
			#qry_selectPrimaryTargetList.primaryTargetName[ListFind(ValueList(qry_selectPrimaryTargetList.primaryTargetID), URL.primaryTargetID)]#
		<cfelse>
		--->
			<select name="primaryTargetID" size="1"<cfif Variables.doAction is "insertContactTemplate"> onChange="fillSelectFromArray(this.document.contactTemplate.contactTemplateOrder, ((this.selectedIndex == -1) ? null : theContactTemplateOrder[this.selectedIndex]));"</cfif>>
			<option value="0"<cfif Form.primaryTargetID is 0> selected</cfif>>-- ALL --</option>
			<cfloop Query="qry_selectPrimaryTargetList">
				<option value="#qry_selectPrimaryTargetList.primaryTargetID#"<cfif Form.primaryTargetID is qry_selectPrimaryTargetList.primaryTargetID> selected</cfif>>#HTMLEditFormat(qry_selectPrimaryTargetList.primaryTargetName)#</option>
			</cfloop>
			</select>
		<!--- </cfif> --->
	</td>
</tr>

<cfif Variables.doAction is "insertContactTemplate">
	<tr>
		<td>Order: </td>
		<td>
			<select name="contactTemplateOrder" size="1">
			<cfset Variables.primaryTargetRow = ListFind(ValueList(qry_selectContactTemplateList.primaryTargetID), Form.primaryTargetID)>
			<cfif Variables.primaryTargetRow is not 0>
				<cfloop Query="qry_selectContactTemplateList" StartRow="#Variables.primaryTargetRow#">
					<cfif qry_selectContactTemplateList.primaryTargetID is not Form.primaryTargetID><cfbreak></cfif>
					<option value="#qry_selectContactTemplateList.contactTemplateOrder#"<cfif Form.contactTemplateOrder is qry_selectContactTemplateList.contactTemplateOrder> selected</cfif>>Before ###qry_selectContactTemplateList.contactTemplateOrder#. #HTMLEditFormat(qry_selectContactTemplateList.contactTemplateName)#</option>
				</cfloop>
			</cfif>
			<option value="0"<cfif Form.contactTemplateOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
			<!--- 
			<cfif URL.primaryTargetID is -1>
				Last (must pre-select target to choose order)
			<cfelse>
				<select name="contactTemplateOrder" size="1">
				<cfloop Query="qry_selectContactTemplateList">
					<option value="#qry_selectContactTemplateList.contactTemplateOrder#"<cfif Form.contactTemplateOrder is qry_selectContactTemplateList.contactTemplateOrder> selected</cfif>>Before ###qry_selectContactTemplateList.contactTemplateOrder#. #HTMLEditFormat(qry_selectContactTemplateList.contactTemplateName)#</option>
				</cfloop>
				<option value="0"<cfif Form.contactTemplateOrder is 0> selected</cfif>>-- LAST --</option>
				</select>
			</cfif>
			--->
		</td>
	</tr>
</cfif>

<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="contactTemplateStatus" value="1"<cfif Form.contactTemplateStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="contactTemplateStatus" value="0"<cfif Form.contactTemplateStatus is not 1> checked</cfif>>Inactive (not listed)</label>
	</td>
</tr>
<tr>
	<td>Name: </td>
	<td><input type="text" name="contactTemplateName" value="#HTMLEditFormat(Form.contactTemplateName)#" size="40" maxlength="#maxlength_ContactTemplate.contactTemplateName#"></td>
</tr>
<tr>
	<td>Subject: </td>
	<td><input type="text" name="contactTemplateSubject" value="#HTMLEditFormat(Form.contactTemplateSubject)#" size="40" maxlength="#maxlength_ContactTemplate.contactTemplateSubject#"></td>
</tr>
<tr>
	<td>From Name: </td>
	<td><input type="text" name="contactTemplateFromName" value="#HTMLEditFormat(Form.contactTemplateFromName)#" size="40" maxlength="#maxlength_ContactTemplate.contactTemplateFromName#"> (who email is from)</td>
</tr>
<tr>
	<td>Reply-To: </td>
	<td><input type="text" name="contactTemplateReplyTo" value="#HTMLEditFormat(Form.contactTemplateReplyTo)#" size="40" maxlength="#maxlength_ContactTemplate.contactTemplateReplyTo#"> (email address)</td>
</tr>
<tr>
	<td>CC: </td>
	<td><input type="text" name="contactTemplateCC" value="#HTMLEditFormat(Form.contactTemplateCC)#" size="40" maxlength="#maxlength_ContactTemplate.contactTemplateCC#"> (separate multiple email addresses with a comma)</td>
</tr>
<tr>
	<td>BCC: </td>
	<td><input type="text" name="contactTemplateBCC" value="#HTMLEditFormat(Form.contactTemplateBCC)#" size="40" maxlength="#maxlength_ContactTemplate.contactTemplateBCC#"> (separate multiple email addresses with a comma)</td>
</tr>
<tr>
	<td>HTML: </td>
	<td><label><input type="checkbox" name="contactTemplateHtml" value="1"<cfif Form.contactTemplateHtml is 1> checked</cfif>> Check if message is in html format</label></td>
</tr>
<tr>
	<td valign="top">Message: </td>
	<td><textarea name="contactTemplateMessage" rows="16" cols="80" wrap="soft">#HTMLEditFormat(Form.contactTemplateMessage)#</textarea></td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitContactTemplate" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>