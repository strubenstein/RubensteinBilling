<cfif Variables.doAction is "insertProduct">
	<cfset URL.productID = 0>
</cfif>

<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("productID")>
<cfset Variables.targetID = URL.productID>
<cfinclude template="../../include/function/fn_datetime.cfm">

<!--- Integrate Category, Language and Image tabs into Update Product --->
<cfif Application.fn_IsUserAuthorized("insertProductLanguage") and Application.fn_IsUserAuthorized("insertProductCategory") and Application.fn_IsUserAuthorized("insertImage")>
	<cfparam Name="URL.displayExtendedForm" Default="True">
<cfelse>
	<cfset URL.displayExtendedForm = False>
</cfif>

<cfif URL.displayExtendedForm is True>
	<cfset Variables.formAction = Variables.formAction & "&displayExtendedForm=#URL.displayExtendedForm#">
	<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="selectProductCategory" ReturnVariable="qry_selectProductCategory">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="productCategoryStatus" Value="1">
	</cfinvoke>

	<cfset Variables.categoryIsMultiple = False>
	<cfif URL.productID is not 0>
		<cfif qry_selectProductCategory.RecordCount gt 1>
			<cfset Variables.categoryIsMultiple = True>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="selectProductLanguage" ReturnVariable="qry_selectProductLanguage">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="languageID" Value="">
			<cfinvokeargument Name="productLanguageStatus" Value="1">
		</cfinvoke>

		<cfinvoke Component="#Application.billingMapping#data.Image" Method="selectImageList" ReturnVariable="qry_selectImage">
			<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
			<cfinvokeargument Name="targetID" Value="#URL.productID#">
			<cfinvokeargument Name="imageStatus" Value="1">
			<cfinvokeargument Name="imageOrder_from" Value="1">
			<cfinvokeargument Name="imageOrder_to" Value="1">
		</cfinvoke>
	</cfif>

	<cfinclude template="c_productCategory/formParam_productCategory.cfm">

	<cfinvoke component="#Application.billingMapping#data.ProductLanguage" method="maxlength_ProductLanguage" returnVariable="maxlength_ProductLanguage" />
	<cfinclude template="formParam_insertProductLanguage.cfm">

	<cfset Variables.urlParameters = "">
	<cfinclude template="../c_image/act_getCompanyImageDirectory.cfm">
	<cfinclude template="../c_image/formParam_insertUpdateImage.cfm">
	<cfinvoke component="#Application.billingMapping#data.Image" method="maxlength_Image" returnVariable="maxlength_Image" />
</cfif>
<!--- /Integrate Category, Language and Image tabs into Update Product --->

<cfinvoke component="#Application.billingMapping#data.Product" method="maxlength_Product" returnVariable="maxlength_Product" />
<cfinclude template="formParam_insertUpdateProduct.cfm">

<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplateList" ReturnVariable="qry_selectTemplateList">
	<cfinvokeargument Name="companyID" Value="0,#Session.companyID#">
	<cfinvokeargument Name="templateStatus" Value="1">
	<cfinvokeargument Name="templateType" Value="Product">
	<cfinvokeargument Name="returnTemplateXML" Value="False">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
	<cfinvokeargument Name="vendorStatus" Value="1">
</cfinvoke>

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="productID">
	<cfinvokeargument name="targetID_formParam" value="#URL.productID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="productID">
	<cfinvokeargument name="targetID_formParam" value="#URL.productID#">
</cfinvoke>

