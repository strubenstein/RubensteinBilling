<cfset Variables.navPageTitle = "">
<cfset Variables.navSubNav = "">
<cfset Variables.navHighlight = "">

<cfswitch expression="#GetFileFromPath(GetBaseTemplatePath())#">
<cfcase value="cart.cfm"><cfset Variables.navPageTitle = "Your Shopping Cart"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="category.cfm"><cfset Variables.navPageTitle = "Category: "><cfset Variables.navSubNav = "category"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="checkout.cfm"><cfset Variables.navPageTitle = "Checkout"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="error.cfm"><cfset Variables.navPageTitle = "Error"></cfcase>
<cfcase value="favorite.cfm"><cfset Variables.navPageTitle = "Favorite Products"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="forget.cfm"><cfset Variables.navPageTitle = "Forget Password"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="index.cfm"><cfset Variables.navPageTitle = "Home"><cfset Variables.navHighlight = "home"><cfset Variables.navSubNav = "home"></cfcase>
<cfcase value="login.cfm"><cfset Variables.navPageTitle = "Login"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="myAccount.cfm"><cfset Variables.navPageTitle = "My Account"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="newsletter.cfm"><cfset Variables.navPageTitle = "Newsletter"><cfset navHighlight = "newsletter"></cfcase>
<cfcase value="product.cfm"><cfset Variables.navPageTitle = "Product: "><cfset Variables.navSubNav = "product"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="search.cfm"><cfset Variables.navPageTitle = "Search"><cfset Variables.navHighlight = "onlinestore"></cfcase>
<cfcase value="wishList.cfm"><cfset Variables.navPageTitle = "Wish List"><cfset Variables.navHighlight = "onlinestore"></cfcase>
</cfswitch>

