<cfcomponent DisplayName="Price" Hint="Manages inserting, updating, deleting and viewing custom pricing">

<cffunction name="maxlength_Price" access="public" output="no" returnType="struct">
	<cfset var maxlength_Price = StructNew()>

	<cfset maxlength_Price.priceCode = 25>
	<cfset maxlength_Price.priceName = 255>
	<cfset maxlength_Price.priceDescription = 255>
	<cfset maxlength_Price.priceBillingMethod = 255>
	<cfset maxlength_Price.priceQuantityMinimumPerOrder = 4>
	<cfset maxlength_Price.priceQuantityMaximumAllCustomers = 4>
	<cfset maxlength_Price.priceQuantityMaximumPerCustomer = 4>
	<cfset maxlength_Price.priceID_custom = 50>

	<cfreturn maxlength_Price>
</cffunction>

<cffunction name="maxlength_PriceStage" access="public" output="no" returnType="struct">
	<cfset var maxlength_PriceStage = StructNew()>
	
	<cfset maxlength_PriceStage.priceStageAmount = 4>
	<cfset maxlength_PriceStage.priceStageIntervalType = 5>
	<cfset maxlength_PriceStage.priceStageText = 255>
	<cfset maxlength_PriceStage.priceStageDescription = 255>

	<cfreturn maxlength_PriceStage>
</cffunction>

