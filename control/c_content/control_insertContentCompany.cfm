<cfinvoke Component="#Application.billingMapping#data.ContentCompany" Method="selectContentCompanyList" ReturnVariable="qry_selectContentCompanyList">
	<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="languageID" Value="#URL.languageID#">
	<cfinvokeargument Name="contentCategoryID" Value="#URL.contentCategoryID#">
	<cfinvokeargument Name="contentCompanyStatus" Value="1">
</cfinvoke>

<cfif qry_selectContentCompanyList.RecordCount is 0>
	<cfset URL.error_content = "noContentListings">
	<cfinclude template="../../view/v_content/error_content.cfm">
<cfelse>
	<cfinclude template="formParam_insertContentCompany.cfm">
	<cfinvoke component="#Application.billingMapping#data.ContentCompany" method="maxlength_ContentCompany" returnVariable="maxlength_ContentCompany" />

	<cfinclude template="../../view/v_content/lang_insertContentCompany.cfm">
	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitContentCompany")>
		<cfinclude template="../../view/v_content/var_contentType_list.cfm">
		<cfinclude template="../../include/function/fn_IsValidEmail.cfm">
		<cfinclude template="formValidate_insertContentCompany.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfinclude template="../../view/error_formValidation.cfm">
		<cfelse>
			<cfset Variables.isOkToWriteFile = False>
			<cfif Find(".", ValueList(qry_selectContentCompanyList.contentFilename))>
				<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
					<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
				</cfinvoke>

				<cfif Application.billingSuperuserEnabled is False and qry_selectCompany.companyDirectory is "">
					<cfset Variables.companyDirectoryPath = Application.billingCustomerDirectoryPath>
					<cfset Variables.isOkToWriteFile = True>
				<cfelse>
					<cfset Variables.companyDirectoryPath = Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & qry_selectCompany.companyDirectory>
					<cfif qry_selectCompany.companyDirectory is not "" and DirectoryExists(Variables.companyDirectoryPath)>
						<cfset Variables.isOkToWriteFile = True>
					</cfif>
				</cfif>
			</cfif>

			<!--- update if no existing value or if changed --->
			<cfloop Query="qry_selectContentCompanyList">
				<cfif qry_selectContentCompanyList.contentCompanyStatus is ""
						or Compare(qry_selectContentCompanyList.contentCompanyText, Form['contentCompanyText#qry_selectContentCompanyList.contentID#']) is not 0>
					<cfinvoke Component="#Application.billingMapping#data.ContentCompany" Method="insertContentCompany" ReturnVariable="isContentCompanyInserted">
						<cfinvokeargument Name="contentID" Value="#qry_selectContentCompanyList.contentID#">
						<cfinvokeargument Name="companyID" Value="#Session.companyID#">
						<cfinvokeargument Name="languageID" Value="#URL.languageID#">
						<cfinvokeargument Name="userID" Value="#Session.userID#">
						<cfinvokeargument Name="contentCompanyStatus" Value="1">
						<cfif Not Application.fn_IsIntegerPositive(qry_selectContentCompanyList.contentCompanyOrder)>
							<cfinvokeargument Name="contentCompanyOrder" Value="1">
						<cfelse>
							<cfinvokeargument Name="contentCompanyOrder" Value="#IncrementValue(qry_selectContentCompanyList.contentCompanyOrder)#">
						</cfif>
						<cfinvokeargument Name="contentCompanyText" Value="#Form['contentCompanyText#qry_selectContentCompanyList.contentID#']#">
						<cfif qry_selectContentCompanyList.contentHtmlOk is 0>
							<cfinvokeargument Name="contentCompanyHtml" Value="0">
						<cfelse>
							<cfinvokeargument Name="contentCompanyHtml" Value="#Form['contentCompanyHtml#qry_selectContentCompanyList.contentID#']#">
						</cfif>
					</cfinvoke>
				</cfif>

				<cfif Variables.isOkToWriteFile is True and qry_selectContentCompanyList.contentFilename is not "">
					<cfset Variables.thisContentFilename = Variables.companyDirectoryPath & Application.billingFilePathSlash & qry_selectContentCompanyList.contentFilename>
					<cffile Action="Write"
						File="#Variables.thisContentFilename#"
						Output="#Trim(Form['contentCompanyText#qry_selectContentCompanyList.contentID#'])##Chr(10)#">
				</cfif>
			</cfloop>

			<cflocation url="index.cfm?method=content.#Variables.doAction#&contentCategoryID=#URL.contentCategoryID#&confirm_content=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>

	<cfset Variables.formAction = "index.cfm?method=content.#Variables.doAction#&contentCategoryID=#URL.contentCategoryID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateContent.formSubmitValue_insert>
	<cfinclude template="../../view/v_content/form_insertContentCompany.cfm">
</cfif>
