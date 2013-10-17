<cfcomponent DisplayName="CreditCard" Hint="Manages creating and viewing user and company credit cards.">

<cffunction name="maxlength_CreditCard" access="public" output="no" returnType="struct">
	<cfset var maxlength_CreditCard = StructNew()>

	<cfset maxlength_CreditCard.creditCardName_decrypted = 50>
	<cfset maxlength_CreditCard.creditCardName = 100>
	<cfset maxlength_CreditCard.creditCardType = 50>
	<cfset maxlength_CreditCard.creditCardNumber_decrypted = 16>
	<cfset maxlength_CreditCard.creditCardNumber = 100>
	<cfset maxlength_CreditCard.creditCardExpirationMonth = 2>
	<cfset maxlength_CreditCard.creditCardExpirationYear = 4>
	<cfset maxlength_CreditCard.creditCardCVC_decrypted = 5>
	<cfset maxlength_CreditCard.creditCardCVC = 15>
	<cfset maxlength_CreditCard.creditCardDescription = 255>

	<cfreturn maxlength_CreditCard>
</cffunction>

<cffunction Name="insertCreditCard" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new credit card into database and returns creditCardID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="addressID" Type="numeric" Required="No" Default="0">
	<cfargument Name="creditCardName" Type="string" Required="No" Default="">
	<cfargument Name="creditCardNumber" Type="string" Required="Yes">
	<cfargument Name="creditCardExpirationMonth" Type="string" Required="Yes">
	<cfargument Name="creditCardExpirationYear" Type="string" Required="Yes">
	<cfargument Name="creditCardType" Type="string" Required="No" Default="">
	<cfargument Name="creditCardCVC" Type="string" Required="No" Default="">
	<cfargument Name="creditCardStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="creditCardRetain" Type="numeric" Required="No" Default="1">
	<cfargument Name="creditCardDescription" Type="string" Required="No" Default="">

	<cfset var qry_insertCreditCard = QueryNew("blank")>

	<cfset Arguments.creditCardName = Application.fn_EncryptString(Arguments.creditCardName)>
	<cfif Arguments.creditCardNumber is not "">
		<cfset Arguments.creditCardNumber = Application.fn_EncryptString(Arguments.creditCardNumber)>
	</cfif>
	<cfif Arguments.creditCardCVC is not "">
		<cfset Arguments.creditCardCVC = Application.fn_EncryptString(Arguments.creditCardCVC)>	
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.CreditCard" method="maxlength_CreditCard" returnVariable="maxlength_CreditCard" />

	<cfquery Name="qry_insertCreditCard" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCreditCard
		(
			companyID, userID, userID_author, addressID, creditCardName, creditCardNumber, creditCardExpirationMonth,
			creditCardExpirationYear, creditCardType, creditCardCVC, creditCardStatus, creditCardRetain,
			creditCardDescription, creditCardCVCstatus, creditCardDateCreated, creditCardDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.creditCardName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CreditCard.creditCardName#">,
			<cfqueryparam Value="#Arguments.creditCardNumber#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CreditCard.creditCardNumber#">,
			<cfqueryparam Value="#Arguments.creditCardExpirationMonth#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CreditCard.creditCardExpirationMonth#">,
			<cfqueryparam Value="#Arguments.creditCardExpirationYear#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CreditCard.creditCardExpirationYear#">,
			<cfqueryparam Value="#Arguments.creditCardType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CreditCard.creditCardType#">,
			<cfqueryparam Value="#Arguments.creditCardCVC#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CreditCard.creditCardCVC#">,
			<cfqueryparam Value="#Arguments.creditCardStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.creditCardRetain#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.creditCardDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CreditCard.creditCardDescription#">,
			NULL,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "creditCardID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertCreditCard.primaryKeyID>
</cffunction>

<cffunction Name="selectCreditCard" Access="public" Output="No" ReturnType="query" Hint="Selects existing credit card for a given company or user">
	<cfargument Name="creditCardID" Type="numeric" Required="Yes">

	<cfset var qry_selectCreditCard = QueryNew("blank")>
	<cfset var temp = "">

	<cfquery Name="qry_selectCreditCard" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCreditCard.companyID, avCreditCard.userID, avCreditCard.userID_author, avCreditCard.addressID,
			avCreditCard.creditCardName, avCreditCard.creditCardNumber, avCreditCard.creditCardType,
			avCreditCard.creditCardExpirationMonth, avCreditCard.creditCardExpirationYear, avCreditCard.creditCardCVC,
			avCreditCard.creditCardStatus, avCreditCard.creditCardDescription, avCreditCard.creditCardCVCstatus,
			avCreditCard.creditCardRetain, avCreditCard.creditCardDateCreated, avCreditCard.creditCardDateUpdated,
			avAddress.addressName, avAddress.addressDescription, avAddress.addressTypeShipping,
			avAddress.addressTypeBilling, avAddress.address, avAddress.address2, avAddress.address3,
			avAddress.city, avAddress.state, avAddress.zipCode, avAddress.zipCodePlus4, avAddress.county,
			avAddress.country, avAddress.addressStatus, avAddress.addressVersion, avAddress.regionID,
			avAddress.addressDateCreated, avAddress.addressDateUpdated
		FROM avCreditCard LEFT OUTER JOIN avAddress ON avCreditCard.addressID = avAddress.addressID
		WHERE avCreditCard.creditCardID = <cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif qry_selectCreditCard.RecordCount is 1>
		<cfif qry_selectCreditCard.creditCardName is not "">
			<cfset temp = QuerySetCell(qry_selectCreditCard, "creditCardName", Application.fn_DecryptString(qry_selectCreditCard.creditCardName), 1)>
		</cfif>
		<cfif qry_selectCreditCard.creditCardNumber is not "">
			<cfset temp = QuerySetCell(qry_selectCreditCard, "creditCardNumber", Application.fn_DecryptString(qry_selectCreditCard.creditCardNumber), 1)>
		</cfif>
		<cfif qry_selectCreditCard.creditCardCVC is not "">
			<cfset temp = QuerySetCell(qry_selectCreditCard, "creditCardCVC", Application.fn_DecryptString(qry_selectCreditCard.creditCardCVC), 1)>
		</cfif>
	</cfif>

	<cfreturn qry_selectCreditCard>
</cffunction>

<cffunction Name="selectCreditCardList" Access="public" Output="No" ReturnType="query" Hint="Selects existing credit cards for a given company or user">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="companyIDorUserID" Type="boolean" Required="No" Default="True">
	<cfargument Name="creditCardStatus" Type="numeric" Required="No">
	<cfargument Name="creditCardRetain" Type="numeric" Required="No">
	<cfargument Name="returnCompanyFields" Type="boolean" Required="No" Default="False">
	<cfargument Name="companyID_author" Type="numeric" Required="No">
	<cfargument Name="creditCardDescription" Type="string" Required="No">
	<cfargument Name="creditCardType" Type="string" Required="No">
	<cfargument Name="creditCardExpirationMonth" Type="string" Required="No">
	<cfargument Name="creditCardExpirationYear" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="creditCardCVCstatus" Type="string" Required="No">

	<cfset var qry_selectCreditCardList = QueryNew("blank")>
	<cfset var temp = "">
	<cfset var returnSubscriber = False>

	<cfif StructKeyExists(Arguments, "subscriberID") and Application.fn_IsIntegerList(Arguments.subscriberID)>
		<cfset returnSubscriber = True>
	</cfif>

	<cfquery Name="qry_selectCreditCardList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCreditCard.creditCardID, avCreditCard.companyID, avCreditCard.userID, avCreditCard.userID_author,
			avCreditCard.addressID, avCreditCard.creditCardName, avCreditCard.creditCardNumber, avCreditCard.creditCardType,
			avCreditCard.creditCardExpirationMonth, avCreditCard.creditCardExpirationYear, avCreditCard.creditCardCVC,
			avCreditCard.creditCardCVCstatus, avCreditCard.creditCardStatus, avCreditCard.creditCardDescription,
			avCreditCard.creditCardRetain, avCreditCard.creditCardDateCreated, avCreditCard.creditCardDateUpdated,
			avAddress.addressName, avAddress.addressDescription, avAddress.addressTypeShipping,
			avAddress.addressTypeBilling, avAddress.address, avAddress.address2, avAddress.address3,
			avAddress.city, avAddress.state, avAddress.zipCode, avAddress.zipCodePlus4, avAddress.county,
			avAddress.country, avAddress.addressStatus, avAddress.addressVersion, avAddress.regionID,
			avAddress.addressDateCreated, avAddress.addressDateUpdated,
			avUser.firstName, avUser.lastName, avUser.userID_custom
			<cfif Arguments.returnCompanyFields is True>, avCompany.companyName, avCompany.companyID_custom</cfif>
			<cfif returnSubscriber is True>, avSubscriberPayment.subscriberID</cfif>
		FROM avCreditCard
			LEFT OUTER JOIN avAddress ON avCreditCard.addressID = avAddress.addressID
			LEFT OUTER JOIN avUser ON avCreditCard.userID = avUser.userID
			<cfif Arguments.returnCompanyFields is True>LEFT OUTER JOIN avCompany ON avCreditCard.companyID = avCompany.companyID</cfif>
			<cfif returnSubscriber is True>LEFT OUTER JOIN avSubscriberPayment ON avCreditCard.creditCardID = avSubscriberPayment.creditCardID</cfif>
		WHERE avCreditCard.creditCardID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="creditCardStatus,creditCardRetain"><cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])> AND avCreditCard.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"> </cfif></cfloop>
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID) and StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND (avCreditCard.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					<cfif Arguments.companyIDorUserID is True> OR <cfelse> AND </cfif>
					avCreditCard.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					)
			<cfelseif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
				AND avCreditCard.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfelseif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND avCreditCard.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "creditCardID") and Application.fn_IsIntegerList(Arguments.creditCardID)>AND avCreditCard.creditCardID IN (<cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "companyID_author") and Application.fn_IsIntegerPositive(Arguments.companyID_author) and Arguments.returnCompanyFields is True>AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "creditCardDescription") and Trim(Arguments.creditCardDescription) is not "">AND avCreditCard.creditCardDescription LIKE <cfqueryparam Value="%#Arguments.creditCardDescription#%" cfsqltype="cf_sql_varchar"></cfif>
			<cfif StructKeyExists(Arguments, "creditCardType") and Trim(Arguments.creditCardType) is not "">AND avCreditCard.creditCardType IN (<cfqueryparam Value="%#Arguments.creditCardType#%" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "creditCardExpirationMonth") and Trim(Arguments.creditCardExpirationMonth) is not "">AND avCreditCard.creditCardExpirationMonth = <cfqueryparam Value="%#Arguments.creditCardExpirationMonth#%" cfsqltype="cf_sql_varchar"></cfif>
			<cfif StructKeyExists(Arguments, "creditCardExpirationYear") and IsNumeric(Arguments.creditCardExpirationYear)>AND avCreditCard.creditCardExpirationYear = <cfqueryparam Value="%#Arguments.creditCardExpirationYear#%" cfsqltype="cf_sql_varchar"></cfif>
			<cfif returnSubscriber is True>AND avSubscriberPayment.subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "creditCardCVCstatus")>AND avCreditCard.creditCardCVCstatus <cfif Not ListFind("0,1", Arguments.creditCardCVCstatus)>IS NULL<cfelse> = <cfqueryparam Value="#Arguments.creditCardCVCstatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
		ORDER BY avCreditCard.creditCardStatus DESC, avCreditCard.creditCardDateCreated DESC
	</cfquery>

	<cfloop Query="qry_selectCreditCardList">
		<cfif qry_selectCreditCardList.creditCardName is not "">
			<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardName", Application.fn_DecryptString(qry_selectCreditCardList.creditCardName), CurrentRow)>
		</cfif>
		<cfif qry_selectCreditCardList.creditCardNumber is not "">
			<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardNumber", Application.fn_DecryptString(qry_selectCreditCardList.creditCardNumber), CurrentRow)>
		</cfif>
		<cfif qry_selectCreditCardList.creditCardCVC is not "">
			<cfset temp = QuerySetCell(qry_selectCreditCardList, "creditCardCVC", Application.fn_DecryptString(qry_selectCreditCardList.creditCardCVC), CurrentRow)>
		</cfif>
	</cfloop>

	<cfreturn qry_selectCreditCardList>
