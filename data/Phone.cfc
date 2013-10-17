<cfcomponent DisplayName="Phone" Hint="Manages creating and viewing user and company phone numbers">

<cffunction name="maxlength_Phone" access="public" output="no" returnType="struct">
	<cfset var maxlength_Phone = StructNew()>

	<cfset maxlength_Phone.phoneAreaCode = 5>
	<cfset maxlength_Phone.phoneNumber = 10>
	<cfset maxlength_Phone.phoneExtension = 5>
	<cfset maxlength_Phone.phoneType = 25>
	<cfset maxlength_Phone.phoneDescription = 255>

	<cfreturn maxlength_Phone>
</cffunction>

<cffunction Name="insertPhone" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new phone number into database and return phoneID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="phoneID_trend" Type="numeric" Required="No" Default="0">
	<cfargument Name="phoneID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="phoneVersion" Type="numeric" Required="No" Default="1">
	<cfargument Name="phoneAreaCode" Type="string" Required="No" Default="">
	<cfargument Name="phoneNumber" Type="string" Required="No" Default="">
	<cfargument Name="phoneExtension" Type="string" Required="No" Default="">
	<cfargument Name="phoneStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="phoneType" Type="string" Required="No" Default="">
	<cfargument Name="phoneDescription" Type="string" Required="No" Default="">

	<cfset var qry_insertPhone = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Phone" method="maxlength_Phone" returnVariable="maxlength_Phone" />

	<cftransaction>
	<cfquery Name="qry_insertPhone" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avPhone
		(
			userID, companyID, userID_author, phoneID_trend, phoneID_parent, phoneVersion, phoneAreaCode,
			phoneNumber, phoneExtension, phoneStatus, phoneType, phoneDescription, phoneDateCreated, phoneDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.phoneID_trend#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.phoneID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.phoneVersion#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.phoneAreaCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Phone.phoneAreaCode#">,
			<cfqueryparam Value="#Arguments.phoneNumber#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Phone.phoneNumber#">,
			<cfqueryparam Value="#Arguments.phoneExtension#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Phone.phoneExtension#">,
			<cfqueryparam Value="#Arguments.phoneStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.phoneType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Phone.phoneType#">,
			<cfqueryparam Value="#Arguments.phoneDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Phone.phoneDescription#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "phoneID", "ALL")#;
	</cfquery>

	<cfif Arguments.phoneID_trend is 0>
		<cfquery Name="qry_insertPhone_trend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avPhone
			SET phoneID_trend = phoneID
			WHERE phoneID = <cfqueryparam Value="#qry_insertPhone.primaryKeyID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	</cftransaction>

	<cfif Arguments.phoneID_parent is not 0>
		<cfinvoke component="#Application.billingMapping#data.Phone" Method="updatePhoneID" ReturnVariable="isPhoneIDUpdated">
			<cfinvokeargument Name="phoneID_new" Value="#qry_insertPhone.primaryKeyID#">
			<cfinvokeargument Name="phoneID_old" Value="#Arguments.phoneID_parent#">
		</cfinvoke>
	</cfif>

	<cfreturn qry_insertPhone.primaryKeyID>
</cffunction>

<cffunction Name="selectPhone" Access="public" Output="No" ReturnType="query" Hint="Selects existing phone number for a given company or user">
	<cfargument Name="phoneID" Type="numeric" Required="Yes">

	<cfset var qry_selectPhone = QueryNew("blank")>

	<cfquery Name="qry_selectPhone" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID, companyID, userID_author, phoneID_parent, phoneID_trend,
			phoneVersion, phoneAreaCode, phoneNumber, phoneExtension, phoneStatus,
			phoneType, phoneDescription, phoneDateCreated, phoneDateUpdated
		FROM avPhone
		WHERE phoneID = <cfqueryparam Value="#Arguments.phoneID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPhone>
</cffunction>

<cffunction Name="selectPhoneList" Access="public" Output="No" ReturnType="query" Hint="Selects existing phone numbers for a given company or user">
	<cfargument Name="phoneID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="phoneID_trend" Type="string" Required="No">
	<cfargument Name="phoneID_parent" Type="string" Required="No">
	<cfargument Name="phoneAreaCode" Type="string" Required="No">
	<cfargument Name="phoneType" Type="string" Required="No">
	<cfargument Name="phoneStatus" Type="numeric" Required="No">
	<cfargument Name="companyIDorUserID" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectPhoneList = QueryNew("blank")>

	<cfquery Name="qry_selectPhoneList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPhone.phoneID, avPhone.userID, avPhone.companyID, avPhone.userID_author,
			avPhone.phoneID_parent, avPhone.phoneID_trend, avPhone.phoneVersion, avPhone.phoneAreaCode,
			avPhone.phoneNumber, avPhone.phoneExtension, avPhone.phoneStatus, avPhone.phoneType,
			avPhone.phoneDescription, avPhone.phoneDateCreated, avPhone.phoneDateUpdated,
			avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avPhone LEFT OUTER JOIN avUser ON avPhone.userID = avUser.userID
		WHERE avPhone.phoneID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			<cfloop Index="field" List="phoneID,phoneID_trend,phoneID_parent">
				<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
					AND avPhone.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "phoneStatus") and ListFind("0,1", Arguments.phoneStatus)>
				AND avPhone.phoneStatus = <cfqueryparam Value="#Arguments.phoneStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID) and StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND (
					avPhone.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					<cfif Arguments.companyIDorUserID is True> OR <cfelse> AND </cfif>
					avPhone.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					)
			<cfelseif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
				AND avPhone.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfelseif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				AND avPhone.userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "phoneAreaCode") and Application.fn_IsIntegerList(Arguments.phoneAreaCode)>
				AND avPhone.phoneAreaCode IN (<cfqueryparam Value="#Arguments.phoneAreaCode#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "phoneType")>
				AND avPhone.phoneType IN (<cfqueryparam Value="#Arguments.phoneType#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			</cfif>
		ORDER BY avPhone.phoneID_parent, avPhone.phoneStatus DESC, avPhone.phoneVersion DESC, avPhone.phoneDateCreated DESC
	</cfquery>

	<cfreturn qry_selectPhoneList>
</cffunction>

<cffunction Name="updatePhone" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing phone number">
	<cfargument Name="phoneID" Type="numeric" Required="Yes">
	<cfargument Name="phoneStatus" Type="numeric" Required="No">
	<cfargument Name="phoneVersion" Type="numeric" Required="No">

	<cfquery Name="qry_updatePhone" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPhone
		SET 
			<cfif StructKeyExists(Arguments, "phoneStatus") and ListFind("0,1", Arguments.phoneStatus)>
				phoneStatus = <cfqueryparam Value="#Arguments.phoneStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "phoneVersion") and Application.fn_IsIntegerNonNegative(Arguments.phoneVersion)>
				phoneVersion = <cfqueryparam Value="#Arguments.phoneVersion#" cfsqltype="cf_sql_smallint">,
			</cfif>
			phoneDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE phoneID = <cfqueryparam Value="#Arguments.phoneID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkPhonePermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that requested phone number is for specified user or company">
	<cfargument Name="phoneID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfset var qry_checkPhonePermission = QueryNew("blank")>

	<cfquery Name="qry_checkPhonePermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT phoneID
		FROM avPhone
		WHERE phoneID = <cfqueryparam Value="#Arguments.phoneID#" cfsqltype="cf_sql_integer">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>
				AND userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkPhonePermission.RecordCount is 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="updatePhoneID" Access="public" Output="No" ReturnType="boolean" Hint="Updates phoneID for subscriber fax notification when phone number is updated">
	<cfargument Name="phoneID_old" Type="numeric" Required="Yes">
	<cfargument Name="phoneID_new" Type="numeric" Required="Yes">

	<cfquery Name="qry_updatePhoneID_subscriberNotify" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscriberNotify
		SET phoneID = <cfqueryparam Value="#Arguments.phoneID_new#" cfsqltype="cf_sql_integer">
		WHERE phoneID = <cfqueryparam Value="#Arguments.phoneID_old#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>
</cfcomponent>

