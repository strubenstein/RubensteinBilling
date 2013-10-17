<cfinclude template="wslang_newsletterSubscriber.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = False>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertNewsletterSubscriber", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = False>
	<cfset returnError = Variables.wslang_newsletterSubscriber.insertNewsletterSubscriber>
<cfelse>
	<cfloop Index="field" List="newsletterSubscriberStatus,newsletterSubscriberHtml">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset Arguments.affiliateID = Application.objWebServiceSecurity.ws_checkAffiliatePermission(qry_selectWebServiceSession.companyID_author, Arguments.affiliateID, Arguments.affiliateID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.affiliateID is not 0>
		<!--- <cfset qry_selectAffiliateList = QueryNew("affiliateID")> --->
		<cfset temp = QueryAddRow(qry_selectAffiliateList, 1)>
		<cfset temp = QuerySetCell(qry_selectAffiliateList, "affiliateID", ToString(Arguments.affiliateID), 1)>
	</cfif>

	<cfset Arguments.cobrandID = Application.objWebServiceSecurity.ws_checkCobrandPermission(qry_selectWebServiceSession.companyID_author, Arguments.cobrandID, Arguments.cobrandID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.cobrandID is not 0>
		<!--- <cfset qry_selectCobrandList = QueryNew("cobrandID")> --->
		<cfset temp = QueryAddRow(qry_selectCobrandList, 1)>
		<cfset temp = QuerySetCell(qry_selectCobrandList, "cobrandID", ToString(Arguments.cobrandID), 1)>
	</cfif>

	<cfset Form = Arguments>
	<cfset Variables.doAction = "insertNewsletterSubscriber">

	<cfif Not IsDefined("fn_IsValidEmail")>
		<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.NewsletterSubscriber" method="maxlength_NewsletterSubscriber" returnVariable="maxlength_NewsletterSubscriber" />
	<cfinclude template="../../view/v_newsletter/lang_insertUpdateNewsletterSubscriber.cfm">
	<cfinclude template="../../control/c_newsletter/formValidate_insertUpdateNewsletterSubscriber.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfset returnValue = False>
		<cfset returnError = "">
		<cfloop Collection="#errorMessage_fields#" Item="field">
			<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
		</cfloop>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.NewsletterSubscriber" Method="insertNewsletterSubscriber" ReturnVariable="newsletterSubscriberType" ArgumentCollection="#Arguments#">
			<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
			<cfinvokeargument Name="userID" Value="0">
			<cfinvokeargument Name="cobrandID" Value="#Arguments.cobrandID#">
			<cfinvokeargument Name="affiliateID" Value="#Arguments.affiliateID#">
			<cfinvokeargument Name="newsletterSubscriberEmail" Value="#Arguments.newsletterSubscriberEmail#">
			<cfinvokeargument Name="newsletterSubscriberStatus" Value="#Arguments.newsletterSubscriberStatus#">
			<cfinvokeargument Name="newsletterSubscriberHtml" Value="#Arguments.newsletterSubscriberHtml#">
		</cfinvoke>
	</cfif>

	<cfset returnValue = True>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

