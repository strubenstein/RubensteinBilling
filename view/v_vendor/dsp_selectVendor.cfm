<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif URL.control is not "company">
	<tr>
		<td>Company Name: </td>
		<td>
			#qry_selectCompany.companyName#
			<cfif Application.fn_IsUserAuthorized("viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectVendor.companyID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Vendor Name: </td>
	<td>#qry_selectVendor.vendorName#</td>
</tr>
<cfif qry_selectVendor.userID is not 0 and qry_selectUser.RecordCount is not 0>
	<tr>
		<td>Primary Contact: </td>
		<td>
			#qry_selectUser.firstName# #qry_selectUser.lastName#
			<cfif Application.fn_IsUserAuthorized("viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectVendor.userID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectVendor.vendorStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<cfif qry_selectVendor.vendorID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectVendor.vendorID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectVendor.vendorCode is not "">
	<tr>
		<td>Code: </td>
		<td>#qry_selectVendor.vendorCode#</td>
	</tr>
</cfif>
<cfif qry_selectVendor.vendorURL is not "">
	<tr>
		<td>URL: </td>
		<td>
			<a href="#qry_selectVendor.vendorURL#" class="plainlink" target="vendor">#qry_selectVendor.vendorURL#</a> 
			<cfif qry_selectVendor.vendorURLdisplay is 1>(displayed)<cfelse>(not displayed)</cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectVendor.vendorImage is not "">
	<tr>
		<td>Image: </td>
		<td><img src="#qry_selectVendor.vendorImage#" border="0" alt="Vendor Logo"></td>
	</tr>
</cfif>
<tr>
	<td>Created: </td>
	<td>#DateFormat(qry_selectVendor.vendorDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectVendor.vendorDateCreated, "hh:mm tt")#</td>
</tr>
<cfif DateCompare(qry_selectVendor.vendorDateCreated, qry_selectVendor.vendorDateUpdated) is not 0>
	<tr>
		<td>Last Updated: </td>
		<td>#DateFormat(qry_selectVendor.vendorDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectVendor.vendorDateUpdated, "hh:mm tt")#</td>
	</tr>
</cfif>
<cfif Application.fn_IsUserAuthorized("exportVendors")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectVendor.vendorIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectVendor.vendorIsExported is not "" and IsDate(qry_selectVendor.vendorDateExported)>
				on #DateFormat(qry_selectVendor.vendorDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectVendor.vendorDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>

<cfif qry_selectVendor.vendorDescription is not "">
	<br><div class="MainText"><b>Description:</b> <cfif qry_selectVendor.vendorDescriptionDisplay is 1>(displayed)<cfelse>(not displayed)</cfif></div>
	<cfif qry_selectVendor.vendorDescriptionHtml is 1>
		<table border="0" cellspacing="0" cellpadding="0" width="800"><tr><td class="MainText">
		#Replace(qry_selectVendor.vendorDescription, Chr(10), "<br>", "ALL")#
		</td></tr></table>
	<cfelse>
		<div class="MainText" style="width: 800">#qry_selectVendor.vendorDescription#</div>
	</cfif>
</cfif>
</cfoutput>


