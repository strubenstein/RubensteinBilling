<cfinvoke Component="#Application.billingMapping#data.ContentCompany" Method="selectContentCompanyList" ReturnVariable="qry_selectContentCompanyList">
	<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="languageID" Value="#URL.languageID#">
	<cfinvokeargument Name="contentCompanyStatus" Value="1">
</cfinvoke>

<cfif qry_selectContentCompanyList.RecordCount is 0>
	<cfset URL.error_content = "noContentListings">
	<cfinclude template="../../view/v_content/error_content.cfm">
<cfelse>
	<cfinclude template="../../view/v_content/dsp_selectContentCompanyList.cfm">
</cfif>
