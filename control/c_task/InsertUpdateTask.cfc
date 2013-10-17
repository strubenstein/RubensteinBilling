<cfcomponent displayName="InsertUpdateTask">

<cffunction name="insertTask" access="public" output="yes" returnType="numeric">
	<cfargument Name="formAction" Type="string" Required="yes">
	<cfargument name="primaryTargetKey" type="string" required="no" default="">
	<cfargument name="targetID" type="numeric" required="no" default="0">
	<cfargument Name="userID_target" Type="numeric" Required="no" default="0">
	<cfargument Name="companyID_target" Type="numeric" Required="no" default="0">
	<cfargument Name="formNameSuffix" type="string" required="no" default="">

	<cfset var returnValue = 0>
	<cfset var taskStruct = StructNew()>
	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfset var lang_insertUpdateTask = StructNew()>
	<cfset var lang_insertUpdateTask_title = StructNew()>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var wsSessionUserID = Session.userID>

	<cfset taskStruct.isUpdateTaskPermission = True>
	<cfset taskStruct.doAction = "insertTask">
	<cfset taskStruct.formAction = Arguments.formAction>

	<cfif Not Application.fn_IsUserAuthorized("insertTaskForOthers")>
		<cfset taskStruct.insertUpdateTaskForOthers = False>
	<cfelse>
		<cfset taskStruct.insertUpdateTaskForOthers = True>
		<cfinvoke Component="#Application.billingMapping#data.UserCompany" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserList">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userStatus" Value="1">
		</cfinvoke>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Task" Method="maxlength_Task" ReturnVariable="maxlength_Task" />

	<cfif Not IsDefined("fn_FormSelectDateTime")>
		<cfinclude Template="../../include/function/fn_datetime.cfm">
	</cfif>

	<cfinclude template="formParam_insertUpdateTask.cfm">
	<cfinclude template="../../view/v_task/lang_insertUpdateTask.cfm">

	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitTask")>
		<cfinclude template="formValidate_insertUpdateTask.cfm">
		<cfif taskStruct.isAllFormFieldsOk is False>
			<cfinvoke component="#Application.billingMapping#include.function.ErrorFormValidation" method="errorFormValidation" returnVariable="isErrorDisplay">
				<cfinvokeargument name="errorMessage_fields" value="#errorMessage_fields#">
			</cfinvoke>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Task" Method="insertTask" ReturnVariable="taskID_new">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
				<cfinvokeargument Name="companyID_agent" Value="#Session.companyID#">
				<cfinvokeargument Name="userID_target" Value="#Arguments.userID_target#">
				<cfinvokeargument Name="companyID_target" Value="#Arguments.companyID_target#">
				<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
				<cfinvokeargument Name="taskMessage" Value="#Form.taskMessage#">
				<cfinvokeargument Name="taskStatus" Value="#Form.taskStatus#">
				<cfinvokeargument Name="taskCompleted" Value="#Form.taskCompleted#">
				<cfinvokeargument Name="taskDateScheduled" Value="#taskStruct.taskDateScheduled#">
				<cfinvokeargument Name="userID_agent" Value="#ListFirst(Form.userID_agent)#">
			</cfinvoke>

			<cfset returnValue = taskID_new>
		</cfif><!--- /form is valid --->
	</cfif><!--- /form is submitted --->

	<cfif returnValue is 0>
		<cfset taskStruct.formName = "insertUpdateTask" & Arguments.formNameSuffix>
		<cfset taskStruct.formSubmitValue = lang_insertUpdateTask.formSubmitValue_insert>

		<cfinclude Template="../../view/v_task/form_insertUpdateTask.cfm">
	</cfif>

	<cfreturn returnValue>
</cffunction>

