<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="selectPayflowList" ReturnVariable="qry_selectPayflowList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="selectPayflowTarget" ReturnVariable="qry_selectPayflowTarget">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
</cfinvoke>

<cfif URL.control is "company">
	<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="selectPayflowForCompany" ReturnVariable="qry_selectPayflowForCompany">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	</cfinvoke>
</cfif>

<cfinclude template="formParam_insertPayflowTarget.cfm">
<cfinclude template="../../view/v_payflow/lang_insertPayflowTarget.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPayflowTarget")>
	<cfinclude template="formValidate_insertPayflowTarget.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfloop Query="qry_selectPayflowList">
			<cfset Variables.payflowTargetRow = ListFind(ValueList(qry_selectPayflowTarget.payflowID), qry_selectPayflowList.payflowID)>
			<!--- if previously checked, but not checked now, update status to inactive --->
			<cfif Not ListFind(Form.payflowID, qry_selectPayflowList.payflowID)>
				<cfif Variables.payflowTargetRow is not 0 and qry_selectPayflowTarget.payflowTargetStatus[Variables.payflowTargetRow] is 1>
					<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="updatePayflowTarget" ReturnVariable="isPayflowTargetUpdated">
						<cfinvokeargument Name="payflowTargetID" Value="#qry_selectPayflowTarget.payflowTargetID[Variables.payflowTargetRow]#">
						<cfinvokeargument Name="payflowTargetStatus" Value="0">
					</cfinvoke>
				</cfif>
			<!--- existing checked payflow: Update status, begin/end dates --->
			<cfelseif Variables.payflowTargetRow is not 0>
				<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="updatePayflowTarget" ReturnVariable="isPayflowTargetUpdated">
					<cfinvokeargument Name="payflowTargetID" Value="#qry_selectPayflowTarget.payflowTargetID[Variables.payflowTargetRow]#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="payflowTargetStatus" Value="1">
					<cfinvokeargument Name="payflowTargetDateBegin" Value="#Form["payflowTargetDateBegin#qry_selectPayflowList.payflowID#_date"]#">
					<cfinvokeargument Name="payflowTargetDateEnd" Value="#Form["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"]#">
				</cfinvoke>
			<!--- newly checked payflow: Insert --->
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.PayflowTarget" Method="insertPayflowTarget" ReturnVariable="isPayflowTargetInserted">
					<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
					<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="payflowID" Value="#qry_selectPayflowList.payflowID#">
					<cfinvokeargument Name="payflowTargetStatus" Value="1">
					<cfinvokeargument Name="payflowTargetDateBegin" Value="#Form["payflowTargetDateBegin#qry_selectPayflowList.payflowID#_date"]#">
					<cfinvokeargument Name="payflowTargetDateEnd" Value="#Form["payflowTargetDateEnd#qry_selectPayflowList.payflowID#_date"]#">
				</cfinvoke>
			</cfif>
		</cfloop>

		<cfif ListFind("affiliateID,cobrandID", Variables.primaryTargetKey) and URL.control is "company">
			<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction#&#Variables.primaryTargetKey#=#Variables.targetID#&companyID=#URL.companyID#&confirm_payflow=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=#URL.control#.#Variables.doAction#&#Variables.primaryTargetKey#=#Variables.targetID#&confirm_payflow=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.columnHeaderList = Variables.lang_insertPayflowTarget_title.payflowOrder & "^" & Variables.lang_insertPayflowTarget_title.payflowName>

<cfif Not REFind("[A-Za-z0-9]", ValueList(qry_selectPayflowList.payflowID_custom))>
	<cfset Variables.displayPayflowID_custom = False>
<cfelse>
	<cfset Variables.displayPayflowID_custom = True>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_insertPayflowTarget_title.payflowID_custom>
</cfif>

<cfset Variables.columnHeaderList = Variables.columnHeaderList
		& "^" & Variables.lang_insertPayflowTarget_title.payflowDefault
		& "^" & Variables.lang_insertPayflowTarget_title.payflowStatus
		& "^" & Variables.lang_insertPayflowTarget_title.payflowID
		& "^" & Variables.lang_insertPayflowTarget_title.payflowDateBegin
		& "^" & Variables.lang_insertPayflowTarget_title.payflowDateEnd>
<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfset Variables.formName = "insertPayflowTarget">
<cfset Variables.formSubmitName = "submitPayflowTarget">

<cfif FindNoCase("view", Variables.doAction)>
	<cfset Variables.formAction = "">
	<cfset Variables.formSubmitValue = "">
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertPayflowTarget.formSubmitValue>
	<cfset Variables.formAction = Variables.formAction & "&" & Variables.primaryTargetKey & "=" & Variables.targetID>
	<cfif ListFind("affiliateID,cobrandID", Variables.primaryTargetKey) and URL.control is "company">
		<cfset Variables.formAction = Variables.formAction & "&companyID=#URL.companyID#">
	</cfif>
</cfif>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_datetime.cfm">

<cfinclude template="../../view/v_payflow/form_insertPayflowTarget.cfm">
