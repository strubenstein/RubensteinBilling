<cfoutput>
<p class="MainText">
Below are the fields you may enter in the contact management templates.<br>
They will automatically be replaced with the appropriate value.<br>
All fields use double brackets to distinguish them from standard html.<br>
Fields may be used in the subject or message body except for phone numbers,<br>
shipping address fields and billing address fields, which are message body only.
</p>

<table border="0" cellspacing="0" cellpadding="3" class="TableText">
<tr><td bgcolor="ffffff" colspan="3"><b>Dates - General dates when email is sent (e.g., #DateFormat(Now(), "mmmm dd, yyyy")#).</b></td></tr>
<tr valign="top">
	<td width="200"><code>&lt;&lt;dateToday&gt;&gt;<br></code></td>
	<td width="200"><code>&lt;&lt;dateTomorrow&gt;&gt;<br></code></td>
	<td width="200"><code>&lt;&lt;dateYesterday&gt;&gt;<br></code></td>
</tr>

<tr><td bgcolor="f4f4ff" colspan="3"><b>Customer Personal - Information about the person being emailed.</b></td></tr>
<tr valign="top" bgcolor="f4f4ff"><td><code>
	&lt;&lt;userID&gt;&gt;<br>
	&lt;&lt;userID_custom&gt;&gt;<br>
	&lt;&lt;firstName&gt;&gt;<br>
	&lt;&lt;lastName&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;email&gt;&gt;<br>
	&lt;&lt;username&gt;&gt;<br>
	&lt;&lt;middleName&gt;&gt;<br>
	&lt;&lt;suffix&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;salutation&gt;&gt;<br>
	&lt;&lt;jobTitle&gt;&gt;<br>
	&lt;&lt;jobDepartment&gt;&gt;<br>
	&lt;&lt;jobDivision&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="ffffff" colspan="3"><b>Customer Phone - Phone numbers for the person being emailed. (Corporate phone numbers not available.)</b></td></tr>
<tr valign="top"><td><code>
	&lt;&lt;phoneHome&gt;&gt;<br>
	&lt;&lt;phoneFax&gt;&gt;<br>
	&lt;&lt;phoneBusiness&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;phoneMobile&gt;&gt;<br>
	&lt;&lt;phonePager&gt;&gt;<br>
	&lt;&lt;phoneDirect&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;phoneTollFree&gt;&gt;<br>
	&lt;&lt;phoneVoicemail&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="f4f4ff" colspan="3"><b>Customer Company - Information about the company of the person being emailed.</b></td></tr>
<tr valign="top" bgcolor="f4f4ff"><td><code>
	&lt;&lt;companyID&gt;&gt;<br>
	&lt;&lt;companyID_custom&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;companyName&gt;&gt;<br>
	&lt;&lt;companyDBA&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;companyURL&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="ffffff" colspan="3"><b>Invoice/Purchase - Information about the invoice/purchase being viewed.</b></td></tr>
<tr valign="top"><td><code>
	&lt;&lt;invoiceID&gt;&gt;<br>
	&lt;&lt;invoiceID_custom&gt;&gt;<br>
	&lt;&lt;invoiceShippingMethod&gt;&gt;<br>
	&lt;&lt;invoiceInstructions&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;invoiceTotal&gt;&gt;<br>
	&lt;&lt;invoiceTotalLineItem&gt;&gt;<br>
	&lt;&lt;invoiceTotalPaymentCredit&gt;&gt;<br>
	&lt;&lt;invoiceTotalTax&gt;&gt;<br>
	&lt;&lt;invoiceTotalShipping&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;invoiceDateClosed&gt;&gt;<br>
	&lt;&lt;invoiceDateDue&gt;&gt;<br>
	&lt;&lt;invoiceDatePaid&gt;&gt;<br>
	&lt;&lt;invoiceDateCompleted&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="f4f4ff" colspan="3"><b>Shipment Info - Designated shipment information for purchase shipment being viewed.</b></td></tr>
<tr valign="top" bgcolor="f4f4ff"><td><code>
	&lt;&lt;shipmentDateSent&gt;&gt;<br>
	&lt;&lt;shipmentDateReceived&gt;&gt;<br>
	&lt;&lt;shipmentCarrier&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;shipmentTrackingNumber&gt;&gt;<br>
	&lt;&lt;shipmentMethod&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;shipmentWeight&gt;&gt;<br>
	&lt;&lt;shipmentInstructions&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="ffffff" colspan="3"><b>Shipping Address - Designated shipping address for invoice/purchase being viewed.</b></td></tr>
<tr valign="top"><td><code>
	&lt;&lt;shippingAddressName&gt;&gt;<br>
	&lt;&lt;shippingAddressFull&gt;&gt;<br>
	&lt;&lt;shippingAddressStreet&gt;&gt;<br>
	&lt;&lt;shippingCounty&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;shippingAddress1&gt;&gt;<br>
	&lt;&lt;shippingAddress2&gt;&gt;<br>
	&lt;&lt;shippingAddress3&gt;&gt;<br>
	&lt;&lt;shippingCity&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;shippingState&gt;&gt;<br>
	&lt;&lt;shippingZipCode&gt;&gt;<br>
	&lt;&lt;shippingZipCodePlus4&gt;&gt;<br>
	&lt;&lt;shippingCountry&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="f4f4ff" colspan="3"><b>Billing Address - Designated billing address for invoice/purchase being viewed.</b></td></tr>
<tr valign="top" bgcolor="f4f4ff"><td><code>
	&lt;&lt;billingAddressName&gt;&gt;<br>
	&lt;&lt;billingAddressFull&gt;&gt;<br>
	&lt;&lt;billingAddressStreet&gt;&gt;<br>
	&lt;&lt;billingCounty&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;billingAddress1&gt;&gt;<br>
	&lt;&lt;billingAddress2&gt;&gt;<br>
	&lt;&lt;billingAddress3&gt;&gt;<br>
	&lt;&lt;billingCity&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;billingState&gt;&gt;<br>
	&lt;&lt;billingZipCode&gt;&gt;<br>
	&lt;&lt;billingZipCodePlus4&gt;&gt;<br>
	&lt;&lt;billingCountry&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="ffffff" colspan="3"><b>Admin Personal - Information about the user sending the email.</b></td></tr>
<tr valign="top"><td><code>
	&lt;&lt;adminUserID&gt;&gt;<br>
	&lt;&lt;adminUserID_custom&gt;&gt;<br>
	&lt;&lt;adminFirstName&gt;&gt;<br>
	&lt;&lt;adminLastName&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;adminEmail&gt;&gt;<br>
	&lt;&lt;adminUsername&gt;&gt;<br>
	&lt;&lt;adminMiddleName&gt;&gt;<br>
	&lt;&lt;adminSuffix&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;adminSalutation&gt;&gt;<br>
	&lt;&lt;adminJobTitle&gt;&gt;<br>
	&lt;&lt;adminJobDepartment&gt;&gt;<br>
	&lt;&lt;adminJobDivision&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="f4f4ff" colspan="3"><b>Admin Phone - Phone numbers for the user sending the email. (Corporate phone numbers not available.)</b></td></tr>
<tr valign="top" bgcolor="f4f4ff"><td><code>
	&lt;&lt;adminPhoneHome&gt;&gt;<br>
	&lt;&lt;adminPhoneFax&gt;&gt;<br>
	&lt;&lt;adminPhoneBusiness&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;adminPhoneMobile&gt;&gt;<br>
	&lt;&lt;adminPhonePager&gt;&gt;<br>
	&lt;&lt;adminPhoneDirect&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;adminPhoneTollFree&gt;&gt;<br>
	&lt;&lt;adminPhoneVoicemail&gt;&gt;<br>
</code></td></tr>

<tr><td bgcolor="ffffff" colspan="3"><b>Admin Company - Information about the company of the user sending the email.</b></td></tr>
<tr valign="top"><td><code>
	&lt;&lt;adminCompanyID&gt;&gt;<br>
	&lt;&lt;adminCompanyID_custom&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;adminCompanyName&gt;&gt;<br>
	&lt;&lt;adminCompanyDBA&gt;&gt;<br>
</code></td><td><code>
	&lt;&lt;adminCompanyURL&gt;&gt;<br>
</code></td></tr>
</table>

<p>
<table border="1" cellspacing="2" cellpadding="2" class="TableText">
<tr><td colspan="2" bgcolor="dddddd"><b>Template Field Explanations &amp; Definitions</b></td></tr>
<tr valign="top"><td>ID: </td><td>Internal primary key. Useful for including links to view/edit an item.</td></tr>
<tr valign="top" bgcolor="f4f4ff"><td>ID_custom: </td><td>Custom key specified by admin for an item.</td></tr>
<tr valign="top"><td>AddressFull: </td><td>Full address, including street, city, state, zip/postal and country if not US.</td></tr>
<tr valign="top" bgcolor="f4f4ff"><td>AddressStreet: </td><td>Combines the 3 address lines.</td></tr>
<tr valign="top"><td>invoiceDateClosed: </td><td>Date the invoice/purchase was closed so that no new line items were added.<br>For shopping cart, it's when customer checks out.</td></tr>
<tr valign="top" bgcolor="f4f4ff"><td>invoiceDateCompleted: </td><td>Date invoice/purchase was done being processed by admin.</td></tr>
<tr valign="top"><td>invoiceTotal: </td><td>Total amount of invoice//purchase, including shipping, all line items and taxes.</td></tr>
<tr valign="top" bgcolor="f4f4ff"><td>invoiceTotalLineItem: </td><td>Total amount of line items (products) on invoice/purchase.</td></tr>
<tr valign="top"><td>invoiceTotalPaymentCredit </td><td>Total amount of credits applied to invoice/purchase.</td></tr>
<tr valign="top" bgcolor="f4f4ff"><td>invoiceTotalTax: </td><td>Total amount of taxes on invoice/purchase.</td></tr>
<tr valign="top"><td>invoiceTotalShipping: </td><td>Total amount of shipping cost on invoice/purchase.</td></tr>
</table>
</p>
</cfoutput>

<tr valign="top"><td><code>&lt;&lt;&gt;&gt;</code></td><td></td></tr>
<tr bgcolor="f4f4ff"><td><code>&lt;&lt;&gt;&gt;</code></td><td></td></tr>

<table border="1" cellspacing="2" cellpadding="2" class="TableText">
<tr class="TableHeader">
	<th>Field Name</th>
	<th>Meaning</th>
</tr>
<tr>
	<td><code>&lt;&lt;firstName&gt;&gt;</code></td>
	<td>First name of person being emailed</td>
</tr>
<tr>
	<td><code>&lt;&lt;lastName&gt;&gt;</code></td>
	<td>Last name of person being emailed</td>
</tr>
<tr>
	<td><code>&lt;&lt;email&gt;&gt;</code></td>
	<td>Email address of person being emailed</td>
</tr>

<tr>
	<td><code>&lt;&lt;companyName&gt;&gt;</code></td>
	<td>Company name of person being emailed</td>
</tr>

<tr>
	<td><code>&lt;&lt;adminFirstName&gt;&gt;</code></td>
	<td>First name of user sending email</td>
</tr>
<tr>
	<td><code>&lt;&lt;adminLastName&gt;&gt;</code></td>
	<td>Last name of user sending email</td>
</tr>
<tr>
	<td><code>&lt;&lt;adminEmail&gt;&gt;</code></td>
	<td>Email address of user sending email</td>
</tr>
<tr>
	<td><code>&lt;&lt;adminCompanyName&gt;&gt;</code></td>
	<td>Company name of user sending email</td>
</tr>
</table>


DATE - MESSAGE & SUBJECT
dateToday
dateTomorrow
dateYesterday

CUSTOMER COMPANY INFO - MESSAGE & SUBJECT
companyID
companyName
companyDBA
companyURL
companyID_custom

CUSTOMER PERSONAL INFO - MESSAGE & SUBJECT
firstName
lastName
email
username
middleName
suffix
salutation
jobTitle
jobDepartment
jobDivision
userID
userID_custom

CUSTOMER PERSONAL PHONE - MESSAGE ONLY (no company phone)
phoneHome
phoneFax
phoneBusiness
phoneMobile
phonePager
phoneDirect
phoneTollFree
phoneVoicemail

INVOICE INFORMATION - MESSAGE & SUBJECT
invoiceID
invoiceID_custom
invoiceDateClosed
invoiceDatePaid
invoiceTotal
invoiceTotalShipping
invoiceTotalLineItem
invoiceTotalPaymentCredit
invoiceTotalTax
invoiceDateCompleted
invoiceShippingMethod
invoiceInstructions

SHIPPING INFORMATION - MESSAGE & SUBJECT (how to identify shippingID?)
shipmentDateSent
shipmentDateReceived
shipmentCarrier
shipmentTrackingNumber
shipmentMethod
shipmentWeight
shipmentInstructions

SHIPPING ADDRESS - MESSAGE ONLY: (with invoiceID)
shippingAddressName
shippingAddressFull
shippingAddressStreet
shippingAddress1
shippingAddress2
shippingAddress3
shippingCity
shippingState
shippingZipCode
shippingZipCodePlus4
shippingCountry
shippingCounty

BILLING ADDRESS - MESSAGE ONLY: (with invoiceID)
billingAddressName
billingAddressFull
billingAddressStreet
billingAddress1
billingAddress2
billingAddress3
billingCity
billingState
billingZipCode
billingZipCodePlus4
billingCountry
billingCounty

ADMIN COMPANY - MESSAGE & SUBJECT
adminCompanyID
adminCompanyName
adminCompanyDBA
adminCompanyURL
adminCompanyID_custom

ADMIN USER - MESSAGE & SUBJECT:
adminUserID
adminUsername
adminFirstName
adminLastName
adminEmail
adminMiddleName
adminSuffix
adminSalutation
adminJobTitle
adminJobDepartment
adminJobDivision
adminUserID_custom

ADMIN PERSONAL PHONE - MESSAGE ONLY (no company phone)
adminPhoneHome
adminPhoneFax
adminPhoneBusiness
adminPhoneMobile
adminPhonePager
adminPhoneDirect
adminPhoneTollFree
adminPhoneVoicemail
