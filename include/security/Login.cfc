<cfcomponent DisplayName="Login" Hint="Manages login process">

<cffunction Name="processLogin" Access="public" Output="No" ReturnType="string" Hint="Processes login and returns error/confirmation message. If successful, initiates session.">
	<cfargument Name="username" Type="string" Required="Yes">
	<cfargument Name="password" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyDirectory" Type="string" Required="Yes">
	<cfargument Name="isWebServicesLogin" Type="boolean" Required="No" Default="False">

	<cfset var usernameIsDisabled = False>
	<cfset var newPermissionStruct = StructNew()>
	<cfset var companyDirectoryLogin = "">
	<cfset var companyDirectoryInclude = "">
	<cfset var affiliateID_list = 0>
	<cfset var cobrandID_list = 0>

	<cfinclude template="lang_processLogin.cfm">
	<cfif Trim(Arguments.username) is "">
		<cfreturn Variables.lang_processLogin.username_blank>
	<cfelseif Trim(Arguments.password) is "">
		<cfreturn Variables.lang_processLogin.password_blank>
	<cfelse>
		<!--- check whether username is disabled --->
		<cfinvoke component="#Application.billingMapping#include.security.Login" Method="checkCompanyID_author" ReturnVariable="realCompanyID_author">
			<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
			<cfinvokeargument Name="companyDirectory" Value="#Arguments.companyDirectory#">
		</cfinvoke>

		<cfinvoke component="#Application.billingMapping#data.LoginAttempt" Method="selectLoginAttempt" ReturnVariable="qry_selectLoginAttempt">
			<cfinvokeargument Name="companyID_author" Value="#realCompanyID_author#">
			<cfinvokeargument Name="loginAttemptUsername" Value="#Arguments.username#">
		</cfinvoke>

		<cfif qry_selectLoginAttempt.RecordCount is not 0>
			<cfloop Query="qry_selectLoginAttempt">
				<cfif qry_selectLoginAttempt.loginAttemptCount gte 2 and DateDiff("n", qry_selectLoginAttempt.loginAttemptDateUpdated, Now()) lt 30>
					<cfset usernameIsDisabled = True>
				<cfelseif DateDiff("n", qry_selectLoginAttempt.loginAttemptDateUpdated, Now()) gt 30>
					<cfinvoke component="#Application.billingMapping#data.LoginAttempt" Method="deleteLoginAttempt" ReturnVariable="isLoginAttemptDeleted">
						<cfinvokeargument Name="loginAttemptID" Value="#qry_selectLoginAttempt.loginAttemptID#">
					</cfinvoke>
				</cfif>
			</cfloop>
		</cfif>

		<cfif usernameIsDisabled is True>
			<cfreturn Variables.lang_processLogin.username_disabled>
		<cfelse>
			<cfinvoke component="#Application.billingMapping#include.security.Login" Method="checkLogin" ReturnVariable="qry_checkLogin">
				<cfinvokeargument Name="username" Value="#Arguments.username#">
				<cfinvokeargument Name="password" Value="#Arguments.password#">
				<cfinvokeargument Name="companyID_author" Value="#Arguments.companyID_author#">
				<cfinvokeargument Name="companyDirectory" Value="#Arguments.companyDirectory#">
			</cfinvoke>

			<cfif qry_checkLogin.RecordCount is not 1>
				<!--- if username is already disabled, update. else insert. --->
				<cfif qry_selectLoginAttempt.RecordCount is 0>
					<cfinvoke component="#Application.billingMapping#data.LoginAttempt" Method="insertLoginAttempt" ReturnVariable="isLoginAttemptInserted">
						<cfinvokeargument Name="companyID_author" Value="#realCompanyID_author#">
						<cfinvokeargument Name="loginAttemptUsername" Value="#Arguments.username#">
					</cfinvoke>
				<cfelse>
					<cfinvoke component="#Application.billingMapping#data.LoginAttempt" Method="updateLoginAttempt" ReturnVariable="isLoginAttemptInserted">
						<cfinvokeargument Name="loginAttemptID" Value="#qry_selectLoginAttempt.loginAttemptID[1]#">
					</cfinvoke>
				</cfif>

				<cfreturn Variables.lang_processLogin.incorrectLogin>

			<cfelseif qry_checkLogin.userStatus is not 1>
				<cfreturn Variables.lang_processLogin.noPermission_user>
			<cfelseif qry_checkLogin.companyPrimary is 0 and qry_checkLogin.companyIsAffiliate is 0
					and qry_checkLogin.companyIsVendor is 0 and qry_checkLogin.companyIsCobrand is 0>
				<cfreturn Variables.lang_processLogin.noPermission_partner>
			<cfelse>
				<!--- if necessary, validate IP address --->
				<cfinvoke component="#Application.billingMapping#include.security.Login" Method="validateIPaddress" ReturnVariable="customerIPisOk">
					<cfinvokeargument Name="companyID_author" Value="#qry_checkLogin.companyID_author#">
					<cfinvokeargument Name="isWebServicesLogin" Value="#Arguments.isWebServicesLogin#">
				</cfinvoke>

				<cfif customerIPisOk is False>
					<cfreturn Variables.lang_processLogin.noPermission_IPaddress>
				<cfelse><!--- get user permissions --->
					<cfinvoke component="#Application.billingMapping#include.security.Login" Method="checkLoginGroup" ReturnVariable="qry_checkLoginGroup">
						<cfinvokeargument Name="userID" Value="#qry_checkLogin.userID#">
						<cfinvokeargument Name="companyID" Value="#qry_checkLogin.companyID#">
					</cfinvoke>

					<cfinvoke component="#Application.billingMapping#include.security.Login" Method="checkLoginPermission" ReturnVariable="qry_checkLoginPermission">
						<cfinvokeargument Name="userID" Value="#qry_checkLogin.userID#">
						<cfinvokeargument Name="groupID" Value="#ValueList(qry_checkLoginGroup.groupID)#">
					</cfinvoke>

					<cfset temp = StructClear(newPermissionStruct)>
					<cfloop Query="qry_checkLoginPermission">
						<cfif Not StructKeyExists(newPermissionStruct, "cat#permissionCategoryID#")>
							<cfset newPermissionStruct["cat#permissionCategoryID#"] = permissionTargetBinaryTotal>
						<cfelse>
							<cfset newPermissionStruct["cat#permissionCategoryID#"] = BitOr(newPermissionStruct["cat#permissionCategoryID#"], permissionTargetBinaryTotal)>
						</cfif>
					</cfloop>

					<cfif Arguments.isWebServicesLogin is True
							and (Not StructKeyExists(newPermissionStruct, "cat#Application.permissionStruct.userWebServiceLoginPermitted.permissionCategoryID#")
								or Not BitAnd(newPermissionStruct["cat#Application.permissionStruct.userWebServiceLoginPermitted.permissionCategoryID#"], Application.permissionStruct.userWebServiceLoginPermitted.permissionBinaryNumber))>
						<cfreturn Variables.lang_processLogin.noPermission_webservice>
					<cfelse>
						<!--- determine company directory for custom header and footer --->
						<cfif qry_checkLogin.companyDirectory is not "">
							<cfset companyDirectoryLogin = qry_checkLogin.companyDirectory>
						<cfelseif qry_checkLogin.companyPrimary is 0>
							<cfinvoke component="#Application.billingMapping#include.security.Login" Method="checkCompanyDirectory" ReturnVariable="theCompanyDirectory">
								<cfinvokeargument Name="companyID_author" Value="#qry_checkLogin.companyID_author#">
							</cfinvoke>
							<cfset companyDirectoryLogin = theCompanyDirectory>
						</cfif>

						<cfif companyDirectoryLogin is not "" and Not DirectoryExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & companyDirectoryLogin)>
							<cfset companyDirectoryLogin = "">
						</cfif>

						<!--- if affiliate, get affiliateID's --->
						<cfset affiliateID_list = 0>
						<cfset cobrandID_list = 0>
						<cfset companyID_author = qry_checkLogin.companyID>

						<cfif qry_checkLogin.companyIsAffiliate is 1>
							<cfinvoke component="#Application.billingMapping#include.security.Login" Method="checkLoginAffiliate" ReturnVariable="qry_checkLoginAffiliate">
								<cfinvokeargument Name="companyID" Value="#qry_checkLogin.companyID#">
							</cfinvoke>

							<cfif qry_checkLoginAffiliate.RecordCount is not 0>
								<cfset affiliateID_list = ValueList(qry_checkLoginAffiliate.affiliateID)>
								<cfset companyID_author = qry_checkLoginAffiliate.companyID_author[1]>
							</cfif>
						</cfif>

						<!--- if cobrand, get cobrandID's --->
						<cfif qry_checkLogin.companyIsCobrand is 1>
							<cfinvoke component="#Application.billingMapping#include.security.Login" Method="checkLoginCobrand" ReturnVariable="qry_checkLoginCobrand">
								<cfinvokeargument Name="companyID" Value="#qry_checkLogin.companyID#">
							</cfinvoke>
					
							<cfif qry_checkLoginCobrand.RecordCount is not 0>
								<cfset cobrandID_list = ValueList(qry_checkLoginCobrand.cobrandID)>
								<cfset companyID_author = qry_checkLoginCobrand.companyID_author[1]>
							</cfif>
						</cfif>

						<cfif Application.billingTrackLoginSessions is True>
							<cfinvoke component="#Application.billingMapping#data.LoginSession" method="insertLoginSession" returnVariable="loginSessionID_new">
								<cfinvokeargument name="userID" value="#qry_checkLogin.userID#">
							</cfinvoke>
						</cfif>

						<cflock Scope="Session" Timeout="5">
							<cfset Session.userID = qry_checkLogin.userID>
							<cfset Session.companyID = qry_checkLogin.companyID>
							<cfset Session.cobrandID = qry_checkLogin.cobrandID>
							<cfset Session.cobrandID_list = cobrandID_list>
							<cfset Session.affiliateID = qry_checkLogin.affiliateID>
							<cfset Session.affiliateID_list = affiliateID_list>
							<cfset Session.companyID_author = companyID_author>
							<cfif qry_checkLoginGroup.RecordCount is not 0>
								<cfset Session.groupID = ValueList(qry_checkLoginGroup.groupID)>
							<cfelse>
								<cfset Session.groupID = 0>
							</cfif>
							<cfset Session.permissionStruct = newPermissionStruct>
							<cfset Session.companyDirectory = companyDirectoryLogin>
							<cfif Application.billingTrackLoginSessions is True>
								<cfset Application.loginSessionID = loginSessionID_new>
							</cfif>
						</cflock>

						<cfif Application.fn_IsUserAuthorized("listContactTopics") or Application.fn_IsUserAuthorized("listContactTemplates")
								or Application.fn_IsUserAuthorized("listStatuses") or Application.fn_IsUserAuthorized("listPrices")
								or Application.fn_IsUserAuthorized("listCustomFields") or Application.fn_IsUserAuthorized("listTemplates")
								or Application.fn_IsUserAuthorized("listPermissionCategories") or Application.fn_IsUserAuthorized("listPrimaryTargets")
								or Application.fn_IsUserAuthorized("listPayflows") or Application.fn_IsUserAuthorized("listImageDirectories")
								or Application.fn_IsUserAuthorized("listMerchants") or Application.fn_IsUserAuthorized("listMerchantAccounts")
								or Application.fn_IsUserAuthorized("listContentCategories") or Application.fn_IsUserAuthorized("listGroups")
								or Application.fn_IsUserAuthorized("listCategories") or Application.fn_IsUserAuthorized("listPaymentCategories")
								or Application.fn_IsUserAuthorized("listSchedulers") or Application.fn_IsUserAuthorized("listIPaddresses")
								or Application.fn_IsUserAuthorized("listCommissions") or Application.fn_IsUserAuthorized("listLoginAttempts")
								or Application.fn_IsUserAuthorized("listTriggerActions")>
							<cflock Scope="Session" Timeout="5">
								<cfset Session.isSetupPermission = True>
							</cflock>
						</cfif>

						<cfreturn "True">
					</cfif><!--- /if webservices login, user has permission --->
				</cfif><!--- /IP address is not restricted --->
			</cfif><!--- /login information is correct --->
		</cfif><!--- /username is not disabled --->
	</cfif><!--- /username and password are not blank --->
