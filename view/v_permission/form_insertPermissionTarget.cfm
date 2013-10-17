<cfset Variables.halfwayReached = False>
<cfif (qry_selectPermissionList.RecordCount) mod 2 is 0>
	<cfset Variables.halfway = qry_selectPermissionList.RecordCount \ 2>
<cfelse>
	<cfset Variables.halfway = (qry_selectPermissionList.RecordCount \ 2) + 1>
</cfif>

<cfoutput>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
var checkflag = "false";
function check(field) {
if (checkflag == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;
}
checkflag = "true";
return "Uncheck All Permissions"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag = "false";
return "Check All Permissions"; }
}
//  End -->
</SCRIPT>

<cfif qry_selectPermissionTargetOrderList.RecordCount gt 1>
	<form method="post" action="#Variables.formAction_view#">
	<div class="MainText"><b><i>View Permission Settings By Date Created:</i></b> 
	<select name="permissionTargetOrder" size="1">
	<cfloop Query="qry_selectPermissionTargetOrderList">
		<option value="#qry_selectPermissionTargetOrderList.permissionTargetOrder#"<cfif Form.permissionTargetOrder is qry_selectPermissionTargetOrderList.permissionTargetOrder> selected</cfif>>###qry_selectPermissionTargetOrderList.permissionTargetOrder#. #DateFormat(qry_selectPermissionTargetOrderList.permissionTargetDateCreated, "mm-dd-yy")# at #TimeFormat(qry_selectPermissionTargetOrderList.permissionTargetDateCreated, "hh:mm tt")#</option>
	</cfloop>
	</select> 
	<input type="submit" value="View">
	<cfif Variables.doAction is "viewPermissionTarget" and Application.fn_IsUserAuthorized("insertPermissionTarget")>
		 [<a href="#Variables.formAction_view#" class="plainlink">Return to Update Permissions</a>]
	</cfif>
	</div>
	</form>
</cfif>

<form method="post" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<cfif Variables.formAction is not "">
	<p><input type=button value="Check All Permissions" onClick="this.value=check(this.form.permissionID);">
	&nbsp; &nbsp; 
	<input type="reset" value="Reset"></p>
</cfif>

<cfset Variables.bgColorOn = False>
<table border="0" cellspacing="2" cellpadding="2"><tr valign="top" width="800"><td>
<table border="0" cellspacing="2" cellpadding="2" class="TableText" width="390">
<cfset Variables.lastPermissionCategoryID = 0>
<cfloop Query="qry_selectPermissionList">
	<cfif CurrentRow is 1 or qry_selectPermissionList.permissionCategoryID is not qry_selectPermissionList.permissionCategoryID[CurrentRow - 1]>
		<cfif CurrentRow gte Variables.halfway and Variables.halfwayReached is False>
			<cfset Variables.halfwayReached = True>
			</table></td>
			<td width="20">&nbsp;</td>
			<td><table border="0" cellspacing="2" cellpadding="2" class="TableText" width="390">
		</cfif>
		<cfset Variables.permissionCategoryRow = ListFind(ValueList(qry_selectPermissionCategoryList.permissionCategoryID), qry_selectPermissionList.permissionCategoryID)>
		<cfif CurrentRow is not 1></td></tr></cfif>
		<tr valign="top" bgcolor="CCCCFF">
		<td> &nbsp; <b>#qry_selectPermissionCategoryList.permissionCategoryTitle[Variables.permissionCategoryRow]#</b></td>
		<tr valign="top"<cfif Variables.bgColorOn is True> bgcolor="f4f4ff"</cfif>><td>
		<cfif Variables.bgColorOn is True><cfset Variables.bgColorOn = False><cfelse><cfset Variables.bgColorOn = True></cfif>
	</cfif>
	<label><input type="checkbox" name="permissionID" value="#qry_selectPermissionList.permissionID#"<cfif BitAnd(Form["permissionBinary#qry_selectPermissionList.permissionCategoryID#"], qry_selectPermissionList.permissionBinaryNumber)> checked</cfif>>
	<cfif qry_selectPermissionList.permissionTitle is "">#qry_selectPermissionList.permissionName#<cfelse>#qry_selectPermissionList.permissionTitle#</cfif></label><br>
</cfloop>
</td>
</tr>
</table>
</td></tr></table>

<cfif Variables.formAction is not "">
	<p><input type="submit" name="submitTargetPermission" value="Update Permissions"></p>
</cfif>
</form>
</cfoutput>
