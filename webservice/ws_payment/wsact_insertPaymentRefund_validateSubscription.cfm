<!--- validate subscriptions --->
<cfset theSubscriptionID = 0>
<cfif returnValue is 0 and (Arguments.subscriptionID is not "" or ListFind(Arguments.useCustomIDFieldList, "subscriptionID") or ListFind(Arguments.useCustomIDFieldList, "subscriptionID_custom"))>
	<cfset Arguments.subscriptionID = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriptionID, Arguments.subscriptionID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.subscriptionID is 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_payment.invalidSubscription>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscription" ReturnVariable="qry_selectSubscriptionList">
			<cfinvokeargument Name="subscriptionID" Value="#Arguments.subscriptionID#">
		</cfinvoke>

		<cfloop Query="qry_selectSubscriptionList">
			<cfif qry_selectSubscriptionList.CurrentRow gt 1 and qry_selectSubscriptionList.subscriberID is not qry_selectSubscriptionList.subscriberID[qry_selectSubscriptionList.CurrentRow - 1]>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.multipleSubscription>
			<cfelseif theSubscriberID is not 0 and qry_selectSubscriptionList.subscriberID is not theSubscriberID>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_payment.notSubscriberSubscription>
			</cfif>
		</cfloop>

		<!--- set companyID and subscriberID to invoice values if necessary --->
		<cfif returnValue is 0>
			<cfset theSubscriptionID = Arguments.subscriptionID>
			<cfif theSubscriberID is 0>
				<cfset theSubscriberID = qry_selectSubscriptionList.subscriberID[1]>
			</cfif>
			<cfif theCompanyID is 0>
				<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
					<cfinvokeargument Name="subscriberID" Value="#theSubscriberID#">
				</cfinvoke>

				<cfset theCompanyID = qry_selectSubscriber.companyID>
			</cfif>
		</cfif><!--- /set companyID and subscriberID to invoice values if necessary --->
	</cfif><!--- /if subscriptions are valid, validate subscriber --->
</cfif><!--- /validate subscriptions --->

