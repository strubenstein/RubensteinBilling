<cfset targetUseCustomIDFieldList = Replace(Arguments.useCustomIDFieldList, "targetID", Arguments.primaryTargetKey, "ONE")>

<cfswitch expression="#Arguments.primaryTargetKey#">
<cfcase value="companyID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewCompany", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="userID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewUser", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="groupID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkGroupPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewGroup", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="invoiceID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewInvoice", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="productID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewProduct", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="subscriberID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewSubscriber", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="subscriptionID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewSubscription", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="affiliateID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewAffiliate", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="cobrandID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewCobrand", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfcase value="vendorID">
	<cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)>
	<cfset isUserAuthorized = Application.objWebServiceSession.isUserAuthorizedWS("viewVendor", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
</cfcase>
<cfdefaultcase>
	<cfset Arguments.targetID = 0>
	<cfset isUserAuthorized = False>
</cfdefaultcase>
</cfswitch>

