<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_import#">
<cfcase value="imported">Records successfully imported!</cfcase><!--- never called --->
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>