<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_export#">
<cfcase value="insertExportTable">Export table successfully added!</cfcase>
<cfcase value="updateExportTable">Export table successfully updated!</cfcase>
<cfcase value="moveExportTableUp,moveExportTableDown">Export table order successfully updated!</cfcase>
<cfcase value="insertExportTableField">Export field successfully added to table!</cfcase>
<cfcase value="updateExportTableField">Export field in table successfully updated!</cfcase>
<cfcase value="moveExportTableFieldUp,moveExportTableFieldDown">Export field order in table successfully updated!</cfcase>
<cfcase value="insertExportQuery">Export query successfully added!</cfcase>
<cfcase value="updateExportQuery">Export query successfully updated!</cfcase>
<cfcase value="moveExportQueryUp,moveExportQueryDown">Export query order successfully updated!</cfcase>
<cfcase value="insertExportQueryField">Export field successfully added to query!</cfcase>
<cfcase value="deleteExportQueryField">Export field in query removed.</cfcase>
<cfcase value="moveExportQueryFieldUp,moveExportQueryFieldDown">Export field order in query successfully updated!</cfcase>
<cfcase value="updateExportTableFieldCompany">Export table field options successfully updated!</cfcase>
<cfcase value="updateExportQueryFieldCompany">Export query field options successfully updated!</cfcase>
<cfcase value="moveExportQueryFieldCompanyUp,moveExportQueryFieldCompanyDown">Export query field order successfully updated!</cfcase>
<cfcase value="updateExportQueryField">Query &quot;select as&quot; field names successfully updated.</cfcase>
<cfcase value="updateExportQueryField_bad">Query &quot;select as&quot; field names successfully updated.<div class="ErrorMessage">Not all fields name were valid. The invalid field names were not updated.</div></cfcase>
<!--- insertExportTableFieldCompany,insertExportQueryFieldCompany --->
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>