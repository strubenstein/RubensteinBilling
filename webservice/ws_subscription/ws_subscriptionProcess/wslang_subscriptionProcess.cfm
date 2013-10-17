<cfset Variables.wslang_subscriptionProcess = StructNew()>

<cfset Variables.wslang_subscriptionProcess.listSubscribers = "You do not have permission to list subscribers.">
<cfset Variables.wslang_subscriptionProcess.subscriberDateProcessNext = "You did not specify a valid next processing date by which to search.">
<cfset Variables.wslang_subscriptionProcess.updateSubscriptionProcess = "You do not have permission to update variable-quantity subscriptions for the billing period.">
<cfset Variables.wslang_subscriptionProcess.invalidSubscriber = "You did not specify a valid subscriber.">
<cfset Variables.wslang_subscriptionProcess.notScheduled = "The subscriber is not active or is not currently scheduled for processing.">
<cfset Variables.wslang_subscriptionProcess.subscriptionQuantity = "You did not specify a valid quantity for this subscription.">
<cfset Variables.wslang_subscriptionProcess.invalidSubscription = "You did not specify a valid subscription.">
<cfset Variables.wslang_subscriptionProcess.subscriptionOptions = "You did not specify valid subscription options.">
<cfset Variables.wslang_subscriptionProcess.invalidPriceStage = "You did not specify a valid custom price stage.">
<cfset Variables.wslang_subscriptionProcess.subscriptionQuantityVaries = "This subscription does not have a variable quantity.">
<cfset Variables.wslang_subscriptionProcess.subscriptionIsRollup = "This subscription quantity is rolled up from other subscriptions.">
