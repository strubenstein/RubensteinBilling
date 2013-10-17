<cfquery Name="qry_selectPriceList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT DISTINCT(avPriceStage.priceStageID), avPriceStage.priceStageOrder, avPriceStage.priceStageAmount,
		avPriceStage.priceStageDollarOrPercent, avPriceStage.priceStageNewOrDeduction,
		avPriceStage.priceStageVolumeDiscount, avPriceStage.priceStageVolumeDollarOrQuantity,
		avPriceStage.priceStageVolumeStep, avPriceStage.priceStageInterval, avPriceStage.priceStageIntervalType,
		avPriceStage.priceStageText, avPriceStage.priceStageDescription,
		avPrice.priceID, avPrice.priceName, avPrice.categoryID, avPrice.productID,
		avPrice.priceAppliesToCategoryChildren, avPrice.priceAppliesToCategory,
		avPrice.priceAppliesToProduct, avPrice.priceAppliesToProductChildren,
		avPrice.priceAppliesToAllProducts, avPrice.priceAppliesToAllCustomers,
		avPrice.priceAppliesToInvoice, avPrice.priceCode, avPrice.priceCodeRequired,
		avPrice.priceAppliedStatus, avPrice.priceQuantityMinimumPerOrder,
		avPrice.priceQuantityMaximumAllCustomers, avPrice.priceQuantityMaximumPerCustomer,
		avPrice.priceHasMultipleStages, avPrice.priceStatus, avPrice.priceDateBegin, avPrice.priceDateEnd,

		CASE avPriceTarget.primaryTargetID
		WHEN #Application.fn_GetPrimaryTargetID("userID")# THEN 1
		WHEN #Application.fn_GetPrimaryTargetID("companyID")# THEN 2
		WHEN #Application.fn_GetPrimaryTargetID("groupID")# THEN 3
		WHEN #Application.fn_GetPrimaryTargetID("affiliateID")# THEN 4
		WHEN #Application.fn_GetPrimaryTargetID("cobrandID")# THEN 5
		WHEN #Application.fn_GetPrimaryTargetID("regionID")# THEN 6
		ELSE 7
		END
		AS priceTargetPriority

		<cfif StructKeyExists(Arguments, "returnPriceVolumeDiscountMinimum") and Arguments.returnPriceVolumeDiscountMinimum is True>
			,
			CASE avPriceStage.priceStageVolumeDiscount
			WHEN 0
				THEN NULL
			ELSE
				(
				SELECT priceVolumeDiscountID<!--- priceVolumeDiscountAmount --->
				FROM avPriceVolumeDiscount
				WHERE avPriceVolumeDiscount.priceStageID = avPriceStage.priceStageID
					AND avPriceVolumeDiscount.priceVolumeDiscountQuantityIsMaximum = 1
				)
			END
			AS priceVolumeDiscountID
		</cfif>
	FROM avPrice, avPriceStage, avPriceTarget
	WHERE avPrice.priceID = avPriceStage.priceID
		AND avPrice.priceID = avPriceTarget.priceID
		AND avPrice.priceStatus = 1
		AND avPrice.priceApproved = 1
		AND avPriceTarget.priceTargetStatus = 1
		<!--- 
		AND avPrice.priceDateBegin <= #CreateODBCDateTime(Now())#
		AND (avPrice.priceDateEnd IS NULL OR avPrice.priceDateEnd >= #CreateODBCDateTime(Now())#)
		--->
		AND avPrice.companyID = #Arguments.companyID_author#
		<cfif StructKeyExists(Arguments, "priceHasMultipleStages") and ListFind("0,1", Arguments.priceHasMultipleStages)>
			AND avPrice.priceHasMultipleStages = #Arguments.priceHasMultipleStages#
		</cfif>
		<cfif StructKeyExists(Arguments, "priceAppliesToInvoice") and Arguments.priceAppliesToInvoice is 1>
			AND avPrice.priceAppliesToInvoice = 1
		<cfelse>
			AND (
				avPrice.priceAppliesToAllProducts = 1
				<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerList(Arguments.categoryID)>
					OR avPrice.categoryID IN (#Arguments.categoryID#)
				</cfif>
				<cfif StructKeyExists(Arguments, "categoryID_parent") and Application.fn_IsIntegerList(Arguments.categoryID_parent)>
					OR (avPrice.categoryID IN (#Arguments.categoryID_parent#) AND avPrice.priceAppliesToCategoryChildren = 1)
				</cfif>
				<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
					OR avPrice.productID IN (#Arguments.productID#)
				</cfif>
				<cfif StructKeyExists(Arguments, "productID_parent") and Application.fn_IsIntegerList(Arguments.productID_parent)>
					OR (avPrice.productID IN (#Arguments.productID_parent#) AND avPrice.priceAppliesToProductChildren = 1)
				</cfif>
				)
		</cfif>
		AND (
			avPrice.priceAppliesToAllCustomers = 1
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerList(Arguments.userID)>
				OR (avPriceTarget.primaryTargetID = #Application.fn_GetPrimaryTargetID("userID")# AND avPriceTarget.targetID IN (#Arguments.userID#))
			</cfif>
			<cfif StructKeyExists(Arguments, "companyID") and Application.fn_IsIntegerList(Arguments.companyID)>
				OR (avPriceTarget.primaryTargetID = #Application.fn_GetPrimaryTargetID("companyID")# AND avPriceTarget.targetID IN (#Arguments.companyID#))
			</cfif>
			<cfif StructKeyExists(Arguments, "groupID") and Application.fn_IsIntegerList(Arguments.groupID)>
				OR (avPriceTarget.primaryTargetID = #Application.fn_GetPrimaryTargetID("groupID")# AND avPriceTarget.targetID IN (#Arguments.groupID#))
			</cfif>
			<cfif StructKeyExists(Arguments, "affiliateID") and Application.fn_IsIntegerList(Arguments.affiliateID)>
				OR (avPriceTarget.primaryTargetID = #Application.fn_GetPrimaryTargetID("affiliateID")# AND avPriceTarget.targetID IN (#Arguments.affiliateID#))
			</cfif>
			<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerList(Arguments.cobrandID)>
				OR (avPriceTarget.primaryTargetID = #Application.fn_GetPrimaryTargetID("cobrandID")# AND avPriceTarget.targetID IN (#Arguments.cobrandID#))
			</cfif>
			<cfif StructKeyExists(Arguments, "regionID") and Application.fn_IsIntegerList(Arguments.regionID)>
				OR (avPriceTarget.primaryTargetID = #Application.fn_GetPrimaryTargetID("regionID")# AND avPriceTarget.targetID IN (#Arguments.regionID#))
			</cfif>
			)
	ORDER BY priceTargetPriority,
			avPrice.priceAppliesToProduct DESC,
			avPrice.priceAppliesToProductChildren DESC,
			avPrice.priceAppliesToCategory DESC,
			avPrice.priceAppliesToCategoryChildren DESC,
			avPrice.priceAppliesToAllProducts DESC,
			avPrice.priceID,
			avPriceStage.priceStageOrder
</cfquery>

<cfif StructKeyExists(Arguments, "displayPriceVolumeDiscountMinimum") and Arguments.displayPriceVolumeDiscountMinimum is True>
	<cfif qry_selectPriceList.RecordCount is not 0>
		<cfloop Query="qry_selectPriceList">
			<cfif IsNumeric(qry_selectPriceList.priceVolumeDiscountID) and qry_selectPriceList.priceVolumeDiscountID is not 0>
				<cfset volumeList = ListAppend(volumeList, qry_selectPriceList.priceVolumeDiscountID)>
			</cfif>
		</cfloop>

		<cfif volumeList is not "">
			<cfquery Name="qry_selectPriceMinimum" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
				SELECT priceVolumeDiscountID, priceVolumeDiscountAmount
				FROM avPriceVolumeDiscount
				WHERE priceVolumeDiscountID IN (#volumeList#)
			</cfquery>

			<cfloop Query="qry_selectPriceList">
				<cfset volumeRow = ListFind(ValueList(qry_selectPriceMinimum.priceVolumeDiscountID), qry_selectPriceList.priceVolumeDiscountID)>
				<cfif volumeRow is 0>
					<cfset priceVolumeDiscountMinimumArray[CurrentRow] = "">
				<cfelse>
					<cfset priceVolumeDiscountMinimumArray[CurrentRow] = qry_selectPriceMinimum.priceVolumeDiscountAmount[volumeRow]>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	<cfset temp = QueryAddColumn(qry_selectPriceList, "priceVolumeDiscountMinimum", priceVolumeDiscountMinimumArray)>
</cfif>

