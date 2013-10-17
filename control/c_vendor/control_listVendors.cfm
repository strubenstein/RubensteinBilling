<cfinclude template="formParam_listVendors.cfm">

<cfinvoke Component="#Application.billingMapping#data.Status" Method="selectStatusList" ReturnVariable="qry_selectStatusList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("vendorID")#">
	<cfinvokeargument Name="statusStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfset Variables.formName = "vendorList">
<cfset Variables.formAction = "index.cfm?method=vendor.listVendors">

<cfinclude template="../../include/function/fn_listObjects.cfm">
<cfinclude template="../../view/v_vendor/form_listVendors.cfm">

<cfinclude template="../../view/v_vendor/lang_listVendors.cfm">
<cfinclude template="formValidate_listVendors.cfm">

<cfif isAllFormFieldsOk is False>
	<cfinclude template="../../view/error_formValidation.cfm">
<cfelse>
	<cfset Variables.queryViewAction = "index.cfm?method=#URL.method#&queryDisplayPerPage=#Form.queryDisplayPerPage#&isFormSubmitted=True">
	<cfset qryParamStruct = StructNew()>

	<cfif IsDefined("URL.vendorID") and URL.vendorID is not 0>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&vendorID=#URL.vendorID#">
	</cfif>

	<cfset qryParamStruct.companyID_author = Session.companyID_author>
	<cfset qryParamStruct.method = URL.method>
	<cfloop Index="field" List="#Variables.fields_integerList#">
		<cfif IsDefined("Form.#field#") and Form[field] is not 0 and Application.fn_IsIntegerList(Form[field])>
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
	<cfif IsDefined("Form.vendorIsExported") and (Form.vendorIsExported is "" or ListFind("0,1", Form.vendorIsExported))>
		<cfset Variables.queryViewAction = Variables.queryViewAction & "&vendorIsExported=#URLEncodedFormat(Form.vendorIsExported)#">
		<cfset qryParamStruct.vendorIsExported = Form.vendorIsExported>
	</cfif>

	<cfset Variables.queryFirstLetter_field = "">
	<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
		<cfswitch expression="#Form.queryOrderBy#">
		<cfcase value="vendorName,vendorName_d"><cfset Variables.queryFirstLetter_field = "avVendor.vendorName"></cfcase>
		<cfcase value="vendorCode,vendorCode_d"><cfset Variables.queryFirstLetter_field = "avVendor.vendorCode"></cfcase>
		<cfcase value="vendorID_custom,vendorID_custom_d"><cfset Variables.queryFirstLetter_field = "avVendor.vendorID_custom"></cfcase>
		<cfcase value="companyName,companyName_d"><cfset Variables.queryFirstLetter_field = "avCompany.companyName"><cfset Arguments.returnCompanyFields = True></cfcase>
		<cfcase value="lastName,lastName_d"><cfset Variables.queryFirstLetter_field = "avUser.lastName"><cfset Arguments.returnUserFields = True></cfcase>
		<cfdefaultcase><cfset Form.queryFirstLetter = ""></cfdefaultcase>
		</cfswitch>
	</cfif>

	<!--- Determine whether results are being displayed or exported --->
	<cfset Variables.exportResults = False>
	<cfset Variables.updateExportStatus = False>
	<cfif IsDefined("Form.submitExportResults") and Application.fn_IsUserAuthorized("exportVendors")
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

	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList" argumentCollection="#qryParamStruct#">
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
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="updateVendorIsExported" ReturnVariable="isVendorExportStatusUpdated">
			<cfinvokeargument Name="vendorID" Value="#ValueList(qry_selectVendorList.vendorID)#">
			<cfinvokeargument Name="vendorIsExported" Value="#Form.targetIsExported#">
		</cfinvoke>
	</cfif>

	<!--- export results --->
	<cfif Variables.exportResults is True>
		<cfinclude template="act_exportVendorList.cfm">

	<!--- reload list after updating exporting status --->
	<cfelseif Variables.updateExportStatus is True>
		<cflocation url="#Variables.queryViewAction#&queryOrderBy=#Form.queryOrderBy#&confirm_vendor=updateVendorIsExported" AddToken="No">

	<!--- display results in browser --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorCount" ReturnVariable="qryTotalRecords" argumentCollection="#qryParamStruct#">
			<cfinvokeargument Name="returnCompanyFields" Value="True">
		</cfinvoke>

		<cfif Not ListFind("vendorName,vendorName_d,vendorCode,vendorCode_d,vendorID_custom,vendorID_custom_d,companyName,companyName_d,lastName,lastName_d", Form.queryOrderBy)>
			<cfset Variables.displayAlphabet = False>
			<cfset Variables.alphabetList = "">
		<cfelse>
			<cfif ListFind("companyName,companyName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avCompany.companyName">
			<cfelseif ListFind("lastName,lastName_d", Form.queryOrderBy)>
				<cfset Variables.alphabetField = "avUser.lastName">
			<cfelse>
				<cfset Variables.alphabetField = "avVendor." & ListFirst(Form.queryOrderBy, "_")>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList_alphabet" ReturnVariable="qry_selectVendorList_alphabet" argumentCollection="#qryParamStruct#">
				<cfinvokeargument Name="alphabetField" Value="#Variables.alphabetField#">
			</cfinvoke>

			<cfset Variables.displayAlphabet = True>
			<cfset Variables.alphabetList = ValueList(qry_selectVendorList_alphabet.firstLetter, "|")>

			<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
				<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList_alphabetPage" ReturnVariable="recordCountBeforeAlphabet" argumentCollection="#qryParamStruct#">
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

		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewVendor,updateVendor,viewCompany,viewUser")>

		<cfset Variables.columnHeaderList = "">
		<cfset Variables.columnOrderByList = "">

		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectVendorList.vendorID_custom))>
			<cfset Variables.displayVendorID_custom = True>
			<cfset Variables.columnHeaderList = Variables.lang_listVendors_title.vendorID_custom & "^">
			<cfset Variables.columnOrderByList = "vendorID_custom^">
		<cfelse>
			<cfset Variables.displayVendorID_custom = False>
		</cfif>

		<cfif REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectVendorList.vendorCode))>
			<cfset Variables.displayVendorCode = True>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listVendors_title.vendorCode & "^">
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "vendorCode^">
		<cfelse>
			<cfset Variables.displayVendorCode = False>
		</cfif>

		<cfset Variables.columnHeaderList = Variables.columnHeaderList & Variables.lang_listVendors_title.vendorName
				& "^" & Variables.lang_listVendors_title.companyName
				& "^" & Variables.lang_listVendors_title.lastName
				& "^" & Variables.lang_listVendors_title.vendorDateCreated>
		<cfset Variables.columnOrderByList = Variables.columnOrderByList & "vendorName^companyName^lastName^vendorDateCreated">

		<cfif ListFind(Variables.permissionActionList, "viewVendor")>
			<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listVendors_title.viewVendor>
			<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
			<cfif URL.control is "company">
				<cfset Variables.manageControl = "company">
			<cfelse>
				<cfset Variables.manageControl = "vendor">
			</cfif>
		</cfif>

		<cfswitch expression="#URL.method#">
		<cfcase value="group.listGroupVendor">
			<cfset Variables.formAction = Variables.queryViewAction>
			<cfset Variables.formSubmitName = "submitGroupTargetDelete">
			<cfset Variables.formSubmitValue = Variables.lang_listVendors_title.formSubmitValue_listGroupVendor>
			<cfset Variables.columnHeaderList = Variables.lang_listVendors_title.listGroupVendor & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfcase value="group.insertGroupVendor">
			<cfset Variables.formAction = Variables.queryViewAction>
			<cfset Variables.formSubmitName = "submitGroupTargetInsert">
			<cfset Variables.formSubmitValue = Variables.lang_listVendors_title.formSubmitValue_insertGroupVendor>
			<cfset Variables.columnHeaderList = Variables.lang_listVendors_title.insertGroupVendor & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfcase value="commission.insertCommissionTargetVendor">
			<cfset Variables.formAction = Replace(Variables.queryViewAction, "commissionID_not=", "commissionID=", "ONE")>
			<cfset Variables.formSubmitName = "submitCommissionTarget">
			<cfset Variables.formSubmitValue = Variables.lang_listVendors_title.formSubmitValue_insertCommissionTargetVendor>
			<cfset Variables.columnHeaderList = Variables.lang_listVendors_title.insertCommissionTargetVendor & "^" & Variables.columnHeaderList>
			<cfset Variables.columnOrderByList = "False^" & Variables.columnOrderByList>
		</cfcase>
		<cfdefaultcase>
			<cfset Variables.formAction = "">
			<cfset Variables.formSubmitValue = "">
		</cfdefaultcase>
		</cfswitch>

		<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

		<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
		<cfinclude template="../../view/v_vendor/dsp_selectVendorList.cfm">
	</cfif><!--- export results or display results in browser--->
</cfif>

