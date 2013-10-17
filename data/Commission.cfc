<cfcomponent DisplayName="Commission" Hint="Manages inserting, updating, deleting and viewing commissions">

<cffunction name="maxlength_Commission" access="public" output="no" returnType="struct">
	<cfset var maxlength_Commission = StructNew()>

	<cfset maxlength_Commission.commissionID_custom = 25>
	<cfset maxlength_Commission.commissionName = 255>
	<cfset maxlength_Commission.commissionDescription = 255>
	<cfset maxlength_Commission.commissionPeriodIntervalType = 5>

	<cfreturn maxlength_Commission>
</cffunction>

<cffunction name="maxlength_CommissionStage" access="public" output="no" returnType="struct">
	<cfset var maxlength_CommissionStage = StructNew()>

	<cfset maxlength_CommissionStage.commissionStageAmount = 4>
	<cfset maxlength_CommissionStage.commissionStageIntervalType = 5>
	<cfset maxlength_CommissionStage.commissionStageText = 255>
	<cfset maxlength_CommissionStage.commissionStageDescription = 255>
	<cfset maxlength_CommissionStage.commissionStageAmountMinimum = 2>
	<cfset maxlength_CommissionStage.commissionStageAmountMaximum = 2>

	<cfreturn maxlength_CommissionStage>
</cffunction>

<cffunction name="maxlength_CommissionVolumeDiscount" access="public" output="no" returnType="struct">
	<cfset var maxlength_CommissionVolumeDiscount = StructNew()>

	<cfset maxlength_CommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum = 4>
	<cfset maxlength_CommissionVolumeDiscount.commissionVolumeDiscountAmount = 4>

	<cfreturn maxlength_CommissionVolumeDiscount>
</cffunction>

