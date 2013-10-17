<cfcomponent displayName="ListTasks">

<cffunction name="listTasks" access="public" output="yes" returnType="boolean" hint="Displays list of tasks/events">
	<cfargument name="formAction" Type="string" Required="yes">
	<cfargument name="doControl" Type="string" Required="yes">
	<!--- <cfargument name="userID_agent" Type="numeric" Required="no"> --->
	<cfargument name="companyID_target" Type="numeric" Required="no" default="0">
	<cfargument name="userID_target" Type="numeric" Required="no" default="0">
	<cfargument name="primaryTargetKey" Type="string" Required="no" default="taskID">
	<cfargument name="targetID" Type="numeric" Required="no" default="0">

	<cfset var returnValue = True>
	<cfset var methodStruct = StructNew()>
	<cfset var listTasksStruct = StructNew()>
	<cfset var errorMessage_fields = StructNew()>
	<cfset var lang_listTasks = StructNew()>
	<cfset var lang_listTasks_title = StructNew()>
	<cfset var listTasksViewStruct = StructNew()>
	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>

	<cfinclude Template="../../include/function/fn_datetime.cfm">

	<cfinclude Template="formParam_listTasks.cfm">

	<cfset methodStruct.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewUser,updateTask,viewInvoice,updateTaskFromList,listTasksForOthers,updateTaskForOthers")>

	<cfif ListFind(methodStruct.permissionActionList, "listTasksForOthers")>
		<cfinvoke Component="#Application.billingMapping#data.UserCompany" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userStatus" Value="1">
		</cfinvoke>
	</cfif>

	<cfset methodStruct.formName = "listTasks">
	<cfinvoke component="#Application.billingMapping#include.function.ListObjectsJS" method="listObjectsJS" returnVariable="isObjectsListed">
		<cfinvokeargument name="formName" value="#methodStruct.formName#">
	</cfinvoke>

	<cfinclude Template="../../view/v_task/form_listTasks.cfm">

	<cfinclude Template="../../view/v_task/lang_listTasks.cfm">
	<cfinclude Template="formValidate_listTasks.cfm">

	<cfif methodStruct.isAllFormFieldsOk is False>
		<cfinvoke component="#Application.billingMapping#include.function.ErrorFormValidation" method="errorFormValidation" returnVariable="isErrorDisplay">
			<cfinvokeargument name="errorMessage_fields" value="#errorMessage_fields#">
		</cfinvoke>
	<cfelse>
		<cfset methodStruct.queryViewAction = "#Arguments.formAction#&queryDisplayPerPage=#Form.queryDisplayPerPage#">

		<cfif Form.taskDateType is not "" and (IsDate(Form.taskDateFrom) or IsDate(Form.taskDateTo))>
			<cfloop Index="field" List="taskDateCreated,taskDateUpdated,taskDateScheduled">
				<cfif ListFind(field, Form.taskDateType)>
					<cfif IsDate(Form.taskDateFrom)>
						<cfset temp = SetVariable("Form.#field#_from", Form.taskDateFrom)>
					</cfif>
					<cfif IsDate(Form.taskDateTo)>
						<cfset temp = SetVariable("Form.#field#_to", Form.taskDateTo)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<!--- create structure for filtering criteria --->
		<cfset listTasksStruct.companyID_agent = Session.companyID>

		<cfif Not IsDefined("Form.taskAll") or Form.taskAll is not 1>
			<cfif IsDefined("Form.taskAllForThisCompany") and Form.taskAllForThisCompany is 1>
				<cfset listTasksStruct.companyID_target = Arguments.companyID_target>
			<cfelseif IsDefined("Form.taskAllForThisUser") and Form.taskAllForThisUser is 1>
				<cfset listTasksStruct.userID_target = Arguments.userID_target>
			<cfelse>
				<cfif primaryTargetID is not 0>
					<cfset listTasksStruct.primaryTargetID = primaryTargetID>
				</cfif>
				<cfif Arguments.targetID is not 0>
					<cfset listTasksStruct.targetID = Arguments.targetID>
				</cfif>
			</cfif>
		</cfif>
		<cfloop Index="field" List="taskStatus">
			<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
				<cfset listTasksStruct[field] = Form[field]>
				<cfset methodStruct.queryViewAction &= "&#field#=#Form[field]#">
			</cfif>
		</cfloop>
		<cfloop Index="field" List="taskID,userID_author,userID_agent,companyID_agent,userID_target,companyID_target">
			<cfif IsDefined("Form.#field#") and Form[field] is not 0 and Trim(Form[field]) is not "">
				<cfset listTasksStruct[field] = Form[field]>
				<cfset methodStruct.queryViewAction &= "&#field#=#Form[field]#">
			</cfif>
		</cfloop>
		<cfif Form.userID_agent is 0>
			<cfset listTasksStruct.userID_agentIsNull = True>
			<cfset methodStruct.queryViewAction &= "&userID_agent=#Form.userID_agent#">
		</cfif>
		<cfif IsDefined("Form.taskMessage") and Trim(Form.taskMessage) is not "">
			<cfset listTasksStruct.taskMessage = Form.taskMessage>
			<cfset methodStruct.queryViewAction &= "&taskMessage=#URLEncodedFormat(Form.taskMessage)#">
		</cfif>
		<cfloop index="field" list="taskCompleted">
			<cfif Application.fn_IsIntegerList(Form[field])>
				<cfset listTasksStruct[field] = Form[field]>
				<cfset methodStruct.queryViewAction &= "&#field#=#Form[field]#">
			</cfif>
		</cfloop>
		<cfloop Index="field" List="taskDateScheduled_from,taskDateScheduled_to,taskDateCreated_from,taskDateCreated_to,taskDateUpdated_from,taskDateUpdated_to">
			<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
				<cfset listTasksStruct[field] = Form[field]>
				<cfset methodStruct.queryViewAction &= "&#field#=#Form[field]#">
			</cfif>
		</cfloop>

		<cfinvoke Component="#Application.billingMapping#data.Task" Method="selectTaskList" ReturnVariable="qry_selectTaskList" argumentCollection="#listTasksStruct#">
			<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
			<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
			<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Task" Method="selectTaskCount" ReturnVariable="qryTotalRecords" argumentCollection="#listTasksStruct#" />

		<cfset methodStruct.queryViewAction_orderBy = methodStruct.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
		<cfset methodStruct.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
		<cfset methodStruct.totalRecords = qryTotalRecords>
		<cfset methodStruct.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, methodStruct.totalRecords)>
		<cfif (methodStruct.totalRecords mod Form.queryDisplayPerPage) is 0>
			<cfset methodStruct.totalPages = methodStruct.totalRecords \ Form.queryDisplayPerPage>
		<cfelse>
			<cfset methodStruct.totalPages = (methodStruct.totalRecords \ Form.queryDisplayPerPage) + 1>
		</cfif>

		<cfset listTasksViewStruct.isDisplayTarget = False>
		<cfset listTasksViewStruct.isDisplayAgent = False>
		<cfset listTasksViewStruct.isDisplayAuthor = False>

		<cfloop query="qry_selectTaskList">
			<cfif listTasksViewStruct.isDisplayAgent is False and CurrentRow gt 1 and qry_selectTaskList.userID_agent is not qry_selectTaskList.userID_agent[CurrentRow - 1]>
				<cfset listTasksViewStruct.isDisplayAgent = True>
			</cfif>
			<cfif listTasksViewStruct.isDisplayTarget is False and (qry_selectTaskList.userID_target is not 0 or (qry_selectTaskList.companyID_target is not 0 and qry_selectTaskList.targetCompanyName is not ""))
					and (RecordCount is 1 or (CurrentRow gt 1 and qry_selectTaskList.userID_target is not qry_selectTaskList.userID_target[CurrentRow - 1]))>
				<cfset listTasksViewStruct.isDisplayTarget = True>
			</cfif>
			<cfif listTasksViewStruct.isDisplayAuthor is False and (Session.userID is not qry_selectTaskList.userID_agent or Session.userID is not qry_selectTaskList.userID_author or qry_selectTaskList.userID_agent is not qry_selectTaskList.userID_author or (CurrentRow gt 1 and qry_selectTaskList.userID_author is not qry_selectTaskList.userID_author[CurrentRow - 1]))>
				<cfset listTasksViewStruct.isDisplayAuthor = True>
			</cfif>
		</cfloop>

		<cfif Arguments.primaryTargetKey is "invoiceID" and Arguments.doControl is not "invoice" and ListFind(methodStruct.permissionActionList, "viewInvoice")>
			<cfset listTasksViewStruct.isDisplayInvoice = True>
		<cfelse>
			<cfset listTasksViewStruct.isDisplayInvoice = False>
		</cfif>

		<cfif Find("Task", Arguments.formAction) and (ListFind(methodStruct.permissionActionList, "updateTaskForOthers") or listTasksViewStruct.isDisplayAgent is False)>
			<cfset listTasksViewStruct.isUpdateTaskForm = True>
			<cfif IsDefined("Form.submitUpdateTaskFromList") and IsDefined("Form.taskID_update") and Application.fn_IsIntegerList(Form.taskID_update)>
				<cfinclude template="act_updateTasksFromList.cfm">
			</cfif>
		<cfelse>
			<cfset listTasksViewStruct.isUpdateTaskForm = False>
		</cfif>

		<cfset methodStruct.columnHeaderList = lang_listTasks_title.taskMessage>
		<cfset methodStruct.columnOrderByList = "False">

		<cfset methodStruct.columnHeaderList &= "^" & lang_listTasks_title.taskDateScheduled>
		<cfset methodStruct.columnOrderByList &= "^taskDateScheduled">

		<cfif listTasksViewStruct.isDisplayAgent is True>
			<cfset methodStruct.columnHeaderList &= "^" & lang_listTasks_title.agentLastName>
			<cfset methodStruct.columnOrderByList &= "^agentLastName">
		</cfif>
		<cfif listTasksViewStruct.isDisplayTarget is True>
			<cfset methodStruct.columnHeaderList &= "^" & lang_listTasks_title.targetCompanyName>
			<cfset methodStruct.columnOrderByList &= "^targetCompanyName">
		</cfif>
		<cfif listTasksViewStruct.isDisplayAuthor is True>
			<cfset methodStruct.columnHeaderList &= "^" & lang_listTasks_title.authorLastName>
			<cfset methodStruct.columnOrderByList &= "^authorLastName">
		</cfif>
		<cfset methodStruct.columnHeaderList &= "^" & lang_listTasks_title.taskCompleted>
		<cfset methodStruct.columnOrderByList &= "^taskCompleted">

		<cfset methodStruct.columnHeaderList &= "^" & lang_listTasks_title.taskDateCreated>
		<cfset methodStruct.columnOrderByList &= "^taskDateCreated">

		<cfif listTasksViewStruct.isDisplayInvoice is True>
			<cfset methodStruct.columnHeaderList &= "^" & lang_listTasks_title.updateTask>
			<cfset methodStruct.columnOrderByList &= "^False">
		</cfif>

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfset methodStruct.columnCount = DecrementValue(2 * ListLen(methodStruct.columnHeaderList, "^"))>

		<cfset methodStruct.viewTaskAction = Replace(Arguments.formAction, ".#URL.action#", ".viewTask", "one")>
		<cfset methodStruct.updateTaskFromListAction = Replace(methodStruct.viewTaskAction, "viewTask", "updateTaskFromList", "one")>
		<cfset methodStruct.updateTaskAction = Replace(methodStruct.viewTaskAction, "viewTask", "updateTask", "one")>
		<cfset methodStruct.redirectURL = URLEncodedFormat(methodStruct.queryViewAction & "&queryOrderBy=" & Form.queryOrderBy)>

		<cfif Not ListFind(methodStruct.permissionActionList, "updateTask")>
			<cfset methodStruct.thisTaskAction = methodStruct.viewTaskAction>
		<cfelse>
			<cfset methodStruct.thisTaskAction = methodStruct.updateTaskAction>
		</cfif>

		<cfinclude Template="../../view/v_task/dsp_listTasks.cfm">
	</cfif>

	<cfreturn returnValue>
</cffunction>

<cffunction name="listIncompleteTasks" access="public" output="yes" returnVariable="numeric">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID" type="numeric" required="yes">

	<cfset var taskStruct = StructNew()>
	<cfset var isUpdateTask = Application.fn_IsUserAuthorized("updateTask")>

	<cfinvoke component="#Application.billingMapping#data.Task" method="selectTaskList" returnVariable="qry_selectTaskList">
		<cfinvokeargument Name="companyID_agent" Value="#Session.companyID_author#">
		<cfinvokeargument Name="primaryTargetID" value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
		<cfinvokeargument Name="targetID" value="#Arguments.targetID#">
		<cfinvokeargument Name="taskStatus" Value="1">
		<cfinvokeargument Name="taskCompleted" Value="0">
		<cfinvokeargument Name="queryOrderBy" value="taskDateScheduled">
		<cfinvokeargument Name="queryDisplayPerPage" Value="0">
		<cfinvokeargument Name="queryPage" Value="1">
	</cfinvoke>

	<cfinclude template="../../view/v_task/dsp_listIncompleteTasks.cfm">

	<cfreturn qry_selectTaskList.RecordCount>
</cffunction>

</cfcomponent>