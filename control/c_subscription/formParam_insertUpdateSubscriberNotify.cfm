<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfloop Query="qry_selectSubscriberNotifyList">
		<cfif qry_selectSubscriberNotifyList.subscriberNotifyStatus is 1>
			<cfparam Name="Form.addressID#qry_selectSubscriberNotifyList.userID#" Default="#qry_selectSubscriberNotifyList.addressID#">
			<cfparam Name="Form.phoneID#qry_selectSubscriberNotifyList.userID#" Default="#qry_selectSubscriberNotifyList.phoneID#">
			<cfif Not IsDefined("Form.isFormSubmitted")>
				<cfparam Name="Form.subscriberNotifyEmail#qry_selectSubscriberNotifyList.userID#" Default="#qry_selectSubscriberNotifyList.subscriberNotifyEmail#">
				<cfparam Name="Form.subscriberNotifyEmailHtml#qry_selectSubscriberNotifyList.userID#" Default="#qry_selectSubscriberNotifyList.subscriberNotifyEmailHtml#">
				<cfparam Name="Form.subscriberNotifyPdf#qry_selectSubscriberNotifyList.userID#" Default="#qry_selectSubscriberNotifyList.subscriberNotifyPdf#">
				<cfparam Name="Form.subscriberNotifyDoc#qry_selectSubscriberNotifyList.userID#" Default="#qry_selectSubscriberNotifyList.subscriberNotifyDoc#">
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfif Variables.doAction is "insertSubscriber" and Not IsDefined("Form.submitUpdateSubscriberNotify")>
	<cfparam Name="Form.subscriberNotifyEmail#Form.userID#" Default="1">
</cfif>

<cfloop Query="qry_selectUserList">
	<cfparam Name="Form.addressID#qry_selectUserList.userID#" Default="0">
	<cfparam Name="Form.subscriberNotifyEmail#qry_selectUserList.userID#" Default="0">
	<cfparam Name="Form.subscriberNotifyEmailHtml#qry_selectUserList.userID#" Default="0">
	<cfparam Name="Form.subscriberNotifyPdf#qry_selectUserList.userID#" Default="0">
	<cfparam Name="Form.subscriberNotifyDoc#qry_selectUserList.userID#" Default="0">
	<cfparam Name="Form.phoneID#qry_selectUserList.userID#" Default="0">
</cfloop>

