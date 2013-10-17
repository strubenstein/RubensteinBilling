<cfoutput>
<table border="0" cellspacing="0" cellpadding="3">
<!--- contentCode, contentType --->
<cfloop Query="qry_selectContentCompanyList">
	<cfset Variables.ccText = Replace(Replace(qry_selectContentCompanyList.contentCompanyText, "<<", "&lt;&lt;", "ALL"), ">>", "&gt;&gt;", "ALL")>
	<tr valign="top" class="MainText"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectContentCompanyList.contentName#: </td>
		<td>
			<cfif qry_selectContentCompanyList.contentCompanyHtml is 1>
				#Variables.ccText#
			<cfelse>
				#Replace(HTMLEditFormat(Variables.ccText), Chr(10), "<br>", "ALL")#
			</cfif>
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>