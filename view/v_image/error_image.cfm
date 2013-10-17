<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_image#">
<cfcase value="noImage">You did not specify an image.</cfcase>
<cfcase value="invalidImage">You did not specify a valid image.</cfcase>
<cfcase value="hideImage">The image is already hidden.</cfcase>
<cfcase value="unhideImage">The image is already live.</cfcase>
<cfcase value="imageNotThumbnail">The image you selected is not actually a thumbnail image.</cfcase>
<cfcase value="invalidAction">You did not select a valid image function.</cfcase>
<cfcase value="invalidControl">This image function cannot be accessed directly via the current module.</cfcase>
<cfcase value="noImageDirectory">There is no custom image directory for your company.<br>Please contact Technical Support.</cfcase>
<cfcase value="noDirectoryForm">You did not submit a valid form to create a new image directory.</cfcase>
<cfcase value="invalidDirectoryName">You did not enter a valid directory name for the new image directory.</cfcase>
<cfcase value="repeatDirectoryName">A directory with that name already exists.</cfcase>
<cfcase value="noDirectoryDelete">You did not specify a directory to delete.</cfcase>
<cfcase value="directoryNotExist">The directory you requested to delete does not exist.</cfcase>
<cfcase value="directoryNotEmpty">You cannot delete a directory unless it has no images in it.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>