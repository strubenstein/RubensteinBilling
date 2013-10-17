<!--- 
<cfif Not Application.fn_IsIntegerNonNegative(URL.subscriberID)>
	<cflocation url="#Variables.subscriptionActionList#&error_subscription=noSubscriber" AddToken="No">
--->
<cfif Trim(URL.subscriberID) is "">
	<cflocation url="#Variables.subscriptionActionList#&error_subscription=noSubscriber" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.companyID) or (URL.companyID is not 0 and Not ListFind("company,user", URL.control))>
	<cflocation url="#Variables.subscriptionActionList#&error_subscription=invalidCompany" AddToken="No">
<cfelseif Not Application.fn_IsIntegerNonNegative(URL.userID) or (URL.userID is not 0 and Not ListFind("user,company", URL.control))>
	<cflocation url="#Variables.subscriptionActionList#&error_subscription=invalidUser" AddToken="No">
<cfelseif Variables.doAction is "insertSubscriber" and Not ListFind("user,company", URL.control)>
	<cflocation url="#Variables.subscriptionActionList#&error_subscription=insertSubscriber" AddToken="No">
<cfelseif URL.subscriberID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="checkSubscriberPermission" ReturnVariable="isSubscriberPermission">
		<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfif URL.companyID is not 0>
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
		</cfif>
		<cfif URL.userID is not 0>
			<cfinvokeargument Name="userID" Value="#URL.userID#">
		</cfif>
		<cfif Session.companyID is not Session.companyID_author>
			<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
			<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
		</cfif>
	</cfinvoke>

	<cfif isSubscriberPermission is False>
		<cflocation url="#Variables.subscriptionActionList#&error_subscription=invalidSubscriber" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
			<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
		</cfinvoke>

		<!--- 
		<cfif qry_selectSubscriber.companyID is not URL.companyID and qry_selectSubscriber.userID is not URL.userID>
			<cflocation url="#Variables.subscriptionActionList#&error_subscription=invalidSubscriber" AddToken="No">
		--->
	</cfif>
<cfelseif Not ListFind("listSubscribers,insertSubscriber", Variables.doAction)>
	<cflocation url="#Variables.subscriptionActionList#&error_subscription=noSubscriber" AddToken="No">
</cfif>
