<cfif REFind("[1-9]", ValueList(qry_selectSubscriptionList.priceID))>
	<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPrice" ReturnVariable="qry_selectPriceList">
		<cfinvokeargument Name="priceID" Value="#ValueList(qry_selectSubscriptionList.priceID)#">
	</cfinvoke>

	<cfif REFindNoCase("[1|y|t]", ValueList(qry_selectPriceList.priceStageVolumeDiscount))>
		<cfinvoke Component="#Application.billingMapping#data.PriceVolumeDiscount" Method="selectPriceVolumeDiscount" ReturnVariable="qry_selectPriceVolumeDiscount">
			<cfinvokeargument Name="priceStageID" Value="#ValueList(qry_selectPriceList.priceStageID)#">
		</cfinvoke>
	</cfif>

	<cfloop Index="unknownPriceRow" List="#Variables.priceStageIDwithoutPriceID#">
		<cfset knownPriceRow = ListFind(ValueList(qry_selectPriceList.priceID), qry_selectSubscriptionList.priceStageID[unknownPriceRow])>
		<cfif knownPriceRow is not 0>
			<cfset temp = QuerySetCell(qry_selectSubscriptionList, "priceID", qry_selectPriceList.priceID[knownPriceRow], unknownPriceRow)>
		</cfif>
	</cfloop>
</cfif>

