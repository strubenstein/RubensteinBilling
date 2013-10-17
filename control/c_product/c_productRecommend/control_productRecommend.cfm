<cfinclude template="../../../view/v_product/v_productRecommend/nav_productRecommend.cfm">

<cfswitch expression="#Variables.doAction#">
<cfcase value="listProductRecommends">
	<!--- list products recommended by this product --->
	<cfinvoke Component="#Application.billingMapping#data.ProductRecommend" Method="selectProductRecommendList" ReturnVariable="qry_selectProductRecommendList_recommend">
		<cfinvokeargument Name="productID_target" Value="#URL.productID#">
		<cfinvokeargument Name="productID_recommend" Value="0">
		<cfinvokeargument Name="productRecommendStatus" Value="1">
	</cfinvoke>

	<!--- list products that recommend this product --->
	<cfinvoke Component="#Application.billingMapping#data.ProductRecommend" Method="selectProductRecommendList" ReturnVariable="qry_selectProductRecommendList_target">
		<cfinvokeargument Name="productID_target" Value="0">
		<cfinvokeargument Name="productID_recommend" Value="#URL.productID#">
		<cfinvokeargument Name="productRecommendStatus" Value="1">
	</cfinvoke>

	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("insertProductRecommend,viewProduct,updateProductRecommend")>

	<cfinclude template="../../../view/v_product/v_productRecommend/dsp_selectProductRecommendList.cfm">
</cfcase>

<cfcase value="insertProductRecommend">
	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductRecommend") and (IsDefined("Form.productID_recommend") or IsDefined("Form.productID_target"))>
		<cfparam Name="Form.productID_recommend" Default="">
		<cfparam Name="Form.productID_target" Default="">
		<cfset Variables.productID_list = "">

		<cfif Form.productID_recommend is not "">
			<cfset Variables.productID_list = Form.productID_recommend>
			<cfinvoke Component="#Application.billingMapping#data.ProductRecommend" Method="insertProductRecommends_select" ReturnVariable="isProductRecommendsInserted">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="productID_target" Value="#URL.productID#">
				<cfinvokeargument Name="productID_recommend" Value="#Form.productID_recommend#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="productRecommendStatus" Value="1">
				<cfinvokeargument Name="productRecommendReverse" Value="0">
				<cfinvokeargument Name="productID_recommend_target" Value="#Form.productID_target#">
			</cfinvoke>
		</cfif>

		<cfif Form.productID_target is not "">
			<cfset Variables.productID_list = ListAppend(Variables.productID_list, Form.productID_target)>
			<cfinvoke Component="#Application.billingMapping#data.ProductRecommend" Method="insertProductRecommended_select" ReturnVariable="isProductRecommendedInserted">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="productID_target" Value="#Form.productID_target#">
				<cfinvokeargument Name="productID_recommend" Value="#URL.productID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="productRecommendStatus" Value="1">
				<cfinvokeargument Name="productRecommendReverse" Value="0">
				<cfinvokeargument Name="productID_target_recommend" Value="#Form.productID_recommend#">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.ProductRecommend" Method="updateProductRecommendsReverse" ReturnVariable="isProductRecommendsReverseUpdated">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="productID_list" Value="#Variables.productID_list#">
		</cfinvoke>

		<cfif IsDefined("Form.queryViewAction")>
			<cflocation url="#Form.queryViewAction#&confirm_product=#URL.action#" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=product.insertProductRecommend&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
		</cfif>
	</cfif>

	<cfset Variables.productID_not = URL.productID>
	<cfinclude template="../control_listProducts.cfm">
</cfcase>

<cfcase value="updateProductRecommend">
	<cfif Not IsDefined("URL.productID_target") or Not IsDefined("URL.productID_recommend") or Not IsDefined("URL.productRecommendStatus")
			or Not Application.fn_IsIntegerPositive(URL.productID_target) or Not Application.fn_IsIntegerPositive(URL.productID_recommend)
			or (URL.productID_target is not URL.productID and URL.productID_recommend is not URL.productID)
			or Not ListFind("0,1", URL.productRecommendStatus)>
		<cflocation url="index.cfm?method=product.listProductRecommends&productID=#URL.productID#&error_product=#URL.action#" AddToken="No">
	</cfif>

	<cfinvoke Component="#Application.billingMapping#data.ProductRecommend" Method="updateProductRecommend" ReturnVariable="isProductRecommendUpdated">
		<cfinvokeargument Name="productID_target" Value="#URL.productID_target#">
		<cfinvokeargument Name="productID_recommend" Value="#URL.productID_recommend#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="productRecommendStatus" Value="#URL.productRecommendStatus#">
		<cfinvokeargument Name="productRecommendReverse" Value="0">
	</cfinvoke>

	<cflocation url="index.cfm?method=product.listProductRecommends&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
</cfcase>
</cfswitch>

