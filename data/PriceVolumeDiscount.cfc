<cfcomponent DisplayName="PriceVolumeDiscount" Hint="Manages volume discount options for custom pricing">

<cffunction name="maxlength_PriceVolumeDiscount" access="public" output="no" returnType="struct">
	<cfset var maxlength_PriceVolumeDiscount = StructNew()>

	<cfset maxlength_PriceVolumeDiscount.priceVolumeDiscountQuantityMinimum = 4>
	<cfset maxlength_PriceVolumeDiscount.priceVolumeDiscountAmount = 4>

	<cfreturn maxlength_PriceVolumeDiscount>
</cffunction>

<cffunction Name="selectPriceVolumeDiscount" Access="public" Output="No" ReturnType="query" Hint="Select Existing Price Volume Discount">
	<cfargument Name="priceStageID" Type="string" Required="No">
	<cfargument Name="priceID" Type="string" Required="No">

	<cfset var qry_selectPriceVolumeDiscount = QueryNew("blank")>

	<cfif Not StructKeyExists(Arguments, "priceStageID") and Not StructKeyExists(Arguments, "priceID")>
		<cfset Arguments.priceStageID = 0>
	<cfelseif StructKeyExists(Arguments, "priceStageID") and Not Application.fn_IsIntegerList(Arguments.priceStageID)>
		<cfset Arguments.priceStageID = 0>
	<cfelseif StructKeyExists(Arguments, "priceID") and Not Application.fn_IsIntegerList(Arguments.priceID)>
		<cfset Arguments.priceStageID = 0>
	</cfif>

	<cfquery Name="qry_selectPriceVolumeDiscount" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT priceVolumeDiscountID, priceStageID,
			priceVolumeDiscountQuantityMinimum, priceVolumeDiscountQuantityIsMaximum,
			priceVolumeDiscountAmount, priceVolumeDiscountIsTotalPrice
		FROM avPriceVolumeDiscount
		WHERE 
			<cfif StructKeyExists(Arguments, "priceStageID")>
				priceStageID IN (<cfqueryparam Value="#Arguments.priceStageID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			<cfelse>
				priceStageID IN 
					(
					SELECT priceStageID
					FROM avPriceStage
					WHERE priceID IN (<cfqueryparam Value="#Arguments.priceID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
					)
			</cfif>
		ORDER BY priceStageID, priceVolumeDiscountQuantityIsMaximum, priceVolumeDiscountQuantityMinimum
	</cfquery>

	<cfreturn qry_selectPriceVolumeDiscount>
</cffunction>

</cfcomponent>
