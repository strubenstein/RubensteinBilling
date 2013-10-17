<cfcomponent displayName="ImageUpload" hint="Manages process of uploading images or specifying URL">

<cffunction name="uploadImage" access="public" returnType="string" output="no" hint="Manages upload">
	<cfargument name="imageFieldFile" type="string" required="yes">
	<cfargument name="imageFieldUrl" type="string" required="yes">
	<cfargument name="imageDirectory" type="string" required="yes">
	<cfargument name="imageUrl" type="string" required="yes">

	<cfset var slash = Application.billingFilepathSlash>
	<cfset var isImageUploaded = False>
	<cfset var imageUploadedFilename = "">
	<cfset var imageReturn = "">

	<cfif Arguments.imageFieldFile is not "" and IsDefined("Form.#Arguments.imageFieldFile#") and Trim(Form[Arguments.imageFieldFile]) is not "">
		<cfif Arguments.imageDirectory is not "" and Not DirectoryExists(Arguments.imageDirectory)>
			<cfdirectory action="create" mode="777" directory="#Arguments.imageDirectory#">
		</cfif>

		<cftry>
			<cffile
				action="Upload"
				fileField="#Arguments.imageFieldFile#"
				Destination="#Arguments.imageDirectory##slash#"
				Accept="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png"
				NameConflict="MakeUnique">

			<cfif File.FileWasSaved is "Yes">
				<cfset isImageUploaded = True>
				<cfset imageReturn = "#Arguments.imageUrl#/#File.ServerFile#">
				<cfset imageUploadedFilename = File.ServerFile>
			<cfelse>
				<cfset imageReturn = "">
			</cfif>

			<cfcatch>
				<cfset imageReturn = "ERROR_FILE">
			</cfcatch>
		</cftry>
	</cfif>

	<cfif isImageUploaded is False and imageReturn is not "ERROR_FILE" and Arguments.imageFieldUrl is not "" and IsDefined("Form.#Arguments.imageFieldUrl#")>
		<cfif Trim(Form[Arguments.imageFieldUrl] is "") or Form[Arguments.imageFieldUrl] is "http://">
			<cfset imageReturn = "">
		<cfelseif ListFind(".gif,.bmp,.png,.jpg", Right(Form[Arguments.imageFieldUrl],4)) or Right(Form[Arguments.imageFieldUrl],5) is ".jpeg">
			<cfset imageReturn = Form[Arguments.imageFieldUrl]>
		<cfelse>
			<cfset imageReturn = "ERROR_URL">
		</cfif>
	</cfif>

	<cfreturn imageReturn>
</cffunction>

</cfcomponent>

