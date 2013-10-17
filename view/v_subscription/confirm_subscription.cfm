<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_subscription#">
<cfcase value="insertSubscriber">Subscriber successfully created.</cfcase>
<cfcase value="updateSubscriber">Subscriber successfully updated.</cfcase>
<cfcase value="insertSubscriberNotify">User(s) successfully added to be notified.</cfcase>
<cfcase value="updateSubscriberNotify">User notification options successfully updated.</cfcase>
<cfcase value="insertSubscription">Subscription successfully created.</cfcase>
<cfcase value="updateSubscription">Subscription successfully updated.</cfcase>
<cfcase value="updateSubscriptionStatus">This subscription is now inactive.</cfcase>
<cfcase value="moveSubscriptionUp,moveSubscriptionDown">Subscription order successfully updated.</cfcase>
<cfcase value="updateSubscriptionProcess">Subscription quantities updated for this subscriber's billing period.</cfcase>
<cfcase value="processSubscriber">Subscriber successfully processed for this billing period.</cfcase>
<cfcase value="updateSubscriberIsExported">Export status of subscriber records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
