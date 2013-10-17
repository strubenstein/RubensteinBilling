<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_template#">
<cfcase value="invalidTemplate">You did not specify a valid template.</cfcase>
<cfcase value="noTemplate">You did not specify a valid template.</cfcase>
<cfcase value="invalidAction">You did not specify a valid template function.</cfcase>
<cfcase value="customizeTemplate">You did not specify a valid template to customize.</cfcase>
<cfcase value="viewTemplateSample">This template does not currently have a sample for you to view.</cfcase>
<cfcase value="updateTemplateDefault">This template is already the default.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>