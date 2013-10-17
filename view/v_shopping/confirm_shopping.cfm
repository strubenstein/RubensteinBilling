<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_shopping#">
<cfcase value="updateAccount">Your account information has been successfully updated.</cfcase>
<cfcase value="insertWishList">The product has been successfully added to your wish list.</cfcase>
<cfcase value="deleteWishList">The product has been removed from your wish list.</cfcase>
<cfcase value="updateWishList">Your wish list has been successfully updated.</cfcase>
<cfcase value="insertFavorite">The product has been successfully added to your favorites list.</cfcase>
<cfcase value="deleteFavorite">The product has been removed from your favorites list.</cfcase>
<cfcase value="updateFavorite">Your favorites list has been successfully updated.</cfcase>
<cfcase value="logout">You have successfully logged out.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>

