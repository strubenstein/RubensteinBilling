<cfset targetUseCustomIDFieldList = Replace(Arguments.useCustomIDFieldList, "targetID", Arguments.primaryTargetKey, "ONE")>

<cfswitch expression="#Arguments.primaryTargetKey#">
<cfcase value="companyID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertPayflowCompany", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="affiliateID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertPayflowTarget", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="cobrandID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertPayflowTarget", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="groupID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkGroupPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertPayflowGroup", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfdefaultcase>
	<cfset Arguments.targetID = 0>
	<cfset isUserAuthorized = False>
</cfdefaultcase>
</cfswitch>

