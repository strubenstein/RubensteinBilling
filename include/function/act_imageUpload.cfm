<cfset SLASH = Application.billingFilePathSlash>

<cfparam Name="Form.#imageField#" Default="">
<cfparam Name="Form.#imageFieldFileUpload#" Default="">
<!--- 
<cfparam Name="uploadDirectoryPath" Default="#Application.billingFilePath##SLASH#images#SLASH#img_product">
<cfparam Name="uploadDirectoryURL" Default="#Application.billingUrl#/images/img_product">
--->

<cfset isImageUploaded = False>
<cfset imageUploadedFilename = "">

<!--- <cfset uploadDirectoryPath = Application.billingFilePath & SLASH & "upload"> --->
<cfif Form[imageFieldFileUpload] is not "">
	<cfif Form.cobrandImageFile is not "" and Not DirectoryExists(uploadDirectoryPath)>
		<cfdirectory action="create" mode="777" directory="#uploadDirectoryPath#">
	</cfif>

	<cftry>
		<cffile
			Action="Upload"
			FileField="#imageFieldFileUpload#"
			Destination="#uploadDirectoryPath##SLASH#"
			Accept="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png"
			NameConflict="MakeUnique">

		<cfif File.FileWasSaved is "Yes">
			<cfset isImageUploaded = True>
			<cfset temp = SetVariable("Form.#imageField#", "#uploadDirectoryURL#/#File.ServerFile#")>
			<cfset imageUploadedFilename = File.ServerFile>
		<cfelse>
			<cfset temp = SetVariable("Form.#imageField#", "")>
		</cfif>

		<cfcatch>
			<cfset errorMessage_fields[imageField] = "You did not upload a valid image.">
		</cfcatch>
	</cftry>
</cfif>

<cfif isImageUploaded is False and Not StructKeyExists(errorMessage_fields, imageField)>
	<cfif Form[imageField] is "" or Form[imageField] is "http://">
		<cfset temp = SetVariable("Form.#imageField#", "")>
	<cfelseif Right(Form[imageField],4) is not ".gif"
			and Right(Form[imageField],4) is not ".bmp"
			and Right(Form[imageField],4) is not ".png"
			and Right(Form[imageField],4) is not ".jpg"
			and Right(Form[imageField],5) is not ".jpeg">
		<cfset temp = SetVariable("Form.#imageField#", "")>
		<cfset errorMessage_fields[imageField] = "You did not enter the URL to a valid image.">
	</cfif>
</cfif>

