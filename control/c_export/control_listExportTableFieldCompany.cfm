<cfinvoke Component="#Application.billingMapping#data.ExportTableFieldCompany" Method="selectExportTableFieldCompanyList" ReturnVariable="qry_selectExportTableFieldCompanyList">
	<cfinvokeargument Name="exportTableID" Value="#URL.exportTableID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="exportTableFieldStatus" Value="1">
</cfinvoke>

<!--- indicate which tables they have customized? --->
<cfset Variables.columnHeaderList = "Field Name^Primary<br>Key?^Type^Size^XML File<br>Field Name^Tab-Delimited<br>Header"><!--- ^HTML Header --->

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_export/dsp_selectExportTableFieldCompanyList.cfm">