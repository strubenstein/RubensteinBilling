<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_subscription#">
<cfcase value="invalidAction">You did not specify a valid subscription function.</cfcase>
<cfcase value="noSubscriber">You did not specify a valid subscriber.</cfcase>
<cfcase value="invalidSubscriber">You did not specify a valid subscriber.</cfcase>
<cfcase value="noSubscription">You did not specify a valid subscription for this subscriber.</cfcase>
<cfcase value="invalidSubscription">You did not select a valid subscription for this subscriber.</cfcase>
<cfcase value="updateInactiveSubscription">You cannot update an inactive subscription.</cfcase>
<cfcase value="invalidCompany">You did not specify a valid company.</cfcase>
<cfcase value="invalidUser">You did not specify a valid user.</cfcase>
<cfcase value="invalidProduct">You did not select a valid product for the subscription.</cfcase>
<cfcase value="insertSubscriber">To create a new subscriber, you must start at a company or user.</cfcase>
<cfcase value="updateSubscriptionProcess">This subscriber does not have any variable-quantity subscriptions to process<br>during this billing period or is not scheduled to be processed.</cfcase>
<cfcase value="processSubscriber">The subscriber could not be processed.</cfcase>
<cfcase value="listSubscribers">There are no subscribers for this company.<br>You may create the subscriber below.</cfcase>
<cfcase value="processSubscriber_notScheduled">Subscriber is not currently scheduled to be processed.</cfcase>
<cfcase value="processSubscriber_beforeDate">Today is before the subscriber's next scheduled processing date.</cfcase>
<cfcase value="processSubscriber_other">The subscriber could not be processed for another unspecified reason, probably because<br>this subscriber has variable-quantity subscriptions that are not yet finalized.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>