<cffunction name="updateTask" access="public" output="yes" returnType="boolean">
	<cfargument Name="formAction" Type="string" Required="yes">
	<cfargument name="taskID" type="numeric" required="Yes">
	<cfargument Name="formNameSuffix" type="string" required="no" default="">

	<cfset var returnValue = False>
	<cfset var taskStruct = StructNew()>
	<cfset var primaryTargetID = 0>
	<cfset var lang_insertUpdateTask = StructNew()>
	<cfset var lang_insertUpdateTask_title = StructNew()>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var wsSessionUserID = Session.userID>

	<cfset taskStruct.isUpdateTaskPermission = True>

	<cfif Not Application.fn_IsIntegerPositive(Arguments.taskID)>
		<cfreturn False>
	<cfelse>
		<cfinvoke component="#Application.billingMapping#data.Task" method="selectTask" returnVariable="qry_selectTask">
			<cfinvokeargument name="taskID" value="#Arguments.taskID#">
		</cfinvoke>

		<cfif qry_selectTask.RecordCount is 0>
			<cfreturn False>
		<cfelse>
			<cfif qry_selectTask.userID_author is not Session.userID and qry_selectTask.userID_agent is not Session.userID
					and Not Application.fn_IsUserAuthorized("insertTaskForOthers")>
				<cfreturn False>
			<!-- user cannot update the core task information, only the completion data --->
			<cfelseif qry_selectTask.userID_author is not Session.userID and Not Application.fn_IsUserAuthorized("insertTaskForOthers")>
				<cfset taskStruct.isUpdateTaskPermission = False>
			</cfif>
		</cfif><!--- /taskID exists --->
	</cfif><!--- /taskID is positive integer --->

	<cfset taskStruct.doAction = "updateTask">
	<cfset taskStruct.formAction = Arguments.formAction>
	<cfif Not FindNoCase("&taskID=#Arguments.taskID#", Arguments.formAction)>
		<cfset taskStruct.formAction &= "&taskID=#Arguments.taskID#">
	</cfif>

	<cfif Not Application.fn_IsUserAuthorized("insertTaskForOthers")>
		<cfset taskStruct.insertUpdateTaskForOthers = False>
	<cfelse>
		<cfset taskStruct.insertUpdateTaskForOthers = True>
		<cfinvoke Component="#Application.billingMapping#data.UserCompany" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserList">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userStatus" Value="1">
		</cfinvoke>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.Task" Method="maxlength_Task" ReturnVariable="maxlength_Task" />

	<cfif Not IsDefined("fn_FormSelectDateTime")>
		<cfinclude Template="../../include/function/fn_datetime.cfm">
	</cfif>

	<cfinclude template="formParam_insertUpdateTask.cfm">
	<cfinclude template="../../view/v_task/lang_insertUpdateTask.cfm">

	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitTask")>
		<cfinclude template="formValidate_insertUpdateTask.cfm">
		<cfif taskStruct.isAllFormFieldsOk is False>
			<cfinvoke component="#Application.billingMapping#include.function.ErrorFormValidation" method="errorFormValidation" returnVariable="isErrorDisplay">
				<cfinvokeargument name="errorMessage_fields" value="#errorMessage_fields#">
			</cfinvoke>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Task" Method="updateTask" ReturnVariable="isTaskUpdated">
				<cfinvokeargument Name="taskID" Value="#Arguments.taskID#">
				<cfif taskStruct.isUpdateTaskPermission is True>
					<cfinvokeargument Name="taskMessage" Value="#Form.taskMessage#">
					<cfinvokeargument Name="taskStatus" Value="#Form.taskStatus#">
					<cfinvokeargument Name="taskDateScheduled" Value="#taskStruct.taskDateScheduled#">
					<cfinvokeargument Name="userID_agent" Value="#ListFirst(Form.userID_agent)#">
				</cfif>
				<cfinvokeargument Name="taskCompleted" Value="#Form.taskCompleted#">
			</cfinvoke>

			<cfset returnValue = True>
		</cfif><!--- /form is valid --->
	</cfif><!--- /form is submitted --->

	<cfif returnValue is False>
		<cfset taskStruct.formName = "insertUpdateTask" & Arguments.formNameSuffix>

		<cfset taskStruct.formSubmitValue = lang_insertUpdateTask.formSubmitValue_update>

		<cfinclude Template="../../view/v_task/form_insertUpdateTask.cfm">
	</cfif>

	<cfreturn returnValue>
</cffunction>

</cfcomponent>