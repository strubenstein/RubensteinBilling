<cfoutput>
<p class="MainText">
For each image, either upload a file or enter the full URL to the image.<br>
You may use multiple images by submitting this page multiple times.<br>
Uploaded images are saved in your images directory or a sub-directory of it:<br>
#Variables.companyImageDirectoryURL#/
</p>

<form method="post" name="insertImage" action="#Variables.formAction#" enctype="multipart/form-data">
<input type="hidden" name="isFormSubmitted" value="True">
<cfif IsDefined("Form.imageUploaded")>
	<input type="hidden" name="imageUploaded" value="#HTMLEditFormat(Form.imageUploaded)#">
</cfif>
<cfif IsDefined("Form.imageUploaded_thumbnail")>
	<input type="hidden" name="imageUploaded_thumbnail" value="#HTMLEditFormat(Form.imageUploaded_thumbnail)#">
</cfif>

<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr>
	<td colspan="2"><b>Image:</b> </td>
</tr>
<tr>
	<td valign="top"><i>Upload File</i>: </td>
	<td>
		<input type="file" name="imageFile" size="45"><br>
		To Directory: 
		<select name="imageDirectory" size="1">
		<option value="">-- DEFAULT --</option>
		<cfloop Index="imageDir" List="#Variables.imageSubDirectoryList#">
			<option value="#HTMLEditFormat(imageDir)#"<cfif imageDir is Form.imageDirectory> selected</cfif>>#HTMLEditFormat(imageDir)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td><i><b>or</b> Enter URL</i>: </td>
	<td><input type="text" name="imageURL" value="#HTMLEditFormat(Form.imageURL)#" size="50" maxlength="#maxlength_Image.imageURL#"></td>
</tr>
<tr>
	<td>Image Size: </td>
	<td>
		Height: <input type="text" name="imageHeight" value="#HTMLEditFormat(Form.imageHeight)#" size="3">
		&nbsp; &nbsp; 
		Width: <input type="text" name="imageWidth" value="#HTMLEditFormat(Form.imageWidth)#" size="3"> 
		&nbsp; &nbsp; 
		Border: 
		<select name="imageBorder" size="1">
		<cfloop Index="count" From="0" To="5">
			<option value="#count#"<cfif Form.imageBorder is count> selected</cfif>>#count#</option>
		</cfloop>
		</select>
		<font class="TableText">(<i>in pixels; optional</i>)</font><br>
		<font class="TableText"><i>Height and width are automatically determined for uploaded images unless specified.</i></font><br>
	</td>
</tr>
<tr>
	<td valign="top">Alternate Text: </td>
	<td class="TableText">
		<input type="text" name="imageAlt" value="#HTMLEditFormat(Form.imageAlt)#" size="50" maxlength="#maxlength_Image.imageAlt#"><br>
		<i>Text displayed while image is downloading or if image cannot be found.<br>Also displayed when user puts mouse over image.</i>
	</td>
</tr>
<tr>
	<td valign="top">Other Settings: </td>
	<td class="TableText">
		<input type="text" name="imageOther" value="#HTMLEditFormat(Form.imageOther)#" size="50" maxlength="#maxlength_Image.imageOther#"><br>
		<i>Enables you to include other components within the image tag, such as hspace or align.</i>
	</td>
</tr>
<tr>
	<td>Category Page: </td>
	<td><label><input type="checkbox" name="imageDisplayCategory" value="1"<cfif Form.imageDisplayCategory is 1> checked</cfif>> Display image on category page and search results</label></td>
</tr>

<tr>
	<td colspan="2">
		<br><b>Thumbnail:</b><br>
		<font class="TableText"><i>Displayed in place of full image. Links to full image in a pop-up window.<br>
		Suggestion: Use Border=1 to indicate thumbnail is click-able.</i></font>
	</td>
</tr>
<tr>
	<td valign="top"><i>Upload File</i>: </td>
	<td>
		<input type="file" name="imageFile_thumbnail" size="45"><br>
		To Directory: 
		<select name="imageDirectory_thumbnail" size="1">
		<option value="">-- DEFAULT --</option>
		<cfloop Index="imageDir" List="#Variables.imageSubDirectoryList#">
			<option value="#HTMLEditFormat(imageDir)#"<cfif imageDir is Form.imageDirectory_thumbnail> selected</cfif>>#HTMLEditFormat(imageDir)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td><i><b>or</b> Enter URL</i>: </td>
	<td><input type="text" name="imageURL_thumbnail" value="#HTMLEditFormat(Form.imageURL_thumbnail)#" size="50" maxlength="#maxlength_Image.imageURL#"></td>
</tr>
<tr>
	<td>Image Size: </td>
	<td>
		Height: <input type="text" name="imageHeight_thumbnail" value="#HTMLEditFormat(Form.imageHeight_thumbnail)#" size="3">
		&nbsp; &nbsp; 
		Width: <input type="text" name="imageWidth_thumbnail" value="#HTMLEditFormat(Form.imageWidth_thumbnail)#" size="3">
		&nbsp; &nbsp; 
		Border: 
		<select name="imageBorder_thumbnail" size="1">
		<cfloop Index="count" From="0" To="5">
			<option value="#count#"<cfif Form.imageBorder_thumbnail is count> selected</cfif>>#count#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td>Alternate Text: </td>
	<td><input type="text" name="imageAlt_thumbnail" value="#HTMLEditFormat(Form.imageAlt_thumbnail)#" size="50" maxlength="#maxlength_Image.imageAlt#"></td>
</tr>
<tr>
	<td>Other Settings: </td>
	<td><input type="text" name="imageOther_thumbnail" value="#HTMLEditFormat(Form.imageOther_thumbnail)#" size="50" maxlength="#maxlength_Image.imageOther#"></td>
</tr>
<tr>
	<td>Category Page: </td>
	<td><label><input type="checkbox" name="imageDisplayCategory_thumbnail" value="1"<cfif Form.imageDisplayCategory_thumbnail is 1> checked</cfif>> Display image on category page and search results</label></td>
</tr>

<tr height="40" valign="bottom">
	<td></td>
	<td><input type="submit" name="submitImage" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>

<!--- 
imageStatus,
imageOrder,
imageHasThumbnail,
imageIsThumbnail,
imageID_parent,
imageUploaded,
imageDeleted,
--->

