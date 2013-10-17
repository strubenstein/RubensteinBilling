<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="paymentCredits">
	<cfinvokeargument name="xmlTagSingle" value="paymentCredit">
	<cfinvokeargument name="fileNamePrefix" value="paymentCredits">
	<cfinvokeargument name="exportQueryName" value="qry_selectPaymentCreditList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectPaymentCreditList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="paymentCreditAmount,paymentCreditStatus,paymentCreditRollover,paymentCreditNegativeInvoice,paymentCreditCompleted,paymentCreditDateBegin,paymentCreditDateEnd,paymentCreditDateCreated,paymentCreditDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="paymentCreditAmount">
	</cfif>
</cfinvoke>

