<cfinclude template="wslang_product.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("listProducts", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_product.listProducts>
<cfelse>
	<cfinclude template="wsact_selectProductList_qryParam.cfm">

	<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

	<cfset returnValue = qryTotalRecords>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

