<cfoutput>
<p><table width="600"><tr><td class="MainText">
Product specifications are used to display specs/details specific to that product. They are also useful for displaying a table of specs about related or child products.
</td></tr></table></p>

<cfif qry_selectProductSpecList.RecordCount is 0>
	<p class="ErrorMessage">This product has no specs at this time.</p>
<cfelse>
	<table border="1" cellspacing="2" cellpadding="2">
	<tr class="TableHeader" valign="bottom">
		<th>Name</th>
		<th>Value</th>
	</tr>

	<cfloop Query="qry_selectProductSpecList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#qry_selectProductSpecList.productSpecName#: </td>
		<td>#qry_selectProductSpecList.productSpecValue#</td>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>

