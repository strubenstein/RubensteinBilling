<!--- 
Verify that category can be deleted:
- No children
- NOT live
- No product listings
--->

<cfset errorMessage_fields = StructNew()>

<cfif qry_selectCategory.categoryHasChildren is 1>
	<cfset errorMessage_fields.categoryHasChildren = Variables.lang_deleteCategory.categoryHasChildren>
</cfif>

<cfif qry_selectCategory.categoryStatus is 1>
	<cfset errorMessage_fields.categoryStatus = Variables.lang_deleteCategory.categoryStatus>
</cfif>

<cfif categoryProductCount gt 0>
	<cfset errorMessage_fields.categoryItemCount = ReplaceNoCase(Variables.lang_deleteCategory.categoryItemCount, "<<LEN>>", categoryProductCount, "ALL")>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_deleteCategory.errorTitle>
	<cfset errorMessage_header = Variables.lang_deleteCategory.errorHeader>
	<cfset errorMessage_footer = Variables.lang_deleteCategory.errorFooter>
</cfif>

