<cfcomponent displayName="ViewTask">

<cffunction name="viewTask" access="public" output="yes" returnType="boolean">
	<cfargument Name="taskID" Type="numeric" Required="yes">
	<cfargument Name="formAction" Type="string" Required="no" default="">

	<cfset var taskStruct = StructNew()>

	<cfif Not Application.fn_IsIntegerPositive(Arguments.taskID)>
		<cfreturn False>
	<cfelse>
		<cfinvoke component="#Application.billingMapping#data.Task" method="selectTask" returnVariable="qry_selectTask">
			<cfinvokeargument name="taskID" value="#Arguments.taskID#">
		</cfinvoke>

		<cfif qry_selectTask.RecordCount is 0>
			<cfreturn False>
		</cfif>
	</cfif>

	<cfset taskStruct.formAction = Arguments.formAction>
	<cfif Not FindNoCase("&taskID=#Arguments.taskID#", Arguments.formAction)>
		<cfset taskStruct.formAction &= "&taskID=#Arguments.taskID#">
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.User" method="selectUser" returnVariable="qry_selectUserList">
		<cfinvokeargument name="userID" value="#qry_selectTask.userID_author#,#qry_selectTask.userID_agent#,#qry_selectTask.userID_target#">
	</cfinvoke>

	<cfset taskStruct.targetType = "">
	<cfloop query="qry_selectUserList">
		<cfif qry_selectUserList.userID is qry_selectTask.userID_author>
			<cfset taskStruct.authorRow = CurrentRow>
		</cfif>
		<cfif qry_selectUserList.userID is qry_selectTask.userID_agent>
			<cfset taskStruct.agentRow = CurrentRow>
		</cfif>
		<cfif qry_selectUserList.userID is qry_selectTask.userID_target>
			<cfset taskStruct.targetRow = CurrentRow>
		</cfif>
	</cfloop>

	<cfif qry_selectTask.companyID_target is not 0>
		<cfinvoke component="#Application.billingMapping#data.Company" method="selectCompany" returnVariable="qry_selectCompany">
			<cfinvokeargument name="companyID" value="#qry_selectTask.companyID_target#">
		</cfinvoke>
	</cfif>

	<cfif qry_selectTask.userID_author is Session.userID or qry_selectTask.userID_agent is Session.userID or Application.fn_IsUserAuthorized("insertTaskForOthers")>
		<cfset taskStruct.isUpdateTaskPermission = True>
	<cfelse>
		<cfset taskStruct.isUpdateTaskPermission = False>
	</cfif>

	<cfinclude template="../../view/v_task/dsp_viewTask.cfm">

	<cfreturn True>
</cffunction>

</cfcomponent>