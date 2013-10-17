<cfoutput>
<p class="MainText"><b>Description:</b><br>
<table border="0" cellspacing="0" cellpadding="0" width="750"><tr><td class="MainText">
<cfif qry_selectProduct.productLanguageDescriptionHtml is 0>
	#Replace(qry_selectProduct.productLanguageDescription, Chr(10), "<br>", "ALL")#
<cfelse>
	#qry_selectProduct.productLanguageDescription#
</cfif>
</td></tr></table>
</p>
</cfoutput>