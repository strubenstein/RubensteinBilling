<cfoutput>
<p class="MainText">
<table border="0" cellspacing="0" cellpadding="0" width="750"><tr><td class="MainText">
<cfif qry_selectProduct.productLanguageSummaryHtml is 0>
	#Replace(qry_selectProduct.productLanguageSummary, Chr(10), "<br>", "ALL")#
<cfelse>
	#qry_selectProduct.productLanguageSummary#
</cfif>
</td></tr></table>
</p>
</cfoutput>