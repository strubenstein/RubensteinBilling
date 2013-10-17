<!--- Check if the subscriber processing entry has already been created for this instance --->
<cfset Variables.subscriberProcessID = 0>
<cfinvoke Component="#Application.billingMapping#data.SubscriberProcess" Method="selectSubscriberProcessList" ReturnVariable="qry_selectSubscriberProcessList">
	<cfinvokeargument Name="subscriberID" Value="#Variables.subscriberID#">
	<cfinvokeargument Name="subscriberProcessCurrent" Value="1">
</cfinvoke>

<cfif qry_selectSubscriberProcessList.RecordCount is 1>
	<cfset Variables.subscriberProcessID = qry_selectSubscriberProcessList.subscriberProcessID>
</cfif>
