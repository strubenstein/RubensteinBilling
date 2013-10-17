<cfparam Name="URL.productID" Default="0">
<cfset Variables.formAction = Variables.doURL & "&productID=" & URL.productID>

<!--- Enable user to go directly to product by entering ID or custom ID --->
<cfset Variables.isViewPermission = Application.fn_IsUserAuthorized("viewProduct")>
<cfset Variables.displayViewByIDList = False>
<cfif Variables.doAction is "viewProduct" and IsDefined("URL.submitView") and Trim(URL.productID) is not "">
	<cfinclude template="act_viewProductByID.cfm">
</cfif>

<cfinclude template="security_product.cfm">
<cfinclude template="../../view/v_product/nav_product.cfm">
<cfif IsDefined("URL.confirm_product")>
	<cfinclude template="../../view/v_product/confirm_product.cfm">
</cfif>
<cfif IsDefined("URL.error_product")>
	<cfinclude template="../../view/v_product/error_product.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listProducts">
	<cfparam Name="Variables.urlParameters" Default="">
	<cfset formAction = Variables.doURL & Variables.urlParameters>
	<cfinclude template="control_listProducts.cfm">
</cfcase>

<cfcase value="insertProduct,updateProduct">
	<cfinclude template="control_insertUpdateProduct.cfm">
</cfcase>

<cfcase value="viewProduct">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfif Variables.displayViewByIDList is True>
			<cfinclude template="../../view/v_product/dsp_viewProductByID.cfm">
		</cfif>
		<cfinclude template="control_viewProduct.cfm">
	<cfelse>
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.ViewFieldArchives" method="viewFieldArchivesViaTarget" returnVariable="isViewed">
			<cfinvokeargument name="primaryTargetKey" value="productID">
			<cfinvokeargument name="targetID" value="#URL.productID#">
		</cfinvoke>

 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="productID">
				<cfinvokeargument name="targetID" value="#URL.productID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="productID">
				<cfinvokeargument name="targetID" value="#URL.productID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<!--- 
<cfcase value="previewProduct">
	<cfif qry_selectProduct.templateFilename is "">
		<cfset Variables.templateFilename = "defaultProduct.cfm">
		<cfset URL.error_product = "noTemplate">
		<cfinclude template="../../view/v_product/error_product.cfm">
	<cfelseif Not FileExists(Application.billingTemplateDirectoryPath & Application.billingFilePathSlash & qry_selectProduct.templateFilename)>
		<cfset Variables.templateFilename = "defaultProduct.cfm">
		<cfset URL.error_product = "invalidTemplate">
		<cfinclude template="../../view/v_product/error_product.cfm">
	<cfelse>
		<cfset Variables.templateFilename = qry_selectProduct.templateFilename>
	</cfif>

	<cfset Session.companyID_author = Session.companyID>
	<cfinclude template="../c_shopping/c_shoppingCatalog/control_getProduct.cfm">
	<cfinclude template="../../include/template/#Variables.templateFilename#">
</cfcase>
--->

<cfcase value="insertProductCategory,viewProductCategory">
	<cfinclude template="c_productCategory/control_productCategory.cfm">
</cfcase>

<cfcase value="moveProductCategoryUp,moveProductCategoryDown">
	<cfinclude template="c_productCategory/control_moveProductCategory.cfm">
</cfcase>

<cfcase value="insertProductLanguage">
	<cfinclude template="control_insertProductLanguage.cfm">
</cfcase>

<cfcase value="insertProductSpec,insertChildProductSpec,listProductSpecs">
	<cfinclude template="c_productSpec/control_productSpec.cfm">
</cfcase>

<cfcase value="listImages,insertImage,updateImage,imageDisplayCategory,moveImageDown,moveImageUp,hideImage,unhideImage,separateImage">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("productID")>
	<cfset Variables.targetID = URL.productID>
	<cfset Variables.urlParameters = "&productID=#URL.productID#">

	<cfset Variables.doControl = "image">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listProductDates,insertProductDate,updateProductDate,deleteProductDate">
	<cfinclude template="c_productDate/control_productDate.cfm">
</cfcase>

<cfcase value="listProductRecommends,insertProductRecommend,updateProductRecommend">
	<cfinclude template="c_productRecommend/control_productRecommend.cfm">
</cfcase>

<cfcase value="listPrices,viewPrice,insertPrice,updatePrice,listPriceTargets,updatePriceTargetStatus0,updatePriceTargetStatus1,insertPriceTargetUser,insertPriceTargetGroup,insertPriceTargetCompany">
	<cfset Variables.urlParameters = "&productID=#URL.productID#">
	<cfset Variables.doControl = "price">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listProductBundles,insertProductBundle,updateProductBundle,moveProductBundleUp,moveProductBundleDown,deleteProductBundle">
	<cfinclude template="c_productBundle/control_productBundle.cfm">
</cfcase>

<cfcase value="listChildProducts">
	<cfinclude template="control_productChildList.cfm">
</cfcase>

<cfcase value="moveChildProductUp,moveChildProductDown">
	<cfset Variables.exitURL = "index.cfm?method=product.listChildProducts&productID=#URL.productID#">
	<cfinclude template="control_productChildMove.cfm">
</cfcase>

<cfcase value="separateChildProduct,unseparateChildProduct">
	<cfset Variables.exitURL = "index.cfm?method=product.listChildProducts&productID=#URL.productID#">
	<cfinclude template="control_productChildSeparate.cfm">
</cfcase>

<cfcase value="fixChildProductOrder">
	<cfset Variables.exitURL = "index.cfm?method=product.listChildProducts&productID=#URL.productID#">
	<cfinclude template="control_productChildFix.cfm">
</cfcase>

<cfcase value="listProductParameters,insertProductParameter,updateProductParameter,moveProductParameterDown,moveProductParameterUp,moveProductParameterCodeDown,moveProductParameterCodeUp,listProductParameterExceptions,insertProductParameterException,updateProductParameterException,updateProductParameterExceptionStatus">
	<cfinclude template="c_productParameter/control_productParameter.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="productID">
		<cfinvokeargument name="targetID" value="#URL.productID#">
		<cfinvokeargument name="urlParameters" value="&productID=#URL.productID#">
	</cfinvoke>
</cfcase>

<cfcase value="listSubscribers">
	<cfset URL.categoryID = "">
	<cfset Variables.doControl = "subscription">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCommissions">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("productID")>
	<cfset Variables.targetID = URL.productID>
	<cfset Variables.urlParameters = "&productID=#URL.productID#">

	<cfset Variables.doControl = "commission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listSalesCommissions">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("productID")>
	<cfset Variables.targetID = URL.productID>
	<cfset Variables.urlParameters = "&productID=#URL.productID#">

	<cfset Variables.doControl = "salesCommission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listInvoices">
	<cfset Variables.doControl = "invoice">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_product = "invalidAction">
	<cfinclude template="../../view/v_product/error_product.cfm">
</cfdefaultcase>
</cfswitch>

