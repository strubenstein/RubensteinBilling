<cfset targetUseCustomIDFieldList = Replace(Arguments.useCustomIDFieldList, "targetID", Arguments.primaryTargetKey, "ONE")>

<cfswitch expression="#Arguments.primaryTargetKey#">
<cfcase value="companyID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="userID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="groupID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkGroupPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="invoiceID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="productID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="subscriberID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="subscriptionID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="affiliateID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="cobrandID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="vendorID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="payflowID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkPayflowPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="paymentID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkPaymentPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfcase value="paymentCreditID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkPaymentCreditPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, targetUseCustomIDFieldList)></cfcase>
<cfdefaultcase><cfset targetID = 0></cfdefaultcase>
</cfswitch>

