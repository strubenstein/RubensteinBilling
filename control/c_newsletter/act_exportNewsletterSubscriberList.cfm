<cfinvoke component="#Application.billingMapping#control.c_export.ExportQueryForCompany" method="exportQueryForCompany" returnVariable="isExported">
	<cfinvokeargument name="exportResultsMethod" value="#Form.exportResultsMethod#">
	<cfinvokeargument name="exportResultsFormat" value="#Form.exportResultsFormat#">
	<cfinvokeargument name="xmlTagPlural" value="newsletterSubscribers">
	<cfinvokeargument name="xmlTagSingle" value="newsletterSubscriber">
	<cfinvokeargument name="fileNamePrefix" value="newsletterSubscribers">
	<cfinvokeargument name="exportQueryName" value="qry_selectNewsletterSubscriberList">
	<cfinvokeargument name="qry_exportTargetList" value="#qry_selectNewsletterSubscriberList#">
	<cfif Form.exportResultsFormat is "display">
		<cfinvokeargument name="fieldsWithCustomDisplay" value="newsletterSubscriberStatus,newsletterSubscriberHtml,newsletterSubscriberDateCreated">
	<cfelse><!--- data --->
		<cfinvokeargument name="fieldsWithCustomDisplay" value="">
	</cfif>
</cfinvoke>

