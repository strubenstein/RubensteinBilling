<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_export#">
<cfcase value="noExportTable">You did not specify a valid export table.</cfcase>
<cfcase value="invalidExportTable">You did not specify a valid export table.</cfcase>
<cfcase value="noExportQuery">You did not specify a valid export query.</cfcase>
<cfcase value="invalidExportQuery">You did not specify a valid export query.</cfcase>
<cfcase value="invalidAction">You did not specify a valid export function.</cfcase>
<cfcase value="updateExportQueryField">You did not submit a valid form for updating the query &quot;select as&quot; field names.</cfcase>
<cfcase value="updateExportTableField">You did not specify a valid field for the export table.</cfcase>
<cfcase value="deleteExportQueryField,moveExportQueryFieldUp,moveExportQueryFieldDown">You did not specify a valid field for this query.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>