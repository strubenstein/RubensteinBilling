<!--- Do any subscriptions have a variable quantity? --->
<cfset Variables.subscriberHasVariableQuantity = False>
<cfset Variables.priceStageIDwithoutPriceID = "">

<cfif REFindNoCase("[1|y|t]", ValueList(qry_selectSubscriptionList.subscriptionQuantityVaries))>
	<cfset Variables.subscriberHasVariableQuantity = True>

	<!--- if no subscriberProcessID, variable quantities have obviously not been entered: STOP --->
	<cfif Variables.subscriberProcessID is 0>
		<cfset Variables.isSubscriptionOkToProcess = False>

	<!--- if not all variable quantities have been entered, STOP --->
	<cfelseif qry_selectSubscriberProcessList.subscriberProcessAllQuantitiesEntered is 0>
		<cfset Variables.isSubscriptionOkToProcess = False>

	<!--- all is well. select variable quantities --->
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.SubscriptionProcess" Method="selectSubscriptionProcessList" ReturnVariable="qry_selectSubscriptionProcessList">
			<cfinvokeargument Name="subscriberProcessID" Value="#Variables.subscriberProcessID#">
		</cfinvoke>

		<cfif REFind("[1|y|t]", ValueList(qry_selectSubscriptionList.subscriptionCategoryMultiple))>
			<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
				<cfinvokeargument Name="companyID" Value="#Application.billingSuperuserCompanyID#">
			</cfinvoke>

			<cfset subscriptionRecordCount = qry_selectSubscriptionList.RecordCount>
			<cfloop Query="qry_selectSubscriptionList" StartRow="1" EndRow="#subscriptionRecordCount#">
				<cfif qry_selectSubscriptionList.subscriptionCategoryMultiple is 1>
					<cfset thisSubRow = qry_selectSubscriptionList.CurrentRow>
					<cfset thisSubID = qry_selectSubscriptionList.subscriptionID>
					<cfset firstSubRow = ListFind(ValueList(qry_selectSubscriptionProcessList.subscriptionID), qry_selectSubscriptionList.subscriptionID)>

					<cfif firstSubRow is not 0>
						<cfset Variables.subRowFieldList = "subscriberID,subscriptionID,userID_author,userID_cancel,subscriptionStatus,subscriptionCompleted,subscriptionDateBegin,subscriptionDateEnd,subscriptionAppliedMaximum,subscriptionAppliedCount,subscriptionIntervalType,subscriptionInterval,subscriptionID_parent,subscriptionID_trend,productID,regionID,subscriptionProductID_custom,subscriptionQuantity,subscriptionQuantityVaries,subscriptionOrder,subscriptionID_custom,subscriptionDescription,subscriptionDescriptionHtml,subscriptionPriceNormal,subscriptionPriceUnit,subscriptionDiscount,subscriptionDateProcessNext,subscriptionDateProcessLast,productParameterExceptionID,subscriptionProRate,subscriptionEndByDateOrAppliedMaximum,subscriptionContinuesAfterEnd,subscriptionIsRollup,subscriptionID_rollup,subscriptionCategoryMultiple,subscriptionDateCreated,subscriptionDateUpdated,vendorID,productCode,productID_custom,productName,productPrice,productWeight,authorFirstName,authorLastName,authorUserID_custom,cancelFirstName,cancelLastName,cancelUserID_custom">
						<cfset firstSubRowStruct = StructNew()>
						<cfloop Index="field" List="#Variables.subRowFieldList#">
							<cfset firstSubRowStruct[field] = Evaluate("qry_selectSubscriptionList.#field#")>
						</cfloop>

						<cfloop Query="qry_selectSubscriptionProcessList" StartRow="#IncrementValue(firstSubRow)#">
							<cfif qry_selectSubscriptionProcessList.subscriptionID is not thisSubID>
								<cfbreak>
							<cfelseif qry_selectSubscriptionProcessList.categoryID is not 0>
								<cfset catRow = ListFind(ValueList(qry_selectCategoryList.categoryID), qry_selectSubscriptionProcessList.categoryID)>
								<cfset temp = QueryAddRow(qry_selectSubscriptionList, 1)>

								<cfset temp = QuerySetCell(qry_selectSubscriptionList, "priceID", 0)>
								<cfset Variables.priceStageIDwithoutPriceID = ListAppend(Variables.priceStageIDwithoutPriceID, qry_selectSubscriptionProcessList.CurrentRow)>
								<cfset temp = QuerySetCell(qry_selectSubscriptionList, "priceStageID", qry_selectSubscriptionProcessList.priceStageID)>
								<cfset temp = QuerySetCell(qry_selectSubscriptionList, "categoryID", qry_selectSubscriptionProcessList.categoryID)>
								<cfset temp = QuerySetCell(qry_selectSubscriptionList, "subscriptionDescription", qry_selectSubscriptionList.subscriptionDescription[thisSubRow] & " - " & qry_selectCategoryList.categoryTitle[catRow])>
								<cfset temp = QuerySetCell(qry_selectSubscriptionList, "subscriptionName", qry_selectSubscriptionList.subscriptionName[thisSubRow] & " - " & qry_selectCategoryList.categoryTitle[catRow])>

								<cfloop Index="field" List="#Variables.subRowFieldList#">
									<cfset temp = QuerySetCell(qry_selectSubscriptionList, field, firstSubRowStruct[field])>
								</cfloop>
							</cfif><!--- if categoryID is not 0 --->
						</cfloop><!--- /loop thru variable-quantity subscriptions for subscription --->

						<!--- Set primary subscription row to the first category multiple subscription value to avoid a zero-quantity for it --->
						<cfset Variables.priceStageIDwithoutPriceID = ListAppend(Variables.priceStageIDwithoutPriceID, firstSubRow)>
						<cfset catRow = ListFind(ValueList(qry_selectCategoryList.categoryID), qry_selectSubscriptionProcessList.categoryID[firstSubRow])>
						<cfset temp = QuerySetCell(qry_selectSubscriptionList, "priceStageID", qry_selectSubscriptionProcessList.priceStageID[firstSubRow], thisSubRow)>
						<cfset temp = QuerySetCell(qry_selectSubscriptionList, "categoryID", qry_selectSubscriptionProcessList.categoryID[firstSubRow], thisSubRow)>
						<cfset temp = QuerySetCell(qry_selectSubscriptionList, "subscriptionDescription", qry_selectSubscriptionList.subscriptionDescription & " - " & qry_selectCategoryList.categoryTitle[catRow], thisSubRow)>
						<cfset temp = QuerySetCell(qry_selectSubscriptionList, "subscriptionName", qry_selectSubscriptionList.subscriptionName & " - " & qry_selectCategoryList.categoryTitle[catRow], thisSubRow)>
						<cfset firstSubRow = firstSubRow + 1>
					</cfif><!--- /if find variable-quantity subscriptions --->
				</cfif><!--- /if subscription has multiple category options --->
			</cfloop><!--- /loop thru subscriptions --->
		</cfif><!--- /if any subscriptions exist with multiple category options --->
	</cfif><!--- /if variable quantity subscription entered --->
</cfif><!--- /if subscription quantity varies --->
