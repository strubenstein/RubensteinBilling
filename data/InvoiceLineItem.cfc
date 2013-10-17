<cfcomponent DisplayName="InvoiceLineItem" Hint="Manages inserting, updating, deleting and viewing invoice line items">

<cffunction name="maxlength_InvoiceLineItem" access="public" output="no" returnType="struct">
	<cfset var maxlength_InvoiceLineItem = StructNew()>

	<cfset maxlength_InvoiceLineItem.invoiceLineItemName = 255>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemDescription = 1000>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemQuantity = 4>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemPriceUnit = 4>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemPriceNormal = 4>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemSubTotal = 4>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemDiscount = 4>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemTotal = 4>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemTotalTax = 4>
	<cfset maxlength_InvoiceLineItem.invoiceLineItemProductID_custom = 50>

	<cfreturn maxlength_InvoiceLineItem>
</cffunction>

<cffunction Name="insertInvoiceLineItem" Access="public" Output="No" ReturnType="numeric" Hint="Insert line item for specified invoice">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemName" Type="string" Required="No" Default="">
	<cfargument Name="invoiceLineItemDescription" Type="string" Required="No" Default="">
	<cfargument Name="invoiceLineItemDescriptionHtml" Type="numeric" Required="No" Default="0">
	<cfargument Name="productID" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceID" Type="numeric" Required="No" Default="0">
	<cfargument Name="categoryID" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemQuantity" Type="numeric" Required="No" Default="1">
	<cfargument Name="invoiceLineItemPriceUnit" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemPriceNormal" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemSubTotal" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemDiscount" Type="numeric" Required="No" Default="0">
	<!--- <cfargument Name="invoiceLineItemTotal" Type="numeric" Required="No" Default="0"> --->
	<cfargument Name="invoiceLineItemTotalTax" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="invoiceLineItemProductIsBundle" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemProductInBundle" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_author" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemManual" Type="numeric" Required="No" Default="1">
	<cfargument Name="invoiceLineItemProductID_custom" Type="string" Required="No" Default="">
	<cfargument Name="productParameterExceptionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="regionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="userID_cancel" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemID_trend" Type="numeric" Required="No" Default="0">
	<cfargument Name="invoiceLineItemID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="subscriptionID" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceStageID" Type="numeric" Required="No" Default="0">
	<cfargument Name="priceVolumeDiscountID" Type="numeric" Required="No" Default="0">
	<cfargument Name="isUpdateInvoiceTotal" Type="boolean" Required="No" Default="True">
	<cfargument Name="invoiceLineItemDateBegin" Type="string" Required="No" Default="">
	<cfargument Name="invoiceLineItemDateEnd" Type="string" Required="No" Default="">
	<cfargument Name="userID" Type="string" Required="No" Default="">

	<cfset var invoiceLineItemID = 0>
	<cfset var primaryTargetID = 0>
	<cfset var qry_insertInvoiceLineItem = QueryNew("blank")>
	<cfset var qry_insertInvoiceLineItem_updateOrder_select = QueryNew("blank")>

	<cfif Not StructKeyExists(Arguments, "invoiceLineItemSubTotal") or Not IsNumeric(Arguments.invoiceLineItemSubTotal)>
		<cfset Arguments.invoiceLineItemSubTotal = (Arguments.invoiceLineItemPriceUnit * Arguments.invoiceLineItemQuantity) - Arguments.invoiceLineItemDiscount>
	</cfif>
	<cfset Arguments.invoiceLineItemTotal = Arguments.invoiceLineItemSubTotal + Arguments.invoiceLineItemTotalTax>

	<cfif Not StructKeyExists(Arguments, "invoiceLineItemPriceNormal") or Not IsNumeric(Arguments.invoiceLineItemPriceNormal)>
		<cfset Arguments.invoiceLineItemPriceNormal = Arguments.invoiceLineItemPriceUnit>
	</cfif>

	<cfinvoke component="#Application.billingMapping#data.InvoiceLineItem" method="maxlength_InvoiceLineItem" returnVariable="maxlength_InvoiceLineItem" />

	<cftransaction>
	<cfquery Name="qry_insertInvoiceLineItem" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avInvoiceLineItem
		(
			invoiceID, invoiceLineItemName, invoiceLineItemDescription, invoiceLineItemDescriptionHtml, productID,
			priceID, priceStageID, priceVolumeDiscountID, categoryID, invoiceLineItemQuantity, invoiceLineItemPriceNormal,
			invoiceLineItemPriceUnit, invoiceLineItemSubTotal, invoiceLineItemDiscount, invoiceLineItemTotal, invoiceLineItemTotalTax,
			invoiceLineItemOrder, invoiceLineItemStatus, invoiceLineItemProductIsBundle, invoiceLineItemProductInBundle, userID_author,
			invoiceLineItemManual, invoiceLineItemProductID_custom, productParameterExceptionID, regionID, userID_cancel,
			invoiceLineItemID_trend, invoiceLineItemID_parent, subscriptionID, invoiceLineItemDateBegin, invoiceLineItemDateEnd,
			invoiceLineItemDateCreated, invoiceLineItemDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceLineItemName#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_InvoiceLineItem.invoiceLineItemName#">,
			<cfqueryparam Value="#Arguments.invoiceLineItemDescription#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_InvoiceLineItem.invoiceLineItemDescription#">,
			<cfqueryparam Value="#Arguments.invoiceLineItemDescriptionHtml#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.productID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.priceStageID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.priceVolumeDiscountID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.categoryID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceLineItemQuantity#" cfsqltype="cf_sql_decimal" Scale="#maxlength_InvoiceLineItem.invoiceLineItemQuantity#">,
			<cfqueryparam Value="#Arguments.invoiceLineItemPriceNormal#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceLineItemPriceUnit#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceLineItemSubTotal#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceLineItemDiscount#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceLineItemTotal#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceLineItemTotalTax#" cfsqltype="cf_sql_money">,
			<cfqueryparam Value="#Arguments.invoiceLineItemOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.invoiceLineItemStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.invoiceLineItemProductIsBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.invoiceLineItemProductInBundle#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.userID_author#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceLineItemManual#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.invoiceLineItemProductID_custom#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_InvoiceLineItem.invoiceLineItemProductID_custom#">,
			<cfqueryparam Value="#Arguments.productParameterExceptionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.regionID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceLineItemID_trend#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.invoiceLineItemID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">,
			<cfif Not StructKeyExists(Arguments, "invoiceLineItemDateBegin") or Not IsDate(Arguments.invoiceLineItemDateBegin)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceLineItemDateBegin#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfif Not StructKeyExists(Arguments, "invoiceLineItemDateEnd") or Not IsDate(Arguments.invoiceLineItemDateEnd)>NULL<cfelse><cfqueryparam Value="#Arguments.invoiceLineItemDateEnd#" cfsqltype="cf_sql_timestamp"></cfif>,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "invoiceLineItemID", "ALL")#;
	</cfquery>

	<cfset invoiceLineItemID = qry_insertInvoiceLineItem.primaryKeyID>
	<cfif Arguments.invoiceLineItemID_trend is 0>
		<cfquery Name="qry_insertInvoiceLineItem_trend" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avInvoiceLineItem
			SET invoiceLineItemID_trend = invoiceLineItemID
			WHERE invoiceLineItemID = <cfqueryparam Value="#invoiceLineItemID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>

	<cfif Application.fn_IsIntegerList(Arguments.userID) and Arguments.userID is not 0>
		<cfquery Name="qry_insertInvoiceLineItemUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avInvoiceLineItemUser (invoiceLineItemID, userID)
			SELECT #invoiceLineItemID#, userID
			FROM avUser
			WHERE userID IN (<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		</cfquery>
	<cfelseif Application.fn_IsIntegerPositive(Arguments.subscriptionID)>
		<cfquery Name="qry_copyInvoiceLineItemUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avInvoiceLineItemUser (invoiceLineItemID, userID)
			SELECT #invoiceLineItemID#, userID
			FROM avSubscriptionUser
			WHERE subscriptionID = <cfqueryparam Value="#Arguments.subscriptionID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>

	<cfif Arguments.invoiceLineItemOrder lte 0>
		<cfquery Name="qry_insertInvoiceLineItem_updateOrder_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT MAX(invoiceLineItemOrder) AS maxInvoiceLineItemOrder
			FROM avInvoiceLineItem
			WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery Name="qry_insertInvoiceLineItem_updateOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avInvoiceLineItem
			SET invoiceLineItemOrder = <cfqueryparam Value="1" cfsqltype="cf_sql_smallint"> + 
				<cfif Not IsNumeric(qry_insertInvoiceLineItem_updateOrder_select.maxInvoiceLineItemOrder)>
					<cfqueryparam Value="0" cfsqltype="cf_sql_smallint">
				<cfelse>
					<cfqueryparam Value="#qry_insertInvoiceLineItem_updateOrder_select.maxInvoiceLineItemOrder#" cfsqltype="cf_sql_smallint">
				</cfif>
			WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
				AND invoiceLineItemID = <cfqueryparam Value="#invoiceLineItemID#" cfsqltype="cf_sql_integer">
		</cfquery>
	<cfelse>
		<cfquery Name="qry_updateInvoiceLineItemOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avInvoiceLineItem
			SET invoiceLineItemOrder = invoiceLineItemOrder + <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
				AND invoiceLineItemID <> <cfqueryparam Value="#invoiceLineItemID#" cfsqltype="cf_sql_integer">
				AND invoiceLineItemOrder >= <cfqueryparam Value="#Arguments.invoiceLineItemOrder#" cfsqltype="cf_sql_smallint">
		</cfquery>
	</cfif>

	<!--- if updating existing line item, update targetID of notes,tasks,custom status and custom fields --->
	<cfif Arguments.invoiceLineItemID_parent is not 0>
		<cfset primaryTargetID = Application.fn_GetPrimaryTargetID("invoiceLineItemID")>
		<cfquery Name="qry_updateInvoiceLineItemID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avSalesCommissionInvoice
			SET invoiceLineItemID = <cfqueryparam Value="#invoiceLineItemID#" cfsqltype="cf_sql_integer">
			WHERE invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID_parent#" cfsqltype="cf_sql_integer">;

			<cfloop Index="tableName" List="avTask,avNote,avStatusHistory,avCustomFieldBit,avCustomFieldDateTime,avCustomFieldDecimal,avCustomFieldInt,avCustomFieldVarchar">
				UPDATE #tableName#
				SET targetID = <cfqueryparam Value="#invoiceLineItemID#" cfsqltype="cf_sql_integer">
				WHERE primaryTargetID = <cfqueryparam Value="#primaryTargetID#" cfsqltype="cf_sql_integer">
					AND targetID = <cfqueryparam Value="#Arguments.invoiceLineItemID_parent#" cfsqltype="cf_sql_integer">;
			</cfloop>
		</cfquery>
	</cfif>
	</cftransaction>

	<cfif Arguments.isUpdateInvoiceTotal is True>
		<cfinvoke component="#Application.billingMapping#data.Invoice" method="updateInvoiceTotal" returnVariable="invoiceTotal_new">
			<cfinvokeargument name="invoiceID" value="#Arguments.invoiceID#">
		</cfinvoke>
	</cfif>

	<cfreturn qry_insertInvoiceLineItem.primaryKeyID>
</cffunction>

<cffunction Name="updateInvoiceLineItem" Access="public" Output="No" ReturnType="boolean" Hint="Update status of line item for specified invoice to inactive">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="Yes">
	<cfargument Name="userID_cancel" Type="numeric" Required="No">
	<cfargument Name="isUpdateInvoiceTotal" Type="boolean" Required="No" Default="True">

	<cfset var qry_selectInvoiceLineItemOrder = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.InvoiceLineItem" method="maxlength_InvoiceLineItem" returnVariable="maxlength_InvoiceLineItem" />

	<cftransaction>
	<cfquery Name="qry_selectInvoiceLineItemOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT invoiceLineItemOrder, invoiceID
		FROM avInvoiceLineItem
		WHERE invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery Name="qry_updateInvoiceLineItem" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avInvoiceLineItem
		SET	
			<cfif StructKeyExists(Arguments, "userID_cancel") and Application.fn_IsIntegerNonNegative(Arguments.userID_cancel)>
				userID_cancel = <cfqueryparam Value="#Arguments.userID_cancel#" cfsqltype="cf_sql_integer">,
			</cfif>
			invoiceLineItemStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			invoiceLineItemOrder = <cfqueryparam Value="0" cfsqltype="cf_sql_smallint">,
			invoiceLineItemDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">;

		<cfif qry_selectInvoiceLineItemOrder.invoiceLineItemOrder is not 0>
			UPDATE avInvoiceLineItem
			SET invoiceLineItemOrder = invoiceLineItemOrder - <cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE invoiceID = <cfqueryparam Value="#qry_selectInvoiceLineItemOrder.invoiceID#" cfsqltype="cf_sql_integer">
				AND invoiceLineItemOrder > <cfqueryparam Value="#qry_selectInvoiceLineItemOrder.invoiceLineItemOrder#" cfsqltype="cf_sql_smallint">;
		</cfif>
	</cfquery>
	</cftransaction>

	<cfif Arguments.isUpdateInvoiceTotal is True>
		<cfinvoke component="#Application.billingMapping#data.Invoice" method="updateInvoiceTotal" returnVariable="invoiceTotal_new">
			<cfinvokeargument name="invoiceID" value="#qry_selectInvoiceLineItemOrder.invoiceID#">
		</cfinvoke>
	</cfif>

	<cfreturn True>
</cffunction>

<cffunction Name="updateInvoiceLineItemStatus" Access="public" Output="No" ReturnType="boolean" Hint="Updates all line items to inactive status for specified invoice">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemStatus" Type="numeric" Required="No" Default="0">

	<cfquery Name="qry_updateInvoiceLineItemStatus" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avInvoiceLineItem
		SET	invoiceLineItemStatus = <cfqueryparam Value="#Arguments.invoiceLineItemStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			invoiceLineItemDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectInvoiceLineItem" Access="public" Output="No" ReturnType="query" Hint="Select Existing Line Item for an Invoice">
	<cfargument Name="invoiceLineItemID" Type="string" Required="Yes">

	<cfset var qry_selectInvoiceLineItem = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.invoiceLineItemID)>
		<cfset Arguments.invoiceLineItemID = 0>
	</cfif>

	<cfquery Name="qry_selectInvoiceLineItem" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT invoiceID, invoiceLineItemID, invoiceLineItemName, invoiceLineItemDescription, invoiceLineItemDescriptionHtml,
			productID, priceID, priceStageID, priceVolumeDiscountID, categoryID, invoiceLineItemQuantity,
			invoiceLineItemPriceUnit, invoiceLineItemPriceNormal, invoiceLineItemSubTotal, invoiceLineItemDiscount,
			invoiceLineItemTotal, invoiceLineItemTotalTax, invoiceLineItemOrder, invoiceLineItemStatus,
			invoiceLineItemProductIsBundle, invoiceLineItemProductInBundle, invoiceLineItemManual,
			productParameterExceptionID, invoiceLineItemProductID_custom, userID_author, regionID, userID_cancel,
			invoiceLineItemID_parent, invoiceLineItemID_trend, subscriptionID, invoiceLineItemDateBegin,
			invoiceLineItemDateEnd, invoiceLineItemDateCreated, invoiceLineItemDateUpdated
		FROM avInvoiceLineItem
		WHERE invoiceLineItemID IN (<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
	</cfquery>

	<cfreturn qry_selectInvoiceLineItem>
</cffunction>

<cffunction Name="selectInvoiceLineItemUser" Access="public" Output="No" ReturnType="query" Hint="Select contact user(s) for existing line item(s).">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="False">

	<cfset var displayAnd = False>

	<cfquery Name="qry_selectInvoiceLineItemUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avInvoiceLineItemUser.invoiceLineItemID, avInvoiceLineItemUser.userID
			<cfif Arguments.returnUserFields is True>, avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom</cfif>
		FROM avInvoiceLineItemUser
			<cfif Arguments.returnUserFields is True>INNER JOIN avUser ON avInvoiceLineItemUser.userID = avUser.userID</cfif>
		<cfloop Index="field" List="invoiceLineItemID,userID">
			<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
				<cfif displayAnd is True> AND <cfelse> WHERE <cfset displayAnd = True></cfif>
				avInvoiceLineItemUser.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
		</cfloop>
		ORDER BY avInvoiceLineItemUser.invoiceLineItemID, 
			<cfif Arguments.returnUserFields is True>avUser.lastName, avUser.firstName,</cfif>
			avInvoiceLineItemUser.userID
	</cfquery>

	<cfreturn qry_selectInvoiceLineItemUser>
</cffunction>

<cffunction Name="selectInvoiceLineItemList" Access="public" Output="No" ReturnType="query" Hint="Select All or Specified Line Items for Existing Invoice">
	<cfargument Name="invoiceID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemID" Type="string" Required="No">
	<cfargument Name="invoiceLineItemStatus" Type="numeric" Required="No">

	<cfset var qry_selectInvoiceLineItemList = QueryNew("blank")>

	<cfquery Name="qry_selectInvoiceLineItemList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avInvoiceLineItem.invoiceLineItemID, avInvoiceLineItem.invoiceID, avInvoiceLineItem.invoiceLineItemName,
			avInvoiceLineItem.invoiceLineItemDescription, avInvoiceLineItem.invoiceLineItemDescriptionHtml,
			avInvoiceLineItem.productID, avInvoiceLineItem.priceID, avInvoiceLineItem.priceStageID,
			avInvoiceLineItem.priceVolumeDiscountID, avInvoiceLineItem.categoryID,
			avInvoiceLineItem.invoiceLineItemQuantity, avInvoiceLineItem.invoiceLineItemPriceUnit,
			avInvoiceLineItem.invoiceLineItemPriceNormal, avInvoiceLineItem.invoiceLineItemSubTotal,
			avInvoiceLineItem.invoiceLineItemDiscount, avInvoiceLineItem.invoiceLineItemTotal,
			avInvoiceLineItem.invoiceLineItemTotalTax, avInvoiceLineItem.invoiceLineItemOrder,
			avInvoiceLineItem.invoiceLineItemStatus, avInvoiceLineItem.userID_author, avInvoiceLineItem.subscriptionID,
			avInvoiceLineItem.invoiceLineItemManual, avInvoiceLineItem.regionID, avInvoiceLineItem.userID_cancel,
			avInvoiceLineItem.invoiceLineItemProductIsBundle, avInvoiceLineItem.invoiceLineItemProductInBundle,
			avInvoiceLineItem.productParameterExceptionID, avInvoiceLineItem.invoiceLineItemProductID_custom,
			avInvoiceLineItem.invoiceLineItemDateBegin, avInvoiceLineItem.invoiceLineItemDateEnd,
			avInvoiceLineItem.invoiceLineItemDateCreated, avInvoiceLineItem.invoiceLineItemDateUpdated,
			avInvoiceLineItem.invoiceLineItemID_parent, avInvoiceLineItem.invoiceLineItemID_trend,
			avProduct.vendorID, avProduct.productCode, avProduct.productID_custom, avProduct.productName,
			avProduct.productPrice, avProduct.productWeight, avProduct.productID_parent,
			AuthorUser.firstName AS authorFirstName, AuthorUser.lastName AS authorLastName, AuthorUser.userID_custom AS authorUserID_custom,
			CancelUser.firstName AS cancelFirstName, CancelUser.lastName AS cancelLastName, CancelUser.userID_custom AS cancelUserID_custom,
			avPriceStage.priceStageText, avPriceStage.priceStageDescription
		FROM avInvoiceLineItem
			LEFT OUTER JOIN avProduct ON avInvoiceLineItem.productID = avProduct.productID
			LEFT OUTER JOIN avUser AS AuthorUser ON avInvoiceLineItem.userID_author = AuthorUser.userID
			LEFT OUTER JOIN avUser AS CancelUser ON avInvoiceLineItem.userID_cancel = CancelUser.userID
			LEFT OUTER JOIN avPriceStage ON avInvoiceLineItem.priceStageID = avPriceStage.priceStageID
		WHERE avInvoiceLineItem.invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "invoiceLineItemID") and Application.fn_IsIntegerList(Arguments.invoiceLineItemID)>
				AND avInvoiceLineItem.invoiceLineItemID IN (<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "invoiceLineItemStatus") and ListFind("0,1", Arguments.invoiceLineItemStatus)>
				AND avInvoiceLineItem.invoiceLineItemStatus = <cfqueryparam Value="#Arguments.invoiceLineItemStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avInvoiceLineItem.invoiceLineItemStatus DESC, avInvoiceLineItem.invoiceLineItemOrder, avInvoiceLineItem.invoiceLineItemDateCreated
	</cfquery>

	<cfreturn qry_selectInvoiceLineItemList>
</cffunction>

<cffunction Name="switchInvoiceLineItemOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch order of existing invoice line items">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceLineItemOrder_direction" Type="string" Required="Yes">

	<cfset var qry_selectInvoiceLineItemOrder_switch = QueryNew("blank")>

	<cfquery Name="qry_switchInvoiceLineItemOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avInvoiceLineItem
		SET invoiceLineItemOrder = invoiceLineItemOrder 
			<cfif Arguments.invoiceLineItemOrder_direction is "moveInvoiceLineItemDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">;

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avInvoiceLineItem INNER JOIN avInvoiceLineItem AS avInvoiceLineItem2
			SET avInvoiceLineItem.invoiceLineItemOrder = avInvoiceLineItem.invoiceLineItemOrder 
				<cfif Arguments.invoiceLineItemOrder_direction is "moveInvoiceLineItemDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avInvoiceLineItem.invoiceLineItemOrder = avInvoiceLineItem2.invoiceLineItemOrder
				AND avInvoiceLineItem.invoiceID = avInvoiceLineItem2.invoiceID
				AND avInvoiceLineItem.invoiceLineItemStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND avInvoiceLineItem.invoiceLineItemID <> <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
				AND avInvoiceLineItem2.invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avInvoiceLineItem
			SET invoiceLineItemOrder = invoiceLineItemOrder 
				<cfif Arguments.invoiceLineItemOrder_direction is "moveInvoiceLineItemDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE invoiceLineItemStatus = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
				AND invoiceLineItemID <> <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
				AND invoiceID = (SELECT invoiceID FROM avInvoiceLineItem WHERE invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">)
				AND invoiceLineItemOrder = (SELECT invoiceLineItemOrder FROM avInvoiceLineItem WHERE invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>


<!--- Invoice Line Item Parameters --->
<cffunction Name="insertInvoiceLineItemParameter" Access="public" Output="No" ReturnType="boolean" Hint="Insert parameter option for a line item">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="Yes">
	<cfargument Name="productParameterOptionID" Type="string" Required="Yes">
	<cfargument Name="deleteExistingLineItemParameter" Type="boolean" Required="No" Default="True">

	<cfif Not Application.fn_IsIntegerList(Arguments.productParameterOptionID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_insertInvoiceLineItemParameter" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfif StructKeyExists(Arguments, "deleteExistingLineItemParameter") and Arguments.deleteExistingLineItemParameter is True>
				DELETE FROM avInvoiceLineItemParameter
				WHERE invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">;
			</cfif>

			INSERT INTO avInvoiceLineItemParameter (invoiceLineItemID, productParameterOptionID)
			SELECT <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">, productParameterOptionID
			FROM avProductParameterOption
			WHERE productParameterOptionID IN (<cfqueryparam Value="#Arguments.productParameterOptionID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				<cfif Not StructKeyExists(Arguments, "deleteExistingLineItemParameter") or Arguments.deleteExistingLineItemParameter is False>
					AND productParameterOptionID NOT IN (SELECT productParameterOptionID FROM avInvoiceLineItemParameter WHERE invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">)
				</cfif>;
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectInvoiceLineItemParameterList" Access="public" Output="No" ReturnType="query" Hint="Select parameter options for designated line item(s)">
	<cfargument Name="invoiceLineItemID" Type="string" Required="Yes">

	<cfset var qry_selectInvoiceLineItemParameterList = QueryNew("blank")>

	<cfif Not Application.fn_IsIntegerList(Arguments.invoiceLineItemID)>
		<cfset Arguments.invoiceLineItemID = 0>
	</cfif>

	<cfquery Name="qry_selectInvoiceLineItemParameterList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT invoiceLineItemID, productParameterOptionID
		FROM avInvoiceLineItemParameter
		WHERE invoiceLineItemID IN (<cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
		ORDER BY invoiceLineItemID
	</cfquery>

	<cfreturn qry_selectInvoiceLineItemParameterList>
</cffunction>

</cfcomponent>
