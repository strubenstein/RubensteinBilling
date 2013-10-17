<cfcomponent DisplayName="User" Hint="Manages creating, updating, viewing and managing users">

<cffunction name="maxlength_User" access="public" output="no" returnType="struct">
	<cfset var maxlength_User = StructNew()>

	<cfset maxlength_User.username = 50>
	<cfset maxlength_User.password = 255>
	<cfset maxlength_User.password_decrypted = 50>
	<cfset maxlength_User.firstName = 50>
	<cfset maxlength_User.middleName = 50>
	<cfset maxlength_User.lastName = 50>
	<cfset maxlength_User.suffix = 10>
	<cfset maxlength_User.salutation = 10>
	<cfset maxlength_User.email = 100>
	<cfset maxlength_User.userID_custom = 50>
	<cfset maxlength_User.jobTitle = 100>
	<cfset maxlength_User.jobDepartment = 100>
	<cfset maxlength_User.jobDivision = 100>
	<cfset maxlength_User.userEmailVerifyCode = 35>
	<cfset maxlength_User.languageID = 5>

	<cfreturn maxlength_User>
</cffunction>

<cffunction Name="insertUser" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new user into database and returns userID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="username" Type="string" Required="Yes">
	<cfargument Name="password" Type="string" Required="Yes">
	<cfargument Name="userStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="firstName" Type="string" Required="Yes">
	<cfargument Name="middleName" Type="string" Required="No" Default="">
	<cfargument Name="lastName" Type="string" Required="Yes">
	<cfargument Name="suffix" Type="string" Required="No" Default="">
	<cfargument Name="salutation" Type="string" Required="No" Default="">
	<cfargument Name="email" Type="string" Required="Yes">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="userID_custom" Type="string" Required="No" Default="">
	<cfargument Name="jobTitle" Type="string" Required="No" Default="">
	<cfargument Name="jobDepartment" Type="string" Required="No" Default="">
	<cfargument Name="jobDivision" Type="string" Required="No" Default="">
	<cfargument Name="userNewsletterStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="userNewsletterHtml" Type="numeric" Required="No" Default="1">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="userIsExported" Type="string" Required="No" Default="">
	<cfargument Name="userDateExported" Type="string" Required="No" Default="">
	<cfargument Name="userEmailVerified" Type="string" Required="No" Default="">
	<cfargument Name="userEmailVerifyCode" Type="string" Required="No" Default="">
	<cfargument Name="userEmailDateVerified" Type="string" Required="No" Default="">

	<cfset var qry_insertUser = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />

	<cfquery Name="qry_insertUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avUser
		(
			companyID, username, password, userStatus, firstName, middleName, lastName, suffix, salutation, email, languageID,
			userID_custom, jobTitle, jobDepartment, jobDivision, userNewsletterStatus, userNewsletterHtml, userID_author,
			userIsExported, userDateExported, userEmailVerified, userEmailVerifyCode, userEmailDateVerified, userDateCreated, userDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.username#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.username#">,
			<cfqueryparam Value="#Application.fn_HashString(Arguments.password)#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.password#">,
			<cfqueryparam Value="#Arguments.userStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.firstName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.firstName#">,
			<cfqueryparam Value="#Arguments.middleName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.middleName#">,
			<cfqueryparam Value="#Arguments.lastName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.lastName#">,
			<cfqueryparam Value="#Arguments.suffix#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.suffix#">,
			<cfqueryparam Value="#Arguments.salutation#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.salutation#">,
			<cfqueryparam Value="#Arguments.email#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.email#">,
			<cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.languageID#">,
			<cfqueryparam Value="#Arguments.userID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.userID_custom#">,
			<cfqueryparam Value="#Arguments.jobTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.jobTitle#">,
			<cfqueryparam Value="#Arguments.jobDepartment#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.jobDepartment#">,
			<cfqueryparam Value="#Arguments.jobDivision#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.jobDivision#">,
			<cfqueryparam Value="#Arguments.userNewsletterStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userNewsletterHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfif Not ListFind("0,1", Arguments.userIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.userIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.userDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.userDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Arguments.userEmailVerified is "">NULL<cfelse><cfqueryparam Value="#Arguments.userEmailVerified#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfqueryparam Value="#Arguments.userEmailVerifyCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.userEmailVerifyCode#">,
			<cfif Not IsDate(Arguments.userEmailDateVerified)>NULL<cfelse><cfqueryparam Value="#Arguments.userEmailDateVerified#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "userID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertUser.primaryKeyID>
</cffunction>

<cffunction Name="updateUser" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing user">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="username" Type="string" Required="No">
	<cfargument Name="password" Type="string" Required="No">
	<cfargument Name="userStatus" Type="numeric" Required="No">
	<cfargument Name="firstName" Type="string" Required="No">
	<cfargument Name="middleName" Type="string" Required="No">
	<cfargument Name="lastName" Type="string" Required="No">
	<cfargument Name="suffix" Type="string" Required="No">
	<cfargument Name="salutation" Type="string" Required="No">
	<cfargument Name="email" Type="string" Required="No">
	<cfargument Name="userID_custom" Type="string" Required="No">
	<cfargument Name="jobTitle" Type="string" Required="No">
	<cfargument Name="jobDepartment" Type="string" Required="No">
	<cfargument Name="jobDivision" Type="string" Required="No">
	<cfargument Name="userNewsletterStatus" Type="numeric" Required="No">
	<cfargument Name="userNewsletterHtml" Type="numeric" Required="No">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="userIsExported" Type="string" Required="No">
	<cfargument Name="userDateExported" Type="string" Required="No">
	<cfargument Name="userEmailVerified" Type="string" Required="No">
	<cfargument Name="userEmailVerifyCode" Type="string" Required="No">
	<cfargument Name="userEmailDateVerified" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />

	<cfquery Name="qry_updateUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avUser
		SET 
			<cfif StructKeyExists(Arguments, "companyID")>companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "username")>username = <cfqueryparam Value="#Arguments.username#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.username#">,</cfif>
			<cfif StructKeyExists(Arguments, "password")>password = <cfqueryparam Value="#Application.fn_HashString(Arguments.password)#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.password#">,</cfif>
			<cfif StructKeyExists(Arguments, "userStatus")>userStatus = <cfqueryparam Value="#Arguments.userStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "firstName")>firstName = <cfqueryparam Value="#Arguments.firstName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.firstName#">,</cfif>
			<cfif StructKeyExists(Arguments, "middleName")>middleName = <cfqueryparam Value="#Arguments.middleName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.middleName#">,</cfif>
			<cfif StructKeyExists(Arguments, "lastName")>lastName = <cfqueryparam Value="#Arguments.lastName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.lastName#">,</cfif>
			<cfif StructKeyExists(Arguments, "suffix")>suffix = <cfqueryparam Value="#Arguments.suffix#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.suffix#">,</cfif>
			<cfif StructKeyExists(Arguments, "salutation")>salutation = <cfqueryparam Value="#Arguments.salutation#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.salutation#">,</cfif>
			<cfif StructKeyExists(Arguments, "email")>email = <cfqueryparam Value="#Arguments.email#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.email#">,</cfif>
			<cfif StructKeyExists(Arguments, "userID_custom")>userID_custom = <cfqueryparam Value="#Arguments.userID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.userID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "jobTitle")>jobTitle = <cfqueryparam Value="#Arguments.jobTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.jobTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "jobDepartment")>jobDepartment = <cfqueryparam Value="#Arguments.jobDepartment#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.jobDepartment#">,</cfif>
			<cfif StructKeyExists(Arguments, "jobDivision")>jobDivision = <cfqueryparam Value="#Arguments.jobDivision#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_User.jobDivision#">,</cfif>
			<cfif StructKeyExists(Arguments, "userNewsletterStatus")>userNewsletterStatus = <cfqueryparam Value="#Arguments.userNewsletterStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "userNewsletterHtml")>userNewsletterHtml = <cfqueryparam Value="#Arguments.userNewsletterHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "userID_author")>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "userIsExported")>userIsExported = <cfif Not ListFind("0,1", Arguments.userIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.userIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "userDateExported")>userDateExported = <cfif Not IsDate(Arguments.userDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.userDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "userEmailVerified")>userEmailVerified = <cfif Arguments.userEmailVerified is "">NULL<cfelse><cfqueryparam Value="#Arguments.userEmailVerified#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "userEmailVerifyCode")>userEmailVerifyCode = <cfqueryparam Value="#Arguments.userEmailVerifyCode#" cfsqltype="cf_sql_varchar" MaxLength="35">,</cfif>
			<cfif StructKeyExists(Arguments, "userEmailDateVerified")>userEmailDateVerified = <cfif Not IsDate(Arguments.userEmailDateVerified)>NULL<cfelse><cfqueryparam Value="#Arguments.userEmailDateVerified#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			userDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectUser" Access="public" Output="No" ReturnType="query" Hint="Selects existing user">
	<cfargument Name="userID" Type="string" Required="Yes">
	<cfargument Name="returnPassword" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectUser = QueryNew("blank")>

	<cfquery Name="qry_selectUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUser.userID, avUser.companyID, avUser.username, avUser.userStatus, avUser.firstName, avUser.middleName,
			avUser.lastName, avUser.suffix, avUser.salutation, avUser.email, avUser.languageID, avUser.userID_custom,
			avUser.jobTitle, avUser.jobDepartment, avUser.jobDivision, avUser.userNewsletterStatus, avUser.userNewsletterHtml,
			avUser.userID_author, avUser.userDateCreated, avUser.userDateUpdated, avUser.userIsExported, avUser.userDateExported,
			avUser.userEmailVerified, avUser.userEmailVerifyCode, avUser.userEmailDateVerified,
			avCompany.companyName, avCompany.companyID_custom, avCompany.affiliateID, avCompany.cobrandID, avCompany.companyDirectory,
			avCompany.companyID_author, avCompany.companyPrimary
			<cfif StructKeyExists(Arguments, "returnPassword") and Arguments.returnPassword is True>, avUser.password</cfif>
		FROM avUser LEFT OUTER JOIN avCompany ON avUser.companyID = avCompany.companyID
		WHERE avUser.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		ORDER BY avUser.lastName, avUser.firstName
	</cfquery>

	<cfreturn qry_selectUser>
