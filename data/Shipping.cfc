<cfcomponent DisplayName="Shipping" Hint="Manages creating and viewing shipments.">

<cffunction name="maxlength_Shipping" access="public" output="no" returnType="struct">
	<cfset var maxlength_Shipping = StructNew()>

	<cfset maxlength_Shipping.shippingCarrier = 50>
	<cfset maxlength_Shipping.shippingMethod = 100>
	<cfset maxlength_Shipping.shippingWeight = 2>
	<cfset maxlength_Shipping.shippingTrackingNumber = 50>
	<cfset maxlength_Shipping.shippingInstructions = 255>

	<cfreturn maxlength_Shipping>
</cffunction>

<cffunction Name="insertShipping" Access="public" Output="No" ReturnType="numeric" Hint="Inserts new shipping record and returns shippingID">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="shippingCarrier" Type="string" Required="Yes">
	<cfargument Name="shippingMethod" Type="string" Required="No" Default="">
	<cfargument Name="shippingWeight" Type="numeric" Required="No" Default="0">
	<cfargument Name="shippingTrackingNumber" Type="string" Required="No" Default="">
	<cfargument Name="shippingInstructions" Type="string" Required="No" Default="">
	<cfargument Name="shippingSent" Type="numeric" Required="No" Default="1">
	<cfargument Name="shippingDateSent" Type="string" Required="No">
	<cfargument Name="shippingReceived" Type="numeric" Required="No" Default="0">
	<cfargument Name="shippingDateReceived" Type="string" Required="No">
	<cfargument Name="shippingStatus" Type="numeric" Required="No" Default="1">

	<cfset var qry_insertShipping = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Shipping" method="maxlength_Shipping" returnVariable="maxlength_Shipping" />

	<cfquery Name="qry_insertShipping" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		INSERT INTO avShipping
		(
			userID, shippingCarrier, shippingMethod, shippingWeight, shippingTrackingNumber, shippingInstructions, shippingSent,
			shippingDateSent, shippingReceived, shippingDateReceived, shippingStatus, shippingDateCreated, shippingDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.shippingCarrier#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Shipping.shippingCarrier#">,
			<cfqueryparam Value="#Arguments.shippingMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Shipping.shippingMethod#">,
			<cfqueryparam Value="#Arguments.shippingWeight#" cfsqltype="cf_sql_decimal" Scale="#maxlength_Shipping.shippingWeight#">,
			<cfqueryparam Value="#Arguments.shippingTrackingNumber#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Shipping.shippingTrackingNumber#">,
			<cfqueryparam Value="#Arguments.shippingInstructions#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Shipping.shippingInstructions#">,
			<cfqueryparam Value="#Arguments.shippingSent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "shippingDateSent") or Not IsDate(Arguments.shippingDateSent)>NULL<cfelse><cfqueryparam Value="#Arguments.shippingDateSent#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.shippingReceived#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfif Not StructKeyExists(Arguments, "shippingDateReceived") or Not IsDate(Arguments.shippingDateReceived)>NULL<cfelse><cfqueryparam Value="#Arguments.shippingDateReceived#" cfsqltype="cf_sql_timestamp"></cfif>,
			<cfqueryparam Value="#Arguments.shippingStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "shippingID", "ALL")#;
	</cfquery>

	<cfreturn qry_insertShipping.primaryKeyID>
</cffunction>

<cffunction Name="insertShippingInvoice" Access="public" Output="No" ReturnType="boolean" Hint="Inserts record that shipment was for a particular invoice">
	<cfargument Name="shippingID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="string" Required="Yes">

	<cfif Not Application.fn_IsIntegerList(Arguments.invoiceID)>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_insertShippingInvoice" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			INSERT INTO avShippingInvoice (invoiceID, shippingID)
			SELECT invoiceID, <cfqueryparam Value="#Arguments.shippingID#" cfsqltype="cf_sql_integer">
			FROM avInvoice
			WHERE invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
				AND invoiceID NOT IN (SELECT invoiceID FROM avShippingInvoice WHERE shippingID = <cfqueryparam Value="#Arguments.shippingID#" cfsqltype="cf_sql_integer">)
		</cfquery>

		<cfreturn True>
	</cfif>
</cffunction>

<cffunction Name="selectShipping" Access="public" Output="No" ReturnType="query" Hint="Selects existing shipment for a given invoice">
	<cfargument Name="shippingID" Type="numeric" Required="Yes">

	<cfset var qry_selectShipping = QueryNew("blank")>

	<cfquery Name="qry_selectShipping" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT userID, shippingCarrier, shippingMethod, shippingWeight, shippingTrackingNumber, shippingInstructions, shippingSent,
			shippingDateSent, shippingReceived, shippingDateReceived, shippingStatus, shippingDateCreated, shippingDateUpdated
		FROM avShipping
		WHERE shippingID = <cfqueryparam Value="#Arguments.shippingID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn qry_selectShipping>
</cffunction>

<cffunction Name="selectShippingList" Access="public" Output="No" ReturnType="query" Hint="Selects existing shipments for a given invoice">
	<cfargument Name="invoiceID" Type="string" Required="Yes">
	<cfargument Name="shippingStatus" Type="numeric" Required="No">
	<cfargument Name="shippingSent" Type="numeric" Required="No">
	<cfargument Name="shippingReceived" Type="numeric" Required="No">

	<cfset var qry_selectShippingList = QueryNew("blank")>

	<cfquery Name="qry_selectShippingList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avShippingInvoice.shippingID, avShippingInvoice.invoiceID, avShipping.userID, avShipping.shippingCarrier, avShipping.shippingMethod,
			avShipping.shippingWeight, avShipping.shippingTrackingNumber, avShipping.shippingInstructions, avShipping.shippingSent, avShipping.shippingDateSent,
			avShipping.shippingReceived, avShipping.shippingDateReceived, avShipping.shippingStatus, avShipping.shippingDateCreated, avShipping.shippingDateUpdated
		FROM avShipping, avShippingInvoice
		WHERE avShippingInvoice.invoiceID IN (<cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfif StructKeyExists(Arguments, "shippingStatus") and ListFind("0,1", Arguments.shippingStatus)>
				AND avShipping.shippingStatus = <cfqueryparam Value="#Arguments.shippingStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingSent") and ListFind("0,1", Arguments.shippingSent)>
				AND avShipping.shippingSent = <cfqueryparam Value="#Arguments.shippingSent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingReceived") and ListFind("0,1", Arguments.shippingReceived)>
				AND avShipping.shippingReceived = <cfqueryparam Value="#Arguments.shippingReceived#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
		ORDER BY avShippingInvoice.shippingID DESC
	</cfquery>

	<cfreturn qry_selectShippingList>
