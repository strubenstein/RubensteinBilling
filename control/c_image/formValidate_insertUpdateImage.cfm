<cfif Not Find("Product", Variables.doAction) or Not IsDefined("errorMessage_fields")>
	<cfset errorMessage_fields = StructNew()>
</cfif>

<!---
<cfset uploadDirectoryPath = Application.billingFilePath & Application.billingFilePathSlash & "images" & Application.billingFilePathSlash & "img_product">
<cfset uploadDirectoryURL = "#Application.billingUrl#/images/img_product">
--->
<!--- determine image directory and URL if using subdirectory --->
<cfif Trim(Form.imageDirectory) is not "" and ListFind(Variables.imageSubDirectoryList, Form.imageDirectory)>
	<cfset uploadDirectoryPath = Variables.companyImageDirectoryPath & Application.billingFilePathSlash & Form.imageDirectory>
	<cfset uploadDirectoryURL = Variables.companyImageDirectoryURL & "/" & Form.imageDirectory>
<cfelse>
	<cfset uploadDirectoryPath = Variables.companyImageDirectoryPath>
	<cfset uploadDirectoryURL = Variables.companyImageDirectoryURL>
</cfif>

<cfset imageField = "imageURL">
<cfset imageFieldFileUpload = "imageFile">
<cfinclude template="../../include/function/act_imageUpload.cfm">

<cfif isImageUploaded is True or Not IsDefined("Form.imageUploaded") or Not ListFind("0,1", Form.imageUploaded)>
	<cfset Form.imageUploaded = Iif(isImageUploaded is True, 1, 0)>
</cfif>

<cfif Form.imageURL is "" and Not Find("Product", Variables.doAction)>
	<cfset errorMessage_fields.imageURL = Variables.lang_insertUpdateImage.imageURL>
</cfif>

<cfif Form.imageURL is not "">
	<!--- 
	<cfif Form.imageHeight is "">
		<cfset Form.imageHeight = 0>
	<cfelseif Not Application.fn_IsIntegerPositive(Form.imageHeight)>
		<cfset errorMessage_fields.imageHeight = Variables.lang_insertUpdateImage.imageHeight>
	</cfif>
	
	<cfif Form.imageWidth is "">
		<cfset Form.imageWidth = 0>
	<cfelseif Not Application.fn_IsIntegerPositive(Form.imageWidth)>
		<cfset errorMessage_fields.imageWidth = Variables.lang_insertUpdateImage.imageWidth>
	</cfif>
	--->

	<cfset Variables.isImageInfoRetrieved = False>
	<cfset Variables.imageSize = 0>

	<cfif IsNumeric(Form.imageHeight) and Not Application.fn_IsIntegerPositive(Form.imageHeight)>
		<cfset errorMessage_fields.imageHeight = Variables.lang_insertUpdateImage.imageHeight>
	<cfelseif isImageUploaded is False>
		<cfset Form.imageHeight = 0>
	<cfelse>
		<cfmodule Template="../../include/function/cf_imageInfo.cfm" File="#uploadDirectoryPath##SLASH##imageUploadedFilename#">
		<cfset Variables.isImageInfoRetrieved = True>
		<cfset Form.imageHeight = imageInfo.height>
		<cfset Variables.imageSize = imageInfo.size>
	</cfif>

	<cfif IsNumeric(Form.imageWidth) and Not Application.fn_IsIntegerPositive(Form.imageWidth)>
		<cfset errorMessage_fields.imageWidth = Variables.lang_insertUpdateImage.imageWidth>
	<cfelseif isImageUploaded is False>
		<cfset Form.imageWidth = 0>
	<cfelse>
		<cfif Variables.isImageInfoRetrieved is False>
			<cfmodule Template="../../include/function/cf_imageInfo.cfm" File="#uploadDirectoryPath##SLASH##imageUploadedFilename#">
			<cfset Variables.imageSize = imageInfo.size>
		</cfif>
		<cfset Form.imageWidth = imageInfo.width>
	</cfif>

	<cfif Not Application.fn_IsIntegerNonNegative(Form.imageBorder) or Form.imageBorder gt 10>
		<cfset errorMessage_fields.imageBorder = Variables.lang_insertUpdateImage.imageBorder>
	</cfif>

	<cfif Len(Form.imageAlt) gt maxlength_Image.imageAlt>
		<cfset errorMessage_fields.imageAlt = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateImage.imageAlt, "<<MAXLENGTH>>", maxlength_Image.imageAlt, "ALL"), "<<LEN>>", Len(Form.imageAlt), "ALL")>
	</cfif>
	<cfif Len(Form.imageOther) gt maxlength_Image.imageOther>
		<cfset errorMessage_fields.imageOther = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateImage.imageOther, "<<MAXLENGTH>>", maxlength_Image.imageOther, "ALL"), "<<LEN>>", Len(Form.imageOther), "ALL")>
	</cfif>
	<cfif Not ListFind("0,1", Form.imageDisplayCategory)>
		<cfset errorMessage_fields.imageDisplayCategory = Variables.lang_insertUpdateImage.imageDisplayCategory>
	</cfif>
</cfif>

<!--- determine thumbnail directory and URL if using subdirectory --->
<cfif Trim(Form.imageDirectory_thumbnail) is not "" and ListFind(Variables.imageSubDirectoryList, Form.imageDirectory_thumbnail)>
	<cfset uploadDirectoryPath = Variables.companyImageDirectoryPath & Application.billingFilePathSlash & Form.imageDirectory_thumbnail>
	<cfset uploadDirectoryURL = Variables.companyImageDirectoryURL & "/" & Form.imageDirectory_thumbnail>
