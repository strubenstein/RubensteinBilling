<cfinclude template="wslang_affiliate.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listAffiliates", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_affiliate.listAffiliates>
<cfelse>
	<cfset Arguments.returnUserFields = False>
	<cfif StructKeyExists(Arguments, "affiliateNameIsCompanyName") and ListFind("0,1", Arguments.affiliateNameIsCompanyName)>
		<cfset Arguments.returnCompanyFields = True>
	<cfelse>
		<cfset Arguments.returnCompanyFields = False>
	</cfif>

	<cfinclude template="wsact_selectAffiliateList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="returnCompanyFields" Value="#Arguments.returnCompanyFields#">
	</cfinvoke>

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">
