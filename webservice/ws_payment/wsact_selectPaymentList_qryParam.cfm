<cfloop Index="field" List="paymentAppliedToInvoice,paymentAppliedToMultipleInvoices,paymentManual,paymentStatus,paymentIsScheduled,paymentProcessed,paymentHasBeenRefunded,paymentIsRefund">
	<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
</cfloop>

<cfset Arguments.affiliateID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.affiliateID, Arguments.affiliateID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.subscriptionID = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriptionID, Arguments.subscriptionID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.paymentID = Application.objWebServiceSecurity.ws_checkPaymentPermission(qry_selectWebServiceSession.companyID_author, Arguments.paymentID, Arguments.paymentID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.invoiceID = Application.objWebServiceSecurity.ws_checkInvoicePermission(qry_selectWebServiceSession.companyID_author, Arguments.invoiceID, Arguments.invoiceID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.paymentCategoryID = Application.objWebServiceSecurity.ws_checkPaymentCategoryPermission(qry_selectWebServiceSession.companyID_author, Arguments.paymentCategoryID, Arguments.paymentCategoryID_custom, Arguments.useCustomIDFieldList)>
<cfset Arguments.productID = Application.objWebServiceSecurity.ws_checkProductPermission(qry_selectWebServiceSession.companyID_author, Arguments.productID, Arguments.productID_custom, Arguments.useCustomIDFieldList)>

<cfset qryParamStruct.companyID_author = qry_selectWebServiceSession.companyID_author>
<cfif ListFind(Arguments.searchFieldList, "paymentApproved") and StructKeyExists(Arguments, "paymentApproved") and (Arguments.paymentApproved is "" or ListFind("0,1", Arguments.paymentApproved))>
	<cfset qryParamStruct.paymentApproved = Arguments.paymentApproved>
</cfif>
<cfloop Index="field" List="paymentMessage,paymentMethod">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Trim(Arguments[field]) is not "">
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="paymentAmount_min,paymentAmount_max">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Arguments[field] is not 0 and IsNumeric(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="paymentCheckNumber_min,paymentCheckNumber_max">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Arguments[field] is not 0 and Application.fn_IsInteger(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="paymentID,paymentCategoryID,affiliateID,cobrandID,companyID,userID,subscriberID,subscriptionID,productID,creditCardID,bankID,merchantAccountID,invoiceID">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and Arguments[field] is not 0 and Application.fn_IsIntegerList(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="paymentIsRefund,paymentProcessed,paymentHasBeenRefunded,paymentIsScheduled,paymentStatus,paymentAppliedToInvoice,paymentAppliedToMultipleInvoices,paymentManual">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfloop Index="field" List="paymentDateReceived_from,paymentDateReceived_to,paymentDateCreated_from,paymentDateCreated_to,paymentDateUpdated_from,paymentDateUpdated_to,paymentDateScheduled_from,paymentDateScheduled_to">
	<cfif ListFind(Arguments.searchFieldList, field) and StructKeyExists(Arguments, field) and IsDate(Arguments[field])>
		<cfset qryParamStruct[field] = Arguments[field]>
	</cfif>
</cfloop>
<cfif ListFind(Arguments.searchFieldList, "paymentIsExported") and StructKeyExists(Arguments, "paymentIsExported") and (Arguments.paymentIsExported is "" or ListFind("0,1", Arguments.paymentIsExported))>
	<cfset qryParamStruct.paymentIsExported = Arguments.paymentIsExported>
</cfif>
