<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Name: </td>
	<td>#qry_selectGroup.groupName#</td>
</tr>
<cfif qry_selectGroup.groupID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectGroup.groupID_custom#</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectGroup.groupStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<cfif qry_selectGroup.groupCategory is not "">
	<tr>
		<td>Category: </td>
		<td>#qry_selectGroup.groupCategory#</td>
	</tr>
</cfif>
<cfif qry_selectGroup.groupDescription is not "">
	<tr>
		<td>Description: </td>
		<td>#qry_selectGroup.groupDescription#</td>
	</tr>
</cfif>
<tr>
	<td>Date Created: </td>
	<td>#DateFormat(qry_selectGroup.groupDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectGroup.groupDateCreated, "hh:mm tt")#</td>
</tr>
<cfif DateCompare(qry_selectGroup.groupDateCreated, qry_selectGroup.groupDateUpdated) is not 0>
	<tr>
		<td>Last Created: </td>
		<td>#DateFormat(qry_selectGroup.groupDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectGroup.groupDateUpdated, "hh:mm tt")#</td>
	</tr>
</cfif>
</table>
<br>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="groupID">
	<cfinvokeargument name="targetID" value="#URL.groupID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#qry_selectGroup.companyID#">
	<cfinvokeargument name="primaryTargetKey" value="groupID">
	<cfinvokeargument name="targetID" value="#URL.groupID#">
</cfinvoke>

<br>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>## Companies: </td>
	<td>#qry_selectGroupSummary.groupCompanyCount#</td>
</tr>
<tr>
	<td>## Users: </td>
	<td>#qry_selectGroupSummary.groupUserCount#</td>
</tr>

<tr>
	<td>## Affiliates: </td>
	<td>#qry_selectGroupSummary.groupAffiliateCount#</td>
</tr>
<tr>
	<td>## Cobrands: </td>
	<td>#qry_selectGroupSummary.groupCobrandCount#</td>
</tr>
<tr>
	<td>## Vendors: </td>
	<td>#qry_selectGroupSummary.groupVendorCount#</td>
</tr>

<tr>
	<td>Custom Prices: </td>
	<td>#qry_selectGroupSummary.groupPriceCount# (does not include custom prices applied to all customers)</td>
</tr>
</table>
</cfoutput>

