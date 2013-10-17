<cfset Variables.lang_insertProductSpec = StructNew()>

<cfset Variables.lang_insertProductSpec.productSpecCount = "You did not enter a valid number for the new number of specification options.">
<cfset Variables.lang_insertProductSpec.productSpecCount_orig = "You did not enter a valid number for the original number of specification options.">
<cfset Variables.lang_insertProductSpec.productSpecHasImage = "You did not select a valid option for whether spec value ##<<COUNT>> is represented by an image.">
<cfset Variables.lang_insertProductSpec.productSpecValue = "Specification value ##<<COUNT>> must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertProductSpec.productSpecName_maxlength = "Specification name ##<<COUNT>> must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertProductSpec.productSpecName_unique = "Specification name ##<<COUNT>> is already being used for this product. A spec name cannot be repeated.">

<cfset Variables.lang_insertProductSpec.errorTitle = "The product specifications could not be added for the following reason(s):">
<cfset Variables.lang_insertProductSpec.errorHeader = "">
<cfset Variables.lang_insertProductSpec.errorFooter = "">
