<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategory" ReturnVariable="qry_selectCategory">
	<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
</cfinvoke>

<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("categoryID")>
<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="selectHeaderFooter" ReturnVariable="qry_selectHeaderFooter">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#URL.categoryID#">
	<cfinvokeargument Name="headerFooterStatus" Value="1">
</cfinvoke>

<cfinclude template="formParam_insertUpdateCategory.cfm">
<cfinvoke component="#Application.billingMapping#data.Category" method="maxlength_Category" returnVariable="maxlength_Category" />

<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
	<cfinvokeargument Name="companyID" Value="0,#Session.companyID_author#">
	<cfinvokeargument Name="templateStatus" Value="1">
	<cfinvokeargument Name="templateType" Value="Category">
</cfinvoke>

<cfinclude template="../../view/v_category/lang_insertUpdateCategory.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertUpdateCategory")>
	<cfinclude template="formValidate_insertUpdateCategory.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfset Form.headerFooterID_header = 0>
		<cfset Form.headerFooterID_footer = 0>

		<cfif Form.categoryHeader is not Form.categoryHeader_orig or Form.categoryHeaderHtml is not Form.categoryHeaderHtml_orig>
			<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="insertHeaderFooter" ReturnVariable="newHeaderID">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#URL.categoryID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="languageID" Value="">
				<cfinvokeargument Name="headerFooterStatus" Value="1">
				<cfinvokeargument Name="headerFooterText" Value="#Trim(Form.categoryHeader)#">
				<cfinvokeargument Name="headerFooterHtml" Value="#Form.categoryHeaderHtml#">
				<cfinvokeargument Name="headerFooterIndicator" Value="0">
			</cfinvoke>
			<cfset Form.headerFooterID_header = newHeaderID>
		</cfif>

		<cfif Form.categoryFooter is not Form.categoryFooter_orig or Form.categoryFooterHtml is not Form.categoryFooterHtml_orig>
			<cfinvoke Component="#Application.billingMapping#data.HeaderFooter" Method="insertHeaderFooter" ReturnVariable="newFooterID">
				<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
				<cfinvokeargument Name="targetID" Value="#URL.categoryID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="languageID" Value="">
				<cfinvokeargument Name="headerFooterStatus" Value="1">
				<cfinvokeargument Name="headerFooterText" Value="#Trim(Form.categoryFooter)#">
				<cfinvokeargument Name="headerFooterHtml" Value="#Form.categoryFooterHtml#">
				<cfinvokeargument Name="headerFooterIndicator" Value="1">
			</cfinvoke>
			<cfset Form.headerFooterID_footer = newFooterID>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Category" Method="updateCategory" ReturnVariable="isCategoryUpdated">
			<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
			<cfinvokeargument Name="categoryCode" Value="#Form.categoryCode#">
			<cfinvokeargument Name="categoryName" Value="#Form.categoryName#">
			<cfinvokeargument Name="categoryDescription" Value="#Form.categoryDescription#">
			<cfinvokeargument Name="categoryTitle" Value="#Form.categoryTitle#">
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

		<cflocation url="#Variables.doURL#&categoryID=#URL.categoryID#&confirm_category=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = Variables.doURL & "&categoryID=" & URL.categoryID>
<cfset Variables.formSubmitValue = Variables.lang_insertUpdateCategory.formSubmitValue_update>
<cfinclude template="../../view/v_category/form_insertUpdateCategory.cfm">
