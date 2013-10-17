<cfset theCompanyID = 0>
<cfset theSubscriberID = 0>

<cfif Not IsDefined("Variables.wslang_payment")>
	<cfinclude template="wslang_payment.cfm">
</cfif>

<!--- validate companyID of customer if necessary --->
<cfif Arguments.companyID is not 0 or ListFind(Arguments.useCustomIDFieldList, "companyID") or ListFind(Arguments.useCustomIDFieldList, "companyID_custom")>
	<cfset Arguments.companyID = Application.objWebServiceSecurity.ws_checkCompanyPermission(qry_selectWebServiceSession.companyID_author, Arguments.companyID, Arguments.companyID_custom, Arguments.useCustomIDFieldList)>
	<cfif Not Application.fn_IsIntegerPositive(Arguments.companyID)>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.invalidCompany>
	<cfelse>
		<cfset theCompanyID = Arguments.companyID>
	</cfif>
</cfif>

<!--- validate subscriberID of customer if necessary --->
<cfif returnValue is 0 and (Arguments.subscriberID is not 0 or ListFind(Arguments.useCustomIDFieldList, "subscriberID") or ListFind(Arguments.useCustomIDFieldList, "subscriberID_custom"))>
	<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	<cfif Not Application.fn_IsIntegerPositive(Arguments.subscriberID)><!--- not valid subscriber --->
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.invalidSubscriber>
	<cfelseif theCompanyID is 0>
		<cfset theSubscriberID = Arguments.subscriberID>
	<cfelse><!--- verify that subscriber is for specified company --->
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
		</cfinvoke>

		<cfif qry_selectSubscriber.companyID is theCompanyID>
			<cfset theSubscriberID = Arguments.subscriberID>
		<cfelse>
			<cfset returnValue = -1>
			<cfset returnError = Variables.wslang_payment.notSubscriberCompany>
		</cfif>
	</cfif>
</cfif>

