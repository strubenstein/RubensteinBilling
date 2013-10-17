<cfinvoke component="#Application.billingMapping#data.PrimaryTarget" method="maxlength_PrimaryTarget" returnVariable="maxlength_PrimaryTarget" />
<cfinclude template="formParam_insertUpdatePrimaryTarget.cfm">
<cfinclude template="../../view/v_primaryTarget/lang_insertUpdatePrimaryTarget.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPrimaryTarget")>
	<cfinclude template="formValidate_insertUpdatePrimaryTarget.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelseif Variables.doAction is "insertPrimaryTarget"><!--- add new primary target --->
		<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="insertPrimaryTarget" ReturnVariable="isPrimaryTargetInserted">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="primaryTargetTable" Value="#Form.primaryTargetTable#">
			<cfinvokeargument Name="primaryTargetKey" Value="#Form.primaryTargetKey#">
			<cfinvokeargument Name="primaryTargetName" Value="#Form.primaryTargetName#">
			<cfinvokeargument Name="primaryTargetDescription" Value="#Form.primaryTargetDescription#">
			<cfinvokeargument Name="primaryTargetStatus" Value="#Form.primaryTargetStatus#">
		</cfinvoke>

		<!--- update primary key switch file --->
		<cfinvoke component="#Application.billingMapping#control.c_primaryTarget.GeneratePrimaryTargetSwitch" method="generatePrimaryTargetSwitch" returnVariable="isSwitchGenerated" />

		<cflocation url="index.cfm?method=primaryTarget.listPrimaryTargets&confirm_primaryTarget=insertPrimaryTarget" AddToken="No">

	<cfelse><!--- update existing primary target --->
		<cfinvoke Component="#Application.billingMapping#data.PrimaryTarget" Method="updatePrimaryTarget" ReturnVariable="isPrimaryTargetUpdated">
			<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="primaryTargetTable" Value="#Form.primaryTargetTable#">
			<cfinvokeargument Name="primaryTargetKey" Value="#Form.primaryTargetKey#">
			<cfinvokeargument Name="primaryTargetName" Value="#Form.primaryTargetName#">
			<cfinvokeargument Name="primaryTargetDescription" Value="#Form.primaryTargetDescription#">
			<cfinvokeargument Name="primaryTargetStatus" Value="#Form.primaryTargetStatus#">
		</cfinvoke>

		<!--- update primary key switch file if primary key field changed --->
		<cfif Form.primaryTargetKey is not qry_selectPrimaryTarget.primaryTargetKey>
			<cfinvoke component="#Application.billingMapping#control.c_primaryTarget.GeneratePrimaryTargetSwitch" method="generatePrimaryTargetSwitch" returnVariable="isSwitchGenerated" />
		</cfif>

		<cflocation url="index.cfm?method=primaryTarget.listPrimaryTargets&confirm_primaryTarget=updatePrimaryTarget" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=primaryTarget.#Variables.doAction#">
<cfif Variables.doAction is "insertPrimaryTarget">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePrimaryTarget.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePrimaryTarget.formSubmitValue_update>
	<cfset Variables.formAction = Variables.formAction & "&primaryTargetID=" & URL.primaryTargetID>
</cfif>

<cfinclude template="../../view/v_primaryTarget/form_insertUpdatePrimaryTarget.cfm">
