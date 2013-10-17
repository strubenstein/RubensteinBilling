<!--- 
SECURITY

If contentCategoryID, contentID and languageID are not non-negative integers, bad
Actions that do NOT require a contentCategoryID: listContentCategories,insertContentCategory
Actions that require a contentCategoryID:
	updateContentCategory,moveContentCategoryUp,moveContentCategoryDown,deleteContentCategory,listContent
Actions that require a contentID:
	updateContent,moveContentUp,moveContentDown,insertContentCompany,viewContentCompany
Actions where contentCategoryID is optional: insertContent
Actions which do NOT require content setup permission: listContentCategories,listContent,insertContentCompany,viewContentCompany
--->

<cfif Not Application.fn_IsIntegerNonNegative(URL.contentCategoryID)>
	<cfset URL.error_content = "invalidContentCategory">
	<cfset Variables.doAction = "listContentCategories">
<cfelseif URL.contentCategoryID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="selectContentCategory" ReturnVariable="qry_selectContentCategory">
		<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
	</cfinvoke>

	<cfif qry_selectContentCategory.RecordCount is 0>
		<cfset URL.error_content = "invalidContentCategory">
		<cfset Variables.doAction = "listContentCategories">
	</cfif>
<cfelseif ListFind("updateContentCategory,moveContentCategoryUp,moveContentCategoryDown,deleteContentCategory,listContent,insertContentCompany,viewContentCompany,viewContentCompanyOrder", Variables.doAction)>
	<cfset URL.error_content = "invalidContentCategory">
	<cfset Variables.doAction = "listContentCategories">
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(URL.contentID)>
	<cfset URL.error_content = "invalidContent">
	<cfset Variables.doAction = "listContentCategories">
<cfelseif URL.contentID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Content" Method="selectContent" ReturnVariable="qry_selectContent">
		<cfinvokeargument Name="contentID" Value="#URL.contentID#">
	</cfinvoke>

	<cfif qry_selectContent.RecordCount is 0>
		<cfset URL.error_content = "invalidContent">
		<cfset Variables.doAction = "listContentCategories">
	</cfif>
<cfelseif ListFind("updateContent,moveContentUp,moveContentDown,viewContentCompanyOrder", Variables.doAction)>
	<cfset URL.error_content = "invalidContent">
	<cfset Variables.doAction = "listContentCategories">
</cfif>
