<cfset Variables.lang_insertUpdatePermission = StructNew()>

<cfset Variables.lang_insertUpdatePermission.formSubmitValue_insert = "Add Permission Listing">
<cfset Variables.lang_insertUpdatePermission.formSubmitValue_update = "Update Permission Listing">

<cfset Variables.lang_insertUpdatePermission.permissionStatus = "You did not select a valid status.">
<cfset Variables.lang_insertUpdatePermission.permissionSuperuserOnly = "You did not select a valid option for whether this permission is for primary company users only.">
<cfset Variables.lang_insertUpdatePermission.permissionName_blank = "The permission name cannot be blank.">
<cfset Variables.lang_insertUpdatePermission.permissionName_unique = "The permission name is already being used.">
<cfset Variables.lang_insertUpdatePermission.permissionName_maxlength = "The permission name must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePermission.permissionTitle_blank = "The permission title cannot be blank.">
<cfset Variables.lang_insertUpdatePermission.permissionTitle_maxlength = "The permission title must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePermission.permissionDescription_maxlength = "The permission description must be <<MAXLENGTH>> characters or less. It currently has <<LEN>> characters.">
<cfset Variables.lang_insertUpdatePermission.permissionOrder = "You did not select a valid order.">
<cfset Variables.lang_insertUpdatePermission.permissionAction_maxlength = "The action(s) this permission applies to must be <<MAXLENGTH>> characters or less.">
<cfset Variables.lang_insertUpdatePermission.permissionAction_valid = "The action(s) may contain only letters and numbers, and may not begin with a number.">
<cfset Variables.lang_insertUpdatePermission.permissionAction_repeat = "An action cannot be repeated.">
<cfset Variables.lang_insertUpdatePermission.permissionAction_unique = "At least one action is already used in another permission.">

<cfset Variables.lang_insertUpdatePermission.errorTitle_insert = "The permission listing could not be created for the following reason(s):">
<cfset Variables.lang_insertUpdatePermission.errorTitle_update = "The permission listing could not be updated for the following reason(s):">
<cfset Variables.lang_insertUpdatePermission.errorHeader = "">
<cfset Variables.lang_insertUpdatePermission.errorFooter = "">
