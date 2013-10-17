<cfcomponent DisplayName="Category" Hint="Manages creating, updating, viewing and managing product categories">

<cffunction name="maxlength_Category" access="public" output="no" returnType="struct">
	<cfset var maxlength_Category = StructNew()>

	<cfset maxlength_Category.categoryCode = 50>
	<cfset maxlength_Category.categoryName = 255>
	<cfset maxlength_Category.categoryDescription = 255>
	<cfset maxlength_Category.categoryTitle = 255>
	<cfset maxlength_Category.categoryID_parentList = 500>
	<cfset maxlength_Category.templateFilename = 50>

	<cfreturn maxlength_Category>
</cffunction>

<cffunction Name="insertCategory" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new category into database and returns categoryID">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="categoryCode" Type="string" Required="No" Default="">
	<cfargument Name="categoryName" Type="string" Required="Yes">
	<cfargument Name="categoryDescription" Type="string" Required="No" Default="">
	<cfargument Name="categoryTitle" Type="string" Required="No" Default="">
	<!--- <cfargument Name="categoryOrder" Type="numeric" Required="Yes"> --->
	<cfargument Name="categoryOrder_manual" Type="numeric" Required="Yes">
	<cfargument Name="categoryStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="categoryID_parent" Type="numeric" Required="No" Default="0">
	<!--- <cfargument Name="categoryID_parentList" Type="string" Required="No" Default=""> --->
	<!--- <cfargument Name="categoryLevel" Type="numeric" Required="No" Default="1"> --->
	<cfargument Name="categoryHasChildren" Type="numeric" Required="No" Default="0">
	<cfargument Name="categoryAcceptListing" Type="numeric" Required="No" Default="1">
	<cfargument Name="categoryIsListed" Type="numeric" Required="No" Default="1">
	<cfargument Name="categoryHasCustomPrice" Type="numeric" Required="No" Default="0">
	<cfargument Name="categoryViewCount" Type="numeric" Required="No" Default="0">
	<cfargument Name="categoryItemsPerPage" Type="numeric" Required="No" Default="10">
	<cfargument Name="categoryNumberOfPages" Type="numeric" Required="No" Default="0">
	<cfargument Name="headerFooterID_header" Type="numeric" Required="No" Default="0">
	<cfargument Name="headerFooterID_footer" Type="numeric" Required="No" Default="0">
	<cfargument Name="templateFilename" Type="string" Required="No" Default="">

	<cfset var qry_insertCategory = QueryNew("blank")>
	<cfset var qry_selectCategoryList = selectCategoryList(Arguments.companyID)>
	<cfset var categoryID = 0>
	<cfset var categoryLevel = 1>
	<cfset var categoryID_parentList = "">
	<cfset var categoryOrder = qry_selectCategoryList.RecordCount + 1>
	<cfset var categoryParentRow = 0>
	<cfset var categoryParentRowCount = 0>
	<cfset var parentRowCounter = 0>
	<cfset var lastParentOrder = 0>

	<cfif Arguments.categoryID_parent is 0><!--- main category --->
		<cfset categoryLevel = 1>
		<cfset categoryID_parentList = "">
		<cfset categoryOrder = qry_selectCategoryList.RecordCount + 1>

		<cfloop Query="qry_selectCategoryList">
			<cfif Arguments.categoryName lt qry_selectCategoryList.categoryName and qry_selectCategoryList.categoryID is not categoryID>
				<cfset categoryOrder = qry_selectCategoryList.categoryOrder>
				<cfbreak>
			</cfif>
		</cfloop>

	<cfelse><!--- subcategory --->
		<cfset categoryParentRow = ListFind(ValueList(qry_selectCategoryList.categoryID), Arguments.categoryID_parent)>
		<cfset categoryParentRowCount = ListFind(ValueList(qry_selectCategoryList.categoryID_parent), Arguments.categoryID_parent)>
		<cfset categoryLevel = qry_selectCategoryList.categoryLevel[categoryParentRow] + 1>
		<cfset categoryOrder = qry_selectCategoryList.categoryOrder[categoryParentRow] + 1>

		<cfif categoryParentRowCount gt 0>
			<cfset parentRowCounter = 0>
			<cfloop Query="qry_selectCategoryList" StartRow="#IncrementValue(categoryParentRow)#">
				<cfif qry_selectCategoryList.categoryID_parent is Arguments.categoryID_parent and qry_selectCategoryList.categoryID is not categoryID>
					<cfif Arguments.categoryName lt qry_selectCategoryList.categoryName>
						<cfset categoryOrder = qry_selectCategoryList.categoryOrder>
						<cfset lastParentOrder = -1>
						<cfbreak>
					<cfelse>
						<cfset parentRowCounter = parentRowCounter + 1>
						<cfset lastParentOrder = qry_selectCategoryList.categoryOrder>
					</cfif>
				<cfelseif qry_selectCategoryList.categoryLevel gt categoryLevel and parentRowCounter lte categoryParentRowCount>
					<cfset lastParentOrder = qry_selectCategoryList.categoryOrder>
				</cfif>
			</cfloop>

			<cfif lastParentOrder is not -1>
				<cfset categoryOrder = lastParentOrder + 1>
			</cfif>
		</cfif>

		<cfif categoryLevel is 2>
			<cfset categoryID_parentList = Arguments.categoryID_parent>
		<cfelse>
			<cfset categoryID_parentList = qry_selectCategoryList.categoryID_parentList[categoryParentRow] & "," & Arguments.categoryID_parent>
		</cfif>
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.Category" method="maxlength_Category" returnVariable="maxlength_Category" />

	<cfquery Name="qry_insertCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Form.categoryID_parent is not 0>
			UPDATE avCategory
			SET categoryHasChildren = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer">
				AND categoryHasChildren = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">;
		</cfif>

		UPDATE avCategory
		SET categoryOrder = categoryOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_integer">
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND categoryOrder >= <cfqueryparam Value="#categoryOrder#" cfsqltype="cf_sql_integer">;

		UPDATE avCategory
		SET categoryOrder_manual = categoryOrder_manual + <cfqueryparam Value="1" cfsqltype="cf_sql_integer">
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND categoryOrder_manual >= <cfqueryparam Value="#Arguments.categoryOrder_manual#" cfsqltype="cf_sql_integer">;

		INSERT INTO avCategory
		(
			companyID, userID, categoryCode, categoryName, categoryDescription, categoryTitle, categoryOrder,
			categoryOrder_manual, categoryStatus, categoryID_parent, categoryID_parentList, categoryLevel,
			categoryHasChildren, categoryAcceptListing, categoryIsListed, categoryHasCustomPrice, categoryViewCount,
			categoryItemsPerPage, categoryNumberOfPages, headerFooterID_header, headerFooterID_footer, templateFilename,
			categoryDateCreated, categoryDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryCode#">,
			<cfqueryparam Value="#Arguments.categoryName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryName#">,
			<cfqueryparam Value="#Arguments.categoryDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryDescription#">,
			<cfqueryparam Value="#Arguments.categoryTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryTitle#">,
			<cfqueryparam Value="#categoryOrder#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryOrder_manual#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#categoryID_parentList#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryID_parentList#">,
			<cfqueryparam Value="#categoryLevel#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.categoryHasChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.categoryAcceptListing#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.categoryIsListed#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.categoryHasCustomPrice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.categoryViewCount#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryItemsPerPage#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryNumberOfPages#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.headerFooterID_header#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.headerFooterID_footer#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.templateFilename#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "categoryID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertCategory.primaryKeyID>
</cffunction>

<cffunction Name="updateCategory" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing category">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="categoryCode" Type="string" Required="No">
	<cfargument Name="categoryName" Type="string" Required="No">
	<cfargument Name="categoryDescription" Type="string" Required="No">
	<cfargument Name="categoryTitle" Type="string" Required="No">
	<cfargument Name="categoryOrder" Type="numeric" Required="No">
	<cfargument Name="categoryOrder_manual" Type="numeric" Required="No">
	<cfargument Name="categoryStatus" Type="numeric" Required="No">
	<cfargument Name="categoryID_parent" Type="numeric" Required="No">
	<cfargument Name="categoryID_parentList" Type="string" Required="No">
	<cfargument Name="categoryLevel" Type="numeric" Required="No">
	<cfargument Name="categoryHasChildren" Type="numeric" Required="No">
	<cfargument Name="categoryAcceptListing" Type="numeric" Required="No">
	<cfargument Name="categoryIsListed" Type="numeric" Required="No">
	<cfargument Name="categoryHasCustomPrice" Type="numeric" Required="No">
	<cfargument Name="categoryViewCount" Type="numeric" Required="No">
	<cfargument Name="categoryItemsPerPage" Type="numeric" Required="No">
	<cfargument Name="categoryNumberOfPages" Type="numeric" Required="No">
	<cfargument Name="headerFooterID_header" Type="numeric" Required="No">
	<cfargument Name="headerFooterID_footer" Type="numeric" Required="No">
	<cfargument Name="templateFilename" Type="string" Required="No" Default="">

	<cfset var qry_selectCategory = selectCategory(Arguments.categoryID)>
	<cfif StructKeyExists(Arguments, "categoryName") and Arguments.categoryName is not qry_selectCategory.categoryName>
		<cfset updateCategoryOrder(qry_selectCategory.companyID)>
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.Category" method="maxlength_Category" returnVariable="maxlength_Category" />

	<cftransaction>
	<!--- If ID of parent category was passed to this query  --->
	<cfif StructKeyExists(Arguments, "categoryID_parent")>
		<!--- If not top-level category, set indicator that parent category has children if necessary --->
		<cfif Arguments.categoryID_parent is not 0>
			<cfquery Name="qry_updateCategory_hasChildrenNew" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				UPDATE avCategory
				SET categoryHasChildren = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer">
					AND categoryHasChildren = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfquery>
		</cfif>

		<!--- If parent category changed, update indicator for whether old parent category has children --->
		<cfif Arguments.categoryID_parent is not qry_selectCategory.categoryID_parent>
			<cfquery Name="qry_updateCategory_checkHasChildren" MaxRows="1" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				SELECT categoryID
				FROM avCategory
				WHERE categoryID_parent = <cfqueryparam Value="#qry_selectCategory.categoryID_parent#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfif qry_updateCategory_checkParent.RecordCount is 0>
				<cfquery Name="qry_updateCategory_checkHasChildren" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
					UPDATE avCategory
					SET categoryHasChildren = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
					WHERE categoryID = <cfqueryparam Value="#qry_selectCategory.categoryID_parent#" cfsqltype="cf_sql_integer">
						AND categoryHasChildren = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
						<!--- AND categoryID NOT IN (SELECT categoryID FROM avCategory WHERE categoryID_parent = <cfqueryparam Value="#qry_selectCategory.categoryID_parent#" cfsqltype="cf_sql_integer">) --->
				</cfquery>
			</cfif>
		</cfif>
	</cfif>

	<cfquery Name="qry_updateCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCategory
		SET 
			<cfif StructKeyExists(Arguments, "categoryCode")>categoryCode = <cfqueryparam Value="#Arguments.categoryCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryCode#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryName")>categoryName = <cfqueryparam Value="#Arguments.categoryName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryName#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryDescription")>categoryDescription = <cfqueryparam Value="#Arguments.categoryDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryTitle")>categoryTitle = <cfqueryparam Value="#Arguments.categoryTitle#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryTitle#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryOrder") and Application.fn_IsIntegerNonNegative(Arguments.categoryOrder)>categoryOrder = <cfqueryparam Value="#Arguments.categoryOrder#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryOrder_manual") and Application.fn_IsIntegerNonNegative(Arguments.categoryOrder_manual)>categoryOrder_manual = <cfqueryparam Value="#Arguments.categoryOrder_manual#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryStatus") and ListFind("0,1", Arguments.categoryStatus)>categoryStatus = <cfqueryparam Value="#Arguments.categoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryID_parent") and Application.fn_IsIntegerNonNegative(Arguments.categoryID_parent)>categoryID_parent = <cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryID_parentList")>categoryID_parentList = <cfqueryparam Value="#Arguments.categoryID_parentList#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.categoryID_parentList#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryLevel") and Application.fn_IsIntegerNonNegative(Arguments.categoryLevel)>categoryLevel = <cfqueryparam Value="#Arguments.categoryLevel#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryHasChildren") and ListFind("0,1", Arguments.categoryHasChildren)>categoryHasChildren = <cfqueryparam Value="#Arguments.categoryHasChildren#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryAcceptListing") and ListFind("0,1", Arguments.categoryAcceptListing)>categoryAcceptListing = <cfqueryparam Value="#Arguments.categoryAcceptListing#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryIsListed") and ListFind("0,1", Arguments.categoryIsListed)>categoryIsListed = <cfqueryparam Value="#Arguments.categoryIsListed#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryHasCustomPrice") and ListFind("0,1", Arguments.categoryHasCustomPrice)>categoryHasCustomPrice = <cfqueryparam Value="#Arguments.categoryHasCustomPrice#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryViewCount") and Application.fn_IsIntegerNonNegative(Arguments.categoryViewCount)>categoryViewCount = <cfqueryparam Value="#Arguments.categoryViewCount#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryItemsPerPage") and Application.fn_IsIntegerNonNegative(Arguments.categoryItemsPerPage)>categoryItemsPerPage = <cfqueryparam Value="#Arguments.categoryItemsPerPage#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "categoryNumberOfPages") and Application.fn_IsIntegerNonNegative(Arguments.categoryNumberofPages)>categoryNumberOfPages = <cfqueryparam Value="#Arguments.categoryNumberOfPages#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "headerFooterID_header") and Application.fn_IsIntegerNonNegative(Arguments.headerFooterID_header)>headerFooterID_header = <cfqueryparam Value="#Arguments.headerFooterID_header#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "headerFooterID_footer") and Application.fn_IsIntegerNonNegative(Arguments.headerFooterID_footer)>headerFooterID_footer = <cfqueryparam Value="#Arguments.headerFooterID_footer#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "templateFilename")>templateFilename = <cfqueryparam Value="#Arguments.templateFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Category.templateFilename#">,</cfif>
			categoryDateUpdated = #Application.billingSql.sql_nowDateTime#
			WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCategory" Access="public" Output="No" ReturnType="query" Hint="Selects existing category">
	<cfargument Name="categoryID" Type="string" Required="Yes">

	<cfset var qry_selectCategory = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.categoryID)>
		<cfset Arguments.categoryID = 0>
	</cfif>

	<cfquery Name="qry_selectCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT categoryID, companyID, userID, categoryCode, categoryName, categoryDescription, categoryTitle,
			categoryOrder, categoryOrder_manual, categoryStatus, categoryID_parent, categoryID_parentList,
			categoryLevel, categoryHasChildren, categoryAcceptListing, categoryViewCount, categoryItemsPerPage,
			categoryNumberOfPages, headerFooterID_header, headerFooterID_footer, templateFilename,
			categoryHasCustomPrice, categoryIsListed, categoryDateCreated, categoryDateUpdated
		FROM avCategory
		WHERE categoryID IN (<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectCategory>
</cffunction>

<cffunction Name="selectCategoryList" Access="public" Output="No" ReturnType="query" Hint="Select list of categories">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryStatus" Type="numeric" Required="No">
	<cfargument Name="categoryLevel" Type="numeric" Required="No">
	<cfargument Name="categoryID_parent" Type="numeric" Required="No">
	<cfargument Name="categoryOrderByManual" Type="boolean" Required="No" Default="False">
	<cfargument Name="categoryAcceptListing" Type="numeric" Required="No">
	<cfargument Name="categoryIsListed" Type="numeric" Required="No">

	<cfset var qry_selectCategoryList = QueryNew("blank")>

	<cfquery Name="qry_selectCategoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT categoryID, categoryCode, categoryName, categoryDescription, categoryTitle,
			categoryOrder, categoryOrder_manual, categoryStatus, categoryID_parent, categoryID_parentList,
			categoryLevel, categoryHasChildren, categoryAcceptListing, categoryViewCount, categoryItemsPerPage,
			categoryNumberOfPages, headerFooterID_header, headerFooterID_footer, templateFilename,
			categoryHasCustomPrice, categoryIsListed, categoryDateCreated, categoryDateUpdated
		FROM avCategory
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "categoryLevel") and Application.fn_IsIntegerNonNegative(Arguments.categoryLevel)>AND categoryLevel = <cfqueryparam Value="#Arguments.categoryLevel#" cfsqltype="cf_sql_integer"></cfif>
			<cfif StructKeyExists(Arguments, "categoryID_parent") and Application.fn_IsIntegerNonNegative(Arguments.categoryID_parent)>AND categoryID_parent = <cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer"></cfif>
			<cfloop Index="field" List="categoryStatus,categoryAcceptListing,categoryIsListed">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			</cfloop>
		ORDER BY <cfif StructKeyExists(Arguments, "categoryOrderByManual") and Arguments.categoryOrderByManual is True>categoryOrder_manual<cfelse>categoryOrder</cfif>
	</cfquery>

	<cfreturn qry_selectCategoryList>
