<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("userID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#"><!--- companyID --->
	<cfif Session.companyID is not Session.companyID_author><!--- if cobrand user is logged in --->
		<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID_list#">
	</cfif>
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#"><!--- companyID --->
	<cfif Session.companyID is not Session.companyID_author><!--- if cobrand user is logged in --->
		<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID_list#">
	</cfif>
</cfinvoke>

<cfinclude template="formParam_listUsers.cfm">

<cfset Variables.formName = "listUsers">
<cfset Variables.formAction = CGI.Script_Name & "?" & CGI.Query_String>
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_user/form_listUsers.cfm">

<cfinclude template="../../view/v_user/lang_listUsers.cfm">
<cfinclude template="formValidate_listUsers.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#&isFormSubmitted=True">

	<cfif IsDefined("Form.returnMyCompanyUsersOnly") and Form.returnMyCompanyUsersOnly is 1>
		<cfset Form.returnCompanyFields = False>
	</cfif>
	<cfif Form.returnCompanyFields is False and ListFind("companyName,companyName_d,companyID_custom,companyID_custom_d", Form.queryOrderBy)>
		<cfset Form.queryOrderBy = "lastName">
	</cfif>

	<!--- determine query parameters --->
	<cfset qryParamStruct = StructNew()>
	<cfset qryParamStruct.companyID_author = Session.companyID_author>
	<cfset qryParamStruct.method = URL.method>
	<cfset qryParamStruct.returnCompanyFields = Form.returnCompanyFields>
	<cfif IsDefined("Form.userID_not") and Form.userID_not is not "" and Application.fn_IsIntegerList(Form.userID_not)>
		<cfset qryParamStruct.userID_not = Form.userID_not>
	</cfif>
	<cfloop Index="field" List="companyID,cobrandID,affiliateID,vendorID,statusID,groupID,priceID,productID,categoryID">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerList(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="commissionID,commissionID_not">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerPositive(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="searchText,searchField,userID_custom,city,state,country,zipCode,county,returnMyCompanyUsersOnly">
		<cfif IsDefined("Form.#field#") and Trim(Form[field]) is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="userIsProductManager,companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsCustomer,companyIsTaxExempt,userHasCustomPricing,userHasCustomID,userStatus,userIsPrimaryContact,userNewsletterStatus,userNewsletterHtml,userIsActiveSubscriber">
		<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="userDateExported_from,userDateExported_to">
		<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif IsDefined("Form.userIsExported") and (Form.userIsExported is "" or ListFind("0,1", Form.userIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&userIsExported=#URLEncodedFormat(Form.userIsExported)#">
		<cfset qryParamStruct.userIsExported = Form.userIsExported>
	</cfif>
	<!--- /determine query parameters --->

	<cfset Variables.queryFirstLetter_field = "">
	<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
		<cfswitch expression="#Form.queryOrderBy#">
		<cfcase value="username,username_d"><cfset Variables.queryFirstLetter_field = "avUser.username"></cfcase>
		<cfcase value="lastName,lastName_d"><cfset Variables.queryFirstLetter_field = "avUser.lastName"></cfcase>
		<cfcase value="companyName,companyName_d"><cfset Variables.queryFirstLetter_field = "avCompany.companyName"></cfcase>
		<cfcase value="jobTitle,jobTitle_d"><cfset Variables.queryFirstLetter_field = "avUser.jobTitle"></cfcase>
		<cfcase value="jobDepartment,jobDepartment_d"><cfset Variables.queryFirstLetter_field = "avUser.jobDepartment"></cfcase>
		<cfcase value="jobDivision,jobDivision_d"><cfset Variables.queryFirstLetter_field = "avUser.jobDivision"></cfcase>
		<cfdefaultcase><cfset Form.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportUsers")
			and IsDefined("URL.queryDisplayResults") and URL.queryDisplayResults is False
			and IsDefined("Form.exportResultsMethod") and ListFind("excel,iif,ab,xml", Form.exportResultsMethod)
			and IsDefined("Form.exportResultsFormat") and ListFind("data,display", Form.exportResultsFormat)
			and IsDefined("Form.exportFunction") and ListFind("exportOnly,exportAndStatus,statusOnly", Form.exportFunction)>
		<cfif ListFind("exportOnly,exportAndStatus", Form.exportFunction)>
			<cfset Variables.exportResults = True>
			<cfset Form.queryDisplayPerPage = 0>
		</cfif>
		<cfif ListFind("exportAndStatus,statusOnly", Form.exportFunction) and IsDefined("Form.targetIsExported") and (Form.targetIsExported is "" or ListFind("0,1", Form.targetIsExported))>
			<cfset Variables.updateExportStatus = True>
		</cfif>
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserList" ReturnVariable="qry_selectUserList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
		<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
			<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
			<cfinvokeargument Name="queryFirstLetter_field" Value="#Variables.queryFirstLetter_field#">
		</cfif>
	</cfinvoke>

	<!--- update export status of all results --->
	<cfif Variables.updateExportStatus is True>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUserIsExported" ReturnVariable="isUserExportStatusUpdated">
			<cfinvokeargument Name="userID" Value="#ValueList(qry_selectUserList.userID)#">
			<cfinvokeargument Name="userIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportUserList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_user=updateUserIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

		<cfif Not ListFind("username,username_d,lastName,lastName_d,companyName,companyName_d,jobTitle,jobTitle_d,jobDepartment,jobDepartment_d,jobDivision,jobDivision_d", Form.queryOrderBy)>
			<cfset Variables.displayAlphabet = False>
			<cfset Variables.alphabetList = "">
		<cfelse>
			<cfif ListFind("companyName,companyName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avCompany.companyName">
			<cfelseif ListFind("lastName,lastName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avUser.lastName">
			<cfelse>
				<cfset Variables.alphabetField = "avUser." & ListFirst(Form.queryOrderBy, "_")>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserList_alphabet" ReturnVariable="qry_selectUserList_alphabet" argumentCollection="#qryParamStruct#">
				<cfinvokeargument Name="alphabetField" Value="#Variables.alphabetField#">
			</cfinvoke>

			<cfset Variables.displayAlphabet = True>
			<cfset Variables.alphabetList = ValueList(qry_selectUserList_alphabet.firstLetter, "|")>

			<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "" and Variables.queryFirstLetter_field is not "">
				<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUserList_alphabetPage" ReturnVariable="userCountBeforeAlphabet" argumentCollection="#qryParamStruct#">
					<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
					<cfinvokeargument Name="queryFirstLetter_field" Value="#Variables.queryFirstLetter_field#">
					<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
				</cfinvoke>

				<cfset Form.queryPage = 1 + (userCountBeforeAlphabet \ Form.queryDisplayPerPage)>
			</cfif>
		</cfif>

		<cfset Variables.queryViewAction = Replace(Variables.queryViewAction, "commissionID_not=", "commissionID=", "ONE")>
		<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
		<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
		<cfset Variables.totalRecords = qryTotalRecords>
		<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
		<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
			<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
		<cfelse>
			<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
		</cfif>

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewUser,viewCompany")>

		<!--- 
		<cfif Form.returnCompanyFields is False>
			<cfset Variables.isDisplayCompanyID_custom = False>
		<cfelseif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectUserList.companyID_custom))>
			<cfset Variables.isDisplayCompanyID_custom = True>
			<cfset Variables.columnHeaderList = "Custom<br>ID^Company^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "companyID_custom^companyName^" & Variables.columnOrderByList>
		<cfelse>
			<cfset Variables.isDisplayCompanyID_custom = False>
			<cfset Variables.columnHeaderList = "Company^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "companyName^" & Variables.columnOrderByList>
		</cfif>
		--->
		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectUserList.companyID_custom))>
			<cfset Variables.isDisplayCompanyID_custom = True>
			<cfset Variables.columnHeaderList = Variables.lang_listUsers_title.companyID_custom & "^">
			<cfset Variables.columnOrderByList = "companyID_custom^">
		<cfelse>
			<cfset Variables.isDisplayCompanyID_custom = False>
			<cfset Variables.columnHeaderList = "">
			<cfset Variables.columnOrderByList = "">
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listUsers_title.companyName & "^" & Variables.lang_listUsers_title.lastName>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "companyName^lastName">

		<cfif Not REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectUserList.userID_custom))>
			<cfset Variables.isDisplayUserID_custom = False>
		<cfelse>
			<cfset Variables.isDisplayUserID_custom = True>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listUsers_title.userID_custom>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^userID_custom">
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listUsers_title.username & "^" & Variables.lang_listUsers_title.userDateCreated>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^username^userDateCreated">

		<cfif ListFind(Variables.permissionActionList, "viewUser")>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listUsers_title.viewUser>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
		</cfif>

		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

		<cfswitch expression="#URL.method#">
		<cfcase value="group.listGroupUser,group.insertGroupUser">
			<cfif URL.method is "group.listGroupUser">
				<cfset Variables.columnHeaderList = Variables.lang_listUsers_title.listGroupUser & "^" & Variables.columnHeaderList>
			<cfelse>
				<cfset Variables.columnHeaderList = Variables.lang_listUsers_title.insertGroupUser & "^" & Variables.columnHeaderList>
			</cfif>

			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfset Variables.userListRedirect = Replace(Variables.queryViewAction_orderBy, "method=user.listUsers", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage>
			<!--- "&groupID=" & URL.groupID & --->

			<cfset Variables.formAction = "index.cfm?method=#URL.method#&groupID=#URL.groupID#">
			<cfset Variables.formName = "groupUser">

			<cfif URL.method is "group.insertGroupUser">
				<cfset Variables.formSubmitName = "submitGroupUserInsert">
				<cfset Variables.formSubmitValue = Variables.lang_listUsers_title.formSubmitValue_insertGroupUser>
			<cfelse><!--- group.listGroupUser --->
				<cfset Variables.formSubmitName = "submitGroupUserDelete">
				<cfset Variables.formSubmitValue = Variables.lang_listUsers_title.formSubmitValue_listGroupUser>
			</cfif>

			<cfinclude template="../../view/v_user/form_userMember.cfm">
		</cfcase>

		<cfcase value="category.insertPriceTargetUser,product.insertPriceTargetUser,price.insertPriceTargetUser">
			<cfset Variables.columnHeaderList = Variables.lang_listUsers_title.priceTarget & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfset Variables.userListRedirect = Replace(Variables.queryViewAction_orderBy, "method=user.listUsers", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage & "&priceID=" & Form.priceID>

			<cfset Variables.companyListRedirect = Replace(Variables.queryViewAction_orderBy, "method=user.listUsers", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage & "&priceID=" & Form.priceID>
			<cfset Variables.formAction = "index.cfm?method=#URL.method#&priceID=#Form.priceID#">

			<cfif IsDefined("Form.categoryID") and IsNumeric(Form.categoryID)>
				<cfset Variables.formAction = Variables.formAction & "&categoryID=" & Form.categoryID>
				<cfset Variables.companyListRedirect = Variables.companyListRedirect & "&categoryID=" & Form.categoryID>
			</cfif>
			<cfif IsDefined("Form.productID") and IsNumeric(Form.productID)>
				<cfset Variables.formAction = Variables.formAction & "&productID=" & Form.productID>
				<cfset Variables.companyListRedirect = Variables.companyListRedirect & "&productID=" & Form.productID>
			</cfif>

			<cfset Variables.formName = "priceTargetUser">
			<cfset Variables.formSubmitName = "submitPriceTargetUser">
			<cfset Variables.formSubmitValue = Variables.lang_listUsers_title.formSubmitValue_priceTarget>

			<cfinclude template="../../view/v_user/form_userMember.cfm">
		</cfcase>

		<cfcase value="subscription.insertSubscriberNotify">
			<cfset Variables.columnHeaderList = Variables.lang_listUsers_title.insertSubscriberNotify & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfset Variables.userListRedirect = Replace(Variables.queryViewAction_orderBy, "method=user.listUsers", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage>

			<cfset Variables.formName = "insertSubscriberNotify">
			<cfset Variables.formAction = "index.cfm?method=#URL.method#&subscriberID=#URL.subscriberID#">
			<cfset Variables.formSubmitName = "submitInsertSubscriptionNotify">
			<cfset Variables.formSubmitValue = Variables.lang_listUsers_title.formSubmitValue_insertSubscriberNotify>

			<cfinclude template="../../view/v_user/form_userMember.cfm">
		</cfcase>

		<cfcase value="payflow.insertPayflowNotify">
			<cfset Variables.columnHeaderList = Variables.lang_listUsers_title.insertPayflowNotify & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfset Variables.userListRedirect = Replace(Variables.queryViewAction_orderBy, "method=user.listUsers", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage>

			<cfset Variables.formName = "insertPayflowNotify">
			<cfset Variables.formAction = "index.cfm?method=#URL.method#&payflowID=#URL.payflowID#">
			<cfset Variables.formSubmitName = "submitInsertPayflowNotify">
			<cfset Variables.formSubmitValue = Variables.lang_listUsers_title.formSubmitValue_insertPayflowNotify>

			<cfinclude template="../../view/v_user/form_userMember.cfm">
		</cfcase>

		<cfcase value="commission.insertCommissionTargetUser">
			<cfset Variables.columnHeaderList = Variables.lang_listUsers_title.insertCommissionTargetUser & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfset Variables.userListRedirect = Replace(Variables.queryViewAction_orderBy, "method=user.listUsers", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage><!---  & "&commissionID=" & Form.commissionID_not --->

			<cfset Variables.companyListRedirect = Replace(Variables.queryViewAction_orderBy, "method=user.listUsers", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage><!---  & "&commissionID=" & Form.commissionID_not --->
			<cfset Variables.formAction = "index.cfm?method=#URL.method#&commissionID=#Form.commissionID_not#">

			<cfset Variables.formName = "commissionTargetUser">
			<cfset Variables.formSubmitName = "submitCommissionTarget">
			<cfset Variables.formSubmitValue = Variables.lang_listUsers_title.formSubmitValue_insertCommissionTargetUser>

			<cfinclude template="../../view/v_user/form_userMember.cfm">
		</cfcase>

		<cfdefaultcase><!--- company.listUsers --->
			<cfif URL.control is "company" and IsDefined("Form.companyID")>
				<cfset Variables.viewUserAction = "index.cfm?method=company.viewUser&companyID=#Form.companyID#">
			<cfelse>
				<cfset Variables.viewUserAction = "index.cfm?method=user.viewUser">
			</cfif>

			<cfinclude template="../../view/v_user/dsp_selectUserList.cfm">
		</cfdefaultcase>
		</cfswitch>
	</cfif><!--- export results or display results in browser--->
</cfif>

