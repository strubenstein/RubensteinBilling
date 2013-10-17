<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_creditCard#">
<cfcase value="insertCreditCard">Credit card information successfully added!<br>You may add another credit card listing below for this user/company.</cfcase>
<cfcase value="updateCreditCard">Credit card information successfully updated!<br>The previous version of this credit card has been archived.</cfcase>
<cfcase value="deleteCreditCard">Credit card information deleted.</cfcase>
<cfcase value="updateCreditCardStatus0">Credit card information has been archived.</cfcase>
<cfcase value="updateCreditCardStatus1">Credit card information is now active again.</cfcase>
<cfcase value="updateCreditCardRetain0">Credit card information is no longer being retained.</cfcase>
<cfcase value="updateCreditCardRetain1">Credit card information is now being retained again.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
