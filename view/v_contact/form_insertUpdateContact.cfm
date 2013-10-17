<!--- 
contactID_orig
contactReplied
contactID_custom
contactTopicID
contactFax
contactEmail
--->

<cfoutput>
<cfif Variables.doAction is "insertContact" and qry_selectContactTemplateList.RecordCount is not 0>
	<form method="get" action="">
	<p class="TableText"><b>Select Contact Management Template: </b>
	<select name="contactTemplateID" size="1" onChange="window.open(this.options[this.selectedIndex].value,'_main')">
	<option value="#Variables.formAction#">-- CONTACT MGMT. TEMPLATE --</option>
	<cfloop Query="qry_selectContactTemplateList">
		<option value="#Variables.formAction#&contactTemplateID=#qry_selectContactTemplateList.contactTemplateID#"<cfif URL.contactTemplateID is qry_selectContactTemplateList.contactTemplateID> selected</cfif>>#HTMLEditFormat(qry_selectContactTemplateList.contactTemplateName)#</option>
	</cfloop>
	</select><br>
	(Note: Select template <i>before</i> entering any text in the form below.)
	</p>
	</form>
</cfif>

<form method="post" name="contact" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="contactTemplateID" value="#Form.contactTemplateID#">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "replyToContact" and URL.contactID is not 0 and IsDefined("qry_selectContact")>
	<tr><td colspan="2"><label><input type="checkbox" name="contactStatus_orig" value="1"<cfif qry_selectContact.contactReplied is 1> checked</cfif>> <b>Check to indicate this contact issue has been successfully resolved.</b></label></td></tr>
</cfif>

<cfif Variables.doAction is "updateContact" and IsDefined("qry_selectContact") and qry_selectContact.contactByCustomer is 1>
	<tr>
		<td>Status: </td>
		<td>
			<label style="color: green"><input type="radio" name="contactStatus" value="1"<cfif Form.contactStatus is 1> checked</cfif>>Resolved</label> &nbsp; 
			<label style="color: red"><input type="radio" name="contactStatus" value="0"<cfif Form.contactStatus is not 1> checked</cfif>>Not Yet Resolved</label>
		</td>
	</tr>
</cfif>

