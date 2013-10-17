<cfloop Index="field" List="salesCommissionFinalized,salesCommissionPaid,salesCommissionStatus,salesCommissionManual">
	<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
</cfloop>

<cfloop Index="field" List="commissionID,affiliateID,cobrandID,invoiceID,companyID,userID,subscriberID,subscriptionID,priceID,productID">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and StructKeyExists(Arguments, "#field#_custom")>
		<cfset fieldPerm = Ucase(Left(field, 1)) & Mid(field, 2, Len(field) - 3)>
		<cfset Arguments[field] = Evaluate("Application.objWebServiceSecurity.ws_check#fieldPerm#Permission(qry_selectWebServiceSession.companyID_author, Arguments[field], Arguments[""#field#_custom""], Arguments.useCustomIDFieldList)")>
	</cfif>
</cfloop>

<cfif ListFind(Arguments.searchFieldList, "salesCommissionID") and StructKeyExists(Arguments, "salesCommissionID") and StructKeyExists(Arguments, "salesCommissionID")>
	<cfinvoke Component="#Application.billingMapping#data.SalesCommission" Method="checkSalesCommissionPermission" ReturnVariable="isSalesCommissionPermission">
		<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
		<cfinvokeargument Name="salesCommissionID" Value="#Arguments.salesCommissionID#">
	</cfinvoke>

	<cfif isSalesCommissionPermission is False>
		<cfset Arguments.salesCommissionID = 0>
	</cfif>
</cfif>

<cfif ListFind(Arguments.searchFieldList, "primaryTargetKey") and StructKeyExists(Arguments, "primaryTargetKey")>
	<cfset Arguments.primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
<cfelse>
	<cfset Arguments.primaryTargetID = 0>
</cfif>

<cfif ListFind(Arguments.searchFieldList, "targetID") and StructKeyExists(Arguments, "targetID")>
	<cfswitch expression="#Arguments.primaryTargetKey#">
	<cfcase value="affiliateID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)></cfcase>
	<cfcase value="cobrandID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)></cfcase>
	<cfcase value="userID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)></cfcase>
	<cfcase value="vendorID"><cfset Arguments.targetID = Application.objWebServiceSecurity.ws_checkVendorPermission(qry_selectWebServiceSession.companyID_author, Arguments.targetID, Arguments.targetID_custom, Arguments.useCustomIDFieldList)></cfcase>
	<cfdefaultcase><cfset Arguments.targetID = 0></cfdefaultcase>
	</cfswitch>
</cfif>

<cfif ListFind(Arguments.searchFieldList, "categoryID") and StructKeyExists(Arguments, "categoryID") and StructKeyExists(Arguments, "categoryCode")>
	<cfset Arguments.categoryID = Application.objWebServiceSecurity.ws_checkCategoryPermission(qry_selectWebServiceSession.companyID_author, Arguments.categoryID, Arguments.categoryCode, Arguments.useCustomIDFieldList)>
</cfif>

<cfset qryParamStruct.companyID_author = qry_selectWebServiceSession.companyID_author>
<cfloop Index="field" List="primaryTargetID,salesCommissionID,commissionID,targetID,invoiceID,companyID,userID,subscriberID,subscriptionID,cobrandID,affiliateID,priceID,productID,categoryID">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Arguments[field] is not 0 and Application.fn_IsIntegerList(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="salesCommissionAmount_min,salesCommissionAmount_max,salesCommissionBasisTotal_min,salesCommissionBasisTotal_max">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and IsNumeric(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="salesCommissionFinalized,salesCommissionStatus,salesCommissionManual">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfif ListFind(Arguments.searchFieldList, "salesCommissionPaid") and StructKeyExists(Arguments, "salesCommissionPaid") and (Arguments.salesCommissionPaid is "" or ListFind("0,1", Arguments.salesCommissionPaid))>
	<cfset qryParamStruct.salesCommissionPaid = Arguments.salesCommissionPaid>
</cfif>
<cfloop Index="field" List="salesCommissionDateFinalized_from,salesCommissionDateFinalized_to,salesCommissionDatePaid_from,salesCommissionDatePaid_to,salesCommissionDateBegin_from,salesCommissionDateBegin_to,salesCommissionDateEnd_from,salesCommissionDateEnd_to">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and IsDate(Arguments[field])>
		<cfset qryParamStruct[field] = CreateODBCDateTime(Arguments[field])>
	</cfif>
</cfloop>
<cfif ListFind(Arguments.searchFieldList, "salesCommissionIsExported") and StructKeyExists(Arguments, "salesCommissionIsExported") and (Arguments.salesCommissionIsExported is "" or ListFind("0,1", Arguments.salesCommissionIsExported))>
	<cfset qryParamStruct.salesCommissionIsExported = Arguments.salesCommissionIsExported>
</cfif>
