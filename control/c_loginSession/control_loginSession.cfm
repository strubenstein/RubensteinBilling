<cfif IsDefined("URL.confirm_loginSession")>
	<cfinclude template="../../view/v_loginSession/confirm_loginSession.cfm">
</cfif>
<cfif IsDefined("URL.error_loginSession")>
	<cfinclude template="../../view/v_loginSession/error_loginSession.cfm">
</cfif>

<cfset Variables.formAction = "index.cfm?method=loginSession.listLoginSessions">

<cfinvoke component="#Application.billingMapping#data.UserCompany" method="selectUserCompanyList_company" returnVariable="qry_selectUserList">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="userStatus" value="1">
</cfinvoke>

<cfparam name="Form.loginSessionOption" default="all">
<cfparam name="Form.loginSessionDateBegin_from" default="">
<cfparam name="Form.loginSessionDateBegin_to" default="">

<cfif IsDefined("URL.userID") and ListFind(ValueList(qry_selectUserList.userID), URL.userID)>
	<cfset Form.userID = URL.userID>
<cfelseif Not IsDefined("Form.userID") or Not ListFind(ValueList(qry_selectUserList.userID), Form.userID)>
	<cfset Form.userID = 0>
</cfif>

<cfif Not IsDefined("fn_FormValidateDateTime")>
	<cfinclude Template="../../include/function/fn_datetime.cfm">
</cfif>

<cfset Variables.formName = "listLoginSessions">
<!--- <cfinclude template="../../view/v_loginSession/form_listLoginSessions.cfm"> --->

<cfif Form.userID is not 0 and IsDefined("URL.updateLoginSession") and IsDefined("URL.loginSessionID") and Application.fn_IsIntegerPositive(URL.loginSessionID)>
	<cfinvoke component="#Application.billingMapping#data.LoginSession" method="selectLoginSession" returnVariable="qry_selectLoginSession">
		<cfinvokeargument name="loginSessionID" value="#URL.loginSessionID#">
	</cfinvoke>

	<cfif qry_selectLoginSession.RecordCount is not 1 or qry_selectLoginSession.userID is not Form.userID and qry_selectLoginSession.loginSessionDateEnd is "">
		<cflocation url="#Arguments.formAction#&error_loginSession=updateLoginSession" addToken="no">
	<cfelse>
		<cfinvoke component="#Application.billingMapping#data.LoginSession" method="updateLoginSession" returnVariable="isLoginSessionUpdated">
			<cfinvokeargument name="loginSessionID" value="#URL.loginSessionID#">
			<cfinvokeargument name="loginSessionDateEnd" value="#Now()#">
		</cfinvoke>

		<cflocation url="#Arguments.formAction#&confirm_loginSession=updateLoginSession" addToken="no">
	</cfif>

<cfelseif Form.userID is not 0>
	<cfinvoke component="#Application.billingMapping#data.User" method="selectUser" returnVariable="qry_selectUser">
		<cfinvokeargument name="userID" value="#Form.userID#">
	</cfinvoke>

	<cfinvoke component="#Application.billingMapping#data.LoginSession" method="selectLoginSessionList" returnVariable="qry_selectLoginSessionList">
	  	<cfinvokeargument name="userID" value="#Form.userID#">
		<cfif IsDate(Form.loginSessionDateBegin_from)>
			<cfinvokeargument name="loginSessionDateBegin_from" value="#Form.loginSessionDateBegin_from#">
		</cfif>
		<cfif IsDate(Form.loginSessionDateBegin_to)>
			<cfinvokeargument name="loginSessionDateBegin_to" value="#Form.loginSessionDateBegin_to#">
		</cfif>
	  	<cfinvokeargument name="returnUserInfo" value="False">
	</cfinvoke>
	<!---
	<cfinvoke component="#Application.billingMapping#control.c_loginSession.ListLoginSessions" method="listLoginSessionsForUser" returnVariable="isListed">
	  	<cfinvokeargument name="userID" value="#Form.userID#">
	  	<cfinvokeargument name="displayForm" value="False">
		<cfif IsDate(Form.loginSessionDateBegin_from)>
			<cfinvokeargument name="loginSessionDateBegin_from" value="#Form.loginSessionDateBegin_from#">
		</cfif>
		<cfif IsDate(Form.loginSessionDateBegin_to)>
			<cfinvokeargument name="loginSessionDateBegin_to" value="#Form.loginSessionDateBegin_to#">
		</cfif>
	</cfinvoke>
	--->
	<cfinclude template="../../view/v_loginSession/dsp_listLoginSessionsForUser.cfm">
<cfelse>
	<cfinvoke component="#Application.billingMapping#data.LoginSession" method="selectLoginSessionList" returnVariable="qry_selectLoginSessionList">
		<cfswitch expression="#Form.loginSessionOption#">
		  <cfcase value="loggedIn">
		  	<cfinvokeargument name="loginSessionDateEndIsNull" value="False">
			<cfinvokeargument name="companyID" value="#Session.companyID_author#">
			<cfinvokeargument name="returnUserInfo" value="True">
		  </cfcase>
		  <cfdefaultcase><!--- all --->
			<cfinvokeargument name="companyID" value="#Session.companyID_author#">
		  	<cfinvokeargument name="loginSessionCurrent" value="1">
			<cfinvokeargument name="returnUserInfo" value="True">
		  </cfdefaultcase>
		</cfswitch>
		<cfif IsDate(Form.loginSessionDateBegin_from)>
			<cfinvokeargument name="loginSessionDateBegin_from" value="#Form.loginSessionDateBegin_from#">
		</cfif>
		<cfif IsDate(Form.loginSessionDateBegin_to)>
			<cfinvokeargument name="loginSessionDateBegin_to" value="#Form.loginSessionDateBegin_to#">
		</cfif>
	</cfinvoke>

	<cfset userRowStruct = StructNew()>
	<cfloop query="qry_selectLoginSessionList">
		<cfset userRowStruct["user#qry_selectLoginSessionList.userID#"] = CurrentRow>
	</cfloop>

	<cfinclude template="../../view/v_loginSession/dsp_listLoginSessionsForAll.cfm">
</cfif>
