<cfcomponent DisplayName="SubscriptionUser" Hint="Manages customer users associated with each subscription">

<cffunction Name="selectSubscriptionUser" Access="public" Output="No" ReturnType="query" Hint="Select contact user(s) for existing subscription(s).">
	<cfargument Name="subscriptionID" Type="string" Required="No">
	<cfargument Name="userID" Type="string" Required="No">
	<cfargument Name="returnUserFields" Type="boolean" Required="No" Default="False">

	<cfset var displayAnd = False>

	<cfquery Name="qry_selectSubscriptionUser" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT avSubscriptionUser.subscriptionID, avSubscriptionUser.userID
			<cfif Arguments.returnUserFields is True>, avUser.firstName, avUser.lastName, avUser.email, avUser.userID_custom</cfif>
		FROM avSubscriptionUser
			<cfif Arguments.returnUserFields is True>INNER JOIN avUser ON avSubscriptionUser.userID = avUser.userID</cfif>
		<cfloop Index="field" List="subscriptionID,userID">
			<cfif StructKeyExists(Arguments, field) and Application.fn_IsIntegerList(Arguments[field])>
				<cfif displayAnd is True> AND <cfelse> WHERE <cfset displayAnd = True></cfif>
				avSubscriptionUser.#field# IN (<cfqueryparam Value="#Arguments[field]#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
		</cfloop>
		ORDER BY avSubscriptionUser.subscriptionID, 
			<cfif Arguments.returnUserFields is True>avUser.lastName, avUser.firstName,</cfif>
			avSubscriptionUser.userID
	</cfquery>

	<cfreturn qry_selectSubscriptionUser>
</cffunction>

</cfcomponent>
