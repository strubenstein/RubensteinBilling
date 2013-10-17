<cfif URL.customFieldID is not 0 and IsDefined("qry_selectCustomField") and IsDefined("qry_selectCustomFieldOptionList") and IsDefined("qry_selectCustomFieldTargetList")>
	<cfparam Name="Form.customFieldName" Default="#qry_selectCustomField.customFieldName#">
	<cfparam Name="Form.customFieldTitle" Default="#qry_selectCustomField.customFieldTitle#">
	<cfparam Name="Form.customFieldDescription" Default="#qry_selectCustomField.customFieldDescription#">
	<cfparam Name="Form.customFieldType" Default="#qry_selectCustomField.customFieldType#">
	<cfparam Name="Form.customFieldFormType" Default="#qry_selectCustomField.customFieldFormType#">
	<cfparam Name="Form.customFieldStatus" Default="#qry_selectCustomField.customFieldStatus#">
	<cfparam Name="Form.customFieldInternal" Default="#qry_selectCustomField.customFieldInternal#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.customFieldExportXml" Default="#qry_selectCustomField.customFieldExportXml#">
		<cfparam Name="Form.customFieldExportTab" Default="#qry_selectCustomField.customFieldExportTab#">
		<cfparam Name="Form.customFieldExportHtml" Default="#qry_selectCustomField.customFieldExportHtml#">

		<cfset Form.primaryTargetID = "">
		<cfloop Query="qry_selectCustomFieldTargetList">
			<cfif qry_selectCustomFieldTargetList.customFieldTargetStatus is 1>
				<cfset Form.primaryTargetID = ListAppend(Form.primaryTargetID, qry_selectCustomFieldTargetList.primaryTargetID)>
			</cfif>
		</cfloop>
	</cfif>

	<cfparam Name="Form.customFieldOptionCount" Default="#qry_selectCustomFieldOptionList.RecordCount#">
	<cfloop Query="qry_selectCustomFieldOptionList">
		<cfparam Name="Form.customFieldOptionLabel#CurrentRow#" Default="#qry_selectCustomFieldOptionList.customFieldOptionLabel#">
		<cfparam Name="Form.customFieldOptionValue#CurrentRow#" Default="#qry_selectCustomFieldOptionList.customFieldOptionValue#">
	</cfloop>
</cfif>

<cfparam Name="Form.customFieldName" Default="">
<cfparam Name="Form.customFieldTitle" Default="">
<cfparam Name="Form.customFieldDescription" Default="">
<cfparam Name="Form.customFieldType" Default="Varchar">
<cfparam Name="Form.customFieldFormType" Default="text">
<cfparam Name="Form.customFieldStatus" Default="1">
<cfparam Name="Form.customFieldInternal" Default="0">

<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.customFieldExportXml" Default="1">
	<cfparam Name="Form.customFieldExportTab" Default="1">
	<cfparam Name="Form.customFieldExportHtml" Default="1">
<cfelse>
	<cfparam Name="Form.customFieldExportXml" Default="0">
	<cfparam Name="Form.customFieldExportTab" Default="0">
	<cfparam Name="Form.customFieldExportHtml" Default="0">
</cfif>

<cfparam Name="Form.primaryTargetID" Default="">

<cfparam Name="Form.customFieldOptionCount" Default="5">
<cfif Not Application.fn_IsIntegerPositive(Form.customFieldOptionCount)>
	<cfset Form.customFieldOptionCount = 5>
</cfif>

<cfloop Index="count" From="1" To="#Form.customFieldOptionCount#">
	<cfparam Name="Form.customFieldOptionLabel#count#" Default="">
	<cfparam Name="Form.customFieldOptionValue#count#" Default="">
</cfloop>

<cfloop Index="count" From="1" To="#Form.customFieldOptionCount#">
	<cfset Variables.newCount = 0>
	<cfif count is not 1 and (IsDefined("Form.submitMoveCustomFieldOptionUp#count#") or IsDefined("Form.submitMoveCustomFieldOptionUp#count#.x"))>
		<cfset Variables.newCount = count - 1>
	<cfelseif count is not Form.customFieldOptionCount and (IsDefined("Form.submitMoveCustomFieldOptionDown#count#") or IsDefined("Form.submitMoveCustomFieldOptionDown#count#.x"))>
		<cfset Variables.newCount = count + 1>
	</cfif>

	<cfif Variables.newCount is not 0>
		<!--- save current values of count being moved in temporary fields --->
		<cfset Variables.tempLabel = Form["customFieldOptionLabel#count#"]>
		<cfset Variables.tempValue = Form["customFieldOptionValue#count#"]>

		<!--- set values of count being forced to moved to its existing values --->
		<cfset temp = SetVariable("Form.customFieldOptionLabel#count#", Form["customFieldOptionLabel#Variables.newCount#"])>
		<cfset temp = SetVariable("Form.customFieldOptionValue#count#", Form["customFieldOptionValue#Variables.newCount#"])>

		<!--- set values of count being moved to its existing values --->
		<cfset temp = SetVariable("Form.customFieldOptionLabel#Variables.newCount#", Variables.tempLabel)>
		<cfset temp = SetVariable("Form.customFieldOptionValue#Variables.newCount#", Variables.tempValue)>

		<cfbreak>
	</cfif>
</cfloop>
