<cfinclude template="wslang_subscription.cfm">
<cfinclude template="../webserviceSession/wsact_checkWebServiceSession.cfm">
<cfif isWebServiceSessionActive is False>
	<cfset returnValue = -1>
<cfelseif Not Application.objWebServiceSession.isUserAuthorizedWS("insertSubscription", qry_selectWebServiceSession.webServiceSessionPermissionStruct, qry_selectWebServiceSession.companyID)>
	<cfset returnValue = -1>
	<cfset returnError = Variables.wslang_subscription.insertSubscription>
<cfelse>
	<cfloop Index="field" List="subscriptionContinuesAfterEnd,subscriptionQuantityVaries,subscriptionDescriptionHtml,subscriptionProRate">
		<cfset Arguments[field] = Application.fn_ConvertBooleanToNumeric(Arguments[field])>
	</cfloop>

	<cfset returnValue = 0>
	<!--- validate subscriber --->
	<cfset Arguments.subscriberID = Application.objWebServiceSecurity.ws_checkSubscriberPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriberID, Arguments.subscriberID_custom, Arguments.useCustomIDFieldList)>
	<cfif Arguments.subscriberID lte 0>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_subscription.invalidSubscriber>
	</cfif>

	<!--- validate product, custom price and product parameters --->
	<cfinclude template="../ws_invoice/wsact_validateProductForLineItem.cfm">

	<!--- validate contact user(s) --->
	<cfif returnValue is 0>
		<cfif ((Arguments.userID is 0 or Arguments.userID is "") and Not ListFind(Arguments.useCustomIDFieldList, "userID") and Not ListFind(Arguments.useCustomIDFieldList, "userID_custom"))
				or (Arguments.userID_custom is "" and (ListFind(Arguments.useCustomIDFieldList, "userID") or ListFind(Arguments.useCustomIDFieldList, "userID_custom")))>
			<cfset Arguments.userID = 0>
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
				<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
			</cfinvoke>

			<cfset Arguments.userID = Application.objWebServiceSecurity.ws_checkUserPermission(qry_selectWebServiceSession.companyID_author, Arguments.userID, Arguments.userID_custom, Arguments.useCustomIDFieldList, qry_selectSubscriber.companyID)>
			<cfif Arguments.userID is not 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_subscription.invalidUser>
			<cfelse>
				<!--- <cfset qry_selectUserCompanyList_company = QueryNew("userID")> --->
				<cfloop Index="thisUserID" List="#Arguments.userID#">
					<cfset temp = QueryAddRow(qry_selectUserCompanyList_company, 1)>
					<cfset temp = QuerySetCell(qry_selectUserCompanyList_company, "userID", ToString(thisUserID))>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>

	<!--- validate subscription rollup --->
	<cfif returnValue is 0>
		<cfif (Arguments.subscriptionID_rollup is 0 and Not ListFind(Arguments.useCustomIDFieldList, "subscriptionID_rollup") and Not ListFind(Arguments.useCustomIDFieldList, "subscriptionID_rollup_custom"))
				or (Arguments.subscriptionID_rollup_custom is "" and (ListFind(Arguments.useCustomIDFieldList, "subscriptionID_rollup") or ListFind(Arguments.useCustomIDFieldList, "subscriptionID_rollup_custom")))>
			<cfset Arguments.subscriptionID_rollup = 0>
		<cfelse>
			<cfset Arguments.subscriptionID_rollup = Application.objWebServiceSecurity.ws_checkSubscriptionPermission(qry_selectWebServiceSession.companyID_author, Arguments.subscriptionID_rollup, Arguments.subscriptionID_rollup_custom, Arguments.useCustomIDFieldList)>
			<cfif Arguments.subscriptionID_rollup is 0>
				<cfset returnValue = -1>
				<cfset returnError = Variables.wslang_subscription.rollupInvalidSubscription>
			<cfelse>
				<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscription" ReturnVariable="qry_selectSubscriptionList">
					<cfinvokeargument Name="subscriptionID" Value="#Arguments.subscriptionID_rollup#">
				</cfinvoke>

				<cfif qry_selectSubscriptionList.subscriberID is not Arguments.subscriberID>
					<cfset returnValue = -1>
					<cfset returnError = Variables.wslang_subscription.rollupWrongSubscriber>
				<cfelseif qry_selectSubscriptionList.subscriptionStatus is 0>
					<cfset returnValue = -1>
					<cfset returnError = Variables.wslang_subscription.rollupSubscriptionInactive>
				<cfelseif qry_selectSubscriptionList.subscriptionID_rollup is not 0>
					<cfset returnValue = -1>
					<cfset returnError = Variables.wslang_subscription.rollupSubscriptionNested>
				<cfelse>
					<cfset rollupRow = 1>
				</cfif>
			</cfif>
		</cfif>
	</cfif>

	<cfif returnValue is 0>
		<cfset Arguments.statusID = Application.objWebServiceSecurity.ws_checkStatusPermission(qry_selectWebServiceSession.companyID_author, Arguments.statusID, Arguments.statusID_custom, Arguments.useCustomIDFieldList, "subscriptionID")>
		<cfinvoke Component="#Application.billingMapping#data.Subscriber" Method="selectSubscriber" ReturnVariable="qry_selectSubscriber">
			<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
		</cfinvoke>		

		<!--- 
		<cfset Variables.displayProductParameter = False>
		<cfset Variables.displayProductParameterException = False>
		<cfset Variables.displayCustomPrice = False>
		<cfset Variables.displayCustomPriceVolumeDiscount = False>
		<cfset Variables.displayPriceQuantityMaximumPerCustomer = False>
		<cfset Variables.displayPriceQuantityMaximumAllCustomers = False>
		--->

		<cfset URL.subscriberID = Arguments.subscriberID>
		<cfset URL.productID = Arguments.productID>
		<cfset URL.subscriptionID = 0>

		<cfif Arguments.subscriptionDateProcessNext is "">
			<cfset Form.subscriptionDateProcessNext = qry_selectSubscriber.subscriberDateProcessNext>
		</cfif>

		<cfset Form = Arguments>
		<cfset Variables.doAction = "insertSubscription">

		<cfif Arguments.productID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProduct" ReturnVariable="qry_selectProduct">
				<cfinvokeargument Name="productID" Value="#Arguments.productID#">
			</cfinvoke>

			<cfinclude template="../../control/c_subscription/act_insertSubscription_getProduct.cfm">
			<cfinclude template="../../control/c_subscription/act_insertSubscription_getPrices.cfm">

			<!--- if real product, use product values as ilne item defaults unless otherwise specified --->
			<cfif Arguments.subscriptionName is "">
				<cfset Arguments.subscriptionName = qry_selectProductLanguage.productLanguageLineItemName>
			</cfif>
			<cfif Arguments.subscriptionDescription is "">
				<cfset Arguments.subscriptionDescription = qry_selectProductLanguage.productLanguageLineItemDescription>
			</cfif>
			<cfif Arguments.subscriptionDescriptionHtml is "">
				<cfset Arguments.subscriptionDescriptionHtml = qry_selectProductLanguage.productLanguageLineItemDescriptionHtml>
			</cfif>
			<cfif Arguments.subscriptionProductID_custom is "">
				<cfset Arguments.subscriptionProductID_custom = qry_selectProduct.productID_custom>
			</cfif>
			<cfif Not IsNumeric(Arguments.subscriptionPriceNormal)>
				<cfset Arguments.subscriptionPriceNormal = qry_selectProduct.productPrice>
			</cfif>
			<cfif Not IsNumeric(Arguments.subscriptionPriceUnit)>
				<cfset Arguments.subscriptionPriceUnit = qry_selectProduct.productPrice>
			</cfif>
		</cfif>

		<cfif Not IsDefined("fn_FormValidateDateTime")>
			<cfinclude template="../../include/function/fn_datetime.cfm">
		</cfif>
		<cfif Not IsDefined("fn_DisplayPriceAmount")>
			<cfinclude template="../../include/function/fn_DisplayPrice.cfm">
		</cfif>

		<cfset Variables.subscriptionDateFieldList = "subscriptionDateBegin,subscriptionDateEnd,subscriptionDateProcessNext">
		<cfinclude template="../../view/v_subscription/var_subscriptionIntervalTypeList.cfm">

		<cfinclude template="../../control/c_subscription/formParam_insertSubscription.cfm">
		<cfinvoke component="#Application.billingMapping#data.Subscription" method="maxlength_Subscription" returnVariable="maxlength_Subscription" />

		<cfset productParameterOptionID_list = "">
		<cfset productParameterExceptionID = 0>
		<cfset productParameterExceptionPricePremium = 0>

		<cfloop Index="field" List="subscriptionDateBegin,subscriptionDateEnd,subscriptionDateProcessNext">
			<cfif Not IsDate(Arguments[field])>
				<cfset Form["#field#_date"] = "">
				<cfset Form["#field#_hh"] = "12">
				<cfset Form["#field#_mm"] = "00">
				<cfset Form["#field#_tt"] = "am">
			<cfelse>
				<cfset hour_ampm = fn_ConvertFrom24HourFormat(Hour(Arguments[field]))>
				<cfset Form["#field#_date"] = DateFormat(Arguments[field], 'mm/dd/yyyy')>
				<cfset Form["#field#_hh"] = ListFirst(hour_ampm, '|')>
				<cfset Form["#field#_mm"] = Minute(Arguments[field])>
				<cfset Form["#field#_tt"] = ListLast(hour_ampm, '|')>
			</cfif>
		</cfloop>

		<cfinclude template="../../view/v_subscription/lang_insertSubscription.cfm">
		<cfinclude template="../../control/c_subscription/formValidate_insertSubscription.cfm">

		<!--- 
		<cfset Variables.multipleLineItem_priceStageVolumeStep = False>
		<cfset Variables.multipleLineItem_priceQuantityMaxPerCustomer = False>
		<cfset Variables.multipleLineItem_priceQuantityMaxAllCustomers = False>
		--->

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = -1>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<!--- insert new subscription --->
			<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="insertSubscription" ReturnVariable="newSubscriptionID">
				<cfinvokeargument Name="subscriberID" Value="#Arguments.subscriberID#">
				<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="priceID" Value="#Form.priceID#">
				<cfif Form.priceID is not 0>
					<cfinvokeargument Name="priceStageID" Value="#qry_selectPriceListForTarget.priceStageID[ListFind(ValueList(qry_selectPriceListForTarget.priceID), Form.priceID)]#">
				</cfif>
				<cfinvokeargument Name="categoryID" Value="0">
				<cfinvokeargument Name="subscriptionName" Value="#Form.subscriptionName#">
				<cfinvokeargument Name="subscriptionID_custom" Value="#Form.subscriptionID_custom#">
				<cfinvokeargument Name="subscriptionDescription" Value="#Form.subscriptionDescription#">
				<cfinvokeargument Name="subscriptionDescriptionHtml" Value="#Form.subscriptionDescriptionHtml#">
				<cfinvokeargument Name="subscriptionQuantity" Value="#Form.subscriptionQuantity#">
				<cfinvokeargument Name="subscriptionQuantityVaries" Value="#Form.subscriptionQuantityVaries#">
				<cfinvokeargument Name="subscriptionPriceUnit" Value="#Form.subscriptionPriceUnit#">
				<cfinvokeargument Name="subscriptionPriceNormal" Value="#Form.subscriptionPriceNormal#">
				<cfinvokeargument Name="subscriptionDiscount" Value="#Form.subscriptionDiscount#">
				<!--- <cfinvokeargument Name="subscriptionTotalTax" Value="#Form.subscriptionTotalTax#"> --->
				<cfinvokeargument Name="subscriptionStatus" Value="1">
				<cfinvokeargument Name="subscriptionProductID_custom" Value="#Form.subscriptionProductID_custom#">
				<cfinvokeargument Name="productParameterExceptionID" Value="#productParameterExceptionID#">
				<cfinvokeargument Name="regionID" Value="0">
				<!--- <cfif Variables.doAction is "insertSubscription"> --->
					<cfinvokeargument Name="subscriptionID_parent" Value="0">
					<cfinvokeargument Name="subscriptionID_trend" Value="0">
					<cfinvokeargument Name="subscriptionAppliedCount" Value="0">
					<cfinvokeargument Name="subscriptionDateProcessLast" Value="">
				<!--- 
				<cfelse>
					<cfinvokeargument Name="subscriptionID_parent" Value="#URL.subscriptionID#">
					<cfinvokeargument Name="subscriptionID_trend" Value="#qry_selectSubscription.subscriptionID_trend#">
					<cfinvokeargument Name="subscriptionOrder" Value="#qry_selectSubscription.subscriptionOrder#">
					<cfinvokeargument Name="subscriptionAppliedCount" Value="#qry_selectSubscription.subscriptionAppliedCount#">
					<cfinvokeargument Name="subscriptionDateProcessLast" Value="#qry_selectSubscription.subscriptionDateProcessLast#">
				</cfif>
				--->
				<cfswitch expression="#Form.subscriptionEndByDateOrAppliedMaximum#">
				  <cfcase value="0"><!--- ends by date --->
					<cfinvokeargument Name="subscriptionEndByDateOrAppliedMaximum" Value="0">
					<cfinvokeargument Name="subscriptionContinuesAfterEnd" Value="0">
					<cfinvokeargument Name="subscriptionAppliedMaximum" Value="0">
					<cfinvokeargument Name="subscriptionDateEnd" Value="#Form.subscriptionDateEnd#">
				  </cfcase>
				  <cfcase value="1"><!--- ends by applied maximum --->
					<cfinvokeargument Name="subscriptionEndByDateOrAppliedMaximum" Value="1">
					<cfinvokeargument Name="subscriptionContinuesAfterEnd" Value="0">
					<cfinvokeargument Name="subscriptionAppliedMaximum" Value="#Form.subscriptionAppliedMaximum#">
					<cfinvokeargument Name="subscriptionDateEnd" Value="">
				  </cfcase>
				  <cfdefaultcase><!--- continues indefinitely --->
					<cfif IsDate(Form.subscriptionDateEnd)><!--- use date --->
						<cfinvokeargument Name="subscriptionEndByDateOrAppliedMaximum" Value="0">
						<cfinvokeargument Name="subscriptionContinuesAfterEnd" Value="1">
						<cfinvokeargument Name="subscriptionDateEnd" Value="#Form.subscriptionDateEnd#">
						<cfinvokeargument Name="subscriptionAppliedMaximum" Value="0">
					<cfelseif IsNumeric(Form.subscriptionAppliedMaximum) and Form.subscriptionAppliedMaximum is not 0><!--- use max applied --->
						<cfinvokeargument Name="subscriptionEndByDateOrAppliedMaximum" Value="1">
						<cfinvokeargument Name="subscriptionContinuesAfterEnd" Value="1">
						<cfinvokeargument Name="subscriptionDateEnd" Value="">
						<cfinvokeargument Name="subscriptionAppliedMaximum" Value="#Form.subscriptionAppliedMaximum#">
					<cfelse>
						<cfinvokeargument Name="subscriptionEndByDateOrAppliedMaximum" Value="">
						<cfinvokeargument Name="subscriptionContinuesAfterEnd" Value="1">
						<cfinvokeargument Name="subscriptionDateEnd" Value="">
						<cfinvokeargument Name="subscriptionAppliedMaximum" Value="0">
					</cfif>
				  </cfdefaultcase>
				</cfswitch>
				<cfinvokeargument Name="subscriptionProRate" Value="#Form.subscriptionProRate#">
				<cfinvokeargument Name="subscriptionIntervalType" Value="#Form.subscriptionIntervalType#">
				<cfinvokeargument Name="subscriptionInterval" Value="#Form.subscriptionInterval#">
				<cfif IsDate(Form.subscriptionDateBegin)>
					<cfinvokeargument Name="subscriptionDateBegin" Value="#Form.subscriptionDateBegin#">
				<cfelse>
					<cfinvokeargument Name="subscriptionDateBegin" Value="#Now()#">
				</cfif>
				<cfinvokeargument Name="subscriptionDateProcessNext" Value="#Form.subscriptionDateProcessNext#">
				<cfinvokeargument Name="userID" Value="#Form.userID#">
				<cfinvokeargument Name="subscriptionID_rollup" Value="#Form.subscriptionID_rollup#">
			</cfinvoke>

			<!--- insert parameters --->
			<cfif displayProductParameter is True>
				<cfinvoke Component="#Application.billingMapping#data.SubscriptionParameter" Method="insertSubscriptionParameter" ReturnVariable="isSubscriptionParameterInserted">
					<cfinvokeargument Name="subscriptionID" Value="#newSubscriptionID#">
					<cfinvokeargument Name="productParameterOptionID" Value="#productParameterOptionID_list#">
					<cfinvokeargument Name="deleteExistingSubscriptionParameter" Value="True">
				</cfinvoke>
			</cfif>

			<!--- custom fields --->
			<cfif Trim(Arguments.customField) is not "">
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="subscriptionID">
					<cfinvokeargument Name="targetID" Value="#newSubscriptionID#">
					<cfinvokeargument Name="customField" Value="#Arguments.customField#">
				</cfinvoke>
			</cfif>

			<!--- custom status --->
			<cfif Arguments.statusID is not 0 or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")>
				<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
					<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="primaryTargetKey" Value="subscriptionID">
					<cfinvokeargument Name="targetID" Value="#newSubscriptionID#">
					<cfinvokeargument Name="useCustomIDFieldList" Value="#Arguments.useCustomIDFieldList#">
					<cfinvokeargument Name="statusID" Value="#Arguments.statusID#">
					<cfinvokeargument Name="statusID_custom" Value="#Arguments.statusID_custom#">
					<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
				</cfinvoke>
			</cfif>

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="insertSubscription">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="subscription">
				<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
				<cfinvokeargument name="targetID" value="#newSubscriptionID#">
			</cfinvoke>

			<cfset returnValue = newSubscriptionID>
		</cfif><!--- /all fields validated --->
	</cfif><!--- /subscriber, product and price are valid --->
</cfif><!--- /user is valid and has permission --->

<cfinclude template="../webserviceSession/wsact_updateWebServiceSession.cfm">