</cffunction>

<cffunction Name="selectUserIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects userID of existing user via custom ID and returns userID(s) if exists, 0 if not exists, and -1 if multiple users have the same userID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_custom" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="No">

	<cfset var qry_selectUserIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectUserIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUser.userID
		FROM avUser, avCompany
		WHERE avUser.companyID = avCompany.companyID
			AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND avUser.userID_custom IN (<cfqueryparam Value="#Arguments.userID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "companyID")>AND avUser.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"></cfif>
	</cfquery>

	<cfif qry_selectUserIDViaCustomID.RecordCount is 0 or qry_selectUserIDViaCustomID.RecordCount lt ListLen(Arguments.userID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectUserIDViaCustomID.RecordCount gt ListLen(Arguments.userID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectUserIDViaCustomID.userID)>
	</cfif>
</cffunction>

<cffunction Name="selectUserSummary" Access="public" Output="No" ReturnType="query" Hint="Selects existing user summary">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<cfset var qry_selectUserSummary = QueryNew("blank")>

	<cfquery Name="qry_selectUserSummary" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			(SELECT COUNT(userID) FROM avUserCompany WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">) AS userCompanyCount,
			(SELECT COUNT(userID) FROM avInvoice WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"> AND invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS userInvoiceCount,
			(SELECT SUM(invoiceTotal) FROM avInvoice WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"> AND invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS userInvoiceTotalSum,
			(SELECT SUM(invoiceTotalLineItem) FROM avInvoice WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"> AND invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS userInvoiceTotalLineItemSum,
			(SELECT SUM(avInvoiceLineItem.invoiceLineItemQuantity) FROM avInvoice, avInvoiceLineItem WHERE avInvoice.invoiceID = avInvoiceLineItem.invoiceID AND avInvoice.userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"> AND avInvoice.invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS userInvoiceLineItemQuantitySum,
			(SELECT COUNT(productID) FROM avProduct WHERE productID IN 
				(SELECT DISTINCT(avInvoiceLineItem.productID) FROM avInvoice, avInvoiceLineItem WHERE avInvoice.invoiceID = avInvoiceLineItem.invoiceID AND avInvoice.userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"> AND avInvoice.invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)
				) AS userInvoiceLineItemProductUniqueCount,
			(SELECT COUNT(avPriceTarget.targetID) FROM avPrice, avPriceTarget WHERE avPrice.priceID = avPriceTarget.priceID AND avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("userID")#" cfsqltype="cf_sql_integer"> AND avPriceTarget.targetID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"> AND avPrice.priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS userPriceCount,
			(SELECT COUNT(userID_target) FROM avNote WHERE userID_target = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">) AS userNoteCount,
			(SELECT COUNT(userID_target) FROM avTask WHERE userID_target = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"> AND taskCompleted = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS userTaskCountCompleted,
			(SELECT COUNT(userID_target) FROM avTask WHERE userID_target = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"> AND taskCompleted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS userTaskCountNotCompleted
	</cfquery>

	<cfreturn qry_selectUserSummary>
</cffunction>

<cffunction Name="checkUsernameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that user's username is unique if new user or updating existing user">
	<cfargument Name="username" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfset var qry_checkUsernameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkUsernameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUser.userID
		FROM avUser, avCompany
		WHERE avUser.companyID = avCompany.companyID
			AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND avUser.username = <cfqueryparam Value="#Arguments.username#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "userID")>AND avUser.userID <> <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"></cfif>
	</cfquery>

	<cfif qry_checkUsernameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkEmailIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that user's email is unique if new user or updating existing user">
	<cfargument Name="email" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfset var qry_checkEmailIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkEmailIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUser.userID
		FROM avUser, avCompany
		WHERE avUser.companyID = avCompany.companyID
			AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND avUser.email = <cfqueryparam Value="#Arguments.email#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "userID")>AND avUser.userID <> <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"></cfif>
	</cfquery>

	<cfif qry_checkEmailIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="insertUserCompany" Access="public" Output="No" ReturnType="boolean" Hint="Insert user to give permission for a company">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userCompanyStatus" Type="numeric" Required="No" Default="1">

	<cfquery Name="qry_insertUserCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avUserCompany (userID, companyID, userCompanyStatus, userCompanyDateCreated, userCompanyDateUpdated)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userCompanyStatus#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		)
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateUserCompany" Access="public" Output="No" ReturnType="boolean" Hint="Update user permission for a company">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userCompanyStatus" Type="numeric" Required="Yes">

	<cfquery Name="qry_updateUserCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avUserCompany
		SET	userCompanyStatus = <cfqueryparam Value="#Arguments.userCompanyStatus#" cfsqltype="cf_sql_integer">,
			userCompanyDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectUserCompanyList_user" Access="public" Output="No" ReturnType="query" Hint="Select companies for which user has permission">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userCompanyStatus" Type="numeric" Required="No">

	<cfset var qry_selectUserCompanyList_user = QueryNew("blank")>

	<cfquery Name="qry_selectUserCompanyList_user" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUserCompany.companyID, avUserCompany.userCompanyStatus, avUserCompany.userCompanyDateCreated, avUserCompany.userCompanyDateUpdated,
			avCompany.companyName, avCompany.companyID_custom, avCompany.companyStatus
		FROM avUserCompany, avCompany
		WHERE avUserCompany.companyID = avCompany.companyID
			AND avUserCompany.userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "userCompanyStatus")>AND avUserCompany.userCompanyStatus = <cfqueryparam Value="#Arguments.userCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY avCompany.companyName
	</cfquery>

	<cfreturn qry_selectUserCompanyList_user>
</cffunction>

<cffunction Name="checkUserPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for user">
	<cfargument Name="userID" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<!--- <cfargument Name="username" Type="string" Required="No"> --->

	<cfset var qry_checkUserPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.userID) or Not Application.fn_IsIntegerList(Arguments.companyID_author)>
		<cfreturn False>
	<cfelseif Arguments.userID is 0><!---  and (Not StructKeyExists(Arguments, "username") or Trim(Arguments.username) is "") --->
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkUserPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT Distinct(avUser.userID)
			FROM avUser, avUserCompany, avCompany
			WHERE avUser.userID = avUserCompany.userID
				AND avUserCompany.companyID = avCompany.companyID
				AND avUser.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerNonNegative(Arguments.companyID)>
					AND avUserCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				</cfif>
				AND avUserCompany.userCompanyStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND avCompany.companyID_author IN (<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)>
					AND avUser.userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID) and StructKeyExists(Arguments, "affiliateID") and Arguments.affiliateID is not "" and Application.fn_IsIntegerList(Arguments.affiliateID)>
					AND (avCompany.cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						OR avCompany.affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
				<cfelseif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>
					AND avCompany.cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfelseif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
					AND avCompany.affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
		</cfquery>

		<cfif qry_checkUserPermission.RecordCount is 0 or qry_checkUserPermission.RecordCount is not ListLen(Arguments.userID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectUserJobDepartmentList" Access="public" Output="No" ReturnType="query" Hint="Select list of existing departments">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_selectUserJobDepartmentList = QueryNew("blank")>

	<cfquery Name="qry_selectUserJobDepartmentList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT DISTINCT(jobDepartment)
		FROM avUser
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND jobDepartment <> ''
		ORDER BY jobDepartment
	</cfquery>

	<cfreturn qry_selectUserJobDepartmentList>
</cffunction>

<cffunction Name="checkForgetUsernameOrPassword" Access="public" Output="No" ReturnType="query" Hint="Select username of user with requested email address and username (if resetting password)">
	<cfargument Name="companyID_author" Type="numeric" Required="No">
	<cfargument Name="email" Type="string" Required="Yes">
	<cfargument Name="username" Type="string" Required="No">

	<cfset var qry_checkForgetUsernameOrPassword = QueryNew("blank")>

	<cfquery Name="qry_checkForgetUsernameOrPassword" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUser.userID, avUser.username, avUser.firstName, avUser.lastName
		FROM avUser, avCompany
		WHERE avUser.companyID = avCompany.companyID
			AND avUser.email = <cfqueryparam Value="#Arguments.email#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "username")>AND avUser.username = <cfqueryparam Value="#Arguments.username#" cfsqltype="cf_sql_varchar"></cfif>
			<cfif StructKeyExists(Arguments, "companyID_author")>AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"></cfif>
	</cfquery>

	<cfreturn qry_checkForgetUsernameOrPassword>
</cffunction>


<!--- functions for viewing list of users --->
<cffunction Name="selectUserList" Access="public" ReturnType="query" Hint="Select list of users">
	<cfargument Name="companyID_author" Type="string" Required="No">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="userIsProductManager" Type="numeric" Required="No">
	<cfargument Name="city" Type="string" Required="No">
	<cfargument Name="state" Type="string" Required="No">
	<cfargument Name="county" Type="string" Required="No">
	<cfargument Name="zipCode" Type="string" Required="No">
	<cfargument Name="country" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="userID_not" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="returnMyCompanyUsersOnly" Type="string" Required="No" Default="">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="userHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="userHasCustomID" Type="numeric" Required="No">
	<cfargument Name="userIsActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="userStatus" Type="string" Required="No">
	<cfargument Name="userIsPrimaryContact" Type="string" Required="No">
	<cfargument Name="userNewsletterStatus" Type="string" Required="No">
	<cfargument Name="userNewsletterHtml" Type="string" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="userIsExported" Type="string" Required="No">
	<cfargument Name="userDateExported_from" Type="string" Required="No">
	<cfargument Name="userDateExported_to" Type="string" Required="No">
	<cfargument Name="userEmailVerified" Type="numeric" Required="No">
	<cfargument Name="userEmailVerifyCode" Type="string" Required="No">
	<cfargument Name="username_list" type="string" required="no">
	<cfargument Name="email_list" type="string" required="no">
	<cfargument Name="userIsLoggedIn" type="numeric" required="no">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="userDateCreated_from" Type="date" Required="No">
	<cfargument Name="userDateCreated_to" Type="date" Required="No">
	<cfargument Name="companyPrimary" Type="numeric" Required="No">
	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="lastName">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="No" Default="">

	<cfset var qry_selectUserList = QueryNew("blank")>
	<cfset var queryParameters_orderBy = "avUser.lastName">
	<cfset var queryParameters_orderBy_noTable = "lastName">

	<cfif Arguments.returnMyCompanyUsersOnly is 1 and ListFind("companyName,companyName_d,companyID_custom,companyID_custom_d", Arguments.queryOrderBy)>
		<cfset Arguments.queryOrderBy = "lastName">
	</cfif>

	<cfswitch Expression="#Arguments.queryOrderBy#">
	<cfcase value="userID,username,userStatus,email,languageID,jobTitle,jobDepartment,jobDivision,userDateUpdated"><cfset queryParameters_orderBy = "avUser.#Arguments.queryOrderBy#"></cfcase>
	<cfcase value="userID_d,username_d,userStatus_d,email_d,languageID_d,jobTitle_d,jobDepartment_d,jobDivision_d,userDateUpdated_d"><cfset queryParameters_orderBy = "avUser.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	<cfcase value="userID_custom"><cfset queryParameters_orderBy = "avUser.userID_custom"></cfcase>
	<cfcase value="userID_custom_d"><cfset queryParameters_orderBy = "avUser.userID_custom DESC"></cfcase>
	<cfcase value="lastName"><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfcase>
	<cfcase value="lastName_d"><cfset queryParameters_orderBy = "avUser.lastName DESC, avUser.firstName DESC"></cfcase>
	<cfcase value="userDateCreated"><cfset queryParameters_orderBy = "avUser.userID"></cfcase>
	<cfcase value="userDateCreated_d"><cfset queryParameters_orderBy = "avUser.userID DESC"></cfcase>
	<cfcase value="companyName"><cfset queryParameters_orderBy = "avCompany.companyName, avUser.lastName, avUser.firstName"></cfcase>
	<cfcase value="companyName_d"><cfset queryParameters_orderBy = "avCompany.companyName DESC, avUser.lastName, avUser.firstName"></cfcase>
	<cfcase value="companyID_custom"><cfset queryParameters_orderBy = "avCompany.companyID_custom"></cfcase>
	<cfcase value="companyID_custom_d"><cfset queryParameters_orderBy = "avCompany.companyID_custom DESC"></cfcase>
	<cfcase value="affiliateID"><cfset queryParameters_orderBy = "avCompany.affiliateID"></cfcase>
	<cfcase value="affiliateID_d"><cfset queryParameters_orderBy = "avCompany.affiliateID DESC"></cfcase>
	<cfcase value="cobrandID"><cfset queryParameters_orderBy = "avCompany.cobrandID"></cfcase>
	<cfcase value="cobrandID_d"><cfset queryParameters_orderBy = "avCompany.cobrandID DESC"></cfcase>
	<cfdefaultcase><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfdefaultcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCompany">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectUserList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avUser.userID, avUser.companyID, avUser.username, avUser.userStatus, avUser.firstName, avUser.middleName,
			avUser.lastName, avUser.suffix, avUser.salutation, avUser.email, avUser.languageID, avUser.userID_custom,
			avUser.jobTitle, avUser.jobDepartment, avUser.jobDivision, avUser.userNewsletterStatus, avUser.userNewsletterHtml,
			avUser.userID_author, avUser.userDateCreated, avUser.userDateUpdated, avUser.userIsExported, avUser.userDateExported,
			avUser.userEmailVerified, avUser.userEmailVerifyCode, avUser.userEmailDateVerified,
			avCompany.companyName, avCompany.companyID_custom, avCompany.affiliateID, avCompany.cobrandID,
			avCompany.companyIsAffiliate, avCompany.companyIsCobrand, avCompany.companyIsVendor, avCompany.companyIsCustomer
		FROM avUser, avUserCompany, avCompany
		WHERE avUser.userID = avUserCompany.userID
			AND avUserCompany.companyID = avCompany.companyID
			<cfinclude template="dataShared/qryWhere_selectUserList.cfm">
			<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "" and Arguments.queryFirstLetter_field is not "">
				<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
					AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
				<cfelse><!--- letter --->
					AND (Left(#Arguments.queryFirstLetter_field#, 1) >= <cfqueryparam value="#UCase(Arguments.queryFirstLetter)#" cfsqltype="cf_sql_varchar">
						OR Left(#Arguments.queryFirstLetter_field#, 1) >= <cfqueryparam value="#LCase(Arguments.queryFirstLetter)#" cfsqltype="cf_sql_varchar">)
				</cfif>
			</cfif>
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectUserList>
</cffunction>

<cffunction Name="selectUserCount" Access="public" ReturnType="numeric" Hint="Select total number of users in list">
	<cfargument Name="companyID_author" Type="string" Required="No">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="userIsProductManager" Type="numeric" Required="No">
	<cfargument Name="city" Type="string" Required="No">
	<cfargument Name="state" Type="string" Required="No">
	<cfargument Name="county" Type="string" Required="No">
	<cfargument Name="zipCode" Type="string" Required="No">
	<cfargument Name="country" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="userID_not" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="returnMyCompanyUsersOnly" Type="string" Required="No" Default="">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="userHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="userHasCustomID" Type="numeric" Required="No">
	<cfargument Name="userIsActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="userStatus" Type="string" Required="No">
	<cfargument Name="userIsPrimaryContact" Type="string" Required="No">
	<cfargument Name="userNewsletterStatus" Type="string" Required="No">
	<cfargument Name="userNewsletterHtml" Type="string" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="userIsExported" Type="string" Required="No">
	<cfargument Name="userDateExported_from" Type="string" Required="No">
	<cfargument Name="userDateExported_to" Type="string" Required="No">
	<cfargument Name="userEmailVerified" Type="numeric" Required="No">
	<cfargument Name="userEmailVerifyCode" Type="string" Required="No">
	<cfargument Name="username_list" type="string" required="no">
	<cfargument Name="email_list" type="string" required="no">
	<cfargument Name="userIsLoggedIn" type="numeric" required="no">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="userDateCreated_from" Type="date" Required="No">
	<cfargument Name="userDateCreated_to" Type="date" Required="No">
	<cfargument Name="companyPrimary" Type="numeric" Required="No">

	<cfset var qry_selectUserCount = QueryNew("blank")>

	<cfquery Name="qry_selectUserCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avUser.userID) AS totalRecords
		FROM avUser, avUserCompany, avCompany
		WHERE avUser.userID = avUserCompany.userID
			AND avUserCompany.companyID = avCompany.companyID
			<cfinclude template="dataShared/qryWhere_selectUserList.cfm">
	</cfquery>

	<cfreturn qry_selectUserCount.totalRecords>
</cffunction>

<cffunction Name="selectUserList_alphabet" Access="public" ReturnType="query" Hint="Select the first letter in value of field by which list of users is ordered">
	<cfargument Name="alphabetField" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="string" Required="No">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="userIsProductManager" Type="numeric" Required="No">
	<cfargument Name="city" Type="string" Required="No">
	<cfargument Name="state" Type="string" Required="No">
	<cfargument Name="county" Type="string" Required="No">
	<cfargument Name="zipCode" Type="string" Required="No">
	<cfargument Name="country" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="userID_not" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="returnMyCompanyUsersOnly" Type="string" Required="No" Default="">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="userHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="userHasCustomID" Type="numeric" Required="No">
	<cfargument Name="userIsActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="userStatus" Type="string" Required="No">
	<cfargument Name="userIsPrimaryContact" Type="string" Required="No">
	<cfargument Name="userNewsletterStatus" Type="string" Required="No">
	<cfargument Name="userNewsletterHtml" Type="string" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="userIsExported" Type="string" Required="No">
	<cfargument Name="userDateExported_from" Type="string" Required="No">
	<cfargument Name="userDateExported_to" Type="string" Required="No">
	<cfargument Name="userEmailVerified" Type="numeric" Required="No">
	<cfargument Name="userEmailVerifyCode" Type="string" Required="No">
	<cfargument Name="username_list" type="string" required="no">
	<cfargument Name="email_list" type="string" required="no">
	<cfargument Name="userIsLoggedIn" type="numeric" required="no">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="companyPrimary" Type="numeric" Required="No">

	<cfset var qry_selectUserList_alphabet = QueryNew("blank")>

	<cfif Not ListFind("avUser.username,avUser.lastName,avUser.jobTitle,avUser.jobDepartment,avUser.jobDivision,avCompany.companyName,avCompany.companyDBA", Arguments.alphabetField)>
		<cfset Arguments.alphabetField = "avUser.lastName">
	</cfif>

	<cfquery Name="qry_selectUserList_alphabet" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Distinct(Left(#Arguments.alphabetField#, 1)) AS firstLetter
		FROM avUser, avUserCompany, avCompany
		WHERE avUser.userID = avUserCompany.userID
			AND avUserCompany.companyID = avCompany.companyID
			<cfinclude template="dataShared/qryWhere_selectUserList.cfm">
	</cfquery>

	<cfreturn qry_selectUserList_alphabet>
</cffunction>

<cffunction Name="selectUserList_alphabetPage" Access="public" ReturnType="numeric" Hint="Select page which includes the first record where the first letter in value of field by which list of users is ordered">
	<cfargument Name="queryFirstLetter" Type="string" Required="Yes">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="Yes">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="string" Required="No">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="True">
	<cfargument Name="userIsProductManager" Type="numeric" Required="No">
	<cfargument Name="city" Type="string" Required="No">
	<cfargument Name="state" Type="string" Required="No">
	<cfargument Name="county" Type="string" Required="No">
	<cfargument Name="zipCode" Type="string" Required="No">
	<cfargument Name="country" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="userID_not" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="returnMyCompanyUsersOnly" Type="string" Required="No" Default="">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="userHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="userHasCustomID" Type="numeric" Required="No">
	<cfargument Name="userIsActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="userStatus" Type="string" Required="No">
	<cfargument Name="userIsPrimaryContact" Type="string" Required="No">
	<cfargument Name="userNewsletterStatus" Type="string" Required="No">
	<cfargument Name="userNewsletterHtml" Type="string" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="userIsExported" Type="string" Required="No">
	<cfargument Name="userDateExported_from" Type="string" Required="No">
	<cfargument Name="userDateExported_to" Type="string" Required="No">
	<cfargument Name="userEmailVerified" Type="numeric" Required="No">
	<cfargument Name="userEmailVerifyCode" Type="string" Required="No">
	<cfargument Name="username_list" type="string" required="no">
	<cfargument Name="email_list" type="string" required="no">
	<cfargument Name="userIsLoggedIn" type="numeric" required="no">
	<cfargument Name="userID_author" Type="string" Required="No">
	<cfargument Name="companyPrimary" Type="numeric" Required="No">

	<cfset var qry_selectUserList_alphabetPage = QueryNew("blank")>

	<cfif Not ListFind("avUser.username,avUser.lastName,avUser.jobTitle,avUser.jobDepartment,avUser.jobDivision,avCompany.companyName,avCompany.companyDBA", Arguments.queryFirstLetter_field)>
		<cfset Arguments.queryFirstLetter_field = "avUser.lastName">
	</cfif>

	<cfquery Name="qry_selectUserList_alphabetPage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avUser.userID) AS userCountBeforeAlphabet
		FROM avUser, avUserCompany, avCompany
		WHERE avUser.userID = avUserCompany.userID
			AND avUserCompany.companyID = avCompany.companyID
			<cfinclude template="dataShared/qryWhere_selectUserList.cfm">
		<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1 or Not REFind("[a-zA-Z]", Arguments.queryFirstLetter)>
			AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
		<cfelse><!--- letter --->
			AND (Left(#Arguments.queryFirstLetter_field#, 1) < '#UCase(Arguments.queryFirstLetter)#'
				OR Left(#Arguments.queryFirstLetter_field#, 1) < '#LCase(Arguments.queryFirstLetter)#')
		</cfif>
	</cfquery>

	<cfreturn 1 + (qry_selectUserList_alphabetPage.userCountBeforeAlphabet \ Arguments.queryDisplayPerPage)>
</cffunction>
<!--- /functions for viewing list of users --->

<!--- Update Export Status --->
<cffunction Name="updateUserIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether user records have been exported. Returns True.">
	<cfargument Name="userID" Type="string" Required="Yes">
	<cfargument Name="userIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.userID) or (Arguments.userIsExported is not "" and Not ListFind("0,1", Arguments.userIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateUserIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avUser
			SET userIsExported = <cfif Not ListFind("0,1", Arguments.userIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.userIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				userDateExported = <cfif Not ListFind("0,1", Arguments.userIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="generateUserEmailVerifyCode" Access="public" Output="No" ReturnType="string" Hint="Generates a unique ID for email verification code.">
	<cfreturn Replace(CreateUUID(), "-", "", "ALL")>
</cffunction>

</cfcomponent>
