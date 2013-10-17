<cfif Not IsDefined("Variables.wslang_invoice")>
	<cfinclude template="wslang_invoice.cfm">
</cfif>

<cfset useSubscriberInfo = False>
<cfif (Arguments.subscriberID is not 0 or Arguments.subscriberID_custom is not "") and returnValue is 0>
	<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.subscriberID lte 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_invoice.invalidSubscriber>
	<cfelse>
		<!--- <cfset qry_selectSubscriberList = QueryNew("subscriberID")> --->
		<cfset temp = QueryAddRow(qry_selectSubscriberList, 1)>
		<cfset temp = QuerySetCell(qry_selectSubscriberList, "subscriberID", ToString(Arguments.subscriberID), 1)>

		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
		</cfinvoke>

		<cfset useSubscriberInfo = True>
		<cfset Arguments.companyID = qry_selectSubscriber.companyID>
		<cfset Arguments.userID = qry_selectSubscriber.userID>

		<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID")> --->
		<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
		<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
	</cfif>
</cfif>

<cfif useSubscriberInfo is False>
	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.companyID lte 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_invoice.invalidCompany>
	</cfif>

	<cfif (Arguments.userID is not 0 or Arguments.userID_custom is not "") and returnValue is 0>
		<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, Arguments.companyID)>
		<cfif Arguments.userID lte 0>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_invoice.invalidUser>
		<cfelse>
			<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID")> --->
			<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
			<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(Arguments.userID), 1)>
		</cfif>
	</cfif>
</cfif>
