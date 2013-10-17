<cfinclude template="act_getCompanyImageDirectory.cfm">

<cfif Not IsDefined("URL.directoryName")>
	<cflocation url="index.cfm?method=image.listImageDirectories&error_image=noDirectoryDelete" AddToken="No">
<cfelseif Trim(URL.directoryName) is "" or REFind("[^A-Za-z0-9_]", URL.directoryName)>
	<cflocation url="index.cfm?method=image.listImageDirectories&error_image=directoryNotExist" AddToken="No">
<cfelse>
	<cfset Variables.companyImageSubDirectoryPath = Variables.companyImageDirectoryPath & Application.billingFilePathSlash & URL.directoryName>

	<!--- check whether directory already exists --->
	<cfif Not DirectoryExists(Variables.companyImageSubDirectoryPath)>
		<cflocation url="index.cfm?method=image.listImageDirectories&error_image=directoryNotExist" AddToken="No">
	<cfelse>
		<cfdirectory Action="list" Name="qry_selectImageSubDirectoryList" Directory="#Variables.companyImageSubDirectoryPath#">
		<cfif qry_selectImageSubDirectoryList.RecordCount gt 1>
			<cflocation url="index.cfm?method=image.listImageDirectories&error_image=directoryNotEmpty" AddToken="No">
		<cfelseif qry_selectImageSubDirectoryList.RecordCount is 1 and qry_selectImageSubDirectoryList.name is not "index.cfm">
			<cflocation url="index.cfm?method=image.listImageDirectories&error_image=directoryNotEmpty" AddToken="No">
		<cfelse>
			<!--- delete image directory index file --->
			<cfif FileExists(Variables.companyImageSubDirectoryPath & Application.billingFilePathSlash & "index.cfm")>
				<cffile Action="Delete" File="#Variables.companyImageSubDirectoryPath##Application.billingFilePathSlash#index.cfm">
			</cfif>

			<!--- delete directory --->
			<cfdirectory Action="Delete" Directory="#Variables.companyImageSubDirectoryPath#">

			<cflocation url="index.cfm?method=image.listImageDirectories&confirm_image=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

