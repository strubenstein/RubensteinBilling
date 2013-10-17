<cfcomponent displayName="ListLoginSessions" hint="Displays current session status for admin users">

<cffunction name="listLoginSessions" access="public" returnType="boolean" output="yes">
	<cfargument name="companyID" type="numeric" required="yes">
	<cfargument name="formAction" type="string" required="yes">
	<cfargument name="displayLoggedInUsersOnly" type="boolean" required="no" default="False" hint="False = display all users and current status">
	<cfargument name="loginSessionDateBegin_from" type="string" required="no">
	<cfargument name="loginSessionDateBegin_to" type="string" required="no">

	<cfset var returnValue = True>
	<cfset var userRowStruct = StructNew()>
	<cfset var userRow = 0>
	<cfset var listAction = Replace(Arguments.formAction, "viewLoginSessionsForUser", "listLoginSessions", "one")>
	<cfset var activityAction = Replace(Arguments.formAction, "viewLoginSessionsForUser", "viewUserActivityReport", "one")>
	<cfset var lang_listLoginSessions_title = StructNew()>
	<cfset var methodStruct = StructNew()>

	<cfif IsDefined("URL.loginSessionDateBegin_from") and IsDate(loginSessionDateBegin_from)>
		<cfset Arguments.loginSessionDateBegin_from = CreateDateTime(Year(URL.loginSessionDateBegin_from), Month(URL.loginSessionDateBegin_from), Day(URL.loginSessionDateBegin_from), 00, 00, 00)>
	</cfif>
	<cfif IsDefined("URL.loginSessionDateBegin_to") and IsDate(loginSessionDateBegin_to)>
		<cfset Arguments.loginSessionDateBegin_to = CreateDateTime(Year(URL.loginSessionDateBegin_to), Month(URL.loginSessionDateBegin_to), Day(URL.loginSessionDateBegin_to), 23, 59, 59)>
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.UserCompany" method="selectUserCompanyList_company" returnVariable="qry_selectUserList">
		<cfinvokeargument name="companyID" value="#Arguments.companyID#">
		<cfinvokeargument name="userStatus" value="1">
	</cfinvoke>

	<cfif IsDefined("URL.userID") and ListFind(ValueList(qry_selectUserList.userID), URL.userID)
			and IsDefined("URL.updateLoginSession") and IsDefined("URL.loginSessionID") and Application.fn_IsIntegerPositive(URL.loginSessionID)>
		<cfinvoke component="#Application.billingMapping#data.LoginSession" method="selectLoginSession" returnVariable="qry_selectLoginSession">
			<cfinvokeargument name="loginSessionID" value="#URL.loginSessionID#">
		</cfinvoke>

		<cfif qry_selectLoginSession.RecordCount is not 1 or qry_selectLoginSession.userID is not URL.userID and qry_selectLoginSession.loginSessionDateEnd is "">
			<cfset URL.error_loginSession = "updateLoginSession">
		<cfelse>
			<cfinvoke component="#Application.billingMapping#data.LoginSession" method="updateLoginSessionDateEnd" returnVariable="isLogoutSessionEnded">
				<cfinvokeargument name="userID" value="#URL.userID#">
				<cfinvokeargument name="loginSessionTimeout" value="0">
				<cfinvokeargument name="loginSessionID" value="#URL.loginSessionID#">
			</cfinvoke>

			<cfset URL.confirm_loginSession = "updateLoginSession">
		</cfif>
	</cfif>

	<cfif Not IsDefined("fn_FormValidateDateTime")>
		<cfinclude Template="../../include/function/fn_datetime.cfm">
	</cfif>

	<!---
	<cfinvoke component="#Application.billingMapping#data.LoginSession" method="selectLoginSessionList" returnVariable="qry_selectLoginSessionList">
		<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	  	<cfinvokeargument name="loginSessionCurrent" value="1">
		<cfif StructKeyExists(Arguments, "loginSessionDateBegin_from") and IsDate(Arguments.loginSessionDateBegin_from)>
			<cfinvokeargument name="loginSessionDateBegin_from" value="#Arguments.loginSessionDateBegin_from#">
		</cfif>
		<cfif StructKeyExists(Arguments, "loginSessionDateBegin_to") and IsDate(Arguments.loginSessionDateBegin_to)>
			<cfinvokeargument name="loginSessionDateBegin_to" value="#Arguments.loginSessionDateBegin_to#">
		</cfif>
		<cfinvokeargument name="returnUserInfo" value="True">
	</cfinvoke>

	<cfloop query="qry_selectLoginSessionList">
		<cfset userRowStruct["user#qry_selectLoginSessionList.userID#"] = CurrentRow>
	</cfloop>
	--->

	<cfparam name="URL.queryOrderBy" default="lastName">
	<cfparam name="URL.userStatus" default="1">
	<cfparam name="URL.viewUsers" default="all">

	<cfinvoke component="#Application.billingMapping#data.LoginSession" method="selectLoginSessionCompanyList" returnVariable="qry_selectLoginSessionList">
		<cfinvokeargument name="companyID" value="#Session.companyID_author#">
		<cfif StructKeyExists(Arguments, "loginSessionDateBegin_from") and IsDate(Arguments.loginSessionDateBegin_from)>
			<cfinvokeargument name="loginSessionDateBegin_from" value="#Arguments.loginSessionDateBegin_from#">
		</cfif>
		<cfif StructKeyExists(Arguments, "loginSessionDateBegin_to") and IsDate(Arguments.loginSessionDateBegin_to)>
			<cfinvokeargument name="loginSessionDateBegin_to" value="#Arguments.loginSessionDateBegin_to#">
		</cfif>
		<cfinvokeargument name="userStatus" value="1">
		<cfinvokeargument name="queryOrderBy" value="#URL.queryOrderBy#">
		<cfif URL.viewUsers is "ever">
			<cfinvokeargument name="returnAllUsers" value="False">
		<cfelseif URL.viewUsers is "current">
			<cfinvokeargument name="loginSessionDateBegin_to" value="#Now()#">
			<cfinvokeargument name="loginSessionDateEndIsNull" value="False">
		</cfif>
	</cfinvoke>

	<cfif IsDefined("URL.confirm_loginSession")>
		<cfinclude template="../../view/v_loginSession/confirm_loginSession.cfm">
	</cfif>
	<cfif IsDefined("URL.error_loginSession")>
		<cfinclude template="../../view/v_loginSession/error_loginSession.cfm">
	</cfif>

	<cfinclude template="../../view/v_loginSession/lang_listLoginSessions.cfm">
	<cfset methodStruct.columnHeaderList = lang_listLoginSessions_title.isLoggedIn
		& "^" & lang_listLoginSessions_title.lastName
		& "^" & lang_listLoginSessions_title.loginSessionDateBegin
		& "^" & lang_listLoginSessions_title.loginSessionDateEnd
		& "^" & lang_listLoginSessions_title.loginSessionLength
		& "^" & lang_listLoginSessions_title.loginSessionTimeout
		& "^" & lang_listLoginSessions_title.isEndSession
		& "^" & lang_listLoginSessions_title.viewActivityReport>
	<cfset methodStruct.columnOrderByList = "False^lastName^loginSessionDateBegin^loginSessionDateEnd^False^False^False^False">
	<cfset methodStruct.columnCount = DecrementValue(2 * ListLen(methodStruct.columnHeaderList, "^"))>

	<cfif Not IsDefined("fn_DisplayCurrentRecordNumbers")>
		<cfinclude Template="../../include/function/fn_DisplayOrderByNav.cfm">
	</cfif>

	<cfinclude template="../../view/v_loginSession/dsp_listLoginSessionsForAll.cfm">

	<cfreturn returnValue>
