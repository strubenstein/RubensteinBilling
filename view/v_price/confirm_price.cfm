<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_price#">
<cfcase value="insertPrice">Custom price successfully created!</cfcase>
<cfcase value="updatePrice">Custom price successfully updated!</cfcase>
<cfcase value="deletePrice">Custom price deleted.</cfcase>
<cfcase value="updatePriceStatus">Custom price updated to inactive.</cfcase>
<cfcase value="updatePriceTargetStatus0">Price target status updated to disabled.</cfcase>
<cfcase value="updatePriceTargetStatus1">Price target status successfully updated to active.</cfcase>
<cfcase value="insertPriceTargetCompany">Company(s) successfully added as price target.</cfcase>
<cfcase value="insertPriceTargetGroup">Group(s) successfully added as price target.</cfcase>
<cfcase value="insertPriceTargetUser">User(s) successfully added as price target.</cfcase>
<cfcase value="insertPriceTargetAffiliate">Affiliate(s) successfully added as price target.</cfcase>
<cfcase value="insertPriceTargetCobrand">Cobrand(s) successfully added as price target.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>