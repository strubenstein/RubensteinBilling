<cfoutput>
<p class="ErrorMessage">More than one affiliate has the ID or code you entered. Please select the correct affiliate:<br>
<table border="1" cellspacing="0" cellpadding="4" class="TableText">
<tr valign="bottom" class="TableHeader">
	<th>ID</th>
	<th>Custom ID</th>
	<th>Code</th>
	<th align="left">Affiliate Name</th>
	<th align="left">Company Name</th>
</tr>
<cfloop Query="qry_viewAffiliateByID">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_viewAffiliateByID.affiliateID#</td>
	<td><cfif qry_viewAffiliateByID.affiliateID_custom is "">&nbsp;<cfelse>#qry_viewAffiliateByID.affiliateID_custom#</cfif></td>
	<td><cfif qry_viewAffiliateByID.affiliateCode is "">&nbsp;<cfelse>#qry_viewAffiliateByID.affiliateCode#</cfif></td>
	<td><a href="index.cfm?method=affiliate.viewAffiliate&affiliateID=#qry_viewAffiliateByID.affiliateID#" class="plainlink">#qry_viewAffiliateByID.affiliateName#</a></td>
	<td><cfif qry_viewAffiliateByID.companyName is "">&nbsp;<cfelse>#qry_viewAffiliateByID.companyName#</cfif></td>
	</tr>
</cfloop>
</table>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
