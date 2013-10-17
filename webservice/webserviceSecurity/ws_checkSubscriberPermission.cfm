<cfif Not ListFind(Arguments.useCustomIDFieldList, "subscriberID") and Not ListFind(Arguments.useCustomIDFieldList, "subscriberID_custom")>
	<cfif Arguments.subscriberID is 0 or Not Application.fn_IsIntegerList(Arguments.subscriberID)>
		<cfset returnValue = 0>
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="checkSubscriberPermission" ReturnVariable="isSubscriberPermission">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerPositive(Arguments.companyID)>
				<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
			</cfif>
		</cfinvoke>

		<cfif isSubscriberPermission is False>
			<cfset returnValue = 0>
		<cfelse>
			<cfset returnValue = Arguments.subscriberID>
		</cfif>
	</cfif>
<cfelseif Trim(Arguments.subscriberID_custom) is "">
	<cfset returnValue = 0>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriberIDViaCustomID" ReturnVariable="subscriberIDViaCustomID">
		<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
		<cfinvokeargument Name="subscriberID_custom" Value="#Arguments.subscriberID_custom#">
		<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerPositive(Arguments.companyID)>
			<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		</cfif>
	</cfinvoke>

	<cfset returnValue = subscriberIDViaCustomID>
</cfif>
