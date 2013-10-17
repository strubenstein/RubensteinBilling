<cfcomponent displayName="ViewCustomFieldValue" hint="Manages viewing current and history of custom field values for a target">

<cffunction name="viewCustomFieldValues" access="public" output="yes" returnType="boolean" hint="Displays current custom field values for a target">
	<cfargument name="companyID" type="numeric" required="yes">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID" type="numeric" required="yes">

	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfset var returnValue = False>
	<cfset var customFieldTypeList = "">
	<cfset var valueRow = 0>
	<cfset var thisCustomFieldID = 0>
	<cfset var thisValue = "">

	<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldListForTarget" ReturnVariable="qry_selectCustomFieldListForTarget">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
	</cfinvoke>

	<cfif qry_selectCustomFieldListForTarget.RecordCount is not 0>
		<cfsilent>
		<cfloop Query="qry_selectCustomFieldListForTarget">
			<cfif Not ListFind(customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
				<cfset customFieldTypeList = ListAppend(customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
			</cfif>
		</cfloop>

		<!--- select existing values of custom fields for target --->
		<cfinvoke Component="#Application.billingMapping#data.CustomFieldValue" Method="selectCustomFieldValueList" ReturnVariable="qry_selectCustomFieldValueList">
			<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldListForTarget.customFieldID)#">
			<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			<cfinvokeargument Name="customFieldValueStatus" Value="1">
			<cfinvokeargument Name="customFieldTypeList" Value="#customFieldTypeList#">
		</cfinvoke>
		</cfsilent>

		<cfinclude template="../../view/v_customField/dsp_viewCustomFieldValues.cfm">
		<cfset returnValue = True>
	</cfif>

	<cfreturn returnValue>
</cffunction>

<cffunction name="viewCustomFieldValueHistory" access="public" output="yes" returnType="boolean" hint="Displays custom field history for a particular target and optional individual custom field">
	<cfargument name="companyID" type="numeric" required="yes">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID" type="numeric" required="yes">
	<cfargument name="customFieldID" type="numeric" required="no">

	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfset var returnValue = False>
	<cfset var methodStruct = StructNew()>
	<cfset var customFieldTypeList = "">
	<cfset var customFieldCount = StructNew()>

	<cfsilent>
	<cfset methodStruct.displayURLCustomField = False>
	<cfset methodStruct.columnCount = 11>
	<cfset methodStruct.userID_list = "">
	<cfset methodStruct.previousUserID = 0>
	<cfset methodStruct.previousCustomFieldID = 0>

	<cfinvoke Component="#Application.billingMapping#data.CustomFieldTarget" Method="selectCustomFieldListForTarget" ReturnVariable="qry_selectCustomFieldListForTarget">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
	</cfinvoke>
	</cfsilent>

	<cfif qry_selectCustomFieldListForTarget.RecordCount is not 0>
		<cfsilent>
		<cfloop Query="qry_selectCustomFieldListForTarget">
			<cfif Not ListFind(customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
				<cfset customFieldTypeList = ListAppend(customFieldTypeList, qry_selectCustomFieldListForTarget.customFieldType)>
			</cfif>
		</cfloop>

		<cfif StructKeyExists(Arguments, "customFieldID") and ListFind(ValueList(qry_selectCustomFieldListForTarget.customFieldID), Arguments.customFieldID)>
			<cfset methodStruct.displayURLCustomField = True>
		</cfif>

		<!--- select existing values of custom fields for target --->
		<cfinvoke Component="#Application.billingMapping#data.CustomFieldValue" Method="selectCustomFieldValueList" ReturnVariable="qry_selectCustomFieldValueList">
			<cfif methodStruct.displayURLCustomField is True>
				<cfinvokeargument Name="customFieldID" Value="#URL.customFieldID#">
			<cfelse>
				<cfinvokeargument Name="customFieldID" Value="#ValueList(qry_selectCustomFieldListForTarget.customFieldID)#">
			</cfif>
			<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
			<!--- <cfinvokeargument Name="customFieldValueStatus" Value="1"> --->
			<cfinvokeargument Name="customFieldTypeList" Value="#customFieldTypeList#">
		</cfinvoke>

		<cfloop Query="qry_selectCustomFieldListForTarget">
			<cfset customFieldCount["customField#qry_selectCustomFieldListForTarget.customFieldID#"] = ListValueCount(ValueList(qry_selectCustomFieldValueList.customFieldID), qry_selectCustomFieldListForTarget.customFieldID)>
		</cfloop>

		<cfloop Query="qry_selectCustomFieldValueList">
			<cfif Not ListFind(methodStruct.userID_list, qry_selectCustomFieldValueList.userID)>
				<cfset methodStruct.userID_list = ListAppend(methodStruct.userID_list, qry_selectCustomFieldValueList.userID)>
			</cfif>
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserList">
			<cfif methodStruct.userID_list is "">
				<cfinvokeargument Name="userID" Value="0">
			<cfelse>
				<cfinvokeargument Name="userID" Value="#methodStruct.userID_list#">
			</cfif>
		</cfinvoke>
		</cfsilent>

		<cfinclude Template="../../view/v_customField/dsp_viewCustomFieldValueHistory.cfm">

		<cfset returnValue = True>
	</cfif>

	<cfreturn returnValue>
</cffunction>

</cfcomponent>