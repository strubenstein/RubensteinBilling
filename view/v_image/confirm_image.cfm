<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_image#">
<cfcase value="insertImage">Image(s) successfully added!</cfcase>
<cfcase value="updateImage">Image(s) successfully updated!</cfcase>
<cfcase value="moveImageUp">Image successfully move up one position!</cfcase>
<cfcase value="moveImageDown">Image(s) successfully move down one position!</cfcase>
<cfcase value="hideImage">Image is now hidden.</cfcase>
<cfcase value="unhideImage">Image is now live again.</cfcase>
<cfcase value="separateImage">Thumbnail successfully separated from image!</cfcase>
<cfcase value="imageDisplayCategory">Image displayed on the category page successfully updated.</cfcase>
<cfcase value="createImageDirectory">New image directory successfully created!</cfcase>
<cfcase value="deleteImageDirectory">Image directory successfully deleted!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
