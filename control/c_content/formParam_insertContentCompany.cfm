<cfloop Query="qry_selectContentCompanyList">
	<cfparam Name="Form.contentCompanyText#qry_selectContentCompanyList.contentID#" Default="#qry_selectContentCompanyList.contentCompanyText#">
	<cfparam Name="Form.contentCompanyHtml#qry_selectContentCompanyList.contentID#" Default="#qry_selectContentCompanyList.contentCompanyHtml#">
	<cfif Form["contentCompanyHtml#qry_selectContentCompanyList.contentID#"] is "">
		<cfset Form["contentCompanyHtml#qry_selectContentCompanyList.contentID#"] = 0>
	</cfif>
</cfloop>
