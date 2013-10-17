<cfparam Name="URL.contentCategoryID" Default="0">
<cfparam Name="URL.contentID" Default="0">
<cfparam Name="URL.languageID" Default="">
<cfparam Name="URL.action" Default="listContentCategories">

<cfinclude template="security_content.cfm">
<cfinclude template="../../view/v_content/nav_content.cfm">
<cfif IsDefined("URL.confirm_content")>
	<cfinclude template="../../view/v_content/confirm_content.cfm">
</cfif>
<cfif IsDefined("URL.error_content")>
	<cfinclude template="../../view/v_content/error_content.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<!--- content category options --->
<cfcase value="listContentCategories">
	<cfinclude template="control_listContentCategories.cfm">
</cfcase>

<cfcase value="insertContentCategory">
	<cfinclude template="control_insertContentCategory.cfm">
</cfcase>

<cfcase value="updateContentCategory">
	<cfinclude template="control_updateContentCategory.cfm">
</cfcase>

<cfcase value="moveContentCategoryUp,moveContentCategoryDown">
	<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="switchContentCategoryOrder" ReturnVariable="isContentCategoryOrderSwitched">
		<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
		<cfinvokeargument Name="contentCategoryOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=content.listContentCategories&confirm_content=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="deleteContentCategory">
	<cfinclude template="control_deleteContentCategory.cfm">
</cfcase>

<!--- content listings options --->
<cfcase value="listContent">
	<cfinclude template="control_listContent.cfm">
</cfcase>

<cfcase value="insertContent">
	<cfinclude template="control_insertContent.cfm">
</cfcase>

<cfcase value="updateContent">
	<cfinclude template="control_updateContent.cfm">
</cfcase>

<cfcase value="moveContentUp,moveContentDown">
	<cfinvoke Component="#Application.billingMapping#data.Content" Method="switchContentOrder" ReturnVariable="isContentOrderSwitched">
		<cfinvokeargument Name="contentID" Value="#URL.contentID#">
		<cfinvokeargument Name="contentOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=content.listContent&contentCategoryID=#qry_selectContent.contentCategoryID#&confirm_content=#Variables.doAction#" AddToken="No">
</cfcase>

<!--- update content for company/language --->
<cfcase value="insertContentCompany">
	<cfinclude template="control_insertContentCompany.cfm">
</cfcase>

<!--- view current version of all category content for company/language --->
<cfcase value="viewContentCompany">
	<cfinclude template="control_viewContentCompany.cfm">
</cfcase>

<!--- view all versions of individual content listing in category for company/language --->
<cfcase value="viewContentCompanyOrder">
	<cfinclude template="control_viewContentCompanyOrder.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_content = "invalidAction">
	<cfinclude template="../../view/v_content/error_content.cfm">
</cfdefaultcase>
</cfswitch>