</cffunction>

<cffunction Name="checkLogin" Access="public" Output="No" ReturnType="query" Hint="Validates username and password to ensure user exists for that company">
	<cfargument Name="username" Type="string" Required="Yes">
	<cfargument Name="password" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyDirectory" Type="string" Required="Yes">

	<cfset var qry_checkLogin = QueryNew("blank")>

	<cfquery Name="qry_checkLogin" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUser.userID, avUser.userStatus, avUser.companyID, avUser.firstName,
			avUser.lastName, avUser.email, avUser.userEmailVerified, avUser.userEmailVerifyCode,
			avCompany.companyPrimary, avCompany.companyIsAffiliate, avCompany.companyIsVendor,
			avCompany.companyIsCobrand, avCompany.companyIsCustomer, avCompany.cobrandID,
			avCompany.affiliateID, avCompany.companyDirectory, avCompany.companyID_author
		FROM avUser, avCompany
		WHERE avUser.companyID = avCompany.companyID
			AND avUser.username = <cfqueryparam Value="#Arguments.username#" cfsqltype="cf_sql_varchar">
			AND avUser.password = <cfqueryparam Value="#Application.fn_HashString(Arguments.password)#" cfsqltype="cf_sql_varchar">
			<cfif Trim(Arguments.companyDirectory) is not "">
				AND avCompany.companyDirectory = <cfqueryparam Value="#Arguments.companyDirectory#" cfsqltype="cf_sql_varchar">
			<cfelseif Application.fn_IsIntegerPositive(Arguments.companyID_author)>
				AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			<!--- 
			<cfelse>
				AND avCompany.companyID_author = <cfqueryparam Value="-1" cfsqltype="cf_sql_integer">
			--->
			</cfif>
	</cfquery>

	<cfreturn qry_checkLogin>
