<cfcomponent DisplayName="ContentCategory" Hint="Manages creating, updating, viewing and managing content categories">

<cffunction name="maxlength_ContentCategory" access="public" output="no" returnType="struct">
	<cfset var maxlength_ContentCategory = StructNew()>

	<cfset maxlength_ContentCategory.contentCategoryName = 100>
	<cfset maxlength_ContentCategory.contentCategoryCode = 50>
	<cfset maxlength_ContentCategory.contentCategoryDescription = 255>

	<cfreturn maxlength_ContentCategory>
</cffunction>

<!--- content categories --->
<cffunction Name="insertContentCategory" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new content category and returns contentCategoryID">
	<cfargument Name="contentCategoryName" Type="string" Required="Yes">
	<cfargument Name="contentCategoryCode" Type="string" Required="Yes">
	<cfargument Name="contentCategoryDescription" Type="string" Required="No" Default="">
	<cfargument Name="contentCategoryOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="contentCategoryStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="userID" Type="numeric" Required="Yes">

	<cfset var qry_insertContentCategory = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.ContentCategory" method="maxlength_ContentCategory" returnVariable="maxlength_ContentCategory" />

	<cfquery Name="qry_insertContentCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avContentCategory
		(
			contentCategoryName, contentCategoryCode, contentCategoryDescription, contentCategoryOrder,
			contentCategoryStatus, userID, contentCategoryDateCreated, contentCategoryDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.contentCategoryName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContentCategory.contentCategoryName#">,
			<cfqueryparam Value="#Arguments.contentCategoryCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContentCategory.contentCategoryCode#">,
			<cfqueryparam Value="#Arguments.contentCategoryDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContentCategory.contentCategoryDescription#">,
			<cfqueryparam Value="#Arguments.contentCategoryOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.contentCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "contentCategoryID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertContentCategory.primaryKeyID>
</cffunction>

<cffunction Name="updateContentCategory" Access="public" Output="No" ReturnType="boolean" Hint="Update existing content category and returns True">
	<cfargument Name="contentCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="contentCategoryName" Type="string" Required="No">
	<cfargument Name="contentCategoryCode" Type="string" Required="No">
	<cfargument Name="contentCategoryDescription" Type="string" Required="No">
	<cfargument Name="contentCategoryOrder" Type="numeric" Required="No">
	<cfargument Name="contentCategoryStatus" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.ContentCategory" method="maxlength_ContentCategory" returnVariable="maxlength_ContentCategory" />

	<cfquery Name="qry_updateContentCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContentCategory
		SET 
			<cfif StructKeyExists(Arguments, "contentCategoryName")>contentCategoryName = <cfqueryparam Value="#Arguments.contentCategoryName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContentCategory.contentCategoryName#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentCategoryCode")>contentCategoryCode = <cfqueryparam Value="#Arguments.contentCategoryCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContentCategory.contentCategoryCode#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentCategoryDescription")>contentCategoryDescription = <cfqueryparam Value="#Arguments.contentCategoryDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ContentCategory.contentCategoryDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentCategoryOrder") and Application.fn_IsIntegerNonNegative(Arguments.contentCategoryOrder)>contentCategoryOrder = <cfqueryparam Value="#Arguments.contentCategoryOrder#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "contentCategoryStatus") and ListFind("0,1", Arguments.contentCategoryStatus)>contentCategoryStatus = <cfqueryparam Value="#Arguments.contentCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			contentCategoryDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkContentCategoryNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that content category name is unique">
	<cfargument Name="contentCategoryName" Type="string" Required="Yes">
	<cfargument Name="contentCategoryID" Type="numeric" Required="No">

	<cfset var qry_checkContentCategoryNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkContentCategoryNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contentCategoryID
		FROM avContentCategory
		WHERE contentCategoryName = <cfqueryparam Value="#Arguments.contentCategoryName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "contentCategoryID") and Application.fn_IsIntegerNonNegative(Arguments.contentCategoryID)>
				AND contentCategoryID <> <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkContentCategoryNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkContentCategoryCodeIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that content category name is unique">
	<cfargument Name="contentCategoryCode" Type="string" Required="Yes">
	<cfargument Name="contentCategoryID" Type="numeric" Required="No">

	<cfset var qry_checkContentCategoryCodeIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkContentCategoryCodeIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contentCategoryID
		FROM avContentCategory
		WHERE contentCategoryCode = <cfqueryparam Value="#Arguments.contentCategoryCode#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "contentCategoryID") and Application.fn_IsIntegerNonNegative(Arguments.contentCategoryID)>
				AND contentCategoryID <> <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkContentCategoryCodeIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="updateContentCategoryOrder" Access="public" Output="No" ReturnType="boolean" Hint="Increment/decrement category order as categories are added/moved/deleted.">
	<cfargument Name="contentCategoryID" Type="numeric" Required="No" Default="0">
	<cfargument Name="contentCategoryOrder_min" Type="numeric" Required="No">
	<cfargument Name="contentCategoryOrder_max" Type="numeric" Required="No">
	<cfargument Name="contentCategoryOrder_direction" Type="string" Required="No" Default="down">

	<cfquery Name="qry_updateContentCategoryOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContentCategory
		SET contentCategoryOrder = contentCategoryOrder 
			<cfif Arguments.contentCategoryOrder_direction is "down"> + <cfelse><!--- up ---> - </cfif> 1
		WHERE contentCategoryID <> <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "contentCategoryOrder_min") and Application.fn_IsIntegerNonNegative(Arguments.contentCategoryOrder_min)>
				AND contentCategoryOrder >= <cfqueryparam Value="#Arguments.contentCategoryOrder_min#" cfsqltype="cf_sql_smallint">
			</cfif>
			<cfif StructKeyExists(Arguments, "contentCategoryOrder_max") and Application.fn_IsIntegerNonNegative(Arguments.contentCategoryOrder_max)>
				AND contentCategoryOrder <= <cfqueryparam Value="#Arguments.contentCategoryOrder_max#" cfsqltype="cf_sql_smallint">
			</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectContentCategory" Access="public" Output="No" ReturnType="query" Hint="Select existing content category"> 
	<cfargument Name="contentCategoryID" Type="numeric" Required="Yes">

	<cfset var qry_selectContentCategory = QueryNew("blank")>

	<cfquery Name="qry_selectContentCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contentCategoryName, contentCategoryCode,
			contentCategoryDescription, contentCategoryOrder, contentCategoryStatus,
			userID, contentCategoryDateCreated, contentCategoryDateUpdated
		FROM avContentCategory
		WHERE contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectContentCategory>
