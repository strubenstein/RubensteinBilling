<cfinclude template="formParam_listCompanies.cfm">

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

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("companyID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfif URL.control is "group" and IsDefined("URL.groupID")>
	<cfset Variables.formAction = "index.cfm?method=#URL.method#&groupID=#URL.groupID#">
<cfelseif URL.control is "payflow" and IsDefined("URL.payflowID")>
	<cfset Variables.formAction = "index.cfm?method=#URL.method#&payflowID=#URL.payflowID#">
</cfif>

<cfset Variables.formName = "companyList">
<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_company/form_listCompanies.cfm">

<cfinclude template="../../view/v_company/lang_listCompanies.cfm">
<cfinclude template="formValidate_listCompanies.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#&isFormSubmitted=True">
	<cfif IsDefined("URL.companyID") and URL.companyID is not 0>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&companyID=#URL.companyID#">
	</cfif>

	<!--- determine query parameters --->
	<cfset qryParamStruct = StructNew()>
	<cfset qryParamStruct.companyID_author = Session.companyID_author>
	<cfset qryParamStruct.method = URL.method>
	<cfif IsDefined("Form.companyID_not") and Form.companyID_not is not "" and Application.fn_IsIntegerList(Form.companyID_not)>
		<cfset qryParamStruct.companyID_not = Form.companyID_not>
	</cfif>
	<cfloop Index="field" List="groupID,affiliateID,cobrandID,statusID,payflowID,payflowID_not">
		<cfif IsDefined("Form.#field#") and Form[field] is not "" and Application.fn_IsIntegerList(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="commissionID,commissionID_not">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerPositive(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&commissionID=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_boolean#">
		<cfif IsDefined("Form.#field#") and Form[field] is not "" and ListFind("0,1", Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="searchText,searchField">
		<cfif IsDefined("Form.#field#") and Form[field] is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif URL.action is "insertPriceTargetCompany">
		<cfset qryParamStruct.priceID = URL.priceID>
		<cfif URL.control is "product">
			<cfset qryParamStruct.productID = URL.productID>
		<cfelseif URL.control is "category">
			<cfset qryParamStruct.categoryID = URL.categoryID>
		</cfif>
	</cfif>
	<cfif IsDefined("Form.companyIsExported") and (Form.companyIsExported is "" or ListFind("0,1", Form.companyIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&companyIsExported=#URLEncodedFormat(Form.companyIsExported)#">
		<cfset qryParamStruct.companyIsExported = Form.companyIsExported>
	</cfif>
	<cfloop Index="field" List="companyDateExported_from,companyDateExported_to">
		<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<!--- /determine query parameters --->

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportCompanies")
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

	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompanyList" ReturnVariable="qry_selectCompanyList" argumentCollection="#qryParamStruct#">
		<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
		<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
		<cfinvokeargument Name="queryPage" Value="#Form.queryPage#">
		<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
			<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
		</cfif>
	</cfinvoke>

	<!--- update export status of all results --->
	<cfif Variables.updateExportStatus is True>
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompanyIsExported" ReturnVariable="isCompanyExportStatusUpdated">
			<cfinvokeargument Name="companyID" Value="#ValueList(qry_selectCompanyList.companyID)#">
			<cfinvokeargument Name="companyIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportCompanyList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_company=updateCompanyIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompanyCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#" />

		<cfif Not ListFind("companyName,companyName_d", Form.queryOrderBy)>
			<cfset Variables.displayAlphabet = False>
			<cfset Variables.alphabetList = "">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompanyList_alphabet" ReturnVariable="qry_selectCompanyList_alphabet" argumentCollection="#qryParamStruct#" />

			<cfset Variables.displayAlphabet = True>
			<cfset Variables.alphabetList = ValueList(qry_selectCompanyList_alphabet.firstLetter, "|")>
		
			<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
				<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompanyList_alphabetPage" ReturnVariable="recordCountBeforeAlphabet" argumentCollection="#qryParamStruct#">
					<cfinvokeargument Name="queryOrderBy" Value="#Form.queryOrderBy#">
					<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
					<cfinvokeargument Name="queryDisplayPerPage" Value="#Form.queryDisplayPerPage#">
				</cfinvoke>

				<cfset Form.queryPage = 1 + (recordCountBeforeAlphabet \ Form.queryDisplayPerPage)>
			</cfif>
		</cfif>

		<cfset Variables.queryViewAction_orderBy = Variables.queryViewAction & "&queryOrderBy=#URLEncodedFormat(Form.queryOrderBy)#">
		<cfset Variables.firstRecord = (Form.queryDisplayPerPage * DecrementValue(Form.queryPage)) + 1>
		<cfset Variables.totalRecords = qryTotalRecords>
		<cfset Variables.lastRecord = Min(Form.queryDisplayPerPage * Form.queryPage, Variables.totalRecords)>
		<cfif (Variables.totalRecords mod Form.queryDisplayPerPage) is 0>
			<cfset Variables.totalPages = Variables.totalRecords \ Form.queryDisplayPerPage>
		<cfelse>
			<cfset Variables.totalPages = (Variables.totalRecords \ Form.queryDisplayPerPage) + 1>
		</cfif>

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

		<cfif REFind("[1-9]", ValueList(qry_selectCompanyList.cobrandID))>
			<cfset Variables.displayPartner = True>
		<cfelseif REFind("[1-9]", ValueList(qry_selectCompanyList.affiliateID))>
			<cfset Variables.displayPartner = True>
		<cfelse>
			<cfset Variables.displayPartner = False>
		</cfif>

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCompany,viewUser")>

		<cfset Variables.columnHeaderList = "">
		<cfset Variables.columnOrderByList = "">

		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectCompanyList.companyID_custom))>
			<cfset Variables.displayCompanyID_custom = True>
			<cfset Variables.columnHeaderList = Variables.lang_listCompanies_title.companyID_custom & "^">
			<cfset Variables.columnOrderByList = "companyID_custom^">
		<cfelse>
			<cfset Variables.displayCompanyID_custom = False>
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listCompanies_title.companyName
				& "^" & Variables.lang_listCompanies_title.lastName>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "companyName^lastName">

		<cfif Variables.displayPartner is True>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCompanies_title.affiliateCobrandName>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCompanies_title.companyType
				& "^" & Variables.lang_listCompanies_title.companyDateCreated>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False^companyDateCreated">

		<cfif ListFind(Variables.permissionActionList, "viewCompany")>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCompanies_title.viewCompany>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
		</cfif>

		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

		<cfset Variables.struct_selectAffiliateList = StructNew()>
		<cfif IsDefined("qry_selectAffiliateList")>
			<cfloop Query="qry_selectAffiliateList">
				<cfset Variables.struct_selectAffiliateList["affiliate#qry_selectAffiliateList.affiliateID#"] = qry_selectAffiliateList.affiliateName>
			</cfloop>
		</cfif>

		<cfset Variables.struct_selectCobrandList = StructNew()>
		<cfif IsDefined("qry_selectCobrandList")>
			<cfloop Query="qry_selectCobrandList">
				<cfset Variables.struct_selectCobrandList["cobrand#qry_selectCobrandList.cobrandID#"] = qry_selectCobrandList.cobrandName>
			</cfloop>
		</cfif>

		<cfswitch expression="#URL.control#">
		<cfcase value="group">
			<cfif URL.method is "group.listGroupCompany">
				<cfset Variables.columnHeaderList = Variables.lang_listCompanies_title.deleteGroupCompany & "^" & Variables.columnHeaderList>
			<cfelse>
				<cfset Variables.columnHeaderList = Variables.lang_listCompanies_title.insertGroupCompany & "^" & Variables.columnHeaderList>
			</cfif>

			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfset Variables.companyListRedirect = Replace(Variables.queryViewAction_orderBy, "method=company.listCompanies", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage>

			<cfset Variables.formAction = "index.cfm?method=#URL.method#&groupID=#URL.groupID#">
			<cfset Variables.formName = "groupCompany">
			<cfif URL.method is "group.insertGroupCompany">
				<cfset Variables.formSubmitName = "submitGroupCompanyInsert">
				<cfset Variables.formSubmitValue = Variables.lang_listCompanies_title.submitGroupCompanyInsert>
			<cfelse><!--- group.listGroupCompany --->
				<cfset Variables.formSubmitName = "submitGroupCompanyDelete">
				<cfset Variables.formSubmitValue = Variables.lang_listCompanies_title.submitGroupCompanyDelete>
			</cfif>

			<cfinclude template="../../view/v_company/form_companyMember.cfm">
		</cfcase>

		<cfcase value="category,product,price">
			<cfset Variables.columnHeaderList = Variables.lang_listCompanies_title.companyPriceTarget & "^" & Variables.columnHeaderList>

			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfset Variables.companyListRedirect = Replace(Variables.queryViewAction_orderBy, "method=company.listCompanies", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage & "&priceID=" & Form.priceID>
			<cfset Variables.formAction = "index.cfm?method=#URL.method#&priceID=#URL.priceID#">

			<cfif IsDefined("URL.categoryID") and Application.fn_IsIntegerNonNegative(URL.categoryID)>
				<cfset Variables.formAction = Variables.formAction & "&categoryID=" & URL.categoryID>
				<cfset Variables.companyListRedirect = Variables.companyListRedirect & "&categoryID=" & URL.categoryID>
			</cfif>
			<cfif IsDefined("URL.productID") and Application.fn_IsIntegerNonNegative(URL.productID)>
				<cfset Variables.formAction = Variables.formAction & "&productID=" & URL.productID>
				<cfset Variables.companyListRedirect = Variables.companyListRedirect & "&productID=" & URL.productID>
			</cfif>

			<cfset Variables.formName = "priceTargetCompany">
			<cfset Variables.formSubmitName = "submitPriceTargetCompany">
			<cfset Variables.formSubmitValue = Variables.lang_listCompanies_title.submitPriceTargetCompany>

			<cfinclude template="../../view/v_company/form_companyMember.cfm">
		</cfcase>

		<cfcase value="commission">
			<cfset Variables.columnHeaderList = Variables.lang_listCompanies_title.companyCommissionTarget & "^" & Variables.columnHeaderList>

			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
			<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
			<cfset Variables.companyListRedirect = Replace(Variables.queryViewAction_orderBy, "method=company.listCompanies", "method=#URL.method#", "ONE") & "&queryPage=" & Form.queryPage>

			<cfif IsDefined("Form.commissionID_not")>
				<cfset Variables.formAction = "index.cfm?method=#URL.method#&commissionID=#Form.commissionID_not#">
				<cfset Variables.companyListRedirect = Variables.companyListRedirect><!---  & "&commissionID=#Form.commissionID_not#" --->
			<cfelse>
				<cfset Variables.formAction = "index.cfm?method=#URL.method#&commissionID=#Form.commissionID#">
			</cfif>

			<cfset Variables.formName = "commissionTargetCompany">
			<cfset Variables.formSubmitName = "submitCommissionTarget">
			<cfset Variables.formSubmitValue = Variables.lang_listCompanies_title.submitCommissionTarget>

			<cfinclude template="../../view/v_company/form_companyMember.cfm">
		</cfcase>

		<cfdefaultcase><!--- company --->
			<cfinclude template="../../view/v_company/dsp_selectCompanyList.cfm">
		</cfdefaultcase>
		</cfswitch>
	</cfif><!--- export results or display results in browser--->
</cfif>

