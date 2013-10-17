<cfoutput>
<cfif qry_selectSubscriberList.RecordCount is 0>
	<p class="ErrorMessage">No subscribers meet your search criteria.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectSubscriberList">
		<cfset Variables.displayThisSubscription = False>
		<cfif Variables.displaySubscription is True>
			<cfset Variables.subRow = ListFind(ValueList(qry_selectSubscriptionList.subscriberID), qry_selectSubscriberList.subscriberID)>
			<cfif Variables.subRow is not 0>
				<cfset Variables.displayThisSubscription = True>
			</cfif>
		</cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.displayThisSubscription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.displayThisSubscription#','#Variables.bgcolor#');">
		<td>#qry_selectSubscriberList.companyName#<cfif ListFind(Variables.permissionActionList, "viewCompany")> <font class="SmallText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectSubscriberList.companyID#" class="plainlink">go</a>)</font></cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectSubscriberList.subscriberName is "">-<cfelseif qry_selectSubscriberList.subscriberName is qry_selectSubscriberList.companyName>&quot;<cfelse>#qry_selectSubscriberList.subscriberName#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectSubscriberList.userID is 0>-<cfelse>#qry_selectSubscriberList.lastName#, #qry_selectSubscriberList.firstName#<cfif ListFind(Variables.permissionActionList, "viewUser")> <font class="SmallText">(<a href="index.cfm?method=user.viewUser&userID=#qry_selectSubscriberList.userID#" class="plainlink">go</a>)</font></cfif></cfif></td>
		<!--- 
		<td>&nbsp;</td>
		<td><cfif qry_selectSubscriberList.subscriberStatus is 0><font color="red">Inactive</font><cfelseif qry_selectSubscriberList.subscriberCompleted is 1><font color="gold">Completed</font><cfelse><font color="green">Active</font></cfif></td>
		<td><cfif qry_selectSubscriberList.subscriberStatus is 1>Active<cfelse>Cancelled</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectSubscriberList.subscriberCompleted is 1>Completed<cfelse>Open</cfif></td>
		 --->
		<td>&nbsp;</td>
		<td>#qry_selectSubscriberList.subscriberLineItemCount#</td>
		<td>&nbsp;</td>
		<td><cfif Not IsNumeric(qry_selectSubscriberList.subscriberLineItemTotal)>$0.00<cfelse>#DollarFormat(qry_selectSubscriberList.subscriberLineItemTotal)#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectSubscriberList.subscriberDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectSubscriberList.subscriberDateCreated, "hh:mm tt")#</div></td>
		<td>&nbsp;</td>
		<td nowrap><cfif Not IsDate(qry_selectSubscriberList.subscriberDateProcessLast)>-<cfelse>#DateFormat(qry_selectSubscriberList.subscriberDateProcessLast, "mm-dd-yy")#<cfif TimeFormat(qry_selectSubscriberList.subscriberDateProcessLast, "hh:mm tt") is not "12:00 am"><div class="SmallText">#TimeFormat(qry_selectSubscriberList.subscriberDateProcessLast, "hh:mm tt")#</div></cfif></cfif></td>
		<td>&nbsp;</td>
		<td nowrap><cfif Not IsDate(qry_selectSubscriberList.subscriberDateProcessNext)>-<cfelse>#DateFormat(qry_selectSubscriberList.subscriberDateProcessNext, "mm-dd-yy")#<cfif TimeFormat(qry_selectSubscriberList.subscriberDateProcessNext, "hh:mm tt") is not "12:00 am"><div class="SmallText">#TimeFormat(qry_selectSubscriberList.subscriberDateProcessNext, "hh:mm tt")#</div></cfif></cfif></td>
		<cfif ListFind(Variables.permissionActionList, "viewSubscriber")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=subscription.viewSubscriber&subscriberID=#qry_selectSubscriberList.subscriberID#" class="plainlink">Manage</a></td>
		</cfif>
		</tr>

		<cfif Variables.displayThisSubscription is True>
			<tr class="TableText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="2">&nbsp;</td>
			<td colspan="#Variables.columnCount - 2#">
			<i>Active Subscription(s) <cfif Variables.displaySubscriptionBasis is "priceID">using this price<cfelse>for this product</cfif></i>:<br>
			<cfset Variables.thisSubscriberID = qry_selectSubscriberList.subscriberID>
			<cfloop Query="qry_selectSubscriptionList" StartRow="#Variables.subRow#">
				<cfif qry_selectSubscriptionList.subscriberID is not Variables.thisSubscriberID><cfbreak></cfif>
				#qry_selectSubscriptionList.subscriptionName#
				<cfif ListFind(Variables.permissionActionList, "updateSubscription")>
					 <font class="SmallText">[<a href="index.cfm?method=subscription.updateSubscription&subscriberID=#qry_selectSubscriptionList.subscriberID#&subscriptionID=#qry_selectSubscriptionList.subscriptionID#" class="plainlink">Update</a>]</font>
				</cfif>
				<div class="SmallText">
				&nbsp; &nbsp; &nbsp; &nbsp; Created #DateFormat(qry_selectSubscriptionList.subscriptionDateCreated, "mm-dd-yy")#. 
				Begins #DateFormat(qry_selectSubscriptionList.subscriptionDateBegin, "mm-dd-yy")#. 
				<cfif IsDate(qry_selectSubscriptionList.subscriptionDateEnd)>Ends #DateFormat(qry_selectSubscriptionList.subscriptionDateEnd, "mm-dd-yy")#. </cfif>
				<cfif IsDate(qry_selectSubscriptionList.subscriptionDateProcessLast)>Last Processed: #DateFormat(qry_selectSubscriptionList.subscriptionDateProcessLast, "mm-dd-yy")#. </cfif>
				<cfif IsDate(qry_selectSubscriptionList.subscriptionDateProcessNext)>Next Processed: #DateFormat(qry_selectSubscriptionList.subscriptionDateProcessNext, "mm-dd-yy")#. </cfif>
				</div>
			</cfloop>
			</td>
			</tr>
		</cfif>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, Variables.displayAlphabet, Variables.alphabetList)#

	<cfif Application.fn_IsUserAuthorized("exportSubscribers")>
		<cfinclude template="../v_export/form_exportQueryForCompany.cfm">
	</cfif>
</cfif>
</cfoutput>
