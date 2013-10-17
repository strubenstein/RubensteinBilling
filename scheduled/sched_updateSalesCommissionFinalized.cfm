<!--- 
Update salesCommissionFinalized, salesCommissionDateFinalized
for period-based sales commissions where the period is over
--->

<!--- generate date ranges for various periods --->
<!--- 
<cfset Variables.periodIntervalDateBegin = StructNew()>
<cfset Variables.periodIntervalDateEnd = StructNew()>

<cfset Variables.nowDate = DateAdd("ww", -1, Now())>
<cfset Variables.calcDate = DateAdd("d", 1 - DayOfWeek(Variables.nowDate), Variables.nowDate)>
<cfset Variables.periodIntervalDateBegin.ww = CreateDateTime(Year(Variables.calcDate), Month(Variables.calcDate), Day(Variables.calcDate), 00, 00, 00)>
<cfset Variables.calcDate = DateAdd("d", 6, Variables.periodIntervalDateBegin.ww)>
<cfset Variables.periodIntervalDateEnd.ww = CreateDateTime(Year(Variables.calcDate), Month(Variables.calcDate), Day(Variables.calcDate), 23, 59, 00)>

<cfset Variables.nowDate = DateAdd("m", -1, Now())>
<cfset Variables.periodIntervalDateBegin.m = CreateDateTime(Year(Variables.nowDate), Month(Variables.nowDate), 01, 00, 00, 00)>
<cfset Variables.periodIntervalDateEnd.m = CreateDateTime(Year(Variables.nowDate), Month(Variables.nowDate), DaysInMonth(Variables.nowDate), 23, 59, 00)>

<cfset Variables.nowDate = DateAdd("q", -1, Now())>
<cfset Variables.periodIntervalDateBegin.q = CreateDateTime(Year(Variables.nowDate), 1 + (3 * DecrementValue(Quarter(Variables.nowDate))), 01, 00, 00, 00)>
<cfset Variables.calcDate = DateAdd("m", 2, Variables.periodIntervalDateBegin.q)>
<cfset Variables.periodIntervalDateEnd.q = CreateDateTime(Year(Variables.nowDate), Month(Variables.calcDate), DaysInMonth(Variables.calcDate), 23, 59, 00)>

<cfset Variables.periodIntervalDateBegin.yyyy = CreateDateTime(Year(Now()) - 1, 01, 01, 00, 00, 00)>
<cfset Variables.periodIntervalDateEnd.yyyy = CreateDateTime(Year(Now()) - 1, 12, 31, 23, 59, 00)>
 --->

<cfquery Name="qry_updateSalesCommissionFinalized" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	UPDATE avSalesCommission
	SET salesCommissionFinalized = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
		salesCommissionDateFinalized = #Application.billingSql.sql_nowDateTime#
	WHERE salesCommissionFinalized = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND salesCommissionDateEnd IS NOT NULL
		AND salesCommissionDateEnd < <cfqueryparam Value="#CreateODBCDateTime(CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 00, 00))#" cfsqltype="cf_sql_timestamp">
</cfquery>

<!--- 
(
<cfloop Index="period" List="ww,m,q,yyyy">
	<cfif period is not "ww">OR</cfif>
	(
	salesCommissionDateBegin = <cfqueryparam Value="#CreateODBCDateTime(Variables.periodIntervalDateBegin[period])#" cfsqltype="cf_sql_timestamp">
	AND
	salesCommissionDateEnd = <cfqueryparam Value="#CreateODBCDateTime(Variables.periodIntervalDateEnd[period])#" cfsqltype="cf_sql_timestamp">
	)
</cfloop>
	)
--->
