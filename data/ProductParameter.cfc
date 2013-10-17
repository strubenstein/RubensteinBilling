<cfcomponent DisplayName="ProductParameter" Hint="Manages product parameters">

<cffunction name="maxlength_ProductParameter" access="public" output="no" returnType="struct">
	<cfset var maxlength_ProductParameter = StructNew()>

	<cfset maxlength_ProductParameter.productParameterName = 100>
	<cfset maxlength_ProductParameter.productParameterText = 100>
	<cfset maxlength_ProductParameter.productParameterDescription = 255>
	<cfset maxlength_ProductParameter.productParameterImage = 100>

	<cfreturn maxlength_ProductParameter>
</cffunction>

<!--- Product Parameters --->
<cffunction Name="insertProductParameter" Access="public" Output="No" ReturnType="numeric" Hint="Insert product parameter and returns productParameterID">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterName" Type="string" Required="Yes">
	<cfargument Name="productParameterText" Type="string" Required="Yes">
	<cfargument Name="productParameterDescription" Type="string" Required="No" Default="">
	<cfargument Name="productParameterOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterImage" Type="string" Required="No" Default="">
	<cfargument Name="productParameterCodeStatus" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterCodeOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterRequired" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="productParameterExceptionID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterExportXml" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterExportTab" Type="numeric" Required="No" Default="0">
	<cfargument Name="productParameterExportHtml" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertProductParameter = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.ProductParameter" method="maxlength_ProductParameter" returnVariable="maxlength_ProductParameter" />

	<cfquery Name="qry_insertProductParameter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductParameter
		SET productParameterOrder = productParameterOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productParameterOrder >= <cfqueryparam Value="#Arguments.productParameterOrder#" cfsqltype="cf_sql_tinyint">;

		<cfif Arguments.productParameterCodeOrder is not 0>
			UPDATE avProductParameter
			SET productParameterCodeOrder = productParameterCodeOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND productParameterCodeOrder >= <cfqueryparam Value="#Arguments.productParameterCodeOrder#" cfsqltype="cf_sql_tinyint">
				AND productParameterCodeOrder <> 0;
		</cfif>

		INSERT INTO avProductParameter
		(
			productID, productParameterName, productParameterText, productParameterDescription, productParameterOrder,
			productParameterImage, productParameterCodeStatus, productParameterCodeOrder, productParameterRequired,
			productParameterStatus, userID, productParameterExportXml, productParameterExportTab, productParameterExportHtml,
			productParameterDateCreated, productParameterDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productParameterName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameter.productParameterName#">,
			<cfqueryparam Value="#Arguments.productParameterText#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameter.productParameterText#">,
			<cfqueryparam Value="#Arguments.productParameterDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameter.productParameterDescription#">,
			<cfqueryparam Value="#Arguments.productParameterOrder#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.productParameterImage#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameter.productParameterImage#">,
			<cfqueryparam Value="#Arguments.productParameterCodeStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productParameterCodeOrder#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.productParameterRequired#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productParameterStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.productParameterExportXml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productParameterExportTab#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productParameterExportHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "productParameterID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertProductParameter.primaryKeyID>
</cffunction>

<cffunction Name="updateProductParameter" Access="public" Output="No" ReturnType="boolean" Hint="Update product parameter and returns True">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterName" Type="string" Required="No">
	<cfargument Name="productParameterText" Type="string" Required="No">
	<cfargument Name="productParameterDescription" Type="string" Required="No">
	<cfargument Name="productParameterOrder" Type="numeric" Required="No">
	<cfargument Name="productParameterImage" Type="string" Required="No">
	<cfargument Name="productParameterCodeStatus" Type="numeric" Required="No">
	<cfargument Name="productParameterCodeOrder" Type="numeric" Required="No">
	<cfargument Name="productParameterRequired" Type="numeric" Required="No">
	<cfargument Name="productParameterStatus" Type="numeric" Required="No">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="productParameterExportXml" Type="numeric" Required="No">
	<cfargument Name="productParameterExportTab" Type="numeric" Required="No">
	<cfargument Name="productParameterExportHtml" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.ProductParameter" method="maxlength_ProductParameter" returnVariable="maxlength_ProductParameter" />

	<cfquery Name="qry_updateProductParameter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductParameter
		SET 
			<cfif StructKeyExists(Arguments, "productParameterName")>productParameterName = <cfqueryparam Value="#Arguments.productParameterName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameter.productParameterName#">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterText")>productParameterText = <cfqueryparam Value="#Arguments.productParameterText#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameter.productParameterText#">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterDescription")>productParameterDescription = <cfqueryparam Value="#Arguments.productParameterDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameter.productParameterDescription#">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterOrder") and Application.fn_IsIntegerNonNegative(Arguments.productParameterOrder)>productParameterOrder = <cfqueryparam Value="#Arguments.productParameterOrder#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterImage")>productParameterImage = <cfqueryparam Value="#Arguments.productParameterImage#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameter.productParameterImage#">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterCodeStatus") and ListFind("0,1", Arguments.productParameterCodeStatus)>productParameterCodeStatus = <cfqueryparam Value="#Arguments.productParameterCodeStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterCodeOrder") and Application.fn_IsIntegerNonNegative(Arguments.productParameterCodeOrder)>productParameterCodeOrder = <cfqueryparam Value="#Arguments.productParameterCodeOrder#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterRequired") and ListFind("0,1", Arguments.productParameterRequired)>productParameterRequired = <cfqueryparam Value="#Arguments.productParameterRequired#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterStatus") and ListFind("0,1", Arguments.productParameterStatus)>productParameterStatus = <cfqueryparam Value="#Arguments.productParameterStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "userID")>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterExportXml") and ListFind("0,1", Arguments.productParameterExportXml)>productParameterExportXml = <cfqueryparam Value="#Arguments.productParameterExportXml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterExportTab") and ListFind("0,1", Arguments.productParameterExportTab)>productParameterExportTab = <cfqueryparam Value="#Arguments.productParameterExportTab#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "productParameterExportHtml") and ListFind("0,1", Arguments.productParameterExportHtml)>productParameterExportHtml = <cfqueryparam Value="#Arguments.productParameterExportHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			productParameterDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkProductParameterNameIsUnique" Access="public" Output="No" ReturnType="boolean" Hint="Check that product parameter name is unique for product">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterName" Type="string" Required="Yes">
	<cfargument Name="productParameterID" Type="numeric" Required="No">

	<cfset var qry_checkProductParameterNameIsUnique = QueryNew("blank")>

	<cfquery Name="qry_checkProductParameterNameIsUnique" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productParameterID
		FROM avProductParameter
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productParameterName = <cfqueryparam Value="#Arguments.productParameterName#" cfsqltype="cf_sql_varchar">
			<cfif StructKeyExists(Arguments, "productParameterID") and Application.fn_IsIntegerPositive(Arguments.productParameterID)>
				AND productParameterID <> <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
			</cfif>
	</cfquery>

	<cfif qry_checkProductParameterNameIsUnique.RecordCount is 0>
		<cfreturn True>
	<cfelse>
		<cfreturn False>
	</cfif>
</cffunction>

<cffunction Name="selectProductParameter" Access="public" Output="No" ReturnType="query" Hint="Select designated product parameter">
	<cfargument Name="productParameterID" Type="numeric" Required="Yes">

	<cfset var qry_selectProductParameter = QueryNew("blank")>

	<cfquery Name="qry_selectProductParameter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productID, userID, productParameterName, productParameterText,
			productParameterDescription, productParameterOrder, productParameterImage,
			productParameterCodeStatus, productParameterCodeOrder, productParameterRequired,
			productParameterExportXml, productParameterExportTab, productParameterExportHtml,
			productParameterStatus, productParameterDateCreated, productParameterDateUpdated
		FROM avProductParameter
		WHERE productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectProductParameter>
</cffunction>

<cffunction Name="selectProductParameterList" Access="public" Output="No" ReturnType="query" Hint="Select existing product parameters">
	<cfargument Name="productID" Type="string" Required="Yes">
	<cfargument Name="productParameterStatus" Type="numeric" Required="No">
	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="productParameterOrder">
	<cfargument Name="returnOptionCount" Type="boolean" Required="No" Default="False">
	<cfargument Name="productParameterExportXml" Type="numeric" Required="No">
	<cfargument Name="productParameterExportTab" Type="numeric" Required="No">
	<cfargument Name="productParameterExportHtml" Type="numeric" Required="No">

	<cfset var qry_selectProductParameterList = QueryNew("blank")>

	<cfquery Name="qry_selectProductParameterList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productParameterID, productID, userID, productParameterName, productParameterText,
			productParameterDescription, productParameterOrder, productParameterImage,
			productParameterCodeStatus, productParameterCodeOrder, productParameterRequired,
			productParameterExportXml, productParameterExportTab, productParameterExportHtml,
			productParameterStatus, productParameterDateCreated, productParameterDateUpdated
			<cfif StructKeyExists(Arguments, "returnOptionCount") and Arguments.returnOptionCount is True>
				,
				(
				SELECT COUNT(productParameterID)
				FROM avProductParameterOption
				WHERE avProductParameterOption.productParameterID = avProductParameter.productParameterID
					AND avProductParameterOption.productParameterOptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				)
				AS productParameterOptionCount
			</cfif>
		FROM avProductParameter
		WHERE productID IN (<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfloop Index="field" List="productParameterStatus,productParameterExportXml,productParameterExportTab,productParameterExportHtml">
				<cfif StructKeyExists(Arguments, field) and ListFind("0,1", Arguments[field])>
					AND #field# = <cfqueryparam Value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				</cfif>
			</cfloop>
		ORDER BY 
		<cfswitch expression="#Arguments.queryOrderBy#">
		<cfcase value="productParameterName">productParameterName</cfcase>
		<cfcase value="productParameterName_d">productParameterName DESC</cfcase>
		<cfcase value="productParameterText">productParameterText</cfcase>
		<cfcase value="productParameterText_d">productParameterText DESC</cfcase>
		<cfcase value="productParameterOrder">productParameterOrder</cfcase>
		<cfcase value="productParameterOrder_d">productParameterOrder DESC</cfcase>
		<cfcase value="productParameterCodeOrder">productParameterCodeStatus DESC, productParameterCodeOrder</cfcase>
		<cfcase value="productParameterCodeOrder_d">productParameterCodeStatus, productParameterCodeOrder DESC</cfcase>
		<cfcase value="productParameterRequired">productParameterRequired DESC, productParameterOrder</cfcase>
		<cfcase value="productParameterRequired_d">productParameterRequired, productParameterOrder</cfcase>
		<cfcase value="productParameterStatus">productParameterStatus DESC, productParameterOrder</cfcase>
		<cfcase value="productParameterStatus_d">productParameterStatus, productParameterOrder</cfcase>
		<cfcase value="productParameterDateCreated">productParameterDateCreated</cfcase>
		<cfcase value="productParameterDateCreated_d">productParameterDateCreated DESC</cfcase>
		<cfcase value="productParameterDateUpdated">productParameterDateUpdated</cfcase>
		<cfcase value="productParameterDateUpdated_d">productParameterDateUpdated DESC</cfcase>
		<cfcase value="productID">productID, productParameterOrder</cfcase>
		<cfcase value="productID_d">productID DESC, productParameterOrder</cfcase>
		<cfdefaultcase>productParameterOrder</cfdefaultcase>
		</cfswitch>
	</cfquery>

	<cfreturn qry_selectProductParameterList>
</cffunction>

<cffunction Name="switchProductParameterOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch product parameter order">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOrder_direction" Type="string" Required="Yes">
	<cfargument Name="productParameterID" Type="numeric" Required="Yes">

	<cfset var qry_selectProductParameterOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchProductParameterOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductParameter
		SET productParameterOrder = productParameterOrder 
			<cfif Arguments.productParameterOrder_direction is "moveProductParameterDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avProductParameter INNER JOIN avProductParameter AS avProductParameter2
			SET avProductParameter.productParameterOrder = avProductParameter.productParameterOrder 
				<cfif Arguments.productParameterOrder_direction is "moveProductParameterDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE avProductParameter.productParameterOrder = avProductParameter2.productParameterOrder
				AND avProductParameter.productID = avProductParameter2.productID
				AND avProductParameter.productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND avProductParameter.productParameterID <> <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
				AND avProductParameter2.productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avProductParameter
			SET productParameterOrder = productParameterOrder 
				<cfif Arguments.productParameterOrder_direction is "moveProductParameterDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND productParameterID <> <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
				AND productParameterOrder = (SELECT productParameterOrder FROM avProductParameter WHERE productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="updateProductParameterCodeOrder" Access="public" Output="No" ReturnType="boolean" Hint="Decrement product parameter code order when a parameter code is no longer active">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterCodeOrder" Type="numeric" Required="Yes">

	<cfquery Name="qry_updateProductParameterCodeOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductParameter
		SET productParameterCodeOrder = productParameterCodeOrder - <cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productParameterCodeOrder >= <cfqueryparam Value="#Arguments.productParameterCodeOrder#" cfsqltype="cf_sql_tinyint">
			AND productParameterID <> <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="switchProductParameterCodeOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch product parameter code order">
	<cfargument Name="productID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterCodeOrder_direction" Type="string" Required="Yes">
	<cfargument Name="productParameterID" Type="numeric" Required="Yes">

	<cfset var qry_selectProductParameterCodeOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchProductParameterCodeOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductParameter
		SET productParameterCodeOrder = productParameterCodeOrder 
			<cfif Arguments.productParameterCodeOrder_direction is "moveProductParameterCodeDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
		WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
			AND productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avProductParameter INNER JOIN avProductParameter AS avProductParameter2
			SET avProductParameter.productParameterCodeOrder = avProductParameter.productParameterCodeOrder 
				<cfif Arguments.productParameterOrder_direction is "moveProductParameterDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE avProductParameter.productParameterCodeOrder = avProductParameter2.productParameterCodeOrder
				AND avProductParameter.productID = avProductParameter2.productID
				AND avProductParameter.productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND avProductParameter.productParameterID <> <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
				AND avProductParameter2.productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avProductParameter
			SET productParameterCodeOrder = productParameterCodeOrder 
				<cfif Arguments.productParameterCodeOrder_direction is "moveProductParameterCodeDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_tinyint">
			WHERE productID = <cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">
				AND productParameterID <> <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
				AND productParameterCodeOrder = (SELECT productParameterCodeOrder FROM avProductParameter WHERE productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