<cfif Variables.displayPartners is True>
	<tr valign="top">
		<td>Optional Partner: </td>
		<td>
			<select name="primaryTargetKey_targetID_userID_partner" size="1">
			<option value="">-- SELECT PARTNER --</option>
			<cfif Variables.displayAffiliate is True>
				<option value="">-- AFFILIATE --</option>
				<option value="affiliateID_#qry_selectAffiliateList.affiliateID#_0"<cfif primaryTargetKey_targetID_userID_partner is "affiliateID_#qry_selectAffiliateList.affiliateID#_0"> selected</cfif>>#Left(HTMLEditFormat(qry_selectAffiliateList.affiliateName), 100)#</option>
				<cfif qry_selectAffiliateList.userID is not 0>
					<option value="affiliateID_#qry_selectAffiliateList.affiliateID#_#qry_selectAffiliateList.userID#"<cfif primaryTargetKey_targetID_userID_partner is "affiliateID_#qry_selectAffiliateList.affiliateID#_#qry_selectAffiliateList.userID#"> selected</cfif>>+ Contact: #HTMLEditFormat(qry_selectAffiliateList.lastName)#, #HTMLEditFormat(qry_selectAffiliateList.firstName)#</option>
				</cfif>
			</cfif>
			<cfif Variables.displayCobrand is True>
				<option value="">-- COBRAND --</option>
				<option value="cobrandID_#qry_selectCobrandList.cobrandID#_0"<cfif primaryTargetKey_targetID_userID_partner is "cobrandID_#qry_selectCobrandList.cobrandID#_0"> selected</cfif>>#Left(HTMLEditFormat(qry_selectCobrandList.cobrandName), 100)#</option>
				<cfif qry_selectCobrandList.userID is not 0>
					<option value="cobrandID_#qry_selectCobrandList.cobrandID#_#qry_selectCobrandList.userID#"<cfif primaryTargetKey_targetID_userID_partner is "cobrandID_#qry_selectCobrandList.cobrandID#_#qry_selectCobrandList.userID#"> selected</cfif>>+ Contact: #HTMLEditFormat(qry_selectCobrandList.lastName)#, #HTMLEditFormat(qry_selectCobrandList.firstName)#</option>
				</cfif>
			</cfif>
			<cfif Variables.displaySalesperson is True>
				<option value="">-- SALESPERSON --</option>
				<cfloop Query="qry_selectCommissionCustomerList">
					<option value="salespersonID_0_#qry_selectCommissionCustomerList.targetID#"<cfif primaryTargetKey_targetID_userID_partner is "salespersonID_0_#qry_selectCommissionCustomerList.targetID#"> selected</cfif>>#HTMLEditFormat(qry_selectCommissionCustomerList.lastName)#, #HTMLEditFormat(qry_selectCommissionCustomerList.firstName)#</option>
				</cfloop>
			</cfif>
			<cfif Variables.displayVendor is True>
				<option value="">-- VENDOR --</option>
				<cfloop Query="qry_selectVendorList">
					<option value="vendorID_#qry_selectVendorList.vendorID#_0"<cfif primaryTargetKey_targetID_userID_partner is "vendorID_#qry_selectVendorList.vendorID#_0"> selected</cfif>>#Left(HTMLEditFormat(qry_selectVendorList.vendorName), 100)#</option>
					<cfif qry_selectVendorList.userID is not 0>
						<option value="vendorID_#qry_selectVendorList.vendorID#_#qry_selectVendorList.userID#"<cfif primaryTargetKey_targetID_userID_partner is "vendorID_#qry_selectVendorList.vendorID#_#qry_selectVendorList.userID#"> selected</cfif>>+ Contact: #HTMLEditFormat(qry_selectVendorList.lastName)#, #HTMLEditFormat(qry_selectVendorList.firstName)#</option>
					</cfif>
				</cfloop>
			</cfif>
			</select>
			<div class="SmallText">
			Select salesperson or partner and optional contact with which to associate this message.<br>
			Enables viewing of this message from Contact Mgmt for that salesperson/partner.
			<cfif Variables.displayUserEmail is True><br>Email addresses for each contact are listed at the bottom of the page.</cfif>
			</div>
		</td>
	</tr>
</cfif>

<tr>
	<td>Subject: </td>
	<td><input type="text" name="contactSubject" value="#HTMLEditFormat(Form.contactSubject)#" size="40" maxlength="#maxlength_Contact.contactSubject#"></td>
</tr>
<tr>
	<td>From Name: </td>
	<td><input type="text" name="contactFromName" value="#HTMLEditFormat(Form.contactFromName)#" size="40" maxlength="#maxlength_Contact.contactFromName#"> (who email is from)</td>
</tr>
<tr>
	<td>Reply-To: </td>
	<td><input type="text" name="contactReplyTo" value="#HTMLEditFormat(Form.contactReplyTo)#" size="40" maxlength="#maxlength_Contact.contactReplyTo#"> (email address)</td>
</tr>
<tr valign="bottom" height="30">
	<td></td>
	<td class="SmallText"> (Separate multiple email addresses with a comma)</td>
</tr>
<tr>
	<td>To: </td>
	<td><input type="text" name="contactTo" value="#HTMLEditFormat(Form.contactTo)#" size="60" maxlength="#maxlength_Contact.contactTo#"></td>
</tr>
<tr>
	<td>CC: </td>
	<td><input type="text" name="contactCC" value="#HTMLEditFormat(Form.contactCC)#" size="60" maxlength="#maxlength_Contact.contactCC#"></td>
</tr>
<tr>
	<td>BCC: </td>
	<td><input type="text" name="contactBCC" value="#HTMLEditFormat(Form.contactBCC)#" size="60" maxlength="#maxlength_Contact.contactBCC#"></td>
