<cfcomponent DisplayName="Bank" Hint="Manages creating and viewing user and company bank accounts">

<cffunction name="maxlength_Bank" access="public" output="no" returnType="struct">
	<cfset var maxlength_Bank = StructNew()>

	<cfset maxlength_Bank.bankName = 255>
	<cfset maxlength_Bank.bankBranch = 255>
	<cfset maxlength_Bank.bankBranchCity = 50>
	<cfset maxlength_Bank.bankBranchState = 50>
	<cfset maxlength_Bank.bankBranchCountry = 100>
	<cfset maxlength_Bank.bankBranchContactName = 100>
	<cfset maxlength_Bank.bankBranchPhone = 25>
	<cfset maxlength_Bank.bankBranchFax = 25>
	<cfset maxlength_Bank.bankRoutingNumber_decrypted = 50>
	<cfset maxlength_Bank.bankRoutingNumber = 100>
	<cfset maxlength_Bank.bankAccountNumber_decrypted = 50>
	<cfset maxlength_Bank.bankAccountNumber = 100>
	<cfset maxlength_Bank.bankAccountName = 100>
	<cfset maxlength_Bank.bankDescription = 255>
	<cfset maxlength_Bank.bankAccountType = 50>

	<cfreturn maxlength_Bank>
</cffunction>

