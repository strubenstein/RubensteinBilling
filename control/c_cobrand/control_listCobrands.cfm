<cfinclude template="formParam_listCobrands.cfm">

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("cobrandID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfset Variables.formName = "cobrandList">
<cfset Variables.formAction = "index.cfm?method=cobrand.listCobrands">

<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_cobrand/form_listCobrands.cfm">

<cfinclude template="../../view/v_cobrand/lang_listCobrands.cfm">
<cfinclude template="formValidate_listCobrands.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#&isFormSubmitted=True">
	<cfset qryParamStruct = StructNew()>

	<cfif IsDefined("URL.cobrandID") and URL.cobrandID is not 0>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&cobrandID=#URL.cobrandID#">
	</cfif>

	<cfset qryParamStruct.companyID_author = Session.companyID_author>
	<cfset qryParamStruct.method = URL.method>
	<cfloop Index="field" List="#Variables.fields_integerList#">
		<cfif IsDefined("Form.#field#") and Form[field] is not 0 and Application.fn_IsIntegerList(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="commissionID,commissionID_not,priceID,priceID_not">
		<cfif IsDefined("Form.#field#") and Application.fn_IsIntegerPositive(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&" & Replace(field, "_not", "", "ONE") & "=" & Form[field]>
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_boolean#">
		<cfif IsDefined("Form.#field#") and ListFind("0,1", Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#Form[field]#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_text#">
		<cfif IsDefined("Form.#field#") and Form[field] is not "">
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfloop Index="field" List="#Variables.fields_date#">
		<cfif IsDefined("Form.#field#") and IsDate(Form[field])>
			<cfset Variables.queryViewAction = Variables.queryViewAction & "&#field#=#URLEncodedFormat(Form[field])#">
			<cfset qryParamStruct[field] = Form[field]>
		</cfif>
	</cfloop>
	<cfif IsDefined("Form.cobrandIsExported") and (Form.cobrandIsExported is "" or ListFind("0,1", Form.cobrandIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&cobrandIsExported=#URLEncodedFormat(Form.cobrandIsExported)#">
		<cfset qryParamStruct.cobrandIsExported = Form.cobrandIsExported>
	</cfif>

	<cfset Variables.queryFirstLetter_field = "">
	<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
		<cfswitch expression="#Form.queryOrderBy#">
		<cfcase value="cobrandName,cobrandName_d"><cfset Variables.queryFirstLetter_field = "avCobrand.cobrandName"></cfcase>
		<cfcase value="cobrandCode,cobrandCode_d"><cfset Variables.queryFirstLetter_field = "avCobrand.cobrandCode"></cfcase>
		<cfcase value="cobrandID_custom,cobrandID_custom_d"><cfset Variables.queryFirstLetter_field = "avCobrand.cobrandID_custom"></cfcase>
		<cfcase value="cobrandTitle,cobrandTitle_d"><cfset Variables.queryFirstLetter_field = "avCobrand.cobrandTitle"></cfcase>
		<cfcase value="cobrandDomain,cobrandDomain_d"><cfset Variables.queryFirstLetter_field = "avCobrand.cobrandDomain"></cfcase>
		<cfcase value="cobrandDirectory,cobrandDirectory_d"><cfset Variables.queryFirstLetter_field = "avCobrand.cobrandDirectory"></cfcase>
		<cfcase value="companyName,companyName_d"><cfset Variables.queryFirstLetter_field = "avCompany.companyName"><cfset Variables.returnCompanyFields = True></cfcase>
		<cfcase value="lastName,lastName_d"><cfset Variables.queryFirstLetter_field = "avUser.lastName"><cfset Variables.returnUserFields = True></cfcase>
		<cfdefaultcase><cfset Form.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportCobrands")
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

	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList" ReturnVariable="qry_selectCobrandList" argumentCollection="#qryParamStruct#">
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
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="updateCobrandIsExported" ReturnVariable="isCobrandExportStatusUpdated">
			<cfinvokeargument Name="cobrandID" Value="#ValueList(qry_selectCobrandList.cobrandID)#">
			<cfinvokeargument Name="cobrandIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportCobrandList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_cobrand=updateCobrandIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#">
			<cfinvokeargument Name="returnCompanyFields" Value="True">
		</cfinvoke>

		<cfif Not ListFind("cobrandName,cobrandName_d,cobrandCode,cobrandCode_d,cobrandID_custom,cobrandID_custom_d,cobrandTitle,cobrandTitle_d,cobrandDomain,cobrandDomain_d,cobrandDirectory,cobrandDirectory_d,companyName,companyName_d,lastName,lastName_d", Form.queryOrderBy)>
			<cfset Variables.displayAlphabet = False>
			<cfset Variables.alphabetList = "">
		<cfelse>
			<cfif ListFind("companyName,companyName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avCompany.companyName">
			<cfelseif ListFind("lastName,lastName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avUser.lastName">
			<cfelse>
				<cfset Variables.alphabetField = "avCobrand." & ListFirst(Form.queryOrderBy, "_")>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList_alphabet" ReturnVariable="qry_selectCobrandList_alphabet" argumentCollection="#qryParamStruct#">
				<cfinvokeargument Name="alphabetField" Value="#Variables.alphabetField#">
			</cfinvoke>

			<cfset Variables.displayAlphabet = True>
			<cfset Variables.alphabetList = ValueList(qry_selectCobrandList_alphabet.firstLetter, "|")>

			<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
				<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrandList_alphabetPage" ReturnVariable="recordCountBeforeAlphabet" argumentCollection="#qryParamStruct#">
					<cfinvokeargument Name="queryFirstLetter" Value="#Form.queryFirstLetter#">
					<cfinvokeargument Name="queryFirstLetter_field" Value="#Variables.queryFirstLetter_field#">
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

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewCobrand,updateCobrand,viewCompany,viewUser")>

		<cfset Variables.columnHeaderList = "">
		<cfset Variables.columnOrderByList = "">

		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectCobrandList.cobrandID_custom))>
			<cfset Variables.displayCobrandID_custom = True>
			<cfset Variables.columnHeaderList = Variables.lang_listCobrands_title.cobrandID_custom & "^">
			<cfset Variables.columnOrderByList = "cobrandID_custom^">
		<cfelse>
			<cfset Variables.displayCobrandID_custom = False>
		</cfif>

		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectCobrandList.cobrandCode))>
			<cfset Variables.displayCobrandCode = True>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listCobrands_title.cobrandCode & "^">
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "cobrandCode^">
		<cfelse>
			<cfset Variables.displayCobrandCode = False>
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCobrands_title.cobrandName
				& "^" & Variables.lang_listCobrands_title.companyName
				& "^" & Variables.lang_listCobrands_title.lastName
				& "^" & Variables.lang_listCobrands_title.cobrandDateCreated>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "cobrandName^companyName^lastName^cobrandDateCreated"><!--- ^cobrandStatus --->

		<cfif ListFind(Variables.permissionActionList, "viewCobrand")>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listCobrands_title.viewCobrand>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
			<cfif URL.control is "company">
				<cfset Variables.manageControl = "company">
			<cfelse>
				<cfset Variables.manageControl = "cobrand">
			</cfif>
		</cfif>

		<cfswitch expression="#URL.method#">
		<cfcase value="group.listGroupCobrand">
			<cfset Variables.formAction = Variables.queryViewAction>
			<cfset Variables.formSubmitName = "submitGroupTargetDelete">
			<cfset Variables.formSubmitValue = Variables.lang_listCobrands_title.formSubmitValue_listGroupCobrand>
			<cfset Variables.columnHeaderList = Variables.lang_listCobrands_title.submitGroupTargetDelete & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfcase value="group.insertGroupCobrand">
			<cfset Variables.formAction = Variables.queryViewAction>
			<cfset Variables.formSubmitName = "submitGroupTargetInsert">
			<cfset Variables.formSubmitValue = Variables.lang_listCobrands_title.formSubmitValue_insertGroupCobrand>
			<cfset Variables.columnHeaderList = Variables.lang_listCobrands_title.submitGroupTargetInsert & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfcase value="commission.insertCommissionTargetCobrand">
			<cfset Variables.formAction = Replace(Variables.queryViewAction, "commissionID_not=", "commissionID=", "ONE")>
			<cfset Variables.formSubmitName = "submitCommissionTarget">
			<cfset Variables.formSubmitValue = Variables.lang_listCobrands_title.formSubmitValue_insertCommissionTargetCobrand>
			<cfset Variables.columnHeaderList = Variables.lang_listCobrands_title.insertCommissionTargetCobrand & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfcase value="price.insertPriceTargetCobrand">
			<cfset Variables.formAction = Replace(Variables.queryViewAction, "priceID_not=", "priceID=", "ONE")>
			<cfset Variables.formSubmitName = "submitPriceTarget">
			<cfset Variables.formSubmitValue = Variables.lang_listCobrands_title.formSubmitValue_insertPriceTargetCobrand>
			<cfset Variables.columnHeaderList = Variables.lang_listCobrands_title.insertPriceTargetCobrand & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfdefaultcase>
			<cfset Variables.formAction = "">
			<cfset Variables.formSubmitValue = "">
		</cfdefaultcase>
		</cfswitch>

		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfinclude template="../../view/v_cobrand/dsp_selectCobrandList.cfm">
	</cfif><!--- export results or display results in browser--->
</cfif>

