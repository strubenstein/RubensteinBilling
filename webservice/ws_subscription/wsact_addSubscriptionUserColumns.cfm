<cfset subscriptionUserArray = ArrayNew(1)>

<cfif qry_selectSubscriptionList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.SubscriptionUser" Method="selectSubscriptionUser" ReturnVariable="qry_selectSubscriptionUser">
		<cfinvokeargument Name="subscriptionID" Value="#ValueList(qry_selectSubscriptionList.subscriptionID)#">
		<cfinvokeargument Name="returnUserField" Value="False">
	</cfinvoke>

	<cfset temp = ArraySet(subscriptionUserArray, 1, qry_selectSubscriptionList.RecordCount, 0)>

	<cfloop Query="qry_selectSubscriptionUser">
		<cfset subscriptionRow = ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), qry_selectSubscriptionUser.userID)>
		<cfif subscriptionRow is not 0>
			<cfif subscriptionUserArray[subscriptionRow] is 0>
				<cfset subscriptionUserArray[subscriptionRow] = qry_selectSubscriptionUser.userID>
			<cfelse>
				<cfset subscriptionUserArray[subscriptionRow] = ListAppend(subscriptionUserArray[subscriptionRow], qry_selectSubscriptionUser.userID)>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfset temp = QueryAddColumn(qry_selectSubscriptionList, "userID", subscriptionUserArray)>

