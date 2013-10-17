<cfparam Name="URL.categoryID" Default="0">
<cfinclude Template="control/c_shopping/c_shoppingCatalog/control_getCategory.cfm">

<cfif URL.error_shopping is "">
	<cfif Not FileExists(Application.billingTemplateDirectoryPath & Application.billingFilepathSlash & qry_selectCategory.templateFilename)>
		<cfinclude template="include/template/defaultCategory.cfm">
	<cfelse>
		<cfinclude template="include/template/#qry_selectCategory.templateFilename#">
	</cfif>
</cfif>
