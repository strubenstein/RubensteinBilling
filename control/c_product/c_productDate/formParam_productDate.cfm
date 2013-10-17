<cfif Variables.doAction is "updateProductDate" and URL.productDateID gt 0>
	<cfset dateRow = ListFind(ValueList(qry_selectProductDateList.productDateID), URL.productDateID)>
	<cfset hour_ampm = fn_ConvertFrom24HourFormat(Hour(qry_selectProductDateList.productDateBegin[dateRow]))>

	<cfparam Name="Form.productDateBegin_date" Default="#DateFormat(qry_selectProductDateList.productDateBegin[dateRow], 'mm/dd/yyyy')#">
	<cfparam Name="Form.productDateBegin_hh" Default="#ListFirst(hour_ampm, '|')#">
	<cfparam Name="Form.productDateBegin_mm" Default="#Minute(qry_selectProductDateList.productDateBegin[dateRow])#">
	<cfparam Name="Form.productDateBegin_tt" Default="#ListLast(hour_ampm, '|')#">

	<cfif IsDate(qry_selectProductDateList.productDateEnd[dateRow])>
		<cfset hour_ampm = fn_ConvertFrom24HourFormat(Hour(qry_selectProductDateList.productDateEnd[dateRow]))>
		<cfparam Name="Form.productDateEnd_date" Default="#DateFormat(qry_selectProductDateList.productDateEnd[dateRow], 'mm/dd/yyyy')#">
		<cfparam Name="Form.productDateEnd_hh" Default="#ListFirst(hour_ampm, '|')#">
		<cfparam Name="Form.productDateEnd_mm" Default="#Minute(qry_selectProductDateList.productDateEnd[dateRow])#">
		<cfparam Name="Form.productDateEnd_tt" Default="#ListLast(hour_ampm, '|')#">
	</cfif>

	<cfparam Name="Form.productDateStatus" Default="#qry_selectProductDateList.productDateStatus[dateRow]#">
</cfif>

<cfparam Name="Form.productDateBegin_date" Default="">
<cfparam Name="Form.productDateBegin_hh" Default="12">
<cfparam Name="Form.productDateBegin_mm" Default="00">
<cfparam Name="Form.productDateBegin_tt" Default="am">
<cfparam Name="Form.productDateEnd_date" Default="">
<cfparam Name="Form.productDateEnd_hh" Default="12">
<cfparam Name="Form.productDateEnd_mm" Default="00">
<cfparam Name="Form.productDateEnd_tt" Default="am">
<cfparam Name="Form.productDateStatus" Default="0">

