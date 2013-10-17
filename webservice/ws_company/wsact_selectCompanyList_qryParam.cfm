<cfloop Index="field" List="companyStatus,companyIsTaxExempt">
	<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
</cfloop>

<cfset Arguments.affiliateID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.affiliateID, Arguments.affiliateID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.groupID = Application.objWebServiceSecurity.ws_checkGroupPermission(qry_selectWebServiceSession.companyID_author, Arguments.groupID, Arguments.groupID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.statusID = Application.objWebServiceSecurity.ws_checkStatusPermission(qry_selectWebServiceSession.companyID_author, Arguments.statusID, Arguments.statusID_custom, Arguments.useCustomIDFieldList, "companyID")>
<cfset Arguments.payflowID = Application.objWebServiceSecurity.ws_checkPayflowPermission(qry_selectWebServiceSession.companyID_author, Arguments.payflowID, Arguments.payflowID_custom, Arguments.useCustomIDFieldList)>

<cfset qryParamStruct.companyID_author = qry_selectWebServiceSession.companyID_author>
<cfloop Index="field" List="companyStatus,companyIsTaxExempt,companyIsCustomer">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="groupID,affiliateID,cobrandID,payflowID,statusID,regionID">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Arguments[field] is not 0 and Application.fn_IsIntegerList(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="companyName,companyDBA,companyURL,companyID_custom,city,state,county,zipCode,country">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfif ListFind(Arguments.searchFieldList, "companyIsExported") and StructKeyExists(Arguments, "companyIsExported") and (Arguments.companyIsExported is "" or ListFind("0,1", Arguments.companyIsExported))>
	<cfset qryParamStruct.companyIsExported = Arguments.companyIsExported>
</cfif>

