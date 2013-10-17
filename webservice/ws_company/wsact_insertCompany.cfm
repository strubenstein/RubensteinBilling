<cfset Arguments.affiliateID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.affiliateID, Arguments.affiliateID_custom, Arguments.useCustomIDFieldList)>
<cfif Arguments.affiliateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliateList">
		<cfinvokeargument Name="affiliateID" Value="#Arguments.affiliateID#">
	</cfinvoke>
</cfif>

<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>
<cfif Arguments.cobrandID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrandList">
		<cfinvokeargument Name="cobrandID" Value="#Arguments.cobrandID#">
	</cfinvoke>
</cfif>

<cfset Variables.doAction = "insertCompany">
<cfset URL.companyID = 0>
<cfset Form.companyPrimary = 0>

<cfif Not IsDefined("fn_IsValidURL")>
	<cfinclude template="../../include/function/fn_IsValidURL.cfm">
</cfif>

<cfinclude template="../../view/v_company/lang_insertUpdateCompany.cfm">
<cfinvoke component="#Application.billingMapping#data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />
<cfinclude template="../../control/c_company/formParam_insertUpdateCompany.cfm">
<cfinclude template="../../control/c_company/formValidate_insertUpdateCompany.cfm">

<cfif isAllFormFieldsOk is False>
	<cfset returnValue = -1>
	<cfset returnError = "">
	<cfloop Collection="#errorMessage_fields#" Item="field">
		<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
	</cfloop>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="insertCompany" ReturnVariable="newCompanyID">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
		<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
		<cfinvokeargument Name="languageID" Value="">
		<cfinvokeargument Name="companyPrimary" Value="0">
		<cfinvokeargument Name="companyID_parent" Value="0">
		<cfinvokeargument Name="userID" Value="0">
		<cfinvokeargument Name="companyName" Value="#Arguments.companyName#">
		<cfinvokeargument Name="companyDBA" Value="#Arguments.companyDBA#">
		<cfinvokeargument Name="companyURL" Value="#Arguments.companyURL#">
		<cfinvokeargument Name="companyStatus" Value="#Arguments.companyStatus#">
		<cfinvokeargument Name="companyID_custom" Value="#Arguments.companyID_custom#">
		<cfinvokeargument Name="affiliateID" Value="#Arguments.affiliateID#">
		<cfinvokeargument Name="cobrandID" Value="#Arguments.cobrandID#">
		<cfinvokeargument Name="companyIsTaxExempt" Value="#Arguments.companyIsTaxExempt#">
		<cfinvokeargument Name="companyIsCustomer" Value="#Arguments.companyIsCustomer#">
	</cfinvoke>

	<cfset returnValue = newCompanyID>
</cfif>

