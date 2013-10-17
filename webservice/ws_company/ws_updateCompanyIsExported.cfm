<cfinclude template="wslang_company.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("exportCompanies", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_company.exportCompanies>
<cfelse>
	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>

	<cfif Arguments.companyID lte 0>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_company.invalidCompany>
	<cfelseif Arguments.companyIsExported is not "" and Not ListFind("0,1", Arguments.companyIsExported)>
		<cfset returnValue = False>
		<cfset returnError = Variables.wslang_company.exportOption>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompanyIsExported" ReturnVariable="isCompanyExported">
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
			<cfinvokeargument Name="companyIsExported" Value="#Arguments.companyIsExported#">
		</cfinvoke>

		<cfset returnValue = True>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">


