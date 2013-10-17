<cfcomponent DisplayName="Company" Hint="Manages creating, updating, viewing and managing companies">

<cffunction name="maxlength_Company" access="public" output="no" returnType="struct">
	<cfset maxlength_Company = StructNew()>

	<cfset maxlength_Company.companyName = 255>
	<cfset maxlength_Company.companyDBA = 255>
	<cfset maxlength_Company.companyURL = 100>
	<cfset maxlength_Company.companyID_custom = 50>
	<cfset maxlength_Company.companyDirectory = 25>
	<cfset maxlength_Company.languageID = 5>

	<cfreturn maxlength_Company>
</cffunction>

<cffunction Name="insertCompany" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new company into database and returns companyID">
	<cfargument Name="userID" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyName" Type="string" Required="No" Default="">
	<cfargument Name="companyDBA" Type="string" Required="No" Default="">
	<cfargument Name="companyURL" Type="string" Required="No" Default="">
	<cfargument Name="languageID" Type="string" Required="No" Default="">
	<cfargument Name="companyPrimary" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyDirectory" Type="string" Required="No" Default="">
	<cfargument Name="companyStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="affiliateID" Type="numeric" Required="No" Default="0">
	<cfargument Name="cobrandID" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyID_custom" Type="string" Required="No" Default="">
	<cfargument Name="companyID_parent" Type="numeric" Required="Yes">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyIsExported" Type="string" Required="No" Default="">
	<cfargument Name="companyDateExported" Type="string" Required="No" Default="">

	<cfset var qry_insertCompany = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />

	<cfquery Name="qry_insertCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avCompany
		(
			userID, companyName, companyDBA, companyURL, languageID, companyPrimary, companyStatus,
			affiliateID, cobrandID, companyID_custom, companyID_parent, companyID_author, userID_author,
			companyIsAffiliate, companyIsCobrand, companyIsVendor, companyIsCustomer, companyIsTaxExempt,
			companyDirectory, companyIsExported, companyDateExported, companyDateCreated, companyDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyName#">,
			<cfqueryparam Value="#Arguments.companyDBA#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyDBA#">,
			<cfqueryparam Value="#Arguments.companyURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyURL#">,
			<cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.languageID#">,
			<cfqueryparam Value="#Arguments.companyPrimary#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.companyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyID_custom#">,
			<cfqueryparam Value="#Arguments.companyID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.companyIsAffiliate#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.companyIsCobrand#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.companyIsVendor#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.companyIsCustomer#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.companyIsTaxExempt#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyDirectory#">,
			<cfif Not ListFind("0,1", Arguments.companyIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.companyIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
			<cfif Not IsDate(Arguments.companyDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.companyDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "companyID", "ALL")#;
	</cfquery>

	<!--- for primary companies, create directory and default files if it does not already exist --->
	<!--- unless otherwise specified, directory is companyID + 3 random lower-case letters --->
	<cfif Arguments.companyPrimary is 0>
		<cfset Arguments.companyDirectory = "">
	<cfelseif Arguments.companyDirectory is not "" and Not DirectoryExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Arguments.companyDirectory)>
		<cfinvoke component="#Application.billingMapping#data.Company" Method="createCompanyDirectory" ReturnVariable="isCompanyDirectoryCreated">
			<cfinvokeargument Name="companyID" Value="#qry_insertCompany.primaryKeyID#">
			<cfinvokeargument Name="companyDirectory" Value="#Arguments.companyDirectory#">
		</cfinvoke>
	<cfelse>
		<cfset Arguments.companyDirectory = qry_insertCompany.primaryKeyID & Chr(RandRange(97,122)) & Chr(RandRange(97,122)) & Chr(RandRange(97,122))>
		<cfinvoke component="#Application.billingMapping#data.Company" Method="createCompanyDirectory" ReturnVariable="isCompanyDirectoryCreated">
			<cfinvokeargument Name="companyID" Value="#qry_insertCompany.primaryKeyID#">
			<cfinvokeargument Name="companyDirectory" Value="#Arguments.companyDirectory#">
		</cfinvoke>
	</cfif>

	<cfreturn qry_insertCompany.primaryKeyID>
</cffunction>

<cffunction Name="createCompanyDirectory" Access="public" Output="No" ReturnType="boolean" Hint="Create new directory for company">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="companyDirectory" Type="string" Required="Yes">

	<cfset var customerDirectoryPath = Application.billingCustomerDirectoryPath>
	<cfset var companyDirectoryPath = customerDirectoryPath & Application.billingFilePathSlash & Arguments.companyDirectory>
	<cfset var companyImageDirectoryPath = companyDirectoryPath & Application.billingFilePathSlash & Application.billingCustomerImageDirectory>
	<cfset var companyTempDirectoryPath = Application.billingTempPath & Application.billingFilePathSlash & Arguments.companyDirectory>

	<cfquery Name="qry_insertCompany_directory" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCompany
		SET companyID_author = companyID,
			companyDirectory = <cfqueryparam Value="#Arguments.companyDirectory#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyDirectory#">
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<!--- create company directory if it does not exist --->
	<cfif Not DirectoryExists(companyDirectoryPath)>
		<cfdirectory Action="Create" Mode="777" Directory="#companyDirectoryPath#">
	</cfif>

	<!--- create company index file to prevent directory browsing --->
	<cfif Not FileExists(companyDirectoryPath & Application.billingFilePathSlash & "index.cfm")>
		<cffile Action="Write" File="#companyDirectoryPath##Application.billingFilePathSlash#index.cfm"
			Output="<cfset blockDirectoryBrowsing = True>
<cflock Scope=""Session"" Timeout=""10"">
	<cfset Session.companyID_author = ""#Arguments.companyID#"">
	<cfset Session.companyDirectory = ""#Arguments.companyDirectory#"">
</cflock>
<cflocation url=""#Application.billingUrl#/"" AddToken=""No"">
">
	</cfif>

	<!--- create admin header file --->
	<cfif Not FileExists(companyDirectoryPath & Application.billingFilePathSlash & "header_admin.cfm")>
		<cffile Action="Copy" Source="#customerDirectoryPath##Application.billingFilePathSlash#header_admin.cfm" Destination="#companyDirectoryPath##Application.billingFilePathSlash#header_admin.cfm">
	</cfif>

	<!--- create admin footer file --->
	<cfif Not FileExists(companyDirectoryPath & Application.billingFilePathSlash & "footer_admin.cfm")>
		<cffile Action="Copy" Source="#customerDirectoryPath##Application.billingFilePathSlash#footer_admin.cfm" Destination="#companyDirectoryPath##Application.billingFilePathSlash#footer_admin.cfm">
	</cfif>

	<!--- 
	<!--- create public site header file --->
	<cfif Not FileExists(companyDirectoryPath & Application.billingFilePathSlash & "header_site.cfm")>
		<cffile Action="Copy" Source="#customerDirectoryPath##Application.billingFilePathSlash#header_site.cfm" Destination="#companyDirectoryPath##Application.billingFilePathSlash#header_site.cfm">
	</cfif>

	<!--- create public site footer file --->
	<cfif Not FileExists(companyDirectoryPath & Application.billingFilePathSlash & "footer_site.cfm")>
		<cffile Action="Copy" Source="#customerDirectoryPath##Application.billingFilePathSlash#footer_site.cfm" Destination="#companyDirectoryPath##Application.billingFilePathSlash#footer_site.cfm">
	</cfif>

	<!--- create public site navigation file --->
	<cfif Not FileExists(companyDirectoryPath & Application.billingFilePathSlash & "nav_site.cfm")>
		<cffile Action="Copy" Source="#customerDirectoryPath##Application.billingFilePathSlash#nav_site.cfm" Destination="#companyDirectoryPath##Application.billingFilePathSlash#nav_site.cfm">
	</cfif>
	--->

	<!--- create images subdirectory --->
	<cfif Not DirectoryExists(companyImageDirectoryPath)>
		<cfdirectory Action="Create" Mode="777" Directory="#companyImageDirectoryPath#">
	</cfif>

	<!--- create company image directory index file to prevent directory browsing --->
	<cfif Not FileExists(companyImageDirectoryPath & Application.billingFilePathSlash & "index.cfm")>
		<cffile Action="Write" File="#companyImageDirectoryPath##Application.billingFilePathSlash#index.cfm" Output="<cfset blockDirectoryBrowsing = True>">
	</cfif>

	<!--- create temp subdirectory for holding temporary import and export files --->
	<cfif Not DirectoryExists(companyTempDirectoryPath)>
		<cfdirectory Action="Create" Mode="777" Directory="#companyTempDirectoryPath#">
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction Name="updateCompany" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing company">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="companyName" Type="string" Required="No">
	<cfargument Name="companyDBA" Type="string" Required="No">
	<cfargument Name="companyURL" Type="string" Required="No">
	<cfargument Name="languageID" Type="string" Required="No">
	<cfargument Name="companyStatus" Type="numeric" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="affiliateID" Type="numeric" Required="No">
	<cfargument Name="cobrandID" Type="numeric" Required="No">
	<cfargument Name="companyIsExported" Type="string" Required="No">
	<cfargument Name="companyDateExported" Type="string" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />

	<cfquery Name="qry_updateCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avCompany
		SET
			<cfif StructKeyExists(Arguments, "userID") and IsNumeric(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "companyName")>companyName = <cfqueryparam Value="#Arguments.companyName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyName#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyDBA")>companyDBA = <cfqueryparam Value="#Arguments.companyDBA#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyDBA#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyURL")>companyURL = <cfqueryparam Value="#Arguments.companyURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyURL#">,</cfif>
			<cfif StructKeyExists(Arguments, "languageID")>languageID = <cfqueryparam Value="#Arguments.languageID#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.languageID#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyStatus") and ListFind("0,1", Arguments.companyStatus)>companyStatus = <cfqueryparam Value="#Arguments.companyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyID_custom")>companyID_custom = <cfqueryparam Value="#Arguments.companyID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Company.companyID_custom#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyIsAffiliate") and ListFind("0,1", Arguments.companyIsAffiliate)>companyIsAffiliate = <cfqueryparam Value="#Arguments.companyIsAffiliate#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyIsCobrand") and ListFind("0,1", Arguments.companyIsCobrand)>companyIsCobrand = <cfqueryparam Value="#Arguments.companyIsCobrand#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyIsVendor") and ListFind("0,1", Arguments.companyIsVendor)>companyIsVendor = <cfqueryparam Value="#Arguments.companyIsVendor#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyIsCustomer") and ListFind("0,1", Arguments.companyIsCustomer)>companyIsCustomer = <cfqueryparam Value="#Arguments.companyIsCustomer#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "companyIsTaxExempt") and ListFind("0,1", Arguments.companyIsTaxExempt)>companyIsTaxExempt = <cfqueryparam Value="#Arguments.companyIsTaxExempt#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerNonNegative(Arguments.affiliateID)>affiliateID = <cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerNonNegative(Arguments.cobrandID)>cobrandID = <cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "companyIsExported") and (Arguments.companyIsExported is "" or ListFind("0,1", Arguments.companyIsExported))>companyIsExported = <cfif Not ListFind("0,1", Arguments.companyIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.companyIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,</cfif>
			<cfif StructKeyExists(Arguments, "companyDateExported") and (Arguments.companyDateExported is "" or IsDate(Arguments.companyDateExported))>companyDateExported = <cfif Not IsDate(Arguments.companyDateExported)>NULL<cfelse><cfqueryparam Value="#CreateODBCDateTime(Arguments.companyDateExported)#" cfsqltype="cf_sql_timestamp"></cfif>,</cfif>
			companyDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectCompany" Access="public" Output="No" ReturnType="query" Hint="Selects existing company">
	<cfargument Name="companyID" Type="string" Required="Yes">

	<cfset var qry_selectCompany = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.companyID)>
		<cfset Arguments.companyID = 0>
	</cfif>

	<cfquery Name="qry_selectCompany" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avCompany.companyID, avCompany.userID, avCompany.companyName, avCompany.companyDBA, avCompany.companyURL,
			avCompany.languageID, avCompany.companyPrimary, avCompany.companyStatus, avCompany.affiliateID, avCompany.cobrandID,
			avCompany.companyID_custom, avCompany.companyID_parent, avCompany.companyID_author, avCompany.companyIsCustomer,
			avCompany.companyIsAffiliate, avCompany.companyIsCobrand, avCompany.companyIsVendor, avCompany.companyIsTaxExempt,
			avCompany.companyDirectory, avCompany.companyIsExported, avCompany.companyDateExported, 
			avCompany.companyDateCreated, avCompany.companyDateUpdated,
			avUser.firstName, avUser.lastName, avUser.userID_custom, avUser.email
		FROM avCompany LEFT OUTER JOIN avUser ON avCompany.userID = avUser.userID
		WHERE avCompany.companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectCompany>
