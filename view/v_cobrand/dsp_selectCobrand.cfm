<cfoutput>
<!--- <cfinclude template="../../include/partner/c#URL.cobrandID#cobrandHeader.cfm"> --->
<cfif Variables.headerRow is not 0>
	<cfif qry_selectHeaderFooter.headerFooterHtml[Variables.headerRow] is 1>
		#qry_selectHeaderFooter.headerFooterText[Variables.headerRow]#
	<cfelse>
		#Replace(qry_selectHeaderFooter.headerFooterText[Variables.headerRow], Chr(10), "<br>", "ALL")#
	</cfif>
</cfif>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif URL.control is not "company">
	<tr>
		<td>Company Name: </td>
		<td>
			#qry_selectCompany.companyName#
			<cfif Application.fn_IsUserAuthorized("viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectCobrand.companyID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Cobrand Name: </td>
	<td>#qry_selectCobrand.cobrandName#</td>
</tr>
<tr>
	<td>Cobrand Title: </td>
	<td>#qry_selectCobrand.cobrandTitle#</td>
</tr>
<cfif qry_selectCobrand.userID is not 0 and qry_selectUser.RecordCount is not 0>
	<tr>
		<td>Primary Contact: </td>
		<td>
			#qry_selectUser.firstName# #qry_selectUser.lastName#
			<cfif Application.fn_IsUserAuthorized("viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectCobrand.userID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectCobrand.cobrandStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<cfif qry_selectCobrand.cobrandID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectCobrand.cobrandID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectCobrand.cobrandCode is not "">
	<tr>
		<td>Code: </td>
		<td>#qry_selectCobrand.cobrandCode#</td>
	</tr>
</cfif>
<cfif qry_selectCobrand.cobrandURL is not "">
	<tr>
		<td>URL: </td>
		<td><a href="#qry_selectCobrand.cobrandURL#" class="plainlink" target="cobrand">#qry_selectCobrand.cobrandURL#</a></td>
	</tr>
</cfif>
<cfif qry_selectCobrand.cobrandImage is not "">
	<tr>
		<td>Image: </td>
		<td><img src="#qry_selectCobrand.cobrandImage#" border="0" alt="Cobrand Logo"></td>
	</tr>
</cfif>
<cfif qry_selectCobrand.cobrandDomain is not "">
	<tr>
		<td>Domain: </td>
		<td>#qry_selectCobrand.cobrandDomain#</td>
	</tr>
</cfif>
<cfif qry_selectCobrand.cobrandDirectory is not "">
	<tr>
		<td>Directory: </td>
		<td>#qry_selectCobrand.cobrandDirectory#</td>
	</tr>
</cfif>
<tr>
	<td>Created: </td>
	<td>#DateFormat(qry_selectCobrand.cobrandDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectCobrand.cobrandDateCreated, "hh:mm tt")#</td>
</tr>
<cfif DateCompare(qry_selectCobrand.cobrandDateCreated, qry_selectCobrand.cobrandDateUpdated) is not 0>
	<tr>
		<td>Last Updated: </td>
		<td>#DateFormat(qry_selectCobrand.cobrandDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectCobrand.cobrandDateUpdated, "hh:mm tt")#</td>
	</tr>
</cfif>
<cfif Application.fn_IsUserAuthorized("exportCobrands")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectCobrand.cobrandIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectCobrand.cobrandIsExported is not "" and IsDate(qry_selectCobrand.cobrandDateExported)>
				on #DateFormat(qry_selectCobrand.cobrandDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectCobrand.cobrandDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="cobrandID">
	<cfinvokeargument name="targetID" value="#URL.cobrandID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="cobrandID">
	<cfinvokeargument name="targetID" value="#URL.cobrandID#">
</cfinvoke>

<!--- <cfinclude template="../../include/partner/c#URL.cobrandID#cobrandFooter.cfm"> --->
<cfif Variables.footerRow is not 0>
	<cfif qry_selectHeaderFooter.headerFooterHtml[Variables.footerRow] is 1>
		#qry_selectHeaderFooter.headerFooterText[Variables.footerRow]#
	<cfelse>
		#Replace(qry_selectHeaderFooter.headerFooterText[Variables.footerRow], Chr(10), "<br>", "ALL")#
	</cfif>
</cfif>
</cfoutput>
