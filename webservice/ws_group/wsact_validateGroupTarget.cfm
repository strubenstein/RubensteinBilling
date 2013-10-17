<cfset Arguments.useCustomIDFieldList = Replace(Arguments.useCustomIDFieldList, "targetID", Arguments.primaryTargetKey, "ONE")>

<cfswitch expression="#Arguments.primaryTargetKey#">
<cfcase value="companyID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertGroupCompany", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="userID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertGroupUser", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="affiliateID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertGroupAffiliate", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="cobrandID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertGroupCobrand", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="vendorID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("insertGroupVendor", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfdefaultcase>
	<cfset Arguments.targetID = 0>
	<cfset isUserAuthorized = False>
</cfdefaultcase>
</cfswitch>

