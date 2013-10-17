<!--- Determine whether custom fields and custom status apply to this object --->
<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("userID")>
<cfset Variables.targetID = URL.userID>

<cfif URL.control is "user" or Not IsDefined("qry_selectCompany")>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
		<cfinvokeargument Name="companyID" Value="#URL.companyID#">
	</cfinvoke>
</cfif>

<cfinclude template="formParam_insertUpdateUser.cfm">
<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />
<cfinclude template="../../view/v_user/lang_insertUpdateUser.cfm">

<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="userID">
	<cfinvokeargument name="targetID_formParam" value="#URL.userID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="userID">
	<cfinvokeargument name="targetID_formParam" value="#URL.userID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitUser")>
	<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
	<cfinclude template="formValidate_insertUpdateUser.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelseif Variables.doAction is "insertUser">
		<cfif IsDefined("Form.generateUserEmailVerifyCode")>
			<cfinvoke component="#Application.billingMapping#data.User" method="generateUserEmailVerifyCode" returnVariable="Form.userEmailVerifyCode" />
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.User" Method="insertUser" ReturnVariable="newUserID">
			<cfif URL.companyID is 0>
				<cfset URL.companyID = Session.companyID>
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfelse>
				<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			</cfif>
			<cfinvokeargument Name="username" Value="#Form.username#">
			<cfinvokeargument Name="password" Value="#Form.password#">
			<cfinvokeargument Name="userStatus" Value="#Form.userStatus#">
			<cfinvokeargument Name="firstName" Value="#Form.firstName#">
			<cfinvokeargument Name="middleName" Value="#Form.middleName#">
			<cfinvokeargument Name="lastName" Value="#Form.lastName#">
			<cfinvokeargument Name="suffix" Value="#Form.suffix#">
			<cfinvokeargument Name="salutation" Value="#Form.salutation#">
			<cfinvokeargument Name="email" Value="#Form.email#">
			<cfinvokeargument Name="userID_custom" Value="#Form.userID_custom#">
			<cfinvokeargument Name="jobTitle" Value="#Form.jobTitle#">
			<cfinvokeargument Name="jobDepartment" Value="#Form.jobDepartment#">
			<cfinvokeargument Name="jobDivision" Value="#Form.jobDivision#">
			<cfinvokeargument Name="userNewsletterStatus" Value="#Form.userNewsletterStatus#">
			<cfinvokeargument Name="userNewsletterHtml" Value="#Form.userNewsletterHtml#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="userEmailVerified" Value="#Form.userEmailVerified#">
			<cfif IsDefined("Form.generateUserEmailVerifyCode")>
				<cfinvokeargument Name="userEmailVerifyCode" Value="#Form.userEmailVerifyCode#">
			</cfif>
			<cfif Form.userEmailVerified is 1>
				<cfinvokeargument Name="userEmailDateVerified" Value="#Now()#">
			</cfif>
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.User" Method="insertUserCompany" ReturnVariable="isUserCompanyInserted">
			<cfinvokeargument Name="userID" Value="#newUserID#">
			<cfinvokeargument Name="companyID" Value="#URL.companyID#">
			<cfinvokeargument Name="userCompanyStatus" Value="1">
		</cfinvoke>

		<cfif URL.control is "company" and IsDefined("qry_selectCompany") and qry_selectCompany.userID is 0>
			<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
				<cfinvokeargument Name="companyID" Value="#URL.companyID#">
				<cfinvokeargument Name="userID" Value="#newUserID#">
			</cfinvoke>
		</cfif>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newUserID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newUserID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="userID">
			<cfinvokeargument name="targetID" value="#newUserID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.control#.viewUser&companyID=#URL.companyID#&userID=#newUserID#&confirm_user=#Variables.doAction#" AddToken="No">

	<cfelse><!--- update user --->
		<cfif IsDefined("Form.generateUserEmailVerifyCode")>
			<cfinvoke component="#Application.billingMapping#data.User" method="generateUserEmailVerifyCode" returnVariable="Form.userEmailVerifyCode" />
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUser" ReturnVariable="isUserUpdated">
			<cfinvokeargument Name="userID" Value="#URL.userID#">
			<cfinvokeargument Name="username" Value="#Form.username#">
			<cfif Form.password is not "">
				<cfinvokeargument Name="password" Value="#Form.password#">
			</cfif>
			<cfinvokeargument Name="userStatus" Value="#Form.userStatus#">
			<cfinvokeargument Name="firstName" Value="#Form.firstName#">
			<cfinvokeargument Name="middleName" Value="#Form.middleName#">
			<cfinvokeargument Name="lastName" Value="#Form.lastName#">
			<cfinvokeargument Name="suffix" Value="#Form.suffix#">
			<cfinvokeargument Name="salutation" Value="#Form.salutation#">
			<cfinvokeargument Name="email" Value="#Form.email#">
			<cfinvokeargument Name="userID_custom" Value="#Form.userID_custom#">
			<cfinvokeargument Name="jobTitle" Value="#Form.jobTitle#">
			<cfinvokeargument Name="jobDepartment" Value="#Form.jobDepartment#">
			<cfinvokeargument Name="jobDivision" Value="#Form.jobDivision#">
			<cfinvokeargument Name="userNewsletterStatus" Value="#Form.userNewsletterStatus#">
			<cfinvokeargument Name="userNewsletterHtml" Value="#Form.userNewsletterHtml#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="userEmailVerified" Value="#Form.userEmailVerified#">
			<cfif IsDefined("Form.generateUserEmailVerifyCode")>
				<cfinvokeargument Name="userEmailVerifyCode" Value="#Form.userEmailVerifyCode#">
			</cfif>
			<cfif Form.userEmailVerified is not 1>
				<cfinvokeargument Name="userEmailDateVerified" Value="">
			<cfelseif Not IsDate(qry_selectUser.userEmailDateVerified)>
				<cfinvokeargument Name="userEmailDateVerified" Value="#Now()#">
			</cfif>
		</cfinvoke>

		<!--- Update custom fields and status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.userID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.userID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- archive field changes --->
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
			<cfinvokeargument name="primaryTargetKey" value="userID">
			<cfinvokeargument name="targetID" value="#URL.userID#">
			<cfinvokeargument name="userID" value="#Session.userID#">
			<cfinvokeargument name="qry_selectTarget" value="#qry_selectUser#">
		</cfinvoke>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="userID">
			<cfinvokeargument name="targetID" value="#URL.userID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=#URL.method#&companyID=#URL.companyID#&userID=#URL.userID#&confirm_user=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserJobDepartmentList" ReturnVariable="qry_selectUserJobDepartmentList">
	<cfinvokeargument Name="companyID" Value="#URL.companyID#">
</cfinvoke>

<cfset Variables.formName = "insertUpdateUser">
<cfset Variables.formAction = "index.cfm?method=" & URL.method & "&companyID=" & URL.companyID & "&userID=" & URL.userID>
<cfif Variables.doAction is "insertUser">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateUser.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateUser.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_user/form_insertUpdateUser.cfm">
