<cfcomponent DisplayName="Merchant" Hint="Manages creating and viewing merchant accounts.">

<cffunction name="maxlength_Merchant" access="public" output="no" returnType="struct">
	<cfset var maxlength_Merchant = StructNew()>

	<cfset maxlength_Merchant.merchantName = 100>
	<cfset maxlength_Merchant.merchantTitle = 100>
	<cfset maxlength_Merchant.merchantURL = 100>
	<cfset maxlength_Merchant.merchantDescription = 255>
	<cfset maxlength_Merchant.merchantFilename = 100>
	<cfset maxlength_Merchant.merchantRequiredFields = 255>

	<cfreturn maxlength_Merchant>
</cffunction>

<cffunction Name="insertMerchant" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new merchant into database and returns merchantID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="merchantName" Type="string" Required="Yes">
	<cfargument Name="merchantTitle" Type="string" Required="No" Default="">
	<cfargument Name="merchantBank" Type="numeric" Required="No" Default="0">
	<cfargument Name="merchantCreditCard" Type="numeric" Required="No" Default="0">
	<cfargument Name="merchantURL" Type="string" Required="No" Default="">
	<cfargument Name="merchantDescription" Type="string" Required="No" Default="">
	<cfargument Name="merchantFilename" Type="string" Required="No" Default="">
	<cfargument Name="merchantStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="merchantRequiredFields" Type="string" Required="No" Default="">

	<cfset var qry_insertMerchant = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Merchant" method="maxlength_Merchant" returnVariable="maxlength_Merchant" />

	<cfquery Name="qry_insertMerchant" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avMerchant
		(
			companyID, userID, merchantName, merchantTitle, merchantURL, merchantDescription,
			merchantBank, merchantCreditCard, merchantFilename, merchantStatus, merchantRequiredFields,
			merchantDateCreated, merchantDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.merchantName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantName#">,
			<cfqueryparam Value="#Arguments.merchantTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantTitle#">,
			<cfqueryparam Value="#Arguments.merchantURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantURL#">,
			<cfqueryparam Value="#Arguments.merchantDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantDescription#">,
			<cfqueryparam Value="#Arguments.merchantBank#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.merchantCreditCard#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.merchantFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantFilename#">,
			<cfqueryparam Value="#Arguments.merchantStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.merchantRequiredFields#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantRequiredFields#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "merchantID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertMerchant.primaryKeyID>
</cffunction>

<cffunction Name="checkMerchantTitleIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that merchant title is unique">
	<cfargument Name="merchantTitle" Type="string" Required="Yes">
	<cfargument Name="merchantID" Type="numeric" Required="No">

	<cfset var qry_checkMerchantTitleIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkMerchantTitleIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT merchantID
		FROM avMerchant
		WHERE merchantTitle = <cfqueryparam Value="#Arguments.merchantTitle#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "merchantID") and Application.fn_IsIntegerNonNegative(Arguments.merchantID)>
				AND merchantID <> <cfqueryparam Value="#Arguments.merchantID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkMerchantTitleIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="updateMerchant" Access="public" Output="No" ReturnType="numeric" Hint="Updates existing merchant information">
	<cfargument Name="merchantID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="merchantName" Type="string" Required="No">
	<cfargument Name="merchantTitle" Type="string" Required="No">
	<cfargument Name="merchantBank" Type="numeric" Required="No">
	<cfargument Name="merchantCreditCard" Type="numeric" Required="No">
	<cfargument Name="merchantURL" Type="string" Required="No">
	<cfargument Name="merchantDescription" Type="string" Required="No">
	<cfargument Name="merchantFilename" Type="string" Required="No">
	<cfargument Name="merchantStatus" Type="numeric" Required="No">
	<cfargument Name="merchantRequiredFields" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Merchant" method="maxlength_Merchant" returnVariable="maxlength_Merchant" />

	<cfquery Name="qry_updateMerchant" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avMerchant
		SET 
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantName")>merchantName = <cfqueryparam Value="#Arguments.merchantName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantName#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantTitle")>merchantTitle = <cfqueryparam Value="#Arguments.merchantTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantURL")>merchantURL = <cfqueryparam Value="#Arguments.merchantURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantURL#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantDescription")>merchantDescription = <cfqueryparam Value="#Arguments.merchantDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantFilename")>merchantFilename = <cfqueryparam Value="#Arguments.merchantFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantFilename#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantBank") and ListFind("0,1", Arguments.merchantBank)>merchantBank = <cfqueryparam Value="#Arguments.merchantBank#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantCreditCard") and ListFind("0,1", Arguments.merchantCreditCard)>merchantCreditCard = <cfqueryparam Value="#Arguments.merchantCreditCard#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantStatus") and ListFind("0,1", Arguments.merchantStatus)>merchantStatus = <cfqueryparam Value="#Arguments.merchantStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "merchantRequiredFields")>merchantRequiredFields = <cfqueryparam Value="#Arguments.merchantRequiredFields#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Merchant.merchantRequiredFields#">,</cfif>
			merchantDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE merchantID = <cfqueryparam Value="#Arguments.merchantID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectMerchant" Access="public" Output="No" ReturnType="query" Hint="Select existing merchant information">
	<cfargument Name="merchantID" Type="numeric" Required="Yes">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectMerchant = QueryNew("blank")>

	<cfquery Name="qry_selectMerchant" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avMerchant.companyID, avMerchant.userID, avMerchant.merchantName, avMerchant.merchantTitle,
			avMerchant.merchantURL, avMerchant.merchantDescription, avMerchant.merchantBank,
			avMerchant.merchantCreditCard, avMerchant.merchantFilename, avMerchant.merchantStatus,
			avMerchant.merchantRequiredFields, avMerchant.merchantDateCreated, avMerchant.merchantDateUpdated
			<cfif Arguments.returnCompanyFields is True>
				, avCompany.companyName, avCompany.companyID_custom,
				avUser.firstName, avUser.lastName, avUser.userID_custom
			</cfif>
		FROM avMerchant
			<cfif Arguments.returnCompanyFields is True>
				LEFT OUTER JOIN avCompany ON avMerchant.companyID = avCompany.companyID
				LEFT OUTER JOIN avUser ON avMerchant.userID = avUser.userID
			</cfif>
		WHERE avMerchant.merchantID = <cfqueryparam Value="#Arguments.merchantID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectMerchant>
</cffunction>

<cffunction Name="selectMerchantList" Access="public" Output="No" ReturnType="query" Hint="Selects existing merchants">
	<cfargument Name="merchantID" Type="string" Required="No">
	<cfargument Name="merchantName" Type="string" Required="No">
	<cfargument Name="merchantTitle" Type="string" Required="No">
	<cfargument Name="merchantBank" Type="numeric" Required="No">
	<cfargument Name="merchantCreditCard" Type="numeric" Required="No">
	<cfargument Name="merchantFilename" Type="string" Required="No">
	<cfargument Name="merchantStatus" Type="numeric" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectMerchantList = QueryNew("blank")>

	<cfquery Name="qry_selectMerchantList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avMerchant.merchantID, avMerchant.companyID, avMerchant.userID, avMerchant.merchantName,
			avMerchant.merchantTitle, avMerchant.merchantURL, avMerchant.merchantDescription, avMerchant.merchantBank,
			avMerchant.merchantCreditCard, avMerchant.merchantFilename, avMerchant.merchantStatus,
			avMerchant.merchantRequiredFields, avMerchant.merchantDateCreated, avMerchant.merchantDateUpdated
			<cfif Arguments.returnCompanyFields is True>
				, avCompany.companyName, avCompany.companyID_custom,
				avUser.firstName, avUser.lastName, avUser.userID_custom
			</cfif>
		FROM avMerchant
			<cfif Arguments.returnCompanyFields is True>
				LEFT OUTER JOIN avCompany ON avMerchant.companyID = avCompany.companyID
				LEFT OUTER JOIN avUser ON avMerchant.userID = avUser.userID
			</cfif>
		WHERE avMerchant.merchantID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "merchantID") and Application.fn_IsIntegerList(Arguments.merchantID)>AND avMerchant.merchantID IN (<cfqueryparam Value="#Arguments.merchantID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "merchantFilename")>AND avMerchant.merchantFilename = <cfqueryparam Value="#Arguments.merchantFilename#" cfsqltype="cf_sql_varchar"></cfif>
			<cfif StructKeyExists(Arguments, "merchantBank") and ListFind("0,1", Arguments.merchantBank)>AND avMerchant.merchantBank = <cfqueryparam Value="#Arguments.merchantBank#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "merchantCreditCard") and ListFind("0,1", Arguments.merchantCreditCard)>AND avMerchant.merchantCreditCard = <cfqueryparam Value="#Arguments.merchantCreditCard#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "merchantStatus") and ListFind("0,1", Arguments.merchantStatus)>AND avMerchant.merchantStatus = <cfqueryparam Value="#Arguments.merchantStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "merchantName") and Trim(Arguments.merchantName) is not "">AND avMerchant.merchantName LIKE <cfqueryparam Value="%#Arguments.merchantName#%" cfsqltype="cf_sql_varchar"></cfif>
			<cfif StructKeyExists(Arguments, "merchantTitle") and Trim(Arguments.merchantTitle) is not "">AND avMerchant.merchantTitle LIKE <cfqueryparam Value="%#Arguments.merchantTitle#%" cfsqltype="cf_sql_varchar"></cfif>
		ORDER BY avMerchant.merchantTitle
	</cfquery>

	<cfreturn qry_selectMerchantList>
</cffunction>

</cfcomponent>
