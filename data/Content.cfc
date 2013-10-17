<cfcomponent DisplayName="Content" Hint="Manages creating, updating, viewing and managing content">

<cffunction name="maxlength_Content" access="public" output="no" returnType="struct">
	<cfset var maxlength_Content = StructNew()>

	<cfset maxlength_Content.contentName = 100>
	<cfset maxlength_Content.contentDescription = 255>
	<cfset maxlength_Content.contentCode = 50>
	<cfset maxlength_Content.contentType = 25>
	<cfset maxlength_Content.contentFilename = 50>

	<cfreturn maxlength_Content>
</cffunction>

<!--- content listings --->
<cffunction Name="insertContent" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new content listing and returns contentID">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="contentName" Type="string" Required="Yes">
	<cfargument Name="contentDescription" Type="string" Required="No" Default="">
	<cfargument Name="contentCode" Type="string" Required="No" Default="">
	<cfargument Name="contentCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="contentType" Type="string" Required="No" Default="">
	<cfargument Name="contentOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="contentStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="contentMaxlength" Type="numeric" Required="No" Default="0">
	<cfargument Name="contentHtmlOk" Type="numeric" Required="No" Default="0">
	<cfargument Name="contentRequired" Type="numeric" Required="No" Default="1">
	<cfargument Name="contentFilename" Type="string" Required="No" Default="">

	<cfset var qry_insertContent = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Content" method="maxlength_Content" returnVariable="maxlength_Content" />

	<cfquery Name="qry_insertContent" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avContent
		(
			userID, contentName, contentDescription, contentCode, contentCategoryID, contentType,
			contentOrder, contentStatus, contentMaxlength, contentHtmlOk, contentRequired,
			contentFilename, contentDateCreated, contentDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.contentName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentName#">,
			<cfqueryparam Value="#Arguments.contentDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentDescription#">,
			<cfqueryparam Value="#Arguments.contentCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentCode#">,
			<cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.contentType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentType#">,
			<cfqueryparam Value="#Arguments.contentOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.contentStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contentMaxlength#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.contentHtmlOk#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contentRequired#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.contentFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentFilename#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "contentID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertContent.primaryKeyID>
</cffunction>

<cffunction Name="selectContentTypeList" Access="public" Output="No" ReturnType="query" Hint="Select existing content types">
	<cfset var qry_selectContentTypeList = QueryNew("blank")>

	<cfquery Name="qry_selectContentTypeList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT DISTINCT(contentType)
		FROM avContent
		ORDER BY contentType
	</cfquery>
	<cfreturn qry_selectContentTypeList>
</cffunction>

<cffunction Name="checkContentNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that content name is unique for selected category">
	<cfargument Name="contentName" Type="string" Required="Yes">
	<cfargument Name="contentCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="contentID" Type="numeric" Required="No">

	<cfset var qry_checkContentNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkContentNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contentID
		FROM avContent
		WHERE contentName = <cfqueryparam Value="#Arguments.contentName#" cfsqltype="cf_sql_varchar">
			AND contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "contentID") and Application.fn_IsIntegerNonNegative(Arguments.contentID)>
				AND contentID <> <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkContentNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkContentCodeIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that content code is unique (across all categories)">
	<cfargument Name="contentCode" Type="string" Required="Yes">
	<cfargument Name="contentID" Type="numeric" Required="No">

	<cfset var qry_checkContentCodeIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkContentCodeIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contentID
		FROM avContent
		WHERE contentCode = <cfqueryparam Value="#Arguments.contentCode#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "contentID") and Application.fn_IsIntegerNonNegative(Arguments.contentID)>
				AND contentID <> <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkContentCodeIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="checkContentFilenameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Verify that content filename is unique (across all categories)">
	<cfargument Name="contentFilename" Type="string" Required="Yes">
	<cfargument Name="contentID" Type="numeric" Required="No">

	<cfset var qry_checkContentFilenameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkContentFilenameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT contentID
		FROM avContent
		WHERE contentFilename = <cfqueryparam Value="#Arguments.contentFilename#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "contentID") and Application.fn_IsIntegerNonNegative(Arguments.contentID)>
				AND contentID <> <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkContentFilenameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="updateContentOrder" Access="public" Output="No" ReturnType="boolean" Hint="Increment/decrement content order within category as content listings are added/moved/deleted.">
	<cfargument Name="contentID" Type="numeric" Required="No" Default="0">
	<cfargument Name="contentCategoryID" Type="numeric" Required="Yes">
	<cfargument Name="contentOrder_min" Type="numeric" Required="No">
	<cfargument Name="contentyOrder_max" Type="numeric" Required="No">
	<cfargument Name="contentOrder_direction" Type="string" Required="No" Default="down">

	<cfquery Name="qry_updateContentOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContent
		SET contentOrder = contentOrder 
			<cfif Arguments.contentOrder_direction is "down"> + <cfelse><!--- up ---> - </cfif> 1
		WHERE contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">
			AND contentID <> <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "contentOrder_min") and Application.fn_IsIntegerNonNegative(Arguments.contentOrder_min)>
				AND contentOrder >= <cfqueryparam Value="#Arguments.contentOrder_min#" cfsqltype="cf_sql_smallint">
			</cfif>
			<cfif StructKeyExists(Arguments, "contentOrder_max") and Application.fn_IsIntegerNonNegative(Arguments.contentOrder_max)>
				AND contentOrder <= <cfqueryparam Value="#Arguments.contentOrder_max#" cfsqltype="cf_sql_smallint">
			</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateContent" Access="public" Output="No" ReturnType="boolean" Hint="Update existing content listing and returns True">
	<cfargument Name="contentID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="contentName" Type="string" Required="No">
	<cfargument Name="contentDescription" Type="string" Required="No">
	<cfargument Name="contentCode" Type="string" Required="No">
	<cfargument Name="contentCategoryID" Type="numeric" Required="No">
	<cfargument Name="contentType" Type="string" Required="No">
	<cfargument Name="contentOrder" Type="numeric" Required="No">
	<cfargument Name="contentStatus" Type="numeric" Required="No">
	<cfargument Name="contentMaxlength" Type="numeric" Required="No">
	<cfargument Name="contentHtmlOk" Type="numeric" Required="No">
	<cfargument Name="contentRequired" Type="numeric" Required="No">
	<cfargument Name="contentFilename" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Content" method="maxlength_Content" returnVariable="maxlength_Content" />

	<cfquery Name="qry_updateContent" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContent
		SET 
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "contentName")>contentName = <cfqueryparam Value="#Arguments.contentName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentName#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentDescription")>contentDescription = <cfqueryparam Value="#Arguments.contentDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentCode")>contentCode = <cfqueryparam Value="#Arguments.contentCode#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentCode#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentCategoryID") and Application.fn_IsIntegerNonNegative(Arguments.contentCategoryID)>contentCategoryID = <cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "contentType")>contentType = <cfqueryparam Value="#Arguments.contentType#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentType#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentOrder") and Application.fn_IsIntegerNonNegative(Arguments.contentOrder)>contentOrder = <cfqueryparam Value="#Arguments.contentOrder#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "contentStatus") and ListFind("0,1", Arguments.contentStatus)>contentStatus = <cfqueryparam Value="#Arguments.contentStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentMaxlength") and Application.fn_IsIntegerNonNegative(Arguments.contentMaxlength)>contentMaxlength = <cfqueryparam Value="#Arguments.contentMaxlength#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "contentHtmlOk") and ListFind("0,1", Arguments.contentHtmlOk)>contentHtmlOk = <cfqueryparam Value="#Arguments.contentHtmlOk#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentRequired") and ListFind("0,1", Arguments.contentRequired)>contentRequired = <cfqueryparam Value="#Arguments.contentRequired#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "contentFilename")>contentFilename = <cfqueryparam Value="#Arguments.contentFilename#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Content.contentFilename#">,</cfif>
			contentDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE contentID = <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectContent" Access="public" Output="No" ReturnType="query" Hint="Select existing content listing">
	<cfargument Name="contentID" Type="numeric" Required="Yes">

	<cfset var qry_selectContent = QueryNew("blank")>

	<cfquery Name="qry_selectContent" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID, contentName, contentDescription, contentCode, contentCategoryID, contentType, contentOrder, contentStatus,
			contentMaxlength, contentHtmlOk, contentRequired, contentFilename, contentDateCreated, contentDateUpdated
		FROM avContent
		WHERE contentID = <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectContent>
