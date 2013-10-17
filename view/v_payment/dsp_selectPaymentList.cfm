<cfoutput>
<cfif qry_selectPaymentList.RecordCount is 0>
	<p class="ErrorMessage">No payments meet your search criteria.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectPaymentList">
		<cfif qry_selectPaymentList.paymentDescription is not "" or qry_selectPaymentList.paymentMessage is not ""><cfset Variables.showDescription = True><cfelse><cfset Variables.showDescription = False></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<cfif Variables.displayPaymentID_custom is True>
			<td><cfif qry_selectPaymentList.paymentID_custom is "">&nbsp;<cfelse>#qry_selectPaymentList.paymentID_custom#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<td>
			<cfif qry_selectPaymentList.targetCompanyName is "">&nbsp;<cfelse>#qry_selectPaymentList.targetCompanyName#</cfif>
			<cfif qry_selectPaymentList.companyID is not 0 and ListFind(Variables.permissionActionList, "viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectPaymentList.companyID#" class="plainlink">Go</a>)</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectPaymentList.targetLastName is "">&nbsp;<cfelse>#qry_selectPaymentList.targetLastName#, #qry_selectPaymentList.targetFirstName#</cfif>
			<cfif qry_selectPaymentList.userID is not 0 and ListFind(Variables.permissionActionList, "viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectPaymentList.userID#" class="plainlink">Go</a>)</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectPaymentList.paymentID_refund is not 0><div class="SmallText">REFUNDED</div></cfif>
			<cfif qry_selectPaymentList.paymentStatus is 0><div class="SmallText">Ignored</div></cfif>
			#fn_DisplayPaymentApproved(qry_selectPaymentList.paymentApproved)#
		</td>
		<td>&nbsp;</td>
		<td>#DollarFormat(qry_selectPaymentList.paymentAmount)#</td>
		<td>&nbsp;</td>
		<td class="SmallText">
			<cfif qry_selectPaymentList.paymentMethod is not "">#qry_selectPaymentList.paymentMethod#<br></cfif>
			<cfif qry_selectPaymentList.paymentCheckNumber is not 0>Check ###qry_selectPaymentList.paymentCheckNumber#<br></cfif>
			<cfif qry_selectPaymentList.paymentManual is 0>Manual<cfelse>Scheduled</cfif>
		</td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectPaymentList.paymentDateReceived, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPaymentList.paymentDateReceived, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td><cfif Not IsDate(qry_selectPaymentList.paymentDateScheduled)>-<cfelse>#DateFormat(qry_selectPaymentList.paymentDateScheduled, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectPaymentList.paymentDateScheduled, "hh:mm tt")#</div></cfif></td>
		<cfif ListFind(Variables.permissionActionList, "updatePayment") or ListFind(Variables.permissionActionList, "viewPayment") or Variables.doAction is "applyPaymentsToInvoice">
			<td>&nbsp;</td>
			<td class="SmallText"><a href="#Variables.manageURL#=#qry_selectPaymentList.paymentID#" class="plainlink">#Variables.manageText#</a></td>
		</cfif>
		</tr>
		<cfif Variables.showDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#">
				<cfif qry_selectPaymentList.paymentDescription is not ""><i>Description</i>: #qry_selectPaymentList.paymentDescription#<br></cfif>
				<cfif qry_selectPaymentList.paymentMessage is not ""><i>Error Message</i>: #qry_selectPaymentList.paymentMessage#</cfif>
			</td>
			</tr>
		</cfif>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, False, "")#

	<cfif (Variables.doAction is "listPayments" and Application.fn_IsUserAuthorized("exportPayments"))
			or (Variables.doAction is "listPaymentRefunds" and Application.fn_IsUserAuthorized("exportPaymentRefunds"))>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
