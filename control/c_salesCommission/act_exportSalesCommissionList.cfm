<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="salesCommissions">
	<cfinvokeargument name="xmlTagSingle" value="salesCommission">
	<cfinvokeargument name="fileNamePrefix" value="salesCommissions">
	<cfinvokeargument name="exportQueryName" value="qry_selectSalesCommissionList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectSalesCommissionList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="salesCommissionFinalized,salesCommissionDateFinalized,salesCommissionPaid,salesCommissionDatePaid,salesCommissionStatus,salesCommissionManual,salesCommissionAmount,salesCommissionBasisTotal,salesCommissionBasisQuantity,commissionStatus,commissionPeriodOrInvoiceBased,commissionHasMultipleStages,salesCommissionDateBegin,salesCommissionDateEnd,salesCommissionDateCreated,salesCommissionDateUpdated,commissionDateCreated,commissionDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="salesCommissionAmount,salesCommissionBasisTotal,salesCommissionBasisQuantity">
	</cfif>
</cfinvoke>

