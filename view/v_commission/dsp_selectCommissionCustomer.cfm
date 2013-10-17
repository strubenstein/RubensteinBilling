<cfoutput>
<cfif qry_selectCommissionCustomerList.RecordCount is 0>
	<p class="ErrorMessage">There are no salespeople for this company.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfset Variables.rowBG = 1>
	<cfloop Query="qry_selectCommissionCustomerList">
		<cfif qry_selectCommissionCustomerList.commissionCustomerDescription is not ""><cfset Variables.showDescription = True><cfelse><cfset Variables.showDescription = False></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<cfif Variables.displaySalesperson is True>
			<td>#qry_selectCommissionCustomerList.lastName#, #qry_selectCommissionCustomerList.firstName#</td>
			<td>&nbsp;</td>
		</cfif>
		<td class="SmallText">
			<cfif Variables.displaySalesperson is False>
				<cfif qry_selectCommissionCustomerList.companyName is "">(no company name)<cfelse>#qry_selectCommissionCustomerList.companyName#</cfif>
				<cfif ListFind(Variables.permissionActionList, "viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectCommissionCustomerList.companyID#" class="plainlink">go</a>)</cfif><br>
			</cfif>
			<cfif qry_selectCommissionCustomerList.commissionCustomerAllUsers is 1>
				All users<br>
			<cfelseif StructKeyExists(Variables.commissionUserStruct, "commissionCustomer#qry_selectCommissionCustomerList.commissionCustomerID#")>
				<cfset Variables.thisCCID = qry_selectCommissionCustomerList.commissionCustomerID>
				<cfloop Query="qry_selectCommissionCustomerUser" StartRow="#Variables.commissionUserStruct["commissionCustomer#Variables.thisCCID#"]#">
					<cfif qry_selectCommissionCustomerUser.commissionCustomerID is not Variables.thisCCID><cfbreak></cfif>
					User: #qry_selectCommissionCustomerUser.firstName# #qry_selectCommissionCustomerUser.lastName#<cfif ListFind(Variables.permissionActionList, "viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectCommissionCustomerUser.userID#" class="plainlink">go</a>)</cfif><br>
				</cfloop>
			</cfif>
			<cfif qry_selectCommissionCustomerList.commissionCustomerAllSubscribers is 1>
				All subscribers<br>
			<cfelseif StructKeyExists(Variables.commissionSubscriberStruct, "commissionCustomer#qry_selectCommissionCustomerList.commissionCustomerID#")>
				<cfset Variables.thisCCID = qry_selectCommissionCustomerList.commissionCustomerID>
				<cfloop Query="qry_selectCommissionCustomerSubscriber" StartRow="#Variables.commissionSubscriberStruct["commissionCustomer#Variables.thisCCID#"]#">
					<cfif qry_selectCommissionCustomerSubscriber.commissionCustomerID is not Variables.thisCCID><cfbreak></cfif>
					Subscriber: #qry_selectCommissionCustomerSubscriber.subscriberName#<cfif ListFind(Variables.permissionActionList, "viewSubscriber")> (<a href="index.cfm?method=subscription.viewSubscriber&subscriberID=#qry_selectCommissionCustomerSubscriber.subscriberID#" class="plainlink">go</a>)</cfif><br>
				</cfloop>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectCommissionCustomerList.commissionCustomerPercent * 100, 2)#%</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCommissionCustomerList.commissionCustomerPrimary is 1>Primary<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectCommissionCustomerList.commissionCustomerDateBegin, "mm/dd/yy")#</td>
		<td>&nbsp;</td>
		<td><cfif Not IsDate(qry_selectCommissionCustomerList.commissionCustomerDateEnd)>-<cfelse>#DateFormat(qry_selectCommissionCustomerList.commissionCustomerDateEnd, "mm/dd/yy")#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectCommissionCustomerList.commissionCustomerStatus is 1>
				<font color="green">Active</font>
				<cfif ListFind(Variables.permissionActionList, "updateCommissionCustomer")><div class="SmallText"><a href="index.cfm?method=#URL.control#.updateCommissionCustomerStatus#Variables.urlParameters#&commissionCustomerID=#qry_selectCommissionCustomerList.commissionCustomerID#" class="plainlink" onmouseout="window.status=''; return true;" onmouseover="window.status='Verify Request'; return true;" title="Verify Request" onclick="return confirm('Are you sure you want to make this commission for this salesperson inactive for this customer?');">Make Inactive</a></div></cfif>
			<cfelse>
				<font color="red">Inactive</font>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectCommissionCustomerList.commissionCustomerDateCreated, "mm/dd/yy")#</td>
		<td>&nbsp;</td>
		<td><cfif DateCompare(qry_selectCommissionCustomerList.commissionCustomerDateCreated, qry_selectCommissionCustomerList.commissionCustomerDateUpdated) is 0>-<cfelse>#DateFormat(qry_selectCommissionCustomerList.commissionCustomerDateUpdated, "mm/dd/yy")#</cfif></td>
		<cfif ListFind(Variables.permissionActionList, "updateCommissionCustomer")>
			<td>&nbsp;</td>
			<td class="SmallText"><cfif qry_selectCommissionCustomerList.commissionCustomerStatus is 0>-<cfelse><a href="index.cfm?method=#URL.control#.updateCommissionCustomer#Variables.urlParameters#&commissionCustomerID=#qry_selectCommissionCustomerList.commissionCustomerID#" class="plainlink">Update</a></cfif></td>
		</cfif>
		</tr>
		<cfif Variables.showDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
				<td colspan="4">&nbsp;</td>
				<td colspan="#Variables.columnCount - 4#"><i>Description: </i>#qry_selectCommissionCustomerList.commissionCustomerDescription#</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>
