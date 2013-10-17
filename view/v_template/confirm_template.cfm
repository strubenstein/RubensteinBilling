<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_template#">
<cfcase value="insertTemplate">Template successfully created!</cfcase>
<cfcase value="updateTemplate">Template successfully updated!</cfcase>
<cfcase value="copyTemplate">Template successfully copied!</cfcase>
<cfcase value="customizeTemplate">Template successfully customized!</cfcase>
<cfcase value="updateTemplateDefault">Template default successfully updated.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
