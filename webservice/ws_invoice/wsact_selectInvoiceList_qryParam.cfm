<cfloop Index="field" List="invoicePaid,invoiceShipped,invoiceClosed,invoiceCompleted,invoiceStatus,invoiceManual,invoiceSent">
	<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
</cfloop>

<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.affiliateID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.affiliateID, Arguments.affiliateID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.statusID = Application.objWebServiceSecurity.ws_checkStatusPermission(qry_selectWebServiceSession.companyID_author, Arguments.statusID, Arguments.statusID_custom, Arguments.useCustomIDFieldList, "invoiceID")>
<cfset Arguments.payflowID = Application.objWebServiceSecurity.ws_checkPayflowPermission(qry_selectWebServiceSession.companyID_author, Arguments.payflowID, Arguments.payflowID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.productID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.productID, Arguments.productID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.priceID = Application.objWebServiceSecurity.ws_checkPricePermission(qry_selectWebServiceSession.companyID_author, Arguments.priceID, Arguments.priceID_custom, Arguments.useCustomIDFieldList)>

<cfset qryParamWhere.companyID_author = qry_selectWebServiceSession.companyID_author>
<cfloop Index="field" List="invoiceClosed,invoiceCompleted,invoiceStatus,invoiceManual,invoiceSent,invoicePaid,invoiceShipped">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
		<cfset qryParamWhere[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="companyID,userID,subscriberID,affiliateID,cobrandID,payflowID,statusID,productID,priceID">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
		<cfset qryParamWhere[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="invoiceShippingMethod">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">
		<cfset qryParamWhere[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="invoiceTotal_min,invoiceTotal_max,invoiceTotalLineItem_min,invoiceTotalLineItem_max,invoiceTotalPaymentCredit_min,invoiceTotalPaymentCredit_max,invoiceTotalShipping_min,invoiceTotalShipping_max,invoiceTotalTax_min,invoiceTotalTax_max">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and IsNumeric(Arguments[field])>
		<cfset qryParamWhere[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="invoiceDatePaid_from,invoiceDatePaid_to,invoiceDateClosed_from,invoiceDateClosed_to,invoiceDateCompleted_from,invoiceDateCompleted_to,invoiceDateDue_from,invoiceDateDue_to,invoiceDateCreated_from,invoiceDateCreated_to">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and IsDate(Arguments[field])>
		<cfset qryParamWhere[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfif ListFind(Arguments.searchFieldList, "invoiceIsExported") and StructKeyExists(Arguments, "invoiceIsExported") and (Arguments.invoiceIsExported is "" or ListFind("0,1", Arguments.invoiceIsExported))>
	<cfset qryParamWhere.invoiceIsExported = Arguments.invoiceIsExported>
</cfif>

<!--- invoiceID_custom,invoiceHasMultipleItems,invoiceHasCustomPrice,invoiceHasCustomID,invoiceHasInstructions,invoiceHasPaymentCredit --->

