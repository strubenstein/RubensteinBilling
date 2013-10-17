<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectCompanyAffiliateList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
</cfinvoke>

<cfinclude template="../../view/v_affiliate/lang_listCompanyAffiliates.cfm">

<cfset Variables.affiliateColumnList = Variables.lang_listCompanyAffiliates_title.affiliateID_custom
		& "^" & Variables.lang_listCompanyAffiliates_title.affiliateName
		& "^" & Variables.lang_listCompanyAffiliates_title.affiliateStatus
		& "^" & Variables.lang_listCompanyAffiliates_title.affiliateCode
		& "^" & Variables.lang_listCompanyAffiliates_title.affiliateDateCreated
		& "^" & Variables.lang_listCompanyAffiliates_title.affiliateDateUpdated>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewAffiliate,updateAffiliate")>
<cfif ListFind(Variables.permissionActionList, "viewAffiliate")>
	<cfset Variables.permissionActionList = ListAppend(Variables.permissionActionList, "viewAffiliate")>
	<cfset Variables.affiliateColumnList = Variables.affiliateColumnList & "^" & Variables.lang_listCompanyAffiliates_title.viewAffiliate>
</cfif>

<cfset Variables.affiliateColumnCount = DecrementValue(2 * ListLen(Variables.affiliateColumnList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_affiliate/dsp_selectCompanyAffiliateList.cfm">
