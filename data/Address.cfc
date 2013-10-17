<cfcomponent DisplayName="Address" Hint="Manages creating and viewing user and company addresses">

<cffunction name="maxlength_Address" access="public" output="no" returnType="struct">
	<cfset var maxlength_Address = StructNew()>

	<cfset maxlength_Address.addressName = 100>
	<cfset maxlength_Address.addressDescription = 255>
	<cfset maxlength_Address.address = 100>
	<cfset maxlength_Address.address2 = 100>
	<cfset maxlength_Address.address3 = 100>
	<cfset maxlength_Address.city = 50>
	<cfset maxlength_Address.state = 50>
	<cfset maxlength_Address.zipCode = 15>
	<cfset maxlength_Address.zipCodePlus4 = 4>
	<cfset maxlength_Address.county = 100>
	<cfset maxlength_Address.country = 100>

	<cfreturn maxlength_Address>
</cffunction>

<cffunction Name="insertAddress" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new address into database and returns addressID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="addressID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressID_trend" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressName" Type="string" Required="No" Default="">
	<cfargument Name="addressDescription" Type="string" Required="No" Default="">
	<cfargument Name="addressTypeShipping" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressTypeBilling" Type="numeric" Required="No" Default="0">
	<cfargument Name="address" Type="string" Required="Yes">
	<cfargument Name="address2" Type="string" Required="No" Default="">
	<cfargument Name="address3" Type="string" Required="No" Default="">
	<cfargument Name="city" Type="string" Required="Yes">
	<cfargument Name="state" Type="string" Required="Yes">
	<cfargument Name="zipCode" Type="string" Required="Yes">
	<cfargument Name="zipCodePlus4" Type="string" Required="No" Default="">
	<cfargument Name="county" Type="string" Required="No" Default="">
	<cfargument Name="country" Type="string" Required="No" Default="United States">
	<cfargument Name="addressStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="regionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressVersion" Type="numeric" Required="No" Default="1">

	<cfset var qry_insertAddress = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Address" method="maxlength_Address" returnVariable="maxlength_Address" />

	<cfquery Name="qry_insertAddress" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avAddress
		(
			companyID, userID, userID_author, addressID_parent, addressID_trend,
			addressName, addressDescription, addressTypeShipping, addressTypeBilling,
			address, address2, address3, city, state, zipCode, zipCodePlus4, county,
			country, addressStatus, addressVersion, regionID, addressDateCreated, addressDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.addressID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.addressID_trend#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.addressName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.addressName#">,
			<cfqueryparam Value="#Arguments.addressDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.addressName#">,
			<cfqueryparam Value="#Arguments.addressTypeShipping#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.addressTypeBilling#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.address#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.address#">,
			<cfqueryparam Value="#Arguments.address2#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.address2#">,
			<cfqueryparam Value="#Arguments.address3#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.address3#">,
			<cfqueryparam Value="#Arguments.city#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.city#">,
			<cfqueryparam Value="#Arguments.state#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.state#">,
			<cfqueryparam Value="#Arguments.zipCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.zipCode#">,
			<cfqueryparam Value="#Arguments.zipCodePlus4#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.zipCodePlus4#">,
			<cfqueryparam Value="#Arguments.county#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.county#">,
			<cfqueryparam Value="#Arguments.country#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Address.country#">,
			<cfqueryparam Value="#Arguments.addressStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.addressVersion#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.regionID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "addressID", "ALL")#;
	</cfquery>

	<cfif Arguments.addressID_trend is 0>
		<cfquery Name="qry_insertAddress_trend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avAddress
			SET addressID_trend = addressID
			WHERE addressID = <cfqueryparam Value="#qry_insertAddress.primaryKeyID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>

	<cfif Arguments.addressID_parent is not 0>
		<cfinvoke component="#Application.billingMapping#data.Address" Method="updateAddressID" ReturnVariable="isAddressIDUpdated">
			<cfinvokeargument Name="addressID_new" Value="#qry_insertAddress.primaryKeyID#">
			<cfinvokeargument Name="addressID_old" Value="#Arguments.addressID_parent#">
		</cfinvoke>
	</cfif>

	<cfreturn qry_insertAddress.primaryKeyID>
</cffunction>

<cffunction Name="selectAddress" Access="public" Output="No" ReturnType="query" Hint="Selects existing address for a given company or user">
	<cfargument Name="addressID" Type="string" Required="Yes">

	<cfset var qry_selectAddress = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.addressID)>
		<cfset Arguments.addressID = 0>
	</cfif>

	<cfquery Name="qry_selectAddress" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT addressID, companyID, userID, userID_author, addressID_parent, addressID_trend,
			addressName, addressDescription, addressTypeShipping, addressTypeBilling, address,
			address2, address3, city, state, zipCode, zipCodePlus4, county, country, addressStatus,
			addressVersion, regionID, addressDateCreated, addressDateUpdated
		FROM avAddress
		WHERE addressID IN (<cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectAddress>
</cffunction>

<cffunction Name="selectAddressList" Access="public" Output="No" ReturnType="query" Hint="Selects existing addresses for a given company or user">
	<cfargument Name="addressID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="addressTypeShipping" Type="numeric" Required="No">
	<cfargument Name="addressTypeBilling" Type="numeric" Required="No">
	<cfargument Name="addressName" Type="string" Required="No">
	<cfargument Name="addressStatus" Type="numeric" Required="No">
	<cfargument Name="addressDescription" Type="string" Required="No">
	<cfargument Name="addressID_trend" Type="string" Required="No">
	<cfargument Name="addressID_parent" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="companyIDorUserID" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectAddressList = QueryNew("blank")>

	<cfquery Name="qry_selectAddressList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avAddress.addressID, avAddress.companyID, avAddress.userID, avAddress.userID_author,
			avAddress.addressID_parent, avAddress.addressID_trend, avAddress.addressName, avAddress.addressDescription,
			avAddress.addressTypeShipping, avAddress.addressTypeBilling, avAddress.address,
			avAddress.address2, avAddress.address3, avAddress.city, avAddress.state, avAddress.zipCode,
			avAddress.zipCodePlus4, avAddress.county, avAddress.country, avAddress.addressStatus,
			avAddress.addressVersion, avAddress.regionID, avAddress.addressDateCreated, avAddress.addressDateUpdated,
			avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avAddress LEFT OUTER JOIN avUser ON avAddress.userID = avUser.userID
		WHERE avAddress.addressID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="addressID,addressID_trend,addressID_parent,regionID">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND avAddress.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfloop Index="field" List="addressStatus,addressTypeShipping,addressTypeBilling">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND avAddress.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID) and StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND (
					avAddress.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					<cfif Arguments.companyIDorUserID is True> OR <cfelse> AND </cfif>
					avAddress.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					)
			<cfelseif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
				AND avAddress.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfelseif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND avAddress.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "addressName")>
				AND avAddress.addressName = <cfqueryparam Value="#Arguments.addressName#" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif StructKeyExists(Arguments, "addressDescription") and Trim(Arguments.addressDescription) is not "">
				AND avAddress.addressDescription LIKE <cfqueryparam Value="%#Arguments.addressDescription#%" cfsqltype="cf_sql_varchar">
			</cfif>
		ORDER BY avAddress.addressID_trend, avAddress.addressStatus DESC, avAddress.addressVersion DESC, avAddress.addressDateCreated DESC
	</cfquery>

	<cfreturn qry_selectAddressList>
