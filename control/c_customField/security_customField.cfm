<cfif URL.control is "customField">
	<cfif Not Application.fn_IsIntegerNonNegative(URL.customFieldID)>
		<cflocation url="index.cfm?method=customField.listCustomFields&error_customField=invalidCustomField" AddToken="No">
	<cfelseif URL.customFieldID is not 0>
		<cfinvoke Component="#Application.billingMapping#data.CustomField" Method="checkCustomFieldPermission" ReturnVariable="isCustomFieldPermission">
			<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		</cfinvoke>

		<cfif isCustomFieldPermission is False>
			<cflocation url="index.cfm?method=customField.listCustomFields&error_customField=invalidCustomField" AddToken="No">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.CustomField" Method="selectCustomField" ReturnVariable="qry_selectCustomField">
				<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
			</cfinvoke>
		</cfif>
	<cfelseif Not ListFind("listCustomFields,listCustomFieldTargets,insertCustomField", Variables.doAction)>
		<cflocation url="index.cfm?method=customField.listCustomFields&error_customField=noCustomField" AddToken="No">
	</cfif>
</cfif>
