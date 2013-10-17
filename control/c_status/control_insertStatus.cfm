<cfparam Name="URL.primaryKeyID" Default="0">

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.Status" method="maxlength_Status" returnVariable="maxlength_Status" />
<cfinclude template="formParam_insertUpdateStatus.cfm">
<cfinclude template="../../view/v_status/lang_insertUpdateStatus.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitStatus")>
	<cfinclude template="formValidate_insertUpdateStatus.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- determine order and whether to increment/decrement existing orders --->
		<cfset Variables.incrementStatusOrder = False>
		<cfif qry_selectStatusList.RecordCount is 0>
			<cfset Variables.statusOrder = 1>
		<cfelseif Form.statusOrder is 0>
			<cfset Variables.statusOrder = qry_selectStatusList.RecordCount + 1>
		<cfelse>
			<cfset Variables.incrementStatusOrder = True>
			<cfset Variables.statusOrder = Form.statusOrder>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Status" Method="insertStatus" ReturnVariable="isStatusInserted">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
			<cfinvokeargument Name="statusName" Value="#Form.statusName#">
			<cfinvokeargument Name="statusTitle" Value="#Form.statusTitle#">
			<cfinvokeargument Name="statusDisplayToCustomer" Value="#Form.statusDisplayToCustomer#">
			<cfinvokeargument Name="statusDescription" Value="#Form.statusDescription#">
			<cfinvokeargument Name="statusOrder" Value="#Variables.statusOrder#">
			<cfinvokeargument Name="incrementStatusOrder" Value="#Variables.incrementStatusOrder#">
			<cfinvokeargument Name="statusStatus" Value="#Form.statusStatus#">
			<cfinvokeargument Name="statusID_custom" Value="#Form.statusID_custom#">
		</cfinvoke>

		<cfif Not ListFind(ValueList(qry_selectStatusTargetList.primaryTargetID), URL.primaryTargetID)>
			<cfinvoke Component="#Application.billingMapping#data.StatusTarget" Method="insertStatusTarget" ReturnVariable="isStatusTargetInserted">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="primaryTargetID" Value="#URL.primaryTargetID#">
				<cfinvokeargument Name="statusTargetExportXmlStatus" Value="1">
				<cfinvokeargument Name="statusTargetExportXmlName" Value="customStatus">
				<cfinvokeargument Name="statusTargetExportTabStatus" Value="1">
				<cfinvokeargument Name="statusTargetExportTabName" Value="Custom Status">
				<cfinvokeargument Name="statusTargetExportHtmlStatus" Value="0">
				<cfinvokeargument Name="statusTargetExportHtmlName" Value="">
			</cfinvoke>
		</cfif>

		<cflocation url="index.cfm?method=status.#Variables.doAction#&primaryTargetID=#URL.primaryTargetID#&confirm_status=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=status.#Variables.doAction#&primaryTargetID=#URL.primaryTargetID#">
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateStatus.formSubmitValue_insert>

<cfinclude template="../../view/v_status/form_insertUpdateStatus.cfm">
