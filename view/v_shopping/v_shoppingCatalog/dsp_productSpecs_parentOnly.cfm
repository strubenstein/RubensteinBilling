<cfoutput>
<table border="1" cellspacing="0" cellpadding="3" class="TableText">
<cfloop Query="qry_selectProductSpecList">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_selectProductSpecList.productSpecName#</td>
	<td>#qry_selectProductSpecList.productSpecValue#</td>
	</tr>
</cfloop>
</table>
</cfoutput>
<!--- 
<cfloop Index="rowCount" From="1" To="#ArrayLen(Variables.productSpecTable)#">
	<tr valign="top"<cfif (rowCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<cfloop Index="colCount" From="1" To="#ArrayLen(Variables.productSpecTable[rowCount])#">
		<cfif rowCount is 1 or colCount is not 1><td align="center"><cfelse><td></cfif>&nbsp;#Variables.productSpecTable[rowCount][colCount]#&nbsp;</td>
	</cfloop>
	</tr>
</cfloop>
--->

