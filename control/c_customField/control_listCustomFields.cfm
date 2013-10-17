<cfinvoke Component="#Application.billingMapping#data.CustomField" Method="selectCustomFieldList" ReturnVariable="qry_selectCustomFieldList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="../../view/v_customField/lang_listCustomFields.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateCustomField")>
<cfset Variables.columnHeaderList = Variables.lang_listCustomFields_title.customFieldName
		& "^" &  Variables.lang_listCustomFields_title.customFieldLabel
		& "^" &  Variables.lang_listCustomFields_title.customFieldFormType
		& "^" &  Variables.lang_listCustomFields_title.customFieldDescription
		& "^" &  Variables.lang_listCustomFields_title.customFieldStatus
		& "^" &  Variables.lang_listCustomFields_title.customFieldInternal
		& "^" &  Variables.lang_listCustomFields_title.customFieldTargets
		& "^" &  Variables.lang_listCustomFields_title.customFieldDateCreated>

<cfif ListFind(Variables.permissionActionList, "updateCustomField")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCustomFields_title.updateCustomField>
</cfif>

<cfset Variables.displayCustomFieldOptions = False>
<cfif qry_selectCustomFieldList.RecordCount is not 0>
	<cfinvoke Component="#Application.billingMapping#data.CustomFieldOption" Method="selectCustomFieldOptionList" ReturnVariable="qry_selectCustomFieldOptionList">
		<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldList.customFieldID)#">
		<cfinvokeargument Name="customFieldOptionStatus" Value="1">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldTargetList" ReturnVariable="qry_selectCustomFieldTargetList">
		<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldList.customFieldID)#">
		<cfinvokeargument Name="queryOrderByCustomFieldID" Value="True">
	</cfinvoke>

	<cfif qry_selectCustomFieldOptionList.RecordCount is not 0>
		<cfset Variables.displayCustomFieldOptions = True>
		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCustomFields_title.customFieldOptions>
	</cfif>
</cfif>

<cfif Not IsDefined("fn_DisplayOrderByButtons") or Not IsCustomFunction(fn_DisplayOrderByButtons)>
	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
</cfif>
<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../view/v_customField/dsp_selectCustomFieldList.cfm">