</cffunction>

<cffunction Name="updateShipping" Access="public" Output="No" ReturnType="boolean" Hint="Updates existing shipment">
	<cfargument Name="shippingID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="shippingCarrier" Type="string" Required="Yes">
	<cfargument Name="shippingMethod" Type="string" Required="No">
	<cfargument Name="shippingWeight" Type="numeric" Required="No">
	<cfargument Name="shippingTrackingNumber" Type="string" Required="No">
	<cfargument Name="shippingInstructions" Type="string" Required="No">
	<cfargument Name="shippingSent" Type="numeric" Required="No">
	<cfargument Name="shippingDateSent" Type="string" Required="No">
	<cfargument Name="shippingReceived" Type="numeric" Required="No">
	<cfargument Name="shippingDateReceived" Type="string" Required="No">
	<cfargument Name="shippingStatus" Type="numeric" Required="No">

	<cfquery Name="qry_updateShipping" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avShipping
		SET 
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>
				userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingCarrier")>
				shippingCarrier = <cfqueryparam Value="#Arguments.shippingCarrier#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Shipping.shippingCarrier#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingMethod")>
				shippingMethod = <cfqueryparam Value="#Arguments.shippingMethod#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Shipping.shippingMethod#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingWeight") and IsNumeric(Arguments.shippingWeight)>
				shippingWeight = <cfqueryparam Value="#Arguments.shippingWeight#" cfsqltype="cf_sql_decimal" Scale="#maxlength_Shipping.shippingWeight#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingTrackingNumber")>
				shippingTrackingNumber = <cfqueryparam Value="#Arguments.shippingTrackingNumber#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Shipping.shippingTrackingNumber#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingInstructions")>
				shippingInstructions = <cfqueryparam Value="#Arguments.shippingInstructions#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Shipping.shippingInstructions#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingSent") and ListFind("0,1", Arguments.shippingSent)>
				shippingSent = <cfqueryparam Value="#Arguments.shippingSent#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingDateSent") and (Arguments.shippingDateSent is "" or IsDate(Arguments.shippingDateSent))>
				shippingDateSent = <cfif Not IsDate(Arguments.shippingDateSent)>NULL<cfelse><cfqueryparam Value="#Arguments.shippingDateSent#" cfsqltype="cf_sql_timestamp"></cfif>,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingReceived") and ListFind("0,1", Arguments.shippingReceived)>
				shippingReceived = <cfqueryparam Value="#Arguments.shippingReceived#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingDateReceived") and (Arguments.shippingDateReceived is "" or IsDate(Arguments.shippingDateReceived))>
				shippingDateReceived = <cfif Not IsDate(Arguments.shippingDateReceived)>NULL<cfelse><cfqueryparam Value="#Arguments.shippingDateReceived#" cfsqltype="cf_sql_timestamp"></cfif>,
			</cfif>
			<cfif StructKeyExists(Arguments, "shippingStatus") and ListFind("0,1", Arguments.shippingStatus)>
				shippingStatus = <cfqueryparam Value="#Arguments.shippingStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			</cfif>
			shippingDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE shippingID = <cfqueryparam Value="#Arguments.shippingID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="checkShippingPermission" Access="public" Output="No" ReturnType="boolean" Hint="Check that requested shipment is for specified invoice or line item.">
	<cfargument Name="shippingID" Type="numeric" Required="Yes">
	<cfargument Name="invoiceID" Type="numeric" Required="No">
	<cfargument Name="invoiceLineItemID" Type="numeric" Required="No">

	<cfset var qry_checkShippingPermission = QueryNew("blank")>

	<cfif Not StructKeyExists(Arguments, "invoiceID") and Not StructKeyExists(Arguments, "invoiceLineItemID")>
		<cfreturn False>
	<cfelse>
		<cfquery Name="qry_checkShippingPermission" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			SELECT shippingID
			FROM <cfif StructKeyExists(Arguments, "invoiceID")>avShippingInvoice<cfelse>avShippingInvoiceLineItem</cfif>
			WHERE shippingID = <cfqueryparam Value="#Arguments.shippingID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "invoiceID")>
				AND invoiceID = <cfqueryparam Value="#Arguments.invoiceID#" cfsqltype="cf_sql_integer">
			<cfelse>
				AND invoiceLineItemID = <cfqueryparam Value="#Arguments.invoiceLineItemID#" cfsqltype="cf_sql_integer">
			</cfif>
		</cfquery>

		<cfif qry_checkShippingPermission.RecordCount is 0>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cfif>
</cffunction>

</cfcomponent>

