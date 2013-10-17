<cfcomponent DisplayName="MerchantAccount" Hint="Manages creating and viewing merchant accounts.">

<cffunction name="maxlength_MerchantAccount" access="public" output="no" returnType="struct">
	<cfset var maxlength_MerchantAccount = StructNew()>

	<cfset maxlength_MerchantAccount.merchantAccountUsername_decrypted = 50>
	<cfset maxlength_MerchantAccount.merchantAccountUsername = 100>
	<cfset maxlength_MerchantAccount.merchantAccountPassword_decrypted = 50>
	<cfset maxlength_MerchantAccount.merchantAccountPassword = 100>
	<cfset maxlength_MerchantAccount.merchantAccountID_custom_decrypted = 50>
	<cfset maxlength_MerchantAccount.merchantAccountID_custom = 100>
	<cfset maxlength_MerchantAccount.merchantAccountDescription = 255>
	<cfset maxlength_MerchantAccount.merchantAccountName = 100>
	<cfset maxlength_MerchantAccount.merchantAccountCreditCardTypeList = 100>

	<cfreturn maxlength_MerchantAccount>
</cffunction>

<cffunction Name="insertMerchantAccount" Access="public" Output="No" ReturnType="numeric" Hint="Inserts merchant account information for a company">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="merchantID" Type="numeric" Required="Yes">
	<cfargument Name="merchantAccountUsername" Type="string" Required="Yes">
	<cfargument Name="merchantAccountPassword" Type="string" Required="Yes">
	<cfargument Name="merchantAccountBank" Type="numeric" Required="No" Default="0">
	<cfargument Name="merchantAccountCreditCard" Type="numeric" Required="No" Default="0">
	<cfargument Name="merchantAccountID_custom" Type="string" Required="No" Default="">
	<cfargument Name="merchantAccountDescription" Type="string" Required="No" Default="">
	<cfargument Name="merchantAccountStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="merchantAccountName" Type="string" Required="No" Default="">
	<cfargument Name="merchantAccountCreditCardTypeList" Type="string" Required="No" Default="">

	<cfset var qry_insertMerchantAccount = QueryNew("blank")>

	<cfif Arguments.merchantAccountUsername is not "">
		<cfset Arguments.merchantAccountUsername = Application.fn_EncryptString(Arguments.merchantAccountUsername)>
	</cfif>
	<cfif Arguments.merchantAccountPassword is not "">
		<cfset Arguments.merchantAccountPassword = Application.fn_EncryptString(Arguments.merchantAccountPassword)>	
	</cfif>
	<cfif Arguments.merchantAccountID_custom is not "">
		<cfset Arguments.merchantAccountID_custom = Application.fn_EncryptString(Arguments.merchantAccountID_custom)>	
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.MerchantAccount" method="maxlength_MerchantAccount" returnVariable="maxlength_MerchantAccount" />

	<cfquery Name="qry_insertMerchantAccount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avMerchantAccount
		(
			companyID, userID, merchantID, merchantAccountUsername, merchantAccountPassword, merchantAccountID_custom,
			merchantAccountStatus, merchantAccountBank, merchantAccountCreditCard, merchantAccountDescription, merchantAccountName,
			merchantAccountCreditCardTypeList, merchantAccountDateCreated, merchantAccountDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.merchantID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.merchantAccountUsername#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountUsername#">,
			<cfqueryparam Value="#Arguments.merchantAccountPassword#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountPassword#">,
			<cfqueryparam Value="#Arguments.merchantAccountID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountID_custom#">,
			<cfqueryparam Value="#Arguments.merchantAccountStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.merchantAccountBank#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.merchantAccountCreditCard#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.merchantAccountDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountDescription#">,
			<cfqueryparam Value="#Arguments.merchantAccountName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountName#">,
			<cfqueryparam Value="#Arguments.merchantAccountCreditCardTypeList#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountCreditCardTypeList#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "merchantAccountID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertMerchantAccount.primaryKeyID>
</cffunction>

<cffunction Name="updateMerchantAccount" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing merchant account information for a company">
	<cfargument Name="merchantAccountID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="merchantID" Type="numeric" Required="No">
	<cfargument Name="merchantAccountUsername" Type="string" Required="No">
	<cfargument Name="merchantAccountPassword" Type="string" Required="No">
	<cfargument Name="merchantAccountBank" Type="numeric" Required="No">
	<cfargument Name="merchantAccountCreditCard" Type="numeric" Required="No">
	<cfargument Name="merchantAccountID_custom" Type="string" Required="No">
	<cfargument Name="merchantAccountDescription" Type="string" Required="No">
	<cfargument Name="merchantAccountStatus" Type="numeric" Required="No">
	<cfargument Name="merchantAccountName" Type="string" Required="No">
	<cfargument Name="merchantAccountCreditCardTypeList" Type="string" Required="No">

	<cfif StructKeyExists(Arguments, "merchantAccountUsername") and Arguments.merchantAccountUsername is not "">
		<cfset Arguments.merchantAccountUsername = Application.fn_EncryptString(Arguments.merchantAccountUsername)>
	</cfif>
	<cfif StructKeyExists(Arguments, "merchantAccountPassword") and Arguments.merchantAccountPassword is not "">
		<cfset Arguments.merchantAccountPassword = Application.fn_EncryptString(Arguments.merchantAccountPassword)>	
	</cfif>
	<cfif StructKeyExists(Arguments, "merchantAccountID_custom") and Arguments.merchantAccountID_custom is not "">
		<cfset Arguments.merchantAccountID_custom = Application.fn_EncryptString(Arguments.merchantAccountID_custom)>	
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.MerchantAccount" method="maxlength_MerchantAccount" returnVariable="maxlength_MerchantAccount" />

	<cfquery Name="qry_updateMerchantAccount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avMerchantAccount
		SET 
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountStatus") and ListFind("0,1", Arguments.merchantAccountStatus)>merchantAccountStatus = <cfqueryparam Value="#Arguments.merchantAccountStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountBank") and ListFind("0,1", Arguments.merchantAccountBank)>merchantAccountBank = <cfqueryparam Value="#Arguments.merchantAccountBank#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountCreditCard") and ListFind("0,1", Arguments.merchantAccountCreditCard)>merchantAccountCreditCard = <cfqueryparam Value="#Arguments.merchantAccountCreditCard#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountUsername")>merchantAccountUsername = <cfqueryparam Value="#Arguments.merchantAccountUsername#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountUsername#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountPassword")>merchantAccountPassword = <cfqueryparam Value="#Arguments.merchantAccountPassword#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountPassword#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountID_custom")>merchantAccountID_custom = <cfqueryparam Value="#Arguments.merchantAccountID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountDescription")>merchantAccountDescription = <cfqueryparam Value="#Arguments.merchantAccountDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountName")>merchantAccountName = <cfqueryparam Value="#Arguments.merchantAccountName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountName#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantAccountCreditCardTypeList")>merchantAccountCreditCardTypeList = <cfqueryparam Value="#Arguments.merchantAccountCreditCardTypeList#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_MerchantAccount.merchantAccountCreditCardTypeList#">,</cfif>
			merchantAccountDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE merchantAccountID = <cfqueryparam Value="#Arguments.merchantAccountID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkMerchantAccountNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that merchant account name is unique for company">
	<cfargument Name="merchantAccountName" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="merchantAccountID" Type="numeric" Required="No">

	<cfset var qry_checkMerchantAccountNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkMerchantAccountNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT merchantAccountID
		FROM avMerchantAccount
		WHERE merchantAccountName = <cfqueryparam Value="#Arguments.merchantAccountName#" cfsqltype="cf_sql_varchar">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "merchantAccountID") and Application.fn_IsIntegerNonNegative(Arguments.merchantAccountID)>
				AND merchantAccountID <> <cfqueryparam Value="#Arguments.merchantAccountID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkMerchantAccountNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectMerchantAccount" Access="public" Output="No" ReturnType="query" Hint="Updates existing merchant account information for a company">
	<cfargument Name="merchantAccountID" Type="numeric" Required="Yes">
	<cfargument Name="returnMerchantFields" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectMerchantAccount = QueryNew("blank")>
	<cfset var temp = "">

	<cfquery Name="qry_selectMerchantAccount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avMerchantAccount.companyID, avMerchantAccount.userID, avMerchantAccount.merchantID,
			avMerchantAccount.merchantAccountUsername, avMerchantAccount.merchantAccountPassword,
			avMerchantAccount.merchantAccountID_custom, avMerchantAccount.merchantAccountStatus,
			avMerchantAccount.merchantAccountBank, avMerchantAccount.merchantAccountCreditCard,
			avMerchantAccount.merchantAccountDescription, avMerchantAccount.merchantAccountName,
			avMerchantAccount.merchantAccountCreditCardTypeList, avMerchantAccount.merchantAccountDateCreated,
			avMerchantAccount.merchantAccountDateUpdated
			<cfif Arguments.returnMerchantFields is True>
				, avMerchant.merchantTitle, avMerchant.merchantFilename,
				avMerchant.merchantBank, avMerchant.merchantCreditCard
			</cfif>
		FROM avMerchantAccount
			<cfif Arguments.returnMerchantFields is True>
				LEFT OUTER JOIN avMerchant ON avMerchantAccount.merchantID = avMerchant.merchantID
			</cfif>
		WHERE avMerchantAccount.merchantAccountID = <cfqueryparam Value="#Arguments.merchantAccountID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_selectMerchantAccount.merchantAccountUsername is not "">
		<cfset temp = QuerySetCell(qry_selectMerchantAccount, "merchantAccountUsername", Application.fn_DecryptString(qry_selectMerchantAccount.merchantAccountUsername), 1)>
	</cfif>
	<cfif qry_selectMerchantAccount.merchantAccountPassword is not "">
		<cfset temp = QuerySetCell(qry_selectMerchantAccount, "merchantAccountPassword", Application.fn_DecryptString(qry_selectMerchantAccount.merchantAccountPassword), 1)>
	</cfif>
	<cfif qry_selectMerchantAccount.merchantAccountID_custom is not "">
		<cfset temp = QuerySetCell(qry_selectMerchantAccount, "merchantAccountID_custom", Application.fn_DecryptString(qry_selectMerchantAccount.merchantAccountID_custom), 1)>
	</cfif>

	<cfreturn qry_selectMerchantAccount>