</cffunction>

<cffunction Name="selectContentCategoryList" Access="public" Output="No" ReturnType="query" Hint="Select existing content categories">
	<cfargument Name="contentStatus" Type="numeric" Required="No">

	<cfset var qry_selectContentCategoryList = QueryNew("blank")>

	<cfquery Name="qry_selectContentCategoryList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avContentCategory.contentCategoryID, avContentCategory.contentCategoryName,
			avContentCategory.contentCategoryCode, avContentCategory.contentCategoryDescription,
			avContentCategory.contentCategoryOrder, avContentCategory.contentCategoryStatus,
			avContentCategory.contentCategoryDateCreated, avContentCategory.contentCategoryDateUpdated,
			avContentCategory.userID, COUNT(avContent.contentCategoryID) as contentCount
		FROM avContentCategory LEFT OUTER JOIN avContent
			ON avContentCategory.contentCategoryID = avContent.contentCategoryID
		<cfif StructKeyExists(Arguments, "contentCategoryStatus") and ListFind("0,1", Arguments.contentCategoryStatus)>
			WHERE contentCategoryStatus = <cfqueryparam Value="#Arguments.contentCategoryStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		</cfif>
		GROUP BY avContentCategory.contentCategoryID, avContentCategory.contentCategoryName,
			avContentCategory.contentCategoryCode, avContentCategory.contentCategoryDescription,
			avContentCategory.contentCategoryOrder, avContentCategory.contentCategoryStatus,
			avContentCategory.contentCategoryDateCreated, avContentCategory.contentCategoryDateUpdated,
			avContentCategory.userID
		ORDER BY avContentCategory.contentCategoryOrder
	</cfquery>

	<cfreturn qry_selectContentCategoryList>
</cffunction>

<cffunction Name="switchContentCategoryOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing content categories">
	<cfargument Name="contentCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="contentCategoryOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchContentCategoryOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContentCategory
		SET contentCategoryOrder = contentCategoryOrder 
			<cfif Arguments.contentCategoryOrder_direction is "moveContentCategoryDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avContentCategory INNER JOIN avContentCategory AS avContentCategory2
			SET avContentCategory.contentCategoryOrder = avContentCategory.contentCategoryOrder 
				<cfif Arguments.contentCategoryOrder_direction is "moveContentCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avContentCategory.contentCategoryOrder = avContentCategory2.contentCategoryOrder
				AND avContentCategory.contentCategoryID <> <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
				AND avContentCategory2.contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avContentCategory
			SET contentCategoryOrder = contentCategoryOrder 
				<cfif Arguments.contentCategoryOrder_direction is "moveContentCategoryDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE contentCategoryID <> <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
				AND contentCategoryOrder = 
					(
					SELECT contentCategoryOrder
					FROM avContentCategory
					WHERE contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
					);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="deleteContentCategory" Access="public" Output="No" ReturnType="boolean" Hint="Delete existing content category">
	<cfargument Name="contentCategoryID" Type="numeric" Required="No">

	<cfquery Name="qry_deleteContentCategory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		DELETE FROM avContentCategory
		WHERE contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfreturn True>
</cffunction>

</cfcomponent>
