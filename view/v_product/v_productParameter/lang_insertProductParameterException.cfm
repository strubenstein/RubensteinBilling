<cfset Variables.lang_insertProductParameterException = StructNew()>

<cfset Variables.lang_insertProductParameterException.formSubmitValue_insert = "Add Exception">
<cfset Variables.lang_insertProductParameterException.formSubmitValue_update = "Update Exception">

<cfset Variables.lang_insertProductParameterException.productParameterExceptionDescription_maxlength = "The description must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertProductParameterException.productParameterOptionID_invalid = "You did not select a valid parameter option.">
<cfset Variables.lang_insertProductParameterException.productParameterOptionID_repeat = "You may not select the same parameter option more than once.">
<cfset Variables.lang_insertProductParameterException.productParameterOptionID_multiple = "You may not select more than one option from each parameter.">
<cfset Variables.lang_insertProductParameterException.productParameterOptionID_zero = "You did not select any parameter options.">
<cfset Variables.lang_insertProductParameterException.productParameterOptionID_maximum = "You may not select more than 4 parameter options.">
<cfset Variables.lang_insertProductParameterException.productParameterOptionID_unique = "This combination of parameters is already being used in another exception or another exception combination contains a sub-set of this combination of parameter options.">
<cfset Variables.lang_insertProductParameterException.productParameterExceptionExcluded_valid = "You did not select a valid option for whether this combination is excluded.">
<cfset Variables.lang_insertProductParameterException.productParameterExceptionExcluded_count = "You cannot exclude this combination of options unless you select at least 2 parameter options.">
<cfset Variables.lang_insertProductParameterException.productParameterExceptionPricePremium_excluded = "You cannot both set a price premium and exclude the combination.">
<cfset Variables.lang_insertProductParameterException.productParameterExceptionPricePremium_zero = "You cannot set a price premium of 0.">
<cfset Variables.lang_insertProductParameterException.productParameterExceptionPricePremium_numeric = "The price premium is not a valid number.">
<cfset Variables.lang_insertProductParameterException.productParameterExceptionPricePremium_decimal = "The price premium may contain a maximum of <<MAXLENGTH>> decimal places.">
<cfset Variables.lang_insertProductParameterException.productParameterExceptionText_maxlength = "The text warning must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertProductParameterException.productParameterExceptionText_noResult = "You did not select any result of this exception.">

<cfset Variables.lang_insertProductParameterException.errorTitle_insert = "The product parameter exception could not be added for the following reason(s):">
<cfset Variables.lang_insertProductParameterException.errorTitle_update = "The product parameter exception could not be updated for the following reason(s):">
<cfset Variables.lang_insertProductParameterException.errorHeader = "">
<cfset Variables.lang_insertProductParameterException.errorFooter = "">
