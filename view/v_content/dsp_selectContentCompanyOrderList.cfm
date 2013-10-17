<cfoutput>
<p class="MainText">
<b>#qry_selectContent.contentName#</b>
<cfif qry_selectContent.contentCode is not ""> (<i>#qry_selectContent.contentCode#</i>)</cfif>
<cfif qry_selectContent.contentDescription is not "">
	<div class="TableText"><i>Description</i>: #HTMLEditFormat(qry_selectContent.contentDescription)#</div>
</cfif>
</p>


<p class="TableText">The content versions are listed in reverse order, which the latest (and current) version listed first.</p>

#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.contentColumnCount, 0, 0, 0, Variables.contentColumnList, "", False)#
<cfloop Query="qry_selectContentCompanyOrderList">
	<cfset Variables.ccText = Replace(Replace(qry_selectContentCompanyOrderList.contentCompanyText, "<<", "&lt;&lt;", "ALL"), ">>", "&gt;&gt;", "ALL")>
	<tr valign="top" class="MainText"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td align="right">#qry_selectContentCompanyOrderList.contentCompanyOrder#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContentCompanyOrderList.userID is 0>(default)<cfelse>#qry_selectContentCompanyOrderList.firstName# #qry_selectContentCompanyOrderList.lastName#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>
			#DateFormat(qry_selectContentCompanyOrderList.contentCompanyDateCreated, "mm-dd-yy")#
			<div class="SmallText">#TimeFormat(qry_selectContentCompanyOrderList.contentCompanyDateCreated, "hh:mm tt")#</div>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContentCompanyOrderList.contentCompanyHtml is 0>-<cfelse>Yes</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectContentCompanyOrderList.contentCompanyHtml is 1>
				#Variables.ccText#
			<cfelse>
				#Replace(HTMLEditFormat(Variables.ccText), Chr(10), "<br>", "ALL")#
			</cfif>
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>