</cffunction>

<cffunction Name="updateCreditCard" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing credit card">
	<cfargument Name="creditCardID" Type="numeric" Required="Yes">
	<cfargument Name="creditCardStatus" Type="numeric" Required="No">
	<cfargument Name="addressID" Type="numeric" Required="No">
	<cfargument Name="creditCardRetain" Type="numeric" Required="No">
	<cfargument Name="deleteCreditCardCVC" Type="boolean" Required="No">
	<cfargument Name="creditCardCVCstatus" Type="string" Required="No">

	<cfquery Name="qry_updateCreditCard" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCreditCard
		SET 
			<cfif StructKeyExists(Arguments, "addressID") and Application.fn_IsIntegerNonNegative(Arguments.addressID)>
				addressID = <cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "creditCardStatus") and ListFind("0,1", Arguments.creditCardStatus)>
				creditCardStatus = <cfqueryparam Value="#Arguments.creditCardStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "creditCardRetain") and ListFind("0,1", Arguments.creditCardRetain)>
				creditCardRetain = <cfqueryparam Value="#Arguments.creditCardRetain#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "deleteCreditCardCVC") and Arguments.deleteCreditCardCVC is True>
				creditCardCVC = <cfqueryparam Value="" cfsqltype="cf_sql_varchar">,
			</cfif>
			<cfif StructKeyExists(Arguments, "creditCardCVCstatus")>
				creditCardCVCstatus = <cfif Not ListFind("0,1", Arguments.creditCardCVCstatus)>NULL<cfelse><cfqueryparam Value="#Arguments.creditCardCVCstatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			</cfif>
			creditCardDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE creditCardID = <cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkCreditCardPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that requested credit card is for specified user or company">
	<cfargument Name="creditCardID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfset var qry_checkCreditCardPermission = QueryNew("blank")>

	<cfquery Name="qry_checkCreditCardPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT creditCardID
		FROM avCreditCard
		WHERE creditCardID = <cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>
				AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkCreditCardPermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="deleteCreditCard" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing credit card record(s)">
	<cfargument Name="creditCardID" Type="string" Required="Yes">

	<cfif Application.fn_IsIntegerList(Arguments.creditCardID)>
		<cfquery Name="qry_deleteCreditCard" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			DELETE FROM avCreditCard
			WHERE creditCardID IN (<cfqueryparam Value="#Arguments.creditCardID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>
</cfcomponent>

