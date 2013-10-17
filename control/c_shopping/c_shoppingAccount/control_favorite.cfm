<cfif URL.action is not "viewFavoriteList">
	<cfset URL.error_shopping = "">
	<cfparam Name="URL.productID" Default="0">

	<cfif Not Application.fn_IsIntegerPositive(URL.productID)>
		<cfset URL.error_shopping = "invalidProduct">
	<cfelse>
		<!--- if valid integer, select this product information --->
		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductLanguageVendor" ReturnVariable="qry_selectProduct">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
		</cfinvoke>

		<!--- ensure this product exists and is currently available --->
		<cfif qry_selectProduct.RecordCount is 0>
			<cfset URL.error_shopping = "invalidProduct">
		</cfif>
	</cfif>

	<cfif URL.error_shopping is not "">
		<cfinclude template="../../../view/v_shopping/error_shopping.cfm">
		<cfset URL.action = "viewFavoriteList">
	</cfif>
</cfif>

<cfswitch expression="#URL.action#">
<cfcase value="insertFavorite">
	<cfinvoke Component="#Application.billingMapping#data.UserProductFavorite" Method="insertUserProductFavorite" ReturnVariable="isFavoriteInserted">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
	</cfinvoke>

	<cfif Not IsDefined("URL.returnID")><!--- view product --->
		<cflocation url="index.cfm?method=product.viewProduct&productID=#URL.productID#&confirm_shopping=#URL.action#" AddToken="No">
	<cfelseif IsNumeric(URL.returnID)><!--- view parent product --->
		<cflocation url="index.cfm?method=product.viewProduct&productID=#URL.returnID#&confirm_shopping=#URL.action#" AddToken="No">
	<cfelse><!--- view shopping cart --->
		<cflocation url="index.cfm?method=cart.viewCart&confirm_shopping=#URL.action#" AddToken="No">
	</cfif>
</cfcase>

<cfcase value="deleteFavorite">
	<cfinvoke Component="#Application.billingMapping#data.UserProductFavorite" Method="deleteUserProductFavorite" ReturnVariable="isFavoriteDeleted">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
	</cfinvoke>

	<cflocation url="favorite.cfm?action=viewFavoriteList&confirm_shopping=#URL.action#" AddToken="No">
</cfcase>

<cfcase value="updateFavorite">
	<cfinvoke component="#Application.billingMapping#data.UserProductFavorite" method="maxlength_UserProductFavorite" returnVariable="maxlength_UserProductFavorite" />
	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitUpdateFavorite#URL.productID#") and IsDefined("Form.userProductFavoriteComment")
			and IsDefined("Form.userProductFavoriteQuantity") and IsNumeric(Form.userProductFavoriteQuantity) and Form.userProductFavoriteQuantity gt 0
			and (Not Find(".", Form.userProductFavoriteQuantity) or Len(ListLast(Form.userProductFavoriteQuantity, ".")) lte maxlength_UserProductFavorite.userProductFavoriteQuantity)>
		<cfinvoke Component="#Application.billingMapping#data.UserProductFavorite" Method="updateUserProductFavorite" ReturnVariable="isFavoriteDeleted">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<!--- 
			<cfinvokeargument Name="userProductFavoriteQuantity" Value="#Form.userProductFavoriteQuantity#">
			<cfinvokeargument Name="userProductFavoriteStatus" Value="#Form.userProductFavoriteStatus#">
			--->
		</cfinvoke>

		<cflocation url="favorite.cfm?action=viewFavoriteList&confirm_shopping=#URL.action#" AddToken="No">
	<cfelse>
		<cflocation url="favorite.cfm?action=viewFavoriteList" AddToken="No">
	</cfif>
</cfcase>

<cfdefaultcase><!--- viewFavoriteList --->
	<cfinvoke Component="#Application.billingMapping#data.UserProductFavorite" Method="selectProductFavoriteList" ReturnVariable="qry_selectFavoriteList">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="userProductFavoriteStatus" Value="1">
		<cfinvokeargument Name="languageID" Value="">
		<cfinvokeargument Name="selectProductInfo" Value="True">
	</cfinvoke>

	<cfinvoke component="#Application.billingMapping#data.UserProductFavorite" method="maxlength_UserProductFavorite" returnVariable="maxlength_UserProductFavorite" />
	<cfinclude template="../../../view/v_shopping/v_shoppingAccount/dsp_selectFavoriteList.cfm">
</cfdefaultcase>
</cfswitch>

