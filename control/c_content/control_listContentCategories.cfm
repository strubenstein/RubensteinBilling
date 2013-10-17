<cfinvoke Component="#Application.billingMapping#data.ContentCategory" Method="selectContentCategoryList" ReturnVariable="qry_selectContentCategoryList">
	<cfif Not Application.fn_IsUserAuthorized("updateContentCategory")>
		<cfinvokeargument Name="contentCategoryStatus" Value="1">
	</cfif>
</cfinvoke>

<cfinclude template="../../view/v_content/lang_listContentCategories.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("moveContentCategoryDown,moveContentCategoryUp,updateContentCategory,deleteContentCategory,listContent,viewContentCompany,insertContent,insertContentCompany")>

<cfset Variables.contentCategoryColumnList = Variables.lang_listContentCategories_title.contentCategoryOrder
		& "^" & Variables.lang_listContentCategories_title.contentCategoryName
		& "^" & Variables.lang_listContentCategories_title.contentCategoryStatus
		& "^" & Variables.lang_listContentCategories_title.contentCategoryDateCreated
		& "^" & Variables.lang_listContentCategories_title.contentCategoryDescription>

<cfif ListFind(Variables.permissionActionList, "moveContentCategoryDown") and ListFind(Variables.permissionActionList, "moveContentCategoryUp")>
	<cfset Variables.contentCategoryColumnList = Variables.contentCategoryColumnList & "^" & Variables.lang_listContentCategories_title.moveContentCategory>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateContentCategory") or ListFind(Variables.permissionActionList, "deleteContentCategory")>
	<cfset Variables.contentCategoryColumnList = Variables.contentCategoryColumnList & "^" & Variables.lang_listContentCategories_title.updateContentCategory>
</cfif>

<cfset Variables.contentCategoryColumnList = Variables.contentCategoryColumnList & "^" & Variables.lang_listContentCategories_title.contentCategoryCount>

<cfif ListFind(Variables.permissionActionList, "listContent") or ListFind(Variables.permissionActionList, "viewContentCompany")>
	<cfset Variables.contentCategoryColumnList = Variables.contentCategoryColumnList & "^" & Variables.lang_listContentCategories_title.listContent>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertContent") or ListFind(Variables.permissionActionList, "insertContentCompany")>
	<cfset Variables.contentCategoryColumnList = Variables.contentCategoryColumnList & "^" & Variables.lang_listContentCategories_title.insertContent>
</cfif>

<cfset Variables.contentCategoryColumnCount = DecrementValue(2 * ListLen(Variables.contentCategoryColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_content/dsp_selectContentCategoryList.cfm">

