<cfif Variables.doAction is not "insertPayflowNotify">
	<cfinvoke Component="#Application.billingMapping#data.PayflowNotify" Method="selectPayflowNotifyList" ReturnVariable="qry_selectPayflowNotifyList">
		<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
		<!--- <cfinvokeargument Name="payflowNotifyStatus" Value="1"> --->
	</cfinvoke>

	<cfset Variables.payflowUserID_list = "">
	<cfloop Query="qry_selectPayflowNotifyList">
		<cfif qry_selectPayflowNotifyList.payflowNotifyStatus is 1 and Not ListFind(Variables.payflowUserID_list, qry_selectPayflowNotifyList.userID)>
			<cfset Variables.payflowUserID_list = ListAppend(Variables.payflowUserID_list, qry_selectPayflowNotifyList.userID)>
		</cfif>
	</cfloop>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserList">
	<cfinvokeargument Name="userID" Value="#Variables.payflowUserID_list#">
</cfinvoke>

<cfinclude template="../../view/v_payflow/var_payflowTemplateTypeList.cfm">
<cfinclude template="formParam_insertUpdatePayflowNotify.cfm">
<cfinclude template="../../view/v_payflow/lang_insertUpdatePayflowNotify.cfm">

<cfif Variables.doAction is not "viewPayflowNotify" and IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitUpdatePayflowNotify")>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfinclude template="formValidate_insertUpdatePayflowNotify.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif ListLen(Variables.payflowUserID_list) is not 0>
			<cfinvoke Component="#Application.billingMapping#data.PayflowNotify" Method="deletePayflowNotify" ReturnVariable="isPayflowNotifyDeleted">
				<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
				<cfinvokeargument Name="userID" Value="#Variables.payflowUserID_list#">
			</cfinvoke>
		</cfif>

		<cfloop Query="qry_selectUserList">
			<cfset Variables.thisUserID = qry_selectUserList.userID>
			<cfloop Index="type" List="#Variables.payflowTemplateTypeList_value#">
				<cfif Form["payflowNotifyEmail#Variables.thisUserID#_#type#"] is 1 or Form["payflowNotifyTask#Variables.thisUserID#_#type#"] is 1>
					<cfinvoke Component="#Application.billingMapping#data.PayflowNotify" Method="insertPayflowNotify" ReturnVariable="isPayflowNotifyInserted">
						<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
						<cfinvokeargument Name="userID" Value="#qry_selectUserList.userID#">
						<cfinvokeargument Name="payflowNotifyStatus" Value="1">
						<cfinvokeargument Name="payflowNotifyType" Value="#type#">
						<cfinvokeargument Name="payflowNotifyEmail" Value="#Form["payflowNotifyEmail#Variables.thisUserID#_#type#"]#">
						<cfinvokeargument Name="payflowNotifyTask" Value="#Form["payflowNotifyTask#Variables.thisUserID#_#type#"]#">
					</cfinvoke>
				</cfif>
			</cfloop>
		</cfloop>

		<cflocation url="#Variables.formAction#&confirm_payflow=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="insertPayflowNotify"><cfset Variables.formSubmitValue = Variables.lang_insertUpdatePayflowNotify.formSubmitValue_insert></cfcase>
<cfcase value="updatePayflowNotify"><cfset Variables.formSubmitValue = Variables.lang_insertUpdatePayflowNotify.formSubmitValue_update></cfcase>
<cfcase value="viewPayflowNotify"><cfset Variables.formAction = ""></cfcase>
</cfswitch>

<cfset Variables.columnHeaderList = "User">
<cfloop Index="type" List="#Variables.payflowTemplateTypeList_label#">
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Replace(type, " - ", ":<br>", "ONE")>
</cfloop>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfinclude template="../../view/v_payflow/form_insertUpdatePayflowNotify.cfm">
