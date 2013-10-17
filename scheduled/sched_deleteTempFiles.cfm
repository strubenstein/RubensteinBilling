<!--- loop thru all temp directories and delete files more than 24 hours old --->
<cfdirectory Action="List" Directory="#Application.billingTempPath#" Name="qry_selectDirectoryList">

<cfloop Query="qry_selectDirectoryList">
	<cfif qry_selectDirectoryList.type is "File">
		<cfif Not ListFindNoCase("index.cfm,Application.cfm", qry_selectDirectoryList.name)
				and DateDiff("h", qry_selectDirectoryList.dateLastModified, Now()) gt 24
				and Not Find(".xml", qry_selectDirectoryList.name)>
			<cffile Action="Delete" File="#Application.billingTempPath##Application.billingFilePathSlash##qry_selectDirectoryList.name#">
		</cfif>
	<cfelse><!--- Dir --->
		<cfset Variables.thisSubPath = Application.billingTempPath & Application.billingFilePathSlash & qry_selectDirectoryList.name>
		<cfdirectory Action="List" Directory="#Variables.thisSubPath#" Name="qry_selectSubDirectoryList">
		<cfloop Query="qry_selectSubDirectoryList">
			<cfif qry_selectSubDirectoryList.type is "File"
					and Not ListFindNoCase("index.cfm,Application.cfm", qry_selectSubDirectoryList.name)
					and DateDiff("h", qry_selectSubDirectoryList.dateLastModified, Now()) gt 24>
				<cffile Action="Delete" File="#Variables.thisSubPath##Application.billingFilePathSlash##qry_selectSubDirectoryList.name#">
			</cfif>
		</cfloop>
	</cfif>
</cfloop>