</cffunction>

<cffunction Name="checkCompanyDirectory" Access="public" Output="No" ReturnType="string" Hint="Returns company directory where custom files are stored.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">

	<cfset var qry_checkCompanyDirectory = QueryNew("blank")>

	<cfquery Name="qry_checkCompanyDirectory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyDirectory
		FROM avCompany
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_checkCompanyDirectory.companyDirectory>
</cffunction>

<cffunction Name="checkLoginAffiliate" Access="public" Output="No" ReturnType="query" Hint="Returns list of affiliates for that company.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkLoginAffiliate = QueryNew("blank")>

	<cfquery Name="qry_checkLoginAffiliate" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT affiliateID, companyID_author
		FROM avAffiliate
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_checkLoginAffiliate>
</cffunction>

<cffunction Name="checkLoginCobrand" Access="public" Output="No" ReturnType="query" Hint="Returns list of cobrands for that company.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkLoginCobrand = QueryNew("blank")>

	<cfquery Name="qry_checkLoginCobrand" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT cobrandID, companyID_author, cobrandDirectory
		FROM avCobrand
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_checkLoginCobrand>
</cffunction>

<cffunction Name="checkLoginGroup" Access="public" Output="No" ReturnType="query" Hint="Returns list of groups for that user.">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkLoginGroup = QueryNew("blank")>

	<cfquery Name="qry_checkLoginGroup" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avGroupTarget.groupID
		FROM avGroupTarget, avGroup
		WHERE avGroupTarget.groupID = avGroup.groupID
			AND avGroup.groupStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avGroupTarget.groupTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND ((avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("userID")#" cfsqltype="cf_sql_integer">
					AND avGroupTarget.targetID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">)
				OR (avGroupTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("companyID")#" cfsqltype="cf_sql_integer">
					AND avGroupTarget.targetID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">))
	</cfquery>

	<cfreturn qry_checkLoginGroup>
</cffunction>

<cffunction Name="checkLoginPermission" Access="public" Output="No" ReturnType="query" Hint="Returns list of permissions based on user and groups.">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="groupID" Type="string" Required="Yes">

	<cfset var qry_checkLoginPermission = QueryNew("blank")>

	<cfquery Name="qry_checkLoginPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT permissionCategoryID, permissionTargetBinaryTotal
		FROM avPermissionTarget
		WHERE permissionTargetStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND ((primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("userID")#" cfsqltype="cf_sql_integer">
					AND targetID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">)
			<cfif Application.fn_IsIntegerList(Arguments.groupID)>
				OR (primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("groupID")#" cfsqltype="cf_sql_integer">
					AND targetID IN (<cfqueryparam Value="#Arguments.groupID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
			</cfif>
				)
		ORDER BY permissionCategoryID
	</cfquery>

	<cfreturn qry_checkLoginPermission>
</cffunction>

<!--- Track failed login attempts --->
<cffunction Name="checkCompanyID_author" Access="public" Output="No" ReturnType="numeric" Hint="Selects companyID_author based on companyID_author or companyDirectory.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyDirectory" Type="string" Required="Yes">

	<cfset var qry_checkCompanyID_author = QueryNew("blank")>

	<cfquery Name="qry_checkCompanyID_author" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID_author
		FROM avCompany
		WHERE companyPrimary = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			<cfif Trim(Arguments.companyDirectory) is not "">
				AND avCompany.companyDirectory = <cfqueryparam Value="#Arguments.companyDirectory#" cfsqltype="cf_sql_varchar">
			<cfelseif Application.fn_IsIntegerPositive(Arguments.companyID_author)>
				AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkCompanyID_author.RecordCount is 1>
		<cfreturn qry_checkCompanyID_author.companyID_author>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>

<cffunction Name="validateIPaddress" Access="public" Output="No" ReturnType="boolean" Hint="Determines whether user is logging in from a valid IP address.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="isWebServicesLogin" Type="boolean" Required="No" Default="False">

	<cfset var customerIPisOk = True>
	<cfset var customerIP = CGI.REMOTE_ADDR>
	<cfset var ipTest = customerIP>
	<cfset var testIPpart = "">
	<cfset var ipMin = "">
	<cfset var ipMax = "">

	<cfinvoke Component="#Application.billingMapping#data.IPaddress" Method="selectIPaddressList" ReturnVariable="qry_selectIPaddressList">
		<cfinvokeargument Name="companyID" Value="#Arguments.companyID_author#">
		<cfif Arguments.isWebServicesLogin is False>
			<cfinvokeargument Name="IPaddressBrowser" Value="1">
		<cfelse>
			<cfinvokeargument Name="IPaddressWebService" Value="1">
		</cfif>
	</cfinvoke>

	<cfif qry_selectIPaddressList.RecordCount is not 0>
		<cfset customerIPisOk = False>

		<!--- pad with zero's for easier comparison --->
		<cfloop Index="count" From="1" To="4">
			<cfset testIPpart = ListGetAt(ipTest, count, ".")>
			<cfif Len(testIPpart) is 1>
				<cfset ipTest = ListSetAt(ipTest, count, "00" & testIPpart, ".")>
			<cfelseif Len(testIPpart) is 2>
				<cfset ipTest = ListSetAt(ipTest, count, "0" & testIPpart, ".")>
			</cfif>
		</cfloop>

		<cfloop Query="qry_selectIPaddressList">
			<cfif customerIP is qry_selectIPaddressList.IPaddress
					or (customerIP is qry_selectIPaddressList.IPaddress_max and qry_selectIPaddressList.IPaddress_max is not "")>
				<cfset customerIPisOk = True>
				<cfbreak>
			<cfelseif qry_selectIPaddressList.IPaddress_max is not "">
				<cfset ipMin = qry_selectIPaddressList.IPaddress>
				<cfset ipMax = qry_selectIPaddressList.IPaddress_max>

				<!--- pad with zero's for easier comparison --->
				<cfloop Index="count" From="1" To="4">
					<cfset testIPpart = ListGetAt(ipMin, count, ".")>
					<cfif Len(testIPpart) is 1>
						<cfset ipMin = ListSetAt(ipMin, count, "00" & testIPpart, ".")>
					<cfelseif Len(testIPpart) is 2>
						<cfset ipMin = ListSetAt(ipMin, count, "0" & testIPpart, ".")>
					</cfif>
				</cfloop>

				<!--- pad with zero's for easier comparison --->
				<cfloop Index="count" From="1" To="4">
					<cfset testIPpart = ListGetAt(ipMax, count, ".")>
					<cfif Len(testIPpart) is 1>
						<cfset ipMax = ListSetAt(ipMax, count, "00" & testIPpart, ".")>
					<cfelseif Len(testIPpart) is 2>
						<cfset ipMax = ListSetAt(ipMax, count, "0" & testIPpart, ".")>
					</cfif>
				</cfloop>

				<!--- compare as string to check if customer IP is within IP range --->
				<cfif ipTest gte ipMin and ipTest lte ipMax>
					<cfset customerIPisOk = True>
					<cfbreak>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn customerIPisOk>
</cffunction>

</cfcomponent>
