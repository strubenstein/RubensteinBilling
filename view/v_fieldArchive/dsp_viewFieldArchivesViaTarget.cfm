<cfoutput>
<div class="SubTitle"><b>Archived Field Values</b></div>
#fn_DisplayCurrentRecordNumbers("", "", "<br>", fieldStruct.columnCount, 0, 0, 0, fieldStruct.columnHeaderList, "", False)#
<cfloop Index="count" From="1" To="#ListLen(archiveStruct.fieldArchiveFieldList)#">
	<cfset fieldStruct.thisFieldName = ListGetAt(archiveStruct.fieldArchiveFieldList, count)>
	<cfset fieldStruct.thisFieldLabel = ListGetAt(archiveStruct.fieldArchiveFieldList_label, count)>
	<cfset fieldStruct.rowspan = Max(1, fieldArchiveList_rowCount[fieldStruct.thisFieldName])>

	<cfif count gt 1><tr><td colspan="#fieldStruct.columnCount#" height="3" align="center"><img src="#Application.billingUrlroot#/images/aline.gif" width="100%" height="1" alt="" border="0"></td></tr></cfif>
	<tr valign="top" class="TableText">
	<td class="MainText" rowspan="#fieldStruct.rowspan#">#fieldStruct.thisFieldLabel#: </td>
	<td rowspan="#fieldStruct.rowspan#">&nbsp;</td>

	<cfif fieldArchiveList_firstRow[fieldStruct.thisFieldName] is 0>
		<td class="TableText" colspan="#fieldStruct.columnCount - 2#"> (<i>No archived values for this field.</i>)</td>
	<cfelse>
		<cfset fieldStruct.counter = 0>
		<cfset fieldStruct.firstRow = fieldArchiveList_firstRow[fieldStruct.thisFieldName]>
		<cfloop Query="qry_selectFieldArchiveList" StartRow="#fieldStruct.firstRow#" EndRow="#DecrementValue(fieldStruct.firstRow + fieldStruct.rowspan)#">
			<cfset fieldStruct.counter = fieldStruct.counter + 1>
			<cfif fieldStruct.counter is not 1></tr><tr valign="top" class="TableText"<cfif (fieldStruct.counter mod 2) is 0> bgcolor="f4f4ff"</cfif>></cfif>
			<td align="center">###IncrementValue(fieldStruct.rowspan - fieldStruct.counter)#.</i></td><td>&nbsp;</td>
			<td>
				<cfif ListFind(archiveStruct.fieldArchiveFieldList_boolean, fieldStruct.thisFieldName)>
					<cfif qry_selectFieldArchiveList.fieldArchiveValue is 1>Yes/Active<cfelse>No/Inactive</cfif>
				<cfelseif ListFind(archiveStruct.fieldArchiveFieldList_special, fieldStruct.thisFieldName)><!--- affiliateID,cobrandID --->
					<cfswitch expression="#fieldStruct.thisFieldName#">
					<cfcase value="affiliateID">
						<cfif IsDefined("qry_selectAffiliate") and IsQuery(qry_selectAffiliate)>
							<cfset fieldStruct.queryRow = ListFind(ValueList(qry_selectAffiliate.affiliateID), qry_selectFieldArchiveList.fieldArchiveValue)>
							<cfif qry_selectFieldArchiveList.fieldArchiveValue is 0>(<i>No affiliate</i>)<cfelseif fieldStruct.queryRow is 0>#qry_selectFieldArchiveList.fieldArchiveValue#<cfelse>#qry_selectAffiliate.affiliateName[fieldStruct.queryRow]#</cfif>
						</cfif>
					</cfcase>
					<cfcase value="cobrandID">
						<cfif IsDefined("qry_selectCobrand") and IsQuery(qry_selectCobrand)>
							<cfset fieldStruct.queryRow = ListFind(ValueList(qry_selectCobrand.cobrandID), qry_selectFieldArchiveList.fieldArchiveValue)>
							<cfif qry_selectFieldArchiveList.fieldArchiveValue is 0>(<i>No cobrand</i>)<cfelseif fieldStruct.queryRow is 0>#qry_selectFieldArchiveList.fieldArchiveValue#<cfelse>#qry_selectCobrand.cobrandName[fieldStruct.queryRow]#</cfif>
						</cfif>
					</cfcase>
					<cfdefaultcase>#qry_selectFieldArchiveList.fieldArchiveValue#</cfdefaultcase>
					</cfswitch>
				<cfelse>
					#qry_selectFieldArchiveList.fieldArchiveValue#
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td>#DateFormat(qry_selectFieldArchiveList.fieldArchiveDate, "mm-dd-yyy")#<div class="SmallText">#TimeFormat(qry_selectFieldArchiveList.fieldArchiveDate, "hh:mm tt")#</div></td><td>&nbsp;</td>
			<td><cfif qry_selectFieldArchiveList.userID is 0>-<cfelse>#qry_selectFieldArchiveList.firstName# #qry_selectFieldArchiveList.lastName#</cfif></td>
		</cfloop>
	</cfif>
	</tr>
</cfloop>
</table>
</cfoutput>
