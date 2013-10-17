<cfoutput>
<cfif qry_selectCreditCardList.RecordCount is 0>
	<p class="ErrorMessage">This <cfif URL.userID is not 0>user<cfelse>company</cfif> has no listed credit cards.</p>
<cfelse>
	<cfif ListFind(Variables.permissionActionList, "deleteCreditCard")>
		<form method="post" action="#Variables.creditCardActionDelete#">
		<input type="hidden" name="isFormSubmitted" value="True">
	</cfif>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.creditCardColumnCount, 0, 0, 0, Variables.creditCardColumnList, "", True)#
	<cfloop Query="qry_selectCreditCardList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif ListFind(Variables.permissionActionList, "deleteCreditCard")>
			<td><cfif qry_selectCreditCardList.creditCardStatus is 1>-<cfelse><input type="radio" name="creditCardID" value="#qry_selectCreditCardList.creditCardID#"></cfif></td><td>&nbsp;</td>
		</cfif>
		<td><cfif qry_selectCreditCardList.creditCardDescription is "">&nbsp;<cfelse>#qry_selectCreditCardList.creditCardDescription#</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectCreditCardList.userID is 0>Company<cfelseif Variables.doControl is "user">User<cfelse>#qry_selectCreditCardList.firstName# #qry_selectCreditCardList.lastName#</cfif></td><td>&nbsp;</td>
		<td>
			<cfif qry_selectCreditCardList.creditCardStatus is 1>
				<font color="green">Active</font><cfif ListFind(Variables.permissionActionList, "updateCreditCardStatus0")><div class="SmallText"><a href="#Variables.creditCardActionStatusArchived#&creditCardID=#qry_selectCreditCardList.creditCardID#" class="plainlink">Change to<br>Archived</a></div></cfif>
			<cfelse>
				<font color="red">Archived</font><cfif ListFind(Variables.permissionActionList, "updateCreditCardStatus1")><div class="SmallText"><a href="#Variables.creditCardActionStatusActive#&creditCardID=#qry_selectCreditCardList.creditCardID#" class="plainlink">Change to<br>Active</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectCreditCardList.creditCardRetain is 1>
				<font color="green">Retain</font><cfif ListFind(Variables.permissionActionList, "updateCreditCardRetain0")><div class="SmallText"><a href="#Variables.creditCardActionRetainNo#&creditCardID=#qry_selectCreditCardList.creditCardID#" class="plainlink">Change to<br>Delete</a></div></cfif>
			<cfelse>
				<font color="red">Delete</font><cfif ListFind(Variables.permissionActionList, "updateCreditCardRetain1")><div class="SmallText"><a href="#Variables.creditCardActionRetainYes#&creditCardID=#qry_selectCreditCardList.creditCardID#" class="plainlink">Change to<br>Retain</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectCreditCardList.creditCardName is "">&nbsp;<cfelse>#qry_selectCreditCardList.creditCardName#</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectCreditCardList.creditCardType is "">&nbsp;<cfelse>#qry_selectCreditCardList.creditCardType#</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectCreditCardList.creditCardNumber is "">&nbsp;<cfelse>#RepeatString("*", Len(qry_selectCreditCardList.creditCardNumber) - 4)##Right(qry_selectCreditCardList.creditCardNumber, 4)#</cfif></td><td>&nbsp;</td>
		<td>#qry_selectCreditCardList.creditCardExpirationMonth#/#qry_selectCreditCardList.creditCardExpirationYear#</td><td>&nbsp;</td>
		<td><cfswitch expression="#qry_selectCreditCardList.creditCardCVCstatus#"><cfcase value="1">Accepted</cfcase><cfcase value="0">Rejected</cfcase><cfdefaultcase>n/a</cfdefaultcase></cfswitch></td><td>&nbsp;</td>
		<td><cfif qry_selectCreditCardList.addressName is "">&nbsp;<cfelse>#qry_selectCreditCardList.addressName#</cfif></td><td>&nbsp;</td>
		<td>
			<cfif qry_selectCreditCardList.city is "">&nbsp;<cfelse>#qry_selectCreditCardList.city#</cfif>
			<cfif qry_selectCreditCardList.state is "">&nbsp;<cfelse><cfif qry_selectCreditCardList.city is "">, </cfif>#qry_selectCreditCardList.state#</cfif>
		</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCreditCardList.creditCardDateCreated, "mm-dd-yy")#</td><td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectCreditCardList.creditCardDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "insertCreditCard")>
			<td>&nbsp;</td><td class="SmallText"><cfif qry_selectCreditCardList.creditCardStatus is 0>-<cfelse><a href="#Variables.creditCardActionUpdate#&creditCardID=#qry_selectCreditCardList.creditCardID#" class="plainlink">Update</a></cfif></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "viewCreditCard")>
			<td>&nbsp;</td><td class="SmallText"><a href="#Variables.creditCardActionView#&creditCardID=#qry_selectCreditCardList.creditCardID#" class="plainlink">View</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>

	<cfif ListFind(Variables.permissionActionList, "deleteCreditCard")>
		<p><input type="submit" name="submitDeleteCreditCard" value="Delete Credit Card" onmouseout="window.status=''; return true;" onmouseover="window.status='Verify Delete'; return true;" title="Verify Delete" onclick="return confirm('Are you sure you want to delete the selected credit card(s)?');"></p>
		</form>
	</cfif>
</cfif>
</cfoutput>
