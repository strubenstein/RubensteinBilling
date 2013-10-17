<cfobject Component="#Application.billingMapping#webservice.WebServiceFunction" Name="objWebServiceFunction">
<cfobject Component="#Application.billingMapping#webservice.WebServiceSecurity" Name="objWebServiceSecurity">
<cfobject Component="#Application.billingMapping#webservice.WebServiceSession" Name="objWebServiceSession">

<!--- Get database-specific SQL parameters --->
<cfset billingSql = StructNew()>

<cfswitch expression="#Application.billingDatabase#">
<cfcase value="MySQL">
	<cfinclude template="var_mysql.cfm">
</cfcase>
<cfcase value="Oracle">
	<cfinclude template="var_oracle.cfm">
</cfcase>
<cfcase value="DB2">
	<cfinclude template="var_db2.cfm">
</cfcase>
<cfdefaultcase><!--- MSSQLServer --->
	<cfinclude template="var_mssql.cfm">
</cfdefaultcase>
</cfswitch>

<cfif Application.billingCustomerDirectory is "">
	<cfset Variables.billingCustomerDirectoryPath = Application.billingFilePath>
	<cfset Variables.billingCustomerDirectoryInclude = "">
<cfelse>
	<cfset Variables.billingCustomerDirectoryPath = Application.billingFilePath & Application.billingFilePathSlash & Application.billingCustomerDirectory>
	<cfset Variables.billingCustomerDirectoryInclude = Application.billingCustomerDirectory & "/">
</cfif>

<cfif Application.billingPartnerDirectory is "">
	<cfset Variables.billingPartnerDirectoryPath = Application.billingFilePath>
	<cfset Variables.billingPartnerDirectoryInclude = "">
<cfelse>
	<cfset Variables.billingPartnerDirectoryPath = Application.billingFilePath & Application.billingFilePathSlash & Application.billingPartnerDirectory>
	<cfset Variables.billingPartnerDirectoryInclude = Application.billingPartnerDirectory & "/">
</cfif>

<cflock Scope="Application" Timeout="10">
	<cfset Application.billingSql = billingSql>
	<cfset Application.fn_convertCFdatepartToSQL = fn_convertCFdatepartToSQL>
	<cfset Application.billingTemplateDirectoryPath = Application.billingFilePath & Application.billingFilePathSlash & "include" & Application.billingFilePathSlash & "template">
	<cfset Application.billingCustomerDirectoryPath = Variables.billingCustomerDirectoryPath>
	<cfset Application.billingCustomerDirectoryInclude = Variables.billingCustomerDirectoryInclude>
	<cfset Application.billingPartnerDirectoryPath = Variables.billingPartnerDirectoryPath>
	<cfset Application.billingPartnerDirectoryInclude = Variables.billingPartnerDirectoryInclude>

	<cfset Application.objWebServiceSecurity = objWebServiceSecurity>
	<cfset Application.objWebServiceFunction = objWebServiceFunction>
	<cfset Application.objWebServiceSession = objWebServiceSession>
</cflock>

