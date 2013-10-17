<cfinclude template="wslang_affiliate.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("viewAffiliate", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = QueryNew("error")>
	<cfset returnError = Variables.wslang_affiliate.viewAffiliate>
<cfelse>
	<cfset Arguments.affiliateID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.affiliateID, Arguments.affiliateID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.affiliateID) is 1 and Arguments.affiliateID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_affiliate.invalidAffiliate>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
			<cfinvokeargument Name="affiliateID" Value="#Arguments.affiliateID#">
		</cfinvoke>

		<cfset returnValue = qry_selectAffiliate>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">
