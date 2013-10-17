<!--- 
Steps to add a user notification option:
1. Select user(s) to notify
2. Display in form to select options
3. Insert/update as necessary
--->

<!--- get subscribers who are notified --->
<cfinvoke Component="#Application.billingMapping#data.SubscriberNotify" Method="selectSubscriberNotifyList" ReturnVariable="qry_selectSubscriberNotifyList">
	<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.userID")>
	<cfset Variables.subscriberUserID_list = Form.userID>
	<cfinclude template="control_updateSubscriberNotify.cfm">
<cfelse>
	<cfset Form.userID_not = ValueList(qry_selectSubscriberNotifyList.userID)>
	<cfset URL.companyID = qry_selectSubscriber.companyID>

	<cfset Variables.doAction = "listUsers">
	<cfset Variables.doControl = "user">
	<cfinclude template="../control.cfm">
</cfif>