<cffunction Name="insertCommission" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new commission. Returns commissionID.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="commissionName" Type="string" Required="No" Default="">
	<cfargument Name="commissionID_custom" Type="string" Required="No" Default="">
	<cfargument Name="commissionStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="commissionAppliesToExistingProducts" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionAppliesToCustomProducts" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionAppliesToInvoice" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionAppliedStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionPeriodOrInvoiceBased" Type="string" Required="No" Default="0">
	<cfargument Name="commissionPeriodIntervalType" Type="string" Required="No" Default="">
	<cfargument Name="commissionDateBegin" Type="date" Required="No" Default="#Now()#">
	<cfargument Name="commissionDateEnd" Type="string" Required="No" Default="">
	<cfargument Name="commissionID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionID_trend" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionIsParent" Type="numeric" Required="No" Default="0">
	<cfargument Name="commissionDescription" Type="string" Required="No" Default="">
	<cfargument Name="commissionStageAmount" Type="array" Required="Yes">
	<cfargument Name="commissionStageDollarOrPercent" Type="array" Required="Yes">
	<cfargument Name="commissionStageAmountMinimum" Type="array" Required="Yes">
	<cfargument Name="commissionStageAmountMaximum" Type="array" Required="Yes">
	<cfargument Name="commissionStageVolumeDiscount" Type="array" Required="Yes">
	<cfargument Name="commissionStageVolumeDollarOrQuantity" Type="array" Required="Yes">
	<cfargument Name="commissionStageVolumeStep" Type="array" Required="Yes">
	<cfargument Name="commissionStageInterval" Type="array" Required="Yes">
	<cfargument Name="commissionStageIntervalType" Type="array" Required="Yes">
	<cfargument Name="commissionStageText" Type="array" Required="Yes">
	<cfargument Name="commissionStageDescription" Type="array" Required="Yes">
	<cfargument Name="commissionVolumeDiscountQuantityMinimum" Type="array" Required="Yes">
	<cfargument Name="commissionVolumeDiscountAmount" Type="array" Required="Yes">
	<cfargument Name="commissionVolumeDiscountIsTotalCommission" Type="array" Required="Yes">

	<cfset var commissionHasMultipleStages = 0>
	<cfset var commissionID = 0>
	<cfset var qry_insertCommission = QueryNew("blank")>
	<cfset var isVolumeDiscount = False>
	<cfset var qry_selectCommissionStageID = QueryNew("blank")>
	<cfset var stageCount = 0>
	<cfset var thisCommissionStageID = 0>

	<cfinvoke component="#Application.billingMapping#data.Commission" method="maxlength_Commission" returnVariable="maxlength_Commission" />
	<cfinvoke component="#Application.billingMapping#data.Commission" method="maxlength_CommissionStage" returnVariable="maxlength_CommissionStage" />
	<cfinvoke component="#Application.billingMapping#data.Commission" method="maxlength_CommissionVolumeDiscount" returnVariable="maxlength_CommissionVolumeDiscount" />

	<cfif ArrayLen(Arguments.commissionStageAmount) gt 1>
		<cfset commissionHasMultipleStages = 1>
	<cfelse>
		<cfset commissionHasMultipleStages = 0>
	</cfif>

	<cftransaction>
	<cfquery Name="qry_insertCommission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCommission
		(
			companyID, userID, commissionName, commissionID_custom, commissionStatus, commissionAppliesToExistingProducts,
			commissionAppliesToCustomProducts, commissionAppliesToInvoice, commissionAppliedStatus, commissionPeriodOrInvoiceBased,
			commissionPeriodIntervalType, commissionDateBegin, commissionDateEnd, commissionID_parent, commissionID_trend,
			commissionIsParent, commissionHasMultipleStages, commissionDescription, commissionDateCreated, commissionDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Commission.commissionName#">,
			<cfqueryparam Value="#Arguments.commissionID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Commission.commissionID_custom#">,
			<cfqueryparam Value="#Arguments.commissionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionAppliesToExistingProducts#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionAppliesToCustomProducts#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionAppliesToInvoice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionAppliedStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionPeriodOrInvoiceBased#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionPeriodIntervalType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Commission.commissionPeriodIntervalType#">,
			<cfif Not StructKeyExists(Arguments, "commissionDateBegin") or Not IsDate(Arguments.commissionDateBegin)>#Application.billingSql.sql_nowDateTime#<cfelse><cfqueryparam Value="#Arguments.commissionDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not StructKeyExists(Arguments, "commissionDateEnd") or Not IsDate(Arguments.commissionDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.commissionDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.commissionID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionID_trend#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.commissionIsParent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#commissionHasMultipleStages#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.commissionDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Commission.commissionDescription#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "commissionID", "ALL")#;
	</cfquery>

	<cfif Arguments.commissionID_trend is 0>
		<cfquery Name="qry_insertCommission_trend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avCommission
			SET commissionID_trend = commissionID
			WHERE commissionID = <cfqueryparam Value="#qry_insertCommission.primaryKeyID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>

	<cfset commissionID = qry_insertCommission.primaryKeyID>
	<cfset isVolumeDiscount = False>

	<cfquery Name="qry_insertCommissionStage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfloop Index="stageCount" From="1" To="#ArrayLen(Arguments.commissionStageAmount)#">
			INSERT INTO avCommissionStage
			(
				commissionID, commissionStageOrder, commissionStageAmount, commissionStageDollarOrPercent, commissionStageAmountMinimum,
				commissionStageAmountMaximum, commissionStageVolumeDiscount, commissionStageVolumeDollarOrQuantity, commissionStageVolumeStep,
				commissionStageInterval, commissionStageIntervalType, commissionStageText, commissionStageDescription
			)
			VALUES
			(
				<cfqueryparam Value="#commissionID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#stageCount#" cfsqltype="cf_sql_tinyint">,
				<cfqueryparam Value="#Arguments.commissionStageAmount[stageCount]#" cfsqltype="cf_sql_money">,
				<cfqueryparam Value="#Arguments.commissionStageDollarOrPercent[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.commissionStageAmountMinimum[stageCount]#" cfsqltype="cf_sql_money">,
				<cfqueryparam Value="#Arguments.commissionStageAmountMaximum[stageCount]#" cfsqltype="cf_sql_money">,
				<cfqueryparam Value="#Arguments.commissionStageVolumeDiscount[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.commissionStageVolumeDollarOrQuantity[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.commissionStageVolumeStep[stageCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="#Arguments.commissionStageInterval[stageCount]#" cfsqltype="cf_sql_smallint">,
				<cfqueryparam Value="#Arguments.commissionStageIntervalType[stageCount]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CommissionStage.commissionStageIntervalType#">,
				<cfqueryparam Value="#Arguments.commissionStageText[stageCount]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CommissionStage.commissionStageText#">,
				<cfqueryparam Value="#Arguments.commissionStageDescription[stageCount]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_CommissionStage.commissionStageDescription#">
			);

			<cfif Arguments.commissionStageVolumeDiscount[stageCount] is 1>
				<cfset isVolumeDiscount = True>
			</cfif>
		</cfloop>
	</cfquery>

	<cfif isVolumeDiscount is True>
		<cfquery Name="qry_selectCommissionStageID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT commissionStageID, commissionStageOrder
			FROM avCommissionStage
			WHERE commissionID = <cfqueryparam Value="#commissionID#" cfsqltype="cf_sql_integer">
				AND commissionStageVolumeDiscount = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfquery>

		<cfloop Query="qry_selectCommissionStageID">
			<cfset stageCount = qry_selectCommissionStageID.commissionStageOrder>
			<cfset thisCommissionStageID = qry_selectCommissionStageID.commissionStageID>

			<cfquery Name="qry_insertCommissionVolumeDiscount#stageCount#" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				<cfloop Index="volumeCount" From="1" To="#ArrayLen(Arguments.commissionVolumeDiscountAmount[stageCount])#">
					INSERT INTO avCommissionVolumeDiscount
					(
						commissionStageID, commissionVolumeDiscountQuantityMinimum, commissionVolumeDiscountQuantityIsMaximum,
						commissionVolumeDiscountAmount, commissionVolumeDiscountIsTotalCommission
					)
					VALUES
					(
						<cfqueryparam Value="#thisCommissionStageID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam Value="#Arguments.commissionVolumeDiscountQuantityMinimum[stageCount][volumeCount]#" cfsqltype="cf_sql_decimal" Scale="#maxlength_CommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum#">,
						<cfqueryparam Value="#Iif(volumeCount is ArrayLen(Arguments.commissionVolumeDiscountAmount[stageCount]), 1, 0)#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
						<cfqueryparam Value="#Arguments.commissionVolumeDiscountAmount[stageCount][volumeCount]#" cfsqltype="cf_sql_money">,
						<cfqueryparam Value="#Arguments.commissionVolumeDiscountIsTotalCommission[stageCount][volumeCount]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					);
				</cfloop>
			</cfquery>
		</cfloop>
	</cfif>
	</cftransaction>

	<cfreturn qry_insertCommission.primaryKeyID>
</cffunction>

<cffunction Name="updateCommission" Access="public" Output="No" ReturnType="boolean" Hint="Update existing commission. Returns True.">
	<cfargument Name="commissionID" Type="numeric" Required="Yes">
	<cfargument Name="commissionStatus" Type="numeric" Required="No">
	<cfargument Name="commissionAppliedStatus" Type="numeric" Required="No">
	<cfargument Name="commissionIsParent" Type="numeric" Required="No">

	<cfquery Name="qry_updateCommission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCommission
		SET
			<cfif StructKeyExists(Arguments, "commissionStatus") and ListFind("0,1", Arguments.commissionStatus)>commissionStatus = <cfqueryparam Value="#Arguments.commissionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "commissionAppliedStatus") and ListFind("0,1", Arguments.commissionAppliedStatus)>commissionAppliedStatus = <cfqueryparam Value="#Arguments.commissionAppliedStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "commissionIsParent") and ListFind("0,1", Arguments.commissionIsParent)>commissionIsParent = <cfqueryparam Value="#Arguments.commissionIsParent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			commissionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE commissionID = <cfqueryparam Value="#Arguments.commissionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkCommissionPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check commission permission for company">
	<cfargument Name="commissionID" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_checkCommissionPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.commissionID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkCommissionPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT commissionID
			FROM avCommission
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND commissionID IN (<cfqueryparam Value="#Arguments.commissionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>

		<cfif qry_checkCommissionPermission.RecordCount is 0 or qry_checkCommissionPermission.RecordCount is not ListLen(Arguments.commissionID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectCommission" Access="public" Output="No" ReturnType="query" Hint="Select existing commission">
	<cfargument Name="commissionID" Type="string" Required="Yes">

	<cfset var qry_selectCommission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.commissionID)>
		<cfset Arguments.commissionID = 0>
	</cfif>

	<cfquery Name="qry_selectCommission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCommission.commissionID, avCommission.userID, avCommission.companyID,
			avCommission.commissionName, avCommission.commissionID_custom, avCommission.commissionStatus,
			avCommission.commissionAppliesToExistingProducts, avCommission.commissionAppliesToCustomProducts,
			avCommission.commissionAppliesToInvoice, avCommission.commissionAppliedStatus,
			avCommission.commissionDateBegin, avCommission.commissionDateEnd,
			avCommission.commissionPeriodOrInvoiceBased, avCommission.commissionPeriodIntervalType,
			avCommission.commissionID_parent, avCommission.commissionID_trend, avCommission.commissionIsParent,
			avCommission.commissionHasMultipleStages, avCommission.commissionDescription,
			avCommission.commissionDateCreated, avCommission.commissionDateUpdated,
			avCommissionStage.commissionStageID, avCommissionStage.commissionStageOrder, avCommissionStage.commissionStageAmount,
			avCommissionStage.commissionStageDollarOrPercent, avCommissionStage.commissionStageAmountMinimum,
			avCommissionStage.commissionStageAmountMaximum, avCommissionStage.commissionStageVolumeDiscount,
			avCommissionStage.commissionStageVolumeDollarOrQuantity, avCommissionStage.commissionStageVolumeStep,
			avCommissionStage.commissionStageInterval, avCommissionStage.commissionStageIntervalType,
			avCommissionStage.commissionStageText, avCommissionStage.commissionStageDescription
		FROM avCommission, avCommissionStage
		WHERE avCommission.commissionID = avCommissionStage.commissionID
			AND avCommission.commissionID IN (<cfqueryparam Value="#Arguments.commissionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		ORDER BY avCommissionStage.commissionID, avCommissionStage.commissionStageOrder
	</cfquery>

	<cfreturn qry_selectCommission>
</cffunction>

<cffunction Name="selectCommissionIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects commission of existing company via custom ID and returns commissionID if exists, 0 if not exists, and -1 if multiple companies have the same commissionID_custom.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="commissionID_custom" Type="string" Required="Yes">

	<cfset var qry_selectCommissionIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectCommissionIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT commissionID
		FROM avCommission
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND commissionID_custom IN (<cfqueryparam Value="#Arguments.commissionID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectCommissionIDViaCustomID.RecordCount is 0 or qry_selectCommissionIDViaCustomID.RecordCount lt ListLen(Arguments.commissionID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectCommissionIDViaCustomID.RecordCount gt ListLen(Arguments.commissionID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectCommissionIDViaCustomID.commissionID)>
	</cfif>
</cffunction>


<!--- functions for viewing list of commissions --->
<cffunction name="selectCommisisionList_getParentCategories" access="public" output="no" returnType="string">
	<cfargument name="categoryID" type="string" required="yes">

	<cfset var categoryID_parentList = "">

	<!--- if category, select commission plans for that category AND parent categories where sub-categories are included --->
	<cfif Arguments.categoryID is not 0 and Application.fn_IsIntegerList(Arguments.categoryID)>
		<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategory" ReturnVariable="qry_selectCategoryList">
			<cfinvokeargument Name="categoryID" Value="#Arguments.categoryID#">
		</cfinvoke>

		<cfloop Query="qry_selectCategoryList">
			<cfloop Index="catParentID" List="#qry_selectCategoryList.categoryID_parentList#">
				<cfif Not ListFind(categoryID_parentList, catParentID)>
					<cfset categoryID_parentList = ListAppend(categoryID_parentList, catParentID)>
				</cfif>
			</cfloop>
		</cfloop>
	</cfif>

	<cfreturn categoryID_parentList>
</cffunction>

<cffunction name="selectCommisisionList_getParentProducts" access="public" output="no" returnType="string">
	<cfargument name="productID" type="string" required="yes">

	<cfset var productID_parentList = "">

	<!--- if product, select commission plans for that product AND parent products where sub-products are included --->
	<cfif Arguments.productID is not 0 and Application.fn_IsIntegerList(Arguments.productID)>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProduct" ReturnVariable="qry_selectProductList">
			<cfinvokeargument Name="productID" Value="#Arguments.productID#">
		</cfinvoke>

		<cfloop Query="qry_selectProductList">
			<cfif qry_selectProductList.productID_parent is not 0 and Not ListFind(productID_parentList, qry_selectProductList.productID_parent)>
				<cfset productID_parentList = ListAppend(productID_parentList, qry_selectProductList.productID_parent)>
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn productID_parentList>
</cffunction>

<cffunction Name="selectCommissionList" Access="public" ReturnType="query" Hint="Select list of commission plans">
	<cfargument Name="companyID_author" Type="string" Required="No">
	<cfargument Name="commissionSearchText" Type="string" Required="No">
	<cfargument Name="commissionSearchField" Type="string" Required="No">
	<cfargument Name="productSearchText" Type="string" Required="No">
	<cfargument Name="productSearchField" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<!--- <cfargument Name="categoryID_sub" Type="numeric" Required="No"> --->
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="vendorID_product" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_parent" Type="string" Required="No">
	<cfargument Name="commissionID_trend" Type="string" Required="No">
	<cfargument Name="commissionDateType" Type="string" Required="No">
	<cfargument Name="commissionDateFrom" Type="string" Required="No">
	<cfargument Name="commissionDateTo" Type="string" Required="No">
	<cfargument Name="commissionPeriodOrInvoiceBased" Type="string" Required="No">
	<cfargument Name="commissionPeriodIntervalType" Type="string" Required="No">
	<cfargument Name="commissionStageInterval_min" Type="numeric" Required="No">
	<cfargument Name="commissionStageInterval_max" Type="numeric" Required="No">
	<cfargument Name="commissionStageIntervalType" Type="string" Required="No">
	<cfargument Name="commissionStageDollarOrPercent" Type="numeric" Required="No">
	<cfargument Name="commissionStatus" Type="numeric" Required="No">
	<cfargument Name="commissionAppliedStatus" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToCategory" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToCategoryChildren" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToProduct" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToProductChildren" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToExistingProducts" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToCustomProducts" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToInvoice" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllUsers" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllGroups" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllAffiliates" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllCobrands" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllCompanies" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllVendors" Type="numeric" Required="No">
	<cfargument Name="commissionHasMultipleStages" Type="numeric" Required="No">
	<cfargument Name="commissionHasCustomID" Type="numeric" Required="No">
	<cfargument Name="commissionBeforeBeginDate" Type="numeric" Required="No">
	<cfargument Name="commissionHasEndDate" Type="numeric" Required="No">
	<cfargument Name="commissionStageVolumeDiscount" Type="numeric" Required="No">
	<cfargument Name="commissionStageVolumeDollarOrQuantity" Type="numeric" Required="No">
	<cfargument Name="commissionStageVolumeStep" Type="numeric" Required="No">
	<cfargument Name="commissionIsParent" Type="numeric" Required="No">
	<cfargument Name="commissionHasGroupTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasAffiliateTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasCobrandTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasCompanyTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasUserTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasVendorTarget" Type="numeric" Required="No">

	<cfargument Name="queryOrderBy" Type="string" Required="no" default="commissionID">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">
	<cfargument Name="queryFirstLetter_field" Type="string" Required="No" Default="">

	<cfset var queryParameters_orderBy = "avCommission.commissionID">
	<cfset var queryParameters_orderBy_noTable = "commissionID">
	<cfset var qry_selectCommissionList = QueryNew("blank")>
	<cfset var dateClause = "">
	<cfset var displayAnd = True>
	<cfset var commissionTargetQueryBegin = "">
	<cfset var fieldID = "">

	<cfswitch expression="#Arguments.queryOrderBy#">
	 <cfcase value="commissionID,userID,commissionStatus,commissionName,commissionDateBegin,commissionDateEnd,commissionDateUpdated"><cfset queryParameters_orderBy = "avCommission.#Arguments.queryOrderBy#"></cfcase>
	 <cfcase value="commissionID_d,userID_d,commissionStatus_d,commissionName_d,commissionDateBegin_d,commissionDateEnd_d,commissionDateUpdated_d"><cfset queryParameters_orderBy = "avCommission.#ListFirst(Arguments.queryOrderBy, '_')# DESC"></cfcase>
	 <cfcase value="categoryName"><cfset queryParameters_orderBy = "avCategory.categoryName"></cfcase>
	 <cfcase value="categoryName_d"><cfset queryParameters_orderBy = "avCategory.categoryName DESC"></cfcase>
	 <cfcase value="productName"><cfset queryParameters_orderBy = "avProduct.productName"></cfcase>
	 <cfcase value="productName_d"><cfset queryParameters_orderBy = "avProduct.productName DESC"></cfcase>
	 <cfcase value="commissionDateCreated"><cfset queryParameters_orderBy = "avCommission.commissionID"></cfcase>
	 <cfcase value="commissionDateCreated_d"><cfset queryParameters_orderBy = "avCommission.commissionID DESC"></cfcase>
	 <cfcase value="commissionID_trend"><cfset queryParameters_orderBy = "avCommission.commissionID_trend, avCommission.commissionDateCreated"></cfcase>
	 <cfcase value="commissionID_trend_d"><cfset queryParameters_orderBy = "avCommission.commissionID_trend DESC, avCommission.commissionDateCreated DESC"></cfcase>
	 <cfcase value="commissionID_custom"><cfset queryParameters_orderBy = "avCommission.commissionID_custom"></cfcase>
	 <cfcase value="commissionID_custom_d"><cfset queryParameters_orderBy = "avCommission.commissionID_custom DESC"></cfcase>
	 <cfcase value="lastName"><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfcase>
	 <cfcase value="lastName_d"><cfset queryParameters_orderBy = "avUser.lastName DESC, avUser.firstName DESC"></cfcase>
	</cfswitch>

	<cfif Not ListFind("avCommission.commissionID,avCommission.commissionID DESC", queryParameters_orderBy)>
		<cfset queryParameters_orderBy &= ", avCommission.commissionID">
	</cfif>
	<cfset queryParameters_orderBy &= ", avCommissionStage.commissionStageOrder">

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCategory,avCommission,avProduct,avCommissionStage">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfif StructKeyExists(Arguments, "categoryID")>
		<cfinvoke component="#Application.billingMapping#data.Commission" method="selectCommisisionList_getParentCategories" returnVariable="categoryID_parentList">
			<cfinvokeargument name="categoryID" value="#Arguments.categoryID#">
		</cfinvoke>
	</cfif>

	<cfif StructKeyExists(Arguments, "productID")>
		<cfinvoke component="#Application.billingMapping#data.Commission" method="selectCommisisionList_getParentProducts" returnVariable="productID_parentList">
			<cfinvokeargument name="productID" value="#Arguments.productID#">
		</cfinvoke>
	</cfif>

	<cfquery Name="qry_selectCommissionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer">
				* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,
			</cfif>
			avCommission.commissionID, avCommission.userID, avCommission.companyID, avCommission.commissionName,
			avCommission.commissionID_custom, avCommission.commissionStatus, avCommission.commissionAppliesToExistingProducts,
			avCommission.commissionAppliesToCustomProducts, avCommission.commissionAppliesToInvoice, avCommission.commissionAppliedStatus,
			avCommission.commissionDateBegin, avCommission.commissionDateEnd,avCommission.commissionPeriodOrInvoiceBased,
			avCommission.commissionPeriodIntervalType, avCommission.commissionID_parent, avCommission.commissionID_trend,
			avCommission.commissionIsParent, avCommission.commissionHasMultipleStages, avCommission.commissionDescription,
			avCommission.commissionDateCreated, avCommission.commissionDateUpdated,
			avCommissionStage.commissionStageID, avCommissionStage.commissionStageOrder, avCommissionStage.commissionStageAmount,
			avCommissionStage.commissionStageDollarOrPercent, avCommissionStage.commissionStageAmountMinimum,
			avCommissionStage.commissionStageAmountMaximum, avCommissionStage.commissionStageVolumeDiscount,
			avCommissionStage.commissionStageVolumeDollarOrQuantity, avCommissionStage.commissionStageVolumeStep,
			avCommissionStage.commissionStageInterval, avCommissionStage.commissionStageIntervalType,
			avCommissionStage.commissionStageText, avCommissionStage.commissionStageDescription,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom
		FROM avCommission INNER JOIN avCommissionStage ON avCommission.commissionID = avCommissionStage.commissionID
			LEFT OUTER JOIN avUser ON avCommission.userID = avUser.userID
		WHERE avCommission.commissionID IN
			(
			SELECT avCommission.commissionID
			FROM avCommission INNER JOIN avCommissionStage ON avCommission.commissionID = avCommissionStage.commissionID
			WHERE 
				<cfinclude template="dataShared/qryWhere_selectCommissionList.cfm">
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

	<cfreturn qry_selectCommissionList>
</cffunction>

<cffunction Name="selectCommissionCount" Access="public" ReturnType="numeric" Hint="Select total number of commission plans in list">
	<cfargument Name="companyID_author" Type="string" Required="No">
	<cfargument Name="commissionSearchText" Type="string" Required="No">
	<cfargument Name="commissionSearchField" Type="string" Required="No">
	<cfargument Name="productSearchText" Type="string" Required="No">
	<cfargument Name="productSearchField" Type="string" Required="No">
	<cfargument Name="categoryID" Type="string" Required="No">
	<!--- <cfargument Name="categoryID_sub" Type="numeric" Required="No"> --->
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="productID" Type="string" Required="No">
	<cfargument Name="statusID" Type="string" Required="No">
	<cfargument Name="vendorID" Type="string" Required="No">
	<cfargument Name="vendorID_product" Type="string" Required="No">
	<cfargument Name="companyID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">
	<cfargument Name="commissionID_parent" Type="string" Required="No">
	<cfargument Name="commissionID_trend" Type="string" Required="No">
	<cfargument Name="commissionDateType" Type="string" Required="No">
	<cfargument Name="commissionDateFrom" Type="string" Required="No">
	<cfargument Name="commissionDateTo" Type="string" Required="No">
	<cfargument Name="commissionPeriodOrInvoiceBased" Type="string" Required="No">
	<cfargument Name="commissionPeriodIntervalType" Type="string" Required="No">
	<cfargument Name="commissionStageInterval_min" Type="numeric" Required="No">
	<cfargument Name="commissionStageInterval_max" Type="numeric" Required="No">
	<cfargument Name="commissionStageIntervalType" Type="string" Required="No">
	<cfargument Name="commissionStageDollarOrPercent" Type="numeric" Required="No">
	<cfargument Name="commissionStatus" Type="numeric" Required="No">
	<cfargument Name="commissionAppliedStatus" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToCategory" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToCategoryChildren" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToProduct" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToProductChildren" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToExistingProducts" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToCustomProducts" Type="numeric" Required="No">
	<cfargument Name="commissionAppliesToInvoice" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllUsers" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllGroups" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllAffiliates" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllCobrands" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllCompanies" Type="numeric" Required="No">
	<cfargument Name="commissionTargetsAllVendors" Type="numeric" Required="No">
	<cfargument Name="commissionHasMultipleStages" Type="numeric" Required="No">
	<cfargument Name="commissionHasCustomID" Type="numeric" Required="No">
	<cfargument Name="commissionBeforeBeginDate" Type="numeric" Required="No">
	<cfargument Name="commissionHasEndDate" Type="numeric" Required="No">
	<cfargument Name="commissionStageVolumeDiscount" Type="numeric" Required="No">
	<cfargument Name="commissionStageVolumeDollarOrQuantity" Type="numeric" Required="No">
	<cfargument Name="commissionStageVolumeStep" Type="numeric" Required="No">
	<cfargument Name="commissionIsParent" Type="numeric" Required="No">
	<cfargument Name="commissionHasGroupTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasAffiliateTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasCobrandTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasCompanyTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasUserTarget" Type="numeric" Required="No">
	<cfargument Name="commissionHasVendorTarget" Type="numeric" Required="No">

	<cfset var qry_selectCommissionCount = QueryNew("blank")>
	<cfset var dateClause = "">
	<cfset var displayAnd = True>
	<cfset var commissionTargetQueryBegin = "">
	<cfset var fieldID = "">

	<cfif StructKeyExists(Arguments, "categoryID")>
		<cfinvoke component="#Application.billingMapping#data.Commission" method="selectCommisisionList_getParentCategories" returnVariable="categoryID_parentList">
			<cfinvokeargument name="categoryID" value="#Arguments.categoryID#">
		</cfinvoke>
	</cfif>

	<cfif StructKeyExists(Arguments, "productID")>
		<cfinvoke component="#Application.billingMapping#data.Commission" method="selectCommisisionList_getParentProducts" returnVariable="productID_parentList">
			<cfinvokeargument name="productID" value="#Arguments.productID#">
		</cfinvoke>
	</cfif>

	<cfquery Name="qry_selectCommissionCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(avCommission.commissionID) AS totalRecords
		FROM avCommission
		WHERE avCommission.commissionID IN 
			(
			SELECT avCommission.commissionID
			FROM avCommission INNER JOIN avCommissionStage ON avCommission.commissionID = avCommissionStage.commissionID
			WHERE 
				<cfinclude template="dataShared/qryWhere_selectCommissionList.cfm">
			)
	</cfquery>

	<cfreturn qry_selectCommissionCount.totalRecords>
</cffunction>
<!--- /functions for viewing list of commissions --->


<cffunction Name="selectCommissionVolumeDiscount" Access="public" Output="No" ReturnType="query" Hint="Select existing commission volume discount">
	<cfargument Name="commissionStageID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="string" Required="No">

	<cfset var qry_selectCommissionVolumeDiscount = QueryNew("blank")>

	<cfif Not StructKeyExists(Arguments, "commissionStageID") and Not StructKeyExists(Arguments, "commissionID")>
		<cfset Arguments.commissionStageID = 0>
	<cfelseif StructKeyExists(Arguments, "commissionStageID") and Not Application.fn_IsIntegerList(Arguments.commissionStageID)>
		<cfset Arguments.commissionStageID = 0>
	<cfelseif StructKeyExists(Arguments, "commissionID") and Not Application.fn_IsIntegerList(Arguments.commissionID)>
		<cfset Arguments.commissionStageID = 0>
	</cfif>

	<cfquery Name="qry_selectCommissionVolumeDiscount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT commissionVolumeDiscountID, commissionStageID, commissionVolumeDiscountQuantityMinimum,
			commissionVolumeDiscountQuantityIsMaximum, commissionVolumeDiscountAmount, commissionVolumeDiscountIsTotalCommission
		FROM avCommissionVolumeDiscount
		WHERE 
			<cfif StructKeyExists(Arguments, "commissionStageID")>
				commissionStageID IN (<cfqueryparam Value="#Arguments.commissionStageID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfelse>
				commissionStageID IN (SELECT commissionStageID FROM avCommissionStage WHERE commissionID IN (<cfqueryparam Value="#Arguments.commissionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">))
			</cfif>
		ORDER BY commissionStageID, commissionVolumeDiscountQuantityIsMaximum, commissionVolumeDiscountQuantityMinimum
	</cfquery>

	<cfreturn qry_selectCommissionVolumeDiscount>
</cffunction>

</cfcomponent>
