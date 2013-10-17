<cfoutput>
<p><hr noshade size="3" width="500" align="left"><div class="MainText"><b>Recently Viewed Products</b><br>
<cfloop Index="count" From="#ArrayLen(Session.lastProductsViewed)#" To="1" Step="-1">
	<a href="index.cfm?method=product.viewProduct&productID=#Session.lastProductsViewed[count].productID#"><cfif Session.lastProductsViewed[count].productID_custom is not "">#Session.lastProductsViewed[count].productID_custom#. </cfif>#Session.lastProductsViewed[count].productLanguageName#</a><br>
</cfloop>
</div></p>
</cfoutput>

