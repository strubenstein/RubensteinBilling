<cfcomponent displayName="UserActivityReport" hint="Generates a summary report of user activity">

<cffunction name="viewUserActivityReport" access="public" output="yes" returnType="boolean" hint="Displays user acitivity report based on date range or logion session">
	<cfargument name="userID" type="numeric" required="yes">
	<cfargument name="formAction" type="string" required="no" default="">
	<cfargument name="loginSessionID" type="numeric" required="no">
	<cfargument name="userActivityDateBegin" type="string" required="no">
	<cfargument name="userActivityDateEnd" type="string" required="no">

	<cfset var returnValue = False>
	<cfset var activityStruct = StructNew()>

	<cfset activityStruct.isLoginSession = False>

	<cfif Application.fn_IsIntegerPositive(Arguments.userID)>
		<cfinvoke component="#Application.billingMapping#data.User" method="selectUser" returnVariable="qry_selectUser">
			<cfinvokeargument name="userID" value="#Arguments.userID#">
		</cfinvoke>

		<cfif qry_selectUser.RecordCount is 1 and qry_selectUser.companyID_author is Session.companyID_author>
			<cfif StructKeyExists(Arguments, "loginSessionID") and Application.fn_IsIntegerPositive(Arguments.loginSessionID)>
				<cfinvoke component="#Application.billingMapping#data.LoginSession" method="selectLoginSession" returnVariable="qry_selectLoginSession">
					<cfinvokeargument name="loginSessionID" value="#Arguments.loginSessionID#">
				</cfinvoke>

				<cfif qry_selectLoginSession.RecordCount is 1 and qry_selectLoginSession.userID is Arguments.userID>
					<cfset activityStruct.isLoginSession = True>
				</cfif>
			</cfif>

			<cfset activityStruct.dateBegin = "">
			<cfset activityStruct.dateEnd = "">

			<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.userActivityDateBegin") and (Form.userActivityDateBegin is "" or IsDate(Form.userActivityDateBegin))>
				<cfif IsDate(Form.userActivityDateBegin)>
					<cfset activityStruct.dateBegin = CreateDateTime(Year(Form.userActivityDateBegin), Month(Form.userActivityDateBegin), Day(Form.userActivityDateBegin), 00, 00, 00)>
				</cfif>
			<cfelseif IsDefined("URL.userActivityDateBegin") and (URL.userActivityDateBegin is "" or IsDate(URL.userActivityDateBegin))>
				<cfif IsDate(URL.userActivityDateBegin)>
					<cfset activityStruct.dateBegin = CreateDateTime(Year(URL.userActivityDateBegin), Month(URL.userActivityDateBegin), Day(URL.userActivityDateBegin), 00, 00, 00)>
				</cfif>
			<cfelseif StructKeyExists(Arguments, "userActivityDateBegin") and IsDate(Arguments.userActivityDateBegin)>
				<cfset activityStruct.dateBegin = Arguments.userActivityDateBegin>
			<cfelseif activityStruct.isLoginSession is True>
				<cfset activityStruct.dateBegin = qry_selectLoginSession.loginSessionDateBegin>
			<!---
			<cfelse>
				<cfset activityStruct.dateBegin = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 00, 00)>
			--->
			</cfif>

			<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.userActivityDateEnd") and (Form.userActivityDateEnd is "" or IsDate(Form.userActivityDateEnd))>
				<cfif IsDate(Form.userActivityDateEnd)>
					<cfset activityStruct.dateEnd = CreateDateTime(Year(Form.userActivityDateEnd), Month(Form.userActivityDateEnd), Day(Form.userActivityDateEnd), 23, 59, 59)>
				</cfif>
			<cfelseif IsDefined("URL.userActivityDateEnd") and (URL.userActivityDateEnd is "" or IsDate(URL.userActivityDateEnd))>
				<cfif IsDate(URL.userActivityDateEnd)>
					<cfset activityStruct.dateEnd = CreateDateTime(Year(URL.userActivityDateEnd), Month(URL.userActivityDateEnd), Day(URL.userActivityDateEnd), 23, 59, 59)>
				</cfif>
			<cfelseif StructKeyExists(Arguments, "userActivityDateEnd") and IsDate(Arguments.userActivityDateEnd)>
				<cfset activityStruct.dateEnd = Arguments.userActivityDateEnd>
			<cfelseif activityStruct.isLoginSession is True and IsDate(qry_selectLoginSession.loginSessionDateEnd)>
				<cfset activityStruct.dateEnd = qry_selectLoginSession.loginSessionDateEnd>
			<!---
			<cfelse>
				<cfset activityStruct.dateEnd = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 23, 59, 59)>
			--->
			</cfif>

			<!--- add note --->
			<cfinvoke component="#Application.billingMapping#data.Note" method="selectNoteCount" returnVariable="noteCountAll">
				<cfinvokeargument name="userID_author" value="#Arguments.userID#">
				<cfif activityStruct.dateBegin is not ""><cfinvokeargument Name="noteDateCreated_from" value="#activityStruct.dateBegin#"></cfif>
				<cfif activityStruct.dateEnd is not ""><cfinvokeargument Name="noteDateCreated_to" value="#activityStruct.dateEnd#"></cfif>
			</cfinvoke>

			<!--- send email --->
			<cfinvoke component="#Application.billingMapping#data.Contact" method="selectContactCount" returnVariable="mailCountAll">
				<cfinvokeargument name="companyID_author" value="#qry_selectUser.companyID_author#">
				<cfinvokeargument name="userID_author" value="#Arguments.userID#">
				<cfif activityStruct.dateBegin is not ""><cfinvokeargument Name="contactDateSent_from" value="#activityStruct.dateBegin#"></cfif>
				<cfif activityStruct.dateEnd is not ""><cfinvokeargument Name="contactDateSent_to" value="#activityStruct.dateEnd#"></cfif>
				<cfinvokeargument Name="contactIsSent" value="1">
			</cfinvoke>

			<!--- tasks/calendar --->
			<cfinvoke component="#Application.billingMapping#data.Task" method="selectTaskCount" returnVariable="taskCount_scheduledAll">
				<cfinvokeargument name="companyID_agent" value="#qry_selectUser.companyID_author#">
				<cfinvokeargument name="userID_agent" value="#Arguments.userID#">
				<cfif activityStruct.dateBegin is not ""><cfinvokeargument name="taskDateScheduled_from" value="#activityStruct.dateBegin#"></cfif>
				<cfif activityStruct.dateEnd is not ""><cfinvokeargument name="taskDateScheduled_to" value="#activityStruct.dateEnd#"></cfif>
			</cfinvoke>

			<cfinvoke component="#Application.billingMapping#data.Task" method="selectTaskCount" returnVariable="taskCount_createdAll">
				<cfinvokeargument name="companyID_agent" value="#qry_selectUser.companyID_author#">
				<cfinvokeargument name="userID_author" value="#Arguments.userID#">
				<cfif activityStruct.dateBegin is not ""><cfinvokeargument name="taskDateCreated_from" value="#activityStruct.dateBegin#"></cfif>
				<cfif activityStruct.dateEnd is not ""><cfinvokeargument name="taskDateCreated_to" value="#activityStruct.dateEnd#"></cfif>
			</cfinvoke>

			<cfinvoke component="#Application.billingMapping#data.Task" method="selectTaskCount" returnVariable="taskCount_updatedAll">
				<cfinvokeargument name="companyID_agent" value="#qry_selectUser.companyID_author#">
				<cfinvokeargument name="userID_author" value="#Arguments.userID#">
				<cfif activityStruct.dateBegin is not ""><cfinvokeargument name="taskDateUpdated_from" value="#activityStruct.dateBegin#"></cfif>
				<cfif activityStruct.dateEnd is not ""><cfinvokeargument name="taskDateUpdated_to" value="#activityStruct.dateEnd#"></cfif>
			</cfinvoke>

			<!--- changed status --->
			<cfinvoke component="#Application.billingMapping#data.StatusHistory" method="selectStatusHistoryCount" returnVariable="statusHistoryCount">
				<cfinvokeargument name="userID" value="#Arguments.userID#">
				<cfif activityStruct.dateBegin is not ""><cfinvokeargument name="statusHistoryDateCreated_from" value="#activityStruct.dateBegin#"></cfif>
				<cfif activityStruct.dateEnd is not ""><cfinvokeargument name="statusHistoryDateCreated_to" value="#activityStruct.dateEnd#"></cfif>
			</cfinvoke>

			<cfif activityStruct.dateBegin is not "">
				<cfset activityStruct.dateBeginDisplay = DateFormat(activityStruct.dateBegin, "ddd, mmm dd, yyyy") & " at " & TimeFormat(activityStruct.dateBegin, "hh:mm tt")>
			<cfelse>
				<cfset activityStruct.dateBeginDisplay = DateFormat(qry_selectUser.userDateCreated, "ddd, mmm dd, yyyy") & " at " & TimeFormat(qry_selectUser.userDateCreated, "hh:mm tt")>
			</cfif>
			<cfif activityStruct.dateEnd is not "">
				<cfset activityStruct.dateEndDisplay = DateFormat(activityStruct.dateEnd, "ddd, mmm dd, yyyy") & " at " & TimeFormat(activityStruct.dateEnd, "hh:mm tt")>
			<cfelse>
				<cfset activityStruct.dateEndDisplay = DateFormat(Now(), "ddd, mmm dd, yyyy") & " at " & TimeFormat(Now(), "hh:mm tt")>
			</cfif>

			<cfif Arguments.formAction is not "">
				<!---
				<cfif Not FindNoCase("&userID=#Arguments.userID#", Arguments.formAction)>
					<cfset Arguments.formAction &= "&userID=" & Arguments.userID>
				</cfif>
				--->

				<cfif Not IsDefined("fn_FormValidateDateTime")>
					<cfinclude Template="../../include/function/fn_datetime.cfm">
				</cfif>

				<cfparam name="Form.userActivityDateBegin" default="">
				<cfparam name="Form.userActivityDateEnd" default="">

				<cfset activityStruct.formName = "listUserActivity">
				<cfinvoke component="#Application.billingMapping#include.function.DateRange" method="dateRangeShortcut" returnVariable="dateRangeStruct" />

				<cfinclude template="../../view/v_loginSession/form_viewUserActivityReport.cfm">
			</cfif>

			<cfinclude template="../../view/v_loginSession/dsp_viewUserActivityReport.cfm">
		</cfif><!--- /user exists, permission --->
	</cfif><!--- /valid user --->

	<cfreturn returnValue>
</cffunction>

</cfcomponent>