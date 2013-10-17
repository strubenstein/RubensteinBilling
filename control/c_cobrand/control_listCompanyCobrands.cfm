<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCompanyCobrandList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
</cfinvoke>

<cfinclude template="../../view/v_cobrand/lang_listCompanyCobrands.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCobrand,updateCobrand,insertCobrandHeader")>
<cfset Variables.cobrandColumnList = Variables.lang_listCompanyCobrands_title.cobrandID_custom
		& "^" & Variables.lang_listCompanyCobrands_title.cobrandName
		& "^" & Variables.lang_listCompanyCobrands_title.cobrandStatus
		& "^" & Variables.lang_listCompanyCobrands_title.cobrandCode
		& "^" & Variables.lang_listCompanyCobrands_title.cobrandDomain
		& "^" & Variables.lang_listCompanyCobrands_title.cobrandDirectory
		& "^" & Variables.lang_listCompanyCobrands_title.cobrandDateCreated
		& "^" & Variables.lang_listCompanyCobrands_title.cobrandDateUpdated>

<cfif ListFind(Variables.permissionActionList, "viewCobrand")>
	<cfset Variables.cobrandColumnList = Variables.cobrandColumnList & "^" & Variables.lang_listCompanyCobrands_title.viewCobrand>
</cfif>
<!--- 
<cfif ListFind(Variables.permissionActionList, "updateCobrand")>
	<cfset Variables.cobrandColumnList = Variables.cobrandColumnList & "^" & Variables.lang_listCompanyCobrands_title.updateCobrand>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertCobrandHeader")>
	<cfset Variables.cobrandColumnList = Variables.cobrandColumnList & "^" & Variables.lang_listCompanyCobrands_title.insertCobrandHeader>
</cfif>
--->

<cfset Variables.cobrandColumnCount = DecrementValue(2 * ListLen(Variables.cobrandColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_cobrand/dsp_selectCompanyCobrandList.cfm">

