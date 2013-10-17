<cfinclude template="wslang_payment.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = QueryNew("error")>
<cfelse>
	<cfset Arguments.paymentID = Application.objWebServiceSecurity.ws_checkPaymentPermission(qry_selectWebServiceSession.companyID_author, Arguments.paymentID, Arguments.paymentID_custom, Arguments.useCustomIDFieldList)>

	<cfif ListLen(Arguments.paymentID) is 1 and Arguments.paymentID lte 0>
		<cfset returnValue = QueryNew("error")>
		<cfset returnError = Variables.wslang_payment.invalidPayment>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Payment" Method="selectPayment" ReturnVariable="qry_selectPayment">
			<cfinvokeargument Name="paymentID" Value="#Arguments.paymentID#">
		</cfinvoke>

		<cfset okToView = True>
		<cfset permissionActionList = Application.objWebServiceSession.isUserAuthorizedListWS("viewPayment,viewPaymentRefund", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>

		<cfif ListLen(permissionActionList) is not 2>
			<cfloop Query="qry_selectPayment">
				<cfif (qry_selectPayment.paymentIsRefund is 0 and Not ListFind(permissionActionList, "viewPayment"))
						or (qry_selectPayment.paymentIsRefund is 1 and Not ListFind(permissionActionList, "viewPaymentRefund"))>
					<cfset okToView = False>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>

		<cfif okToView is False>
			<cfset returnValue = QueryNew("error")>
			<cfset returnError = Variables.wslang_payment.viewPayment>
		<cfelse>
			<cfset returnValue = qry_selectPayment>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