<cfelse>
	<cfset uploadDirectoryPath = Variables.companyImageDirectoryPath>
	<cfset uploadDirectoryURL = Variables.companyImageDirectoryURL>
</cfif>

<cfset imageField = "imageURL_thumbnail">
<cfset imageFieldFileUpload = "imageFile_thumbnail">
<cfinclude template="../../include/function/act_imageUpload.cfm">

<cfif isImageUploaded is True or Not IsDefined("Form.imageUploaded_thumbnail") or Not ListFind("0,1", Form.imageUploaded_thumbnail)>
	<cfset Form.imageUploaded_thumbnail = Iif(isImageUploaded is True, 1, 0)>
</cfif>

<cfif Form.imageURL_thumbnail is "">
	<cfset Variables.isThumbnail = False>
<cfelse>
	<cfset Variables.isThumbnail = True>

	<!--- 
	<cfif Form.imageHeight_thumbnail is "">
		<cfset Form.imageHeight_thumbnail = 0>
	<cfelseif Not Application.fn_IsIntegerPositive(Form.imageHeight_thumbnail)>
		<cfset errorMessage_fields.imageHeight_thumbnail = Variables.lang_insertUpdateImage.imageHeight_thumbnail>
	</cfif>

	<cfif Form.imageWidth_thumbnail is "">
		<cfset Form.imageWidth_thumbnail = 0>
	<cfelseif Not Application.fn_IsIntegerPositive(Form.imageWidth_thumbnail)>
		<cfset errorMessage_fields.imageWidth_thumbnail = Variables.lang_insertUpdateImage.imageWidth_thumbnail>
	</cfif>
	--->

	<cfset Variables.isImageInfoRetrieved = False>
	<cfset Variables.imageSize_thumbnail = 0>

	<cfif IsNumeric(Form.imageHeight_thumbnail) and Not Application.fn_IsIntegerPositive(Form.imageHeight_thumbnail)>
		<cfset errorMessage_fields.imageHeight_thumbnail = Variables.lang_insertUpdateImage.imageHeight_thumbnail>
	<cfelseif isImageUploaded is False>
		<cfset Form.imageHeight_thumbnail = 0>
	<cfelse>
		<cfmodule Template="../../include/function/cf_imageInfo.cfm" File="#uploadDirectoryPath##SLASH##imageUploadedFilename#">
		<cfset Variables.isImageInfoRetrieved = True>
		<cfset Form.imageHeight_thumbnail = imageInfo.height>
		<cfset Variables.imageSize_thumbnail = imageInfo.size>
	</cfif>

	<cfif IsNumeric(Form.imageWidth_thumbnail) and Not Application.fn_IsIntegerPositive(Form.imageWidth_thumbnail)>
		<cfset errorMessage_fields.imageWidth_thumbnail = Variables.lang_insertUpdateImage.imageWidth_thumbnail>
	<cfelseif isImageUploaded is False>
		<cfset Form.imageWidth_thumbnail = 0>
	<cfelse>
		<cfif Variables.isImageInfoRetrieved is False>
			<cfmodule Template="../../include/function/cf_imageInfo.cfm" File="#uploadDirectoryPath##SLASH##imageUploadedFilename#">
			<cfset Variables.imageSize_thumbnail = imageInfo.size>
		</cfif>
		<cfset Form.imageWidth_thumbnail = imageInfo.width>
	</cfif>

	<cfif Not Application.fn_IsIntegerNonNegative(Form.imageBorder_thumbnail) or Form.imageBorder_thumbnail gt 10>
		<cfset errorMessage_fields.imageBorder_thumbnail = Variables.lang_insertUpdateImage.imageBorder_thumbnail>
	</cfif>

	<cfif Len(Form.imageAlt_thumbnail) gt maxlength_Image.imageAlt>
		<cfset errorMessage_fields.imageAlt_thumbnail = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateImage.imageAlt_thumbnail, "<<MAXLENGTH>>", maxlength_Image.imageAlt, "ALL"), "<<LEN>>", Len(Form.imageAlt_thumbnail), "ALL")>
	</cfif>
	<cfif Len(Form.imageOther_thumbnail) gt maxlength_Image.imageOther>
		<cfset errorMessage_fields.imageOther_thumbnail = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateImage.imageOther_thumbnail, "<<MAXLENGTH>>", maxlength_Image.imageOther, "ALL"), "<<LEN>>", Len(Form.imageOther_thumbnail), "ALL")>
	</cfif>
	<cfif Not ListFind("0,1", Form.imageDisplayCategory_thumbnail)>
		<cfset errorMessage_fields.imageDisplayCategory_thumbnail = Variables.lang_insertUpdateImage.imageDisplayCategory_thumbnail>
	<cfelseif Form.imageDisplayCategory is 1 and Form.imageDisplayCategory_thumbnail is 1>
		<cfset errorMessage_fields.imageDisplayCategory_thumbnail = Variables.lang_insertUpdateImage.imageDisplayCategory_both>
	</cfif>
</cfif>

<cfif Not Find("Product", Variables.doAction)>
	<cfif StructIsEmpty(errorMessage_fields)>
		<cfset isAllFormFieldsOk = True>
	<cfelse>
		<cfset isAllFormFieldsOk = False>
		<cfset errorMessage_title = Variables.lang_insertUpdateImage.errorTitle>
		<cfset errorMessage_header = Variables.lang_insertUpdateImage.errorHeader>
		<cfif Form.imageUploaded is True or Form.imageUploaded_thumbnail is True>
			<cfset errorMessage_footer = Variables.lang_insertUpdateImage.errorFooter_upload>
		<cfelse>
			<cfset errorMessage_footer = Variables.lang_insertUpdateImage.errorFooter_normal>
		</cfif>
	</cfif>
</cfif>