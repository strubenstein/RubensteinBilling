<cfoutput>
<form method="post" name="newsletterSubscriber" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif qry_selectCobrandList.RecordCount is not 0>
	<tr>
		<td>Cobrand: </td>
		<td>
			<select name="cobrandID" size="1" class="TableText">
			<option value="0">-- SELECT COBRAND --</option>
			<cfloop Query="qry_selectCobrandList">
				<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(qry_selectCobrandList.cobrandName)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<cfif qry_selectAffiliateList.RecordCount is not 0>
	<tr>
		<td>Affiliate: </td>
		<td>
			<select name="affiliateID" size="1" class="TableText">
			<option value="0">-- SELECT AFFILIATE --</option>
			<cfloop Query="qry_selectAffiliateList">
				<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(qry_selectAffiliateList.affiliateName)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td>
		<label><input type="radio" name="newsletterSubscriberStatus" value="1"<cfif Form.newsletterSubscriberStatus is 1> checked</cfif>> Subscribed</label> &nbsp; 
		<label><input type="radio" name="newsletterSubscriberStatus" value="0"<cfif Form.newsletterSubscriberStatus is not 1> checked</cfif>> Un-subscribed</label>
	</td>
</tr>
<tr>
	<td>Preferred Format: </td>
	<td>
		<label><input type="radio" name="newsletterSubscriberHtml" value="1"<cfif Form.newsletterSubscriberHtml is 1> checked</cfif>> HTML</label> &nbsp; 
		<label><input type="radio" name="newsletterSubscriberHtml" value="0"<cfif Form.newsletterSubscriberHtml is not 1> checked</cfif>> Text</label>
	</td>
</tr>
<cfif Variables.doAction is "insertNewsletterSubscriber">
	<tr>
		<td>Email Address(es): </td>
		<td class="TableText"><i>Separate email addresses with a comma or carriage return.</i></td>
	</tr>
	<tr><td colspan="2"><textarea name="newsletterSubscriberEmail" rows="20" cols="60" wrap="off">#HTMLEditFormat(Replace(Form.newsletterSubscriberEmail, ",", Chr(10), "ALL"))#</textarea></td></tr>
<cfelse>
	<tr>
		<td>Email Address: </td>
		<td><input type="text" name="newsletterSubscriberEmail" value="#HTMLEditFormat(Form.newsletterSubscriberEmail)#" size="50" maxlength="#maxlength_NewsletterSubscriber.newsletterSubscriberEmail#"></td>
	</tr>
</cfif>
<tr>
	<td></td>
	<td><input type="submit" name="submitNewsletterSubscriber" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
