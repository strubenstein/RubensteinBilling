<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Name: </td>
	<td>#qry_selectUser.salutation# #qry_selectUser.firstName# #qry_selectUser.lastName# #qry_selectUser.suffix#</td>
</tr>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectUser.userStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<!--- 
<cfif Variables.userStatusRow is not 0>
	<tr>
		<td>User Custom Status: </td>
		<td>#qry_selectStatusHistoryList.statusOrder[Variables.userStatusRow]#. #qry_selectStatusHistoryList.statusTitle[Variables.userStatusRow]#</td>
	</tr>
</cfif>
--->
<cfif Variables.displayCompany is True>
	<tr>
		<td>Company Name: </td>
		<td>
			#qry_selectCompany.companyName#
			<cfif Application.fn_IsUserAuthorized("viewCompany")>
			 (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectUser.companyID#" class="plainlink">go</a>)
			</cfif>
		</td>
	</tr>
	<!--- 
	<cfif Variables.companyStatusRow is not 0>
		<tr>
			<td>Company Custom Status: </td>
			<td>#qry_selectStatusHistoryList.statusOrder[Variables.companyStatusRow]#. #qry_selectStatusHistoryList.statusTitle[Variables.companyStatusRow]#</td>
		</tr>
	</cfif>
	--->
</cfif>
<cfif qry_selectUser.userID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectUser.userID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectUser.username is not "">
	<tr>
		<td>Username: </td>
		<td>#qry_selectUser.username#</td>
	</tr>
</cfif>
<cfif qry_selectUser.email is not "">
	<tr>
		<td>Email: </td>
		<td><a href="mailto:#qry_selectUser.email#" class="plainlink">#qry_selectUser.email#</a></td>
	</tr>
</cfif>
<tr>
	<td>Newsletter: </td>
	<td><cfif qry_selectUser.userNewsletterStatus is 0>No<cfelse>Yes <cfif qry_selectUser.userNewsletterHtml is 0>(text)<cfelse>(html)</cfif></cfif></td>
</tr>
<cfif qry_selectUser.jobTitle is not "">
	<tr>
		<td>Job Title: </td>
		<td>#qry_selectUser.jobTitle#</td>
	</tr>
</cfif>
<cfif qry_selectUser.jobDepartment is not "">
	<tr>
		<td>Department: </td>
		<td>#qry_selectUser.jobDepartment#</td>
	</tr>
</cfif>
<cfif qry_selectUser.jobDivision is not "">
	<tr>
		<td>Division: </td>
		<td>#qry_selectUser.jobDivision#</td>
	</tr>
</cfif>

<tr valign="top">
	<td>Email Verifiication: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="MainText">
		<tr>
			<td>Status: </td>
			<td>
				<cfswitch expression="#qry_selectUser.userEmailVerified#">
				<cfcase value="1"><font color="green">Verified</font></cfcase>
				<cfcase value="0"><font color="red">Not Verified</font></cfcase>
				<cfdefaultcase>Not Requested</cfdefaultcase>
				</cfswitch>
				<cfif IsDate(qry_selectUser.userEmailDateVerified)> (on #DateFormat(qry_selectUser.userEmailDateVerified, "mm/dd/yyyy")# at #TimeFormat(qry_selectUser.userEmailDateVerified, "hh:mm tt")#)</cfif>
			</td>
		</tr>
		<tr>
			<td>Code: </td>
			<td><cfif qry_selectUser.userEmailVerifyCode is "">(none)<cfelse>#qry_selectUser.userEmailVerifyCode#</cfif></td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td>Date Created: </td>
	<td>#DateFormat(qry_selectUser.userDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectUser.userDateCreated, "hh:mm tt")#</td>
</tr>
<cfif DateCompare(qry_selectUser.userDateCreated, qry_selectUser.userDateUpdated) is not 0>
	<tr>
		<td>Last Updated: </td>
		<td>#DateFormat(qry_selectUser.userDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectUser.userDateUpdated, "hh:mm tt")#</td>
	</tr>
</cfif>
<cfif Application.fn_IsUserAuthorized("exportUsers")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectUser.userIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectUser.userIsExported is not "" and IsDate(qry_selectUser.userDateExported)>
				on #DateFormat(qry_selectUser.userDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectUser.userDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="userID">
	<cfinvokeargument name="targetID" value="#URL.userID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="userID">
	<cfinvokeargument name="targetID" value="#URL.userID#">
</cfinvoke>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif qry_selectUserSummary.userCompanyCount gt 1>
	<tr>
		<td>## Companies: </td>
		<td>#qry_selectUserSummary.userCompanyCount#</td>
	</tr>
</cfif>
<cfif qry_selectUserSummary.userInvoiceCount is not 0>
	<tr>
		<td>## Invoices/Purchases: </td>
		<td>#qry_selectUserSummary.userInvoiceCount#</td>
	</tr>
	<tr>
		<td>Sum of Invoices/Purchases: </td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td> - Including tax &amp; shipping: </td>
		<td><cfif Not IsNumeric(qry_selectUserSummary.userInvoiceTotalSum)>$0<cfelse>#DollarFormat(qry_selectUserSummary.userInvoiceTotalSum)#</cfif></td>
	</tr>
	<tr>
		<td> - Products only: </td>
		<td><cfif Not IsNumeric(qry_selectUserSummary.userInvoiceTotalLineItemSum)>$0<cfelse>#DollarFormat(qry_selectUserSummary.userInvoiceTotalLineItemSum)#</cfif></td>
	</tr>
	<tr>
		<td>Total ## of Products Purchased: </td>
		<td><cfif Not IsNumeric(qry_selectUserSummary.userInvoiceLineItemQuantitySum)>0<cfelse>#qry_selectUserSummary.userInvoiceLineItemQuantitySum#</cfif></td>
	</tr>
	<!--- 
	<tr>
		<td>## of Unique Products Purchased: </td>
		<td>#qry_selectUserSummary.userInvoiceLineItemProductUniqueCount#</td>
	</tr>
	--->
</cfif>
<tr>
	<td>Custom Prices: </td>
	<td>#qry_selectUserSummary.userPriceCount# (does not include custom prices via groups, company, or applied to all customers)</td>
</tr>
<tr>
	<td>## Notes: </td>
	<td>#qry_selectUserSummary.userNoteCount#</td>
</tr>
<tr>
	<td>## Tasks: </td>
	<td>#qry_selectUserSummary.userTaskCountNotCompleted# open (#qry_selectUserSummary.userTaskCountCompleted# completed)</td>
</tr>
</table>
</cfoutput>

