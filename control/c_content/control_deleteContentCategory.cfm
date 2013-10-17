<cfinvoke Component="#Application.billingMapping#data.Content" Method="selectContentList" ReturnVariable="qry_selectContentList">
	<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
</cfinvoke>

<cfif qry_selectContentList.RecordCount is not 0>
	<cflocation url="index.cfm?method=content.listContentCategories&error_content=#Variables.doAction#" AddToken="No">
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="deleteContentCategory" ReturnVariable="isContentCategoryDeleted">
		<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
	</cfinvoke>

	<cflocation url="index.cfm?method=content.listContentCategories&confirm_content=#Variables.doAction#" AddToken="No">
</cfif>
