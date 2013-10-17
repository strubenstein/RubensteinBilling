<cfinvoke Component="#Application.billingMapping#data.ContentCompany" Method="selectContentCompanyOrderList" ReturnVariable="qry_selectContentCompanyOrderList">
	<cfinvokeargument Name="contentID" Value="#URL.contentID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="languageID" Value="#URL.languageID#">
</cfinvoke>

<cfif qry_selectContentCompanyOrderList.RecordCount is 0>
	<cfset URL.error_content = "noContent">
	<cfinclude template="../../view/v_content/error_content.cfm">
<cfelse>
	<cfinclude template="../../view/v_content/lang_viewContentCompanyOrder.cfm">

	<cfset Variables.contentColumnList = Variables.lang_viewContentCompanyOrder_title.contentCompanyOrder
			& "^" & Variables.lang_viewContentCompanyOrder_title.contentCompanyAuthor
			& "^" & Variables.lang_viewContentCompanyOrder_title.contentCompanyDateCreated
			& "^" & Variables.lang_viewContentCompanyOrder_title.contentCompanyHtml
			& "^" & Variables.lang_viewContentCompanyOrder_title.contentCompanyValue>
	<cfset Variables.contentColumnCount = DecrementValue(2 * ListLen(Variables.contentColumnList, "^"))>

	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
	<cfinclude template="../../view/v_content/dsp_selectContentCompanyOrderList.cfm">
</cfif>
