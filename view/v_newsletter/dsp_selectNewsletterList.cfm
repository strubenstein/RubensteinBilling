<cfoutput>
<cfif qry_selectNewsletterList.RecordCount is 0>
	<p class="ErrorMessage">No newsletters meet your search criteria.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectNewsletterList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif Variables.displayCustomID is True>
			<td><cfif qry_selectNewsletterList.contactID_custom is "">&nbsp;<cfelse>#qry_selectNewsletterList.contactID_custom#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<td><cfif qry_selectNewsletterList.newsletterDescription is "">&nbsp;<cfelse>#qry_selectNewsletterList.newsletterDescription#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectNewsletterList.userID_author is 0>&nbsp;<cfelse>#qry_selectNewsletterList.authorLastName#,<br>#qry_selectNewsletterList.authorFirstName#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectNewsletterList.contactFromName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectNewsletterList.contactSubject is "">&nbsp;<cfelse>#qry_selectNewsletterList.contactSubject#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap><cfif Not IsDate(qry_selectNewsletterList.contactDateSent)>-<cfelse>#DateFormat(qry_selectNewsletterList.contactDateSent, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectNewsletterList.contactDateSent, "hh:mm tt")#</div></cfif></td>
		<cfif ListFind(Variables.permissionActionList, "updateNewsletter") or ListFind(Variables.permissionActionList, "viewNewsletter")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif Not IsDate(qry_selectNewsletterList.contactDateSent) and ListFind(Variables.permissionActionList, "updateNewsletter")>
					<a href="index.cfm?method=newsletter.updateNewsletter&newsletterID=#qry_selectNewsletterList.newsletterID#" class="plainlink">Update/<br>Send</a>
				<cfelseif IsDate(qry_selectNewsletterList.contactDateSent) and ListFind(Variables.permissionActionList, "viewNewsletter")>
					<a href="index.cfm?method=newsletter.viewNewsletter&newsletterID=#qry_selectNewsletterList.newsletterID#" class="plainlink">View</a>
				</cfif>
			</td>
		</cfif>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, False, "")#
</cfif>
</cfoutput>

