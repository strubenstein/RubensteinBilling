<cfcomponent DisplayName="Subscriber" Hint="Manages inserting, updating, deleting and viewing subscriptions to products">

<cffunction name="maxlength_Subscriber" access="public" output="no" returnType="struct">
	<cfset var maxlength_Subscriber = StructNew()>

	<cfset maxlength_Subscriber.subscriberName = 100>
	<cfset maxlength_Subscriber.subscriberID_custom = 50>

	<cfreturn maxlength_Subscriber>
</cffunction>

<cffunction Name="insertSubscriber" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new subscriber. Returns subscriberID.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_cancel" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="subscriberName" Type="string" Required="No" Default="">
	<cfargument Name="subscriberID_custom" Type="string" Required="No" Default="">
	<cfargument Name="subscriberStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="subscriberCompleted" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberDateProcessNext" Type="string" Required="No" Default="">
	<cfargument Name="subscriberDateProcessLast" Type="string" Required="No" Default="">
	<cfargument Name="addressID_billing" Type="numeric" Required="No" Default="0">
	<cfargument Name="addressID_shipping" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriberIsExported" Type="string" Required="No" Default="">
	<cfargument Name="subscriberDateExported" Type="string" Required="No" Default="">

	<cfset var qry_insertSubscriber = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Subscriber" method="maxlength_Subscriber" returnVariable="maxlength_Subscriber" />

	<cfquery Name="qry_insertSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avSubscriber
		(
			companyID, userID, userID_author, userID_cancel, companyID_author, subscriberName,
			subscriberID_custom, subscriberStatus, subscriberCompleted, subscriberDateProcessNext,
			subscriberDateProcessLast, addressID_billing, addressID_shipping, subscriberIsExported,
			subscriberDateExported, subscriberDateCreated, subscriberDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriberName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscriber.subscriberName#">,
			<cfqueryparam Value="#Arguments.subscriberID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscriber.subscriberID_custom#">,
			<cfqueryparam Value="#Arguments.subscriberStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.subscriberCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "subscriberDateProcessNext") or Not IsDate(Arguments.subscriberDateProcessNext)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriberDateProcessNext#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not StructKeyExists(Arguments, "subscriberDateProcessLast") or Not IsDate(Arguments.subscriberDateProcessLast)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriberDateProcessLast#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.addressID_billing#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.addressID_shipping#" cfsqltype="cf_sql_integer">,
			<cfif Not ListFind("0,1", Arguments.subscriberIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriberIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.subscriberDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.subscriberDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "subscriberID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertSubscriber.primaryKeyID>
</cffunction>

<cffunction Name="updateSubscriber" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing subscriber. Returns True.">
	<cfargument Name="subscriberID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="userID_author" Type="numeric" Required="No">
	<cfargument Name="userID_cancel" Type="numeric" Required="No">
	<cfargument Name="companyID_author" Type="numeric" Required="No">
	<cfargument Name="subscriberName" Type="string" Required="No">
	<cfargument Name="subscriberID_custom" Type="string" Required="No">
	<cfargument Name="subscriberStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriberDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriberDateProcessLast" Type="string" Required="No">
	<cfargument Name="addressID_billing" Type="numeric" Required="No">
	<cfargument Name="addressID_shipping" Type="numeric" Required="No">
	<cfargument Name="doNotUpdateSubscriberDateUpdated" Type="boolean" Required="No" Default="False">
	<cfargument Name="subscriberIsExported" Type="string" Required="No">
	<cfargument Name="subscriberDateExported" Type="string" Required="No">

	<cfset var displayComma = False>

	<cfinvoke component="#Application.billingMapping#data.Subscriber" method="maxlength_Subscriber" returnVariable="maxlength_Subscriber" />

	<cfquery Name="qry_updateSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avSubscriber
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "userID_author") and Application.fn_IsIntegerNonNegative(Arguments.userID_author)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "userID_cancel") and Application.fn_IsIntegerNonNegative(Arguments.userID_cancel)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>userID_cancel = <cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "subscriberStatus") and ListFind("0,1", Arguments.subscriberStatus)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberStatus = <cfqueryparam Value="#Arguments.subscriberStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "subscriberCompleted") and ListFind("0,1", Arguments.subscriberCompleted)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberCompleted = <cfqueryparam Value="#Arguments.subscriberCompleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "subscriberDateProcessNext")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberDateProcessNext = <cfif Not IsDate(Arguments.subscriberDateProcessNext)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriberDateProcessNext#" cfsqltype="cf_sql_timestamp"></cfif></cfif>
			<cfif StructKeyExists(Arguments, "subscriberDateProcessLast")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberDateProcessLast = <cfif Not IsDate(Arguments.subscriberDateProcessLast)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriberDateProcessLast#" cfsqltype="cf_sql_timestamp"></cfif></cfif>
			<cfif StructKeyExists(Arguments, "subscriberName")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberName = <cfqueryparam Value="#Arguments.subscriberName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscriber.subscriberName#"></cfif>
			<cfif StructKeyExists(Arguments, "subscriberID_custom")><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberID_custom = <cfqueryparam Value="#Arguments.subscriberID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Subscriber.subscriberID_custom#"></cfif>
			<cfif Not StructKeyExists(Arguments, "doNotUpdateSubscriberDateUpdated") or Arguments.doNotUpdateSubscriberDateUpdated is False><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberDateUpdated = #Application.billingSql.sql_nowDateTime#</cfif>
			<cfif StructKeyExists(Arguments, "addressID_billing") and Application.fn_IsIntegerNonNegative(Arguments.addressID_billing)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>addressID_billing = <cfqueryparam Value="#Arguments.addressID_billing#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "addressID_shipping") and Application.fn_IsIntegerNonNegative(Arguments.addressID_shipping)><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>addressID_shipping = <cfqueryparam Value="#Arguments.addressID_shipping#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "subscriberIsExported") and (Arguments.subscriberIsExported is "" or ListFind("0,1", Arguments.subscriberIsExported))><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberIsExported = <cfif Not ListFind("0,1", Arguments.subscriberIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriberIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif></cfif>
			<cfif StructKeyExists(Arguments, "subscriberDateExported") and (Arguments.subscriberDateExported is "" or IsDate(Arguments.subscriberDateExported))><cfif displayComma is True>,<cfelse><cfset displayComma = True></cfif>subscriberDateExported = <cfif Not IsDate(Arguments.subscriberDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.subscriberDateExported)#" cfsqltype="cf_sql_timestamp"></cfif></cfif>
		WHERE subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkSubscriberPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check company permission for existing subscriber">
	<cfargument Name="subscriberID" Type="string" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="companyID" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">

	<cfset var qry_checkSubscriberPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.subscriberID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkSubscriberPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT avSubscriber.userID, avSubscriber.companyID, avSubscriber.companyID_author,
				avCompany.affiliateID, avCompany.cobrandID
			FROM avSubscriber, avCompany
			WHERE avSubscriber.companyID = avCompany.companyID
				AND avSubscriber.subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfloop Index="field" List="companyID_author,userID,companyID">
					<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerNonNegative(Arguments[field])>
						AND avSubscriber.#field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer">
					</cfif>
				</cfloop>
				<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID) and StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
					AND (avCompany.cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						OR avCompany.affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
				<cfelseif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>
					AND avCompany.cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfelseif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
					AND avCompany.affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
		</cfquery>

		<cfif qry_checkSubscriberPermission.RecordCount is 0 or qry_checkSubscriberPermission.RecordCount is not ListLen(Arguments.subscriberID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectSubscriber" Access="public" Output="No" ReturnType="query" Hint="Select Existing Subscriber">
	<cfargument Name="subscriberID" Type="string" Required="Yes">

	<cfset var qry_selectSubscriber = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.subscriberID)>
		<cfset Arguments.subscriberID = 0>
	</cfif>

	<cfquery Name="qry_selectSubscriber" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSubscriber.subscriberID, avSubscriber.companyID, avSubscriber.userID, avSubscriber.userID_author,
			avSubscriber.userID_cancel, avSubscriber.companyID_author, avSubscriber.subscriberName,
			avSubscriber.subscriberID_custom, avSubscriber.subscriberCompleted, avSubscriber.subscriberStatus,
			avSubscriber.subscriberDateProcessNext, avSubscriber.subscriberDateProcessLast, avSubscriber.addressID_billing,
			avSubscriber.addressID_shipping, avSubscriber.subscriberDateCreated, avSubscriber.subscriberDateUpdated,
			avSubscriber.subscriberIsExported, avSubscriber.subscriberDateExported,
			avCompany.companyName, avCompany.companyID_custom,
			avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avSubscriber
			LEFT OUTER JOIN avCompany ON avSubscriber.companyID = avCompany.companyID
			LEFT OUTER JOIN avUser ON avSubscriber.userID = avUser.userID
		WHERE avSubscriber.subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectSubscriber>
</cffunction>

<cffunction Name="selectSubscriberIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects subscriberID of existing subscriber via custom ID and returns subscriberID if exists, 0 if not exists, and -1 if multiple companies have the same subscriberID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="subscriberID_custom" Type="string" Required="Yes">

	<cfset var qry_selectSubscriberIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriberIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT subscriberID
		FROM avSubscriber
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND subscriberID_custom IN (<cfqueryparam Value="#Arguments.subscriberID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectSubscriberIDViaCustomID.RecordCount is 0 or qry_selectSubscriberIDViaCustomID.RecordCount lt ListLen(Arguments.subscriberID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectSubscriberIDViaCustomID.RecordCount gt ListLen(Arguments.subscriberID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectSubscriberIDViaCustomID.subscriberID)>
	</cfif>
</cffunction>


<!--- functions for viewing list of subscribers --->
<cffunction Name="selectSubscriberList" Access="public" ReturnType="query" Hint="Select list of subscribers">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="userID_custom" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="subscriberName" Type="string" Required="No">
	<cfargument Name="subscriptionName" Type="string" Required="No">
	<cfargument Name="subscriberID_custom" Type="string" Required="No">
	<cfargument Name="subscriptionProductID_custom" Type="string" Required="No">
	<cfargument Name="subscriptionDescription" Type="string" Required="No">
	<cfargument Name="subscriptionIntervalType" Type="string" Required="No">
	<cfargument Name="subscriptionID_custom" Type="string" Required="No">
	<cfargument Name="subscriberDateType" Type="string" Required="No">
	<cfargument Name="searchPriceField" Type="string" Required="No">

	<cfargument Name="subscriberStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentExists" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyMultipleUser" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmail" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmailHtml" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPdf" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyDoc" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPhoneID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyAddressID" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasParameter" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasParameterException" Type="numeric" Required="No">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriptionIsCustomProduct" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasPrice" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasDescription" Type="numeric" Required="No">
	<cfargument Name="subscriptionDescriptionHtml" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantityVaries" Type="numeric" Required="No">
	<cfargument Name="subscriberHasCustomID" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasCustomID" Type="numeric" Required="No">
	<cfargument Name="subscriptionContinuesAfterEnd" Type="numeric" Required="No">
	<cfargument Name="subscriptionEndByDateOrAppliedMaximum" Type="string" Required="No">
	<cfargument Name="subscriptionHasEndDate" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasMaximum" Type="numeric" Required="No">
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="numeric" Required="No">

	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="phoneID" Type="string" Required="No">
	<cfargument Name="addressID" Type="string" Required="No">
	<cfargument Name="productParameterOptionID" Type="string" Required="No">
	<cfargument Name="productParameterExceptionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceStageID" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="subscriptionInterval" Type="string" Required="No">
	<cfargument Name="subscriptionAppliedMaximum" Type="string" Required="No">
	<cfargument Name="subscriptionAppliedRemaining" Type="string" Required="No">
	<cfargument Name="statusID_subscriber" Type="string" Required="No">
	<cfargument Name="statusID_subscription" Type="string" Required="No">

	<cfargument Name="subscriptionInterval_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionInterval_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedMaximum_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedMaximum_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedRemaining_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedRemaining_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal_max" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal_min" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal_max" Type="numeric" Required="No">
	<cfargument Name="searchPrice_min" Type="numeric" Required="No">
	<cfargument Name="searchPrice_max" Type="numeric" Required="No">

	<cfargument Name="subscriberDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriberDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriberDateCreated" Type="string" Required="No">
	<cfargument Name="subscriberDateUpdated" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriptionDateBegin" Type="string" Required="No">
	<cfargument Name="subscriptionDateEnd" Type="string" Required="No">
	<cfargument Name="subscriptionDateCreated" Type="string" Required="No">
	<cfargument Name="subscriberDateFrom" Type="string" Required="No">
	<cfargument Name="subscriberDateTo" Type="string" Required="No">
	<cfargument Name="subscriberIsExported" Type="string" Required="No">
	<cfargument Name="subscriberDateExported_from" Type="string" Required="No">
	<cfargument Name="subscriberDateExported_to" Type="string" Required="No">
	<cfargument Name="subscriptionIsRollup" Type="numeric" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="no" default="subscriberName">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="No" Default="">

	<cfset var qry_selectSubscriberList = QueryNew("blank")>
	<cfset var displayOr = False>
	<cfset var dateClause = "">
	<cfset var totalClause = "">
	<cfset var thisField = "">

	<cfswitch expression="#Arguments.queryOrderBy#">
	 <cfcase value="subscriberID,subscriberDateProcessNext,subscriberDateProcessLast,subscriberName,subscriberDateUpdated">
		<cfset queryParameters_orderBy = "avSubscriber.#Arguments.queryOrderBy#">
	 </cfcase>
	 <cfcase value="subscriberID_d,subscriberDateProcessNext_d,subscriberDateProcessLast_d,subscriberName_d,subscriberDateUpdated_d">
		<cfset queryParameters_orderBy = "avSubscriber.#ListFirst(Arguments.queryOrderBy, '_')# DESC">
	 </cfcase>
	 <cfcase value="subscriberDateCreated"><cfset queryParameters_orderBy = "avSubscriber.subscriberID"></cfcase>
	 <cfcase value="subscriberDateCreated_d"><cfset queryParameters_orderBy = "avSubscriber.subscriberID DESC"></cfcase>
	 <cfcase value="subscriberID_custom"><cfset queryParameters_orderBy = "avSubscriber.subscriberID_custom"></cfcase>
	 <cfcase value="subscriberID_custom_d"><cfset queryParameters_orderBy = "avSubscriber.subscriberID_custom DESC"></cfcase>
	 <cfcase value="companyName"><cfset queryParameters_orderBy = "avCompany.companyName"></cfcase>
	 <cfcase value="companyName_d"><cfset queryParameters_orderBy = "avCompany.companyName DESC"></cfcase>
	 <cfcase value="lastName"><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfcase>
	 <cfcase value="lastName_d"><cfset queryParameters_orderBy = "avUser.lastName DESC, avUser.firstName DESC"></cfcase>
	 <cfcase value="subscriberStatus"><cfset queryParameters_orderBy = "avSubscriber.subscriberStatus DESC, avSubscriber.subscriberDateProcessNext DESC"></cfcase>
	 <cfcase value="subscriberStatus_d"><cfset queryParameters_orderBy = "avSubscriber.subscriberStatus, avSubscriber.subscriberDateProcessNext"></cfcase>
	 <cfcase value="subscriberCompleted"><cfset queryParameters_orderBy = "avSubscriber.subscriberCompleted DESC, avSubscriber.subscriberDateProcessNext DESC"></cfcase>
	 <cfcase value="subscriberCompleted_d"><cfset queryParameters_orderBy = "avSubscriber.subscriberCompleted, avSubscriber.subscriberDateProcessNext"></cfcase>
	 <cfcase value="subscriberLineItemTotal"><cfset queryParameters_orderBy = "subscriberLineItemTotal, avSubscriber.subscriberName"></cfcase>
	 <cfcase value="subscriberLineItemTotal_d"><cfset queryParameters_orderBy = "subscriberLineItemTotal DESC, avSubscriber.subscriberName DESC"></cfcase>
	 <cfcase value="subscriberLineItemCount"><cfset queryParameters_orderBy = "subscriberLineItemCount, avSubscriber.subscriberName"></cfcase>
	 <cfcase value="subscriberLineItemCount_d"><cfset queryParameters_orderBy = "subscriberLineItemCount DESC, avSubscriber.subscriberName DESC"></cfcase>
	 <cfdefaultcase><cfset queryParameters_orderBy = "avSubscriber.subscriberName"></cfdefaultcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCompany,avSubscriber">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectSubscriberList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avSubscriber.subscriberID, avSubscriber.subscriberID_custom, avSubscriber.companyID, avSubscriber.userID,
			avSubscriber.userID_author, avSubscriber.userID_cancel, avSubscriber.companyID_author,
			avSubscriber.subscriberName, avSubscriber.subscriberStatus, avSubscriber.subscriberCompleted,
			avSubscriber.subscriberDateProcessNext, avSubscriber.subscriberDateProcessLast,
			avSubscriber.addressID_billing, avSubscriber.addressID_shipping,
			avSubscriber.subscriberIsExported, avSubscriber.subscriberDateExported,
			avSubscriber.subscriberDateCreated, avSubscriber.subscriberDateUpdated,
			avCompany.companyName, avCompany.companyID_custom,
			avUser.firstName, avUser.lastName, avUser.userID_custom,
			(
				SELECT COUNT(avSubscription.subscriberID)
				FROM avSubscription
				WHERE avSubscription.subscriberID = avSubscriber.subscriberID
					AND avSubscription.subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avSubscription.subscriptionCompleted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			)
			AS subscriberLineItemCount,
			(
				SELECT SUM(avSubscription.subscriptionPriceUnit * avSubscription.subscriptionQuantity)
				FROM avSubscription
				WHERE avSubscription.subscriberID = avSubscriber.subscriberID
					AND avSubscription.subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					AND avSubscription.subscriptionCompleted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			)
			AS subscriberLineItemTotal
		FROM avSubscriber
			LEFT OUTER JOIN avCompany ON avSubscriber.companyID = avCompany.companyID
			LEFT OUTER JOIN avUser ON avSubscriber.userID = avUser.userID
		WHERE avSubscriber.subscriberID IN 
			(
			SELECT DISTINCT(avSubscriber.subscriberID)
			FROM avSubscriber
				LEFT OUTER JOIN avCompany ON avSubscriber.companyID = avCompany.companyID
				LEFT OUTER JOIN avUser ON avSubscriber.userID = avUser.userID
				LEFT OUTER JOIN avSubscription ON avSubscriber.subscriberID = avSubscription.subscriberID
				LEFT OUTER JOIN avSubscriberNotify ON avSubscriber.subscriberID = avSubscriberNotify.subscriberID AND avSubscriberNotify.subscriberNotifyStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				LEFT OUTER JOIN avSubscriberPayment ON avSubscriber.subscriberID = avSubscriberPayment.subscriberID AND avSubscriberPayment.subscriberPaymentStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE 
				<cfinclude template="dataShared/qryWhere_selectSubscriberList.cfm">
				<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "" and Arguments.queryFirstLetter_field is not "">
					<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
						AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
					<cfelse><!--- letter --->
						AND (Left(#Arguments.queryFirstLetter_field#, 1) >= '#UCase(Arguments.queryFirstLetter)#' OR Left(#Arguments.queryFirstLetter_field#, 1) >= '#LCase(Arguments.queryFirstLetter)#')
					</cfif>
				</cfif>
			)
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectSubscriberList>
</cffunction>

<cffunction Name="selectSubscriberCount" Access="public" ReturnType="numeric" Hint="Select total number of subscribers in list">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="userID_custom" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="subscriberName" Type="string" Required="No">
	<cfargument Name="subscriptionName" Type="string" Required="No">
	<cfargument Name="subscriberID_custom" Type="string" Required="No">
	<cfargument Name="subscriptionProductID_custom" Type="string" Required="No">
	<cfargument Name="subscriptionDescription" Type="string" Required="No">
	<cfargument Name="subscriptionIntervalType" Type="string" Required="No">
	<cfargument Name="subscriptionID_custom" Type="string" Required="No">
	<cfargument Name="subscriberDateType" Type="string" Required="No">
	<cfargument Name="searchPriceField" Type="string" Required="No">

	<cfargument Name="subscriberStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentExists" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyMultipleUser" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmail" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmailHtml" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPdf" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyDoc" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPhoneID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyAddressID" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasParameter" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasParameterException" Type="numeric" Required="No">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriptionIsCustomProduct" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasPrice" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasDescription" Type="numeric" Required="No">
	<cfargument Name="subscriptionDescriptionHtml" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantityVaries" Type="numeric" Required="No">
	<cfargument Name="subscriberHasCustomID" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasCustomID" Type="numeric" Required="No">
	<cfargument Name="subscriptionContinuesAfterEnd" Type="numeric" Required="No">
	<cfargument Name="subscriptionEndByDateOrAppliedMaximum" Type="string" Required="No">
	<cfargument Name="subscriptionHasEndDate" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasMaximum" Type="numeric" Required="No">
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="numeric" Required="No">

	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="phoneID" Type="string" Required="No">
	<cfargument Name="addressID" Type="string" Required="No">
	<cfargument Name="productParameterOptionID" Type="string" Required="No">
	<cfargument Name="productParameterExceptionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceStageID" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="subscriptionInterval" Type="string" Required="No">
	<cfargument Name="subscriptionAppliedMaximum" Type="string" Required="No">
	<cfargument Name="subscriptionAppliedRemaining" Type="string" Required="No">
	<cfargument Name="statusID_subscriber" Type="string" Required="No">
	<cfargument Name="statusID_subscription" Type="string" Required="No">

	<cfargument Name="subscriptionInterval_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionInterval_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedMaximum_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedMaximum_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedRemaining_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedRemaining_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal_max" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal_min" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal_max" Type="numeric" Required="No">
	<cfargument Name="searchPrice_min" Type="numeric" Required="No">
	<cfargument Name="searchPrice_max" Type="numeric" Required="No">

	<cfargument Name="subscriberDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriberDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriberDateCreated" Type="string" Required="No">
	<cfargument Name="subscriberDateUpdated" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriptionDateBegin" Type="string" Required="No">
	<cfargument Name="subscriptionDateEnd" Type="string" Required="No">
	<cfargument Name="subscriptionDateCreated" Type="string" Required="No">
	<cfargument Name="subscriberDateFrom" Type="string" Required="No">
	<cfargument Name="subscriberDateTo" Type="string" Required="No">
	<cfargument Name="subscriberIsExported" Type="string" Required="No">
	<cfargument Name="subscriberDateExported_from" Type="string" Required="No">
	<cfargument Name="subscriberDateExported_to" Type="string" Required="No">
	<cfargument Name="subscriptionIsRollup" Type="numeric" Required="No">

	<cfset var displayOr = False>
	<cfset var dateClause = "">
	<cfset var totalClause = "">
	<cfset var thisField = "">
	<cfset var qry_selectSubscriberCount = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriberCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(subscriberID) AS totalRecords
		FROM avSubscriber
		WHERE subscriberID IN 
			(
			SELECT DISTINCT(avSubscriber.subscriberID)
			FROM avSubscriber
				LEFT OUTER JOIN avCompany ON avSubscriber.companyID = avCompany.companyID
				LEFT OUTER JOIN avUser ON avSubscriber.userID = avUser.userID
				LEFT OUTER JOIN avSubscription ON avSubscriber.subscriberID = avSubscription.subscriberID
				LEFT OUTER JOIN avSubscriberNotify ON avSubscriber.subscriberID = avSubscriberNotify.subscriberID AND avSubscriberNotify.subscriberNotifyStatus = 1
				LEFT OUTER JOIN avSubscriberPayment ON avSubscriber.subscriberID = avSubscriberPayment.subscriberID AND avSubscriberPayment.subscriberPaymentStatus = 1
			WHERE 
				<cfinclude template="dataShared/qryWhere_selectSubscriberList.cfm">
			)
	</cfquery>

	<cfreturn qry_selectSubscriberCount.totalRecords>
</cffunction>

<cffunction Name="selectSubscriberList_alphabet" Access="public" ReturnType="query" Hint="Select the first letter in value of field by which list of subscribers is ordered">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="userID_custom" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="subscriberName" Type="string" Required="No">
	<cfargument Name="subscriptionName" Type="string" Required="No">
	<cfargument Name="subscriberID_custom" Type="string" Required="No">
	<cfargument Name="subscriptionProductID_custom" Type="string" Required="No">
	<cfargument Name="subscriptionDescription" Type="string" Required="No">
	<cfargument Name="subscriptionIntervalType" Type="string" Required="No">
	<cfargument Name="subscriptionID_custom" Type="string" Required="No">
	<cfargument Name="subscriberDateType" Type="string" Required="No">
	<cfargument Name="searchPriceField" Type="string" Required="No">

	<cfargument Name="subscriberStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentExists" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyMultipleUser" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmail" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmailHtml" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPdf" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyDoc" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPhoneID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyAddressID" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasParameter" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasParameterException" Type="numeric" Required="No">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriptionIsCustomProduct" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasPrice" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasDescription" Type="numeric" Required="No">
	<cfargument Name="subscriptionDescriptionHtml" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantityVaries" Type="numeric" Required="No">
	<cfargument Name="subscriberHasCustomID" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasCustomID" Type="numeric" Required="No">
	<cfargument Name="subscriptionContinuesAfterEnd" Type="numeric" Required="No">
	<cfargument Name="subscriptionEndByDateOrAppliedMaximum" Type="string" Required="No">
	<cfargument Name="subscriptionHasEndDate" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasMaximum" Type="numeric" Required="No">
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="numeric" Required="No">

	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="phoneID" Type="string" Required="No">
	<cfargument Name="addressID" Type="string" Required="No">
	<cfargument Name="productParameterOptionID" Type="string" Required="No">
	<cfargument Name="productParameterExceptionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceStageID" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="subscriptionInterval" Type="string" Required="No">
	<cfargument Name="subscriptionAppliedMaximum" Type="string" Required="No">
	<cfargument Name="subscriptionAppliedRemaining" Type="string" Required="No">
	<cfargument Name="statusID_subscriber" Type="string" Required="No">
	<cfargument Name="statusID_subscription" Type="string" Required="No">

	<cfargument Name="subscriptionInterval_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionInterval_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedMaximum_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedMaximum_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedRemaining_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedRemaining_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal_max" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal_min" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal_max" Type="numeric" Required="No">
	<cfargument Name="searchPrice_min" Type="numeric" Required="No">
	<cfargument Name="searchPrice_max" Type="numeric" Required="No">

	<cfargument Name="subscriberDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriberDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriberDateCreated" Type="string" Required="No">
	<cfargument Name="subscriberDateUpdated" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriptionDateBegin" Type="string" Required="No">
	<cfargument Name="subscriptionDateEnd" Type="string" Required="No">
	<cfargument Name="subscriptionDateCreated" Type="string" Required="No">
	<cfargument Name="subscriberDateFrom" Type="string" Required="No">
	<cfargument Name="subscriberDateTo" Type="string" Required="No">
	<cfargument Name="subscriberIsExported" Type="string" Required="No">
	<cfargument Name="subscriberDateExported_from" Type="string" Required="No">
	<cfargument Name="subscriberDateExported_to" Type="string" Required="No">
	<cfargument Name="subscriptionIsRollup" Type="numeric" Required="No">

	<cfargument Name="alphabetField" Type="string" Required="Yes">

	<cfset var displayOr = False>
	<cfset var dateClause = "">
	<cfset var totalClause = "">
	<cfset var thisField = "">
	<cfset var qry_selectSubscriberList_alphabet = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriberList_alphabet" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Distinct(Left(#Arguments.alphabetField#, 1)) AS firstLetter
		FROM avSubscriber
			LEFT OUTER JOIN avCompany ON avSubscriber.companyID = avCompany.companyID
			LEFT OUTER JOIN avUser ON avSubscriber.userID = avUser.userID
			LEFT OUTER JOIN avSubscription ON avSubscriber.subscriberID = avSubscription.subscriberID
			LEFT OUTER JOIN avSubscriberNotify ON avSubscriber.subscriberID = avSubscriberNotify.subscriberID AND avSubscriberNotify.subscriberNotifyStatus = 1
			LEFT OUTER JOIN avSubscriberPayment ON avSubscriber.subscriberID = avSubscriberPayment.subscriberID AND avSubscriberPayment.subscriberPaymentStatus = 1
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectSubscriberList.cfm">
		ORDER BY firstLetter
	</cfquery>

	<cfreturn qry_selectSubscriberList_alphabet>
</cffunction>

<cffunction Name="selectSubscriberList_alphabetPage" Access="public" ReturnType="numeric" Hint="Select page which includes the first record where the first letter in value of field by which list of subscribers is ordered">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="userID_custom" Type="string" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="subscriberName" Type="string" Required="No">
	<cfargument Name="subscriptionName" Type="string" Required="No">
	<cfargument Name="subscriberID_custom" Type="string" Required="No">
	<cfargument Name="subscriptionProductID_custom" Type="string" Required="No">
	<cfargument Name="subscriptionDescription" Type="string" Required="No">
	<cfargument Name="subscriptionIntervalType" Type="string" Required="No">
	<cfargument Name="subscriptionID_custom" Type="string" Required="No">
	<cfargument Name="subscriberDateType" Type="string" Required="No">
	<cfargument Name="searchPriceField" Type="string" Required="No">

	<cfargument Name="subscriberStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentExists" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentHasBankID" Type="numeric" Required="No">
	<cfargument Name="subscriberPaymentHasCreditCardID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyMultipleUser" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmail" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyEmailHtml" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPdf" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyDoc" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyPhoneID" Type="numeric" Required="No">
	<cfargument Name="subscriberNotifyAddressID" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasParameter" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasParameterException" Type="numeric" Required="No">
	<cfargument Name="subscriptionCompleted" Type="numeric" Required="No">
	<cfargument Name="subscriptionIsCustomProduct" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasPrice" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasDescription" Type="numeric" Required="No">
	<cfargument Name="subscriptionDescriptionHtml" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantityVaries" Type="numeric" Required="No">
	<cfargument Name="subscriberHasCustomID" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasCustomID" Type="numeric" Required="No">
	<cfargument Name="subscriptionContinuesAfterEnd" Type="numeric" Required="No">
	<cfargument Name="subscriptionEndByDateOrAppliedMaximum" Type="string" Required="No">
	<cfargument Name="subscriptionHasEndDate" Type="numeric" Required="No">
	<cfargument Name="subscriptionHasMaximum" Type="numeric" Required="No">
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberProcessAllQuantitiesEntered" Type="numeric" Required="No">

	<cfargument Name="bankID" Type="string" Required="No">
	<cfargument Name="creditCardID" Type="string" Required="No">
	<cfargument Name="subscriberID" Type="string" Required="No">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="phoneID" Type="string" Required="No">
	<cfargument Name="addressID" Type="string" Required="No">
	<cfargument Name="productParameterOptionID" Type="string" Required="No">
	<cfargument Name="productParameterExceptionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceStageID" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="subscriptionInterval" Type="string" Required="No">
	<cfargument Name="subscriptionAppliedMaximum" Type="string" Required="No">
	<cfargument Name="subscriptionAppliedRemaining" Type="string" Required="No">
	<cfargument Name="statusID_subscriber" Type="string" Required="No">
	<cfargument Name="statusID_subscription" Type="string" Required="No">

	<cfargument Name="subscriptionInterval_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionInterval_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedMaximum_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedMaximum_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedRemaining_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionAppliedRemaining_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionQuantity_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionPriceUnit_max" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal_min" Type="numeric" Required="No">
	<cfargument Name="subscriptionTotal_max" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal_min" Type="numeric" Required="No">
	<cfargument Name="subscriberLineItemTotal_max" Type="numeric" Required="No">
	<cfargument Name="searchPrice_min" Type="numeric" Required="No">
	<cfargument Name="searchPrice_max" Type="numeric" Required="No">

	<cfargument Name="subscriberDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriberDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriberDateCreated" Type="string" Required="No">
	<cfargument Name="subscriberDateUpdated" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessNext" Type="string" Required="No">
	<cfargument Name="subscriptionDateProcessLast" Type="string" Required="No">
	<cfargument Name="subscriptionDateBegin" Type="string" Required="No">
	<cfargument Name="subscriptionDateEnd" Type="string" Required="No">
	<cfargument Name="subscriptionDateCreated" Type="string" Required="No">
	<cfargument Name="subscriberDateFrom" Type="string" Required="No">
	<cfargument Name="subscriberDateTo" Type="string" Required="No">
	<cfargument Name="subscriberIsExported" Type="string" Required="No">
	<cfargument Name="subscriberDateExported_from" Type="string" Required="No">
	<cfargument Name="subscriberDateExported_to" Type="string" Required="No">
	<cfargument Name="subscriptionIsRollup" Type="numeric" Required="No">

	<cfargument Name="queryFirstLetter" Type="string" Required="Yes">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="Yes">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="Yes">

	<cfset var displayOr = False>
	<cfset var dateClause = "">
	<cfset var totalClause = "">
	<cfset var thisField = "">
	<cfset var qry_selectSubscriberList_alphabetPage = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriberList_alphabetPage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avSubscriber.subscriberID) AS recordCountBeforeAlphabet
		FROM avSubscriber
			LEFT OUTER JOIN avCompany ON avSubscriber.companyID = avCompany.companyID
			LEFT OUTER JOIN avUser ON avSubscriber.userID = avUser.userID
			LEFT OUTER JOIN avSubscription ON avSubscriber.subscriberID = avSubscription.subscriberID
			LEFT OUTER JOIN avSubscriberNotify ON avSubscriber.subscriberID = avSubscriberNotify.subscriberID AND avSubscriberNotify.subscriberNotifyStatus = 1
			LEFT OUTER JOIN avSubscriberPayment ON avSubscriber.subscriberID = avSubscriberPayment.subscriberID AND avSubscriberPayment.subscriberPaymentStatus = 1
		WHERE 
			<cfinclude template="dataShared/qryWhere_selectSubscriberList.cfm">
			<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
				AND Left(#Arguments.queryFirstLetter_field#, 1) < 'a'
			<cfelse><!--- letter --->
				AND (Left(#Arguments.queryFirstLetter_field#, 1) < '#UCase(Arguments.queryFirstLetter)#' OR Left(#Arguments.queryFirstLetter_field#, 1) < '#LCase(Arguments.queryFirstLetter)#')
			</cfif>
	</cfquery>

	<cfreturn 1 + (qry_selectSubscriberList_alphabetPage.recordCountBeforeAlphabet \ Arguments.queryDisplayPerPage)>
</cffunction>
<!--- /functions for viewing list of subscribers --->

<cffunction Name="selectMinSubscriptionDateProcessNext" Access="public" Output="No" ReturnType="string" Hint="Select next processing date for a subscriber">
	<cfargument Name="subscriberID" Type="numeric" Required="Yes">

	<cfset var qry_selectMinSubscriptionDateProcessNext = QueryNew("blank")>

	<cfquery Name="qry_selectMinSubscriptionDateProcessNext" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT MIN(subscriptionDateProcessNext) AS minSubscriptionProcessDateNext
		FROM avSubscription
		WHERE subscriberID = <cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer">
			AND subscriptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND subscriptionCompleted = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>

	<cfreturn qry_selectMinSubscriptionDateProcessNext.minSubscriptionProcessDateNext>
</cffunction>

<!--- Update Export Status --->
<cffunction Name="updateSubscriberIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether subscriber records have been exported. Returns True.">
	<cfargument Name="subscriberID" Type="string" Required="Yes">
	<cfargument Name="subscriberIsExported" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.subscriberID) or (Arguments.subscriberIsExported is not "" and Not ListFind("0,1", Arguments.subscriberIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateSubscriberIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSubscriber
			SET subscriberIsExported = <cfif Not ListFind("0,1", Arguments.subscriberIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.subscriberIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				subscriberDateExported = <cfif Not ListFind("0,1", Arguments.subscriberIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE subscriberID IN (<cfqueryparam Value="#Arguments.subscriberID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>
