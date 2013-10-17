<cfoutput>
<cfif qry_selectNewsletterSubscriberList.RecordCount is 0>
	<p class="ErrorMessage">No newsletter subscribers met your criteria.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Variables.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectNewsletterSubscriberList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgColor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td><cfif qry_selectNewsletterSubscriberList.companyName is "">&nbsp;<cfelse>#qry_selectNewsletterSubscriberList.companyName#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectNewsletterSubscriberList.lastName is "">&nbsp;<cfelse>#qry_selectNewsletterSubscriberList.lastName#, #qry_selectNewsletterSubscriberList.firstName#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectNewsletterSubscriberList.newsletterSubscriberEmail#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectNewsletterSubscriberList.newsletterSubscriberStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectNewsletterSubscriberList.newsletterSubscriberHtml is 1>html<cfelse>text</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectNewsletterSubscriberList.newsletterSubscriberDateCreated, "mm-dd-yyyy")#</td>
		<cfif ListFind(Variables.permissionActionList, "updateNewsletterSubscriber") or ListFind(Variables.permissionActionList, "updateCompany") or ListFind(Variables.permissionActionList, "updateUser")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif qry_selectNewsletterSubscriberList.companyID is 0><!--- newsletter subscriber --->
					<cfif ListFind(Variables.permissionActionList, "updateNewsletterSubscriber")>
						<a href="index.cfm?method=newsletter.updateNewsletterSubscriber&newsletterSubscriberID=#qry_selectNewsletterSubscriberList.newsletterSubscriberID#" class="plainlink">Newsletter Sub.</a>
					</cfif>
				<cfelse>
					<cfif ListFind(Variables.permissionActionList, "updateCompany")>
						<a href="index.cfm?method=company.updateCompany&companyID=#qry_selectNewsletterSubscriberList.companyID#" class="plainlink">Company</a> |
					</cfif>
					<cfif ListFind(Variables.permissionActionList, "updateUser")>
						<a href="index.cfm?method=user.updateUser&userID=#qry_selectNewsletterSubscriberList.userID#" class="plainlink">User</a>
					</cfif>
				</cfif>
			</td>
		</cfif>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, False, "")#

	<cfif Application.fn_IsUserAuthorized("exportNewsletterSubscribers")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
