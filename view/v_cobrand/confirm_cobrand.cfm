<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_cobrand#">
<cfcase value="insertCobrand">Cobrand successfully added!<br>You may add another cobrand listing below for this company.</cfcase>
<cfcase value="updateCobrand">Cobrand successfully updated!</cfcase>
<cfcase value="insertCobrandHeader">Cobrand header and footer successfully updated!</cfcase>
<cfcase value="updateCobrandIsExported">Export status of cobrand records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
