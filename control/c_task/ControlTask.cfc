<cfcomponent displayName="ControlTask" hint="Manages all task requests to make it easy to access all tasks functions from another module">

<!---
URL variables:
taskID
userID
companyID
fileID

Session variables:
userID
companyID

Unused variables:
invoiceID
shippingID
hideNavigation
--->

<cffunction name="controlTask" access="public" output="yes" returnType="string" hint="Manages access to all task functions">
	<cfargument name="doControl" type="string" required="yes">
	<cfargument name="doAction" type="string" required="yes">
	<cfargument name="formAction" type="string" required="no" default="">
	<cfargument name="urlParameters" type="string" required="no" default="">
	<!--- URL <cfargument name="taskID" type="string" required="no" default="0" hint="Must be numeric, but string to avoid validation error"> --->
	<cfargument name="primaryTargetKey" type="string" required="no" default="" hint="Type of object that tasks is for, e.g., invoiceID. Blank means generic.">
	<cfargument name="targetID" type="numeric" required="no" default="0" hint="ID of object that task is for, i.e., the invoiceID value">
	<cfargument name="userID_target" type="string" required="yes" default="0" hint="ID of user that task is for, e.g., the user an invoice is for">
	<cfargument name="companyID_target" type="numeric" required="no" default="0" hint="ID of company that task is for, e.g., the company an invoice is for">
	<cfargument name="userID_agent" type="numeric" required="no" default="#Session.userID#">
	<!--- <cfargument name="companyID" type="numeric" required="no" default="#Session.companyID#"> --->
	<cfargument name="hideSubnavigation" type="boolean" required="no" default="False">
	<!--- URL <cfargument name="fileID" type="string" required="no" default="" hint="Must be numeric, but string to avoid validation error"> --->

	<cfset var returnValue = "">
	<cfset var methodStruct = StructNew()>

	<cfparam name="URL.taskID" default="0">
	<cfif IsDefined("URL.userID_agent") and Application.fn_IsIntegerNonNegative(URL.userID_agent)>
		<cfset Arguments.userID_agent = URL.userID_agent>
	<cfelseif Not Application.fn_IsIntegerNonNegative(Arguments.userID_agent)>
		<cfset Arguments.userID_agent = 0>
	</cfif>

	<cfif Arguments.userID_agent is not 0>
		<cfinvoke component="#Application.billingMapping#data.User" method="selectUser" returnVariable="qry_selectTaskUser">
			<cfinvokeargument name="userID" value="#Arguments.userID_agent#">
		</cfinvoke>
		<cfif qry_selectTaskUser.RecordCount is 0 or qry_selectTaskUser.companyID is not Session.companyID>
			<cfset Arguments.userID_agent = Session.userID>
		</cfif>
	</cfif>

	<cfinclude template="security_task.cfm">

	<cfif IsDefined("URL.confirm_task")>
		<cfinclude template="../../view/v_task/confirm_task.cfm">
	</cfif>
	<cfif IsDefined("URL.error_task")>
		<cfinclude template="../../view/v_task/error_task.cfm">
	</cfif>

	<cfif Arguments.hideSubnavigation is False or Not IsDefined("URL.hideSubnavigation") or URL.hideSubnavigation is not "True">
		<!---
		<cfinvoke component="#Application.billingMapping#data.UserCompany" method="selectUserCompanyList_company" returnVariable="qry_selectUserList">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
		</cfinvoke>
		--->

		<cfinclude template="../../view/v_task/nav_task.cfm">
	</cfif>

	<cfswitch expression="#Arguments.doAction#">
	<cfcase value="listTasks">
		<cfhtmlhead text="<title>Existing Tasks</title>">
		<cfinvoke component="#Application.billingMapping#control.c_task.ListTasks" method="listTasks" returnVariable="isListed">
			<cfinvokeargument name="formAction" value="#Arguments.formAction#">
			<cfinvokeargument name="doControl" value="#Arguments.doControl#">
			<!--- <cfinvokeargument name="userID_agent" value="#Arguments.userID_agent#"> --->
			<cfinvokeargument name="userID_target" value="#Arguments.userID_target#">
			<cfinvokeargument name="companyID_target" value="#Arguments.companyID_target#">
			<cfinvokeargument name="primaryTargetKey" value="#Arguments.primaryTargetKey#">
			<cfinvokeargument name="targetID" value="#Arguments.targetID#">
		</cfinvoke>
	</cfcase>

	<cfcase value="insertTask">
		<cfhtmlhead text="<title>Add New Task</title>">
		<cfinvoke component="#Application.billingMapping#control.c_task.InsertUpdateTask" method="insertTask" returnVariable="taskID_new">
			<cfinvokeargument Name="formAction" value="#Arguments.formAction#">
			<cfinvokeargument name="primaryTargetKey" value="#Arguments.primaryTargetKey#">
			<cfinvokeargument name="targetID" value="#Arguments.targetID#">
			<cfif StructKeyExists(Arguments, "userID_target") and Application.fn_IsIntegerPositive(Arguments.userID_target)>
				<cfinvokeargument Name="userID_target" value="#Arguments.userID_target#">
			</cfif>
			<cfif StructKeyExists(Arguments, "companyID_target") and Application.fn_IsIntegerPositive(Arguments.companyID_target)>
				<cfinvokeargument Name="companyID_target" value="#Arguments.companyID_target#">
			</cfif>
		</cfinvoke>

		<cfif Application.fn_IsIntegerPositive(taskID_new)>
			<cflocation url="#Replace(Arguments.formAction, 'insertTask', 'updateTask', 'all')#&taskID=#taskID_new#&confirm_task=insertTask" addToken="no">
		</cfif>
	</cfcase>

	<cfcase value="updateTask">
		<cfhtmlhead text="<title>Update Task #URL.taskID#</title>">
		<cfinvoke component="#Application.billingMapping#control.c_task.InsertUpdateTask" method="updateTask" returnVariable="isTaskUpdated">
			<cfinvokeargument Name="formAction" value="#Arguments.formAction#">
			<cfinvokeargument Name="taskID" value="#URL.taskID#">
		</cfinvoke>

		<cfif isTaskUpdated is True>
			<cflocation url="#Arguments.formAction#&taskID=#URL.taskID#&confirm_task=#Arguments.doAction#" addToken="no">
		</cfif>
	</cfcase>

	<cfcase value="viewTask">
		<cfhtmlhead text="<title>View Task #URL.taskID#</title>">
		<cfinvoke component="#Application.billingMapping#control.c_task.ViewTask" method="viewTask" returnVariable="isViewed">
			<cfinvokeargument Name="taskID" value="#URL.taskID#">
			<cfinvokeargument Name="formAction" value="#Arguments.formAction#">
		</cfinvoke>
	</cfcase>

	<cfdefaultcase>
		<cfset URL.error_task = "invalidAction">
		<cfinclude template="../../view/v_task/error_task.cfm">
	</cfdefaultcase>
	</cfswitch>

	<cfreturn returnValue>
</cffunction>

</cfcomponent>
