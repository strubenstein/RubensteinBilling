<cfif Not IsDefined("URL.error_image") or URL.error_image is not "noImageDirectory">
	<cfinclude template="act_getCompanyImageDirectory.cfm">

	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("createImageDirectory,deleteImageDirectory")>
	<cfset Variables.imageDirectoryArray = ArrayNew(1)>
	<cfset Variables.counter = 1>

	<cfdirectory Action="list" Name="qry_selectImageDirectoryList" Directory="#Variables.companyImageDirectoryPath#" Sort="dirname ASC">

	<cfloop Query="qry_selectImageDirectoryList">
		<cfif qry_selectImageDirectoryList.type is "Dir">
			<cfset Variables.imageDirectoryArray[Variables.counter] = StructNew()>
			<cfset Variables.imageDirectoryArray[Variables.counter].directoryName = qry_selectImageDirectoryList.name>
			<cfset Variables.imageDirectoryArray[Variables.counter].directoryDateCreated = qry_selectImageDirectoryList.dateLastModified>
			<cfset Variables.companyImageSubDirectoryPath = Variables.companyImageDirectoryPath & Application.billingFilePathSlash & qry_selectImageDirectoryList.name>
			<cfif Not DirectoryExists(Variables.companyImageSubDirectoryPath)>
				<cfset Variables.imageDirectoryArray[Variables.counter].directoryFileCount = 0>
			<cfelse>
				<!--- subtract 1 from count for default "index.cfm" file --->
				<cfdirectory Action="list" Name="qry_selectImageSubDirectoryList" Directory="#Variables.companyImageSubDirectoryPath#">
				<cfset Variables.imageDirectoryArray[Variables.counter].directoryFileCount = qry_selectImageSubDirectoryList.RecordCount - 1>
			</cfif>
			<cfset Variables.counter = Variables.counter + 1>
		</cfif>
	</cfloop>

	<!--- display image directories --->
	<cfinclude template="../../view/v_image/dsp_selectImageDirectoryList.cfm">

	<!--- display new directory form (if permission) --->
	<cfif ListFind(Variables.permissionActionList, "createImageDirectory")>
		<cfinclude template="../../view/v_image/form_createImageDirectory.cfm">
	</cfif>
</cfif>

