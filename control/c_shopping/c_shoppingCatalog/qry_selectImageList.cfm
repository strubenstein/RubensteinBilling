<cfquery Name="qry_selectImageList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT targetID AS productID, imageID, imageURL, imageTag, imageOrder,
		imageHasThumbnail, imageID_parent, imageIsThumbnail
	FROM avImage
	WHERE imageStatus = 1
		AND primaryTargetID = #Application.fn_GetPrimaryTargetID("productID")#
		AND targetID IN 
		<cfif StructKeyExists(Arguments, "productID") and Application.fn_IsIntegerList(Arguments.productID)>
			(#Arguments.productID#)
		<cfelse>
			(0)
		</cfif>
		<cfif StructKeyExists(Arguments, "imageIsThumbnail") and ListFind("0,1", Arguments.imageIsThumbnail)>
			AND imageIsThumbnail = #Arguments.imageIsThumbnail#
		</cfif>
		<cfif StructKeyExists(Arguments, "imageHasThumbnail") and ListFind("0,1", Arguments.imageHasThumbnail)>
			AND imageHasThumbnail = #Arguments.imageHasThumbnail#
		</cfif>
		<cfif StructKeyExists(Arguments, "imageID") and Application.fn_IsIntegerList(Arguments.imageID)>
			AND imageID IN (#Arguments.imageID#)
		</cfif>
		<cfif StructKeyExists(Arguments, "imageOrder_from") and StructKeyExists(Arguments, "imageOrder_to")
				and Application.fn_IsIntegerNonNegative(Arguments.imageOrder_from) and Application.fn_IsIntegerNonNegative(Arguments.imageOrder_to)
				and Arguments.imageOrder_to gte Arguments.imageOrder_from>
			AND imageOrder BETWEEN #Arguments.imageOrder_from# AND #Arguments.imageOrder_to#
		</cfif>
	ORDER BY imageOrder, imageIsThumbnail DESC
</cfquery>

