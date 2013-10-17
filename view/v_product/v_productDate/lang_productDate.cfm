<cfset Variables.lang_productDate = StructNew()>

<cfset Variables.lang_productDate.formSubmitValue_insert = "Add Product Date">
<cfset Variables.lang_productDate.formSubmitValue_update = "Update Product Date">

<cfset Variables.lang_productDate.productDateEnd = "The end date/time must be after the begin date/time.">
<cfset Variables.lang_productDate.productDate_twoNoEnd = "You may only specify one begin date that has no end date.<br>You should edit the existing begin date instead.">
<cfset Variables.lang_productDate.productDate_beginAfterEnd = "The new end date is after an existing begin date that does not end.<br>You should edit the existing being date instead.">
<cfset Variables.lang_productDate.productDate_beginWithin = "The new begin date is within an existing date range.">
<cfset Variables.lang_productDate.productDate_endWithin = "The new end date is within an existing date range.">
<cfset Variables.lang_productDate.productDate_span = "The new begin date is before an existing date range and the end date is after an existing date range.<br>The new date range cannot span an existing date range.<br>You should either edit or delete the existing date range.">

<cfset Variables.lang_productDate.errorTitle_insert = "The product date range could not be added for the following reason(s):">
<cfset Variables.lang_productDate.errorTitle_update = "The product date range could not be updated for the following reason(s):">
<cfset Variables.lang_productDate.errorHeader = "">
<cfset Variables.lang_productDate.errorFooter = "">
