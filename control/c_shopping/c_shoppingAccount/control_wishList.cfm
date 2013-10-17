<cfif URL.action is not "viewWishList">
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
		<cfset URL.action = "viewWishList">
	</cfif>
</cfif>

<cfswitch expression="#URL.action#">
<cfcase value="insertWishList">
	<cfinvoke Component="#Application.billingMapping#data.UserProductWishList" Method="insertUserProductWishList" ReturnVariable="isWishListInserted">
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

<cfcase value="deleteWishList">
	<cfinvoke Component="#Application.billingMapping#data.UserProductWishList" Method="deleteUserProductWishList" ReturnVariable="isWishListDeleted">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
	</cfinvoke>

	<cflocation url="wishList.cfm?action=viewWishList&confirm_shopping=#URL.action#" AddToken="No">
</cfcase>

<cfcase value="updateWishList">
	<cfinvoke component="#Application.billingMapping#data.UserProductWishList" method="maxlength_UserProductWishList" returnVariable="maxlength_UserProductWishList" />
	<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitUpdateWishList#URL.productID#") and IsDefined("Form.userProductWishListComment")
			and IsDefined("Form.userProductWishListQuantity") and IsNumeric(Form.userProductWishListQuantity) and Form.userProductWishListQuantity gt 0
			and (Not Find(".", Form.userProductWishListQuantity) or Len(ListLast(Form.userProductWishListQuantity, ".")) lte maxlength_UserProductWishList.userProductWishListQuantity)>
		<cfinvoke Component="#Application.billingMapping#data.UserProductWishList" Method="updateUserProductWishList" ReturnVariable="isWishListDeleted">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="userProductWishListQuantity" Value="#Form.userProductWishListQuantity#">
			<cfinvokeargument Name="userProductWishListComment" Value="#Form.userProductWishListComment#">
			<!--- 
			<cfinvokeargument Name="userProductWishListStatus" Value="#Form.userProductWishListStatus#">
			<cfinvokeargument Name="userProductWishListFulfilled" Value="#Form.userProductWishListFulfilled#">
			<cfinvokeargument Name="invoiceLineItemID" Value="#Form.invoiceLineItemID#">
			<cfinvokeargument Name="userProductWishListRating" Value="#Form.userProductWishListRating#">
			<cfinvokeargument Name="addressID" Value="#Form.addressID#">
			--->
		</cfinvoke>

		<cflocation url="wishList.cfm?action=viewWishList&confirm_shopping=#URL.action#" AddToken="No">
	<cfelse>
		<cflocation url="wishList.cfm?action=viewWishList" AddToken="No">
	</cfif>
</cfcase>

<cfdefaultcase><!--- viewWishList --->
	<cfinvoke Component="#Application.billingMapping#data.UserProductWishList" Method="selectProductWishListList" ReturnVariable="qry_selectWishList">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="userProductWishListStatus" Value="1">
		<cfinvokeargument Name="userProductWishListFulfilled" Value="0">
		<cfinvokeargument Name="languageID" Value="">
		<cfinvokeargument Name="selectProductInfo" Value="True">
	</cfinvoke>

	<cfinvoke component="#Application.billingMapping#data.UserProductWishList" method="maxlength_UserProductWishList" returnVariable="maxlength_UserProductWishList" />
	<cfinclude template="../../../view/v_shopping/v_shoppingAccount/form_selectWishList.cfm">
</cfdefaultcase>
</cfswitch>

