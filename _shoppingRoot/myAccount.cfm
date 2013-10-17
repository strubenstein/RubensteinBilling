<!--- 
Display orders and tracking information for each
Update account/contact information
--->

<cfif Session.userID is 0>
	<cflocation url="login.cfm?myAccount=True" AddToken="No">
<cfelseif Not StructKeyExists(Session, "companyAuthorizedUsers") or Not StructKeyExists(Session, "companyExpirationDate") or Not StructKeyExists(Session, "companyPrimaryUser")>
	<cfinclude template="control/c_shopping/c_corporateLicense/act_checkCorporateLicense.cfm">
</cfif>

<cfif StructKeyExists(Session, "username") and Session.username is "jkircher">
	<cfset Variables.isCourseReport = True>
<cfelse>
	<cfset Variables.isCourseReport = False>
</cfif>

<cfparam Name="URL.action" Default="">
<cfset Variables.doAction = URL.action>

<cfif IsDefined("URL.confirm_shopping")>
	<CFINCLUDE Template="view/v_shopping/confirm_shopping.cfm">
</cfif>

<cfswitch Expression="#URL.action#">
<cfcase Value="listPurchases">
	<cfinclude template="control/c_shopping/c_shoppingAccount/control_listPurchases.cfm">
</cfcase>

<cfcase Value="viewPurchase">
	<cfinclude template="control/c_shopping/c_shoppingAccount/control_viewPurchase.cfm">
</cfcase>

<cfcase Value="updateAccount">
	<cfinclude Template="control/c_shopping/c_shoppingAccount/control_updateAccount.cfm">
</cfcase>

<cfdefaultcase><!--- list myaccount links --->
	<p class="SubTitle">My Account</p>

	<p class="MainText">
	<a href="myAccount.cfm?action=listPurchases">View Your Purchases</a><br>
	<a href="myAccount.cfm?action=updateAccount">Change Registration Info</a><br>
	<!--- 
	<a href="wishList.cfm?action=viewWishList">Wish List</a><br>
	<a href="favorite.cfm?action=viewFavoriteList">Favorite List</a><br>
	--->
	</p>
</cfdefaultcase>
</cfswitch>
