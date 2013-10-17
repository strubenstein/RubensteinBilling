<cfinclude template="formParam_listAffiliates.cfm">

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("affiliateID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfset Variables.formName = "affiliateList">
<cfset Variables.formAction = "index.cfm?method=affiliate.listAffiliates">

<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_affiliate/form_listAffiliates.cfm">

<cfinclude template="../../view/v_affiliate/lang_listAffiliates.cfm">
<cfinclude template="formValidate_listAffiliates.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#&isFormSubmitted=True">
	<cfset qryParamStruct = StructNew()>

	<cfif IsDefined("URL.affiliateID") and URL.affiliateID is not 0>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&affiliateID=#URL.affiliateID#">
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
	<cfif IsDefined("Form.affiliateIsExported") and (Form.affiliateIsExported is "" or ListFind("0,1", Form.affiliateIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&affiliateIsExported=#URLEncodedFormat(Form.affiliateIsExported)#">
		<cfset qryParamStruct.affiliateIsExported = Form.affiliateIsExported>
	</cfif>

	<cfset Variables.queryFirstLetter_field = "">
	<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
		<cfswitch expression="#Form.queryOrderBy#">
		<cfcase value="affiliateName,affiliateName_d"><cfset Variables.queryFirstLetter_field = "avAffiliate.affiliateName"></cfcase>
		<cfcase value="affiliateCode,affiliateCode_d"><cfset Variables.queryFirstLetter_field = "avAffiliate.affiliateCode"></cfcase>
		<cfcase value="affiliateID_custom,affiliateID_custom_d"><cfset Variables.queryFirstLetter_field = "avAffiliate.affiliateID_custom"></cfcase>
		<cfcase value="companyName,companyName_d"><cfset Variables.queryFirstLetter_field = "avCompany.companyName"><cfset Variables.returnCompanyFields = True></cfcase>
		<cfcase value="lastName,lastName_d"><cfset Variables.queryFirstLetter_field = "avUser.lastName"><cfset Variables.returnUserFields = True></cfcase>
		<cfdefaultcase><cfset Form.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportAffiliates")
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

	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList" ReturnVariable="qry_selectAffiliateList" argumentCollection="#qryParamStruct#">
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
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="updateAffiliateIsExported" ReturnVariable="isAffiliateExportStatusUpdated">
			<cfinvokeargument Name="affiliateID" Value="#ValueList(qry_selectAffiliateList.affiliateID)#">
			<cfinvokeargument Name="affiliateIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportAffiliateList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_affiliate=updateAffiliateIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#">
			<cfinvokeargument Name="returnCompanyFields" Value="True">
		</cfinvoke>

		<cfif Not ListFind("affiliateName,affiliateName_d,affiliateCode,affiliateCode_d,affiliateID_custom,affiliateID_custom_d,companyName,companyName_d,lastName,lastName_d", Form.queryOrderBy)>
			<cfset Variables.displayAlphabet = False>
			<cfset Variables.alphabetList = "">
		<cfelse>
			<cfif ListFind("companyName,companyName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avCompany.companyName">
			<cfelseif ListFind("lastName,lastName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avUser.lastName">
			<cfelse>
				<cfset Variables.alphabetField = "avAffiliate." & ListFirst(Form.queryOrderBy, "_")>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList_alphabet" ReturnVariable="qry_selectAffiliateList_alphabet" argumentCollection="#qryParamStruct#">
				<cfinvokeargument Name="alphabetField" Value="#Variables.alphabetField#">
			</cfinvoke>

			<cfset Variables.displayAlphabet = True>
			<cfset Variables.alphabetList = ValueList(qry_selectAffiliateList_alphabet.firstLetter, "|")>

			<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
				<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliateList_alphabetPage" ReturnVariable="recordCountBeforeAlphabet" argumentCollection="#qryParamStruct#">
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

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewAffiliate,updateAffiliate,viewCompany,viewUser")>

		<cfset Variables.columnHeaderList = "">
		<cfset Variables.columnOrderByList = "">

		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectAffiliateList.affiliateID_custom))>
			<cfset Variables.displayAffiliateID_custom = True>
			<cfset Variables.columnHeaderList = Variables.lang_listAffiliates_title.affiliateID_custom & "^">
			<cfset Variables.columnOrderByList = "affiliateID_custom^">
		<cfelse>
			<cfset Variables.displayAffiliateID_custom = False>
		</cfif>

		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectAffiliateList.affiliateCode))>
			<cfset Variables.displayAffiliateCode = True>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listAffiliates_title.affiliateCode & "^">
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "affiliateCode^">
		<cfelse>
			<cfset Variables.displayAffiliateCode = False>
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listAffiliates_title.affiliateName
				& "^" & Variables.lang_listAffiliates_title.companyName
				& "^" & Variables.lang_listAffiliates_title.lastName
				& "^" & Variables.lang_listAffiliates_title.affiliateDateCreated>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "affiliateName^companyName^lastName^affiliateDateCreated">

		<cfif ListFind(Variables.permissionActionList, "viewAffiliate")>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listAffiliates_title.viewAffiliate>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
			<cfif URL.control is "company">
				<cfset Variables.manageControl = "company">
			<cfelse>
				<cfset Variables.manageControl = "affiliate">
			</cfif>
		</cfif>

		<cfswitch expression="#URL.method#">
		<cfcase value="group.listGroupAffiliate">
			<cfset Variables.formAction = Variables.queryViewAction>
			<cfset Variables.formSubmitName = "submitGroupTargetDelete">
			<cfset Variables.formSubmitValue = Variables.lang_listAffiliates_title.formSubmitValue_listGroupAffiliate>
			<cfset Variables.columnHeaderList = Variables.lang_listAffiliates_title.submitGroupTargetDelete & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfcase value="group.insertGroupAffiliate">
			<cfset Variables.formAction = Variables.queryViewAction>
			<cfset Variables.formSubmitName = "submitGroupTargetInsert">
			<cfset Variables.formSubmitValue = Variables.lang_listAffiliates_title.formSubmitValue_insertGroupAffiliate>
			<cfset Variables.columnHeaderList = Variables.lang_listAffiliates_title.submitGroupTargetInsert & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfcase value="commission.insertCommissionTargetAffiliate">
			<cfset Variables.formAction = Replace(Variables.queryViewAction, "commissionID_not=", "commissionID=", "ONE")>
			<cfset Variables.formSubmitName = "submitCommissionTarget">
			<cfset Variables.formSubmitValue = Variables.lang_listAffiliates_title.formSubmitValue_insertCommissionTargetAffiliate>
			<cfset Variables.columnHeaderList = Variables.lang_listAffiliates_title.submitCommissionTarget & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfcase value="price.insertPriceTargetAffiliate">
			<cfset Variables.formAction = Replace(Variables.queryViewAction, "priceID_not=", "priceID=", "ONE")>
			<cfset Variables.formSubmitName = "submitPriceTarget">
			<cfset Variables.formSubmitValue = Variables.lang_listAffiliates_title.formSubmitValue_insertPriceTargetAffiliate>
			<cfset Variables.columnHeaderList = Variables.lang_listAffiliates_title.submitPriceTarget & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfdefaultcase>
			<cfset Variables.formAction = "">
			<cfset Variables.formSubmitValue = "">
		</cfdefaultcase>
		</cfswitch>

		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfinclude template="../../view/v_affiliate/dsp_selectAffiliateList.cfm">
	</cfif><!--- export results or display results in browser--->
</cfif>

