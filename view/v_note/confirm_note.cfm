<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_note#">
<cfcase value="insertNote">Note successfully added!</cfcase>
<cfcase value="updateNote">Note successfully updated!</cfcase>
<cfcase value="deleteNote">Note deleted.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
