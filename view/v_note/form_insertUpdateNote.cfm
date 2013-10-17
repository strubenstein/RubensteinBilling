<cfoutput>
<form method="post" name="note" action="#Arguments.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<div class="SubTitle">Add Note</div>
<cfif methodStruct.displayPartners is True>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr valign="top">
		<td class="TableText">Optional Partner:&nbsp; </td>
		<td class="SmallText">
			<select name="primaryTargetKey_targetID_userID_partner" size="1" class="TableText">
			<option value="">-- SELECT PARTNER --</option>
			<cfif methodStruct.displayAffiliate is True>
				<option value="">-- AFFILIATE --</option>
				<option value="affiliateID_#qry_selectAffiliateList.affiliateID#_0"<cfif Form.primaryTargetKey_targetID_userID_partner is "affiliateID_#qry_selectAffiliateList.affiliateID#_0"> selected</cfif>>#Left(HTMLEditFormat(qry_selectAffiliateList.affiliateName), 100)#</option>
				<cfif qry_selectAffiliateList.userID is not 0>
					<option value="affiliateID_#qry_selectAffiliateList.affiliateID#_#qry_selectAffiliateList.userID#"<cfif Form.primaryTargetKey_targetID_userID_partner is "affiliateID_#qry_selectAffiliateList.affiliateID#_#qry_selectAffiliateList.userID#"> selected</cfif>>+ Contact: #HTMLEditFormat(qry_selectAffiliateList.lastName)#, #HTMLEditFormat(qry_selectAffiliateList.firstName)#</option>
				</cfif>
			</cfif>
			<cfif methodStruct.displayCobrand is True>
				<option value="">-- COBRAND --</option>
				<option value="cobrandID_#qry_selectCobrandList.cobrandID#_0"<cfif Form.primaryTargetKey_targetID_userID_partner is "cobrandID_#qry_selectCobrandList.cobrandID#_0"> selected</cfif>>#Left(HTMLEditFormat(qry_selectCobrandList.cobrandName), 100)#</option>
				<cfif qry_selectCobrandList.userID is not 0>
					<option value="cobrandID_#qry_selectCobrandList.cobrandID#_#qry_selectCobrandList.userID#"<cfif Form.primaryTargetKey_targetID_userID_partner is "cobrandID_#qry_selectCobrandList.cobrandID#_#qry_selectCobrandList.userID#"> selected</cfif>>+ Contact: #HTMLEditFormat(qry_selectCobrandList.lastName)#, #HTMLEditFormat(qry_selectCobrandList.firstName)#</option>
				</cfif>
			</cfif>
			<cfif methodStruct.displaySalesperson is True>
				<option value="">-- SALESPERSON --</option>
				<cfloop Query="qry_selectCommissionCustomerList">
					<option value="salespersonID_0_#qry_selectCommissionCustomerList.targetID#"<cfif Form.primaryTargetKey_targetID_userID_partner is "salespersonID_0_#qry_selectCommissionCustomerList.targetID#"> selected</cfif>>#HTMLEditFormat(qry_selectCommissionCustomerList.lastName)#, #HTMLEditFormat(qry_selectCommissionCustomerList.firstName)#</option>
				</cfloop>
			</cfif>
			<cfif methodStruct.displayVendor is True>
				<option value="">-- VENDOR --</option>
				<cfloop Query="qry_selectVendorList">
					<option value="vendorID_#qry_selectVendorList.vendorID#_0"<cfif Form.primaryTargetKey_targetID_userID_partner is "vendorID_#qry_selectVendorList.vendorID#_0"> selected</cfif>>#Left(HTMLEditFormat(qry_selectVendorList.vendorName), 100)#</option>
					<cfif qry_selectVendorList.userID is not 0>
						<option value="vendorID_#qry_selectVendorList.vendorID#_#qry_selectVendorList.userID#"<cfif Form.primaryTargetKey_targetID_userID_partner is "vendorID_#qry_selectVendorList.vendorID#_#qry_selectVendorList.userID#"> selected</cfif>>+ Contact: #HTMLEditFormat(qry_selectVendorList.lastName)#, #HTMLEditFormat(qry_selectVendorList.firstName)#</option>
					</cfif>
				</cfloop>
			</cfif>
			</select><br>
			Select salesperson or partner and optional contact with which to associate this note.<br>
			Enables viewing of this message from Notes for that salesperson/partner.
		</td>
	</tr>
	</table>
</cfif>

<textarea name="noteMessage" rows="8" cols="80" wrap="soft">#HTMLEditFormat(Form.noteMessage)#</textarea><br>
<input type="submit" name="submitNote" value="#HTMLEditFormat(methodStruct.formSubmitValue)#">
</p>
</form>
</cfoutput>

