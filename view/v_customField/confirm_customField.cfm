<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_customField#">
<cfcase value="insertCustomField">Custom field successfully added!</cfcase>
<cfcase value="updateCustomField">Custom field successfully updated!</cfcase>
<cfcase value="deleteCustomField">Custom field deleted.</cfcase>
<cfcase value="moveCustomFieldTargetUp,moveCustomFieldTargetDown">Custom field successfully moved within target!</cfcase>
<cfcase value="insertCustomFieldValues">Custom field fields successfully updated.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