<cffunction Name="insertPrice" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new price. Returns priceID.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No" Default="0">
	<cfargument Name="productID" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceAppliesToCategory" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceAppliesToCategoryChildren" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceAppliesToProduct" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceAppliesToProductChildren" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceAppliesToAllProducts" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceAppliesToAllCustomers" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceAppliesToInvoice" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceCode" Type="string" Required="No" Default="">
	<cfargument Name="priceCodeRequired" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceID_custom" Type="string" Required="No" Default="">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="priceStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="priceApproved" Type="numeric" Required="No" Default="1">
	<cfargument Name="priceDateApproved" Type="string" Required="No">
	<cfargument Name="userID_approved" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceName" Type="string" Required="No" Default="">
	<cfargument Name="priceDescription" Type="string" Required="No" Default="">
	<cfargument Name="priceQuantityMinimumPerOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceAppliedStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceQuantityMaximumAllCustomers" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceQuantityMaximumPerCustomer" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceBillingMethod" Type="string" Required="No" Default="">
	<cfargument Name="priceDateBegin" Type="string" Required="No">
	<cfargument Name="priceDateEnd" Type="string" Required="No">
	<cfargument Name="priceID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceID_trend" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceIsParent" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceStageAmount" Type="array" Required="Yes">
	<cfargument Name="priceStageDollarOrPercent" Type="array" Required="Yes">
	<cfargument Name="priceStageNewOrDeduction" Type="array" Required="Yes">
	<cfargument Name="priceStageVolumeDiscount" Type="array" Required="Yes">
	<cfargument Name="priceStageVolumeDollarOrQuantity" Type="array" Required="Yes">
	<cfargument Name="priceStageVolumeStep" Type="array" Required="Yes">
	<cfargument Name="priceStageInterval" Type="array" Required="Yes">
	<cfargument Name="priceStageIntervalType" Type="array" Required="Yes">
	<cfargument Name="priceStageText" Type="array" Required="Yes">
	<cfargument Name="priceStageDescription" Type="array" Required="Yes">
	<cfargument Name="priceVolumeDiscountQuantityMinimum" Type="array" Required="Yes">
	<cfargument Name="priceVolumeDiscountAmount" Type="array" Required="Yes">
	<cfargument Name="priceVolumeDiscountIsTotalPrice" Type="array" Required="Yes">

	<cfset var priceHasMultipleStage = 0>
	<cfset var qry_insertPrice = QueryNew("blank")>
	<cfset var priceID = 0>
	<cfset var isVolumeDiscount = False>
	<cfset var stageCount = 0>
	<cfset var thisPriceStageID = 0>
	<cfset var qry_selectPriceStageID = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Price" method="maxlength_Price" returnVariable="maxlength_Price" />
	<cfinvoke component="#Application.billingMapping#data.Price" method="maxlength_PriceStage" returnVariable="maxlength_PriceStage" />
	<cfinvoke component="#Application.billingMapping#data.PriceVolumeDiscount" method="maxlength_PriceVolumeDiscount" returnVariable="maxlength_PriceVolumeDiscount" />

	<cfif ArrayLen(Arguments.priceStageAmount) gt 1>
		<cfset priceHasMultipleStages = 1>
	<cfelse>
		<cfset priceHasMultipleStages = 0>
	</cfif>

	<cftransaction>
		<cfquery Name="qry_insertPrice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avPrice
			(
				companyID, categoryID, productID, priceAppliesToCategory, priceAppliesToCategoryChildren, priceAppliesToProduct,
				priceAppliesToProductChildren, priceAppliesToAllProducts, priceAppliesToAllCustomers, priceAppliesToInvoice,
				priceCode, priceCodeRequired, userID, priceStatus, priceApproved, priceDateApproved, userID_approved, priceName,
				priceDescription, priceQuantityMinimumPerOrder, priceAppliedStatus, priceQuantityMaximumAllCustomers,
				priceQuantityMaximumPerCustomer, priceBillingMethod, priceDateBegin, priceDateEnd, priceID_parent, priceID_trend,
				priceIsParent, priceHasMultipleStages, priceID_custom, priceDateCreated, priceDateUpdated
			)
			VALUES
			(
				<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.priceAppliesToCategory#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceAppliesToCategoryChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceAppliesToProduct#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceAppliesToProductChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceAppliesToAllProducts#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceAppliesToAllCustomers#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceAppliesToInvoice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Price.priceCode#">,
				<cfqueryparam Value="#Arguments.priceCodeRequired#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.priceStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceApproved#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfif Not StructKeyExists(Arguments, "priceDateApproved") or Not IsDate(Arguments.priceDateApproved)>NULL<cfelse><cfqueryparam Value="#Arguments.priceDateApproved#" cfsqltype="cf_sql_timestamp"></cfif>,
				<cfqueryparam Value="#Arguments.userID_approved#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.priceName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Price.priceName#">,
				<cfqueryparam Value="#Arguments.priceDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Price.priceDescription#">,
				<cfqueryparam Value="#Arguments.priceQuantityMinimumPerOrder#" cfsqltype="cf_sql_decimal" Scale="#maxlength_Price.priceQuantityMinimumPerOrder#">,
				<cfqueryparam Value="#Arguments.priceAppliedStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceQuantityMaximumAllCustomers#" cfsqltype="cf_sql_decimal" Scale="#maxlength_Price.priceQuantityMaximumAllCustomers#">,
				<cfqueryparam Value="#Arguments.priceQuantityMaximumPerCustomer#" cfsqltype="cf_sql_decimal" Scale="#maxlength_Price.priceQuantityMaximumPerCustomer#">,
				<cfqueryparam Value="#Arguments.priceBillingMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Price.priceBillingMethod#">,
				<cfif Not StructKeyExists(Arguments, "priceDateBegin") or Not IsDate(Arguments.priceDateBegin)>#Application.billingSql.sql_nowDateTime#<cfelse><cfqueryparam Value="#Arguments.priceDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
				<cfif Not StructKeyExists(Arguments, "priceDateEnd") or Not IsDate(Arguments.priceDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.priceDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
				<cfqueryparam Value="#Arguments.priceID_parent#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.priceID_trend#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.priceIsParent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#priceHasMultipleStages#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.priceID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Price.priceID_custom#">,
				#Application.billingSql.sql_nowDateTime#,
				#Application.billingSql.sql_nowDateTime#
			);

			#Replace(Application.billingSql.identityField_select, "primaryKeyField", "priceID", "ALL")#;
		</cfquery>

		<cfif Arguments.priceID_trend is 0>
			<cfquery Name="qry_insertPrice_trend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				UPDATE avPrice
				SET priceID_trend = priceID
				WHERE priceID = <cfqueryparam Value="#qry_insertPrice.primaryKeyID#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>

		<cfset priceID = qry_insertPrice.primaryKeyID>

		<cfset isVolumeDiscount = False>

		<cfquery Name="qry_insertPriceStage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfloop Index="stageCount" From="1" To="#ArrayLen(Arguments.priceStageAmount)#">
				INSERT INTO avPriceStage
				(
					priceID, priceStageOrder, priceStageAmount, priceStageDollarOrPercent, priceStageNewOrDeduction,
					priceStageVolumeDiscount, priceStageVolumeDollarOrQuantity, priceStageVolumeStep, priceStageInterval,
					priceStageIntervalType, priceStageText, priceStageDescription
				)
				VALUES
				(
					<cfqueryparam Value="#priceID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam Value="#stageCount#" cfsqltype="cf_sql_tinyint">,
					<cfqueryparam Value="#Arguments.priceStageAmount[stageCount]#" cfsqltype="cf_sql_money">,
					<cfqueryparam Value="#Arguments.priceStageDollarOrPercent[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#Arguments.priceStageNewOrDeduction[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#Arguments.priceStageVolumeDiscount[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#Arguments.priceStageVolumeDollarOrQuantity[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#Arguments.priceStageVolumeStep[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
					<cfqueryparam Value="#Arguments.priceStageInterval[stageCount]#" cfsqltype="cf_sql_smallint">,
					<cfqueryparam Value="#Arguments.priceStageIntervalType[stageCount]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PriceStage.priceStageIntervalType#">,
					<cfqueryparam Value="#Arguments.priceStageText[stageCount]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PriceStage.priceStageText#">,
					<cfqueryparam Value="#Arguments.priceStageDescription[stageCount]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_PriceStage.priceStageDescription#">
				);
				<cfif Arguments.priceStageVolumeDiscount[stageCount] is 1>
					<cfset isVolumeDiscount = True>
				</cfif>
			</cfloop>
		</cfquery>
		
		<cfif isVolumeDiscount is True>
			<cfquery Name="qry_selectPriceStageID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				SELECT priceStageID, priceStageOrder
				FROM avPriceStage
				WHERE priceID = <cfqueryparam Value="#priceID#" cfsqltype="cf_sql_integer">
					AND priceStageVolumeDiscount = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfquery>

			<cfloop Query="qry_selectPriceStageID">
				<cfset stageCount = qry_selectPriceStageID.priceStageOrder>
				<cfset thisPriceStageID = qry_selectPriceStageID.priceStageID>

				<cfquery Name="qry_insertPriceVolumeDiscount#stageCount#" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
					<cfloop Index="volumeCount" From="1" To="#ArrayLen(Arguments.priceVolumeDiscountAmount[stageCount])#">
						INSERT INTO avPriceVolumeDiscount
						(
							priceStageID, priceVolumeDiscountQuantityMinimum, priceVolumeDiscountQuantityIsMaximum,
							priceVolumeDiscountAmount, priceVolumeDiscountIsTotalPrice
						)
						VALUES
						(
							<cfqueryparam Value="#thisPriceStageID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam Value="#Arguments.priceVolumeDiscountQuantityMinimum[stageCount][volumeCount]#" cfsqltype="cf_sql_decimal" Scale="#maxlength_PriceVolumeDiscount.priceVolumeDiscountQuantityMinimum#">,
							<cfqueryparam Value="#Iif(volumeCount is ArrayLen(Arguments.priceVolumeDiscountAmount[stageCount]), 1, 0)#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
							<cfqueryparam Value="#Arguments.priceVolumeDiscountAmount[stageCount][volumeCount]#" cfsqltype="cf_sql_money">,
							<cfqueryparam Value="#Arguments.priceVolumeDiscountIsTotalPrice[stageCount][volumeCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
						);
					</cfloop>
				</cfquery>
			</cfloop>
		</cfif>

		<cfif Arguments.priceAppliesToAllCustomers is 1>
			<cfset insertPriceTarget(priceID, 0, 0, Arguments.userID, 1, 0)>
		</cfif>
	</cftransaction>

	<cfreturn qry_insertPrice.primaryKeyID>
</cffunction>

<cffunction Name="updatePrice" Access="public" Output="No" ReturnType="boolean" Hint="Update Existing Price. Returns True.">
	<cfargument Name="priceID" Type="numeric" Required="Yes">
	<cfargument Name="priceStatus" Type="numeric" Required="No">
	<cfargument Name="priceApproved" Type="numeric" Required="No">
	<cfargument Name="priceDateApproved" Type="string" Required="No">
	<cfargument Name="userID_approved" Type="numeric" Required="No">
	<cfargument Name="priceAppliedStatus" Type="numeric" Required="No">
	<cfargument Name="priceIsParent" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Price" method="maxlength_Price" returnVariable="maxlength_Price" />

	<cfquery Name="qry_updatePrice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avPrice
		SET
			<cfif StructKeyExists(Arguments, "priceStatus") and ListFind("0,1", Arguments.priceStatus)>priceStatus = <cfqueryparam Value="#Arguments.priceStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "priceApproved") and ListFind("0,1", Arguments.priceApproved)>priceApproved = <cfqueryparam Value="#Arguments.priceApproved#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "priceDateApproved")>priceDateApproved = <cfif Not IsDate(Arguments.priceDateApproved)>NULL<cfelse><cfqueryparam Value="#Arguments.priceDateApproved#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "userID_approved") and Application.fn_IsIntegerNonNegative(Arguments.userID_approved)>userID_approved = <cfqueryparam Value="#Arguments.userID_approved#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "priceAppliedStatus") and ListFind("0,1", Arguments.priceAppliedStatus)>priceAppliedStatus = <cfqueryparam Value="#Arguments.priceAppliedStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "priceIsParent") and ListFind("0,1", Arguments.priceIsParent)>priceIsParent = <cfqueryparam Value="#Arguments.priceIsParent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			priceDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE priceID = <cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkPricePermission" Access="public" Output="No" ReturnType="boolean" Hint="Check Price Permission for Company">
	<cfargument Name="priceID" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">

	<cfset var qry_checkPricePermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.priceID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkPricePermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT priceID
			FROM avPrice
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND priceID IN (<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerNonNegative(Arguments.categoryID)>
					AND categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerNonNegative(Arguments.productID)>
					AND productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				</cfif>
		</cfquery>

		<cfif qry_checkPricePermission.RecordCount is 0 or qry_checkPricePermission.RecordCount is not ListLen(Arguments.priceID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectPrice" Access="public" Output="No" ReturnType="query" Hint="Select Existing Price">
	<cfargument Name="priceID" Type="string" Required="Yes">

	<cfset var qry_selectPrice = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.priceID)>
		<cfset Arguments.priceID = 0>
	</cfif>

	<cfquery Name="qry_selectPrice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avPrice.priceID, avPrice.companyID, avPrice.categoryID, avPrice.productID,
			avPrice.priceAppliesToCategory, avPrice.priceAppliesToCategoryChildren,
			avPrice.priceAppliesToProduct, avPrice.priceAppliesToProductChildren,
			avPrice.priceAppliesToAllProducts, avPrice.priceAppliesToAllCustomers,
			avPrice.priceAppliesToInvoice, avPrice.priceCode, avPrice.priceCodeRequired,
			avPrice.userID, avPrice.priceApproved, avPrice.priceDateApproved, avPrice.userID_approved,
			avPrice.priceStatus, avPrice.priceName, avPrice.priceDescription, avPrice.priceAppliedStatus,
			avPrice.priceQuantityMinimumPerOrder, avPrice.priceQuantityMaximumAllCustomers,
			avPrice.priceQuantityMaximumPerCustomer, avPrice.priceBillingMethod, avPrice.priceID_custom,
			avPrice.priceDateBegin, avPrice.priceDateEnd, avPrice.priceID_parent, avPrice.priceID_trend,
			avPrice.priceHasMultipleStages, avPrice.priceDateCreated, avPrice.priceDateUpdated,
			avPriceStage.priceStageID, avPriceStage.priceStageOrder, avPriceStage.priceStageAmount,
			avPriceStage.priceStageDollarOrPercent, avPriceStage.priceStageNewOrDeduction,
			avPriceStage.priceStageVolumeDiscount, avPriceStage.priceStageVolumeDollarOrQuantity,
			avPriceStage.priceStageVolumeStep, avPriceStage.priceStageInterval, avPriceStage.priceStageIntervalType,
			avPriceStage.priceStageText, avPriceStage.priceStageDescription
		FROM avPrice, avPriceStage
		WHERE avPrice.priceID = avPriceStage.priceID
			AND avPrice.priceID IN (<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		ORDER BY avPriceStage.priceID, avPriceStage.priceStageOrder
	</cfquery>

	<cfreturn qry_selectPrice>
</cffunction>

<cffunction Name="selectPriceIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects price of existing company via custom ID and returns priceID if exists, 0 if not exists, and -1 if multiple companies have the same priceID_custom.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="priceID_custom" Type="string" Required="Yes">

	<cfset var qry_selectPriceIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectPriceIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT priceID
		FROM avPrice
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND priceID_custom IN (<cfqueryparam Value="#Arguments.priceID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectPriceIDViaCustomID.RecordCount is 0 or qry_selectPriceIDViaCustomID.RecordCount lt ListLen(Arguments.priceID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectPriceIDViaCustomID.RecordCount gt ListLen(Arguments.priceID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectPriceIDViaCustomID.priceID)>
	</cfif>
</cffunction>

<!--- functions for viewing list of prices --->
<cffunction Name="selectPriceList" Access="public" ReturnType="query" Hint="Select list of prices">
	<cfargument Name="companyID_author" Type="string" Required="No">
	<cfargument Name="priceSearchText" Type="string" Required="No">
	<cfargument Name="priceSearchField" Type="string" Required="No">
	<cfargument Name="productSearchText" Type="string" Required="No">
	<cfargument Name="productSearchField" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="categoryID_sub" Type="numeric" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceID_parent" Type="string" Required="No">
	<cfargument Name="priceID_trend" Type="string" Required="No">
	<cfargument Name="priceDateType" Type="string" Required="No">
	<cfargument Name="priceDateFrom" Type="string" Required="No">
	<cfargument Name="priceDateTo" Type="string" Required="No">
	<cfargument Name="priceStageInterval_min" Type="numeric" Required="No">
	<cfargument Name="priceStageInterval_max" Type="numeric" Required="No">
	<cfargument Name="priceStageIntervalType" Type="string" Required="No">
	<cfargument Name="priceStageDollarOrPercent_priceStageNewOrDeduction" Type="string" Required="No">
	<cfargument Name="priceStatus" Type="numeric" Required="No">
	<cfargument Name="priceAppliedStatus" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToCategory" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToCategoryChildren" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToProduct" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToProductChildren" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToAllProducts" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToInvoice" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToAllCustomers" Type="numeric" Required="No">
	<cfargument Name="priceHasMultipleStages" Type="numeric" Required="No">
	<cfargument Name="priceHasCode" Type="numeric" Required="No">
	<cfargument Name="priceCodeRequired" Type="numeric" Required="No">
	<cfargument Name="priceHasCustomID" Type="numeric" Required="No">
	<cfargument Name="priceBeforeBeginDate" Type="numeric" Required="No">
	<cfargument Name="priceHasEndDate" Type="numeric" Required="No">
	<cfargument Name="priceStageVolumeDiscount" Type="numeric" Required="No">
	<cfargument Name="priceStageVolumeDollarOrQuantity" Type="numeric" Required="No">
	<cfargument Name="priceStageVolumeStep" Type="numeric" Required="No">
	<cfargument Name="priceAppliedToSubscription" Type="numeric" Required="No">
	<cfargument Name="priceHasQuantityMinimumPerOrder" Type="numeric" Required="No">
	<cfargument Name="priceHasQuantityMaximumPerCustomer" Type="numeric" Required="No">
	<cfargument Name="priceHasQuantityMaximumAllCustomers" Type="numeric" Required="No">
	<cfargument Name="priceIsParent" Type="numeric" Required="No">
	<cfargument Name="priceHasGroupTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasRegionTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasAffiliateTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasCobrandTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasCompanyTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasUserTarget" Type="numeric" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="no" default="priceID">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">

	<cfset var queryParameters_orderBy = "avPrice.priceID">
	<cfset var queryParameters_orderBy_noTable = "priceID">
	<cfset var dateClause = "">
	<cfset var displayAnd = True>
	<cfset var priceTargetQueryBegin = "">
	<cfset var fieldID = "">
	<cfset var qry_selectPriceList = QueryNew("blank")>

	<cfswitch expression="#Arguments.queryOrderBy#">
	<cfcase value="priceID,userID,priceStatus,priceName,priceDateBegin,priceDateEnd,priceDateUpdated,priceCode"><cfset queryParameters_orderBy = "avPrice.#Arguments.queryOrderBy#"></cfcase>
	<cfcase value="priceID_d,userID_d,priceStatus_d,priceName_d,priceDateBegin_d,priceDateEnd_d,priceDateUpdated_d,priceCode_d"><cfset queryParameters_orderBy = "avPrice.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	<cfcase value="priceDateCreated"><cfset queryParameters_orderBy = "avPrice.priceID"></cfcase>
	<cfcase value="priceDateCreated_d"><cfset queryParameters_orderBy = "avPrice.priceID DESC"></cfcase>
	<cfcase value="priceID_trend"><cfset queryParameters_orderBy = "avPrice.priceID_trend"></cfcase>
	<cfcase value="priceID_trend_d"><cfset queryParameters_orderBy = "avPrice.priceID_trend_d DESC"></cfcase>
	<cfcase value="priceID_custom"><cfset queryParameters_orderBy = "avPrice.priceID_custom"></cfcase>
	<cfcase value="priceID_custom_d"><cfset queryParameters_orderBy = "avPrice.priceID_custom DESC"></cfcase>
	<cfcase value="categoryName"><cfset queryParameters_orderBy = "avCategory.categoryName"></cfcase>
	<cfcase value="categoryName_d"><cfset queryParameters_orderBy = "avCategory.categoryName DESC"></cfcase>
	<cfcase value="productName"><cfset queryParameters_orderBy = "avProduct.productName"></cfcase>
	<cfcase value="productName_d"><cfset queryParameters_orderBy = "avProduct.productName DESC"></cfcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avPrice,avCategory,avProduct">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectPriceList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avPrice.priceID, avPrice.companyID, avPrice.categoryID, avPrice.productID,
			avPrice.priceAppliesToCategory, avPrice.priceAppliesToCategoryChildren,
			avPrice.priceAppliesToProduct, avPrice.priceAppliesToProductChildren,
			avPrice.priceAppliesToAllProducts, avPrice.priceAppliesToAllCustomers,
			avPrice.priceAppliesToInvoice, avPrice.priceCode, avPrice.priceCodeRequired,
			avPrice.userID, avPrice.priceApproved, avPrice.priceDateApproved, avPrice.userID_approved,
			avPrice.priceStatus, avPrice.priceName, avPrice.priceDescription, avPrice.priceAppliedStatus,
			avPrice.priceQuantityMinimumPerOrder, avPrice.priceQuantityMaximumAllCustomers,
			avPrice.priceQuantityMaximumPerCustomer, avPrice.priceBillingMethod, avPrice.priceID_custom,
			avPrice.priceDateBegin, avPrice.priceDateEnd, avPrice.priceID_parent, avPrice.priceID_trend,
			avPrice.priceHasMultipleStages, avPrice.priceDateCreated, avPrice.priceDateUpdated,
			avPriceStage.priceStageID, avPriceStage.priceStageOrder, avPriceStage.priceStageAmount,
			avPriceStage.priceStageDollarOrPercent, avPriceStage.priceStageNewOrDeduction,
			avPriceStage.priceStageVolumeDiscount, avPriceStage.priceStageVolumeDollarOrQuantity,
			avPriceStage.priceStageVolumeStep, avPriceStage.priceStageInterval, avPriceStage.priceStageIntervalType,
			avPriceStage.priceStageText, avPriceStage.priceStageDescription,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom,
			avCategory.categoryName,
			avProduct.productName, avProduct.productPrice, avProduct.vendorID
		FROM avPrice INNER JOIN avPriceStage ON avPrice.priceID = avPriceStage.priceID
			LEFT OUTER JOIN avUser ON avPrice.userID = avUser.userID
			LEFT OUTER JOIN avCategory ON avPrice.categoryID = avCategory.categoryID
			LEFT OUTER JOIN avProduct ON avPrice.productID = avProduct.productID
		WHERE avPrice.priceID IN 
			(
			SELECT avPrice.priceID
			FROM avPrice INNER JOIN avPriceStage ON avPrice.priceID = avPriceStage.priceID
				<cfif StructKeyExists(Arguments, "productID") or StructKeyExists(Arguments, "vendorID") or StructKeyExists(Arguments, "productSearchText")>
					LEFT OUTER JOIN avProduct ON avPrice.productID = avProduct.productID
				</cfif>
			WHERE 
				<cfinclude template="dataShared/qryWhere_selectPriceList.cfm">
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

	<cfreturn qry_selectPriceList>
</cffunction>

<cffunction Name="selectPriceCount" Access="public" ReturnType="numeric" Hint="Select total number of prices in list">
	<cfargument Name="companyID_author" Type="string" Required="No">
	<cfargument Name="priceSearchText" Type="string" Required="No">
	<cfargument Name="priceSearchField" Type="string" Required="No">
	<cfargument Name="productSearchText" Type="string" Required="No">
	<cfargument Name="productSearchField" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<cfargument Name="categoryID_sub" Type="numeric" Required="No">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">
	<cfargument Name="priceID_parent" Type="string" Required="No">
	<cfargument Name="priceID_trend" Type="string" Required="No">
	<cfargument Name="priceDateType" Type="string" Required="No">
	<cfargument Name="priceDateFrom" Type="string" Required="No">
	<cfargument Name="priceDateTo" Type="string" Required="No">
	<cfargument Name="priceStageInterval_min" Type="numeric" Required="No">
	<cfargument Name="priceStageInterval_max" Type="numeric" Required="No">
	<cfargument Name="priceStageIntervalType" Type="string" Required="No">
	<cfargument Name="priceStageDollarOrPercent_priceStageNewOrDeduction" Type="string" Required="No">
	<cfargument Name="priceStatus" Type="numeric" Required="No">
	<cfargument Name="priceAppliedStatus" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToCategory" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToCategoryChildren" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToProduct" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToProductChildren" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToAllProducts" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToInvoice" Type="numeric" Required="No">
	<cfargument Name="priceAppliesToAllCustomers" Type="numeric" Required="No">
	<cfargument Name="priceHasMultipleStages" Type="numeric" Required="No">
	<cfargument Name="priceHasCode" Type="numeric" Required="No">
	<cfargument Name="priceCodeRequired" Type="numeric" Required="No">
	<cfargument Name="priceHasCustomID" Type="numeric" Required="No">
	<cfargument Name="priceBeforeBeginDate" Type="numeric" Required="No">
	<cfargument Name="priceHasEndDate" Type="numeric" Required="No">
	<cfargument Name="priceStageVolumeDiscount" Type="numeric" Required="No">
	<cfargument Name="priceStageVolumeDollarOrQuantity" Type="numeric" Required="No">
	<cfargument Name="priceStageVolumeStep" Type="numeric" Required="No">
	<cfargument Name="priceAppliedToSubscription" Type="numeric" Required="No">
	<cfargument Name="priceHasQuantityMinimumPerOrder" Type="numeric" Required="No">
	<cfargument Name="priceHasQuantityMaximumPerCustomer" Type="numeric" Required="No">
	<cfargument Name="priceHasQuantityMaximumAllCustomers" Type="numeric" Required="No">
	<cfargument Name="priceIsParent" Type="numeric" Required="No">
	<cfargument Name="priceHasGroupTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasRegionTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasAffiliateTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasCobrandTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasCompanyTarget" Type="numeric" Required="No">
	<cfargument Name="priceHasUserTarget" Type="numeric" Required="No">

	<cfset var dateClause = "">
	<cfset var displayAnd = True>
	<cfset var priceTargetQueryBegin = "">
	<cfset var fieldID = "">
	<cfset var qry_selectPriceCount = QueryNew("blank")>

	<cfquery Name="qry_selectPriceCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avPrice.priceID) AS totalRecords
		FROM avPrice
		WHERE avPrice.priceID IN 
			(
			SELECT avPrice.priceID
			FROM avPrice INNER JOIN avPriceStage ON avPrice.priceID = avPriceStage.priceID
				<cfif StructKeyExists(Arguments, "productID") or StructKeyExists(Arguments, "vendorID") or StructKeyExists(Arguments, "productSearchText")>
					LEFT OUTER JOIN avProduct ON avPrice.productID = avProduct.productID
				</cfif>
			WHERE 
				<cfinclude template="dataShared/qryWhere_selectPriceList.cfm">
			)
	</cfquery>

	<cfreturn qry_selectPriceCount.totalRecords>
</cffunction>
<!--- /functions for viewing list of prices --->

<cffunction Name="selectSumInvoiceLineItemQuantityAtPrice" Access="public" Output="No" ReturnType="query" Hint="Select total quantity of products invoiced at a given custom price">
	<cfargument Name="priceID" Type="string" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="companyID" Type="numeric" Required="No">

	<cfset var qry_selectSumInvoiceLineItemQuantityAtPrice = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.priceID)>
		<cfset Arguments.priceID = -1>
	</cfif>

	<cfquery Name="qry_selectSumInvoiceLineItemQuantityAtPrice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avInvoiceLineItem.priceID, SUM(avInvoiceLineItem.invoiceLineItemQuantity) AS sumInvoiceLineItemQuantity
		FROM avInvoiceLineItem, avInvoice
		WHERE avInvoiceLineItem.invoiceID = avInvoice.invoiceID
			AND avInvoiceLineItem.invoiceLineItemStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			AND avInvoiceLineItem.priceID IN (<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerPositive(Arguments.companyID)
					and StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerPositive(Arguments.userID)>
				AND (
					avInvoice.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
					OR
					avInvoice.userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
					)
			<cfelseif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerPositive(Arguments.companyID)>
				AND avInvoice.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfelseif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerPositive(Arguments.userID)>
				AND avInvoice.userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">
			</cfif>
		GROUP BY avInvoiceLineItem.priceID
	</cfquery>

	<cfreturn qry_selectSumInvoiceLineItemQuantityAtPrice>
</cffunction>

<cffunction Name="selectSubscriptionPriceCount" Access="public" Output="No" ReturnType="numeric" Hint="Select number of active subscriptions using a particular price">
	<cfargument Name="priceID" Type="numeric" Required="Yes">
	<cfargument Name="subscriptionStatus" Type="numeric" Required="No">
	<cfargument Name="subscriberStatus" Type="numeric" Required="No">

	<cfset var qry_selectSubscriptionPriceCount = QueryNew("blank")>

	<cfquery Name="qry_selectSubscriptionPriceCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(avSubscription.priceID) AS subscriptionCount
		FROM avSubscriber, avSubscription
		WHERE avSubscriber.subscriberID = avSubscription.subscriptionID
			AND avSubscription.priceID = <cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "subscriptionStatus") and ListFind("0,1", Arguments.subscriptionStatus)>
				AND avSubscription.subscriptionStatus = <cfqueryparam Value="#Arguments.subscriptionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "subscriberStatus") and ListFind("0,1", Arguments.subscriberStatus)>
				AND avSubscriber.subscriberStatus = <cfqueryparam Value="#Arguments.subscriberStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
	</cfquery>

	<cfreturn qry_selectSubscriptionPriceCount.subscriptionCount>
</cffunction>

</cfcomponent>
