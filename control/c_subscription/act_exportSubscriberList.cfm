<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="subscribers">
	<cfinvokeargument name="xmlTagSingle" value="subscriber">
	<cfinvokeargument name="fileNamePrefix" value="subscribers">
	<cfinvokeargument name="exportQueryName" value="qry_selectSubscriberList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectSubscriberList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="subscriberStatus,subscriberCompleted,subscriberDateProcessNext,subscriberDateProcessLast,subscriberDateCreated,subscriberDateUpdated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="">
	</cfif>
</cfinvoke>

