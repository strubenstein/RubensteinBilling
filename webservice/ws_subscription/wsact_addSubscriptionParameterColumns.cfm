<cfset subscriptionParameterValueArray = ArrayNew(1)>

<cfif qry_selectSubscriptionList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.SubscriptionParameter" Method="selectSubscriptionParameterList" ReturnVariable="qry_selectSubscriptionParameterList">
		<cfinvokeargument Name="subscriptionID" Value="#ValueList(qry_selectSubscriptionList.subscriptionID)#">
	</cfinvoke>

	<cfset temp = ArraySet(subscriptionParameterValueArray, 1, qry_selectSubscriptionList.RecordCount, "")>

	<cfif qry_selectSubscriptionParameterList.RecordCount is not 0>
		<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="selectProductParameterOption" ReturnVariable="qry_selectProductParameterOption">
			<cfinvokeargument Name="productParameterOptionID" Value="#ValueList(qry_selectSubscriptionParameterList.productParameterOptionID)#">
		</cfinvoke>

		<cfloop Query="qry_selectSubscriptionParameterList">
			<cfset subscriptionRow = ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), qry_selectSubscriptionParameterList.subscriptionID)>
			<cfif subscriptionRow is not 0>
				<cfset parameterOptionRow = ListFind(ValueList(qry_selectProductParameterOption.productParameterOptionID), qry_selectSubscriptionParameterList.productParameterOptionID)>
				<cfif parameterOptionRow is not 0>
					<cfset subscriptionParameterValueArray[subscriptionRow] = 
						subscriptionParameterValueArray[subscriptionRow]
						& "<#qry_selectProductParameterOption.productParameterName[parameterOptionRow]#>"
						& qry_selectProductParameterOption.productParameterOptionValue[parameterOptionRow]
						& "</#qry_selectProductParameterOption.productParameterName[parameterOptionRow]#>">
				</cfif>
			</cfif>
		</cfloop>

		<!--- if not blank, add parent productParameter xml tag --->
		<cfif ArrayLen(subscriptionParameterValueArray) is not 0>
			<cfloop Index="count" From="1" To="#ArrayLen(subscriptionParameterValueArray)#">
				<cfif subscriptionParameterValueArray[count] is not "">
					<cfset subscriptionParameterValueArray[count] = "<productParameter>" & subscriptionParameterValueArray[count] & "</productParameter>">
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfset temp = QueryAddColumn(qry_selectSubscriptionList, "productParameter", subscriptionParameterValueArray)>