<cffunction Name="insertBank" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new bank into database and returns bankID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="bankName" Type="string" Required="No" Default="">
	<cfargument Name="bankBranch" Type="string" Required="No" Default="">
	<cfargument Name="bankBranchCity" Type="string" Required="No" Default="">
	<cfargument Name="bankBranchState" Type="string" Required="No" Default="">
	<cfargument Name="bankBranchCountry" Type="string" Required="No" Default="">
	<cfargument Name="bankBranchContactName" Type="string" Required="No" Default="">
	<cfargument Name="bankBranchPhone" Type="string" Required="No" Default="">
	<cfargument Name="bankBranchFax" Type="string" Required="No" Default="">
	<cfargument Name="bankRoutingNumber" Type="string" Required="No" Default="">
	<cfargument Name="bankAccountNumber" Type="string" Required="No" Default="">
	<cfargument Name="bankAccountName" Type="string" Required="No" Default="">
	<cfargument Name="bankCheckingOrSavings" Type="string" Required="No" Default="">
	<cfargument Name="bankPersonalOrCorporate" Type="numeric" Required="No" Default="0">
	<cfargument Name="bankDescription" Type="string" Required="No" Default="">
	<cfargument Name="bankAccountType" Type="string" Required="No" Default="">
	<cfargument Name="bankStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="bankRetain" Type="numeric" Required="No" Default="1">
	<cfargument Name="addressID" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertBank = QueryNew("blank")>

	<cfif Arguments.bankRoutingNumber is not "">
		<cfset Arguments.bankRoutingNumber = Application.fn_EncryptString(Arguments.bankRoutingNumber)>	
	</cfif>
	<cfif Arguments.bankAccountNumber is not "">
		<cfset Arguments.bankAccountNumber = Application.fn_EncryptString(Arguments.bankAccountNumber)>	
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.Bank" method="maxlength_Bank" returnVariable="maxlength_Bank" />

	<cfquery Name="qry_insertBank" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avBank
		(
			companyID, userID, userID_author, bankName, bankBranch, bankBranchCity, bankBranchState,
			bankBranchCountry, bankBranchContactName, bankBranchPhone, bankBranchFax, bankRoutingNumber,
			bankAccountNumber, bankAccountName, bankCheckingOrSavings, bankPersonalOrCorporate,
			bankDescription, bankAccountType, bankStatus, bankRetain, addressID, bankDateCreated, bankDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.bankName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankName#">,
			<cfqueryparam Value="#Arguments.bankBranch#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankBranch#">,
			<cfqueryparam Value="#Arguments.bankBranchCity#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankBranchCity#">,
			<cfqueryparam Value="#Arguments.bankBranchState#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankBranchState#">,
			<cfqueryparam Value="#Arguments.bankBranchCountry#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankBranchCountry#">,
			<cfqueryparam Value="#Arguments.bankBranchContactName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankBranchContactName#">,
			<cfqueryparam Value="#Arguments.bankBranchPhone#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankBranchPhone#">,
			<cfqueryparam Value="#Arguments.bankBranchFax#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankBranchFax#">,
			<cfqueryparam Value="#Arguments.bankRoutingNumber#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankRoutingNumber#">,
			<cfqueryparam Value="#Arguments.bankAccountNumber#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankAccountNumber#">,
			<cfqueryparam Value="#Arguments.bankAccountName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankAccountName#">,
			<cfif Not ListFind("0,1", Arguments.bankCheckingOrSavings)>NULL<cfelse><cfqueryparam Value="#Arguments.bankCheckingOrSavings#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfqueryparam Value="#Arguments.bankPersonalOrCorporate#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.bankDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankDescription#">,
			<cfqueryparam Value="#Arguments.bankAccountType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Bank.bankAccountType#">,
			<cfqueryparam Value="#Arguments.bankStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.bankRetain#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "bankID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertBank.primaryKeyID>
</cffunction>

<cffunction Name="selectBank" Access="public" Output="No" ReturnType="query" Hint="Selects existing bank account for a given company or user">
	<cfargument Name="bankID" Type="numeric" Required="Yes">

	<cfset var qry_selectBank = QueryNew("blank")>
	<cfset var temp = "">

	<cfquery Name="qry_selectBank" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avBank.bankID, avBank.companyID, avBank.userID, avBank.userID_author, avBank.bankName,
			avBank.bankBranch, avBank.bankBranchCity, avBank.bankBranchState, avBank.bankBranchCountry,
			avBank.bankBranchContactName, avBank.bankBranchPhone, avBank.bankBranchFax,
			avBank.bankRoutingNumber, avBank.bankAccountNumber, avBank.bankAccountName,
			avBank.bankCheckingOrSavings, avBank.bankPersonalOrCorporate, avBank.bankDescription,
			avBank.bankAccountType, avBank.bankStatus, avBank.bankRetain, avBank.addressID,
			avBank.bankDateCreated, avBank.bankDateUpdated,
			avAddress.addressName, avAddress.addressDescription, avAddress.addressTypeShipping,
			avAddress.addressTypeBilling, avAddress.address, avAddress.address2, avAddress.address3,
			avAddress.city, avAddress.state, avAddress.zipCode, avAddress.zipCodePlus4, avAddress.county,
			avAddress.country, avAddress.addressStatus, avAddress.addressVersion, avAddress.regionID,
			avAddress.addressDateCreated, avAddress.addressDateUpdated
		FROM avBank LEFT OUTER JOIN avAddress ON avBank.addressID = avAddress.addressID
		WHERE avBank.bankID = <cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_selectBank.RecordCount is 1>
		<cfif qry_selectBank.bankRoutingNumber is not "">
			<cfset temp = QuerySetCell(qry_selectBank, "bankRoutingNumber", Application.fn_DecryptString(qry_selectBank.bankRoutingNumber), 1)>
		</cfif>
		<cfif qry_selectBank.bankAccountNumber is not "">
			<cfset temp = QuerySetCell(qry_selectBank, "bankAccountNumber", Application.fn_DecryptString(qry_selectBank.bankAccountNumber), 1)>
		</cfif>
	</cfif>

	<cfreturn qry_selectBank>
</cffunction>

<cffunction Name="selectBankList" Access="public" Output="No" ReturnType="query" Hint="Selects existing bank accounts for a given company or user">
	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyIDorUserID" Type="boolean" Required="No" Default="True">
	<cfargument Name="bankCheckingOrSavings" Type="string" Required="No">
	<cfargument Name="bankPersonalOrCorporate" Type="numeric" Required="No">
	<cfargument Name="bankAccountType" Type="string" Required="No">
	<cfargument Name="bankStatus" Type="numeric" Required="No">
	<cfargument Name="bankRetain" Type="numeric" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="companyID_author" Type="numeric" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">

	<cfargument Name="bankDescription" Type="string">

	<cfset var qry_selectBankList = QueryNew("blank")>
	<cfset var temp = "">
	<cfset var returnSubscriber = False>

	<cfif StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerList(Arguments.subscriberID)>
		<cfset returnSubscriber = True>
	</cfif>

	<cfquery Name="qry_selectBankList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avBank.bankID, avBank.companyID, avBank.userID, avBank.userID_author, avBank.bankName,
			avBank.bankBranch, avBank.bankBranchCity, avBank.bankBranchState, avBank.bankBranchCountry,
			avBank.bankBranchContactName, avBank.bankBranchPhone, avBank.bankBranchFax,
			avBank.bankRoutingNumber, avBank.bankAccountNumber, avBank.bankAccountName,
			avBank.bankCheckingOrSavings, avBank.bankPersonalOrCorporate, avBank.bankDescription,
			avBank.bankAccountType, avBank.bankStatus, avBank.bankRetain, avBank.addressID,
			avBank.bankDateCreated, avBank.bankDateUpdated, 
			avAddress.addressName, avAddress.addressDescription, avAddress.addressTypeShipping,
			avAddress.addressTypeBilling, avAddress.address, avAddress.address2, avAddress.address3,
			avAddress.city, avAddress.state, avAddress.zipCode, avAddress.zipCodePlus4, avAddress.county,
			avAddress.country, avAddress.addressStatus, avAddress.addressVersion, avAddress.regionID,
			avAddress.addressDateCreated, avAddress.addressDateUpdated,
			avUser.firstName, avUser.lastName, avUser.userID_custom
			<cfif Arguments.returnCompanyFields is True>, avCompany.companyName, avCompany.companyID_custom</cfif>
			<cfif returnSubscriber is True>, avSubscriberPayment.subscriberID</cfif>
		FROM avBank
			LEFT OUTER JOIN avAddress ON avBank.addressID = avAddress.addressID
			LEFT OUTER JOIN avUser ON avBank.userID = avUser.userID
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avBank.companyID = avCompany.companyID</cfif>
			<cfif returnSubscriber is True>LEFT OUTER JOIN avSubscriberPayment ON avCreditCard.creditCardID = avSubscriberPayment.creditCardID</cfif>
		WHERE avBank.bankID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "bankStatus") and ListFind("0,1", Arguments.bankStatus)>
				AND avBank.bankStatus = <cfqueryparam Value="#Arguments.bankStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "bankID") and Application.fn_IsIntegerList(Arguments.bankID)>
				AND avBank.bankID IN (<cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID) and StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND (
					avBank.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					<cfif Arguments.companyIDorUserID is True> OR <cfelse> AND </cfif>
					avBank.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					)
			<cfelseif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
				AND avBank.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfelseif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND avBank.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "bankAccountType")>
				AND avBank.bankAccountType = <cfqueryparam Value="#Arguments.bankAccountType#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif StructKeyExists(Arguments, "bankPersonalOrCorporate") and ListFind("0,1", Arguments.bankPersonalOrCorporate)>
				AND avBank.bankPersonalOrCorporate = <cfqueryparam Value="#Arguments.bankPersonalOrCorporate#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "bankCheckingOrSavings")>
				<cfif ListFind("0,1", Arguments.bankCheckingOrSavings) or Arguments.bankCheckingOrSavings is "0,1" or Arguments.bankCheckingOrSavings is "1,0">
					AND avBank.bankCheckingOrSavings IN (<cfqueryparam Value="#Arguments.bankCheckingOrSavings#" cfsqltype="#Application.billingSql.cfSqlType_bit#" List="Yes" Separator=",">)
				<cfelseif Arguments.bankCheckingOrSavings is "">
					AND avBank.bankCheckingOrSavings IS NULL
				</cfif>
			</cfif>
			<cfif StructKeyExists(Arguments, "bankDescription") and Trim(Arguments.bankDescription) is not "">
				AND avBank.bankDescription LIKE <cfqueryparam Value="%#Arguments.bankDescription#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif StructKeyExists(Arguments, "companyID_author") and Application.fn_IsIntegerPositive(Arguments.companyID_author) and Arguments.returnCompanyFields is True>
				AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif returnSubscriber is True>
				AND avSubscriberPayment.subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
		ORDER BY avBank.bankDateCreated DESC
	</cfquery>

	<cfloop Query="qry_selectBankList">
		<cfif qry_selectBankList.bankRoutingNumber is not "">
			<cfset temp = QuerySetCell(qry_selectBankList, "bankRoutingNumber", Application.fn_DecryptString(qry_selectBankList.bankRoutingNumber), 1)>
		</cfif>
		<cfif qry_selectBankList.bankAccountNumber is not "">
			<cfset temp = QuerySetCell(qry_selectBankList, "bankAccountNumber", Application.fn_DecryptString(qry_selectBankList.bankAccountNumber), 1)>
		</cfif>
	</cfloop>

	<cfreturn qry_selectBankList>
