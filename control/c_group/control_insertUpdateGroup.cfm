<cfinclude template="formParam_insertUpdateGroup.cfm">
<cfinvoke component="#Application.billingMapping#data.Group" method="maxlength_Group" returnVariable="maxlength_Group" />
<cfinclude template="../../view/v_group/lang_insertUpdateGroup.cfm">

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupCategoryList" ReturnVariable="qry_selectGroupCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="groupID">
	<cfinvokeargument name="targetID_formParam" value="#URL.groupID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="groupID">
	<cfinvokeargument name="targetID_formParam" value="#URL.groupID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("submitInsertUpdateGroup")>
	<cfinclude template="formValidate_insertUpdateGroup.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">

	<cfelseif Variables.doAction is "insertGroup">
		<cfinvoke Component="#Application.billingMapping#data.Group" Method="insertGroup" ReturnVariable="newGroupID">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="groupName" Value="#Form.groupName#">
			<cfinvokeargument Name="groupCategory" Value="#Form.groupCategory#">
			<cfinvokeargument Name="groupDescription" Value="#Form.groupDescription#">
			<cfinvokeargument Name="groupStatus" Value="#Form.groupStatus#">
			<cfinvokeargument Name="groupID_custom" Value="#Form.groupID_custom#">
		</cfinvoke>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newGroupID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newGroupID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=group.insertGroup&confirm_group=#URL.action#" AddToken="No">

	<cfelse><!--- updateGroup --->
		<cfinvoke Component="#Application.billingMapping#data.Group" Method="updateGroup" ReturnVariable="isGroupUpdated">
			<cfinvokeargument Name="groupID" Value="#URL.groupID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="groupName" Value="#Form.groupName#">
			<cfinvokeargument Name="groupCategory" Value="#Form.groupCategory#">
			<cfinvokeargument Name="groupDescription" Value="#Form.groupDescription#">
			<cfinvokeargument Name="groupStatus" Value="#Form.groupStatus#">
			<cfinvokeargument Name="groupID_custom" Value="#Form.groupID_custom#">
		</cfinvoke>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.groupID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.groupID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=group.updateGroup&groupID=#URL.groupID#&confirm_group=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfif Variables.doAction is "insertGroup">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateGroup.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateGroup.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_group/form_insertUpdateGroup.cfm">

