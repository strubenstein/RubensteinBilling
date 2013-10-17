<cfcomponent DisplayName="Image" Hint="Manages inserting, updating, deleting and viewing images">

<cffunction name="maxlength_Image" access="public" output="no" returnType="struct">
	<cfset var maxlength_Image = StructNew()>

	<cfset maxlength_Image.imageURL = 255>
	<cfset maxlength_Image.imageAlt = 100>
	<cfset maxlength_Image.imageOther = 100>
	<cfset maxlength_Image.imageTag = 600>

	<cfreturn maxlength_Image>
</cffunction>

<cffunction Name="insertImage" Access="public" Output="No" ReturnType="numeric" Hint="Insert image">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="Yes">
	<cfargument Name="imageURL" Type="string" Required="Yes">
	<cfargument Name="imageAlt" Type="string" Required="No" Default="">
	<cfargument Name="imageHeight" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageWidth" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageSize" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageBorder" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageOther" Type="string" Required="No" Default="">
	<cfargument Name="imageTag" Type="string" Required="Yes">
	<cfargument Name="imageStatus" Type="numeric" Required="No" Default="1">
	<cfargument Name="imageOrder" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageHasThumbnail" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageIsThumbnail" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageID_parent" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageUploaded" Type="numeric" Required="No" Default="0">
	<cfargument Name="imageDisplayCategory" Type="numeric" Required="No" Default="0">

	<cfset var qry_insertImageOrder_select = QueryNew("blank")>
	<cfset var qry_insertImage = QueryNew("blank")>

	<cfinvoke component="#Application.billingMapping#data.Image" method="maxlength_Image" returnVariable="maxlength_Image" />

	<cftransaction>
	<cfquery Name="qry_insertImage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		<cfif Arguments.imageOrder is not 0>
			UPDATE avImage
			SET imageOrder = imageOrder + 1
			WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
				AND imageOrder >= <cfqueryparam Value="#Arguments.imageOrder#" cfsqltype="cf_sql_smallint">;
		</cfif>

		INSERT INTO avImage
		(
			primaryTargetID, targetID, userID, imageURL, imageAlt, imageHeight, imageWidth, imageSize,
			imageBorder, imageOther, imageTag, imageStatus, imageOrder, imageHasThumbnail, imageIsThumbnail,
			imageID_parent, imageUploaded, imageDeleted, imageDisplayCategory, imageDateCreated, imageDateUpdated
		)
		VALUES
		(
			<cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.imageURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Image.imageURL#">,
			<cfqueryparam Value="#Arguments.imageAlt#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Image.imageAlt#">,
			<cfqueryparam Value="#Arguments.imageHeight#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.imageWidth#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.imageSize#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.imageBorder#" cfsqltype="cf_sql_tinyint">,
			<cfqueryparam Value="#Arguments.imageOther#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Image.imageOther#">,
			<cfqueryparam Value="#Arguments.imageTag#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Image.imageTag#">,
			<cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.imageOrder#" cfsqltype="cf_sql_smallint">,
			<cfqueryparam Value="#Arguments.imageHasThumbnail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.imageIsThumbnail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.imageID_parent#" cfsqltype="cf_sql_integer">,
			<cfqueryparam Value="#Arguments.imageUploaded#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			<cfqueryparam Value="#Arguments.imageDisplayCategory#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,
			#Application.billingSql.sql_nowDateTime#,
			#Application.billingSql.sql_nowDateTime#
		);

		#Replace(Application.billingSql.identityField_select, "primaryKeyField", "imageID", "ALL")#;
	</cfquery>

	<cfif Arguments.imageOrder is 0>
		<cfquery Name="qry_insertImageOrder_select" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			<cfif Arguments.imageIsThumbnail is 0>
				SELECT Max(imageOrder) AS maxImageOrder
				FROM avImage
				WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
					AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			<cfelse>
				SELECT imageOrder AS maxImageOrder
				FROM avImage
				WHERE imageID = <cfqueryparam Value="#Arguments.imageID_parent#" cfsqltype="cf_sql_integer">
			</cfif>
		</cfquery>

		<cfquery Name="qry_insertImageOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
			UPDATE avImage
			SET imageOrder = 
				<cfif Not IsNumeric(qry_insertImageOrder_select.maxImageOrder)>
					<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
				<cfelse>
					<cfif Arguments.imageIsThumbnail is 0><cfqueryparam Value="1" cfsqltype="cf_sql_smallint"> + </cfif>
					<cfqueryparam Value="#qry_insertImageOrder_select.maxImageOrder#" cfsqltype="cf_sql_smallint">
				</cfif>
			WHERE imageID = #qry_insertImage.primaryKeyID#
		</cfquery>
	</cfif>
	</cftransaction>

	<cfreturn qry_insertImage.primaryKeyID>