</cffunction>

<cffunction Name="updateBank" Access="public" Output="No" ReturnType="boolean" Hint="Updates status of existing bank account when replaced with new account info">
	<cfargument Name="bankID" Type="numeric" Required="Yes">
	<cfargument Name="bankStatus" Type="numeric" Required="No">
	<cfargument Name="bankRetain" Type="numeric" Required="No">
	<cfargument Name="bankPersonalOrCorporate" Type="numeric" Required="No">
	<cfargument Name="bankCheckingOrSavings" Type="numeric" Required="No">

	<cfquery Name="qry_updateBank" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avBank
		SET 
			<cfif StructKeyExists(Arguments, "bankStatus") and ListFind("0,1", Arguments.bankStatus)>bankStatus = <cfqueryparam Value="#Arguments.bankStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "bankRetain") and ListFind("0,1", Arguments.bankRetain)>bankRetain = <cfqueryparam Value="#Arguments.bankRetain#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "bankCheckingOrSavings") and ListFind("0,1", Arguments.bankCheckingOrSavings)>bankCheckingOrSavings = <cfqueryparam Value="#Arguments.bankCheckingOrSavings#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "bankPersonalOrCorporate") and ListFind("0,1", Arguments.bankPersonalOrCorporate)>bankPersonalOrCorporate = <cfqueryparam Value="#Arguments.bankPersonalOrCorporate#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			bankDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE bankID = <cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkBankPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that requested bank is for specified user or company">
	<cfargument Name="bankID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfset var qry_checkBankPermission = QueryNew("blank")>

	<cfquery Name="qry_checkBankPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT bankID
		FROM avBank
		WHERE bankID = <cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>
				AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkBankPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="deleteBank" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing bank account">
	<cfargument Name="bankID" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteBank" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avBank
		WHERE bankID = <cfqueryparam Value="#Arguments.bankID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
