<cfoutput>
<cfif qry_selectShippingList.RecordCount is 0>
	<p class="ErrorMessage">There are no shipments for this purchase/invoice yet.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.shippingColumnCount, 0, 0, 0, Variables.shippingColumnList, "", True)#
	<cfloop Query="qry_selectShippingList">
		<tr valign="top" class="TableText"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectShippingList.shippingCarrier#</td>
		<td>&nbsp;</td>
		<td>#qry_selectShippingList.shippingMethod#</td>
		<td>&nbsp;</td>
		<td align="center"><cfif qry_selectShippingList.shippingWeight is 0>&nbsp;<cfelse>#qry_selectShippingList.shippingWeight#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectShippingList.shippingTrackingNumber is "">&nbsp;<cfelse>#qry_selectShippingList.shippingTrackingNumber#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectShippingList.shippingInstructions is "">&nbsp;<cfelse>#qry_selectShippingList.shippingInstructions#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectShippingList.shippingSent is 0><font color="red">Not Sent</font><br><cfelseif Not IsDate(qry_selectShippingList.shippingDateSent)><font color="green">Sent</font></cfif>
			<cfif IsDate(qry_selectShippingList.shippingDateSent)>#DateFormat(qry_selectShippingList.shippingDateSent, "mm/dd/yy")#<div class="SmallText">#TimeFormat(qry_selectShippingList.shippingDateSent, "hh:mm tt")#</div></cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectShippingList.shippingReceived is 0><font color="red">Not Received</font><br><cfelseif Not IsDate(qry_selectShippingList.shippingDateReceived)><font color="green">Received</font></cfif>
			<cfif IsDate(qry_selectShippingList.shippingDateReceived)>#DateFormat(qry_selectShippingList.shippingDateReceived, "mm/dd/yy")#<div class="SmallText">#TimeFormat(qry_selectShippingList.shippingDateReceived, "hh:mm tt")#</div></cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectShippingList.shippingStatus is 1><font color="green">Active</font><cfelse><font color="red">Cancelled</font></cfif></td>
		<td>&nbsp;</td>
		<td>#DateFormat(qry_selectShippingList.shippingDateCreated, "mm/dd/yy")#<div class="SmallText">#TimeFormat(qry_selectShippingList.shippingDateCreated, "hh:mm tt")#</div></td>
		<cfif ListFind(Variables.permissionActionList, "updateStatus")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=#URL.control#.updateShipping&invoiceID=#URL.invoiceID#&shippingID=#qry_selectShippingList.shippingID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