</tr>
<tr>
	<td><b>Message:</b> </td>
	<td><label><input type="checkbox" name="contactHtml" value="1"<cfif Form.contactHtml is 1> checked</cfif>> Check if message is in html format</label></td>
</tr>
<tr><td colspan="2"><textarea name="contactMessage" rows="16" cols="80" wrap="soft">#HTMLEditFormat(Form.contactMessage)#</textarea></td></tr>
<tr>
	<td></td>
	<td class="TableText">
		<input type="submit" name="submitContactSend" value="#HTMLEditFormat(Variables.formSubmitValue_send)#">
		&nbsp; &nbsp; 
		<input type="submit" name="submitContactSave" value="#HTMLEditFormat(Variables.formSubmitValue_save)#"> (to send later)<br>
		<br>
		<input type="reset" value="#HTMLEditFormat(Variables.formSubmitValue_reset)#">
	</td>
</tr>
</table>
</form>

<cfif Variables.displayUserEmail is True>
	<p>
	<table border="1" cellspacing="0" cellpadding="2">
	<tr class="TableHeader" valign="bottom">
		<th>Partner Type</th>
		<th>Company Name</th>
		<th>Contact Name</th>
		<th>Email</th>
	</tr>
	<cfif Variables.displayAffiliate is True and qry_selectAffiliateList.userID is not 0>
		<tr class="TableText" valign="top">
			<td>Affiliate</td>
			<td>#qry_selectAffiliateList.affiliateName#</td>
			<td>#qry_selectAffiliateList.lastName#, #qry_selectAffiliateList.firstName#</td>
			<td class="SmallText"><cfif Not StructKeyExists(Variables.userEmailStruct, "user#qry_selectAffiliateList.userID#")>-<cfelse>#Variables.userEmailStruct["user#qry_selectAffiliateList.userID#"]#</cfif></td>
		</tr>
	</cfif>
	<cfif Variables.displayCobrand is True and qry_selectCobrandList.userID is not 0>
		<tr class="TableText" valign="top">
			<td>Cobrand</td>
			<td>#qry_selectCobrandList.cobrandName#</td>
			<td>#qry_selectCobrandList.lastName#, #qry_selectCobrandList.firstName#</td>
			<td class="SmallText"><cfif Not StructKeyExists(Variables.userEmailStruct, "user#qry_selectCobrandList.userID#")>-<cfelse>#Variables.userEmailStruct["user#qry_selectCobrandList.userID#"]#</cfif></td>
		</tr>
	</cfif>
	<cfif Variables.displaySalesperson is True>
		<cfloop Query="qry_selectCommissionCustomerList">
			<tr class="TableText" valign="top">
				<td>Salesperson</td>
				<td>-</td>
				<td>#qry_selectCommissionCustomerList.lastName#, #qry_selectCommissionCustomerList.firstName#</td>
				<td class="SmallText"><cfif Not StructKeyExists(Variables.userEmailStruct, "user#qry_selectCommissionCustomerList.targetID#")>-<cfelse>#Variables.userEmailStruct["user#qry_selectCommissionCustomerList.targetID#"]#</cfif></td>
			</tr>
		</cfloop>
	</cfif>
	<cfif Variables.displayVendor is True>
		<cfloop Query="qry_selectVendorList">
			<tr class="TableText" valign="top">
				<td>Vendor</td>
				<td>#qry_selectVendorList.vendorName#</td>
				<td>#qry_selectVendorList.lastName#, #qry_selectVendorList.firstName#</td>
				<td class="SmallText"><cfif Not StructKeyExists(Variables.userEmailStruct, "user#qry_selectVendorList.userID#")>-<cfelse>#Variables.userEmailStruct["user#qry_selectVendorList.userID#"]#</cfif></td>
			</tr>
		</cfloop>
	</cfif>
	</table>
	</p>
</cfif>
</cfoutput>