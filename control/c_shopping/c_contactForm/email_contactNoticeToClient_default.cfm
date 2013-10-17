<cfmail
	From="#qry_selectContactTopic.contactTopicEmail#"
	To="#qry_selectContactTopic.contactTopicEmail#"
	Subject="#qry_selectContactTopic.contactTopicName#"
	Username="#Application.billingEmailUsername#"
	Password="#Application.billingEmailPassword#">
A visitor has just submitted the Contact Us form. Below is the relevant information:

Reason for Contact: #qry_selectContactTopic.contactTopicName#

Submitted by:
#Form.firstName# #Form.lastName#
<cfif Form.companyName is not "">#Form.companyName#</cfif>
#Form.email#

<cfif Form.phoneAreaCode is not "">(#Form.phoneAreaCode#) #Form.phoneNumber# <cfif Form.phoneExtension is not ""> ext. #Form.phoneExtension#</cfif></cfif>
<cfif Form.address is not "">
#Form.address#
#Form.city#, #Form.state# #Form.zipCode#
#Form.country#
</cfif>

Subject: #Form.contactSubject#
Message:
#Form.contactMessage#

</cfmail>

