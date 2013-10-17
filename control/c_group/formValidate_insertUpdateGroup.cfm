<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.groupStatus)>
	<cfset errorMessage_fields.groupStatus = Variables.lang_insertUpdateGroup.groupStatus>
</cfif>

<cfif Trim(Form.groupName) is "">
	<cfset errorMessage_fields.groupName = Variables.lang_insertUpdateGroup.groupName_blank>
<cfelseif Len(Form.groupName) gt maxlength_Group.groupName>
	<cfset errorMessage_fields.groupName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateGroup.groupName_maxlength, "<<MAXLENGTH>>", maxlength_Group.groupName, "ALL"), "<<LEN>>", Len(Form.groupName), "ALL")>
<cfelse><!--- update --->
	<cfinvoke Component="#Application.billingMapping#data.Group" Method="checkGroupNameIsUnique" ReturnVariable="isGroupNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		 <cfinvokeargument Name="groupID" Value="#URL.groupID#">
		 <cfinvokeargument Name="groupName" Value="#Form.groupName#">
	</cfinvoke>

	<cfif isGroupNameUnique is False>
		<cfset errorMessage_fields.groupName = Variables.lang_insertUpdateGroup.groupName_unique>
	</cfif>
</cfif>

<cfif Form.groupID_custom is not "">
	<cfif Len(Form.groupID_custom) gt maxlength_Group.groupID_custom>
		<cfset errorMessage_fields.groupID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateGroup.groupID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Group.groupID_custom, "ALL"), "<<LEN>>", Len(Form.groupID_custom), "ALL")>
	<cfelse><!--- update --->
		<cfinvoke Component="#Application.billingMapping#data.Group" Method="checkGroupID_customIsUnique" ReturnVariable="isGroupID_customUnique">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			 <cfinvokeargument Name="groupID_custom" Value="#Form.groupID_custom#">
			 <cfif URL.groupID is not 0>
				 <cfinvokeargument Name="groupID" Value="#URL.groupID#">
			</cfif>
		</cfinvoke>
	
		<cfif isGroupID_customUnique is False>
			<cfset errorMessage_fields.groupID_custom = Variables.lang_insertUpdateGroup.groupID_custom_unique>
		</cfif>
	</cfif>
</cfif>

<cfif Len(Form.groupDescription) gt maxlength_Group.groupDescription>
	<cfset errorMessage_fields.groupDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateGroup.groupDescription, "<<MAXLENGTH>>", maxlength_Group.groupDescription, "ALL"), "<<LEN>>", Len(Form.groupDescription), "ALL")>
</cfif>

<cfif Form.groupCategory_text is not "">
	<cfif Len(Form.groupCategory_text) gt maxlength_Group.groupCategory>
		<cfset errorMessage_fields.groupCategory_text = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateGroup.groupCategory_text, "<<MAXLENGTH>>", maxlength_Group.groupCategory_text, "ALL"), "<<LEN>>", Len(Form.groupCategory_text), "ALL")>
	<cfelse>
		<cfset Form.groupCategory = Form.groupCategory_text>
	</cfif>
<cfelseif Form.groupCategory_select is not "">
	<cfif Not ListFind(ValueList(qry_selectGroupCategoryList.groupCategory), Form.groupCategory_select)>
		<cfset errorMessage_fields.groupCategory_select = Variables.lang_insertUpdateGroup.groupCategory_select_valid>
	<cfelseif Len(Form.groupCategory_select) gt maxlength_Group.groupCategory>
		<cfset errorMessage_fields.groupCategory_select = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateGroup.groupCategory_select_maxlength, "<<MAXLENGTH>>", maxlength_Group.groupCategory_select, "ALL"), "<<LEN>>", Len(Form.groupCategory_select), "ALL")>
	<cfelse>
		<cfset Form.groupCategory = Form.groupCategory_select>
	</cfif>
<cfelse>
	<cfset Form.groupCategory = "">
</cfif>

<!--- Validate custom fields and custom status if applicable (and not via web service) --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfif isCustomFieldValueExist is True>
		<cfinvoke component="#objInsertCustomFieldValue#" method="formValidate_insertCustomFieldValue" returnVariable="errorMessageStruct_customField" />
		<cfif Not StructIsEmpty(errorMessageStruct_customField)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_customField)>
		</cfif>
	</cfif>

	<cfif isStatusExist is True>
		<cfinvoke component="#objInsertStatusHistory#" method="formValidate_insertStatusHistory" returnVariable="errorMessageStruct_status" />
		<cfif Not StructIsEmpty(errorMessageStruct_status)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_status)>
		</cfif>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertGroup">
		<cfset errorMessage_title = Variables.lang_insertUpdateGroup.errorTitle_insert>
	<cfelse><!--- updateGroup --->
		<cfset errorMessage_title = Variables.lang_insertUpdateGroup.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateGroup.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateGroup.errorFooter>
</cfif>

