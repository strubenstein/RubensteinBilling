<cfset errorMessage_fields = StructNew()>

<cfif Form.categoryName is "">
	<cfset errorMessage_fields.categoryName = Variables.lang_insertUpdateCategory.categoryName_blank>
<cfelseif Len(Form.categoryName) gt maxlength_Category.categoryName>
	<cfset errorMessage_fields.categoryName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCategory.categoryName_maxlength, "<<MAXLENGTH>>", maxlength_Category.categoryName, "ALL"), "<<LEN>>", Len(Form.categoryName), "ALL")>
<cfelse>
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="checkCategoryNameIsUnique" ReturnVariable="isCategoryNameUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="categoryName" Value="#Form.categoryName#">
		<cfinvokeargument Name="categoryID_parent" Value="#Form.categoryID_parent#">
		<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
	</cfinvoke>

	<cfif isCategoryNameUnique is False>
		<cfif Form.categoryID_parent is 0>
			<cfset errorMessage_fields.categoryName = Variables.lang_insertUpdateCategory.categoryName_uniqueMain>
		<cfelse>
			<cfset errorMessage_fields.categoryName = Variables.lang_insertUpdateCategory.categoryName_uniqueSub>
		</cfif>
	</cfif>
</cfif>

<cfif Len(Form.categoryTitle) gt maxlength_Category.categoryTitle>
	<cfset errorMessage_fields.categoryTitle = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCategory.categoryTitle, "<<MAXLENGTH>>", maxlength_Category.categoryTitle, "ALL"), "<<LEN>>", Len(Form.categoryTitle), "ALL")>
</cfif>
<cfif Len(Form.categoryDescription) gt maxlength_Category.categoryDescription>
	<cfset errorMessage_fields.categoryDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCategory.categoryDescription, "<<MAXLENGTH>>", maxlength_Category.categoryDescription, "ALL"), "<<LEN>>", Len(Form.categoryDescription), "ALL")>
</cfif>

<cfif Len(Form.categoryCode) gt maxlength_Category.categoryCode>
	<cfset errorMessage_fields.categoryCode = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertUpdateCategory.categoryCode_maxlength, "<<MAXLENGTH>>", maxlength_Category.categoryCode, "ALL"), "<<LEN>>", Len(Form.categoryCode), "ALL")>
<cfelseif Trim(Form.categoryCode) is not "">
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="checkCategoryCodeIsUnique" ReturnVariable="isCategoryCodeUnique">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="categoryCode" Value="#Form.categoryCode#">
		<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
	</cfinvoke>

	<cfif isCategoryCodeUnique is False>
		<cfset errorMessage_fields.categoryCode = Variables.lang_insertUpdateCategory.categoryCode_unique>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.categoryStatus)>
	<cfset errorMessage_fields.categoryStatus = Variables.lang_insertUpdateCategory.categoryStatus>
</cfif>

<cfif Not ListFind("0,1", Form.categoryAcceptListing)>
	<cfset errorMessage_fields.categoryAcceptListing = Variables.lang_insertUpdateCategory.categoryAcceptListing>
</cfif>

<cfif Not ListFind("0,1", Form.categoryIsListed)>
	<cfset errorMessage_fields.categoryIsListed = Variables.lang_insertUpdateCategory.categoryIsListed>
</cfif>

<cfif Form.categoryID_parent is not 0 and Not ListFind(ValueList(qry_selectCategoryList.categoryID), Form.categoryID_parent)>
	<cfset errorMessage_fields.categoryID_parent = Variables.lang_insertUpdateCategory.categoryID_parent>
</cfif>

<cfif Form.templateFilename is not "" and Not ListFindNoCase(ValueList(qry_selectTemplateList.templateFilename), Form.templateFilename)>
	<cfset errorMessage_fields.templateFilename = Variables.lang_insertUpdateCategory.templateFilename>
</cfif>

<cfif Not ListFind("categoryItemsPerPage,categoryNumberOfPages", Form.itemsPerPage_or_numberOfPages)>
	<cfset errorMessage_fields.itemsPerPage_or_numberOfPages = Variables.lang_insertUpdateCategory.itemsPerPage_or_numberOfPages>
<cfelseif Not Application.fn_IsIntegerPositive(Form.itemsOrPages_value)>
	<cfset errorMessage_fields.itemsOrPages_value = Variables.lang_insertUpdateCategory.itemsOrPages_value>
<cfelse><!--- assign proper values for storing in database --->
	<cfif Form.itemsPerPage_or_numberOfPages is "categoryItemsPerPage">
		<cfset Form.categoryItemsPerPage = Form.itemsOrPages_value>
		<cfset Form.categoryNumberOfPages = 0>
	<cfelse>
		<cfset Form.categoryItemsPerPage = 0>
		<cfset Form.categoryNumberOfPages = Form.itemsOrPages_value>
	</cfif>
</cfif>

<cfif Not ListFind("0,1", Form.categoryHeaderHtml)>
	<cfset errorMessage_fields.categoryHeaderHtml = Variables.lang_insertUpdateCategory.categoryHeaderHtml>
</cfif>
<cfif Not ListFind("0,1", Form.categoryFooterHtml)>
	<cfset errorMessage_fields.categoryFooterHtml = Variables.lang_insertUpdateCategory.categoryFooterHtml>
</cfif>

<cfif Variables.doAction is "insertCategory">
	<cfif Not Application.fn_IsIntegerNonNegative(Form.categoryOrder_manual)>
		<cfset errorMessage_fields.categoryOrder_manual = Variables.lang_insertUpdateCategory.categoryOrder_manual_numeric>
	<cfelseif qry_selectCategoryList_order.RecordCount is not 0 
			and Form.categoryOrder_manual gt IncrementValue(qry_selectCategoryList_order.categoryOrder_manual[qry_selectCategoryList_order.RecordCount])>
		<cfset errorMessage_fields.categoryOrder_manual = Variables.lang_insertUpdateCategory.categoryOrder_manual_maximum>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertCategory">
		<cfset errorMessage_title = Variables.lang_insertUpdateCategory.errorTitle_insert>
	<cfelse><!--- updateCategory --->
		<cfset errorMessage_title = Variables.lang_insertUpdateCategory.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertUpdateCategory.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertUpdateCategory.errorFooter>
</cfif>

