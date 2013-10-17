<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_category#">
<cfcase value="insertCategory">Category successfully created!</cfcase>
<cfcase value="updateCategory">Category successfully updated!</cfcase>
<cfcase value="moveCategoryUp,moveCategoryDown">Category manual order successfully updated!</cfcase>
<cfcase value="deleteCategory">Category successfully deleted!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>