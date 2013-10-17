<!--- 
Pricing Priority:
1 - this product (priceAppliesToProduct)
2 - parent product (priceAppliesToProductChildren)
3 - this category (priceAppliesToCategory)
4 - parent category (priceAppliesToCategoryChildren)
5 - all products (priceAppliesToAllProducts)
--->

<cfset Variables.currentPricePriority = 100>
<cfloop Query="qry_selectPriceList">
	<!--- price is for this product --->
	<cfif qry_selectPriceList.priceAppliesToProduct is 1 and qry_selectPriceList.productID is Variables.thisProductID>
		<cfset Variables.thisPricePriority = 1>
	<!--- price is for parent product --->
	<cfelseif qry_selectPriceList.priceAppliesToProductChildren is 1 and qry_selectPriceList.productID is Variables.thisProductID_parent>
		<cfset Variables.thisPricePriority = 2>
	<!--- price is for this category --->
	<cfelseif qry_selectPriceList.priceAppliesToCategory is 1 and qry_selectPriceList.categoryID is Variables.thisCategoryID>
		<cfset Variables.thisPricePriority = 3>
	<!--- price is for parent category --->
	<cfelseif qry_selectPriceList.priceAppliesToCategoryChildren is 1 and ListFind(Variables.thisCategoryID_parentList, qry_selectPriceList.categoryID)>
		<cfset Variables.thisPricePriority = 4>
	<!--- price is for all products --->
	<cfelseif qry_selectPriceList.priceAppliesToAllProducts is 1>
		<cfset Variables.thisPricePriority = 5>
	<cfelse>
		<cfset Variables.thisPricePriority = 100>
	</cfif>

	<cfif Variables.thisPricePriority lt Variables.currentPricePriority>
		<cfset Variables.currentPricePriority = Variables.thisPricePriority>
		<cfset Variables.productID_customPriceRow["product#Variables.thisProductID#"] = qry_selectPriceList.CurrentRow>

		<!--- determine custom price --->
		<cfswitch expression="#qry_selectPriceList.priceStageDollarOrPercent#_#qry_selectPriceList.priceStageNewOrDeduction#_#qry_selectPriceList.priceStageVolumeDiscount#">
		<cfcase value="0_0_0"><cfset Variables.thisPrice = qry_selectPriceList.priceStageAmount></cfcase>
		<cfcase value="0_1_0"><cfset Variables.thisPrice = Variables.thisProductPrice - qry_selectPriceList.priceStageAmount></cfcase>
		<cfcase value="1_0_0"><cfset Variables.thisPrice = Variables.thisProductPrice * qry_selectPriceList.priceStageAmount></cfcase>
		<cfcase value="1_1_0"><cfset Variables.thisPrice = Variables.thisProductPrice * (1 - qry_selectPriceList.priceStageAmount)></cfcase>
		<cfcase value="0_0_1"><cfset Variables.thisPrice = qry_selectPriceList.priceVolumeDiscountMinimum></cfcase>
		<cfcase value="0_1_1"><cfset Variables.thisPrice = Variables.thisProductPrice - qry_selectPriceList.priceVolumeDiscountMinimum></cfcase>
		<cfcase value="1_0_1"><cfset Variables.thisPrice = Variables.thisProductPrice * qry_selectPriceList.priceVolumeDiscountMinimum></cfcase>
		<cfcase value="1_1_1"><cfset Variables.thisPrice = Variables.thisProductPrice * (1 - qry_selectPriceList.priceVolumeDiscountMinimum)></cfcase>
		<cfdefaultcase><cfset Variables.thisPrice = Variables.thisProductPrice></cfdefaultcase>
		</cfswitch>

		<cfset Variables.productID_customPriceAmount["product#Variables.thisProductID#"] = Variables.thisPrice>
		<cfif Variables.thisPricePriority is 1>
			<cfbreak>
		</cfif>
	</cfif>
</cfloop>
