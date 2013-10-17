<cfinclude template="formParam_updateStatusTarget.cfm">
<cfinvoke component="#Application.billingMapping#data.StatusTarget" method="maxlength_StatusTarget" returnVariable="maxlength_StatusTarget" />
<cfinclude template="../../view/v_status/lang_updateStatusTarget.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitStatusTarget")>
	<cfinclude template="formValidate_updateStatusTarget.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfloop Query="qry_selectStatusTargetList">
			<cfinvoke Component="#Application.billingMapping#data.StatusTarget" Method="updateStatusTarget" ReturnVariable="isStatusTargetUpdated">
				<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
				<cfinvokeargument Name="primaryTargetID" Value="#qry_selectStatusTargetList.primaryTargetID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="statusTargetExportXmlStatus" Value="#Form["statusTargetExportXmlStatus#qry_selectStatusTargetList.primaryTargetID#"]#">
				<cfinvokeargument Name="statusTargetExportXmlName" Value="#Form["statusTargetExportXmlName#qry_selectStatusTargetList.primaryTargetID#"]#">
				<cfinvokeargument Name="statusTargetExportTabStatus" Value="#Form["statusTargetExportTabStatus#qry_selectStatusTargetList.primaryTargetID#"]#">
				<cfinvokeargument Name="statusTargetExportTabName" Value="#Form["statusTargetExportTabName#qry_selectStatusTargetList.primaryTargetID#"]#">
				<cfinvokeargument Name="statusTargetExportHtmlStatus" Value="#Form["statusTargetExportHtmlStatus#qry_selectStatusTargetList.primaryTargetID#"]#">
				<cfinvokeargument Name="statusTargetExportHtmlName" Value="#Form["statusTargetExportHtmlName#qry_selectStatusTargetList.primaryTargetID#"]#">
			</cfinvoke>
		</cfloop>

		<cflocation url="index.cfm?method=status.#Variables.doAction#&confirm_status=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formSubmitValue = Variables.lang_updateStatusTarget.formSubmitValue>
<cfset Variables.formAction = "index.cfm?method=status.#Variables.doAction#">

<cfinclude template="../../view/v_status/form_updateStatusTarget.cfm">
