<cfoutput>
<cfif qry_selectPhoneList.RecordCount is 0>
	<p class="ErrorMessage">This <cfif URL.userID is not 0>user<cfelse>company</cfif> has no listed phone numbers.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.phoneColumnCount, 0, 0, 0, Variables.phoneColumnList, "", True)#
	<cfloop Query="qry_selectPhoneList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td><cfif qry_selectPhoneList.phoneType is "">&nbsp;<cfelse>#qry_selectPhoneList.phoneType#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectPhoneList.phoneVersion#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPhoneList.userID is 0>Company<cfelseif Variables.doControl is "user">User<cfelse>#qry_selectPhoneList.firstName# #qry_selectPhoneList.lastName#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectPhoneList.phoneStatus is 1>
				<font color="green">Active</font><cfif ListFind(Variables.permissionActionList, "updatePhoneStatus0")><div class="SmallText"><a href="#Variables.phoneActionStatusArchived#&phoneID=#qry_selectPhoneList.phoneID#" class="plainlink">Change to<br>Archived</a></div></cfif>
			<cfelse>
				<font color="red">Archived</font><cfif ListFind(Variables.permissionActionList, "updatePhoneStatus1")><div class="SmallText"><a href="#Variables.phoneActionStatusActive#&phoneID=#qry_selectPhoneList.phoneID#" class="plainlink">Change to<br>Active</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPhoneList.phoneAreaCode is "">&nbsp;<cfelse>#qry_selectPhoneList.phoneAreaCode#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectPhoneList.phoneNumber is "">&nbsp;
			<cfelseif Len(qry_selectPhoneList.phoneNumber) is 7>#Left(qry_selectPhoneList.phoneNumber, 3)#-#Right(qry_selectPhoneList.phoneNumber, 4)#
			<cfelse>#qry_selectPhoneList.phoneNumber#
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPhoneList.phoneExtension is "">&nbsp;<cfelse>x#qry_selectPhoneList.phoneExtension#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectPhoneList.phoneDescription is "">&nbsp;<cfelse>x#qry_selectPhoneList.phoneDescription#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPhoneList.phoneDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectPhoneList.phoneDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "insertPhone")>
			<td>&nbsp;</td>
			<td class="SmallText"><cfif qry_selectPhoneList.phoneStatus is 0>-<cfelse><a href="#Variables.phoneActionUpdate#&phoneID=#qry_selectPhoneList.phoneID#" class="plainlink">Update</a></cfif></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
