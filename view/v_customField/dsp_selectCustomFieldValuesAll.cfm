<cfset Variables.previousUserID = 0>
<cfset Variables.previousCustomFieldID = 0>

<cfoutput>
<p>
<div class="SubTitle"><b>Custom Field Value History</b></div>
#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", False)#
<cfloop Query="qry_selectCustomFieldListForTarget">
	<cfif Variables.displayURLCustomField is False or qry_selectCustomFieldListForTarget.customFieldID is URL.customFieldID>
		<cfif CurrentRow is 1 or qry_selectCustomFieldListForTarget.customFieldID is not qry_selectCustomFieldListForTarget.customFieldID[CurrentRow - 1]>
			<cfset Variables.rowspan = Max(1, Variables.customFieldCount["customField#qry_selectCustomFieldListForTarget.customFieldID#"])>
			<!--- <tr valign="bottom" height="30" class="MainText" bgcolor="dddddd"><td colspan="#Variables.columnCount#"><b>#qry_selectCustomFieldListForTarget.customFieldTitle#</b></td></tr> --->
			<cfif CurrentRow gt 1 and URL.customFieldID is 0><tr><td colspan="#Variables.columnCount#" height="3" align="center"><img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr></cfif>
			<tr valign="top" class="TableText">
			<td class="MainText" rowspan="#Variables.rowspan#">#qry_selectCustomFieldListForTarget.customFieldTitle#: </td>
			<td rowspan="#Variables.rowspan#">&nbsp;</td>
		</cfif>

		<cfset Variables.valueRow = ListFind(ValueList(qry_selectCustomFieldValueList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
		<cfif Variables.valueRow is 0>
			<!--- <tr valign="top" class="TableText"><td colspan="#Variables.columnCount#"> (<i>No values for this custom field.</i>)</td></tr> --->
			<td class="TableText" colspan="#Variables.columnCount - 2#"> (<i>No values for this custom field.</i>)</td>
		<cfelse>
			<cfset Variables.thisCustomFieldID = qry_selectCustomFieldListForTarget.customFieldID>
			<cfset Variables.count = 0>
			<cfloop Query="qry_selectCustomFieldValueList" StartRow="#Variables.valueRow#">
				<cfif qry_selectCustomFieldValueList.customFieldID is not Variables.thisCustomFieldID><cfbreak></cfif>
				<cfif qry_selectCustomFieldValueList.CurrentRow is Variables.valueRow or qry_selectCustomFieldValueList.CurrentRow is 1
						or DateCompare(qry_selectCustomFieldValueList.customFieldValueDateCreated, qry_selectCustomFieldValueList.customFieldValueDateCreated[CurrentRow - 1]) is not 0>
					<cfset Variables.count = Variables.count + 1>
					<cfif Variables.count is not 1></tr><tr valign="top" class="TableText"<cfif (Variables.count mod 2) is 0> bgcolor="f4f4ff"</cfif>></cfif>
					<!--- <tr valign="top" class="TableText"<cfif (Variables.count mod 2) is 0> bgcolor="f4f4ff"</cfif>> --->
					<td align="center">###IncrementValue(Variables.rowspan - Variables.count)#.<!--- #Variables.count#. ---></i></td>
					<td>&nbsp;</td>
					<td>
						<cfset Variables.thisValue = ToString(qry_selectCustomFieldValueList.customFieldValueValue)>
						<cfswitch expression="#qry_selectCustomFieldValueList.customFieldValueType#">
						<cfcase value="Bit"><cfif Variables.thisValue is 1>True<cfelse>False</cfif></cfcase>
						<cfcase value="Decimal">#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.thisValue)#</cfcase>
						<cfcase value="DateTime">#DateFormat(Variables.thisValue, "mmmm dd, yyyy")# at #TimeFormat(Variables.thisValue, "hh:mm tt")#<br>#Variables.thisValue#</cfcase>
						<cfdefaultcase><!--- Varchar,Int --->#HTMLEditFormat(Variables.thisValue)#</cfdefaultcase>
						</cfswitch>
						<!--- 
						<cfset Variables.sameValueDate = True>
						<cfset Variables.thisValueCount = 1>
						<cfset Variables.firstValueRow = qry_selectCustomFieldValueList.CurrentRow>
						<cfset Variables.thisValueRow = Variables.firstValueRow>

						<cfloop Condition="Variables.sameValueDate is True">
							<cfset Variables.thisValueRow = Variables.firstValueRow + Variables.thisValueCount - 1>
							<cfset Variables.thisValue = ToString(qry_selectCustomFieldValueList.customFieldValueValue[Variables.thisValueRow])>
							<cfif Variables.thisValue is "">
								&nbsp;
							<cfelse>
								<cfif Variables.thisValueCount is not 1><br></cfif>
								<cfswitch expression="#qry_selectCustomFieldValueList.customFieldValueType[Variables.thisValueRow]#">
								<cfcase value="Bit"><cfif Variables.thisValue is 1>True<cfelse>False</cfif></cfcase>
								<cfcase value="Decimal">#Application.fn_LimitPaddedDecimalZerosQuantity(Variables.thisValue)#</cfcase>
								<cfcase value="DateTime">#DateFormat(Variables.thisValue, "mmmm dd, yyyy")# at #TimeFormat(Variables.thisValue, "hh:mm tt")#<br>#Variables.thisValue#</cfcase>
								<cfdefaultcase><!--- Varchar,Int --->#HTMLEditFormat(Variables.thisValue)#</cfdefaultcase>
								</cfswitch>
							</cfif>
							<cfif Variables.thisValueRow is qry_selectCustomFieldValueList.RecordCount or DateCompare(qry_selectCustomFieldValueList.customFieldValueDateCreated[Variables.thisValueRow], qry_selectCustomFieldValueList.customFieldValueDateCreated[Variables.thisValueRow + 1]) is not 0>
								<cfset Variables.sameValueDate = False>
							<cfelse>
								<cfset Variables.thisValueCount = Variables.thisValueCount + 1>
							</cfif>
						</cfloop>
						--->
					</td>
					<td>&nbsp;</td>
					<td align="center"><cfif qry_selectCustomFieldValueList.customFieldValueStatus is 1><font color="green">Current</font><cfelse><font color="red">Archived</font></cfif></td>
					<td>&nbsp;</td>
					<td align="center" nowrap>#DateFormat(qry_selectCustomFieldValueList.customFieldValueDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectCustomFieldValueList.customFieldValueDateCreated, "hh:mm tt")#</div></td>
					<td>&nbsp;</td>
					<cfset Variables.userRow = ListFind(ValueList(qry_selectUserList.userID), qry_selectCustomFieldValueList.userID)>
					<td>
						<cfif Variables.userRow is 0>
							&nbsp;
						<cfelseif qry_selectCustomFieldValueList.customFieldID is Variables.previousCustomFieldID and qry_selectCustomFieldValueList.userID is Variables.previousUserID>
							<div align="center">&quot;</div>
						<cfelse>
							#qry_selectUserList.lastName[Variables.userRow]#, #qry_selectUserList.firstName[Variables.userRow]#<br>
							<cfif qry_selectUserList.companyID is not Session.companyID>#qry_selectUserList.companyName[Variables.userRow]#</cfif>
						</cfif>
					</td>
					<!--- </tr> --->
					<cfset Variables.previousUserID = qry_selectCustomFieldValueList.userID>
					<cfset Variables.previousCustomFieldID = qry_selectCustomFieldValueList.customFieldID>
				</cfif>
			</cfloop>
		</cfif>
		</tr>
	</cfif>
</cfloop>
</table>
</p>
</cfoutput>
