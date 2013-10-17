<cfset Variables.lang_insertUpdateCategory = StructNew()>

<cfset Variables.lang_insertUpdateCategory.categoryName_blank = "The category name cannot be blank.">
<cfset Variables.lang_insertUpdateCategory.categoryName_maxlength = "The category name may have a maximum length of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCategory.categoryName_uniqueMain = "This category name is already being used as a main category name.">
<cfset Variables.lang_insertUpdateCategory.categoryName_uniqueSub = "This category name is already being used as a subcategory name within the parent category.">
<cfset Variables.lang_insertUpdateCategory.categoryTitle = "The category title may have a maximum length of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCategory.categoryDescription = "The category description may have a maximum length of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCategory.categoryCode_unique = "The category code is already being used.">
<cfset Variables.lang_insertUpdateCategory.categoryCode_maxlength = "The category code may have a maximum length of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdateCategory.categoryStatus = "You did not enter a valid category status.">
<cfset Variables.lang_insertUpdateCategory.categoryAcceptListing = "You did not enter a valid option for whether this category accepts listings.">
<cfset Variables.lang_insertUpdateCategory.categoryIsListed = "You did not enter a valid option for whether this category is listed on the site.">
<cfset Variables.lang_insertUpdateCategory.categoryID_parent = "You did not enter a valid parent category.">
<cfset Variables.lang_insertUpdateCategory.templateFilename = "You did not select a valid template.">
<cfset Variables.lang_insertUpdateCategory.itemsPerPage_or_numberOfPages = "You did not select a valid option for the number of items to display per page or the number of pages.">
<cfset Variables.lang_insertUpdateCategory.itemsOrPages_value = "You did not enter a valid number of pages or items per page.">
<cfset Variables.lang_insertUpdateCategory.categoryHeaderHtml = "You did not select a valid text/html format option for the header.">
<cfset Variables.lang_insertUpdateCategory.categoryFooterHtml = "You did not select a valid text/html format option for the footer.">
<cfset Variables.lang_insertUpdateCategory.categoryOrder_manual_numeric = "The manual category order must be a non-negative integer.">
<cfset Variables.lang_insertUpdateCategory.categoryOrder_manual_maximum = "The manual category order may only be 1 greater than the last category.">

<cfset Variables.lang_insertUpdateCategory.formSubmitValue_insert = "Create Category">
<cfset Variables.lang_insertUpdateCategory.formSubmitValue_update = "Update Category">

<cfset Variables.lang_insertUpdateCategory.errorTitle_insert = "The category could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdateCategory.errorTitle_update = "The category could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdateCategory.errorHeader = "">
<cfset Variables.lang_insertUpdateCategory.errorFooter = "">
