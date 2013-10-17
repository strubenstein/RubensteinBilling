<cfset Variables.lang_insertAddress = StructNew()>

<cfset Variables.lang_insertAddress.addressStatus = "You did not select a valid address status.">
<cfset Variables.lang_insertAddress.regionID = "You did not select a valid region.">
<cfset Variables.lang_insertAddress.addressTypeShipping = "You did not select a valid option for whether this is the shipping address.">
<cfset Variables.lang_insertAddress.addressTypeBilling = "You did not select a valid option for whether this is the billing address.">
<cfset Variables.lang_insertAddress.addressType = "You did not select either the shipping or billing address type.">
<cfset Variables.lang_insertAddress.addressName_maxlength = "The address name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.addressName_unique = "The address name is already being used by another address. Please select a different name.">
<cfset Variables.lang_insertAddress.addressDescription = "The address description may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.address_blank = "The street address cannot be blank.">
<cfset Variables.lang_insertAddress.address_maxlength = "The street address may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.address2 = "The 2nd street address line name may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.address3 = "The 3rd street address line may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.city_blank = "The city cannot be blank.">
<cfset Variables.lang_insertAddress.city_maxlength = "The state may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.state_maxlength = "The state may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.state_blank = "The state cannot be blank.">
<cfset Variables.lang_insertAddress.state_valid = "You did not enter a valid state.">
<cfset Variables.lang_insertAddress.zipCode_blank = "The zip/postal code cannot be blank.">
<cfset Variables.lang_insertAddress.zipCode_maxlength = "The zip/postal code may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.zipCode_valid = "The zip/postal code may contain only letters, numbers and a space.">
<cfset Variables.lang_insertAddress.zipCodePlus4 = "The zip code <i>plus 4</i> may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.county = "The county may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.country_maxlength = "The country may have a maximum of <<MAXLENGTH>> characters. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertAddress.country_blank = "The country cannot be blank.">
<cfset Variables.lang_insertAddress.country_valid = "You did not select a valid country.">

<cfset Variables.lang_insertAddress.formSubmitValue_insert = "Add Address">
<cfset Variables.lang_insertAddress.formSubmitValue_update = "Update Address">

<cfset Variables.lang_insertAddress.errorTitle_insert = "The address could not be added for the following reason(s):">
<cfset Variables.lang_insertAddress.errorTitle_update = "The address could not be updated for the following reason(s):">
<cfset Variables.lang_insertAddress.errorHeader = "">
<cfset Variables.lang_insertAddress.errorFooter = "">
