<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<!---
<cfloop index="theDsn" list="BillingDev,BillingClean,BillingDemo">
	<cfquery name="qry_selectUsers" datasource="#theDsn#">
		SELECT userID, username
		FROM avUser
	</cfquery>

	<cfquery name="qry_updateUser" datasource="#theDsn#">
		<cfloop query="qry_selectUsers">
			UPDATE avUser
			SET password = <cfqueryparam value="#Hash(qry_selectUsers.username, 'SHA-512')#" cfsqltype="cf_sql_varchar">
			WHERE userID = #qry_selectUsers.userID#;
		</cfloop>
	</cfquery>
</cfloop>
--->

</body>
</html>
