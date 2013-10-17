<cfcomponent DisplayName="PaymentCategory" Hint="Manages creating, viewing and updating payment categories">

<cffunction name="maxlength_PaymentCategory" access="public" output="no" returnType="struct">
	<cfset var maxlength_PaymentCategory = StructNew()>

	<cfset maxlength_PaymentCategory.paymentCategoryName = 100>
	<cfset maxlength_PaymentCategory.paymentCategoryTitle = 255>
	<cfset maxlength_PaymentCategory.paymentCategoryID_custom = 50>
	<cfset maxlength_PaymentCategory.paymentCategoryType = 10>
	<cfset maxlength_PaymentCategory.paymentCategoryAutoMethod = 255>

	<cfreturn maxlength_PaymentCategory>
</cffunction>

<cffunction Name="insertPaymentCategory" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new payment category and returns paymentCategoryID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="paymentCategoryName" Type="string" Required="Yes">
	<cfargument Name="paymentCategoryType" Type="string" Required="Yes">
	<cfargument Name="paymentCategoryTitle" Type="string" Required="No" Default="">
	<cfargument Name="paymentCategoryID_custom" Type="string" Required="No" Default="">
	<cfargument Name="paymentCategoryOrder" Type="numeric" Required="Yes">
	<cfargument Name="paymentCategoryStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="paymentCategoryAutoMethod" Type="string" Required="No" Default="">
	<cfargument Name="paymentCategoryCreatedViaSetup" Type="numeric" Required="No" Default="0">
	<cfargument Name="incrementPaymentCategoryOrder" Type="boolean" Required="No" Default="True">

	<cfset var qry_insertPaymentCategory = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.PaymentCategory" method="maxlength_PaymentCategory" returnVariable="maxlength_PaymentCategory" />

	<cfquery Name="qry_insertPaymentCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.incrementPaymentCategoryOrder is True>
			UPDATE avPaymentCategory
			SET paymentCategoryOrder = paymentCategoryOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE paymentCategoryType = <cfqueryparam Value="#Arguments.paymentCategoryType#" cfsqltype="cf_sql_varchar">
				AND paymentCategoryOrder >= <cfqueryparam Value="#Arguments.paymentCategoryOrder#" cfsqltype="cf_sql_tinyint">;
		</cfif>

		INSERT INTO avPaymentCategory
		(
			companyID, userID, paymentCategoryName, paymentCategoryTitle, paymentCategoryID_custom, paymentCategoryOrder,
			paymentCategoryType, paymentCategoryStatus, paymentCategoryAutoMethod, paymentCategoryCreatedViaSetup,
			paymentCategoryDateCreated, paymentCategoryDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.paymentCategoryName#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryName#">,
			<cfqueryparam Value="#Arguments.paymentCategoryTitle#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryTitle#">,
			<cfqueryparam Value="#Arguments.paymentCategoryID_custom#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryID_custom#">,
			<cfqueryparam Value="#Arguments.paymentCategoryOrder#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.paymentCategoryType#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryType#">,
			<cfqueryparam Value="#Arguments.paymentCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.paymentCategoryAutoMethod#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryAutoMethod#">,
			<cfqueryparam Value="#Arguments.paymentCategoryCreatedViaSetup#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "paymentCategoryID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertPaymentCategory.primaryKeyID>
</cffunction>

<cffunction Name="updatePaymentCategory" Access="public" Output="No" ReturnType="boolean" Hint="Update existing payment category and returns True">
	<cfargument Name="paymentCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="paymentCategoryName" Type="string" Required="No">
	<cfargument Name="paymentCategoryTitle" Type="string" Required="No">
	<cfargument Name="paymentCategoryID_custom" Type="string" Required="No">
	<cfargument Name="paymentCategoryType" Type="string" Required="No">
	<cfargument Name="paymentCategoryStatus" Type="numeric" Required="No">
	<cfargument Name="paymentCategoryAutoMethod" Type="string" Required="No">
	<cfargument Name="paymentCategoryCreatedViaSetup" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.PaymentCategory" method="maxlength_PaymentCategory" returnVariable="maxlength_PaymentCategory" />

	<cfquery Name="qry_updatePaymentCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPaymentCategory
		SET 
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryName")>paymentCategoryName = <cfqueryparam Value="#Arguments.paymentCategoryName#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryName#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryTitle")>paymentCategoryTitle = <cfqueryparam Value="#Arguments.paymentCategoryTitle#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryID_custom")>paymentCategoryID_custom = <cfqueryparam Value="#Arguments.paymentCategoryID_custom#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryType")>paymentCategoryType = <cfqueryparam Value="#Arguments.paymentCategoryType#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryType#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryStatus") and ListFind("0,1", Arguments.paymentCategoryStatus)>paymentCategoryStatus = <cfqueryparam Value="#Arguments.paymentCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryAutoMethod")>paymentCategoryAutoMethod = <cfqueryparam Value="#Arguments.paymentCategoryAutoMethod#" cfsqltype="cf_sql_varchar" Maxlength="#maxlength_PaymentCategory.paymentCategoryAutoMethod#">,</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryCreatedViaSetup") and ListFind("0,1", Arguments.paymentCategoryCreatedViaSetup)>paymentCategoryCreatedViaSetup = <cfqueryparam Value="#Arguments.paymentCategoryCreatedViaSetup#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			paymentCategoryDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE paymentCategoryID = <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkPaymentCategoryPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate company has permission for payment category(s)">
	<cfargument Name="paymentCategoryID" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkPaymentCategoryPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.paymentCategoryID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkPaymentCategoryPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT paymentCategoryID
			FROM avPaymentCategory
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND paymentCategoryID IN (<cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfif qry_checkPaymentCategoryPermission.RecordCount is 0 or qry_checkPaymentCategoryPermission.RecordCount is not ListLen(Arguments.paymentCategoryID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectPaymentCategory" Access="public" Output="No" ReturnType="query" Hint="Selects existing payment category">
	<cfargument Name="paymentCategoryID" Type="numeric" Required="Yes">

	<cfset var qry_selectPaymentCategory = QueryNew("blank")>

	<cfquery Name="qry_selectPaymentCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID, userID, paymentCategoryName, paymentCategoryTitle, paymentCategoryID_custom,
			paymentCategoryOrder, paymentCategoryType, paymentCategoryStatus, paymentCategoryAutoMethod,
			paymentCategoryCreatedViaSetup, paymentCategoryDateCreated, paymentCategoryDateUpdated
		FROM avPaymentCategory
		WHERE paymentCategoryID = <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectPaymentCategory>
</cffunction>

<cffunction Name="selectPaymentCategoryIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects paymentCategoryID of existing payment category via custom ID and returns paymentCategoryID(s) if exists, 0 if not exists, and -1 if multiple payment category(s) have the same paymentCategoryID_custom.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="paymentCategoryID_custom" Type="string" Required="Yes">

	<cfset var qry_selectPaymentCategoryIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectPaymentCategoryIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT paymentCategoryID
		FROM avPaymentCategory
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND paymentCategoryID_custom IN (<cfqueryparam Value="#Arguments.paymentCategoryID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectPaymentCategoryIDViaCustomID.RecordCount is 0 or qry_selectPaymentCategoryIDViaCustomID.RecordCount lt ListLen(Arguments.paymentCategoryID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectPaymentCategoryIDViaCustomID.RecordCount gt ListLen(Arguments.paymentCategoryID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectPaymentCategoryIDViaCustomID.paymentCategoryID)>
	</cfif>
</cffunction>

<cffunction Name="selectPaymentCategoryList" Access="public" Output="No" ReturnType="query" Hint="Selects existing payment category(s)">
	<cfargument Name="companyID" Type="string" Required="Yes">
	<cfargument Name="paymentCategoryID" Type="string" Required="No">
	<cfargument Name="paymentCategoryID_custom" Type="string" Required="No">
	<cfargument Name="paymentCategoryType" Type="string" Required="No">
	<cfargument Name="paymentCategoryAutoMethod" Type="string" Required="No">
	<cfargument Name="paymentCategoryStatus" Type="numeric" Required="No">

	<cfset var qry_selectPaymentCategoryList = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.companyID)>
		<cfset Arguments.companyID = 0>
	</cfif>

	<cfquery Name="qry_selectPaymentCategoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT paymentCategoryID, companyID, userID, paymentCategoryName, paymentCategoryTitle,
			paymentCategoryID_custom, paymentCategoryOrder, paymentCategoryType, paymentCategoryStatus,
			paymentCategoryAutoMethod, paymentCategoryCreatedViaSetup,
			paymentCategoryDateCreated, paymentCategoryDateUpdated
		FROM avPaymentCategory
		WHERE companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "paymentCategoryID") and Application.fn_IsIntegerList(Arguments.paymentCategoryID)>AND paymentCategoryID IN (<cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryID_custom") and Application.fn_IsIntegerList(Arguments.paymentCategoryID_custom)>AND paymentCategoryID_custom IN (<cfqueryparam Value="#Arguments.paymentCategoryID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryType")>AND paymentCategoryType IN (<cfqueryparam Value="#Arguments.paymentCategoryType#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryAutoMethod")>AND paymentCategoryAutoMethod <cfif Arguments.paymentCategoryAutoMethod is ""> = '' <cfelse> LIKE <cfqueryparam Value="%#Arguments.paymentCategoryAutoMethod#%" cfsqltype="cf_sql_varchar"></cfif></cfif>
			<cfif StructKeyExists(Arguments, "paymentCategoryStatus") and ListFind("0,1", Arguments.paymentCategoryStatus)>AND paymentCategoryStatus = <cfqueryparam Value="%#Arguments.paymentCategoryStatus#%" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
		ORDER BY companyID, paymentCategoryType DESC, paymentCategoryOrder
	</cfquery>

	<cfreturn qry_selectPaymentCategoryList>
</cffunction>

<cffunction Name="switchPaymentCategoryOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing payment categories for a particular type">
	<cfargument Name="paymentCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="paymentCategoryType" Type="string" Required="Yes">
	<cfargument Name="paymentCategoryOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectPaymentCategoryOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchPaymentCategoryOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPaymentCategory
		SET paymentCategoryOrder = paymentCategoryOrder 
			<cfif Arguments.paymentCategoryOrder_direction is "movePaymentCategoryDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE paymentCategoryID = <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avPaymentCategory INNER JOIN avPaymentCategory AS avPaymentCategory2
			SET avPaymentCategory.paymentCategoryOrder = avPaymentCategory.paymentCategoryOrder 
				<cfif Arguments.paymentCategoryOrder_direction is "movePaymentCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE avPaymentCategory.paymentCategoryOrder = avPaymentCategory2.paymentCategoryOrder 
				AND avPaymentCategory.companyID = avPaymentCategory2.companyID
				AND avPaymentCategory.paymentCategoryType = <cfqueryparam Value="#Arguments.paymentCategoryType#" cfsqltype="cf_sql_varchar">
				AND avPaymentCategory.paymentCategoryID <> <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">
				AND avPaymentCategory2.paymentCategoryID = <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avPaymentCategory
			SET paymentCategoryOrder = paymentCategoryOrder 
				<cfif Arguments.paymentCategoryOrder_direction is "movePaymentCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE paymentCategoryType = <cfqueryparam Value="#Arguments.paymentCategoryType#" cfsqltype="cf_sql_varchar">
				AND paymentCategoryID <> <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">
				AND companyID = 
					(
					SELECT companyID
					FROM avPaymentCategory2
					WHERE paymentCategoryID = <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">
					)
				AND paymentCategoryOrder = 
					(
					SELECT paymentCategoryOrder
					FROM avPaymentCategory
					WHERE paymentCategoryID = <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">
					);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkPaymentCategoryNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check that payment category name is unique for designated type">
	<cfargument Name="paymentCategoryName" Type="string" Required="Yes">
	<cfargument Name="paymentCategoryType" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="paymentCategoryID" Type="numeric" Required="No">

	<cfset var qry_checkPaymentCategoryNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkPaymentCategoryNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT paymentCategoryID
		FROM avPaymentCategory
		WHERE paymentCategoryName = <cfqueryparam Value="#Arguments.paymentCategoryName#" CFSQLType="cf_sql_varchar">
			AND paymentCategoryType = <cfqueryparam Value="#Arguments.paymentCategoryType#" CFSQLType="cf_sql_varchar">
			AND companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "paymentCategoryID") and Application.fn_IsIntegerNonNegative(Arguments.paymentCategoryID)>
				AND paymentCategoryID <> <cfqueryparam Value="#Arguments.paymentCategoryID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkPaymentCategoryNameIsUnique.RecordCount is not 0>
		<cfreturn False>
	<cfelse>
		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>