</cffunction>

<cffunction Name="selectCompanyIDViaCustomID" Access="public" Output="No" ReturnType="string" Hint="Selects companyID of existing company via custom ID and returns companyID(s) if exists, 0 if not exists, and -1 if multiple companies have the same companyID_custom.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="companyID_custom" Type="string" Required="Yes">

	<cfset var qry_selectCompanyIDViaCustomID = QueryNew("blank")>

	<cfquery Name="qry_selectCompanyIDViaCustomID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT companyID
		FROM avCompany
		WHERE companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
			AND companyID_custom IN (<cfqueryparam Value="#Arguments.companyID_custom#" cfsqltype="cf_sql_varchar" List="Yes" Separator=",">)
	</cfquery>

	<cfif qry_selectCompanyIDViaCustomID.RecordCount is 0 or qry_selectCompanyIDViaCustomID.RecordCount lt ListLen(Arguments.companyID_custom)>
		<cfreturn 0>
	<cfelseif qry_selectCompanyIDViaCustomID.RecordCount gt ListLen(Arguments.companyID_custom)>
		<cfreturn -1>
	<cfelse>
		<cfreturn ValueList(qry_selectCompanyIDViaCustomID.companyID)>
	</cfif>
</cffunction>

<cffunction Name="selectCompanySummary" Access="public" Output="No" ReturnType="query" Hint="Selects existing company summary">
	<cfargument Name="companyID" Type="numeric" Required="Yes">

	<cfset var qry_selectCompanySummary = QueryNew("blank")>

	<cfquery Name="qry_selectCompanySummary" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT
			(SELECT COUNT(companyID) FROM avUserCompany WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">) AS companyUserCount,
			(SELECT COUNT(companyID) FROM avInvoice WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"> AND invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS companyInvoiceCount,
			(SELECT SUM(invoiceTotal) FROM avInvoice WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"> AND invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS companyInvoiceTotalSum,
			(SELECT SUM(invoiceTotalLineItem) FROM avInvoice WHERE companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"> AND invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS companyInvoiceTotalLineItemSum,
			(SELECT SUM(avInvoiceLineItem.invoiceLineItemQuantity) FROM avInvoice, avInvoiceLineItem WHERE avInvoice.invoiceID = avInvoiceLineItem.invoiceID AND avInvoice.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"> AND avInvoice.invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS companyInvoiceLineItemQuantitySum,
			(SELECT COUNT(productID) FROM avProduct WHERE productID IN 
				(SELECT DISTINCT(avInvoiceLineItem.productID) FROM avInvoice, avInvoiceLineItem WHERE avInvoice.invoiceID = avInvoiceLineItem.invoiceID AND avInvoice.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"> AND avInvoice.invoiceClosed = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)
				) AS companyInvoiceLineItemProductUniqueCount,
			(SELECT COUNT(avPriceTarget.targetID) FROM avPrice, avPriceTarget WHERE avPrice.priceID = avPriceTarget.priceID AND avPriceTarget.primaryTargetID = <cfqueryparam Value="#Application.fn_GetPrimaryTargetID("companyID")#" cfsqltype="cf_sql_integer"> AND avPriceTarget.targetID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"> AND avPrice.priceStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS companyPriceCount,
			(SELECT COUNT(companyID_target) FROM avNote WHERE companyID_target = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">) AS companyNoteCount,
			(SELECT COUNT(companyID_target) FROM avTask WHERE companyID_target = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"> AND taskCompleted = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS companyTaskCountCompleted,
			(SELECT COUNT(companyID_target) FROM avTask WHERE companyID_target = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer"> AND taskCompleted = <cfqueryparam Value="10" cfsqltype="#Application.billingSql.cfSqlType_bit#">) AS companyTaskCountNotCompleted,
			(SELECT COUNT(avCompany.affiliateID) FROM avCompany, avAffiliate WHERE avCompany.affiliateID = avAffiliate.affiliateID AND avAffiliate.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">) AS companyAffiliateCompanyCount,
			(SELECT COUNT(avCompany.cobrandID) FROM avCompany, avCobrand WHERE avCompany.cobrandID = avCobrand.cobrandID AND avCobrand.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">) AS companyCobrandCompanyCount,
			(SELECT COUNT(avProduct.vendorID) FROM avProduct, avVendor WHERE avProduct.vendorID = avVendor.vendorID AND avVendor.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">) AS companyVendorProductCount,
			(SELECT SUM(invoiceLineItemQuantity) FROM avInvoiceLineItem WHERE productID IN 
				(SELECT avProduct.productID FROM avProduct, avVendor WHERE avProduct.vendorID = avVendor.vendorID AND avVendor.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">)
				) AS companyVendorProductSoldCount,
			(SELECT SUM(invoiceLineItemTotal) FROM avInvoiceLineItem WHERE productID IN 
				(SELECT avProduct.productID FROM avProduct, avVendor WHERE avProduct.vendorID = avVendor.vendorID AND avVendor.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">)
				) AS companyVendorProductSoldTotal
	</cfquery>

	<cfreturn qry_selectCompanySummary>
</cffunction>

<cffunction Name="selectUserCompanyList_company" Access="public" Output="No" ReturnType="query" Hint="Select users which are part of or have permission for this company">
	<cfargument Name="companyID" Type="numeric" Required="Yes">
	<cfargument Name="userCompanyStatus" Type="numeric" Required="No">
	<cfargument Name="userIsPrimaryContact" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectUserCompanyList_company = QueryNew("blank")>

	<cfquery Name="qry_selectUserCompanyList_company" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avUserCompany.userID, avUserCompany.userCompanyStatus,
			avUserCompany.userCompanyDateCreated, avUserCompany.userCompanyDateUpdated,
			avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom
		FROM avUserCompany, avUser
			<cfif Arguments.userIsPrimaryContact is True>, avCompany</cfif>
		WHERE avUserCompany.userID = avUser.userID
			<cfif Arguments.userIsPrimaryContact is True>
				AND avUserCompany.companyID = avCompany.companyID
				AND avUserCompany.userID = avCompany.userID
			</cfif>
			AND avUserCompany.companyID = <cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "userCompanyStatus") and ListFind("0,1", Arguments.userCompanyStatus)>
				AND avUserCompany.userCompanyStatus = <cfqueryparam Value="#Arguments.userCompanyStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avUser.lastName, avUser.firstName
	</cfquery>

	<cfreturn qry_selectUserCompanyList_company>
</cffunction>

<cffunction Name="checkCompanyPermission" Access="public" Output="No" ReturnType="boolean" Hint="Validate user has permission for company(s)">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="companyID" Type="string" Required="Yes">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">

	<cfset var qry_checkCompanyPermission = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.companyID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkCompanyPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT userID_author, companyID_author
			FROM avCompany
			WHERE companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif Arguments.companyID_author is not Application.billingSuperuserCompanyID>
					AND companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
				<cfelse>
					AND (companyID_author = <cfqueryparam Value="#Arguments.companyID_author#" cfsqltype="cf_sql_integer">
						OR companyPrimary = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">)
				</cfif>
				<cfif Arguments.userID_author is not 0>
					AND userID_author = <cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)
						and StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
					AND (
						cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						OR
						affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
						)
				<cfelseif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>
					AND cobrandID IN (<cfqueryparam Value="#Arguments.cobrandID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfelseif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
					AND affiliateID IN (<cfqueryparam Value="#Arguments.affiliateID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				</cfif>
		</cfquery>

		<cfif qry_checkCompanyPermission.RecordCount is 0 or qry_checkCompanyPermission.RecordCount is not ListLen(Arguments.companyID)>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

<!--- functions for viewing list of companies --->
<cffunction Name="selectCompanyList" Access="public" ReturnType="query" Hint="Select list of companies">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="companyStatus" Type="numeric" Required="No">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="companyHasName" Type="numeric" Required="No">
	<cfargument Name="companyHasDBA" Type="numeric" Required="No">
	<cfargument Name="companyHasURL" Type="numeric" Required="No">
	<cfargument Name="companyHasUser" Type="numeric" Required="No">
	<cfargument Name="companyIsActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="companyHasMultipleUsers" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomID" Type="numeric" Required="No">
	<cfargument Name="companyPrimary" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="companyID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="companyName" Type="string" Required="No">
	<cfargument Name="companyDBA" Type="string" Required="No">
	<cfargument Name="companyURL" Type="string" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="city" Type="string" Required="No">
	<cfargument Name="state" Type="string" Required="No">
	<cfargument Name="county" Type="string" Required="No">
	<cfargument Name="zipCode" Type="string" Required="No">
	<cfargument Name="country" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="companyIsExported" Type="string" Required="No">
	<cfargument Name="companyDateExported_from" Type="string" Required="No">
	<cfargument Name="companyDateExported_to" Type="string" Required="No">
	<cfargument Name="queryOrderBy" Type="string" Required="No" Default="lastName">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="No" Default="0">
	<cfargument Name="queryPage" Type="numeric" Required="No" Default="1">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">

	<cfset var displayOr = "">
	<cfset var searchTextEscaped = "">
	<cfset var queryParameters_orderBy = "">
	<cfset var queryParameters_orderBy_noTable = "">
	<cfset var qry_selectCompanyList = QueryNew("blank")>

	<cfswitch Expression="#Arguments.queryOrderBy#">
	  <cfcase value="companyID,companyName,companyDBA,companyURL,affiliateID,cobrandID,languageID,companyID_parent,companyDateCreated,companyDateUpdated">
		<cfset queryParameters_orderBy = "avCompany.#Arguments.queryOrderBy#">
	  </cfcase>
	  <cfcase value="companyID_d,companyName_d,companyDBA_d,companyURL_d,affiliateID_d,cobrandID_d,languageID_d,companyID_parent_d,companyDateCreated_d,companyDateUpdated_d">
		<cfset queryParameters_orderBy = "avCompany.#ListFirst(Arguments.queryOrderBy, '_')# DESC">
	  </cfcase>
	  <cfcase value="companyPrimary,companyStatus,companyIsAffiliate,companyIsCobrand,companyIsVendor,companyIsCustomer,companyIsTaxExempt">
		<cfset queryParameters_orderBy = "avCompany.#Arguments.queryOrderBy# DESC">
	  </cfcase>
	  <cfcase value="companyPrimary_d,companyStatus_d,companyIsAffiliate_d,companyIsCobrand_d,companyIsVendor_d,companyIsCustomer_d,companyIsTaxExempt_d">
		<cfset queryParameters_orderBy = "avCompany.#ListFirst(Arguments.queryOrderBy, '_')#">
	  </cfcase>
	  <cfcase value="companyID_custom"><cfset queryParameters_orderBy  = "avCompany.companyID_custom"></cfcase>
	  <cfcase value="companyID_custom_d"><cfset queryParameters_orderBy  = "avCompany.companyID_custom DESC"></cfcase>
	  <cfcase value="lastName"><cfset queryParameters_orderBy = "avUser.lastName, avUser.firstName"></cfcase>
	  <cfcase value="lastName_d"><cfset queryParameters_orderBy = "avUser.lastName DESC, avUser.firstName DESC"></cfcase>
	  <cfdefaultcase><cfset queryParameters_orderBy = "avCompany.companyName"></cfdefaultcase>
	</cfswitch>

	<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
	<cfloop index="table" list="avUser,avCompany">
		<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
	</cfloop>

	<cfquery Name="qry_selectCompanyList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT 
			<cfif Application.billingDatabase is "MSSQLServer">* FROM (SELECT row_number() OVER (ORDER BY #queryParameters_orderBy#) as rowNumber,</cfif>
			avCompany.companyID, avCompany.userID, avCompany.companyName, avCompany.companyDBA, avCompany.companyURL,
			avCompany.languageID, avCompany.companyPrimary, avCompany.companyStatus, avCompany.affiliateID, avCompany.cobrandID,
			avCompany.companyID_custom, avCompany.companyID_parent, avCompany.companyID_author, avCompany.companyIsAffiliate,
			avCompany.companyIsCobrand, avCompany.companyIsVendor, avCompany.companyIsCustomer, avCompany.companyIsTaxExempt,
			avCompany.companyDirectory, avCompany.companyIsExported, avCompany.companyDateExported,
			avCompany.companyDateCreated, avCompany.companyDateUpdated,
			avUser.firstName, avUser.lastName, avUser.userID_custom
		FROM avCompany LEFT OUTER JOIN avUser ON avCompany.userID = avUser.userID
		WHERE <cfinclude template="dataShared/qryWhere_selectCompanyList.cfm">
			<cfif StructKeyExists(Arguments, "queryFirstLetter") and Arguments.queryFirstLetter is not "">
				<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1>
					AND Left(avCompany.companyName, 1) < 'a'
				<cfelse><!--- letter --->
					AND (Left(avCompany.companyName, 1) >= '#UCase(Arguments.queryFirstLetter)#' OR Left(avCompany.companyName, 1) >= '#LCase(Arguments.queryFirstLetter)#')
				</cfif>
			</cfif>
		<cfif Application.billingDatabase is "MSSQLServer">
			) AS T
			<cfif Arguments.queryDisplayPerPage gt 0>WHERE rowNumber BETWEEN #IncrementValue(Arguments.queryDisplayPerPage * DecrementValue(Arguments.queryPage))# AND #Val(Arguments.queryDisplayPerPage * Arguments.queryPage)#</cfif>
			ORDER BY #queryParameters_orderBy_noTable#
		<cfelseif Arguments.queryDisplayPerPage gt 0 and Application.billingDatabase is "MySQL">
			ORDER BY #queryParameters_orderBy#
			LIMIT #DecrementValue(Arguments.queryPage) * Arguments.queryDisplayPerPage#, #Arguments.queryDisplayPerPage#
		</cfif>
	</cfquery>

	<cfreturn qry_selectCompanyList>
</cffunction>

<cffunction Name="selectCompanyCount" Access="public" ReturnType="numeric" Hint="Select total number of companies in list">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="companyStatus" Type="numeric" Required="No">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="companyHasName" Type="numeric" Required="No">
	<cfargument Name="companyHasDBA" Type="numeric" Required="No">
	<cfargument Name="companyHasURL" Type="numeric" Required="No">
	<cfargument Name="companyHasUser" Type="numeric" Required="No">
	<cfargument Name="companyIsActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="companyHasMultipleUsers" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomID" Type="numeric" Required="No">
	<cfargument Name="companyPrimary" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="companyID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="companyName" Type="string" Required="No">
	<cfargument Name="companyDBA" Type="string" Required="No">
	<cfargument Name="companyURL" Type="string" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="city" Type="string" Required="No">
	<cfargument Name="state" Type="string" Required="No">
	<cfargument Name="county" Type="string" Required="No">
	<cfargument Name="zipCode" Type="string" Required="No">
	<cfargument Name="country" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="companyIsExported" Type="string" Required="No">
	<cfargument Name="companyDateExported_from" Type="string" Required="No">
	<cfargument Name="companyDateExported_to" Type="string" Required="No">

	<cfset var qry_selectCompanyCount = QueryNew("blank")>

	<cfquery Name="qry_selectCompanyCount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(companyID) AS totalRecords
		FROM avCompany
		WHERE <cfinclude template="dataShared/qryWhere_selectCompanyList.cfm">
	</cfquery>

	<cfreturn qry_selectCompanyCount.totalRecords>
</cffunction>

<cffunction Name="selectCompanyList_alphabet" Access="public" ReturnType="query" Hint="Select the first letter in value of field by which list of companies is ordered">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="companyStatus" Type="numeric" Required="No">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="companyHasName" Type="numeric" Required="No">
	<cfargument Name="companyHasDBA" Type="numeric" Required="No">
	<cfargument Name="companyHasURL" Type="numeric" Required="No">
	<cfargument Name="companyHasUser" Type="numeric" Required="No">
	<cfargument Name="companyIsActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="companyHasMultipleUsers" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomID" Type="numeric" Required="No">
	<cfargument Name="companyPrimary" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="companyID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="companyName" Type="string" Required="No">
	<cfargument Name="companyDBA" Type="string" Required="No">
	<cfargument Name="companyURL" Type="string" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="city" Type="string" Required="No">
	<cfargument Name="state" Type="string" Required="No">
	<cfargument Name="county" Type="string" Required="No">
	<cfargument Name="zipCode" Type="string" Required="No">
	<cfargument Name="country" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="companyIsExported" Type="string" Required="No">
	<cfargument Name="companyDateExported_from" Type="string" Required="No">
	<cfargument Name="companyDateExported_to" Type="string" Required="No">

	<cfset var qry_selectCompanyList_alphabet = QueryNew("blank")>

	<cfquery Name="qry_selectCompanyList_alphabet" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT DISTINCT(Left(companyName, 1)) AS firstLetter
		FROM avCompany
		WHERE <cfinclude template="dataShared/qryWhere_selectCompanyList.cfm">
		ORDER BY firstLetter
	</cfquery>

	<cfreturn qry_selectCompanyList_alphabet>
</cffunction>

<cffunction Name="selectCompanyList_alphabetPage" Access="public" ReturnType="numeric" Hint="Select page which includes the first record where the first letter in value of field by which list of companies is ordered">
	<cfargument Name="companyID_author" Type="string" Required="Yes">
	<cfargument Name="method" Type="string" Required="No" Default="">
	<cfargument Name="groupID" Type="string" Required="No">
	<cfargument Name="affiliateID" Type="string" Required="No">
	<cfargument Name="cobrandID" Type="string" Required="No">
	<cfargument Name="companyStatus" Type="numeric" Required="No">
	<cfargument Name="companyIsAffiliate" Type="numeric" Required="No">
	<cfargument Name="companyIsCobrand" Type="numeric" Required="No">
	<cfargument Name="companyIsVendor" Type="numeric" Required="No">
	<cfargument Name="companyIsCustomer" Type="numeric" Required="No">
	<cfargument Name="companyIsTaxExempt" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomPricing" Type="numeric" Required="No">
	<cfargument Name="companyHasName" Type="numeric" Required="No">
	<cfargument Name="companyHasDBA" Type="numeric" Required="No">
	<cfargument Name="companyHasURL" Type="numeric" Required="No">
	<cfargument Name="companyHasUser" Type="numeric" Required="No">
	<cfargument Name="companyIsActiveSubscriber" Type="numeric" Required="No">
	<cfargument Name="companyHasMultipleUsers" Type="numeric" Required="No">
	<cfargument Name="companyHasCustomID" Type="numeric" Required="No">
	<cfargument Name="companyPrimary" Type="numeric" Required="No">
	<cfargument Name="searchText" Type="string" Required="No">
	<cfargument Name="searchField" Type="string" Required="No">
	<cfargument Name="categoryID" Type="numeric" Required="No">
	<cfargument Name="productID" Type="numeric" Required="No">
	<cfargument Name="priceID" Type="numeric" Required="No">
	<cfargument Name="companyID_not" Type="string" Required="No">
	<cfargument Name="payflowID" Type="string" Required="No">
	<cfargument Name="companyName" Type="string" Required="No">
	<cfargument Name="companyDBA" Type="string" Required="No">
	<cfargument Name="companyURL" Type="string" Required="No">
	<cfargument Name="companyID_custom" Type="string" Required="No">
	<cfargument Name="city" Type="string" Required="No">
	<cfargument Name="state" Type="string" Required="No">
	<cfargument Name="county" Type="string" Required="No">
	<cfargument Name="zipCode" Type="string" Required="No">
	<cfargument Name="country" Type="string" Required="No">
	<cfargument Name="regionID" Type="string" Required="No">
	<cfargument Name="commissionID" Type="numeric" Required="No">
	<cfargument Name="commissionID_not" Type="numeric" Required="No">
	<cfargument Name="companyIsExported" Type="string" Required="No">
	<cfargument Name="companyDateExported_from" Type="string" Required="No">
	<cfargument Name="companyDateExported_to" Type="string" Required="No">
	<cfargument Name="queryDisplayPerPage" Type="numeric" Required="Yes">
	<cfargument Name="queryFirstLetter" Type="string" Required="No" Default="">

	<cfset var qry_selectCompanyList_alphabetPage = QueryNew("blank")>

	<cfquery Name="qry_selectCompanyList_alphabetPage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT COUNT(companyID) AS recordCountBeforeAlphabet
		FROM avCompany
		WHERE <cfinclude template="dataShared/qryWhere_selectCompanyList.cfm">
			<cfif Arguments.queryFirstLetter is "0-9" or Len(Arguments.queryFirstLetter) gt 1 or Not REFind("[a-zA-Z]", Arguments.queryFirstLetter)>
				AND Left(companyName, 1) < 'a'
			<cfelse><!--- letter --->
				AND (Left(companyName, 1) < '#UCase(Arguments.queryFirstLetter)#' OR Left(companyName, 1) < '#LCase(Arguments.queryFirstLetter)#')
			</cfif>
	</cfquery>

	<cfreturn 1 + (qry_selectCompanyList_alphabetPage.recordCountBeforeAlphabet \ Arguments.queryDisplayPerPage)>
</cffunction>
<!--- /functions for viewing list of companies --->

<!--- Update Export Status --->
<cffunction Name="updateCompanyIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether company records have been exported. Returns True.">
	<cfargument Name="companyID" Type="string" Required="Yes">
	<cfargument Name="companyIsExported" Type="string" Required="Yes">

	<cfset var qry_updateCompanyIsExported = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.companyID) or (Arguments.companyIsExported is not "" and Not ListFind("0,1", Arguments.companyIsExported))>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_updateCompanyIsExported" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avCompany
			SET companyIsExported = <cfif Not ListFind("0,1", Arguments.companyIsExported)>NULL<cfelse><cfqueryparam Value="#Arguments.companyIsExported#" cfsqltype="#Application.billingSql.cfSqlType_bit#"></cfif>,
				companyDateExported = <cfif Not ListFind("0,1", Arguments.companyIsExported)>NULL<cfelse>#Application.billingSql.sql_nowDateTime#</cfif>
			WHERE companyID IN (<cfqueryparam Value="#Arguments.companyID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>
		<cfreturn True>
	</cfif>
</cffunction>

</cfcomponent>
