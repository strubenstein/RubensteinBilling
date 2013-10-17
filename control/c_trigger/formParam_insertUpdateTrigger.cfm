<cfif IsDefined("qry_selectTrigger") and IsQuery(qry_selectTrigger) and qry_selectTrigger.RecordCount is 1>
	<cfparam Name="Form.triggerStatus" Default="#qry_selectTrigger.triggerStatus#">
	<cfparam Name="Form.triggerFilename" Default="#qry_selectTrigger.triggerFilename#">
	<cfparam Name="Form.triggerDescription" Default="#qry_selectTrigger.triggerDescription#">
	<cfparam Name="Form.triggerDateBegin" Default="#DateFormat(qry_selectTrigger.triggerDateBegin, "mm/dd/yyyy")#">
	<cfif IsDate(qry_selectTrigger.triggerDateEnd)>
		<cfparam Name="Form.triggerDateEnd" Default="#DateFormat(qry_selectTrigger.triggerDateEnd, "mm/dd/yyyy")#">
	</cfif>
</cfif>

<cfparam Name="Form.triggerStatus" Default="1">
<cfparam Name="Form.triggerFilename" Default="">
<cfparam Name="Form.triggerDescription" Default="">
<cfparam Name="Form.triggerDateBegin" Default="">
<cfparam Name="Form.triggerDateEnd" Default="">
