<cfinvoke Component="#Application.billingMapping#data.Content" Method="selectContentList" ReturnVariable="qry_selectContentList">
	<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
</cfinvoke>

<cfset Variables.displayContentLastUpdated = False>
<cfif qry_selectContentList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.ContentCompany" Method="selectContentCompanyLastUpdated" ReturnVariable="qry_selectContentCompanyLastUpdated">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="languageID" Value="#URL.languageID#">
		<cfinvokeargument Name="contentID" Value="#ValueList(qry_selectContentList.contentID)#">
	</cfinvoke>

	<cfif qry_selectContentCompanyLastUpdated.RecordCount is not 0>
		<cfset Variables.displayContentLastUpdated = True>
	</cfif>
</cfif>

<cfinclude template="../../view/v_content/lang_listContent.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewContentCompanyOrder,moveContentDown,moveContentUp,updateContent")>

<cfset Variables.contentColumnList = Variables.lang_listContent_title.contentOrder
		& "^" & Variables.lang_listContent_title.contentName
		& "^" & Variables.lang_listContent_title.contentType
		& "^" & Variables.lang_listContent_title.contentMaxlength
		& "^" & Variables.lang_listContent_title.contentRequired
		& "^" & Variables.lang_listContent_title.contentHtml
		& "^" & Variables.lang_listContent_title.contentStatus
		& "^" & Variables.lang_listContent_title.contentDateCreated
		& "^" & Variables.lang_listContent_title.contentLastUpdated
		& "^" & Variables.lang_listContent_title.contentAuthor
		& "^" & Variables.lang_listContent_title.contentVersion
		& "^" & Variables.lang_listContent_title.contentDescription>

<cfif ListFind(Variables.permissionActionList, "moveContentDown") and ListFind(Variables.permissionActionList, "moveContentUp")>
	<cfset Variables.contentColumnList = Variables.contentColumnList & "^" & Variables.lang_listContent_title.moveContent>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateContent")>
	<cfset Variables.contentColumnList = Variables.contentColumnList & "^" & Variables.lang_listContent_title.updateContent>
</cfif>

<cfset Variables.contentColumnCount = DecrementValue(2 * ListLen(Variables.contentColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_content/dsp_selectContentList.cfm">
