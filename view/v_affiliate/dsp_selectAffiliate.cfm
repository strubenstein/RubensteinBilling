<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif URL.control is not "company">
	<tr>
		<td>Company Name: </td>
		<td>
			#qry_selectCompany.companyName#
			<cfif Application.fn_IsUserAuthorized("viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectAffiliate.companyID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Affiliate Name: </td>
	<td>#qry_selectAffiliate.affiliateName#</td>
</tr>
<cfif qry_selectAffiliate.userID is not 0 and qry_selectUser.RecordCount is not 0>
	<tr>
		<td>Primary Contact: </td>
		<td>
			#qry_selectUser.firstName# #qry_selectUser.lastName#
			<cfif Application.fn_IsUserAuthorized("viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectAffiliate.userID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectAffiliate.affiliateStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<cfif qry_selectAffiliate.affiliateID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectAffiliate.affiliateID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectAffiliate.affiliateCode is not "">
	<tr>
		<td>Code: </td>
		<td>#qry_selectAffiliate.affiliateCode#</td>
	</tr>
</cfif>
<cfif qry_selectAffiliate.affiliateURL is not "">
	<tr>
		<td>URL: </td>
		<td><a href="#qry_selectAffiliate.affiliateURL#" class="plainlink" target="affiliate">#qry_selectAffiliate.affiliateURL#</a></td>
	</tr>
</cfif>
<tr>
	<td>Created: </td>
	<td>#DateFormat(qry_selectAffiliate.affiliateDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectAffiliate.affiliateDateCreated, "hh:mm tt")#</td>
</tr>
<cfif DateCompare(qry_selectAffiliate.affiliateDateCreated, qry_selectAffiliate.affiliateDateUpdated) is not 0>
	<tr>
		<td>Last Updated: </td>
		<td>#DateFormat(qry_selectAffiliate.affiliateDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectAffiliate.affiliateDateUpdated, "hh:mm tt")#</td>
	</tr>
</cfif>
<cfif Application.fn_IsUserAuthorized("exportAffiliates")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectAffiliate.affiliateIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectAffiliate.affiliateIsExported is not "" and IsDate(qry_selectAffiliate.affiliateDateExported)>
				on #DateFormat(qry_selectAffiliate.affiliateDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectAffiliate.affiliateDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>
</cfoutput>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="affiliateID">
	<cfinvokeargument name="targetID" value="#URL.affiliateID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="affiliateID">
	<cfinvokeargument name="targetID" value="#URL.affiliateID#">
</cfinvoke>
