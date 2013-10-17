<cfoutput>
<p>
<div class="SubTitle"><b>Custom Field Value History</b></div>
<table border="0" cellspacing="0" cellpadding="2">
<tr class="TableHeader" valign="bottom" align="left">
	<th>Custom Field</th><th>&nbsp;</th>
	<th>Ver-<br>sion</th><th>&nbsp;</th>
	<th>Value</th><th>&nbsp;</th>
	<th>Status</th><th>&nbsp;</th>
	<th>Date<br>Created</th><th>&nbsp;</th>
	<th>User Who<br>Set Value</th>
</tr>
<tr><td colspan="#methodStruct.columnCount#" height="3" align="center"><img src="#Application.billingUrlRoot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr>

<cfloop Query="qry_selectCustomFieldListForTarget">
	<cfif methodStruct.displayURLCustomField is False or qry_selectCustomFieldListForTarget.customFieldID is Arguments.customFieldID>
		<cfif CurrentRow is 1 or qry_selectCustomFieldListForTarget.customFieldID is not qry_selectCustomFieldListForTarget.customFieldID[CurrentRow - 1]>
			<cfset methodStruct.rowspan = Max(1, customFieldCount["customField#qry_selectCustomFieldListForTarget.customFieldID#"])>
			<cfif CurrentRow gt 1 and methodStruct.displayURLCustomField is False><tr><td colspan="#methodStruct.columnCount#" height="3" align="center"><img src="#Application.billingUrlRoot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr></cfif>
			<tr valign="top" class="TableText">
			<td class="MainText" rowspan="#methodStruct.rowspan#">#qry_selectCustomFieldListForTarget.customFieldTitle#: </td>
			<td rowspan="#methodStruct.rowspan#">&nbsp;</td>
		</cfif>

		<cfset methodStruct.valueRow = ListFind(ValueList(qry_selectCustomFieldValueList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
		<cfif methodStruct.valueRow is 0>
			<td class="TableText" colspan="#methodStruct.columnCount - 2#"> (<i>No values for this custom field.</i>)</td>
		<cfelse>
			<cfset methodStruct.thisCustomFieldID = qry_selectCustomFieldListForTarget.customFieldID>
			<cfset methodStruct.count = 0>
			<cfloop Query="qry_selectCustomFieldValueList" StartRow="#methodStruct.valueRow#">
				<cfif qry_selectCustomFieldValueList.customFieldID is not methodStruct.thisCustomFieldID><cfbreak></cfif>
				<cfif qry_selectCustomFieldValueList.CurrentRow is methodStruct.valueRow or qry_selectCustomFieldValueList.CurrentRow is 1
						or DateCompare(qry_selectCustomFieldValueList.customFieldValueDateCreated, qry_selectCustomFieldValueList.customFieldValueDateCreated[CurrentRow - 1]) is not 0>
					<cfset methodStruct.count += 1>
					<cfif methodStruct.count is not 1></tr><tr valign="top" class="TableText"<cfif (methodStruct.count mod 2) is 0> bgcolor="##f4f4ff"</cfif>></cfif>
					<!--- <tr valign="top" class="TableText"<cfif (methodStruct.count mod 2) is 0> bgcolor="##f4f4ff"</cfif>> --->
					<td>###IncrementValue(methodStruct.rowspan - methodStruct.count)#.<!--- #methodStruct.count#. ---></i></td>
					<td>&nbsp;</td>
					<td>
						<cfset methodStruct.thisValue = ToString(qry_selectCustomFieldValueList.customFieldValueValue)>
						<cfswitch Expression="#qry_selectCustomFieldValueList.customFieldValueType#">
						<cfcase value="Bit"><cfif methodStruct.thisValue is 1>True<cfelse>False</cfif></cfcase>
						<cfcase value="Decimal">#Application.fn_LimitPaddedDecimalZerosQuantity(methodStruct.thisValue)#</cfcase>
						<cfcase value="DateTime">#DateFormat(methodStruct.thisValue, "mmmm dd, yyyy")# at #TimeFormat(methodStruct.thisValue, "hh:mm tt")#<br>#methodStruct.thisValue#</cfcase>
						<cfdefaultcase><!--- Varchar,Int --->#HTMLEditFormat(methodStruct.thisValue)#</cfdefaultcase>
						</cfswitch>
					</td>
					<td>&nbsp;</td>
					<td><cfif qry_selectCustomFieldValueList.customFieldValueStatus is 1><font color="green">Current</font><cfelse><font color="red">Archived</font></cfif></td>
					<td>&nbsp;</td>
					<td nowrap>#DateFormat(qry_selectCustomFieldValueList.customFieldValueDateCreated, "mm-dd-yy")# at #TimeFormat(qry_selectCustomFieldValueList.customFieldValueDateCreated, "hh:mm tt")#</td>
					<td>&nbsp;</td>
					<cfset methodStruct.userRow = ListFind(ValueList(qry_selectUserList.userID), qry_selectCustomFieldValueList.userID)>
					<td>
						<cfif methodStruct.userRow is 0>
							&nbsp;
						<cfelseif qry_selectCustomFieldValueList.customFieldID is methodStruct.previousCustomFieldID and qry_selectCustomFieldValueList.userID is methodStruct.previousUserID>
							&nbsp; &quot;
						<cfelse>
							#qry_selectUserList.lastName[methodStruct.userRow]#, #qry_selectUserList.firstName[methodStruct.userRow]#<br>
							<cfif qry_selectUserList.companyID is not Session.companyID>#qry_selectUserList.companyName[methodStruct.userRow]#</cfif>
						</cfif>
					</td>
					<cfset methodStruct.previousUserID = qry_selectCustomFieldValueList.userID>
					<cfset methodStruct.previousCustomFieldID = qry_selectCustomFieldValueList.customFieldID>
				</cfif>
			</cfloop>
		</cfif>
		</tr>
	</cfif>
</cfloop>
</table>
</p>
</cfoutput>