</cffunction>

<cffunction Name="updateImage" Access="public" Output="No" ReturnType="boolean" Hint="Update image">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="imageID" Type="numeric" Required="Yes">
	<cfargument Name="userID" Type="numeric" Required="No">
	<cfargument Name="imageURL" Type="string" Required="No">
	<cfargument Name="imageAlt" Type="string" Required="No">
	<cfargument Name="imageHeight" Type="numeric" Required="No">
	<cfargument Name="imageWidth" Type="numeric" Required="No">
	<cfargument Name="imageSize" Type="numeric" Required="No">
	<cfargument Name="imageBorder" Type="numeric" Required="No">
	<cfargument Name="imageOther" Type="string" Required="No">
	<cfargument Name="imageTag" Type="string" Required="No">
	<cfargument Name="imageStatus" Type="numeric" Required="No">
	<cfargument Name="imageOrder" Type="numeric" Required="No">
	<cfargument Name="imageHasThumbnail" Type="numeric" Required="No">
	<cfargument Name="imageIsThumbnail" Type="numeric" Required="No">
	<cfargument Name="imageID_parent" Type="numeric" Required="No">
	<cfargument Name="imageUploaded" Type="numeric" Required="No">
	<cfargument Name="imageDeleted" Type="numeric" Required="No">
	<cfargument Name="imageDisplayCategory" Type="numeric" Required="No">

	<cfinvoke component="#Application.billingMapping#data.Image" method="maxlength_Image" returnVariable="maxlength_Image" />

	<cfquery Name="qry_updateImage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avImage
		SET
			<cfif StructKeyExists(Arguments, "userID") and Application.fn_IsIntegerNonNegative(Arguments.userID)>userID = <cfqueryparam Value="#Arguments.userID#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "imageURL")>imageURL = <cfqueryparam Value="#Arguments.imageURL#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Image.imageURL#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageAlt")>imageAlt = <cfqueryparam Value="#Arguments.imageAlt#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Image.imageAlt#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageHeight") and Application.fn_IsIntegerNonNegative(Arguments.imageHeight)>imageHeight = <cfqueryparam Value="#Arguments.imageHeight#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "imageWidth") and Application.fn_IsIntegerNonNegative(Arguments.imageWidth)>imageWidth = <cfqueryparam Value="#Arguments.imageWidth#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "imageSize") and Application.fn_IsIntegerNonNegative(Arguments.imageSize)>imageSize = <cfqueryparam Value="#Arguments.imageSize#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "imageBorder") and Application.fn_IsIntegerNonNegative(Arguments.imageBorder)>imageBorder = <cfqueryparam Value="#Arguments.imageBorder#" cfsqltype="cf_sql_tinyint">,</cfif>
			<cfif StructKeyExists(Arguments, "imageOther")>imageOther = <cfqueryparam Value="#Arguments.imageOther#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Image.imageOther#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageTag")>imageTag = <cfqueryparam Value="#Arguments.imageTag#" cfsqltype="cf_sql_varchar" MaxLength="#maxlength_Image.imageTag#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageStatus") and ListFind("0,1", Arguments.imageStatus)>imageStatus = <cfqueryparam Value="#Arguments.imageStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageOrder") and Application.fn_IsIntegerNonNegative(Arguments.imageOrder)>imageOrder = <cfqueryparam Value="#Arguments.imageOrder#" cfsqltype="cf_sql_smallint">,</cfif>
			<cfif StructKeyExists(Arguments, "imageHasThumbnail") and ListFind("0,1", Arguments.imageHasThumbnail)>imageHasThumbnail = <cfqueryparam Value="#Arguments.imageHasThumbnail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageIsThumbnail") and ListFind("0,1", Arguments.imageIsThumbnail)>imageIsThumbnail = <cfqueryparam Value="#Arguments.imageIsThumbnail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageID_parent") and Application.fn_IsIntegerNonNegative(Arguments.imageID_parent)>imageID_parent = <cfqueryparam Value="#Arguments.imageID_parent#" cfsqltype="cf_sql_integer">,</cfif>
			<cfif StructKeyExists(Arguments, "imageUploaded") and ListFind("0,1", Arguments.imageUploaded)>imageUploaded = <cfqueryparam Value="#Arguments.imageUploaded#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageDeleted") and ListFind("0,1", Arguments.imageDeleted)>imageDeleted = <cfqueryparam Value="#Arguments.imageDeleted#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			<cfif StructKeyExists(Arguments, "imageDisplayCategory") and ListFind("0,1", Arguments.imageDisplayCategory)>imageDisplayCategory = <cfqueryparam Value="#Arguments.imageDisplayCategory#" cfsqltype="#Application.billingSql.cfSqlType_bit#">,</cfif>
			imageDateUpdated = #Application.billingSql.sql_nowDateTime#
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">		AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			AND imageID = <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="selectImage" Access="public" Output="No" ReturnType="query" Hint="Select image and thumbnail">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="imageID" Type="string" Required="Yes">
	<cfargument Name="isSelectImageThumbnail" Type="boolean" Required="No" Default="False">

	<cfset var qry_selectImage = QueryNew("blank")>

	<cfquery Name="qry_selectImage" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT imageID, userID, imageURL, imageAlt, imageHeight, imageWidth,
			imageSize, imageBorder, imageOther, imageTag, imageStatus,
			imageOrder, imageHasThumbnail, imageIsThumbnail, imageID_parent,
			imageUploaded, imageDeleted, imageDisplayCategory, imageDateCreated, imageDateUpdated
		FROM avImage
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			AND (imageID = <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
				<cfif Arguments.isSelectImageThumbnail is True>OR imageID_parent = <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer"></cfif>)
		ORDER BY imageIsThumbnail
	</cfquery>

	<cfreturn qry_selectImage>
</cffunction>

<cffunction Name="selectImageList" Access="public" Output="No" ReturnType="query" Hint="Select images">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="imageID" Type="string" Required="No">
	<cfargument Name="imageStatus" Type="numeric" Required="No">
	<cfargument Name="imageHasThumbnail" Type="numeric" Required="No">
	<cfargument Name="imageIsThumbnail" Type="numeric" Required="No">
	<cfargument Name="imageOrder_from" Type="numeric" Required="No">
	<cfargument Name="imageOrder_to" Type="numeric" Required="No">

	<cfset var qry_selectImageList = QueryNew("blank")>

	<cfquery Name="qry_selectImageList" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		SELECT imageID, userID, imageURL, imageAlt, imageHeight, imageWidth,
			imageSize, imageBorder, imageOther, imageTag, imageStatus,
			imageOrder, imageHasThumbnail, imageIsThumbnail, imageID_parent,
			imageUploaded, imageDeleted, imageDisplayCategory,
			imageDateCreated, imageDateUpdated
		FROM avImage
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			<cfif StructKeyExists(Arguments, "imageIsThumbnail") and ListFind("0,1", Arguments.imageIsThumbnail)>
				AND imageIsThumbnail = <cfqueryparam Value="#Arguments.imageIsThumbnail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "imageHasThumbnail") and ListFind("0,1", Arguments.imageHasThumbnail)>
				AND imageHasThumbnail = <cfqueryparam Value="#Arguments.imageHasThumbnail#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "imageStatus") and ListFind("0,1", Arguments.imageStatus)>
				AND imageStatus = <cfqueryparam Value="#Arguments.imageStatus#" cfsqltype="#Application.billingSql.cfSqlType_bit#">
			</cfif>
			<cfif StructKeyExists(Arguments, "imageID") and Application.fn_IsIntegerList(Arguments.imageID)>
				AND imageID IN (<cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer" List="Yes" Separator=",">)
			</cfif>
			<cfif StructKeyExists(Arguments, "imageOrder_from") and StructKeyExists(Arguments, "imageOrder_to")
					and Application.fn_IsIntegerNonNegative(Arguments.imageOrder_from) and Application.fn_IsIntegerNonNegative(Arguments.imageOrder_to)
					and Arguments.imageOrder_to gte Arguments.imageOrder_from>
				AND imageOrder BETWEEN 
					<cfqueryparam Value="#Arguments.imageOrder_from#" cfsqltype="cf_sql_smallint">
					AND 
					<cfqueryparam Value="#Arguments.imageOrder_to#" cfsqltype="cf_sql_smallint">
			</cfif>
		ORDER BY imageOrder, imageIsThumbnail
	</cfquery>

	<cfreturn qry_selectImageList>
</cffunction>

<cffunction Name="updateImageOrder" Access="public" Output="No" ReturnType="boolean" Hint="Update image order">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="imageOrder" Type="numeric" Required="Yes">
	<cfargument Name="imageOrder_direction" Type="string" Required="Yes">
	<cfargument Name="imageID" Type="string" Required="No">

	<cfquery Name="qry_updateImageOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avImage
		SET imageOrder = imageOrder 
			<cfif Arguments.imageOrder_direction is "moveImageDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			AND imageOrder >= <cfqueryparam Value="#Arguments.imageOrder#" cfsqltype="cf_sql_smallint">
			<cfif StructKeyExists(Arguments, "imageID")>AND imageID <> <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer"></cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

<cffunction Name="switchImageOrder" Access="public" Output="No" ReturnType="boolean" Hint="Switch image order">
	<cfargument Name="primaryTargetID" Type="numeric" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="imageOrder_direction" Type="string" Required="Yes">
	<cfargument Name="imageID" Type="numeric" Required="Yes">

	<cfquery Name="qry_switchImageOrder" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
		UPDATE avImage
		SET imageOrder = imageOrder 
			<cfif Arguments.imageOrder_direction is "moveImageDown"> + <cfelse> - </cfif> 
			<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
		WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
			AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
			AND 
			(
				imageID = <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
				OR
				imageID_parent = <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
			);

		<cfif Application.billingDatabase is "MySQL">
			UPDATE avImage INNER JOIN avImage AS avImage2
			SET avImage.imageOrder = avImage.imageOrder 
				<cfif Arguments.imageOrder_direction is "moveImageDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE avImage.imageOrder = avImage2.imageOrder
				AND avImage.primaryTargetID = avImage2.primaryTargetID
				AND avImage.primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND avImage.targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
				AND avImage.imageID <> <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
				AND avImage.imageID_parent <> <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
				AND avImage2.imageID = <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">;
		<cfelse>
			UPDATE avImage
			SET imageOrder = imageOrder 
				<cfif Arguments.imageOrder_direction is "moveImageDown"> - <cfelse> + </cfif> 
				<cfqueryparam Value="1" cfsqltype="cf_sql_smallint">
			WHERE primaryTargetID = <cfqueryparam Value="#Arguments.primaryTargetID#" cfsqltype="cf_sql_integer">
				AND targetID = <cfqueryparam Value="#Arguments.targetID#" cfsqltype="cf_sql_integer">
				AND imageID <> <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
				AND imageID_parent <> <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
				AND imageOrder = 
					(
					SELECT imageOrder
					FROM avImage
					WHERE imageID = <cfqueryparam Value="#Arguments.imageID#" cfsqltype="cf_sql_integer">
					);
		</cfif>
	</cfquery>

	<cfreturn True>
</cffunction>

</cfcomponent>