</cffunction>

<cffunction Name="updateAddress" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing address">
	<cfargument Name="addressID" Type="numeric" Required="Yes">
	<cfargument Name="addressStatus" Type="numeric" Required="No">
	<cfargument Name="addressVersion" Type="numeric" Required="No">
	<cfargument Name="addressTypeBilling" Type="numeric" Required="No">
	<cfargument Name="addressTypeShipping" Type="numeric" Required="No">
	<cfargument Name="regionID" Type="numeric" Required="No">

	<cfquery Name="qry_updateAddress" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avAddress
		SET 
			<cfif StructKeyExists(Arguments, "addressStatus") and ListFind("0,1", Arguments.addressStatus)>addressStatus = <cfqueryparam Value="#Arguments.addressStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "addressVersion") and Application.fn_IsIntegerNonNegative(Arguments.addressVersion)>addressVersion = <cfqueryparam Value="#Arguments.addressVersion#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerNonNegative(Arguments.regionID)>regionID = <cfqueryparam Value="#Arguments.regionID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "addressTypeBilling") and ListFind("0,1", Arguments.addressTypeBilling)>addressTypeBilling = <cfqueryparam Value="#Arguments.addressTypeBilling#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "addressTypeShipping") and ListFind("0,1", Arguments.addressTypeShipping)>addressTypeShipping = <cfqueryparam Value="#Arguments.addressTypeShipping#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			addressDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE addressID = <cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkAddressNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check that requested address name is not already being used">
	<cfargument Name="addressID" Type="numeric" Required="No">
	<cfargument Name="addressName" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkAddressNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkAddressNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT addressID
		FROM avAddress
		WHERE addressStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			<cfif StructKeyExists(Arguments, "addressID") and Application.fn_IsIntegerNonNegative(Arguments.addressID)>
				AND addressID <> <cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer">
			</cfif>
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			AND addressName = <cfqueryparam Value="#Arguments.addressName#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif qry_checkAddressNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkAddressPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that requested address is for specified user or company">
	<cfargument Name="addressID" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="No">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfset var qry_checkAddressPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.addressID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkAddressPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT avAddress.addressID
			FROM avAddress
			<cfif StructKeyExists(Arguments, "companyID_author") and Application.fn_IsIntegerPositive(Arguments.companyID_author)>
				INNER JOIN avCompany ON avAddress.companyID = avCompany.companyID
			</cfif>
			WHERE avAddress.addressID IN (<cfqueryparam Value="#Arguments.addressID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "companyID_author") and Application.fn_IsIntegerPositive(Arguments.companyID_author)>AND avCompany.companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer"></cfif>
				<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerPositive(Arguments.companyID)>AND avAddress.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"></cfif>
				<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>AND avAddress.userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"></cfif>
		</cfquery>

		<cfif qry_checkAddressPermission.RecordCount is 0 or qry_checkAddressPermission.RecordCount is not ListLen(Arguments.addressID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="updateAddressID" Access="public" Output="No" ReturnType="boolean" Hint="Updates addressID for affiliate, cobrand, vendor and other moving-forward areas when address is updated">
	<cfargument Name="addressID_old" Type="numeric" Required="Yes">
	<cfargument Name="addressID_new" Type="numeric" Required="Yes">

	<cfquery Name="qry_updateAddressID_subscriber_shipping" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscriber
		SET addressID_shipping = <cfqueryparam Value="#Arguments.addressID_new#" cfsqltype="cf_sql_integer">
		WHERE addressID_shipping = <cfqueryparam Value="#Arguments.addressID_old#" cfsqltype="cf_sql_integer">;

		UPDATE avSubscriber
		SET addressID_billing = <cfqueryparam Value="#Arguments.addressID_new#" cfsqltype="cf_sql_integer">
		WHERE addressID_billing = <cfqueryparam Value="#Arguments.addressID_old#" cfsqltype="cf_sql_integer">;

		UPDATE avCreditCard
		SET addressID = <cfqueryparam Value="#Arguments.addressID_new#" cfsqltype="cf_sql_integer">
		WHERE addressID = <cfqueryparam Value="#Arguments.addressID_old#" cfsqltype="cf_sql_integer">;

		UPDATE avBank
		SET addressID = <cfqueryparam Value="#Arguments.addressID_new#" cfsqltype="cf_sql_integer">
		WHERE addressID = <cfqueryparam Value="#Arguments.addressID_old#" cfsqltype="cf_sql_integer">;

		UPDATE avSubscriberNotify
		SET addressID = <cfqueryparam Value="#Arguments.addressID_new#" cfsqltype="cf_sql_integer">
		WHERE addressID = <cfqueryparam Value="#Arguments.addressID_old#" cfsqltype="cf_sql_integer">;
	</cfquery>

	<cfreturn True>
</cffunction>
</cfcomponent>

