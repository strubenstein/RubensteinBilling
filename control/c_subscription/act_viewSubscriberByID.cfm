<cfquery Name="qry_viewSubscriberByID" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avSubscriber.subscriberID, avSubscriber.subscriberID_custom, avSubscriber.subscriberName,
		avCompany.companyName, avUser.firstName, avUser.lastName
	FROM avSubscriber
		INNER JOIN avCompany ON avSubscriber.companyID = avCompany.companyID
		LEFT OUTER JOIN avUser ON avSubscriber.userID = avUser.userID
	WHERE avSubscriber.companyID_author = <cfqueryparam Value="#Session.companyID#" cfsqltype="cf_sql_integer">
		AND (
			avSubscriber.subscriberID_custom = <cfqueryparam Value="#URL.subscriberID#" cfsqltype="cf_sql_varchar">
			<cfif Application.fn_IsIntegerNonNegative(URL.subscriberID)>
				OR avSubscriber.subscriberID = <cfqueryparam Value="#URL.subscriberID#" cfsqltype="cf_sql_integer">
			</cfif>
			)
	ORDER BY avSubscriber.subscriberID_custom, avSubscriber.subscriberName, avCompany.companyName
</cfquery>

<cfif qry_viewSubscriberByID.RecordCount is 1>
	<cfset URL.subscriberID = qry_viewSubscriberByID.subscriberID>
<cfelseif qry_viewSubscriberByID.RecordCount gt 1>
	<cfset URL.subscriberID = qry_viewSubscriberByID.subscriberID[1]>
	<cfset Variables.displayViewByIDList = True>
</cfif>
