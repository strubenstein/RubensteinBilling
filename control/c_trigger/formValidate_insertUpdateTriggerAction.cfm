<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.triggerActionStatus)>
	<cfset errorMessage_fields.triggerActionStatus = Variables.lang_insertUpdateTriggerAction.triggerActionStatus>
</cfif>

<cfif Not ListFind("0,1", Form.triggerActionSuperuserOnly)>
	<cfset errorMessage_fields.triggerActionSuperuserOnly = Variables.lang_insertUpdateTriggerAction.triggerActionSuperuserOnly>
</cfif>

<cfif URL.triggerAction is "">
	<cfif Trim(Form.triggerAction) is "">
		<cfset errorMessage_fields.triggerAction = Variables.lang_insertUpdateTriggerAction.triggerAction_blank>
	<cfelseif Len(Form.triggerAction) gt maxlength_TriggerAction.triggerAction>
		<cfset errorMessage_fields.triggerAction = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateTriggerAction.triggerAction_maxlength, "<<MAXLENGTH>>", maxlength_TriggerAction.triggerAction, "ALL"), "<<LEN>>", Len(Form.triggerAction), "ALL")>
	<cfelseif Variables.doAction is "insertTriggerAction">
		<cfinvoke Component="#Application.billingMapping#data.TriggerAction" Method="checkTriggerActionIsUnique" ReturnVariable="isTriggerActionUnique">
			<cfinvokeargument Name="triggerAction" Value="#Form.triggerAction#">
		</cfinvoke>
	
		<cfif isTriggerActionUnique is False>
			<cfset errorMessage_fields.triggerAction = Variables.lang_insertUpdateTriggerAction.triggerAction_unique>
		</cfif>
	</cfif>
</cfif>

<cfset Form.triggerActionControl = "">
<cfif Trim(Form.triggerActionControl_text) is not "">
	<cfif Len(Form.triggerActionControl_text) gt maxlength_TriggerAction.triggerActionControl>
		<cfset errorMessage_fields.triggerActionControl = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateTriggerAction.triggerActionControl_maxlength, "<<MAXLENGTH>>", maxlength_TriggerAction.triggerActionControl, "ALL"), "<<LEN>>", Len(Form.triggerActionControl_text), "ALL")>
	<cfelse>
		<cfset Form.triggerActionControl = Form.triggerActionControl_text>
	</cfif>
<cfelseif Form.triggerActionControl_select is not "">
	<cfif Not ListFind(ValueList(qry_selectTriggerActionList.triggerActionControl), Form.triggerActionControl_select)>
		<cfset errorMessage_fields.triggerActionControl = Variables.lang_insertUpdateTriggerAction.triggerActionControl_select>
	<cfelse>
		<cfset Form.triggerActionControl = Form.triggerActionControl_select>
	</cfif>
</cfif>

<cfif Len(Form.triggerActionDescription) gt maxlength_TriggerAction.triggerActionDescription>
	<cfset errorMessage_fields.triggerActionDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateTriggerAction.triggerActionDescription_maxlength, "<<MAXLENGTH>>", maxlength_TriggerAction.triggerActionDescription, "ALL"), "<<LEN>>", Len(Form.triggerActionDescription), "ALL")>
</cfif>

<cfif URL.triggerAction is "" and Form.triggerActionOrder is not 0 and (Not Application.fn_IsIntegerPositive(Form.triggerActionOrder)
		or Form.triggerActionOrder gt qry_selectTriggerActionList.RecordCount)>
	<cfset errorMessage_fields.triggerActionOrder = Variables.lang_insertUpdateTriggerAction.triggerActionOrder>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif URL.triggerAction is "">
		<cfset errorMessage_title = Variables.lang_insertUpdateTriggerAction.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertUpdateTriggerAction.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateTriggerAction.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateTriggerAction.errorFooter>
</cfif>