</cffunction>

<cffunction name="viewLoginSessionsForUser" access="public" returnType="boolean" output="yes">
	<cfargument name="userID" type="numeric" required="yes">
	<cfargument name="formAction" type="string" required="yes">
	<cfargument name="loginSessionDateBegin_from" type="string" required="no">
	<cfargument name="loginSessionDateBegin_to" type="string" required="no">
	<cfargument name="viewTimesheet" type="boolean" required="no" default="False">

	<cfset var returnValue = True>
	<cfset var userRow = 0>
	<cfset var activityAction = Replace(Arguments.formAction, "viewLoginSessionsForUser", "viewUserActivityReport", "one")>
	<cfset var sessionsAction = Replace(Arguments.formAction, "viewLoginSessionsForUser", "listLoginSessions", "one")>
	<cfset var timeStruct = StructNew()>
	<cfset var timeKey = "">

	<cfif IsDefined("URL.viewTimesheet") and URL.viewTimesheet is True>
		<cfset Arguments.viewTimesheet = True>
	</cfif>

	<cfloop index="field" list="loginSessionDateBegin_from,loginSessionDateBegin_to">
		<cfif StructKeyExists(Arguments, field)>
			<cfset Form[field] = Arguments[field]>
		<cfelseif IsDefined("URL.#field#") and IsDate(URL[field])>
			<cfset Form[field] = URL[field]>
		<cfelse>
			<cfparam name="Form.#field#" default="">
		</cfif>
	</cfloop>

	<cfif Not Application.fn_IsIntegerPositive(Arguments.userID)>
		<cfset returnValue = False>
	<cfelse>
		<cfinvoke component="#Application.billingMapping#data.User" method="selectUser" returnVariable="qry_selectUser">
			<cfinvokeargument name="userID" value="#Arguments.userID#">
		</cfinvoke>

		<cfif qry_selectUser.RecordCount is 0 or Session.companyID_author is not qry_selectUser.companyID_author>
			<cfset returnValue = False>
		<cfelse>
			<cfinvoke component="#Application.billingMapping#data.LoginSession" method="selectLoginSessionList" returnVariable="qry_selectLoginSessionList">
			  	<cfinvokeargument name="userID" value="#Arguments.userID#">
				<cfif IsDate(Form.loginSessionDateBegin_from)>
					<cfinvokeargument name="loginSessionDateBegin_from" value="#CreateDateTime(Year(Form.loginSessionDateBegin_from), Month(Form.loginSessionDateBegin_from), Day(Form.loginSessionDateBegin_from), 00, 00, 00)#">
				</cfif>
				<cfif IsDate(Form.loginSessionDateBegin_to)>
					<cfinvokeargument name="loginSessionDateBegin_to" value="#CreateDateTime(Year(Form.loginSessionDateBegin_to), Month(Form.loginSessionDateBegin_to), Day(Form.loginSessionDateBegin_to), 23, 59, 59)#">
				</cfif>
			  	<cfinvokeargument name="returnUserInfo" value="False">
			</cfinvoke>

			<cfif Not IsDefined("fn_FormValidateDateTime")>
				<cfinclude Template="../../include/function/fn_datetime.cfm">
			</cfif>

			<cfif Arguments.viewTimesheet is False>
				<cfinclude template="../../view/v_loginSession/dsp_listLoginSessionsForUser.cfm">
			<cfelse>
				<cfset timeStruct.monthList = "">
				<cfif qry_selectLoginSessionList.RecordCount is not 0>
					<cfset timeStruct.dateEnd = qry_selectLoginSessionList.loginSessionDateBegin[1]>
					<cfset timeStruct.dateBegin = qry_selectLoginSessionList.loginSessionDateBegin[qry_selectLoginSessionList.RecordCount]>
					<cfset timeStruct.firstSunday = DateAdd("d", -1 * DecrementValue(DayOfWeek(timeStruct.dateEnd)), timeStruct.dateEnd)>
					<cfset timeStruct.weekCount = 2 + DateDiff("ww", timeStruct.dateBegin, timeStruct.dateEnd)>
				</cfif>

				<cfloop query="qry_selectLoginSessionList">
					<cfset timeKey = "date" & DateFormat(qry_selectLoginSessionList.loginSessionDateBegin, "yyyymmdd")>
					<cfif qry_selectLoginSessionList.loginSessionDateEnd is not "">
						<cfset timeStruct.duration = DateDiff("n", qry_selectLoginSessionList.loginSessionDateBegin, qry_selectLoginSessionList.loginSessionDateEnd) / 60>
					<cfelseif DateFormat(qry_selectLoginSessionList.loginSessionDateBegin, "yyyymmdd") is DateFormat(Now(), "yyyymmdd")>
						<cfset timeStruct.duration = DateDiff("n", qry_selectLoginSessionList.loginSessionDateBegin, Now()) / 60>
					<cfelse>
						<cfset timeStruct.duration = 0>
					</cfif>

					<cfif StructKeyExists(timeStruct, timeKey)>
						<cfset timeStruct[timeKey] += timeStruct.duration>
					<cfelse>
						<cfset timeStruct[timeKey] = timeStruct.duration>
					</cfif>

					<cfset timeKey = "month" & DateFormat(qry_selectLoginSessionList.loginSessionDateBegin, "yyyymm")>
					<cfif StructKeyExists(timeStruct, timeKey)>
						<cfset timeStruct[timeKey] += timeStruct.duration>
					<cfelse>
						<cfset timeStruct[timeKey] = timeStruct.duration>
						<cfset timeStruct.monthList = ListAppend(timeStruct.monthList, timeKey)>
					</cfif>
				</cfloop>

				<cfinclude template="../../view/v_loginSession/dsp_listLoginSessionTimesheet.cfm">
			</cfif>
		</cfif>
	</cfif>

	<cfreturn returnValue>
</cffunction>

</cfcomponent>