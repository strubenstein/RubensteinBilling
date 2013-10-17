<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfif qry_selectCompany.companyDirectory is "">
	<cfset Variables.companyImageDirectoryPath = Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Application.billingCustomerImageDirectory>
	<cfset Variables.companyImageDirectoryURL = Application.billingUrl & "/" & Application.billingCustomerDirectoryInclude & Application.billingCustomerImageDirectory>
<cfelse>
	<cfset Variables.companyImageDirectoryPath = Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & qry_selectCompany.companyDirectory & Application.billingFilePathSlash & Application.billingCustomerImageDirectory>
	<cfset Variables.companyImageDirectoryURL = Application.billingUrl & "/" & Application.billingCustomerDirectoryInclude & qry_selectCompany.companyDirectory & "/" & Application.billingCustomerImageDirectory>
</cfif>

<cfif URL.control is "image">
	<cfset Variables.errorURL = "index.cfm?method=image.listImageDirectories&error_image=noImageDirectory">
<cfelse>
	<cfset Variables.errorURL = "index.cfm?method=#URL.control#.listImages#Variables.urlParameters#&error_image=noImageDirectory">
</cfif>

<cfif Not DirectoryExists(Variables.companyImageDirectoryPath)>
	<cflocation url="#Variables.errorURL#" AddToken="No">
</cfif>

