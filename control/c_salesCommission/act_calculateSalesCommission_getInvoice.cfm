<!--- invoice is selected in component to ensure invoice is paid before continuing --->
<!--- select line items for product and vendor info --->
<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
	<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
	<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
</cfinvoke>

<!--- select company information for affiliate and cobrand --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
	<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
</cfinvoke>

<!--- determine begin date of first price stage --->
<cfif qry_selectInvoice.subscriberID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
		<cfinvokeargument Name="subscriberID" Value="#qry_selectInvoice.subscriberID#">
	</cfinvoke>

	<cfquery Name="qry_selectSubscriptionListFromInvoice" DBType="query">
		SELECT DISTINCT(subscriptionID)
		FROM qry_selectInvoiceLineItemList
		WHERE subscriptionID <> 0
	</cfquery>

	<cfif qry_selectSubscriptionListFromInvoice.RecordCount is not 0>
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
			<cfinvokeargument Name="subscriberID" Value="#qry_selectInvoice.subscriberID#">
			<cfinvokeargument Name="subscriptionID" Value="#ValueList(qry_selectSubscriptionListFromInvoice.subscriptionID)#">
		</cfinvoke>

		<cfloop Query="qry_selectSubscriptionList">
			<cfset subscriptionRowStruct["subscription#qry_selectSubscriptionListFromInvoice.subscriptionID#"] = qry_selectSubscriptionList.CurrentRow>
		</cfloop>
	</cfif>
</cfif>

<!--- set effective date of commission for determining price stage --->
<cfif IsDate(qry_selectInvoice.invoiceDatePaid)>
	<cfset effectiveCommissionDate = qry_selectInvoice.invoiceDatePaid>
<cfelse>
	<cfset effectiveCommissionDate = Now()>
</cfif>

