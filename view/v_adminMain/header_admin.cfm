<cfoutput>
<html>
<head>
	<title>#Application.billingSiteTitle#</title>
	<link rel="stylesheet" type="text/css" href="#Application.billingUrlroot#/billing.css">
</head>

<body bgcolor="white" text="Black" marginwidth="0" marginheight="0" topmargin="0" leftmargin="10"<cfif IsDefined("URL.method")> onload="InitMenu()" id="Bdy" onclick="HideMenu(menuBar)"</cfif>>
</cfoutput>

<cfheader name="Cache-Control" value="no-cache, no-store, max-age=0, must-revalidate">
<cfheader name="Expires" value="Fri, 01 Jan 1990 00:00:00 GMT">
<cfheader name="Pragma" value="no-cache">
