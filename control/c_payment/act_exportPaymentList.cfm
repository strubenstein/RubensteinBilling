<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfif Variables.doAction is "listPayments">
		<cfinvokeargument name="xmlTagPlural" value="payments">
		<cfinvokeargument name="xmlTagSingle" value="payment">
		<cfinvokeargument name="fileNamePrefix" value="payments">
	<cfelse>
		<cfinvokeargument name="xmlTagPlural" value="refunds">
		<cfinvokeargument name="xmlTagSingle" value="refund">
		<cfinvokeargument name="fileNamePrefix" value="refunds">
	</cfif>
	<cfinvokeargument name="exportQueryName" value="qry_selectPaymentList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectPaymentList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="paymentAmount,paymentManual,paymentProcessed,paymentCheckNumber,paymentApproved,paymentStatus,paymentIsRefund,paymentDateReceived,paymentDateScheduled,paymentDateCreated,paymentDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="paymentAmount">
	</cfif>
</cfinvoke>

