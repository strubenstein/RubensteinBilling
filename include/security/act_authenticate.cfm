<cfif Not StructKeyExists(Session, "userID") or Not StructKeyExists(Session, "companyID")
		or Not StructKeyExists(Session, "companyID_author") or Not StructKeyExists(Session, "groupID")
		or Not StructKeyExists(Session, "cobrandID") or Not StructKeyExists(Session, "cobrandID_list")
		or Not StructKeyExists(Session, "affiliateID") or Not StructKeyExists(Session, "affiliateID_list")
		or Not StructKeyExists(Session, "permissionStruct")>
	<cfinclude template="act_login.cfm">
<cfelseif Not Application.fn_IsIntegerPositive(Session.userID) or Not Application.fn_IsIntegerPositive(Session.companyID)
		or Session.companyID_author is 0 or Not IsStruct(Session.permissionStruct)>
	<cfinclude template="act_login.cfm">
</cfif>