</cffunction>

<cffunction Name="selectMerchantAccountList" Access="public" Output="No" ReturnType="query" Hint="Updates existing merchant account information for a company">
	<cfargument Name="merchantAccountID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="merchantID" Type="string" Required="No">
	<cfargument Name="merchantAccountBank" Type="numeric" Required="No">
	<cfargument Name="merchantAccountCreditCard" Type="numeric" Required="No">
	<cfargument Name="merchantAccountStatus" Type="numeric" Required="No">
	<cfargument Name="returnMerchantFields" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectMerchantAccountList = QueryNew("blank")>
	<cfset var temp = "">

	<cfquery Name="qry_selectMerchantAccountList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avMerchantAccount.merchantAccountID, avMerchantAccount.companyID, avMerchantAccount.userID, avMerchantAccount.merchantID,
			avMerchantAccount.merchantAccountUsername, avMerchantAccount.merchantAccountPassword,
			avMerchantAccount.merchantAccountID_custom, avMerchantAccount.merchantAccountStatus,
			avMerchantAccount.merchantAccountBank, avMerchantAccount.merchantAccountCreditCard,
			avMerchantAccount.merchantAccountDescription, avMerchantAccount.merchantAccountName,
			avMerchantAccount.merchantAccountCreditCardTypeList, avMerchantAccount.merchantAccountDateCreated,
			avMerchantAccount.merchantAccountDateUpdated
			<cfif Arguments.returnMerchantFields is True>
				, avMerchant.merchantTitle, avMerchant.merchantFilename,
				avMerchant.merchantBank, avMerchant.merchantCreditCard
			</cfif>
		FROM avMerchantAccount
			<cfif Arguments.returnMerchantFields is True>
				LEFT OUTER JOIN avMerchant ON avMerchantAccount.merchantID = avMerchant.merchantID
			</cfif>
		WHERE avMerchantAccount.merchantAccountID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="merchantAccountID,merchantID,companyID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND avMerchantAccount.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfloop Index="field" List="merchantAccountBank,merchantAccountCreditCard,merchantAccountStatus">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND avMerchantAccount.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
	</cfquery>

	<cfloop Query="qry_selectMerchantAccountList">
		<cfif qry_selectMerchantAccountList.merchantAccountUsername is not "">
			<cfset temp = QuerySetCell(qry_selectMerchantAccountList, "merchantAccountUsername", Application.fn_DecryptString(qry_selectMerchantAccountList.merchantAccountUsername), CurrentRow)>
		</cfif>
		<cfif qry_selectMerchantAccountList.merchantAccountPassword is not "">
			<cfset temp = QuerySetCell(qry_selectMerchantAccountList, "merchantAccountPassword", Application.fn_DecryptString(qry_selectMerchantAccountList.merchantAccountPassword), CurrentRow)>
		</cfif>
		<cfif qry_selectMerchantAccountList.merchantAccountID_custom is not "">
			<cfset temp = QuerySetCell(qry_selectMerchantAccountList, "merchantAccountID_custom", Application.fn_DecryptString(qry_selectMerchantAccountList.merchantAccountID_custom), CurrentRow)>
		</cfif>
	</cfloop>

	<cfreturn qry_selectMerchantAccountList>
