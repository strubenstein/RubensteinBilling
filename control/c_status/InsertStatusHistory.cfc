<cfcomponent displayName="InsertStatusHistory" hint="Manages inserting and updating custom status for a target">

<cfset This.isStatusExist = False>
<cfset This.primaryTargetID = 0>

<cffunction name="formParam_insertStatusHistory" access="public" output="no" returnType="boolean" hint="Sets initial form values for custom field values">
	<cfargument name="companyID" type="numeric" required="yes">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID_formParam" type="numeric" required="yes">

	<cfset This.primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfinvoke component="#Application.billingMapping#data.StatusHistory" method="maxlength_StatusHistory" returnVariable="maxlength_StatusHistory" />

	<!--- validate that statusID is valid option for target --->
	<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID#">
		<cfinvokeargument Name="primaryTargetID" Value="#This.primaryTargetID#">
		<cfinvokeargument Name="statusStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectStatusList.RecordCount is not 0>
		<cfset This.isStatusExist = True>
		<cfset returnValue = True>

		<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="selectStatusHistory" ReturnVariable="qry_selectStatusHistory">
			<cfinvokeargument Name="primaryTargetID" Value="#This.primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID_formParam#">
			<cfinvokeargument Name="statusHistoryStatus" Value="1">
		</cfinvoke>

		<cfparam Name="Form.statusHistoryComment" Default="">
		<cfif qry_selectStatusHistory.RecordCount is 0>
			<cfparam Name="Form.statusID" Default="0">
		<cfelse>
			<cfparam Name="Form.statusID" Default="#qry_selectStatusHistory.statusID#">
		</cfif>
	</cfif>

	<cfreturn This.isStatusExist>
</cffunction>

<cffunction name="formValidate_insertStatusHistory" access="public" output="no" returnType="struct" hint="Validates form values for custom field values">
	<cfset var errorMessageStruct = StructNew()>
	<cfset var methodStruct = StructNew()>

	<cfif This.isStatusExist is True>
		<cfinclude Template="../../view/v_status/lang_insertStatusHistory.cfm">

		<cfif Form.statusID is not 0 and Not ListFind(ValueList(qry_selectStatusList.statusID), Form.statusID)>
			<cfset errorMessage_fields.statusID = Variables.lang_insertStatusHistory.statusID>
		</cfif>

		<cfif Len(Form.statusHistoryComment) gt maxlength_StatusHistory.statusHistoryComment>
			<cfset errorMessage_fields.statusHistoryComment = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertStatusHistory.statusHistoryComment_maxlength, "<<MAXLENGTH>>", maxlength_StatusHistory.statusHistoryComment, "ALL"), "<<LEN>>", Len(Form.statusHistoryComment), "ALL")>
		</cfif>
	</cfif>

	<cfreturn errorMessageStruct>
</cffunction>

<cffunction name="formProcess_insertStatusHistory" access="public" output="no" returnType="boolean" hint="Inserts updated custom field values">
	<cfargument name="userID" type="numeric" required="yes">
	<cfargument name="targetID_formProcess" type="numeric" required="yes">

	<cfset var methodStruct = StructNew()>

	<cfif This.isStatusExist is True and (Form.statusID is not qry_selectStatusHistory.statusID or Form.statusHistoryComment is not "")>
		<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
			<cfinvokeargument Name="userID" Value="#Arguments.userID#">
			<cfinvokeargument Name="primaryTargetID" Value="#This.primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#Arguments.targetID_formProcess#">
			<cfinvokeargument Name="statusID" Value="#Form.statusID#">
			<cfinvokeargument Name="statusHistoryManual" Value="1">
			<cfinvokeargument Name="statusHistoryComment" Value="#Form.statusHistoryComment#">
		</cfinvoke>
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction name="form_insertStatusHistory" access="public" output="yes" returnType="boolean" hint="Displays form for updating custom field values">
	<cfset var methodStruct = StructNew()>

	<cfif This.isStatusExist is True>
		<cfinclude Template="../../view/v_status/form_insertStatusHistory.cfm">
	</cfif>

	<cfreturn True>
</cffunction>

</cfcomponent>