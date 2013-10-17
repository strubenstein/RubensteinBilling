<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_customField#">
<cfcase value="invalidCustomField">You did not specify a valid custom field.</cfcase>
<cfcase value="noCustomField">You must specify a valid custom field.</cfcase>
<cfcase value="invalidAction">You did not specify a valid custom field action.</cfcase>
<cfcase value="invalidActionPermission">You do not have permission for this custom field function.</cfcase>
<cfcase value="moveCustomFieldTargetUp,moveCustomFieldTargetDown">You did not specify a valid custom field target to move.</cfcase>
<cfcase value="noCustomFieldsForTarget">There are no custom fields for this target type.</cfcase>
<cfcase value="invalidTargetAction">You did not specify a valid custom field request.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>