<cfcomponent displayName="ViewFieldArchives">

<cffunction name="determineFieldArchiveTarget" access="public" output="no" returnType="struct">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<!--- <cfargument name="targetID" type="numeric" required="yes"> --->

	<cfset var archiveStruct = StructNew()>

	<cfset archiveStruct.fieldArchiveFieldList_boolean = "">
	<cfset archiveStruct.fieldArchiveFieldList_special = "">
	
	<cfswitch expression="#Arguments.primaryTargetKey#">
	<cfcase value="companyID">
		<!--- <cfset archiveStruct.targetID = URL.companyID> --->
		<cfset archiveStruct.fieldArchiveTableName = "avCompany">
		<cfset archiveStruct.fieldArchiveQuery = "qry_selectCompany">
		<cfset archiveStruct.fieldArchiveFieldList = "companyStatus,companyID_custom,companyName,companyDBA,companyURL,affiliateID,cobrandID,companyIsTaxExempt">
		<cfset archiveStruct.fieldArchiveFieldList_label = "Status,Custom ID,Company Name,DBA,URL,Affiliate,Cobrand,Tax Exempt Status">
		<cfset archiveStruct.fieldArchiveFieldList_boolean = "companyStatus,companyIsTaxExempt">
		<cfset archiveStruct.fieldArchiveFieldList_special = "affiliateID,cobrandID">
	</cfcase>
	
	<cfcase value="userID">
		<!--- <cfset archiveStruct.targetID = URL.userID> --->
		<cfset archiveStruct.fieldArchiveTableName = "avUser">
		<cfset archiveStruct.fieldArchiveQuery = "qry_selectUser">
		<cfset archiveStruct.fieldArchiveFieldList = "userStatus,userID_custom,username,firstName,middleName,lastName,email,suffix,salutation,jobTitle,jobDepartment,jobDivision">
		<cfset archiveStruct.fieldArchiveFieldList_label = "Status,Custom ID,Username,First Name,Middle Name,Last Name,Email,Suffix,Salutation,Job Title,Department,Division">
		<cfset archiveStruct.fieldArchiveFieldList_boolean = "userStatus">
	</cfcase>
	
	<cfcase value="affiliateID">
		<!--- <cfset archiveStruct.targetID = URL.affiliateID> --->
		<cfset archiveStruct.fieldArchiveTableName = "avAffiliate">
		<cfset archiveStruct.fieldArchiveQuery = "qry_selectAffiliate">
		<cfset archiveStruct.fieldArchiveFieldList = "affiliateStatus,affiliateName,affiliateID_custom,affiliateCode,affiliateURL">
		<cfset archiveStruct.fieldArchiveFieldList_label = "Status,Affiliate Name,Custom ID,Code,URL">
		<cfset archiveStruct.fieldArchiveFieldList_boolean = "affiliateStatus">
	</cfcase>
	
	<cfcase value="cobrandID">
		<!--- <cfset archiveStruct.targetID = URL.cobrandID> --->
		<cfset archiveStruct.fieldArchiveTableName = "avCobrand">
		<cfset archiveStruct.fieldArchiveQuery = "qry_selectCobrand">
		<cfset archiveStruct.fieldArchiveFieldList = "cobrandStatus,cobrandName,cobrandTitle,cobrandID_custom,cobrandCode,cobrandURL,cobrandDomain,cobrandDirectory,cobrandImage">
		<cfset archiveStruct.fieldArchiveFieldList_label = "Status,Cobrand Name,Title,Custom ID,Code,URL,Domain,Directory,Image">
		<cfset archiveStruct.fieldArchiveFieldList_boolean = "cobrandStatus">
	</cfcase>
	
	<cfcase value="vendorID">
		<!--- <cfset archiveStruct.targetID = URL.vendorID> --->
		<cfset archiveStruct.fieldArchiveTableName = "avVendor">
		<cfset archiveStruct.fieldArchiveQuery = "qry_selectVendor">
		<cfset archiveStruct.fieldArchiveFieldList = "vendorStatus,vendorName,vendorID_custom,vendorCode,vendorURL,vendorURLdisplay,vendorDescription,vendorDescriptionHtml,vendorDescriptionDisplay,vendorImage">
		<cfset archiveStruct.fieldArchiveFieldList_label = "Status,Vendor Name,Custom ID,Code,URL,Display URL?,Description,HTML Description?,Display Description?,Image">
		<cfset archiveStruct.fieldArchiveFieldList_boolean = "vendorStatus">
	</cfcase>
	
	<cfcase value="productID">
		<!--- <cfset archiveStruct.targetID = URL.productID> --->
		<!--- userID_manager,vendorID, productID_parent, productChildType,templateFilename --->
		<cfset archiveStruct.fieldArchiveTableName = "avProduct">
		<cfset archiveStruct.fieldArchiveQuery = "qry_selectProduct">
		<cfset archiveStruct.fieldArchiveFieldList = "productStatus,productListedOnSite,productCanBePurchased,productDisplayChildren,productName,productPrice,productPriceCallForQuote,productID_custom,productCode,productWeight,productCatalogPageNumber,productInWarehouse">
		<cfset archiveStruct.fieldArchiveFieldList_label = "Status,Listed On Site?,Can Be Purchased?,Display Children?,Product Name,Product Price,Call For Quote?,Custom ID,Code,Weight,Catalog Page,Is In Warehouse?">
		<cfset archiveStruct.fieldArchiveFieldList_boolean = "productStatus,productListedOnSite,productCanBePurchased,productDisplayChildren,productPriceCallForQuote,productInWarehouse">
	</cfcase>
	</cfswitch>

	<cfreturn archiveStruct>
