<cfoutput>
<p class="MainText"><i>Custom Fields:</i>
<table border="0" cellspacing="0" cellpadding="3" class="MainText">
<cfloop Query="qry_selectCustomFieldListForTarget">
	<cfset valueRow = ListFind(ValueList(qry_selectCustomFieldValueList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
	<tr valign="top">
		<td align="right">#qry_selectCustomFieldListForTarget.customFieldTitle#: &nbsp;</td>
		<td>
			<cfif valueRow is 0>
				&nbsp;
			<cfelse>
				<cfset thisCustomFieldID = qry_selectCustomFieldListForTarget.customFieldID>
				<cfloop Query="qry_selectCustomFieldValueList" StartRow="#valueRow#">
					<cfif qry_selectCustomFieldValueList.customFieldID is not thisCustomFieldID><cfbreak></cfif>
					<cfset thisValue = ToString(qry_selectCustomFieldValueList.customFieldValueValue)>
					<cfif thisValue is "">
						&nbsp;
					<cfelse>
						<cfif qry_selectCustomFieldValueList.CurrentRow is not 1 and qry_selectCustomFieldValueList.customFieldID is qry_selectCustomFieldValueList.customFieldID[CurrentRow - 1]><br></cfif>
						<cfswitch Expression="#qry_selectCustomFieldValueList.customFieldValueType#">
						<cfcase value="Bit"><cfif thisValue is 1>True<cfelse>False</cfif></cfcase>
						<cfcase value="Decimal">#Application.fn_LimitPaddedDecimalZerosQuantity(thisValue)#</cfcase>
						<cfcase value="DateTime">#DateFormat(thisValue, "mmmm dd, yyyy")# at #TimeFormat(thisValue, "hh:mm tt")#</cfcase>
						<cfdefaultcase><!--- Varchar,Int --->#thisValue#</cfdefaultcase>
						</cfswitch>
					</cfif>
				</cfloop>
			</cfif>
		</td>
	</tr>
</cfloop>
</table>
</p>
</cfoutput>
