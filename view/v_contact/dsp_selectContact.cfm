<!--- 
contactID_orig
contactReplied
contactTopicID
contactFax
contactEmail

author name, company
target name, company
--->

<cfoutput>
<cfif URL.control is "contact">
	<p class="TableText">
	<cfif Application.fn_IsUserAuthorized("viewUser")>[<a href="index.cfm?method=user.viewUser&userID=#qry_selectContact.userID_target#" class="plainlink">View This User</a>] </cfif> 
	<cfif Application.fn_IsUserAuthorized("viewCompany")>[<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContact.companyID_target#" class="plainlink">View This Company</a>]</cfif>
	</p>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.displayProductInfo is True>
	<tr>
		<td>Product: </td>
		<td>
			<cfif qry_selectProduct.productID_custom is not "">#qry_selectProduct.productID_custom#. </cfif>#qry_selectProduct.productName#
			<cfif Application.fn_IsUserAuthorized("viewProduct")>
				<font class="TableText">(<a href="index.cfm?method=product.viewProduct&productID=#qry_selectContact.targetID#" class="plainlink">view</a>)</font>
			</cfif>
		</td>
	</tr>
</cfif>
<cfif Variables.displayPartnerCompany is not "" or Variables.displayPartnerUser is not "">
	<tr valign="top">
		<td>Partner: </td>
		<td>
			<cfif Variables.displayPartnerCompany is not "">#Variables.displayPartnerCompany#<br></cfif>
			<cfif Variables.displayPartnerUser is not "">#Variables.displayPartnerUser#</cfif>
		</td>
	</tr>
</cfif>
<cfif Variables.displayContactTopic is True>
	<tr>
		<td>Topic: </td>
		<td>#qry_selectContactTopic.contactTopicName#</td>
	</tr>
</cfif>
<cfif Variables.displayContactTemplate is True>
	<tr>
		<td>Template: </td>
		<td>#qry_selectContactTemplate.contactTemplateName#</td>
	</tr>
</cfif>
<cfif qry_selectContact.contactID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectContact.contactID_custom#</td>
	</tr>
</cfif>
<cfif Variables.doAction is "updateContact" and IsDefined("qry_selectContact") and qry_selectContact.contactByCustomer is 1>
	<tr>
		<td>Status: </td>
		<td><cfif qry_selectContact.contactStatus is 1> Resolved<cfelse>Not Yet Resolved</cfif></td>
	</tr>
</cfif>
<tr>
	<td>Subject: </td>
	<td>#qry_selectContact.contactSubject#</td>
</tr>
<tr>
	<td>From Name: </td>
	<td>#qry_selectContact.contactFromName#</td>
</tr>
<tr>
	<td>Reply-To: </td>
	<td><a href="mailto:#qry_selectContact.contactReplyTo#" class="plainlink">#qry_selectContact.contactReplyTo#</a></td>
</tr>
<tr valign="top">
	<td>To: </td>
	<td><cfloop Index="email" List="#qry_selectContact.contactTo#"><a href="mailto:#email#" class="plainlink">#email#</a><br></cfloop></td>
</tr>
<cfif qry_selectContact.contactCC is not "">
	<tr valign="top">
		<td>CC: </td>
		<td><cfloop Index="email" List="#qry_selectContact.contactCC#"><a href="mailto:#email#" class="plainlink">#email#</a><br></cfloop></td>
	</tr>
</cfif>
<cfif qry_selectContact.contactBCC is not "">
	<tr valign="top">
		<td>BCC: </td>
		<td><cfloop Index="email" List="#qry_selectContact.contactBCC#"><a href="mailto:#email#" class="plainlink">#email#</a><br></cfloop></td>
	</tr>
</cfif>
<tr>
	<td><b>Message:</b> </td>
	<td><cfif qry_selectContact.contactHtml is 1>(sent in html format)</cfif></td>
</tr>
</table>

<table border="1" cellspacing="0" cellpadding="2" class="TableText" width="750"><tr><td>
<cfif qry_selectContact.contactHtml is 0>
	#Replace(HTMLEditFormat(qry_selectContact.contactMessage), Chr(10), "<br>", "ALL")#
<cfelse>
	#qry_selectContact.contactMessage#
	</td></tr><tr><td>
	<p class="MainText"><b>HTML Code:</b></p>
	#Replace(HTMLEditFormat(qry_selectContact.contactMessage), Chr(10), "<br>", "ALL")#
</cfif>
</td></tr></table>
</cfoutput>