</cffunction><!--- /determineFieldArchiveTarget --->

<cffunction name="viewFieldArchivesViaTarget" access="public" output="yes" returnType="boolean">
	<cfargument name="primaryTargetKey" type="string" required="yes">
	<cfargument name="targetID" type="numeric" required="yes">

	<cfset var fieldArchiveList_firstRow = StructNew()>
	<cfset var fieldArchiveList_rowCount = StructNew()>
	<cfset var fieldStruct = StructNew()>

	<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.ViewFieldArchives" method="determineFieldArchiveTarget" returnVariable="archiveStruct">
		<cfinvokeargument name="primaryTargetKey" value="#Arguments.primaryTargetKey#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.FieldArchive" Method="selectFieldArchiveList" ReturnVariable="qry_selectFieldArchiveList">
		<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)#">
		<cfinvokeargument Name="targetID" Value="#Arguments.targetID#">
		<cfinvokeargument Name="fieldArchiveTableName" Value="#archiveStruct.fieldArchiveTableName#">
	</cfinvoke>

	<cfloop Index="field" List="#archiveStruct.fieldArchiveFieldList#">
		<cfset fieldArchiveList_firstRow[field] = ListFind(ValueList(qry_selectFieldArchiveList.fieldArchiveFieldName), field)>
		<cfset fieldArchiveList_rowCount[field] = ListValueCount(ValueList(qry_selectFieldArchiveList.fieldArchiveFieldName), field)>
	</cfloop>

	<!--- if special values, get necessary data --->
	<cfloop Index="field" List="#archiveStruct.fieldArchiveFieldList_special#">
		<cfif fieldArchiveList_firstRow[field] is not 0>
			<cfset fieldStruct.fieldValueList = "">
			<cfloop Query="qry_selectFieldArchiveList" StartRow="#fieldArchiveList_firstRow[field]#" EndRow="#DecrementValue(fieldArchiveList_firstRow[field] + fieldArchiveList_rowCount[field])#">
				<cfset fieldStruct.fieldValueList = ListAppend(fieldStruct.fieldValueList, qry_selectFieldArchiveList.fieldArchiveValue)>
			</cfloop>

			<cfif fieldStruct.fieldValueList is not "">
				<cfswitch expression="#field#">
				<cfcase value="affiliateID">
					<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
						<cfinvokeargument Name="affiliateID" Value="#fieldStruct.fieldValueList#">
					</cfinvoke>
				</cfcase>
				<cfcase value="cobrandID">
					<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
						<cfinvokeargument Name="cobrandID" Value="#fieldStruct.fieldValueList#">
					</cfinvoke>
				</cfcase>
				</cfswitch>
			</cfif>
		</cfif>
	</cfloop>

	<cfset fieldStruct.columnHeaderList = "Field^Ver-<br>sion^Archived<br>Value^Date<br>Archived^User Who<br>Updated Value">
	<cfset fieldStruct.columnCount = DecrementValue(2 * ListLen(fieldStruct.columnHeaderList, "^"))>

	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
	<cfinclude template="../../view/v_fieldArchive/dsp_viewFieldArchivesViaTarget.cfm">

	<cfreturn True>
</cffunction>

</cfcomponent>
