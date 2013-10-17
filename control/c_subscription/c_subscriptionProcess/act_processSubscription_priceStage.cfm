<!--- initialize structure that stores list of price stages for each subscription --->
<cfset subscriptionID_priceStageIDList = StructNew()>
<cfloop Query="qry_selectSubscriptionList">
	<cfset subscriptionID_priceStageIDList["subscription#qry_selectSubscriptionList.subscriptionID#"] = 0>
</cfloop>

<!--- select custom prices for subscriptions that have multiple price stages --->
<cfif REFind("[1-9]", ValueList(qry_selectSubscriptionList.priceID))>
	<!--- for each subscription with a custom price, list price stages and determine dates and whether they apply to this billing period --->
	<cfset priceStageStruct = StructNew()>

	<cfloop Query="qry_selectSubscriptionList">
		<cfif qry_selectSubscriptionList.priceID is not 0>
			<cfset priceRow = ListFind(ValueList(qry_selectPriceList.priceID), qry_selectSubscriptionList.priceID)>
			<cfif priceRow is not 0>
				<cfset thisPriceID = qry_selectSubscriptionList.priceID>
				<cfset thisSubscriptionID = qry_selectSubscriptionList.subscriptionID>
				<cfset subscriptionRow = qry_selectSubscriptionList.CurrentRow>

				<cfloop Query="qry_selectPriceList" StartRow="#priceRow#">
					<cfif qry_selectPriceList.priceID is not thisPriceID><cfbreak></cfif>
					<!--- determine all price stages with date ranges--->
					<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"] = StructNew()>
					<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageRow = qry_selectPriceList.CurrentRow>
					<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageText = qry_selectPriceList.priceStageText>
					<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageIsInPeriod = True>

					<!--- if first stage, begin date is subscription begin date --->
					<cfif (priceRow - CurrentRow) is 0>
						<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageDateBegin = qry_selectSubscriptionList.subscriptionDateBegin[subscriptionRow]>
					<cfelse><!--- begin date is day after end date of previous stage --->
						<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageDateBegin = DateAdd("d", 1, priceStageStruct["priceStage#qry_selectPriceList.priceStageID[CurrentRow - 1]#"][CurrentRow - 1].priceStageDateBegin)>
						<!--- if begin date is after processing date, price stage is not in this billing period --->
						<cfif DateCompare(priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageDateBegin, qry_selectSubscriptionList.subscriptionDateProcessNext[subscriptionRow]) is 1>
							<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageIsInPeriod = False>
						</cfif>
					</cfif>

					<!--- if last or only price stage, max end date is earlier of processing date or subscription end date (if applicable) --->
					<cfif qry_selectPriceList.priceStageIntervalType is "" or qry_selectPriceList.priceStageInterval is 0>
						<!--- if subscription end date, use min of subscription end date and processing date --->
						<cfif IsDate(qry_selectSubscriptionList.subscriptionDateEnd[subscriptionRow]) and qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum[subscriptionRow] is 0>
							<cfset maxEndDate = CreateODBCDateTime(Min(qry_selectSubscriptionList.subscriptionDateEnd[subscriptionRow], qry_selectSubscriptionList.subscriptionDateProcessNext[subscriptionRow]))>
						<cfelse><!--- no subscription end date. so use processing date --->
							<cfset maxEndDate = qry_selectSubscriptionList.subscriptionDateProcessNext[subscriptionRow]>
						</cfif>

					<!--- not last stage; determine end date of next price stage, then compare to subscription/processing end date --->
					<cfelse>
						<cfset maxEndDate = DateAdd(qry_selectPriceList.priceStageIntervalType, qry_selectPriceList.priceStageInterval, priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageDateBegin)>
						<!--- if subscription end date, use min of price stage end date and subscription end date --->
						<cfif IsDate(qry_selectSubscriptionList.subscriptionDateEnd[subscriptionRow]) and qry_selectSubscriptionList.subscriptionEndByDateOrAppliedMaximum[subscriptionRow] is 0>
							<cfset maxEndDate = CreateODBCDateTime(Min(maxEndDate, qry_selectSubscriptionList.subscriptionDateEnd[subscriptionRow]))>
						</cfif>
						<!--- use min or current min end date (based on above) and processing date --->
						<cfset maxEndDate = CreateODBCDateTime(Min(maxEndDate, qry_selectSubscriptionList.subscriptionDateProcessNext[subscriptionRow]))>
					</cfif>

					<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageDateEnd = maxEndDate>

					<!--- if end date is before previous processing date, price stage is not in this billing period --->
					<cfif IsDate(qry_selectSubscriptionList.subscriptionDateProcessLast[subscriptionRow]) and DateCompare(priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageDateEnd, qry_selectSubscriptionList.subscriptionDateProcessLast[subscriptionRow]) is -1>
						<cfset priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageIsInPeriod = False>
					</cfif>

					<!--- if price stage is within this billing period, add to list of applicable price stage for this subscription --->
					<cfif priceStageStruct["priceStage#qry_selectPriceList.priceStageID#"].priceStageIsInPeriod is True>
						<cfif subscriptionID_priceStageIDList["subscription#thisSubscriptionID#"] is 0>
							<cfset subscriptionID_priceStageIDList["subscription#thisSubscriptionID#"] = qry_selectPriceList.priceStageID>
						<cfelse>
							<cfset subscriptionID_priceStageIDList["subscription#thisSubscriptionID#"] = ListAppend(subscriptionID_priceStageIDList["subscription#thisSubscriptionID#"], qry_selectPriceList.priceStageID)>
						</cfif>
					</cfif>
				</cfloop><!--- /loop thru price stages for custom price --->
			</cfif><!--- /if subscription custom price exists in query results --->
		</cfif><!--- /if subscription has custom price --->
	</cfloop><!--- /loop thru subscriptions --->
</cfif><!--- /if any custom prices --->

