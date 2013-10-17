<cfcomponent DisplayName="Region" Hint="Manages regions">

<cffunction Name="maxlength_Region" Access="public" Output="No" ReturnType="struct">
	<cfset var maxlength_Region = StructNew()>

	<cfset maxlength_Region.regionName = 100>
	<cfset maxlength_Region.regionCity = 100>
	<cfset maxlength_Region.regionCounty = 100>
	<cfset maxlength_Region.regionState = 100>
	<cfset maxlength_Region.regionStateAbbreviation = 2>
	<cfset maxlength_Region.regionZipCode = 10>
	<cfset maxlength_Region.regionZipCodeMax = 10>
	<cfset maxlength_Region.regionCountry = 100>
	<cfset maxlength_Region.regionDescription = 255>
	<cfset maxlength_Region.regionLatitude = 6>
	<cfset maxlength_Region.regionLongitude = 6>

	<cfreturn maxlength_Region>
</cffunction>

<cffunction name="insertRegion" access="public" output="No" returnType="numeric" hint="Inserts new region. Returns regionID.">
	<cfargument name="companyID" type="numeric" required="no" default="0">
	<cfargument name="userID" type="numeric" required="no" default="0">
	<cfargument name="regionName" type="string" required="no" default="">
	<cfargument name="regionCity" type="string" required="no" default="">
	<cfargument name="regionCounty" type="string" required="no" default="">
	<cfargument name="regionState" type="string" required="no" default="">
	<cfargument name="regionStateAbbreviation" type="string" required="no" default="">
	<cfargument name="regionZipCode" type="string" required="no" default="">
	<cfargument name="regionZipCodeMax" type="string" required="no" default="">
	<cfargument name="regionCountry" type="string" required="no" default="">
	<cfargument name="regionStatus" type="numeric" required="no" default="0">
	<cfargument name="regionIsBundle" type="numeric" required="no" default="0">
	<cfargument name="regionInBundle" type="numeric" required="no" default="0">
	<cfargument name="regionDescription" type="string" required="no" default="">
	<cfargument name="regionAreaCode" type="string" required="no" default="">
	<cfargument name="regionLatitude" type="numeric" required="no" default="0">
	<cfargument name="regionLongitude" type="numeric" required="no" default="0">
	<cfargument name="regionGMToffset" type="numeric" required="no" default="0">
	<cfargument name="regionDaylightSavings" type="numeric" required="no" default="0">

	<cfset var qry_insertRegion = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Region" method="maxlength_Region" returnVariable="maxlength_Region" />

	<cfquery Name="qry_insertRegion" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avRegion
		(
			companyID, userID, regionName, regionCity, regionCounty, regionState, regionStateAbbreviation,
			regionZipCode, regionZipCodeMax, regionCountry, regionStatus, regionIsBundle, regionInBundle,
			regionDescription, regionAreaCode, regionLatitude, regionLongitude, regionGMToffset,
			regionDaylightSavings, regionDateCreated, regionDateUpdated
		)
		VALUES
		(
			<cfqueryparam value="#Arguments.companyID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#Arguments.regionName#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionName#">,
			<cfqueryparam value="#Arguments.regionCity#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionCity#">,
			<cfqueryparam value="#Arguments.regionCounty#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionCounty#">,
			<cfqueryparam value="#Arguments.regionState#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionState#">,
			<cfqueryparam value="#Arguments.regionStateAbbreviation#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionStateAbbreviation#">,
			<cfqueryparam value="#Arguments.regionZipCode#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionZipCode#">,
			<cfqueryparam value="#Arguments.regionZipCodeMax#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionZipCodeMax#">,
			<cfqueryparam value="#Arguments.regionCountry#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionCountry#">,
			<cfqueryparam value="#Arguments.regionStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam value="#Arguments.regionIsBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam value="#Arguments.regionInBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam value="#Arguments.regionDescription#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region.regionDescription#">,
			<cfqueryparam value="#Arguments.regionAreaCode#" cfsqltype="cf_sql_char" maxlength="#maxlength_Region.regionAreaCode#">,
			<cfqueryparam value="#Arguments.regionLatitude#" cfsqltype="cf_sql_decimal" scale="#maxlength_Region.regionLatitude#">,
			<cfqueryparam value="#Arguments.regionLongitude#" cfsqltype="cf_sql_decimal" scale="#maxlength_Region.regionLongitude#">,
			<cfqueryparam value="#Arguments.regionGMToffset#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam value="#Arguments.regionDaylightSavings#" cfsqltype="cf_sql_tinyint">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "regionID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertRegion.primaryKeyID>
</cffunction>

<cffunction name="updateRegion" access="public" output="No" returnType="boolean" hint="Updates existing region">
	<cfargument name="regionID" type="numeric" required="yes">
	<cfargument name="companyID" type="numeric" required="no">
	<cfargument name="userID" type="numeric" required="no">
	<cfargument name="regionName" type="string" required="no">
	<cfargument name="regionCity" type="string" required="no">
	<cfargument name="regionCounty" type="string" required="no">
	<cfargument name="regionState" type="string" required="no">
	<cfargument name="regionStateAbbreviation" type="string" required="no">
	<cfargument name="regionZipCode" type="string" required="no">
	<cfargument name="regionZipCodeMax" type="string" required="no">
	<cfargument name="regionCountry" type="string" required="no">
	<cfargument name="regionStatus" type="numeric" required="no">
	<cfargument name="regionIsBundle" type="numeric" required="no">
	<cfargument name="regionInBundle" type="numeric" required="no">
	<cfargument name="regionDescription" type="string" required="no">
	<cfargument name="regionAreaCode" type="string" required="no">
	<cfargument name="regionLatitude" type="numeric" required="no">
	<cfargument name="regionLongitude" type="numeric" required="no">
	<cfargument name="regionGMToffset" type="numeric" required="no">
	<cfargument name="regionDaylightSavings" type="numeric" required="no">

	<cfinvoke component="#Application.billingMapping#data.Region" method="maxlength_Region" returnVariable="maxlength_Region" />

	<cfquery Name="qry_updateRegion" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avRegion
		SET 
			<cfloop index="field" list="companyID,userID">
				<cfif StructKeyExists(Arguments, field)>#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_integer">,</cfif>
			</cfloop>
			<cfloop index="field" list="regionName,regionCity,regionCounty,regionState,regionStateAbbreviation,regionZipCode,regionZipCodeMax,regionCountry,regionDescription">
				<cfif StructKeyExists(Arguments, field)>#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="cf_sql_varchar" maxlength="#maxlength_Region[field]#">,</cfif>
			</cfloop>
			<cfloop index="field" list="regionStatus,regionIsBundle,regionInBundle">
				<cfif StructKeyExists(Arguments, field)>#field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "regionAreaCode")>regionAreaCode = <cfqueryparam value="#Arguments.regionAreaCode#" cfsqltype="cf_sql_char" maxlength="#maxlength_Region.regionAreaCode#">,</cfif>
			<cfif StructKeyExists(Arguments, "regionLatitude")>regionLatitude = <cfqueryparam value="#Arguments.regionLatitude#" cfsqltype="cf_sql_decimal" scale="#maxlength_Region.regionLatitude#">,</cfif>
			<cfif StructKeyExists(Arguments, "regionLongitude")>regionLongitude = <cfqueryparam value="#Arguments.regionLongitude#" cfsqltype="cf_sql_decimal" scale="#maxlength_Region.regionLongitude#">,</cfif>
			<cfif StructKeyExists(Arguments, "regionGMToffset")>regionGMToffset = <cfqueryparam value="#Arguments.regionGMToffset#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "regionDaylightSavings")>regionDaylightSavings = <cfqueryparam value="#Arguments.regionDaylightSavings#" cfsqltype="cf_sql_tinyint">,</cfif>
			regionDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE regionID = <cfqueryparam value="#Arguments.regionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction name="selectRegion" access="public" output="No" returnType="query" hint="Selects existing region">
	<cfargument name="regionID" type="numeric" required="Yes">

	<cfset var qry_selectRegion = QueryNew("blank")>

	<cfquery Name="qry_selectRegion" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT regionID, companyID, userID, regionName, regionCity, regionCounty, regionState, regionStateAbbreviation,
			regionZipCode, regionZipCodeMax, regionCountry, regionStatus, regionIsBundle, regionInBundle,
			regionDescription, regionAreaCode, regionLatitude, regionLongitude, regionGMToffset,
			regionDaylightSavings, regionDateCreated, regionDateUpdated
		FROM avRegion
		WHERE regionID = <cfqueryparam value="#Arguments.regionID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectRegion>
</cffunction>

<cffunction name="selectRegionList" access="public" output="No" returnType="query" hint="Selects existing region">
	<cfargument name="regionID" type="string" required="No">
	<cfargument name="regionCounty" type="string" required="No">
	<cfargument name="regionState" type="string" required="No">
	<cfargument name="regionStateAbbreviation" type="string" required="No">
	<cfargument name="regionCity" type="string" required="No">
	<cfargument name="regionName" type="string" required="No">
	<cfargument name="regionZipCode" type="string" required="No">
	<cfargument name="regionCountry" type="string" required="No">
	<cfargument name="regionStatus" type="numeric" required="No">
	<cfargument name="regionIsBundle" type="numeric" required="No">
	<cfargument name="regionInBundle" type="numeric" required="No">
	<cfargument name="regionAreaCode" type="string" required="No">
	<cfargument name="queryOrderBy" type="string" required="No" default="regionName">

	<cfset var qry_selectRegionList = QueryNew("blank")>

	<cfquery Name="qry_selectRegionList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT regionID, companyID, userID, regionName, regionCity, regionCounty, regionState, regionStateAbbreviation,
			regionZipCode, regionZipCodeMax, regionCountry, regionStatus, regionIsBundle, regionInBundle,
			regionDescription, regionAreaCode, regionLatitude, regionLongitude, regionGMToffset,
			regionDaylightSavings, regionDateCreated, regionDateUpdated
		FROM avRegion
		WHERE regionID <> 0
			<cfloop index="field" list="regionCounty,regionState,regionStateAbbreviation,regionCity,regionZipCode,regionCountry">
				<cfif StructKeyExists(Arguments, field)>AND #field# IN (<cfqueryparam value="#Arguments.field#" cfsqltype="cf_sql_varchar" list="yes">)</cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "regionName")>AND regionName LIKE <cfqueryparam value="%#Arguments.regionName#%" cfsqltype="cf_sql_varchar"></cfif>
			<cfloop index="field" list="regionStatus,regionBundle,regionInBundle">
				<cfif StructKeyExists(Arguments, field)>AND #field# = <cfqueryparam value="#Arguments[field]#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>
			</cfloop>
			<cfif StructKeyExists(Arguments, "regionID")>AND regionID IN (<cfqueryparam value="#Arguments.regionID#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
			<cfif StructKeyExists(Arguments, "regionAreaCode")>AND regionAreaCode IN (<cfqueryparam value="#Arguments.regionAreaCode#" cfsqltype="cf_sql_char" list="yes">)</cfif>
		ORDER BY
			<cfswitch expression="#Arguments.queryOrderBy#">
			<cfcase value="regionID,regionName,regionCity,regionCounty,regionState,regionStateAbbreviation,regionZipCode,regionCountry,regionAreaCode">#Arguments.queryOrderBy#</cfcase>
			<cfcase value="regionID_d,regionName_d,regionCity_d,regionCounty_d,regionState_d,regionStateAbbreviation_d,regionZipCode_d,regionCountry_d,regionAreaCode_d">#ListFirst(Arguments.queryOrderBy, "_")#</cfcase>
			<cfdefaultcase>ORDER BY regionName</cfdefaultcase>
			</cfswitch>
	</cfquery>

	<cfreturn qry_selectRegionList>
</cffunction>

</cfcomponent>