</cffunction>

<cffunction Name="checkMerchantAccountPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that requested merchant account is for specified user or company">
	<cfargument Name="merchantAccountID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkMerchantAccountPermission = QueryNew("blank")>

	<cfquery Name="qry_checkMerchantAccountPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT merchantAccountID
		FROM avMerchantAccount
		WHERE merchantAccountID = <cfqueryparam Value="#Arguments.merchantAccountID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_checkMerchantAccountPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectMerchantAccountIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects merchantAccount of existing merchant account via custom ID and returns merchantAccountID(s) if exists, 0 if not exists, and -1 if multiple merchant account(s) have the same merchantAccountID_custom.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="merchantAccountID_custom" Type="string" Required="Yes">

	<cfset var qry_selectMerchantAccountIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectMerchantAccountIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT merchantAccountID
		FROM avMerchantAccount
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND merchantAccountID_custom IN (<cfqueryparam Value="#Arguments.merchantAccountID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectMerchantAccountIDViaCustomID.RecordCount is 0 or qry_selectMerchantAccountIDViaCustomID.RecordCount lt ListLen(Arguments.merchantAccountID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectMerchantAccountIDViaCustomID.RecordCount gt ListLen(Arguments.merchantAccountID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectMerchantAccountIDViaCustomID.merchantAccountID)>
	</cfif>
</cffunction>

</cfcomponent>
