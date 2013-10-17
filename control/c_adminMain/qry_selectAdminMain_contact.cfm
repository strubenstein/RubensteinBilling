<cfquery Name="qry_selectAdminMain_contact" Datasource="#Application.billingDsn#" Username="#Application.billingDsnUsername#" Password="#Application.billingDsnPassword#">
	SELECT avContactTopic.contactTopicID, avContactTopic.contactTopicName, COUNT(avContact.contactTopicID) AS contactCount
	FROM avContactTopic, avContact
	WHERE avContactTopic.contactTopicID = avContact.contactTopicID
		AND avContact.contactByCustomer = <cfqueryparam Value="1" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND avContact.contactStatus = <cfqueryparam Value="0" cfsqltype="#Application.billingSql.cfSqlType_bit#">
		AND avContactTopic.companyID = <cfqueryparam Value="#Session.companyID_author#" cfsqltype="cf_sql_integer">
	GROUP BY avContactTopic.contactTopicID, avContactTopic.contactTopicName
	HAVING COUNT(avContact.contactTopicID) > <cfqueryparam Value="0" cfsqltype="cf_sql_integer">
	ORDER BY avContactTopic.contactTopicName
</cfquery>

