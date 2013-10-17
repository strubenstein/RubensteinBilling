<cfinvoke Component="#Application.billingMapping#data.CustomField" Method="selectCustomFieldList" ReturnVariable="qry_selectCustomFieldList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="../../view/v_customField/lang_listCustomFieldTargets.cfm">

<cfset Variables.permissionActionList = "moveCustomFieldTargetDown,moveCustomFieldTargetUp,updateCustomField,viewCustomFieldValuesAll">
<cfset Variables.columnHeaderList = Variables.lang_listCustomFieldTargets_title.customFieldOrder
		& "^" &  Variables.lang_listCustomFieldTargets_title.customFieldName
		& "^" &  Variables.lang_listCustomFieldTargets_title.customFieldLabel
		& "^" &  Variables.lang_listCustomFieldTargets_title.customFieldType
		& "^" &  Variables.lang_listCustomFieldTargets_title.customFieldFormType
		& "^" &  Variables.lang_listCustomFieldTargets_title.customFieldTargetStatus
		& "^" &  Variables.lang_listCustomFieldTargets_title.customFieldDateCreated
		& "^" &  Variables.lang_listCustomFieldTargets_title.customFieldDateUpdated>

<cfif ListFind(Variables.permissionActionList, "moveCustomFieldTargetDown") and ListFind(Variables.permissionActionList, "moveCustomFieldTargetUp")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCustomFieldTargets_title.moveCustomFieldTarget>
</cfif>

<cfif ListFind(Variables.permissionActionList, "updateCustomField")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCustomFieldTargets_title.updateCustomField>
</cfif>

<cfset Variables.displayCustomFieldOptions = False>
<cfif qry_selectCustomFieldList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.CustomFieldOption" Method="selectCustomFieldOptionList" ReturnVariable="qry_selectCustomFieldOptionList">
		<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldList.customFieldID)#">
		<cfinvokeargument Name="customFieldOptionStatus" Value="1">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldTargetList" ReturnVariable="qry_selectCustomFieldTargetList">
		<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldList.customFieldID)#">
		<cfinvokeargument Name="queryOrderByCustomFieldID" Value="False">
	</cfinvoke>

	<cfif qry_selectCustomFieldOptionList.RecordCount is not 0>
		<cfset Variables.displayCustomFieldOptions = True>
		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^Options">
	</cfif>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfinclude template="../../view/v_customField/dsp_selectCustomFieldTargetList.cfm">
