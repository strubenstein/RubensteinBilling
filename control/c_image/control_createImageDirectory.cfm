<cfinclude template="act_getCompanyImageDirectory.cfm">

<cfif Not IsDefined("Form.isFormSubmitted") or Not IsDefined("Form.submitCreateImageDirectory") or Not IsDefined("Form.directoryName")>
	<cflocation url="index.cfm?method=image.listImageDirectories&error_image=noDirectoryForm" AddToken="No">
<cfelseif Len(Form.directoryName) gt 25 or Trim(Form.directoryName) is ""
		or REFind("[^A-Za-z0-9_]", Form.directoryName) or Left(Form.directoryName, 1) is "_">
	<cflocation url="index.cfm?method=image.listImageDirectories&error_image=invalidDirectoryName" AddToken="No">
<cfelse>
	<cfset Variables.companyImageSubDirectoryPath = Variables.companyImageDirectoryPath & Application.billingFilePathSlash & Form.directoryName>

	<!--- check whether directory already exists --->
	<cfif DirectoryExists(Variables.companyImageSubDirectoryPath)>
		<cflocation url="index.cfm?method=image.listImageDirectories&error_image=repeatDirectoryName" AddToken="No">
	<cfelse>
		<!--- create new directory --->
		<cfdirectory Action="Create" Mode="777" Directory="#Variables.companyImageSubDirectoryPath#">
		
		<!--- create image directory index file to prevent directory browsing --->
		<cffile Action="Write" File="#Variables.companyImageSubDirectoryPath##Application.billingFilePathSlash#index.cfm" Output="<cfset blockDirectoryBrowsing = True>">

		<cflocation url="index.cfm?method=image.listImageDirectories&confirm_image=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