<cfinclude template="../../view/v_product/lang_insertUpdateProduct.cfm">
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProduct")>
	<!--- Integrate Category, Language and Image tabs into Update Product --->
	<cfif URL.displayExtendedForm is True>
		<cfinclude template="../../view/v_product/lang_insertProductLanguage.cfm">
		<cfinclude template="../../view/v_product/v_productCategory/lang_productCategory.cfm">
		<cfinclude template="../../view/v_image/lang_insertUpdateImage.cfm">
	</cfif>
	<!--- /Integrate Category, Language and Image tabs into Update Product --->

	<cfinclude template="formValidate_insertUpdateProduct.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfif Form.productID_parent is "">
			<cfset Form.productID_parent = 0>
		</cfif>
		<cfif Form.productCatalogPageNumber is "">
			<cfset Form.productCatalogPageNumber = 0>
		</cfif>

		<cfif Variables.doAction is "insertProduct">
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="insertProduct" ReturnVariable="newProductID">
				<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
				<cfinvokeargument Name="userID_manager" Value="#Form.userID_manager#">
				<cfinvokeargument Name="vendorID" Value="#Form.vendorID#">
				<cfinvokeargument Name="productCode" Value="#Form.productCode#">
				<cfinvokeargument Name="productName" Value="#Form.productName#">
				<cfinvokeargument Name="productPrice" Value="#Form.productPrice#">
				<cfinvokeargument Name="productPriceCallForQuote" Value="#Form.productPriceCallForQuote#">
				<cfinvokeargument Name="productWeight" Value="#Form.productWeight#">
				<cfinvokeargument Name="productStatus" Value="#Form.productStatus#">
				<cfinvokeargument Name="productListedOnSite" Value="#Form.productListedOnSite#">
				<cfinvokeargument Name="productCanBePurchased" Value="#Form.productCanBePurchased#">
				<cfinvokeargument Name="productDisplayChildren" Value="#Form.productDisplayChildren#">
				<cfinvokeargument Name="productIsBundle" Value="#Form.productIsBundle#">
				<cfinvokeargument Name="productID_custom" Value="#Form.productID_custom#">
				<cfinvokeargument Name="templateFilename" Value="#Form.templateFilename#">
				<cfinvokeargument Name="productCatalogPageNumber" Value="#Form.productCatalogPageNumber#">
				<cfinvokeargument Name="productID_parent" Value="#Form.productID_parent#">
				<cfinvokeargument Name="productChildType" Value="#Form.productChildType#">
				<cfinvokeargument Name="productInWarehouse" Value="#Form.productInWarehouse#">
			</cfinvoke>

			<cfif URL.displayExtendedForm is False>
				<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="insertProductLanguage" ReturnVariable="isProductLanguageInserted">
					<cfinvokeargument Name="productID" Value="#newProductID#">
					<cfinvokeargument Name="languageID" Value="">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="productLanguageName" Value="#Form.productName#">
					<cfinvokeargument Name="productLanguageLineItemName" Value="#Form.productName#">
					<cfinvokeargument Name="productLanguageLineItemDescription" Value="">
					<cfinvokeargument Name="productLanguageLineItemDescriptionHtml" Value="0">
					<cfinvokeargument Name="productLanguageSummaryHtml" Value="0">
					<cfinvokeargument Name="productLanguageSummary" Value="">
					<cfinvokeargument Name="productLanguageDescription" Value="">
					<cfinvokeargument Name="productLanguageDescriptionHtml" Value="0">
				</cfinvoke>
			</cfif>

			<cfset Variables.targetID = newProductID>
			<cfset URL.productID = newProductID>

			<cfif Form.productID_parent is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
					<cfinvokeargument Name="productID" Value="#Form.productID_parent#">
					<cfinvokeargument Name="productHasChildren" Value="1">
				</cfinvoke>
			</cfif>

		<cfelse><!--- update --->
			<cfset Form.productID = URL.productID>
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
				<cfinvokeargument Name="userID_manager" Value="#Form.userID_manager#">
				<cfinvokeargument Name="vendorID" Value="#Form.vendorID#">
				<cfinvokeargument Name="productCode" Value="#Form.productCode#">
				<cfinvokeargument Name="productName" Value="#Form.productName#">
				<cfinvokeargument Name="productPrice" Value="#Form.productPrice#">
				<cfinvokeargument Name="productPriceCallForQuote" Value="#Form.productPriceCallForQuote#">
				<cfinvokeargument Name="productWeight" Value="#Form.productWeight#">
				<cfinvokeargument Name="productStatus" Value="#Form.productStatus#">
				<cfinvokeargument Name="productListedOnSite" Value="#Form.productListedOnSite#">
				<cfinvokeargument Name="productCanBePurchased" Value="#Form.productCanBePurchased#">
				<cfinvokeargument Name="productDisplayChildren" Value="#Form.productDisplayChildren#">
				<cfinvokeargument Name="productID_custom" Value="#Form.productID_custom#">
				<cfinvokeargument Name="templateFilename" Value="#Form.templateFilename#">
				<cfinvokeargument Name="productCatalogPageNumber" Value="#Form.productCatalogPageNumber#">
				<cfinvokeargument Name="productID_parent" Value="#Form.productID_parent#">
				<cfinvokeargument Name="productChildType" Value="#Form.productChildType#">
				<cfinvokeargument Name="productInWarehouse" Value="#Form.productInWarehouse#">
			</cfinvoke>

			<cfif Form.productID_parent is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
					<cfinvokeargument Name="productID" Value="#Form.productID_parent#">
					<cfinvokeargument Name="productHasChildren" Value="1">
				</cfinvoke>
			</cfif>

			<!--- archive field changes --->
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.InsertFieldArchive" method="insertFieldArchiveViaTarget" returnVariable="isArchived">
			<cfinvokeargument name="primaryTargetKey" value="productID">
			<cfinvokeargument name="targetID" value="#URL.productID#">
			<cfinvokeargument name="userID" value="#Session.userID#">
			<cfinvokeargument name="qry_selectTarget" value="#qry_selectProduct#">
		</cfinvoke>
		</cfif>

		<cfif URL.displayExtendedForm is True>
			<!--- ProductLanguage --->
			<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="insertProductLanguage" ReturnVariable="isProductLanguage">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="languageID" Value="">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="productLanguageName" Value="#Form.productLanguageName#">
				<cfinvokeargument Name="productLanguageLineItemName" Value="#Form.productLanguageLineItemName#">
				<cfif Variables.doAction is "insertProduct">
					<cfinvokeargument Name="productLanguageLineItemDescription" Value="">
					<cfinvokeargument Name="productLanguageLineItemDescriptionHtml" Value="0">
					<cfinvokeargument Name="productLanguageSummary" Value="0">
					<cfinvokeargument Name="productLanguageSummaryHtml" Value="0">
				<cfelse>
					<cfinvokeargument Name="productLanguageLineItemDescription" Value="#qry_selectProductLanguage.productLanguageLineItemDescription#">
					<cfinvokeargument Name="productLanguageLineItemDescriptionHtml" Value="#qry_selectProductLanguage.productLanguageLineItemDescriptionHtml#">
					<cfinvokeargument Name="productLanguageSummary" Value="#qry_selectProductLanguage.productLanguageSummary#">
					<cfinvokeargument Name="productLanguageSummaryHtml" Value="#qry_selectProductLanguage.productLanguageSummaryHtml#">
				</cfif>
				<cfinvokeargument Name="productLanguageDescription" Value="#Form.productLanguageDescription#">
				<cfinvokeargument Name="productLanguageDescriptionHtml" Value="#Form.productLanguageDescriptionHtml#">
			</cfinvoke>

			<!--- ProductCategory --->
			<cfinclude template="c_productCategory/act_insertProductCategory.cfm">

			<!--- Image --->
			<cfif Variables.doAction is "insertProduct">
				<cfinclude template="../c_image/act_insertImage.cfm">
			<cfelse>
				<cfif qry_selectImage.RecordCount is 0 or qry_selectImage.imageIsThumbnail[1] is 1>
					<cfset URL.imageID = 0>
				<cfelse>
					<cfset URL.imageID = qry_selectImage.imageID[1]>
				</cfif>
				<cfinclude template="../c_image/act_updateImage.cfm">
			</cfif>
		</cfif>

		<!--- Insert custom fields and custom status if necessary --->
		<cfif isCustomFieldValueExist is True>
			<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.productID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<cfif isStatusExist is True>
			<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
				<cfinvokeargument name="targetID_formProcess" value="#URL.productID#">
				<cfinvokeargument name="userID" value="#Session.userID#">
			</cfinvoke>
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="productID">
			<cfinvokeargument name="targetID" value="#URL.productID#">
		</cfinvoke>

		<cfif Variables.doAction is "insertProduct">
			<!--- <cflocation url="index.cfm?method=product.insertProductLanguage&productID=#newProductID#&comfirm_product=#Variables.doAction#" AddToken="No"> --->
			<cflocation url="index.cfm?method=product.insertProduct&productID_new=#newProductID#&displayExtendedForm=#URL.displayExtendedForm#&comfirm_product=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=product.updateProduct&productID=#URL.productID#&displayExtendedForm=#URL.displayExtendedForm#&confirm_product=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif><!--- /form valid --->
</cfif><!--- /form submitted --->

<cfset Variables.formName = "insertProduct">
<cfif Variables.doAction is "insertProduct">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateProduct.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateProduct.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_product/form_insertUpdateProduct.cfm">
