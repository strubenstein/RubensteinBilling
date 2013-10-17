<cfoutput>
<cfif qry_selectPaymentCreditList.RecordCount is 0>
	<p class="ErrorMessage">No payment credits meet your search criteria.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectPaymentCreditList">
		<cfif qry_selectPaymentCreditList.paymentCreditDescription is not ""><cfset Variables.showDescription = True><cfelse><cfset Variables.showDescription = False></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<cfif Variables.displayPaymentCreditID_custom is True>
			<td><cfif qry_selectPaymentCreditList.paymentCreditID_custom is "">&nbsp;<cfelse>#qry_selectPaymentCreditList.paymentCreditID_custom#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<cfif Variables.displayPaymentCreditName is True>
			<td><cfif qry_selectPaymentCreditList.paymentCreditName is "">&nbsp;<cfelse>#qry_selectPaymentCreditList.paymentCreditName#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		<td>
			<cfif qry_selectPaymentCreditList.targetCompanyName is "">&nbsp;<cfelse>#qry_selectPaymentCreditList.targetCompanyName#</cfif>
			<cfif qry_selectPaymentCreditList.companyID is not 0 and ListFind(Variables.permissionActionList, "viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectPaymentCreditList.companyID#" class="plainlink">Go</a>)</cfif>
			<cfif qry_selectPaymentCreditList.subscriberName is not ""><div class="SmallText"><i>Subscriber</i>: #qry_selectPaymentCreditList.subscriberName#</div></cfif>
		</td>
		<!--- 
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectPaymentCreditList.targetLastName is "">&nbsp;<cfelse>#qry_selectPaymentCreditList.targetLastName#, #qry_selectPaymentCreditList.targetFirstName#</cfif>
			<cfif qry_selectPaymentCreditList.userID is not 0 and ListFind(Variables.permissionActionList, "viewUser")>
				 (<a href="index.cfm?method=user.viewUser&userID=#qry_selectPaymentCreditList.userID#" class="plainlink">Go</a>)
			</cfif>
		</td>
		--->
		<td>&nbsp;</td>
		<td>#DollarFormat(qry_selectPaymentCreditList.paymentCreditAmount)#</td>
		<td>&nbsp;</td>
		<td class="SmallText">#qry_selectPaymentCreditList.paymentCreditAppliedCount# of #qry_selectPaymentCreditList.paymentCreditAppliedMaximum#</td>
		<td>&nbsp;</td>
		<td><cfif Not IsDate(qry_selectPaymentCreditList.paymentCreditDateBegin)>n/a<cfelse>#DateFormat(qry_selectPaymentCreditList.paymentCreditDateBegin, "mm-dd-yy")#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif Not IsDate(qry_selectPaymentCreditList.paymentCreditDateEnd)>n/a<cfelse>#DateFormat(qry_selectPaymentCreditList.paymentCreditDateEnd, "mm-dd-yy")#</cfif></td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectPaymentCreditList.paymentCreditDateCreated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "updatePaymentCredit") or ListFind(Variables.permissionActionList, "viewPaymentCredit") or Variables.doAction is "applyPaymentCreditsToInvoice">
			<td>&nbsp;</td>
			<td class="SmallText"><a href="#Variables.manageURL#=#qry_selectPaymentCreditList.paymentCreditID#" class="plainlink">#Variables.manageText#</a></td>
		</cfif>
		</tr>
		<cfif Variables.showDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#"><i>Description</i>: #qry_selectPaymentCreditList.paymentCreditDescription#</td>
			</tr>
		</cfif>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, False, "")#

	<cfif Application.fn_IsUserAuthorized("exportPaymentCredits")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
