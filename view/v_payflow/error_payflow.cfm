<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_payflow#">
<cfcase value="invalidPayflow">You did not specify a valid subscription processing method.</cfcase>
<cfcase value="noPayflow">You must specify a valid subscription processing method.</cfcase>
<cfcase value="invalidAction">You did not specify a valid function for subscription processing method.</cfcase>
<cfcase value="insertPayflowCompany">To specify which subscription processing method(s) to use for a company,<br>you must start from that particular company via <a href="index.cfm?method=company.listCompanies" class="plainlink">Companies</a>.</cfcase>
<cfcase value="insertPayflowGroup">To specify which subscription processing method(s) to use for a group<br>you must start from that particular company via <a href="index.cfm?method=group.listGroups" class="plainlink">Groups</a>.</cfcase>
<cfcase value="insertPayflowTarget">To specify which subscription processing method(s) to use for a target<br>you must start from that particular target.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>