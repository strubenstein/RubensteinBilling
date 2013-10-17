<cfquery Name="qry_selectHeaderFooterList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT headerFooterID, headerFooterText, headerFooterHtml, headerFooterIndicator
	FROM avHeaderFooter
	WHERE headerFooterStatus = 1
		<cfif StructKeyExists(Arguments, "headerFooterID") and Application.fn_IsIntegerList(Arguments.headerFooterID)>
			AND headerFooterID IN (#Arguments.headerFooterID#)
		</cfif>
		<cfif StructKeyExists(Arguments, "categoryID") and Application.fn_IsIntegerPositive(Arguments.cobrandID)>
			AND primaryTargetID = #Application.fn_GetPrimaryTargetID("categoryID")#
			AND targetID = #Arguments.categoryID#
		</cfif>
		<cfif StructKeyExists(Arguments, "cobrandID") and Application.fn_IsIntegerPositive(Arguments.cobrandID)>
			AND primaryTargetID = #Application.fn_GetPrimaryTargetID("cobrandID")#
			AND targetID = #Arguments.cobrandID#
		</cfif>
		<cfif StructKeyExists(Arguments, "languageID")>
			AND languageID = '#Arguments.languageID#'
		</cfif>
		<cfif StructKeyExists(Arguments, "headerFooterIndicator") and ListFind("0,1", Arguments.headerFooterIndicator)>
			AND headerFooterIndicator = #Arguments.headerFooterIndicator#
		</cfif>
	ORDER BY headerFooterIndicator
</cfquery>
