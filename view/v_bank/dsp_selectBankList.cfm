<cfoutput>
<cfif qry_selectBankList.RecordCount is 0>
	<p class="ErrorMessage">This <cfif URL.userID is not 0>user<cfelse>company</cfif> has no listed bank accounts.</p>
<cfelse>
	<cfif ListFind(Variables.permissionActionList, "deleteBank")>
		<form method="post" action="#Variables.bankActionDelete#">
		<input type="hidden" name="isFormSubmitted" value="True">
	</cfif>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.bankColumnCount, 0, 0, 0, Variables.bankColumnList, "", True)#
	<cfloop Query="qry_selectBankList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<cfif ListFind(Variables.permissionActionList, "deleteBank")>
			<td><cfif qry_selectBankList.bankStatus is 1>-<cfelse><input type="radio" name="bankID" value="#qry_selectBankList.bankID#"></cfif></td><td>&nbsp;</td>
		</cfif>
		<td><cfif qry_selectBankList.bankDescription is "">&nbsp;<cfelse>#qry_selectBankList.bankDescription#</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectBankList.userID is 0>Company<cfelseif Variables.doControl is "user">User<cfelse>#qry_selectBankList.firstName# #qry_selectBankList.lastName#</cfif></td><td>&nbsp;</td>
		<td>
			<cfif qry_selectBankList.bankStatus is 1>
				<font color="green">Active</font><cfif ListFind(Variables.permissionActionList, "updateBankStatus0")><div class="SmallText"><a href="#Variables.bankActionStatusArchived#&bankID=#qry_selectBankList.bankID#" class="plainlink">Change to<br>Archived</a></div></cfif>
			<cfelse>
				<font color="red">Archived</font><cfif ListFind(Variables.permissionActionList, "updateBankStatus1")><div class="SmallText"><a href="#Variables.bankActionStatusActive#&bankID=#qry_selectBankList.bankID#" class="plainlink">Change to<br>Active</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectBankList.bankRetain is 1>
				<font color="green">Retain</font><cfif ListFind(Variables.permissionActionList, "updateBankRetain0")><div class="SmallText"><a href="#Variables.bankActionRetainNo#&bankID=#qry_selectBankList.bankID#" class="plainlink">Change to<br>Delete</a></div></cfif>
			<cfelse>
				<font color="red">Delete</font><cfif ListFind(Variables.permissionActionList, "updateBankRetain1")><div class="SmallText"><a href="#Variables.bankActionRetainYes#&bankID=#qry_selectBankList.bankID#" class="plainlink">Change to<br>Retain</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectBankList.bankName is "">&nbsp;<cfelse>#qry_selectBankList.bankName#</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectBankList.bankAccountName is "">&nbsp;<cfelse>#qry_selectBankList.bankAccountName#</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectBankList.bankPersonalOrCorporate is 0>Personal<cfelse>Corporate</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectBankList.bankCheckingOrSavings is 0>Checking<cfelseif qry_selectBankList.bankCheckingOrSavings is 1>Savings<cfelseif qry_selectBankList.bankAccountType is "">&nbsp;<cfelse>#qry_selectBankList.bankAccountType#</cfif></td><td>&nbsp;</td>
		<td><cfif qry_selectBankList.bankAccountNumber is "">&nbsp;<cfelse>#qry_selectBankList.bankAccountNumber#</cfif></td><td>&nbsp;</td>
		<td>
			<cfif qry_selectBankList.bankBranchCity is "">&nbsp;<cfelse>#qry_selectBankList.bankBranchCity#</cfif>
			<cfif qry_selectBankList.bankBranchState is "">&nbsp;<cfelse><cfif qry_selectBankList.bankBranchCity is not "">, </cfif>#qry_selectBankList.bankBranchState#</cfif>
		</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectBankList.bankDateCreated, "mm-dd-yy")#</td><td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectBankList.bankDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "insertBank")>
			<td>&nbsp;</td>
			<td class="SmallText"><cfif qry_selectBankList.bankStatus is 0>-<cfelse><a href="#Variables.bankActionUpdate#&bankID=#qry_selectBankList.bankID#" class="plainlink">Update</a></cfif></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "viewBank")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="#Variables.bankActionView#&bankID=#qry_selectBankList.bankID#" class="plainlink">View</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>

	<cfif ListFind(Variables.permissionActionList, "deleteBank")>
		<p><input type="submit" name="submitDeleteBank" value="Delete Bank" onmouseout="window.status=''; return true;" onmouseover="window.status='Verify Delete'; return true;" title="Verify Delete" onclick="return confirm('Are you sure you want to delete the selected bank account(s)?');"></p>
		</form>
	</cfif>
</cfif>
</cfoutput>
