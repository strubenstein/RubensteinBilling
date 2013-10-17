<cfif qry_selectSubscriberList.RecordCount is not 0>
	<cfset temp = ArraySet(subscriberPaymentCreditCardID, 1, qry_selectSubscriberList.RecordCount, 0)>
	<cfset temp = ArraySet(subscriberPaymentBankID, 1, qry_selectSubscriberList.RecordCount, 0)>

	<!--- get subscriber payment information --->
	<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="selectSubscriberPaymentList" ReturnVariable="qry_selectSubscriberPaymentList">
		<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
		<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
	</cfinvoke>

	<cfloop Query="qry_selectSubscriberPaymentList">
		<cfset subscriberRow = ListFind(ValueList(qry_selectSubscriberList.subscriberID), qry_selectSubscriberPaymentList.subscriberID)>
		<cfif subscriberRow is not 0>
			<cfset subscriberPaymentCreditCardID[CurrentRow] = qry_selectSubscriberPaymentList.creditCardID>
			<cfset subscriberPaymentBankID[CurrentRow] = qry_selectSubscriberPaymentList.bankID>
		</cfif>
	</cfloop>
</cfif>

<cfset QueryAddColumn(qry_selectSubscriberList, "creditCardID", subscriberPaymentCreditCardID)>
<cfset QueryAddColumn(qry_selectSubscriberList, "bankID", subscriberPaymentBankID)>
