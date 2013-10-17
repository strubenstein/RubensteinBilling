<!--- -->
<fusedoc language="ColdFusion" specification="2.0">
	<responsibilities> 
		I take a search engine safe URL and copy the variables
		it contains into the URL structure, based on the SES 
		functionality of formurl2attributessearch.cfm by 
		Steve Nelson.
		
		Instead of using index.cfm?variable=value you would use:
		index.cfm/variables/value.cfm
		If you are using formURL2attributes, you will call this tag first
		If you use this tag you won't use formurl2attributesSearch
	</responsibilities>
	<properties>
		<property name="version" value="1.72" />
		<property name="lastUpdated" value="20-Apr-2004" />
		<history author="Bert Dawson" email="bert@redbanner.com" role="Architect" type="Create"/>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Create">
			Made a ton of changes to Bert's code to make it
			more vanilla, and suited as a fbx file.  BETA!
		</history>
		<history author="Bert Dawson" email="bert@redbanner.com" role="Architect" type="Update">
			ping
		</history>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Update">
			pong
		</history>
		<history author="Bert Dawson" email="bert@redbanner.com" role="Architect" type="Update">
			ping
		</history>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Update">
			pong
		</history>
		<history author="Bert Dawson" email="bert@redbanner.com" role="Architect" type="Update">
			ping
		</history>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Update">
			pong!
			Added the "super friendly" option of making this file
			called as a tag or not.  You can pass the variables in
			via request, variables, or attributes scope.  The variable
			containing the basehref is set to caller.* when called
			as a custom tag.
		</history>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Update">
			(ping pong ping)
			Bert submitted code to add a user defined variable for the
			string we use to denote NULL values (sesEmptyString).
			
			Removed check for Len(SESdummyExtension) in the initialization code
			since it's redundant (Bert).
			
			1.3 didn't work right with some Apache web servers.  Apache/cgi.request_uri
			seems to be the equiv to IIS/cgi.path_info.  path_info can still exist
			with Apache, but without the template information.  Added code to 
			check for request_uri, then path_info, then just set it blank if
			neither has a value (Erik).
		</history>
		<history author="Bert Dawson" email="bert@redbanner.com" role="Architect" type="Update">
			pang!
			removed IsDefined() checks on cgi vars since this will always return true
			the line that adds null values between adjacent slashes was using the 
			string "null" - now uses the variable #emptyString# (NB the // trick
			doesn't work on win2k/CF5/IIS - the cgi.path_info never has double slashes in it...)
		</history>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Update">
			Some versions of Apache will choke when a template name is not sent in
			the URL (e.g. http://www.foo.com -vs- http://www.foo.com/index.cfm)
			
			Fusedocs had a minor bug - default value of SESrBaseName is baseHref, not base.
			
			a double slash to denote a null variable value does not work in IIS.  Just use
			the keyword NULL for the value instead (can be changed below if needed)
			
			Variables with spaces in their names didn't carry over right in Apache.  Fixed.
		</history>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Update">
			Changed code to parse URLs differently.  Should now work on all version of 
			Apache, IIS, Netscape and iPlanet web servers.
			
			Also changed visual formating of this code a little bit to make Bert happy.
		</history>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Update">
			Minor change to prevent error thrown when template is omitted from URL using Apache
		</history>
		<history author="Erik Voldengen" email="erikv@fusium.com" role="Architect" type="Update">
			Previous change caused problems with CF5/IIS.  Corrected the code.
		</history>
	</properties>
	<io>
		<in>
			<string name="SESrBaseName" scope="variables" default="baseHref" optional="Yes" comments="the variable name to return the base ref in" oncondition="set in variables scope before this file is run"/>
			<string name="SESrBaseName" scope="attributes" default="baseHref" optional="Yes" comments="the variable name to return the base ref in" oncondition="called as custom tag and passed as a parameter"/>
			<string name="SESrBaseName" scope="request" default="baseHref" optional="Yes" comments="the variable name to return the base ref in" oncondition="set in request scope before this file is run"/>
			
			<string name="SESdummyExtension" scope="variables" optional="Yes" comments="the dummy extension (including the '.') to remove from the end if the cgi.path_info before it is converted to URL scope variables" oncondition="called as a custom tag"/>
			<string name="SESdummyExtension" scope="attributes" optional="Yes" comments="the dummy extension (including the '.') to remove from the end if the cgi.path_info before it is converted to URL scope variables" oncondition="called as a custom tag"/>
			<string name="SESdummyExtension" scope="request" optional="Yes" comments="the dummy extension (including the '.') to remove from the end if the cgi.path_info before it is converted to URL scope variables" oncondition="called as a custom tag"/>

			<string name="SESemptyString" scope="variables" optional="Yes" default="#request.SESemptyString#" comments="url values which equal this will be changed to be empty string"/>
			<string name="SESemptyString" scope="attributes" optional="Yes" default="#request.SESemptyString#" comments="url values which equal this will be changed to be empty string"/>
			<string name="SESemptyString" scope="request" optional="Yes" default="null" comments="url values which equal this will be changed to be empty string"/>
		</in>
		<out>
			<string scope="variables" name="#rBaseName#" optional="No"  comments="the variable containing the <base href>, name passed in above" />
		</out>
	</io>
</fusedoc> ---><cfscript>

//First off - get the variable names defined

/* Depending on how this tag was called, set the baseHREF
      variable name, and dummy Extension value */
if (listlast(getbasetaglist()) IS "CF_SESCONVERTER") {
	baseVarName="caller.baseHREF";
	
	if (isDefined("attributes.SESrBaseName") AND Len(attributes.SESrBaseName)) {
		baseVarName="caller." & attributes.SESrBaseName;
	}
	else if (isDefined("request.SESrBaseName") and Len(request.SESrBaseName)) {
		baseVarName="caller." & request.SESrBaseName;
	}
	
	// Now Check for the dummy extension variable 
	dummyExtension=".htm";
	if (isDefined("attributes.SESdummyExtension")) {
		dummyExtension=attributes.SESdummyExtension;
	}
	else if (isDefined("request.SESdummyExtension")) {
		dummyExtension=request.SESdummyExtension;
	}
	
	// We use 'null' to denote null values by default.  You can can change it.
	emptyString = "null";
	if (isDefined("attributes.SESemptyString") AND Len(attributes.SESemptyString)) {
		emptyString=attributes.SESemptyString;
	}
	else if (isDefined("request.SESemptyString") AND Len(request.SESemptyString)) {
		emptyString=request.SESemptyString;
	}
}
//Otherwise, it's not a custom tag	
else { 
	baseVarName="baseHREF";
	if (isDefined("variables.SESrBaseName") and Len(variables.SESrBaseName)) {
		baseVarName = variables.SESrBaseName;
	}
	else if (isDefined("request.SESrBaseName") and Len(request.SESrBaseName)) {
		baseVarName = request.SESrBaseName;
	}
	
	// Now Check for the dummy extension variable
	dummyExtension=".htm";
	if (isDefined("variables.SESdummyExtension")) {
		dummyExtension=variables.SESdummyExtension;
	}
	else if (isDefined("request.SESdummyExtension")) {
		dummyExtension=request.SESdummyExtension;
	}
	
	// We use 'null' to denote null values by default.  You can can change it.
	emptyString = "null";
	if (isDefined("variables.SESemptyString") AND Len(variables.SESemptyString)) {
		emptyString=variables.SESemptyString;
	}
	else if (isDefined("request.SESemptyString") AND Len(request.SESemptyString)) {
		emptyString=request.SESemptyString;
	}
}

// Now, on with the SES conversion.

// depending on the web server, get the info from different cgi vars.

currentPath = '';

if (Len(cgi.request_uri)) {
 currentPath = cgi.request_uri;
}
else if (Len(cgi.path_info)) {
 currentPath = cgi.path_info;
}
if ((Len(currentPath)) AND ((Len(cgi.script_name) GT Len(currentPath)) OR (NOT find(".",currentPath)))) {
 currentPath = cgi.script_name;  
} 

/* only do stuff if currentPath has len, otherwise it breaks the RemoveChars() function */
if (Len(currentPath)) {

	/* replace any ?,&,= characters that are in the url for some reason */
	cleanpathinfo=REReplace(currentPath, "\&|\=", "/" ,"ALL");

	/* get everything after the first occurence of ".XXX/",
	   where XXX is .cfm, or whatever you use for your templates 
	   In other words, get the query string */	
	cleanpathinfo=RemoveChars(cleanpathinfo,1,Find("/",cleanpathinfo,Find(".",cleanpathinfo,1)));

	/* If it's a SES url, do all the crunching.  If not, skip it */
	if (Len(cleanpathinfo) AND cleanpathinfo NEQ CGI.Script_Name) {
		
		// Remove fake file extension, pass empty value to skip this  
		if (Len(dummyextension)) {
			if (Right(cleanpathinfo,Len(dummyextension)) IS dummyextension) {
				cleanpathinfo = Left(cleanpathinfo,Len(cleanpathinfo)-Len(dummyextension));
			}
		}

		// add a null value if there is a trailing slash
		if (Right(cleanpathinfo,1) IS '/') {
			cleanpathinfo = cleanpathinfo & emptyString;
		}
		
		//add null values between adjacent slashes
		cleanpathinfo = Replace(cleanpathinfo,"//","/" & emptyString & "/","all");

		// get a copy of anything in the url scope
		originalURL = Duplicate(url);

	 	SlashLen = ListLen(cleanpathinfo,"/");
		for (i=1; i LTE SlashLen; i=i+2) {
			/* get this item from the list into the local var i */
			urlname = ListGetAt(cleanpathinfo, i, '/');
			if (i LT SlashLen) {
				urlvalue = ListGetAt(cleanpathinfo, i+1, '/');
				urlvalue = replacenocase(urlvalue,"slash_","/","all");
				if (urlvalue IS emptyString) { 
					urlvalue = "";
				}
				StructInsert(url, urlname, urlvalue, true); 
			}
		}

		// return stuff that was in the url scope originally
		StructAppend(url,originalURL,true);
	}
}

// now sort out the base href 
s_Prefix = "http";
if (CGI.HTTPS EQ "ON") {
	s_Prefix = "https";
}
s_Port = "";
if (CGI.SERVER_PORT NEQ "80") {
	s_Port = ":" & CGI.SERVER_PORT;
}

s_Base = REReplace(CGI.SCRIPT_NAME, "[^/]+\.cfm.*", "");
s_Base= s_Prefix & "://" & CGI.SERVER_NAME & s_Port & s_Base;

"#baseVarName#" = s_Base;
</cfscript>