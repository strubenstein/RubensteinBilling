<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList_order">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="categoryOrderByManual" Value="True">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
	<cfinvokeargument Name="companyID" Value="0,#Session.companyID_author#">
	<cfinvokeargument Name="templateStatus" Value="1">
	<cfinvokeargument Name="templateType" Value="Category">
</cfinvoke>

<cfset URL.categoryID = 0>
<cfinclude template="formParam_insertUpdateCategory.cfm">
<cfinvoke component="#Application.billingMapping#data.Category" method="maxlength_Category" returnVariable="maxlength_Category" />

<cfinclude template="../../view/v_category/lang_insertUpdateCategory.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertUpdateCategory")>
	<cfinclude template="formValidate_insertUpdateCategory.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfset Form.companyID = Session.companyID>
		<cfset Form.userID = Session.userID>

		<cfset Form.headerFooterID_header = 0>
		<cfset Form.headerFooterID_footer = 0>

		<cfif Form.categoryOrder_manual is 0>
			<cfif Not REFind("[1-9]", ValueList(qry_selectCategoryList.categoryOrder_manual))>
				<cfset Form.categoryOrder_manual = 1>
			<cfelse>
				<cfset Form.categoryOrder_manual = 1 + ListFirst(ListSort(ValueList(qry_selectCategoryList.categoryOrder_manual), "numeric", "desc"))>
			</cfif>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Category" Method="insertCategory" ReturnVariable="newCategoryID">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="categoryCode" Value="#Form.categoryCode#">
			<cfinvokeargument Name="categoryName" Value="#Form.categoryName#">
			<cfinvokeargument Name="categoryDescription" Value="#Form.categoryDescription#">
			<cfinvokeargument Name="categoryTitle" Value="#Form.categoryTitle#">
			<cfinvokeargument Name="categoryOrder_manual" Value="#Form.categoryOrder_manual#">
			<cfinvokeargument Name="categoryStatus" Value="#Form.categoryStatus#">
			<cfinvokeargument Name="categoryID_parent" Value="#Form.categoryID_parent#">
			<cfinvokeargument Name="categoryAcceptListing" Value="#Form.categoryAcceptListing#">
			<cfinvokeargument Name="categoryIsListed" Value="#Form.categoryIsListed#">
			<cfinvokeargument Name="categoryItemsPerPage" Value="#Form.categoryItemsPerPage#">
			<cfinvokeargument Name="categoryNumberOfPages" Value="#Form.categoryNumberOfPages#">
			<cfinvokeargument Name="headerFooterID_header" Value="#Form.headerFooterID_header#">
			<cfinvokeargument Name="headerFooterID_footer" Value="#Form.headerFooterID_footer#">
			<cfinvokeargument Name="templateFilename" Value="#Form.templateFilename#">
		</cfinvoke>

		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("categoryID")>
		<cfif Trim(Form.categoryHeader) is not "">
			<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="insertHeaderFooter" ReturnVariable="newHeaderID">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#newCategoryID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="languageID" Value="">
				<cfinvokeargument Name="headerFooterStatus" Value="1">
				<cfinvokeargument Name="headerFooterText" Value="#Trim(Form.categoryHeader)#">
				<cfinvokeargument Name="headerFooterHtml" Value="#Form.categoryHeaderHtml#">
				<cfinvokeargument Name="headerFooterIndicator" Value="0">
			</cfinvoke>
			<cfset Form.headerFooterID_header = newHeaderID>
		</cfif>

		<cfif Trim(Form.categoryFooter) is not "">
			<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="insertHeaderFooter" ReturnVariable="newFooterID">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#newCategoryID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="languageID" Value="">
				<cfinvokeargument Name="headerFooterStatus" Value="1">
				<cfinvokeargument Name="headerFooterText" Value="#Trim(Form.categoryFooter)#">
				<cfinvokeargument Name="headerFooterHtml" Value="#Form.categoryFooterHtml#">
				<cfinvokeargument Name="headerFooterIndicator" Value="1">
			</cfinvoke>
			<cfset Form.headerFooterID_footer = newFooterID>
		</cfif>

		<cfif Form.headerFooterID_header is not 0 or Form.headerFooterID_footer is not 0>
			<cfinvoke Component="#Application.billingMapping#data.Category" Method="updateCategory" ReturnVariable="isUpdated">
				<cfinvokeargument Name="categoryID" Value="#newCategoryID#">
				<cfinvokeargument Name="headerFooterID_header" Value="#Form.headerFooterID_header#">
				<cfinvokeargument Name="headerFooterID_footer" Value="#Form.headerFooterID_footer#">
			</cfinvoke>
		</cfif>

		<cflocation url="#Variables.doURL#&confirm_category=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = Variables.doURL>
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateCategory.formSubmitValue_insert>
<cfinclude template="../../view/v_category/form_insertUpdateCategory.cfm">
