<cfinclude template="wslang_affiliate.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportAffiliates", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_affiliate.exportAffiliates>
<cfelse>
	<cfset Arguments.affiliateID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.affiliateID, Arguments.affiliateID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.affiliateID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_affiliate.invalidAffiliate>
	<cfelseif Arguments.affiliateIsExported is not "" and Not ListFind("0,1", Arguments.affiliateIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_affiliate.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="updateAffiliateIsExported" ReturnVariable="isAffiliateExported">
			<cfinvokeargument Name="affiliateID" Value="#Arguments.affiliateID#">
			<cfinvokeargument Name="affiliateIsExported" Value="#Arguments.affiliateIsExported#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