</cffunction>

<cffunction Name="checkCategoryPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for category">
	<cfargument Name="categoryID" Type="string" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryStatus" Type="numeric" Required="No">

	<cfset var qry_checkCategoryPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.categoryID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkCategoryPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT categoryID
			FROM avCategory
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
				AND categoryID IN (<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif StructKeyExists(Arguments, "categoryStatus") and ListFind("0,1", Arguments.categoryStatus)>
					AND categoryStatus = <cfqueryparam Value="#Arguments.categoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
		</cfquery>

		<cfif qry_checkCategoryPermission.RecordCount is 0 or qry_checkCategoryPermission.RecordCount is not ListLen(Arguments.categoryID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<cffunction Name="selectCategoryIDViaCode" Access="public" Output="No" ReturnType="string" Hint="Selects category via code and returns categoryID if exists, 0 if not exists, and -1 if multiple categories have the same code.">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryCode" Type="string" Required="Yes">

	<cfset var qry_selectCategoryIDViaCode = QueryNew("blank")>

	<cfquery Name="qry_selectCategoryIDViaCode" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT categoryID
		FROM avCategory
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND categoryCode IN (<cfqueryparam Value="#Arguments.categoryCode#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectCategoryIDViaCode.RecordCount is 0 or qry_selectCategoryIDViaCode.RecordCount lt ListLen(Arguments.categoryCode)>
		<cfreturn 0>
	<cfelseif qry_selectCategoryIDViaCode.RecordCount gt ListLen(Arguments.categoryCode)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectCategoryIDViaCode.categoryID)>
	</cfif>
</cffunction>

<cffunction Name="checkCategoryNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Validate that category name is unique for company">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No" Default="0">
	<cfargument Name="categoryID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="categoryName" Type="string" Required="Yes">

	<cfset var qry_checkCategoryNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkCategoryNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT categoryID
		FROM avCategory
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND categoryName = <cfqueryparam Value="#Arguments.categoryName#" cfsqltype="cf_sql_varchar">
			AND categoryID_parent = <cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer">
			<cfif Arguments.categoryID is not 0>
				AND categoryID <> <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkCategoryNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkCategoryCodeIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Validate that category code is unique for company">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID" Type="numeric" Required="No" Default="0">
	<cfargument Name="categoryCode" Type="string" Required="Yes">

	<cfset var qry_checkCategoryCodeIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkCategoryCodeIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT categoryID
		FROM avCategory
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			AND categoryCode = <cfqueryparam Value="#Arguments.categoryCode#" cfsqltype="cf_sql_varchar">
			<cfif Arguments.categoryID is not 0>
				AND categoryID <> <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkCategoryCodeIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="switchCategoryOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch manual order of existing categories">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="categoryOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchCategoryOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCategory
		SET categoryOrder_manual = categoryOrder_manual 
			<cfif Arguments.categoryOrder_direction is "moveCategoryDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avCategory INNER JOIN avCategory AS avCategory2
			SET avCategory.categoryOrder_manual = avCategory.categoryOrder_manual 
				<cfif Arguments.categoryOrder_direction is "moveCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avCategory.categoryOrder_manual = avCategory2.categoryOrder_manual
				AND avCategory.categoryID <> <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
				AND avCategory2.categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avCategory
			SET categoryOrder_manual = categoryOrder_manual 
				<cfif Arguments.categoryOrder_direction is "moveCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE categoryID <> <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
				AND categoryOrder_manual = 
					(
					SELECT categoryOrder_manual
					FROM avCategory
					WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
					);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="deleteCategory" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing category">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="categoryID_parent" Type="numeric" Required="Yes">

	<cfquery Name="qry_deleteCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avCategory WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">;
		DELETE FROM avProductCategory WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">;
		DELETE FROM avPriceTarget WHERE priceID IN (SELECT priceID FROM avPrice WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer"> AND priceAppliesToCategory = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">);
		DELETE FROM avPriceVolumeDiscount WHERE priceStageID IN (SELECT avPriceStage.priceStageID FROM avPrice, avPriceStage WHERE avPrice.priceID = avPriceStage.priceID AND avPrice.categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer"> AND avPrice.priceAppliesToCategory = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">);
		DELETE FROM avPrice WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer"> AND priceAppliesToCategory = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;

		<cfif Arguments.categoryID_parent is not 0 and Application.billingDatabase is "MySQL">
			UPDATE avCategory LEFT OUTER JOIN avCategory AS avCategory2
				ON avCategory.categoryID = avCategory2.categoryID_parent
			SET avCategory.categoryHasChildren = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE avCategory.categoryID = <cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer">
			  AND avCategory2.categoryID_parent IS NULL;
		<cfelseif Arguments.categoryID_parent is not 0>
			UPDATE avCategory
			SET categoryHasChildren = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer">
				AND categoryID NOT IN (SELECT categoryID_parent FROM avCategory WHERE categoryID_parent = <cfqueryparam Value="#Arguments.categoryID_parent#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfset updateCategoryOrder(Arguments.companyID)>
	<cfreturn True>
</cffunction>

<cffunction Name="updateCategoryOrder" Access="public" Output="No" ReturnType="boolean" Hint="Update Order of Categories if category is deleted or renamed">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var currentCategoryID_list = "">
	<cfset var currentCategoryID_queryRow = "">
	<cfset var remainingCategoryID_list = "">
	<cfset var thisCatID = "">
	<cfset var thisCatRow = "">
	<cfset var thisCatName = "">
	<cfset var thisCatParentID = "">
	<cfset var loopRowStart = "">
	<cfset var categoryPlaced = False>
	<cfset var loopCatRow = "">
	<cfset var qry_selectCategoryList_order = QueryNew("blank")>
	<cfset var qry_selectMaxCategoryLevel = QueryNew("blank")>
	<cfset var queryMax = 20>
	<cfset var queryTimes = 0>
	<cfset var loopStart = 0>
	<cfset var loopEnd = 0>

	<cfquery Name="qry_selectCategoryList_order" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT categoryID, categoryID_parent, categoryName, categoryLevel
		FROM avCategory
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
		ORDER BY categoryLevel, categoryID_parent, categoryName
	</cfquery>

	<cfif qry_selectCategoryList_order.RecordCount is not 0>
		<cfset currentCategoryID_list = qry_selectCategoryList_order.categoryID[1]>
		<cfset currentCategoryID_queryRow = 1>
		<cfset remainingCategoryID_list = ValueList(qry_selectCategoryList_order.categoryID)>

		<cfloop Query="qry_selectCategoryList_order" StartRow="2">
			<cfset thisCatID = qry_selectCategoryList_order.categoryID>
			<cfset thisCatRow = qry_selectCategoryList_order.CurrentRow>
			<cfset thisCatName = qry_selectCategoryList_order.categoryName>
			<cfset thisCatParentID = qry_selectCategoryList_order.categoryID_parent>
			<cfset loopRowStart = ListFind(currentCategoryID_list, qry_selectCategoryList_order.categoryID_parent) + 1>
			<cfset categoryPlaced = False>

			<cfloop Index="count" From="#loopRowStart#" To="#ListLen(currentCategoryID_list)#">
				<cfset loopCatRow = ListGetAt(currentCategoryID_queryRow, count)>
				<cfif thisCatParentID is not qry_selectCategoryList_order.categoryID_parent[loopCatRow] or thisCatName lt qry_selectCategoryList_order.categoryName[loopCatRow]>
					<cfset currentCategoryID_list = ListInsertAt(currentCategoryID_list, count, thisCatID)>
					<cfset currentCategoryID_queryRow = ListInsertAt(currentCategoryID_queryRow, count, thisCatRow)>
					<cfset categoryPlaced = True>
					<cfbreak>
				</cfif>
			</cfloop>

			<cfif categoryPlaced is False>
				<cfset currentCategoryID_list = ListAppend(currentCategoryID_list, qry_selectCategoryList_order.categoryID)>
				<cfset currentCategoryID_queryRow = ListAppend(currentCategoryID_queryRow, qry_selectCategoryList_order.CurrentRow)>
			</cfif>
		</cfloop>

		<cfset queryMax = 20>
		<cfif (qry_selectCategoryList_order.RecordCount mod queryMax) is 0>
			<cfset queryTimes = qry_selectCategoryList_order.RecordCount \ queryMax>
		<cfelse>
			<cfset queryTimes = (qry_selectCategoryList_order.RecordCount \ queryMax) + 1>
		</cfif>

		<cfloop Index="queryCount" From="1" To="#queryTimes#">
			<cfset loopStart = (DecrementValue(queryCount) * queryMax) + 1>
			<cfset loopEnd = Min(loopStart + queryMax - 1, qry_selectCategoryList_order.RecordCount)>

			<cfquery Name="qry_updateCategoryOrder_all#queryCount#" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				<cfloop Index="count" From="#loopStart#" To="#loopEnd#">
					UPDATE avCategory
					SET categoryOrder = <cfqueryparam Value="#count#" cfsqltype="cf_sql_integer">
					WHERE categoryID = <cfqueryparam Value="#ListGetAt(currentCategoryID_list, count)#" cfsqltype="cf_sql_integer">
				</cfloop>
			</cfquery>
		</cfloop>

		<cfquery Name="qry_selectMaxCategoryLevel" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT Max(categoryLevel) AS maxCategoryLevel
			FROM avCategory
			WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery Name="qry_updateCategoryParentList_null" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avCategory
			SET categoryID_parentList = ''
			WHERE categoryLevel = <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">;

			UPDATE avCategory
			SET categoryID_parentList = categoryID_parent
			WHERE categoryLevel = <cfqueryparam Value="2" cfsqltype="cf_sql_tinyint">;

			<cfif Application.billingDatabase is "MySQL">
				<cfloop Index="level" From="3" To="#qry_selectMaxCategoryLevel.maxCategoryLevel#">
					UPDATE avCategory INNER JOIN avCategory AS avCategory2
					SET avCategory.categoryID_parentList = CONCAT(avCategory2.categoryID_parentList, ',', avCategory.categoryID_parent)
					WHERE avCategory.categoryID_parent = avCategory2.categoryID
					  AND avCategory.categoryLevel = <cfqueryparam Value="#level#" cfsqltype="cf_sql_tinyint">;
				</cfloop>
			<cfelse>
				<cfloop Index="level" From="3" To="#qry_selectMaxCategoryLevel.maxCategoryLevel#">
					UPDATE avCategory
					SET categoryID_parentList = Cast((SELECT A.categoryID_parentList FROM avCategory A WHERE A.categoryID = avCategory.categoryID_parent) AS varchar (255)) + ',' + Cast(categoryID_parent AS varchar (10))
					WHERE categoryLevel = <cfqueryparam Value="#level#" cfsqltype="cf_sql_tinyint">;
				</cfloop>
			</cfif>
		</cfquery>
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCategoryProductCount" Access="public" Output="No" ReturnType="numeric" Hint="Select Count of Products in Category">
	<cfargument Name="categoryID" Type="numeric" Required="Yes">
	<cfargument Name="productCategoryStatus" Type="numeric" Required="No">

	<cfset var qry_selectCategoryProductCount = QueryNew("blank")>

	<cfquery Name="qry_selectCategoryProductCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT Count(categoryID) AS categoryProductCount
		FROM avProductCategory
		WHERE categoryID = <cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "productCategoryStatus") and ListFind("0,1", Arguments.productCategoryStatus)>
				AND productCategoryStatus = <cfqueryparam Value="#Arguments.productCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
	</cfquery>

	<cfreturn qry_selectCategoryProductCount.categoryProductCount>
</cffunction>

</cfcomponent>
