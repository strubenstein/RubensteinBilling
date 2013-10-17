<cfinclude template="wslang_vendor.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listVendors", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_vendor.listVendors>
<cfelse>
	<cfset Arguments.returnUserFields = False>
	<cfif StructKeyExists(Arguments, "vendorNameIsCompanyName") and ListFind("0,1", Arguments.vendorNameIsCompanyName)>
		<cfset Arguments.returnCompanyFields = True>
	<cfelse>
		<cfset Arguments.returnCompanyFields = False>
	</cfif>

	<cfinclude template="wsact_selectVendorList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

