
<cfset Variables.customFieldTypeList = "">
<cfloop Query="qry_selectCustomFieldListForTarget">
	<cfif Not ListFind(Variables.customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
		<cfset Variables.customFieldTypeList = ListAppend(Variables.customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
	</cfif>
</cfloop>

<cfif IsDefined("URL.customFieldID") and ListFind(ValueList(qry_selectCustomFieldListForTarget.customFieldID), URL.customFieldID)>
	<cfset Variables.displayURLCustomField = True>
<cfelse>
	<cfset Variables.displayURLCustomField = False>
</cfif>

<!--- select existing values of custom fields for target --->
<cfinvoke Component="#Application.billingMapping#data.CustomFieldValue" Method="selectCustomFieldValueList" ReturnVariable="qry_selectCustomFieldValueList">
	<cfif Variables.displayURLCustomField is True>
		<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
	<cfelse>
		<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldListForTarget.customFieldID)#">
	</cfif>
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	<!--- <cfinvokeargument Name="customFieldValueStatus" Value="1"> --->
	<cfinvokeargument Name="customFieldTypeList" Value="#Variables.customFieldTypeList#">
</cfinvoke>

<cfset Variables.customFieldCount = StructNew()>
<cfloop Query="qry_selectCustomFieldListForTarget">
	<cfset Variables.customFieldCount["customField#qry_selectCustomFieldListForTarget.customFieldID#"] = ListValueCount(ValueList(qry_selectCustomFieldValueList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
</cfloop>

<cfset Variables.userID_list = "">
<cfloop Query="qry_selectCustomFieldValueList">
	<cfif Not ListFind(Variables.userID_list, qry_selectCustomFieldValueList.userID)>
		<cfset Variables.userID_list = ListAppend(Variables.userID_list, qry_selectCustomFieldValueList.userID)>
	</cfif>
</cfloop>

<cfif Variables.userID_list is "">
	<cfset qry_selectUserList = QueryNew("userID")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserList">
		<cfinvokeargument Name="userID" Value="#Variables.userID_list#">
	</cfinvoke>
</cfif>

<cfinclude template="../../view/v_customField/lang_viewCustomFieldValuesAll.cfm">

<cfset Variables.columnHeaderList = Variables.lang_viewCustomFieldValuesAll_title.customFieldName
		& "^" &  Variables.lang_viewCustomFieldValuesAll_title.customFieldVersion
		& "^" &  Variables.lang_viewCustomFieldValuesAll_title.customFieldValue
		& "^" &  Variables.lang_viewCustomFieldValuesAll_title.customFieldStatus
		& "^" &  Variables.lang_viewCustomFieldValuesAll_title.customFieldDateCreated
		& "^" &  Variables.lang_viewCustomFieldValuesAll_title.customFieldAuthor>
<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfif Not IsDefined("fn_DisplayCurrentRecordNumbers")>
	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
</cfif>

<cfinclude template="../../view/v_customField/dsp_selectCustomFieldValuesAll.cfm">
