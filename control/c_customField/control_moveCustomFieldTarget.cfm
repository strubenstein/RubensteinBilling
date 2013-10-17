<cfif Not IsDefined("URL.primaryTargetID") or Not Application.fn_IsIntegerPositive(URL.primaryTargetID)>
	<cflocation url="index.cfm?method=customField.listCustomFieldTargets&error_customField=#Variables.doAction#" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldTarget" ReturnVariable="qry_selectCustomFieldTarget">
	<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
	<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
</cfinvoke>

<cfif qry_selectCustomFieldTarget.RecordCount is not 1>
	<cflocation url="index.cfm?method=customField.listCustomFieldTargets&error_customField=#Variables.doAction#" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="switchCustomFieldTargetOrder" ReturnVariable="isCustomFieldTargetOrderMoved">
	<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
	<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
	<cfinvokeargument Name="customFieldTargetOrder_direction" Value="#Variables.doAction#">
</cfinvoke>

<cflocation url="index.cfm?method=customField.listCustomFieldTargets&confirm_customField=#Variables.doAction#" AddToken="No">