</cffunction>

<cffunction Name="selectContentList" Access="public" Output="No" ReturnType="query" Hint="Select existing content listings">
	<cfargument Name="contentID" Type="string" Required="No">
	<cfargument Name="contentCode" Type="string" Required="No">
	<cfargument Name="contentCategoryID" Type="string" Required="No">
	<cfargument Name="contentType" Type="string" Required="No">
	<cfargument Name="contentStatus" Type="numeric" Required="No">
	<cfargument Name="contentCategoryCode" Type="string" Required="No">

	<cfset var qry_selectContentList = QueryNew("blank")>

	<cfquery Name="qry_selectContentList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avContent.contentID, avContent.userID, avContent.contentName, avContent.contentDescription,
			avContent.contentCode, avContent.contentCategoryID, avContent.contentType, avContent.contentOrder,
			avContent.contentStatus, avContent.contentMaxlength, avContent.contentHtmlOk, avContent.contentRequired,
			avContent.contentFilename, avContent.contentDateCreated, avContent.contentDateUpdated
		FROM avContent
			<cfif StructKeyExists(Arguments, "contentCategoryCode") and Trim(Arguments.contentCategoryCode) is not "">
				INNER JOIN avContentCategory ON avContent.contentCategoryID = avContentCategory.contentCategoryID
			</cfif>
		WHERE 
			<cfif StructKeyExists(Arguments, "contentCategoryCode") and Trim(Arguments.contentCategoryCode) is not "">
				avContentCategory.contentCategoryCode IN (<cfqueryparam Value="#Arguments.contentCategoryCode#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
			<cfelse>
				avContent.contentID > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif StructKeyExists(Arguments, "contentCategoryID") and Application.fn_IsIntegerList(Arguments.contentCategoryID)>AND avContent.contentCategoryID IN (<cfqueryparam Value="#Arguments.contentCategoryID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "contentID") and Application.fn_IsIntegerList(Arguments.contentID)>AND avContent.contentID IN (<cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "contentStatus") and ListFind("0,1", Arguments.contentStatus)>AND avContent.contentStatus = <cfqueryparam Value="#Arguments.contentStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			<cfif StructKeyExists(Arguments, "contentCode") and Arguments.contentCode is not "">AND avContent.contentCode IN (<cfqueryparam Value="#Arguments.contentCode#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)</cfif>
			<cfif StructKeyExists(Arguments, "contentType") and Arguments.contentType is not "">AND avContent.contentType IN (<cfqueryparam Value="#Arguments.contentType#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)</cfif>
		ORDER BY avContent.contentOrder, avContent.contentStatus DESC
	</cfquery>

	<cfreturn qry_selectContentList>
</cffunction>

<cffunction Name="switchContentOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing content listings within category">
	<cfargument Name="contentID" Type="numeric" Required="Yes">
	<cfargument Name="contentOrder_direction" Type="string" Required="Yes">

	<cfquery Name="qry_switchContentOrder_up" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avContent
		SET contentOrder = contentOrder 
			<cfif Arguments.contentOrder_direction is "moveContentDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE contentID = <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avContent INNER JOIN avContent AS avContent2
			SET avContent.contentOrder = avContent.contentOrder 
				<cfif Arguments.contentOrder_direction is "moveContentDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avContent.contentOrder = avContent2.contentOrder
				AND avContent.contentCategoryID = avContent2.contentCategoryID
				AND avContent.contentID <> <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
				AND avContent2.contentID = <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avContent
			SET contentOrder = contentOrder 
				<cfif Arguments.contentOrder_direction is "moveContentDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE contentID <> <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">
				AND contentOrder = (SELECT contentOrder FROM avContent WHERE contentID = <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">)
				AND contentCategoryID = (SELECT contentCategoryID FROM avContent WHERE contentID = <cfqueryparam Value="#Arguments.contentID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>

