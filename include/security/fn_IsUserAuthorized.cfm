<!--- use Session.permissionStruct and Session.companyID vs Session.companyID_author for userIsPrimary? --->
<!--- 
input - action
external variables - Application.permissionStruct, Session.permissionStruct, Session.companyID, Session.companyID_author
output - True/False

To determine whether user has permission for that action:
- Determine permissionID for that action
- Select permissionBinaryNumber and permissionCategoryID of that permissionID
- If session permission structure for that permissionCategoryID does not exist, Return False
	Elseif BitAnd is True, Return True
	Else Return False
--->

<cfscript>
// Check permissions for browser user. Return True/False.
function fn_IsUserAuthorized (permissionAction)
{
	// ensure all required variables exist
	if (Trim(permissionAction) is "")
		return True;
	else if (Not StructKeyExists(Application, "permissionStruct") or Not IsStruct(Application.permissionStruct)
			or Not StructKeyExists(Session, "companyID") or Not StructKeyExists(Session, "companyID_author")
			or Not StructKeyExists(Session, "permissionStruct") or Not IsStruct(Session.permissionStruct))
		return False;
	// if permission does not exist, user has permission by default
	else if (Not StructKeyExists(Application.permissionStruct, permissionAction))
		return True;
	// if permission requires being a superuser
	else if (Application.permissionStruct[permissionAction].permissionSuperuserOnly is 1
			and Session.companyID is not Application.billingSuperuserCompanyID)
		return False;
	// if user does not have permission for permission category that contains permission, return False
	else if (Not StructKeyExists(Session.permissionStruct, "cat#Application.permissionStruct[permissionAction].permissionCategoryID#"))
		return False;
	// if user has permission, return True
	else if (BitAnd(Session.permissionStruct["cat#Application.permissionStruct[permissionAction].permissionCategoryID#"], Application.permissionStruct[permissionAction].permissionBinaryNumber))
		return True;
	else
		return False;
}

// Check multiple permissions for browser user. Return list of permissions.
function fn_IsUserAuthorizedList (permissionActionList)
{
	var permissionActionList_yes = "";
	for (count=1; count lte ListLen(permissionActionList); count = count + 1)
	{
		if (Application.fn_IsUserAuthorized(ListGetAt(permissionActionList, count)))
			permissionActionList_yes = ListAppend(permissionActionList_yes, ListGetAt(permissionActionList, count));
	}
	return permissionActionList_yes;
}
</cfscript>

<cflock Scope="Application" Timeout="5">
	<cfset Application.fn_isUserAuthorized = fn_isUserAuthorized>
	<cfset Application.fn_IsUserAuthorizedList = fn_IsUserAuthorizedList>
</cflock>

