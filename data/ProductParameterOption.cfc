<cfcomponent DisplayName="ProductParameterOption" Hint="Manages product parameter options">

<cffunction name="maxlength_ProductParameterOption" access="public" output="no" returnType="struct">
	<cfset var maxlength_ProductParameterOption = StructNew()>

	<cfset maxlength_ProductParameterOption.productParameterOptionLabel = 100>
	<cfset maxlength_ProductParameterOption.productParameterOptionValue = 100>
	<cfset maxlength_ProductParameterOption.productParameterOptionImage = 100>
	<cfset maxlength_ProductParameterOption.productParameterOptionCode = 50>

	<cfreturn maxlength_ProductParameterOption>
</cffunction>

<!--- Product Parameter Options --->
<cffunction Name="insertProductParameterOption" Access="public" Output="No" ReturnType="boolean" Hint="Insert product parameter options and returns True">
	<cfargument Name="productParameterID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOptionLabel" Type="array" Required="Yes">
	<cfargument Name="productParameterOptionValue" Type="array" Required="Yes">
	<cfargument Name="productParameterOptionImage" Type="array" Required="No" Default="">
	<cfargument Name="productParameterOptionCode" Type="array" Required="No" Default="">

	<cfinvoke component="#Application.billingMapping#data.ProductParameterOption" method="maxlength_ProductParameterOption" returnVariable="maxlength_ProductParameterOption" />

	<cftransaction>
	<cfquery Name="qry_insertProductParameterOption" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductParameterOption
		SET productParameterOptionStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			productParameterOptionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
			AND productParameterOptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">;

		<cfloop Index="count" From="1" To="#ArrayLen(Arguments.productParameterOptionLabel)#">
			INSERT INTO avProductParameterOption
			(
				productParameterID, productParameterOptionLabel, productParameterOptionValue, productParameterOptionOrder,
				productParameterOptionImage, productParameterOptionCode, productParameterOptionStatus, productParameterOptionVersion,
				userID, productParameterOptionDateCreated, productParameterOptionDateUpdated
			)
			VALUES
			(
				<cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam Value="#Arguments.productParameterOptionLabel[count]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameterOption.productParameterOptionLabel#">,
				<cfqueryparam Value="#Arguments.productParameterOptionValue[count]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameterOption.productParameterOptionValue#">,
				<cfqueryparam Value="#count#" cfsqltype="cf_sql_smallint">,
				<cfqueryparam Value="#Arguments.productParameterOptionImage[count]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameterOption.productParameterOptionImage#">,
				<cfqueryparam Value="#Arguments.productParameterOptionCode[count]#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_ProductParameterOption.productParameterOptionCode#">,
				<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
				<cfqueryparam Value="0" cfsqltype="cf_sql_smallint">,
				<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
				#Application.billingSql.sql_nowDateTime#,
				#Application.billingSql.sql_nowDateTime#
			);
		</cfloop>
	</cfquery>

	<cfquery Name="qry_insertProductParameterOption_updateVersion_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT MAX(productParameterOptionVersion) AS maxProductParameterOptionVersion
		FROM avProductParameterOption
		WHERE productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_insertProductParameterOption_updateVersion" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avProductParameterOption
		SET productParameterOptionVersion = <cfqueryparam Value="1" cfsqltype="cf_sql_smallint"> + 
			<cfif Not IsNumeric(qry_insertProductParameterOption_updateVersion_select.maxProductParameterOptionVersion)>
				<cfqueryparam Value="0" cfsqltype="cf_sql_smallint">
			<cfelse>
				<cfqueryparam Value="#qry_insertProductParameterOption_updateVersion_select.maxProductParameterOptionVersion#" cfsqltype="cf_sql_smallint">
			</cfif>
		WHERE productParameterID = <cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer">
			AND productParameterOptionStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
	</cfquery>
	</cftransaction>

	<cfreturn True>
</cffunction>

<cffunction Name="selectProductParameterOption" Access="public" Output="No" ReturnType="query" Hint="Select designated product parameter option">
	<cfargument Name="productParameterOptionID" Type="string" Required="Yes">

	<cfset var qry_selectProductParameterOption = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.productParameterOptionID)>
		<cfset Arguments.productParameterOptionID = 0>
	</cfif>

	<cfquery Name="qry_selectProductParameterOption" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avProductParameterOption.productParameterOptionID, avProductParameterOption.productParameterID,
			avProductParameterOption.productParameterOptionLabel, avProductParameterOption.productParameterOptionValue,
			avProductParameterOption.productParameterOptionOrder, avProductParameterOption.productParameterOptionImage,
			avProductParameterOption.productParameterOptionCode, avProductParameterOption.productParameterOptionStatus,
			avProductParameterOption.productParameterOptionVersion, avProductParameterOption.userID, 
			avProductParameterOption.productParameterOptionDateCreated, avProductParameterOption.productParameterOptionDateUpdated,
			avProductParameter.productParameterName, avProductParameter.productParameterText
		FROM avProductParameterOption INNER JOIN avProductParameter ON avProductParameterOption.productParameterID = avProductParameter.productParameterID
		WHERE avProductParameterOption.productParameterOptionID IN (<cfqueryparam Value="#Arguments.productParameterOptionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectProductParameterOption>
</cffunction>

<cffunction Name="selectProductParameterOptionList" Access="public" Output="No" ReturnType="query" Hint="Select designated product parameter options">
	<cfargument Name="productParameterID" Type="string" Required="Yes">
	<cfargument Name="productParameterOptionStatus" Type="numeric" Required="No">
	<cfargument Name="productParameterOptionVersion" Type="string" Required="No">

	<cfset var qry_selectProductParameterOptionList = QueryNew("blank")>

	<cfquery Name="qry_selectProductParameterOptionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT productParameterOptionID, productParameterID, productParameterOptionLabel,
			productParameterOptionValue, productParameterOptionOrder, productParameterOptionImage,
			productParameterOptionCode, productParameterOptionStatus, productParameterOptionVersion,
			userID, productParameterOptionDateCreated, productParameterOptionDateUpdated
		FROM avProductParameterOption
		WHERE productParameterID IN (<cfqueryparam Value="#Arguments.productParameterID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "productParameterOptionStatus") and ListFind("0,1", Arguments.productParameterOptionStatus)>
				AND productParameterOptionStatus = <cfqueryparam Value="#Arguments.productParameterOptionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "productParameterOptionVersion") and Application.fn_IsIntegerList(Arguments.productParameterOptionVersion)>
				AND productParameterOptionVersion IN (<cfqueryparam Value="#Arguments.productParameterOptionVersion#" cfsqltype="cf_sql_smallint" List="Yes" Separator=",">)
			</cfif>
		ORDER BY productParameterID, productParameterOptionVersion DESC, productParameterOptionOrder
	</cfquery>

	<cfreturn qry_selectProductParameterOptionList>
</cffunction>

</cfcomponent>
