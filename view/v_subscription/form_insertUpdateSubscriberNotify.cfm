<cfoutput>
<cfif qry_selectUserList.RecordCount is 0>
	<p class="ErrorMessage">No users are set to be notified for this subscriber.</p>
<cfelse>
	<p class="MainText">Note: Word document, PDF document and fax are not yet enabled.</p>

	<form method="post" name="subscriberNotify" action="#Variables.formAction#">
	<input type="hidden" name="isFormSubmitted" value="True">
	<cfif Variables.doAction is "insertSubscriberNotify">
		<input type="hidden" name="userID" value="#Form.userID#">
	</cfif>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
	<cfloop Query="qry_selectUserList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectUserList.lastName#, #qry_selectUserList.firstName#</td>
		<td>&nbsp;</td>
		<td align="center"><input type="checkbox" name="subscriberNotifyEmail#qry_selectUserList.userID#" value="1"<cfif Form["subscriberNotifyEmail#qry_selectUserList.userID#"] is 1> checked</cfif>></td>
		<td>&nbsp;</td>
		<td align="center"><input type="checkbox" name="subscriberNotifyEmailHtml#qry_selectUserList.userID#" value="1"<cfif Form["subscriberNotifyEmailHtml#qry_selectUserList.userID#"] is 1> checked</cfif>></td>
		<td>&nbsp;</td>
		<td align="center"><input type="checkbox" name="subscriberNotifyPdf#qry_selectUserList.userID#" value="1"<cfif Form["subscriberNotifyPdf#qry_selectUserList.userID#"] is 1> checked</cfif>></td>
		<td>&nbsp;</td>
		<td align="center"><input type="checkbox" name="subscriberNotifyDoc#qry_selectUserList.userID#" value="1"<cfif Form["subscriberNotifyDoc#qry_selectUserList.userID#"] is 1> checked</cfif>></td>
		<td>&nbsp;</td>
		<td>
			<select name="phoneID#qry_selectUserList.userID#" size="1">
			<option value="0">-- NO FAX --</option>
			<cfloop Query="qry_selectPhoneList">
				<cfif Form["phoneID#qry_selectUserList.userID#"] is qry_selectPhoneList.phoneID or qry_selectPhoneList.userID is qry_selectUserList.userID or (qry_selectPhoneList.companyID is qry_selectUserList.companyID and qry_selectPhoneList.userID is 0)>
					<option value="#qry_selectPhoneList.phoneID#"<cfif Form["phoneID#qry_selectUserList.userID#"] is qry_selectPhoneList.phoneID> selected</cfif>>(#HTMLEditFormat(qry_selectPhoneList.phoneAreaCode)#) <cfif Len(qry_selectPhoneList.phoneNumber) is not 7 or Not IsNumeric(qry_selectPhoneList.phoneNumber)>#HTMLEditFormat(qry_selectPhoneList.phoneNumber)#<cfelse>#Left(qry_selectPhoneList.phoneNumber, 3)#-#Right(qry_selectPhoneList.phoneNumber, 4)#</cfif></option>
				</cfif>
			</cfloop>
			</select>
		</td>
		<td>&nbsp;</td>
		<td class="SmallText">
			<label><input type="radio" name="addressID#qry_selectUserList.userID#" value="0"<cfif Form["addressID#qry_selectUserList.userID#"] is 0> checked</cfif>>Do not mail invoice</label><br>
			<cfloop Query="qry_selectAddressList">
				<cfif Form["addressID#qry_selectUserList.userID#"] is qry_selectAddressList.addressID or qry_selectAddressList.userID is qry_selectUserList.userID or (qry_selectAddressList.companyID is qry_selectUserList.companyID and qry_selectAddressList.userID is 0)>
					<label><input type="radio" name="addressID#qry_selectUserList.userID#" value="#qry_selectAddressList.addressID#"<cfif Form["addressID#qry_selectUserList.userID#"] is qry_selectAddressList.addressID> checked</cfif>>#qry_selectAddressList.address# #qry_selectAddressList.address2# / #qry_selectAddressList.city#, #qry_selectAddressList.state# #qry_selectAddressList.zipCode#<cfif qry_selectAddressList.zipCodePlus4 is not "">-#qry_selectAddressList.zipCodePlus4#</cfif></label>
				</cfif>
			</cfloop>
			</select>
		</td>
		</tr>
	</cfloop>
	<cfif Variables.formAction is not "">
		<tr><th colspan="#Variables.columnCount#"><input type="submit" name="submitUpdateSubscriberNotify" value="#HTMLEditFormat(Variables.formSubmitValue)#"></th></tr>
	</cfif>
	</table>
	</form>
</cfif>
</cfoutput>
