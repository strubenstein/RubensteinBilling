<!--- 
4 options:
- Add a new subscription with an existing product
- Add a new subscription based on an existing subscription (copy)
- Add a new subscription with a "custom" product that does not exist
- Update an existing subscription, using the same product

If new subscription, let user choose between custom product and existing product.
--->

<cfparam Name="URL.subscriptionID" Default="0">
<cfinclude template="../../include/function/fn_datetime.cfm">
<cfset Variables.subscriptionDateFieldList = "subscriptionDateBegin,subscriptionDateEnd,subscriptionDateProcessNext">
<cfinclude template="../../view/v_subscription/var_subscriptionIntervalTypeList.cfm">
<!--- if new subscription, select existing product or enter custom product info --->

<cfif Variables.doAction is "updateSubscription" or URL.subscriptionID is not 0>
	<cfset URL.productID = qry_selectSubscription.productID>
<cfelseif Not IsDefined("URL.productID") or URL.productID is -1>
	<cfset Variables.urlParameters = "&subscriberID=#URL.subscriberID#">
	<cfset Variables.doAction = "listProducts">
	<cfset Variables.doControl = "product">
	<cfinclude template="../control.cfm">

	<cfinclude template="../../view/v_adminMain/footer_admin.cfm">
	<cfabort>
<cfelseif URL.productID is not 0>
	<cfif Not Application.fn_IsIntegerPositive(URL.productID)>
		<cflocation url="index.cfm?method=subscription.viewSubscriber&subscriberID=#URL.subscriberID#&error_subscription=invalidProduct" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="checkProductPermission" ReturnVariable="isProductPermission">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		</cfinvoke>

		<cfif isProductPermission is False>
			<cflocation url="index.cfm?method=subscription.viewSubscriber&subscriberID=#URL.subscriberID#&error_subscription=invalidProduct" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset displayProductParameter = False>
<cfset displayProductParameterException = False>
<cfset displayCustomPrice = False>
<cfset displayCustomPriceVolumeDiscount = False>
<cfset displayPriceQuantityMaximumPerCustomer = False>
<cfset displayPriceQuantityMaximumAllCustomers = False>
<!--- 
<cfset Variables.productID_customPriceRow = StructNew()>
<cfset Variables.productID_customPriceAmount = StructNew()>
--->

<!--- select product --->
<cfif URL.productID is not 0>
	<cfinclude template="act_insertSubscription_getProduct.cfm">
	<cfinclude template="act_insertSubscription_getPrices.cfm">
</cfif>

<!--- get users in company for contact --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="selectSubscriptionList" ReturnVariable="qry_selectSubscriptionList">
	<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
	<cfinvokeargument Name="subscriptionStatus" Value="1">
</cfinvoke>

<cfif Variables.doAction is "updateSubscription" or URL.subscriptionID is not 0>
	<!--- select existing contact users for company --->
	<cfinvoke Component="#Application.billingMapping#data.SubscriptionUser" Method="selectSubscriptionUser" ReturnVariable="qry_selectSubscriptionUser">
		<cfinvokeargument Name="subscriptionID" Value="#URL.subscriptionID#">
	</cfinvoke>
</cfif>

<cfinclude template="formParam_insertSubscription.cfm">
<cfinvoke component="#Application.billingMapping#data.Subscription" method="maxlength_Subscription" returnVariable="maxlength_Subscription" />
<cfinclude template="../../view/v_subscription/lang_insertSubscription.cfm">
<cfinclude template="../../include/function/fn_DisplayPrice.cfm">

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
	<cfinvokeargument name="targetID_formParam" value="#URL.subscriptionID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
	<cfinvokeargument name="targetID_formParam" value="#URL.subscriptionID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitSubscription")>
	<cfset productParameterOptionID_list = "">
	<cfset productParameterExceptionID = 0>
	<cfset productParameterExceptionPricePremium = 0>

	<cfinclude template="formValidate_insertSubscription.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- if updating existing subscription, make subscription inactive --->
		<cfif Variables.doAction is "updateSubscription">
			<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="updateSubscription" ReturnVariable="isSubscriptionUpdated">
				<cfinvokeargument Name="subscriptionID" Value="#URL.subscriptionID#">
				<cfinvokeargument Name="userID_cancel" Value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- insert new subscription --->
		<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="insertSubscription" ReturnVariable="newSubscriptionID">
			<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
			<cfinvokeargument Name="userID_author" Value="#Session.userID#">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="priceID" Value="#Form.priceID#">
			<cfif Form.priceID is not 0>
				<cfinvokeargument Name="priceStageID" Value="#qry_selectPriceListForTarget.priceStageID[ListFind(ValueList(qry_selectPriceListForTarget.priceID), Form.priceID)]#">
			</cfif>
			<cfinvokeargument Name="categoryID" Value="#Form.categoryID#">
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
			<cfinvokeargument Name="regionID" Value="#Form.regionID#">
			<cfif Variables.doAction is "insertSubscription">
				<cfinvokeargument Name="subscriptionID_parent" Value="0">
				<cfinvokeargument Name="subscriptionID_trend" Value="0">
				<cfinvokeargument Name="subscriptionAppliedCount" Value="0">
				<cfinvokeargument Name="subscriptionDateProcessLast" Value="">
			<cfelse>
				<cfinvokeargument Name="subscriptionID_parent" Value="#URL.subscriptionID#">
				<cfinvokeargument Name="subscriptionID_trend" Value="#qry_selectSubscription.subscriptionID_trend#">
				<cfinvokeargument Name="subscriptionOrder" Value="#qry_selectSubscription.subscriptionOrder#">
				<cfinvokeargument Name="subscriptionAppliedCount" Value="#qry_selectSubscription.subscriptionAppliedCount#">
				<cfinvokeargument Name="subscriptionDateProcessLast" Value="#qry_selectSubscription.subscriptionDateProcessLast#">
			</cfif>
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
			<cfinvokeargument Name="subscriptionDateBegin" Value="#Form.subscriptionDateBegin#">
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

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newSubscriptionID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#newSubscriptionID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
			<cfinvokeargument name="targetID" value="#newSubscriptionID#">
		</cfinvoke>

		<cfif Application.fn_IsUserAuthorized("viewSubscriptions")>
			<cflocation url="index.cfm?method=subscription.viewSubscriptions&subscriberID=#URL.subscriberID#&confirm_subscription=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cfif Variables.doAction is "updateSubscription">
				<cfset Variables.redirectVars = "&subscriptionID=#newSubscriptionID#">
			<cfelseif URL.productID is 0>
				<cfset Variables.redirectVars = "&productID=0">
			<cfelse>
				<cfset Variables.redirectVars = "">
			</cfif>

			<cflocation url="index.cfm?method=subscription.#Variables.doAction#&subscriberID=#URL.subscriberID##Variables.redirectVars#&confirm_subscription=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formName = "updateSubscription">
<cfset Variables.formAction = "index.cfm?method=subscription.#Variables.doAction#&subscriberID=#URL.subscriberID#&productID=#URL.productID#">
<cfif URL.subscriptionID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&subscriptionID=#URL.subscriptionID#">
</cfif>

<cfif Variables.doAction is "insertSubscription">
	<cfset Variables.formSubmitValue = Variables.lang_insertSubscription.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertSubscription.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_price/var_priceStageIntervalTypeList.cfm">
<cfinclude template="../../view/v_subscription/form_insertSubscription.cfm">
