<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Company Name: </td>
	<td>#qry_selectCompany.companyName#</td>
</tr>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectCompany.companyStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<!--- 
<cfif Variables.companyStatusRow is not 0>
	<tr>
		<td>Company Custom Status: </td>
		<td>#qry_selectStatusHistoryList.statusOrder[Variables.companyStatusRow]#. #qry_selectStatusHistoryList.statusTitle[Variables.companyStatusRow]#</td>
	</tr>
</cfif>
--->
<tr>
	<td>Tax Status: </td>
	<td>Company <cfif qry_selectCompany.companyIsTaxExempt is 1>IS<cfelse>is NOT</cfif> tax-exempt.</td>
</tr>
<cfif Variables.displayUser is True>
	<tr>
		<td>Primary Contact: </td>
		<td>
			#qry_selectUser.firstName# #qry_selectUser.lastName# #qry_selectUser.suffix#
			<cfif Application.fn_IsUserAuthorized("viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectCompany.userID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
	<!--- 
	<cfif Variables.userStatusRow is not 0>
		<tr>
			<td>User Custom Status: </td>
			<td>#qry_selectStatusHistoryList.statusOrder[Variables.userStatusRow]#. #qry_selectStatusHistoryList.statusTitle[Variables.userStatusRow]#</td>
		</tr>
	</cfif>
	--->
</cfif>
<cfif qry_selectCompany.companyID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectCompany.companyID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectCompany.companyDBA is not "">
	<tr>
		<td>DBA: </td>
		<td>#qry_selectCompany.companyDBA#</td>
	</tr>
</cfif>
<cfif qry_selectCompany.companyURL is not "">
	<tr>
		<td>URL: </td>
		<td><a href="#qry_selectCompany.companyURL#" class="plainlink">#qry_selectCompany.companyURL#</a></td>
	</tr>
</cfif>
<cfif Variables.displayAffiliate is True>
	<tr>
		<td>Affiliate: </td>
		<td>
			#qry_selectAffiliate.affiliateName#
			<cfif Application.fn_IsUserAuthorized("listCompanyAffiliates")> (<a href="index.cfm?method=company.listCompanyAffiliates&companyID=#qry_selectAffiliate.companyID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
</cfif>
<cfif Variables.displayCobrand is True>
	<tr>
		<td>Cobrand: </td>
		<td>
			#qry_selectCobrand.cobrandName#
			<cfif Application.fn_IsUserAuthorized("listCompanyCobrands")> (<a href="index.cfm?method=company.listCompanyCobrands&companyID=#qry_selectCobrand.companyID#" class="plainlink">go</a>)</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Date Created: </td>
	<td>#DateFormat(qry_selectCompany.companyDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectCompany.companyDateCreated, "hh:mm tt")#</td>
</tr>
<cfif DateCompare(qry_selectCompany.companyDateCreated, qry_selectCompany.companyDateUpdated) is not 0>
	<tr>
		<td>Last Created: </td>
		<td>#DateFormat(qry_selectCompany.companyDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectCompany.companyDateUpdated, "hh:mm tt")#</td>
	</tr>
</cfif>
<cfif Application.fn_IsUserAuthorized("exportCompanies")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectCompany.companyIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectCompany.companyIsExported is not "" and IsDate(qry_selectCompany.companyDateExported)>
				on #DateFormat(qry_selectCompany.companyDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectCompany.companyDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>
<br>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="companyID">
	<cfinvokeargument name="targetID" value="#URL.companyID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="companyID">
	<cfinvokeargument name="targetID" value="#URL.companyID#">
</cfinvoke>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>## Users: </td>
	<td>#qry_selectCompanySummary.companyUserCount#</td>
</tr>
<cfif qry_selectCompany.companyIsCustomer is 1 or qry_selectCompanySummary.companyInvoiceCount is not 0>
	<tr>
		<td>## Invoices/Purchases: </td>
		<td>#qry_selectCompanySummary.companyInvoiceCount#</td>
	</tr>
	<tr>
		<td>Sum of Invoices/Purchases: </td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td> - Including tax &amp; shipping: </td>
		<td><cfif Not IsNumeric(qry_selectCompanySummary.companyInvoiceTotalSum)>$0<cfelse>#DollarFormat(qry_selectCompanySummary.companyInvoiceTotalSum)#</cfif></td>
	</tr>
	<tr>
		<td> - Products only: </td>
		<td><cfif Not IsNumeric(qry_selectCompanySummary.companyInvoiceTotalLineItemSum)>$0<cfelse>#DollarFormat(qry_selectCompanySummary.companyInvoiceTotalLineItemSum)#</cfif></td>
	</tr>
	<tr>
		<td>Total ## of Products Purchased: </td>
		<td><cfif Not IsNumeric(qry_selectCompanySummary.companyInvoiceLineItemQuantitySum)>0<cfelse>#qry_selectCompanySummary.companyInvoiceLineItemQuantitySum#</cfif></td>
	</tr>
	<tr>
		<td>## of Unique Products Purchased: </td>
		<td>#qry_selectCompanySummary.companyInvoiceLineItemProductUniqueCount#</td>
	</tr>
</cfif>
<tr>
	<td>Custom Prices: </td>
	<td>#qry_selectCompanySummary.companyPriceCount# (does not include custom prices via groups, company users, or applied to all customers)</td>
</tr>
<tr>
	<td>## Notes: </td>
	<td>#qry_selectCompanySummary.companyNoteCount#</td>
</tr>
<tr>
	<td>## Tasks: </td>
	<td>#qry_selectCompanySummary.companyTaskCountNotCompleted# open (#qry_selectCompanySummary.companyTaskCountCompleted# completed)</td>
</tr>
</table>
<br>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif qry_selectCompany.companyIsAffiliate is 1 or qry_selectCompanySummary.companyAffiliateCompanyCount is not 0>
	<tr>
		<td>## Companies Registered via Affiliate Site(s): </td>
		<td>#qry_selectCompanySummary.companyAffiliateCompanyCount#</td>
	</tr>
</cfif>
<cfif qry_selectCompany.companyIsCobrand is 1 or qry_selectCompanySummary.companyCobrandCompanyCount is not 0>
	<tr>
		<td>## Companies Registered via Cobrand Site(s): </td>
		<td>#qry_selectCompanySummary.companyCobrandCompanyCount#</td>
	</tr>
</cfif>
<cfif qry_selectCompany.companyIsVendor is 1 or qry_selectCompanySummary.companyVendorProductCount is not 0>
	<tr>
		<td>## Vendor Products: </td>
		<td>#qry_selectCompanySummary.companyVendorProductCount#</td>
	</tr>
	<tr>
		<td>Total ## Vendor Products Sold: </td>
		<td>#qry_selectCompanySummary.companyVendorProductSoldCount#</td>
	</tr>
	<tr>
		<td>Sum of Vendor Products Sold: </td>
		<td>#qry_selectCompanySummary.companyVendorProductSoldTotal#</td>
	</tr>
</cfif>
</table>
</cfoutput>

