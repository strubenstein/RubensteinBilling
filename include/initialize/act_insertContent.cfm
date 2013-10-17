
<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="insertContentCategory" ReturnVariable="newContentCategoryID">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="contentCategoryName" Value="Admin Custom Header & Footer">
	<cfinvokeargument Name="contentCategoryCode" Value="adminNav">
	<cfinvokeargument Name="contentCategoryDescription" Value="">
	<cfinvokeargument Name="contentCategoryStatus" Value="1">
	<cfinvokeargument Name="contentCategoryOrder" Value="1">
</cfinvoke>

<cfset Variables.contentCategoryID = newContentCategoryID>
 
<!--- Admin Header --->
<cfinvoke Component="#Application.billingMapping#data.Content" Method="insertContent" ReturnVariable="contentID">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="contentName" Value="Admin Header">
	<cfinvokeargument Name="contentCode" Value="adminHeader">
	<cfinvokeargument Name="contentDescription" Value="Header at top of admin screens above admin navigation bar.">
	<cfinvokeargument Name="contentStatus" Value="1">
	<cfinvokeargument Name="contentOrder" Value="1">
	<cfinvokeargument Name="contentCategoryID" Value="#Variables.contentCategoryID#">
	<cfinvokeargument Name="contentHtmlOk" Value="1">
	<cfinvokeargument Name="contentRequired" Value="0">
	<cfinvokeargument Name="contentType" Value="Header">
	<cfinvokeargument Name="contentMaxlength" Value="0">
	<cfinvokeargument Name="contentFilename" Value="header_admin.cfm">
</cfinvoke>

<!--- Admin Footer --->
<cfinvoke Component="#Application.billingMapping#data.Content" Method="insertContent" ReturnVariable="contentID">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="contentName" Value="Admin Footer">
	<cfinvokeargument Name="contentCode" Value="adminFooter">
	<cfinvokeargument Name="contentDescription" Value="Footer displayed at bottom of all admin pages, above nav footer.">
	<cfinvokeargument Name="contentStatus" Value="1">
	<cfinvokeargument Name="contentOrder" Value="2">
	<cfinvokeargument Name="contentCategoryID" Value="#Variables.contentCategoryID#">
	<cfinvokeargument Name="contentHtmlOk" Value="1">
	<cfinvokeargument Name="contentRequired" Value="0">
	<cfinvokeargument Name="contentType" Value="Footer">
	<cfinvokeargument Name="contentMaxlength" Value="0">
	<cfinvokeargument Name="contentFilename" Value="footer_admin.cfm">
</cfinvoke>

