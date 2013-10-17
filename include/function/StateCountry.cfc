<cfcomponent displayName="StateCountry" hint="Manages list of states and countries">

<cffunction name="stateStruct" access="public" output="no" returnType="struct" hint="Returns structure of states/provinces used in form">
	<cfset var stateStruct = StructNew()>

	<cfset stateStruct.usa_abbrByName = "AL,AK,AZ,AR,CA,CO,CT,DC,DE,FL,GA,GU,HI,ID,IL,IN,IA,KS,KY,LA,ME,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,OH,OK,OR,PA,PR,RI,SC,SD,TN,TX,UT,VT,VI,VA,WA,WV,WI,WY">
	<cfset stateStruct.usa_nameByName = "Alabama,Alaska,Arizona,Arkansas,California,Colorado,Connecticut,D.C.,Delaware,Florida,Georgia,Guam,Hawaii,Idaho,Illinois,Indiana,Iowa,Kansas,Kentucky,Louisiana,Maine,Maryland,Massachusetts,Michigan,Minnesota,Mississippi,Missouri,Montana,Nebraska,Nevada,New Hampshire,New Jersey,New Mexico,New York,North Carolina,North Dakota,Ohio,Oklahoma,Oregon,Pennsylvania,Puerto Rico,Rhode Island,South Carolina,South Dakota,Tennessee,Texas,Utah,Vermont,Virgin Islands,Virginia,Washington,West Virginia,Wisconsin,Wyoming">

	<cfset stateStruct.usa_abbrByAbbr = "AK,AL,AR,AZ,CA,CO,CT,DC,DE,FL,GA,GU,HI,IA,ID,IL,IN,KS,KY,LA,MA,MD,ME,MI,MN,MO,MS,MT,NC,ND,NE,NH,NJ,NM,NV,NY,OH,OK,OR,PA,PR,RI,SC,SD,TN,TX,UT,VA,VI,VT,WA,WI,WV,WY">
	<cfset stateStruct.usa_nameByAbbr = "Alaska,Alabama,Arkansas,Arizona,California,Colorado,Connecticut,D.C.,Delaware,Florida,Georgia,Guam,Hawaii,Iowa,Idaho,Illinois,Indiana,Kansas,Kentucky,Louisiana,Massachusetts,Maryland,Maine,Michigan,Minnesota,Missouri,Mississippi,Montana,North Carolina,North Dakota,Nebraska,New Hampshire,New Jersey,New Mexico,Nevada,New York,Ohio,Oklahoma,Oregon,Pennsylvania,Puerto Rico,Rhode Island,South Carolina,South Dakota,Tennessee,Texas,Utah,Virginia,Virgin Islands,Vermont,Washington,Wisconsin,West Virginia,Wyoming">

	<cfset stateStruct.canada_abbrByName = "AB,BC,MB,NB,NL,NT,NS,ON,PE,QC,SK,YT">
	<cfset stateStruct.canada_nameByName = "Alberta,British Columbia,Manitoba,New Brunswick,Newfoundland,Northwest Territories,Nova Scotia,Ontario,Prince Edward Island,Quebec,Saskatchewan,Yukon">

	<cfset stateStruct.canada_abbrByAbbr = "AB,BC,MB,NB,NL,NS,NT,ON,PE,QC,SK,YT">
	<cfset stateStruct.canada_nameByAbbr = "Alberta,British Columbia,Manitoba,New Brunswick,Newfoundland,Nova Scotia,Northwest Territories,Ontario,Prince Edward Islands,Quebec,Saskatchewan,Yukon">

	<cfset stateStruct.usa_abbrByName_licensed = "AZ,CA,CO,CT,DC,DE,FL,GA,HI,ID,IL,IN,LA,ME,MD,MA,MI,NV,NH,NY,NC,OR,PA,RI,TN,TX,UT,VA,WA">
	<cfset stateStruct.usa_nameByName_licensed = "Arizona,California,Colorado,Connecticut,D.C.,Delaware,Florida,Georgia,Hawaii,Idaho,Illinois,Indiana,Louisiana,Maine,Maryland,Massachusetts,Michigan,Nevada,New Hampshire,New York,North Carolina,Oregon,Pennsylvania,Rhode Island,Tennessee,Texas,Utah,Virginia,Washington">

	<cfset stateStruct.usa_abbrByAbbr_licensed = "AZ,CA,CO,CT,DC,DE,FL,GA,HI,ID,IL,IN,LA,MA,MD,ME,MI,NC,NH,NV,NY,OR,PA,RI,TN,TX,UT,VA,WA">
	<cfset stateStruct.usa_nameByAbbr_licensed = "Arizona,California,Colorado,Connecticut,D.C.,Delaware,Florida,Georgia,Hawaii,Idaho,Illinois,Indiana,Louisiana,Massachusetts,Maryland,Maine,Michigan,North Carolina,New Hampshire,Nevada,New York,Oregon,Pennsylvania,Rhode Island,Tennessee,Texas,Utah,Virginia,Washington">

	<cfreturn stateStruct>
</cffunction>

<cffunction name="getStateList" access="public" output="no" returnType="struct" hint="Returns structure of label and display values for states/provinces">
	<cfargument name="labelIsFullState" type="boolean" required="no" default="True">
	<cfargument name="valueIsFullState" type="boolean" required="no" default="True">
	<cfargument name="displayUSStates" type="boolean" required="no" default="True">
	<cfargument name="displayCanadaProvinces" type="boolean" required="no" default="False">
	<cfargument name="displayUSBeforeCanada" type="boolean" required="no" default="True">

	<cfset var stateList = StructNew()>
	<cfset var displayCountryOption = "">

	<cfif Arguments.displayCanadaProvinces is False>
		<cfset displayCountryOption = "US">
	<cfelseif Arguments.displayUSStates is False>
		<cfset displayCountryOption = "Canada">
	<cfelseif Arguments.displayUSBeforeCanada is True>
		<cfset displayCountryOption = "US|Canada">
	<cfelse>
		<cfset displayCountryOption = "Canada|US">
	</cfif>

	<cfinvoke method="stateStruct" returnVariable="stateStruct" />

	<cfswitch expression="#Arguments.labelIsFullState#:#Arguments.valueIsFullState#:#displayCountryOption#">
	<cfcase Value="True:True:US"><!--- Display state / Store state / US only --->
		<cfset stateList.label = stateStruct.usa_nameByName>
		<cfset stateList.value = stateStruct.usa_nameByName>
	</cfcase>
	<cfcase Value="True:True:Canada"><!--- Display state / Store state / Canada only --->
		<cfset stateList.label = stateStruct.canada_nameByName>
		<cfset stateList.value = stateStruct.canada_nameByName>
	</cfcase>
	<cfcase Value="True:True:US|Canada"><!--- Display state / Store state / US,Canada --->
		<cfset stateList.label = stateStruct.usa_nameByName & "," & stateStruct.canada_nameByName>
		<cfset stateList.value = stateStruct.usa_nameByName & "," & stateStruct.canada_nameByName>
	</cfcase>
	<cfcase Value="True:True:Canada|US"><!--- Display state / Store state / Canada,US --->
		<cfset stateList.label = stateStruct.canada_nameByName & "," & stateStruct.usa_nameByName>
		<cfset stateList.value = stateStruct.canada_nameByName & "," & stateStruct.usa_nameByName>
	</cfcase>

	<cfcase Value="True:False:US"><!--- Display state / Store abbreviation / US only --->
		<cfset stateList.label = stateStruct.usa_nameByName>
		<cfset stateList.value = stateStruct.usa_abbrByName>
	</cfcase>
	<cfcase Value="True:False:Canada"><!--- Display state / Store abbreviation / Canada only --->
		<cfset stateList.label = stateStruct.canada_nameByName>
		<cfset stateList.value = stateStruct.canada_abbrByName>
	</cfcase>
	<cfcase Value="True:False:US|Canada"><!--- Display state / Store abbreviation / US,Canada --->
		<cfset stateList.label = stateStruct.usa_nameByName & "," & stateStruct.canada_nameByName>
		<cfset stateList.value = stateStruct.usa_abbrByName & "," & stateStruct.canada_abbrByName>
	</cfcase>
	<cfcase Value="True:False:Canada|US"><!--- Display state / Store abbreviation / Canada,US --->
		<cfset stateList.label = stateStruct.canada_nameByName & "," & stateStruct.usa_nameByName>
		<cfset stateList.value = stateStruct.canada_abbrByName & "," & stateStruct.usa_abbrByName>
	</cfcase>

	<cfcase Value="False:True:US"><!--- Display abbreviation / Store state / US only --->
		<cfset stateList.label = stateStruct.usa_abbrByAbbr>
		<cfset stateList.value = stateStruct.usa_nameByAbbr>
	</cfcase>
	<cfcase Value="False:True:Canada"><!--- Display abbreviation / Store state / Canada only --->
		<cfset stateList.label = stateStruct.canada_abbrByAbbr>
		<cfset stateList.value = stateStruct.canada_nameByAbbr>
	</cfcase>
	<cfcase Value="False:True:US|Canada"><!--- Display abbreviation / Store state / US,Canada --->
		<cfset stateList.label = stateStruct.usa_abbrByAbbr & "," & stateStruct.canada_abbrByAbbr>
		<cfset stateList.value = stateStruct.usa_nameByAbbr & "," & stateStruct.canada_nameByAbbr>
	</cfcase>
	<cfcase Value="False:True:Canada|US"><!--- Display abbreviation / Store state / Canada,US --->
		<cfset stateList.label = stateStruct.canada_abbrByAbbr & "," & stateStruct.usa_abbrByAbbr>
		<cfset stateList.value = stateStruct.canada_nameByAbbr & "," & stateStruct.usa_nameByAbbr>
	</cfcase>

	<cfcase Value="False:False:US"><!--- Display abbreviation / Store abbreviation / US only --->
		<cfset stateList.label = stateStruct.usa_abbrByAbbr>
		<cfset stateList.value = stateStruct.usa_abbrByAbbr>
	</cfcase>
	<cfcase Value="False:False:Canada"><!--- Display abbreviation / Store abbreviation / Canada only --->
		<cfset stateList.label = stateStruct.canada_abbrByAbbr>
		<cfset stateList.value = stateStruct.canada_abbrByAbbr>
	</cfcase>
	<cfcase Value="False:False:US|Canada"><!--- Display abbreviation / Store abbreviation / US,Canada --->
		<cfset stateList.label = stateStruct.usa_abbrByAbbr & "," & stateStruct.canada_abbrByAbbr>
		<cfset stateList.value = stateStruct.usa_abbrByAbbr & "," & stateStruct.canada_abbrByAbbr>
	</cfcase>
	<cfcase Value="False:False:Canada|US"><!--- Display abbreviation / Store abbreviation / Canada,US --->
		<cfset stateList.label = stateStruct.canada_abbrByAbbr & "," & stateStruct.usa_abbrByAbbr>
		<cfset stateList.value = stateStruct.canada_abbrByAbbr & "," & stateStruct.usa_abbrByAbbr>
	</cfcase>
	</cfswitch>

	<cfreturn stateList>
</cffunction>

<cffunction name="countryList" access="public" output="no" returnType="string" hint="Returns list of countries used in form">
	<cfreturn "Argentina,Australia,Austria,Belgium,Brazil,Canada,Caribbean,Chile,China,Colombia,Czech Republic,Denmark,Europe,Finland,France,Germany,Hong Kong,Hungary,India,Ireland,Israel,Italy,Japan,Korea,Latin America,Luxemburg,Malaysia,Mexico,Middle East,Netherlands,New Zealand,North Africa,Norway,Peru,Poland,Portugal,Russia,Singapore,Slovakia,Slovenija,South Africa,Spain,Sweden,Switzerland,Taiwan,Thailand,Turkey,UK,USA,Uruguay,Venezuela">
</cffunction>

<cffunction name="countryStruct" access="public" output="no" returnType="struct" hint="Returns structure of lists of countries">
	<cfset countryStruct = StructNew()>

	<cfset countryStruct.abbr_short = "AR,AU,AT,BR,CA,CL,CN,CO,DK,FI,FR,DE,IE,IT,JP,KR,MX,NO,ES,SE,TW,GB,US,VE">
	<cfset countryStruct.name_short = "Argentina,Australia,Austria,Brazil,Canada,Chile,China,Colombia,Denmark,Finland,France,Germany,Ireland,Italy,Japan,Mexico,Norway,South Korea,Spain,Sweden,Taiwan,United Kingdom,United States,Venezuela">

	<cfset countryStruct.name_medium = "Argentina,Australia,Austria,Belgium,Brazil,Canada,Caribbean,Chile,China,Colombia,Czech Republic,Denmark,Europe,Finland,France,Germany,Hong Kong,Hungary,India,Ireland,Israel,Italy,Japan,Korea,Latin America,Luxemburg,Malaysia,Mexico,Middle East,Netherlands,New Zealand,North Africa,Norway,Peru,Poland,Portugal,Russia,Singapore,Slovakia,Slovenija,South Africa,Spain,Sweden,Switzerland,Taiwan,Thailand,Turkey,UK,USA,Uruguay,Venezuela">

	<cfset countryStruct.abbr_long = "AF,AL,DZ,AS,AD,AI,AQ,AG,AR,AM,AW,AU,AT,AZ,BS,BH,BD,BB,BY,BE,BZ,BJ,BM,BT,BO,BA,BW,BV,BR,IO,BN,BG,BF,BI,KH,CM,CA,CV,KY,CF,TD,CL,CN,HK,MO,CX,CC,Is,CO,KM,CK,CR,CI,HR,CY,CZ,CD,DK,DJ,DM,DO,TP,EC,EG,SV,GQ,ER,EE,ET,MK,F.Y.R.O.,FK,FO,FJ,FI,FR,GF,PF,TF,GA,GM,GE,DE,GH,GI,GR,GL,GD,GP,GU,GT,GN,GW,GY,HT,HM,HN,HU,IS,IN,ID,IE,IL,IT,JM,JP,JO,KZ,KE,KI,KR,KW,KG,LV,LB,LS,LR,LI,LT,LU,MG,MW,MY,MV,ML,MT,MH,MQ,MR,MU,YT,MX,FM,MD,MC,MN,MS,MA,MZ,MM,NA,NR,NP,NL,AN,NC,NZ,NI,NE,NG,NU,NF,MP,NO,OM,PK,PW,PA,PG,PY,PE,PH,PN,PL,PT,PR,QA,CG,RE,RO,RU,SH,KN,LC,PM,VC,WS,WM,ST,SA,SN,SC,SL,SG,SK,SI,SB,SO,ZA,GS,ES,LK,SR,SJ,SZ,SE,CH,SY,TW,TJ,TZ,TH,TL,TG,TK,TO,TT,TN,TR,TM,TC,TV,UG,UA,AE,GB,US,UM,UY,UZ,VU,VA,VE,VN,VG,VI,WF,EH,YE,ZM,ZW">
	<cfset countryStruct.name_long = "Afghanistan,Albania,Algeria,American Samoa,Andorra,Anguilla,Antarctica,Antigua And Barbuda,Argentina,Armenia,Aruba,Australia,Austria,Ayerbaijan,Bahamas (The),Bahrain,Bangladesh,Barbados,Belarus,Belgium,Belize,Benin,Bermuda,Bhutan,Bolivia,Bosnia and Herzegovina,Botswana,Bouvet Is,Brazil,British Indian Ocean Territory,Brunei,Bulgaria,Burkina Faso,Burundi,Cambodia,Cameroon,Canada,Cape Verde,Cayman Is,Central African Republic,Chad,Chile,China,China (Hong Kong S.A.R.),China (Macau S.A.R.),Christmas Is,Cocos (Keeling) Is,Colombia,Comoros,Cook Islands,Costa Rica,Cote D'Ivoire (Ivory Coast),Croatia (Hrvatska),Cyprus,Czech Republic,Democratic Republic of the Congo,Denmark,Djibouti,Dominica,Dominican Republic,East Timor,Ecuador,Egypt,El Salvador,Equatorial Guinea,Eritrea,Estonia,Ethiopia,F.Y.R.O. Macedonia,Falkland Is (Is Malvinas),Faroe Islands,Fiji Islands,Finland,France,French Guiana,French Polynesia,French Southern Territories,Gabon,Gambia (The),Georgia,Germany,Ghana,Gibraltar,Greece,Greenland,Grenada,Guadeloupe,Guam,Guatemala,Guinea,Guinea-Bissau,Guyana,Haiti,Heard and McDonald Is,Honduras,Hungary,Iceland,India,Indonesia,Ireland,Israel,Italy,Jamaica,Japan,Jordan,Kayakhstan,Kenya,Kiribati,Kuwait,Kyrgyzstan,Latvia,Lebanon,Lesotho,Liberia,Liechtenstein,Lithuania,Luxembourg,Madagascar,Malawi,Malaysia,Maldives,Mali,Malta,Marshall Is,Martinique,Mauritania,Mauritius,Mayotte,Mexico,Micronesia,Moldova,Monaco,Mongolia,Montserrat,Morocco,Mozambique,Myanmar,Namibia,Nauru,Nepal,Netherlands (The), Netherlands Antilles,New Caledonia,New Zealand,Nicaragua,Niger,Nigeria,Niue,Norfolk Island,North Korea,Northern Mariana Is,Norway,Oman,Pakistan,Palau=,Panama,Papua New Guinea,Paraguay,Peru,Philippines,Pitcairn Island,Poland,Portugal,Puerto Rico,Qatar,Republic of the Congo,Reunion,Romania,Russia,Saint Helena,Saint Kitts And Nevis,Saint Lucia,Saint Pierre and Miquelon,Saint Vincent And The Grenadines,Samoa,San Marino,Sao Tome and Principe,Saudi Arabia,Senegal,Seychelles,Sierra Leone,Singapore,Slo	vakia,Slovenia,Solomon Islands,Somalia,South Africa,South Georgia &amp; The S. Sandwich Is,South Korea,Spain,Sri Lanka,Suriname,Svalbard And Jan Mayen Is,Swaziland,Sweden,Switzerland,Syria,Taiwan,Tajikistan,Tanzania,Thailand,Timor-Leste,Togo,Tokelau,Tonga,Trinidad And Tobago,Tunisia,Turkey,Turkmenistan,Turks And Caicos Is,Tuvalu,Uganda,Ukraine,United Arab Emirates,United Kingdom,United States,United States Minor Outlying Is,Uruguay,Uzbekistan,Vanuatu,Vatican City State (Holy See),Venezuela,Vietnam,Virgin Islands (British),Virgin Islands (US),Wallis And Futuna Islands,Western Sahara,Yemen,Zambia,Zimbabwe">

	<cfreturn countryStruct>
</cffunction>

<cffunction name="getCountryList" access="public" output="No" returnType="struct" hint="Returns structure of label and display values for countries">
	<cfargument name="displayLongCountryList" type="boolean" required="no" default="True">
	<cfargument name="valueIsFullCountry" type="boolean" required="no" default="True">

	<cfset var countryList = StructNew()>

	<cfinvoke method="countryStruct" returnVariable="countryStruct" />

	<cfswitch expression="#Arguments.displayLongCountryList#:#Arguments.valueIsFullCountry#">
	<cfcase value="True:True"><!--- long list, store full country --->
		<cfset countryList.label = countryStruct.name_long>
		<cfset countryList.value = countryStruct.name_long>
	</cfcase>
	<cfcase value="True:False"><!--- long list, store abbreviation --->
		<cfset countryList.label = countryStruct.name_long>
		<cfset countryList.value = countryStruct.abbr_long>
	</cfcase>
	<cfcase value="False:True"><!--- short list, store full country --->
		<cfset countryList.label = countryStruct.name_short>
		<cfset countryList.value = countryStruct.name_short>
	</cfcase>
	<cfcase value="False:False"><!--- short list, store abbreviation --->
		<cfset countryList.label = countryStruct.name_short>
		<cfset countryList.value = countryStruct.abbr_short>
	</cfcase>
	</cfswitch>

	<cfreturn countryList>
</cffunction>

<cffunction name="displaySelectState" access="public" output="yes" returnType="string" hint="Displays states/provinces in form select">
	<cfargument name="stateList" type="string" required="Yes" hint="labelValueCountry">
	<cfargument name="selectedState" type="string" required="No" default="">
	<cfargument name="defaultText" type="string" required="No" default="-- SELECT --">
	<cfargument name="stateStruct" type="struct" required="No">

	<cfset var selectStateList_label = "">
	<cfset var selectStateList_value = "">

	<cfsilent>
	<cfif Not StructKeyExists(Arguments, "stateStruct")>
		<cfset Arguments.stateStruct = stateStruct()>
	</cfif>

	<cfswitch expression="#Arguments.stateList#">
	<cfcase value="stateStateUS"><!--- Display state / Store state / US only --->
		<cfset selectStateList_label = stateStruct.usa_nameByName>
		<cfset selectStateList_value = stateStruct.usa_nameByName>
	</cfcase>
	<cfcase value="stateStateCanada"><!--- Display state / Store state / Canada only --->
		<cfset selectStateList_label = stateStruct.canada_nameByName>
		<cfset selectStateList_value = stateStruct.canada_nameByName>
	</cfcase>
	<cfcase value="stateStateUSCanada"><!--- Display state / Store state / US,Canada --->
		<cfset selectStateList_label = stateStruct.usa_nameByName & "," & stateStruct.canada_nameByName>
		<cfset selectStateList_value = stateStruct.usa_nameByName & "," & stateStruct.canada_nameByName>
	</cfcase>
	<cfcase value="stateStateCanadaUS"><!--- Display state / Store state / Canada,US --->
		<cfset selectStateList_label = stateStruct.canada_nameByName & "," & stateStruct.usa_nameByName>
		<cfset selectStateList_value = stateStruct.canada_nameByName & "," & stateStruct.usa_nameByName>
	</cfcase>

	<cfcase value="stateStUS"><!--- Display state / Store abbreviation / US only --->
		<cfset selectStateList_label = stateStruct.usa_nameByName>
		<cfset selectStateList_value = stateStruct.usa_abbrByName>
	</cfcase>
	<cfcase value="stateStCanada"><!--- Display state / Store abbreviation / Canada only --->
		<cfset selectStateList_label = stateStruct.canada_nameByName>
		<cfset selectStateList_value = stateStruct.canada_abbrByName>
	</cfcase>
	<cfcase value="stateStUSCanada"><!--- Display state / Store abbreviation / US,Canada --->
		<cfset selectStateList_label = stateStruct.usa_nameByName & "," & stateStruct.canada_nameByName>
		<cfset selectStateList_value = stateStruct.usa_abbrByName & "," & stateStruct.canada_abbrByName>
	</cfcase>
	<cfcase value="stateStCanadaUS"><!--- Display state / Store abbreviation / Canada,US --->
		<cfset selectStateList_label = stateStruct.canada_nameByName & "," & stateStruct.usa_nameByName>
		<cfset selectStateList_value = stateStruct.canada_abbrByName & "," & stateStruct.usa_abbrByName>
	</cfcase>

	<cfcase value="stStateUS"><!--- Display abbreviation / Store state / US only --->
		<cfset selectStateList_label = stateStruct.usa_abbrByAbbr>
		<cfset selectStateList_value = stateStruct.usa_nameByAbbr>
	</cfcase>
	<cfcase value="stStateCanada"><!--- Display abbreviation / Store state / Canada only --->
		<cfset selectStateList_label = stateStruct.canada_abbrByAbbr>
		<cfset selectStateList_value = stateStruct.canada_nameByAbbr>
	</cfcase>
	<cfcase value="stStateUSCanada"><!--- Display abbreviation / Store state / US,Canada --->
		<cfset selectStateList_label = stateStruct.usa_abbrByAbbr & "," & stateStruct.canada_abbrByAbbr>
		<cfset selectStateList_value = stateStruct.usa_nameByAbbr & "," & stateStruct.canada_nameByAbbr>
	</cfcase>
	<cfcase value="stStateCanadaUs"><!--- Display abbreviation / Store state / Canada,US --->
		<cfset selectStateList_label = stateStruct.canada_abbrByAbbr & "," & stateStruct.usa_abbrByAbbr>
		<cfset selectStateList_value = stateStruct.canada_nameByAbbr & "," & stateStruct.usa_nameByAbbr>
	</cfcase>

	<cfcase value="stStUS"><!--- Display abbreviation / Store abbreviation / US only --->
		<cfset selectStateList_label = stateStruct.usa_abbrByAbbr>
		<cfset selectStateList_value = stateStruct.usa_abbrByAbbr>
	</cfcase>
	<cfcase value="stStCanada"><!--- Display abbreviation / Store abbreviation / Canada only --->
		<cfset selectStateList_label = stateStruct.canada_abbrByAbbr>
		<cfset selectStateList_value = stateStruct.canada_abbrByAbbr>
	</cfcase>
	<cfcase value="stStUSCanada"><!--- Display abbreviation / Store abbreviation / US,Canada --->
		<cfset selectStateList_label = stateStruct.usa_abbrByAbbr & "," & stateStruct.canada_abbrByAbbr>
		<cfset selectStateList_value = stateStruct.usa_abbrByAbbr & "," & stateStruct.canada_abbrByAbbr>
	</cfcase>
	<cfcase value="stStCanadaUs"><!--- Display abbreviation / Store abbreviation / Canada,US --->
		<cfset selectStateList_label = stateStruct.canada_abbrByAbbr & "," & stateStruct.usa_abbrByAbbr>
		<cfset selectStateList_value = stateStruct.canada_abbrByAbbr & "," & stateStruct.usa_abbrByAbbr>
	</cfcase>
	</cfswitch>
	</cfsilent>

	<cfoutput>
	<option value="">#HTMLEditFormat(Arguments.defaultText)#</option>
	<cfloop index="count" from="1" to="#ListLen(selectStateList_label)#"><option value="#ListGetAt(selectStateList_value, count)#"<cfif Arguments.selectedState is ListGetAt(selectStateList_value, count)> selected</cfif>>#ListGetAt(selectStateList_label, count)#</option></cfloop>
	</cfoutput>

	<cfreturn "">
</cffunction>

<cffunction name="displaySelectCountry" access="public" output="yes" returnType="boolean" hint="Displays countries in form select">
	<cfargument name="selectedCountry" type="string" required="No" default="">

	<cfoutput>
	<option value=""<cfif Arguments.selectedCountry is ""> selected</cfif>>-- SELECT --</option>
	<option value=" "<cfif Arguments.selectedCountry is " "> selected</cfif>>OTHER</option>
	<option value="Argentina"<cfif Arguments.selectedCountry is "Argentina"> selected</cfif>>Argentina</option>
	<option value="Australia"<cfif Arguments.selectedCountry is "Australia"> selected</cfif>>Australia</option>
	<option value="Austria"<cfif Arguments.selectedCountry is "Austria"> selected</cfif>>Austria</option>
	<option value="Belgium"<cfif Arguments.selectedCountry is "Belgium"> selected</cfif>>Belgium</option>
	<option value="Brazil"<cfif Arguments.selectedCountry is "Brazil"> selected</cfif>>Brazil</option>
	<option value="Canada"<cfif Arguments.selectedCountry is "Canada"> selected</cfif>>Canada</option>
	<option value="Caribbean"<cfif Arguments.selectedCountry is "Caribbean"> selected</cfif>>Caribbean</option>
	<option value="Chile"<cfif Arguments.selectedCountry is "Chile"> selected</cfif>>Chile</option>
	<option value="China"<cfif Arguments.selectedCountry is "China"> selected</cfif>>China</option>
	<option value="Colombia"<cfif Arguments.selectedCountry is "Colombia"> selected</cfif>>Colombia</option>
	<option value="Czech Republic"<cfif Arguments.selectedCountry is "Czech Republic"> selected</cfif>>Czech Republic</option>
	<option value="Denmark"<cfif Arguments.selectedCountry is "Denmark"> selected</cfif>>Denmark</option>
	<option value="Finland"<cfif Arguments.selectedCountry is "Finland"> selected</cfif>>Finland</option>
	<option value="France"<cfif Arguments.selectedCountry is "France"> selected</cfif>>France</option>
	<option value="Germany"<cfif Arguments.selectedCountry is "Germany"> selected</cfif>>Germany</option>
	<option value="Hong Kong"<cfif Arguments.selectedCountry is "Hong Kong"> selected</cfif>>Hong Kong</option>
	<option value="Hungary"<cfif Arguments.selectedCountry is "Hungary"> selected</cfif>>Hungary</option>
	<option value="India"<cfif Arguments.selectedCountry is "India"> selected</cfif>>India</option>
	<option value="Ireland"<cfif Arguments.selectedCountry is "Ireland"> selected</cfif>>Ireland</option>
	<option value="Israel"<cfif Arguments.selectedCountry is "Israel"> selected</cfif>>Israel</option>
	<option value="Italy"<cfif Arguments.selectedCountry is "Italy"> selected</cfif>>Italy</option>
	<option value="Japan"<cfif Arguments.selectedCountry is "Japan"> selected</cfif>>Japan</option>
	<option value="Korea"<cfif Arguments.selectedCountry is "Korea"> selected</cfif>>Korea</option>
	<option value="Luxemburg"<cfif Arguments.selectedCountry is "Luxemburg"> selected</cfif>>Luxemburg</option>
	<option value="Malaysia"<cfif Arguments.selectedCountry is "Malaysia"> selected</cfif>>Malaysia</option>
	<option value="Mexico"<cfif Arguments.selectedCountry is "Mexico"> selected</cfif>>Mexico</option>
	<option value="Netherlands"<cfif Arguments.selectedCountry is "Netherlands"> selected</cfif>>Netherlands</option>
	<option value="New Zealand"<cfif Arguments.selectedCountry is "New Zealand"> selected</cfif>>New Zealand</option>
	<option value="Norway"<cfif Arguments.selectedCountry is "Norway"> selected</cfif>>Norway</option>
	<option value="Peru"<cfif Arguments.selectedCountry is "Peru"> selected</cfif>>Peru</option>
	<option value="Poland"<cfif Arguments.selectedCountry is "Poland"> selected</cfif>>Poland</option>
	<option value="Portugal"<cfif Arguments.selectedCountry is "Portugal"> selected</cfif>>Portugal</option>
	<option value="Russia"<cfif Arguments.selectedCountry is "Russia"> selected</cfif>>Russia</option>
	<option value="Singapore"<cfif Arguments.selectedCountry is "Singapore"> selected</cfif>>Singapore</option>
	<option value="Slovakia"<cfif Arguments.selectedCountry is "Slovakia"> selected</cfif>>Slovakia</option>
	<option value="Slovenija"<cfif Arguments.selectedCountry is "Slovenija"> selected</cfif>>Slovenija</option>
	<option value="South Africa"<cfif Arguments.selectedCountry is "South Africa"> selected</cfif>>South Africa</option>
	<option value="Spain"<cfif Arguments.selectedCountry is "Spain"> selected</cfif>>Spain</option>
	<option value="Sweden"<cfif Arguments.selectedCountry is "Sweden"> selected</cfif>>Sweden</option>
	<option value="Switzerland"<cfif Arguments.selectedCountry is "Switzerland"> selected</cfif>>Switzerland</option>
	<option value="Taiwan"<cfif Arguments.selectedCountry is "Taiwan"> selected</cfif>>Taiwan</option>
	<option value="Thailand"<cfif Arguments.selectedCountry is "Thailand"> selected</cfif>>Thailand</option>
	<option value="Turkey"<cfif Arguments.selectedCountry is "Turkey"> selected</cfif>>Turkey</option>
	<option value="UK"<cfif Arguments.selectedCountry is "UK"> selected</cfif>>United Kingdom</option>
	<option value="USA"<cfif ListFind("US,USA,United States", Arguments.selectedCountry)> selected</cfif>>United States</option>
	<option value="Uruguay"<cfif Arguments.selectedCountry is "Uruguay"> selected</cfif>>Uruguay</option>
	<option value="Venezuela"<cfif Arguments.selectedCountry is "Venezuela"> selected</cfif>>Venezuela</option>
	</cfoutput>

	<cfreturn True>
</cffunction>

<cffunction name="getCountyListByState" access="public" output="no" returnType="string" hint="Returns alphabetical list of counties in a state">
	<cfargument name="state" type="string" required="yes">

	<cfset var countyList = "">

	<cfscript>
	switch (Arguments.state)
	{
	 case "AK": case "Alaska": return "Aleutians East,Aleutians West,Anchorage,Bethel,Bristol Bay,Denali,Dillingham,Fairbanks North Star,Haines,Juneau,Kenai Peninsula,Ketchikan Gateway,Kodiak Island,Lake and Peninsula,Matanuska Susitna,Nome,North Slope,Northwest Arctic,Prince Wales Ketchikan,Sitka,Skagway Hoonah Angoon,Southeast Fairbanks,Valdez Cordova,Wade Hampton,Wrangell Petersburg,Yakutat,Yukon Koyukuk"; break;
	 case "AL": case "Alabama": return "Autauga,Baldwin,Barbour,Bibb,Blount,Bullock,Butler,Calhoun,Chambers,Cherokee,Chilton,Choctaw,Clarke,Clay,Cleburne,Coffee,Colbert,Conecuh,Coosa,Covington,Crenshaw,Cullman,Dale,Dallas,De Kalb,Elmore,Escambia,Etowah,Fayette,Franklin,Geneva,Greene,Hale,Henry,Houston,Jackson,Jefferson,Lamar,Lauderdale,Lawrence,Lee,Limestone,Lowndes,Macon,Madison,Marengo,Marion,Marshall,Mobile,Monroe,Montgomery,Morgan,Perry,Pickens,Pike,Randolph,Russell,Saint Clair,Shelby,Sumter,Talladega,Tallapoosa,Tuscaloosa,Walker,Washington,Wilcox,Winston"; break;
	 case "AR": case "Arkansas": return "Arkansas,Ashley,Baxter,Benton,Boone,Bradley,Calhoun,Carroll,Chicot,Clark,Clay,Cleburne,Cleveland,Columbia,Conway,Craighead,Crawford,Crittenden,Cross,Dallas,Desha,Drew,Faulkner,Franklin,Fulton,Garland,Grant,Greene,Hempstead,Hot Spring,Howard,Independence,Izard,Jackson,Jefferson,Johnson,Lafayette,Lawrence,Lee,Lincoln,Little River,Logan,Lonoke,Madison,Marion,Miller,Mississippi,Monroe,Montgomery,Nevada,Newton,Ouachita,Perry,Phillips,Pike,Poinsett,Polk,Pope,Prairie,Pulaski,Randolph,Saint Francis,Saline,Scott,Searcy,Sebastian,Sevier,Sharp,Stone,Union,Van Buren,Washington,White,Woodruff,Yell"; break;
	 case "AZ": case "Arizona": return "Apache,Cochise,Coconino,Gila,Graham,Greenlee,La Paz,Maricopa,Mohave,Navajo,Pima,Pinal,Santa Cruz,Yavapai,Yuma"; break;
	 case "CA": case "California": return "Alameda,Alpine,Amador,Butte,Calaveras,Colusa,Contra Costa,Del Norte,El Dorado,Fresno,Glenn,Humboldt,Imperial,Inyo,Kern,Kings,Lake,Lassen,Los Angeles,Madera,Marin,Mariposa,Mendocino,Merced,Modoc,Mono,Monterey,Napa,Nevada,Orange,Placer,Plumas,Riverside,Sacramento,San Benito,San Bernardino,San Diego,San Francisco,San Joaquin,San Luis Obispo,San Mateo,Santa Barbara,Santa Clara,Santa Cruz,Shasta,Sierra,Siskiyou,Solano,Sonoma,Stanislaus,Sutter,Tehama,Trinity,Tulare,Tuolumne,Ventura,Yolo,Yuba"; break;
	 case "CO": case "Colorado": return "Adams,Alamosa,Arapahoe,Archuleta,Baca,Bent,Boulder,Broomfield,Chaffee,Cheyenne,Clear Creek,Conejos,Costilla,Crowley,Custer,Delta,Denver,Dolores,Douglas,Eagle,El Paso,Elbert,Fremont,Garfield,Gilpin,Grand,Gunnison,Hinsdale,Huerfano,Jackson,Jefferson,Kiowa,Kit Carson,La Plata,Lake,Larimer,Las Animas,Lincoln,Logan,Mesa,Mineral,Moffat,Montezuma,Montrose,Morgan,Otero,Ouray,Park,Phillips,Pitkin,Prowers,Pueblo,Rio Blanco,Rio Grande,Routt,Saguache,San Juan,San Miguel,Sedgwick,Summit,Teller,Washington,Weld,Yuma"; break;
	 case "CT": case "Connecticut": return "Fairfield,Hartford,Litchfield,Middlesex,New Haven,New London,Tolland,Windham"; break;
	 case "DC": case "District of Columbia": return "District of Columbia"; break;
	 case "DE": case "Delaware": return "Kent,New Castle,Sussex"; break;
	 case "FL": case "Florida": return "Alachua,Baker,Bay,Bradford,Brevard,Broward,Calhoun,Charlotte,Citrus,Clay,Collier,Columbia,De Soto,Dixie,Duval,Escambia,Flagler,Franklin,Gadsden,Gilchrist,Glades,Gulf,Hamilton,Hardee,Hendry,Hernando,Highlands,Hillsborough,Holmes,Indian River,Jackson,Jefferson,Lafayette,Lake,Lee,Leon,Levy,Liberty,Madison,Manatee,Marion,Martin,Miami-Dade,Monroe,Nassau,Okaloosa,Okeechobee,Orange,Osceola,Palm Beach,Pasco,Pinellas,Polk,Putnam,Saint Johns,Saint Lucie,Santa Rosa,Sarasota,Seminole,Sumter,Suwannee,Taylor,Union,Volusia,Wakulla,Walton,Washington"; break;
	 case "GA": case "Georgia": return "Appling,Atkinson,Bacon,Baker,Baldwin,Banks,Barrow,Bartow,Ben Hill,Berrien,Bibb,Bleckley,Brantley,Brooks,Bryan,Bulloch,Burke,Butts,Calhoun,Camden,Candler,Carroll,Catoosa,Charlton,Chatham,Chattahoochee,Chattooga,Cherokee,Clarke,Clay,Clayton,Clinch,Cobb,Coffee,Colquitt,Columbia,Cook,Coweta,Crawford,Crisp,Dade,Dawson,Decatur,Dekalb,Dodge,Dooly,Dougherty,Douglas,Early,Echols,Effingham,Elbert,Emanuel,Evans,Fannin,Fayette,Floyd,Forsyth,Franklin,Fulton,Gilmer,Glascock,Glynn,Gordon,Grady,Greene,Gwinnett,Habersham,Hall,Hancock,Haralson,Harris,Hart,Heard,Henry,Houston,Irwin,Jackson,Jasper,Jeff Davis,Jefferson,Jenkins,Johnson,Jones,Lamar,Lanier,Laurens,Lee,Liberty,Lincoln,Long,Lowndes,Lumpkin,Macon,Madison,Marion,McDuffie,McIntosh,Meriwether,Miller,Mitchell,Monroe,Montgomery,Morgan,Murray,Muscogee,Newton,Oconee,Oglethorpe,Paulding,Peach,Pickens,Pierce,Pike,Polk,Pulaski,Putnam,Quitman,Rabun,Randolph,Richmond,Rockdale,Schley,Screven,Seminole,Spalding,Stephens,Stewart,Sumter,Talbot,Taliaferro,Tattnall,Taylor,Telfair,Terrell,Thomas,Tift,Toombs,Towns,Treutlen,Troup,Turner,Twiggs,Union,Upson,Walker,Walton,Ware,Warren,Washington,Wayne,Webster,Wheeler,White,Whitfield,Wilcox,Wilkes,Wilkinson,Worth"; break;
	 case "HI": case "Hawaii": return "Hawaii,Honolulu,Kalawao,Kauai,Maui"; break;
	 case "IA": case "Iowa": return "Adair,Adams,Allamakee,Appanoose,Audubon,Benton,Black Hawk,Boone,Bremer,Buchanan,Buena Vista,Butler,Calhoun,Carroll,Cass,Cedar,Cerro Gordo,Cherokee,Chickasaw,Clarke,Clay,Clayton,Clinton,Crawford,Dallas,Davis,Decatur,Delaware,Des Moines,Dickinson,Dubuque,Emmet,Fayette,Floyd,Franklin,Fremont,Greene,Grundy,Guthrie,Hamilton,Hancock,Hardin,Harrison,Henry,Howard,Humboldt,Ida,Iowa,Jackson,Jasper,Jefferson,Johnson,Jones,Keokuk,Kossuth,Lee,Linn,Louisa,Lucas,Lyon,Madison,Mahaska,Marion,Marshall,Mills,Mitchell,Monona,Monroe,Montgomery,Muscatine,Obrien,Osceola,Page,Palo Alto,Plymouth,Pocahontas,Polk,Pottawattamie,Poweshiek,Ringgold,Sac,Scott,Shelby,Sioux,Story,Tama,Taylor,Union,Van Buren,Wapello,Warren,Washington,Wayne,Webster,Winnebago,Winneshiek,Woodbury,Worth,Wright"; break;
	 case "ID": case "Idaho": return "Ada,Adams,Bannock,Bear Lake,Benewah,Bingham,Blaine,Boise,Bonner,Bonneville,Boundary,Butte,Camas,Canyon,Caribou,Cassia,Clark,Clearwater,Custer,Elmore,Franklin,Fremont,Gem,Gooding,Idaho,Jefferson,Jerome,Kootenai,Latah,Lemhi,Lewis,Lincoln,Madison,Minidoka,Nez Perce,Oneida,Owyhee,Payette,Power,Shoshone,Teton,Twin Falls,Valley,Washington"; break;
	 case "IL": case "Illinois": return "Adams,Alexander,Bond,Boone,Brown,Bureau,Calhoun,Carroll,Cass,Champaign,Christian,Clark,Clay,Clinton,Coles,Cook,Crawford,Cumberland,De Kalb,Dewitt,Douglas,Du Page,Edgar,Edwards,Effingham,Fayette,Ford,Franklin,Fulton,Gallatin,Greene,Grundy,Hamilton,Hancock,Hardin,Henderson,Henry,Iroquois,Jackson,Jasper,Jefferson,Jersey,Jo Daviess,Johnson,Kane,Kankakee,Kendall,Knox,La Salle,Lake,Lawrence,Lee,Livingston,Logan,Macon,Macoupin,Madison,Marion,Marshall,Mason,Massac,McDonough,McHenry,McLean,Menard,Mercer,Monroe,Montgomery,Morgan,Moultrie,Ogle,Peoria,Perry,Piatt,Pike,Pope,Pulaski,Putnam,Randolph,Richland,Rock Island,Saint Clair,Saline,Sangamon,Schuyler,Scott,Shelby,Stark,Stephenson,Tazewell,Union,Vermilion,Wabash,Warren,Washington,Wayne,White,Whiteside,Will,Williamson,Winnebago,Woodford"; break;
	 case "IN": case "Indiana": return "Adams,Allen,Bartholomew,Benton,Blackford,Boone,Brown,Carroll,Cass,Clark,Clay,Clinton,Crawford,Daviess,De Kalb,Dearborn,Decatur,Delaware,Dubois,Elkhart,Fayette,Floyd,Fountain,Franklin,Fulton,Gibson,Grant,Greene,Hamilton,Hancock,Harrison,Hendricks,Henry,Howard,Huntington,Jackson,Jasper,Jay,Jefferson,Jennings,Johnson,Knox,Kosciusko,La Porte,Lagrange,Lake,Lawrence,Madison,Marion,Marshall,Martin,Miami,Monroe,Montgomery,Morgan,Newton,Noble,Ohio,Orange,Owen,Parke,Perry,Pike,Porter,Posey,Pulaski,Putnam,Randolph,Ripley,Rush,Scott,Shelby,Spencer,St Joseph,Starke,Steuben,Sullivan,Switzerland,Tippecanoe,Tipton,Union,Vanderburgh,Vermillion,Vigo,Wabash,Warren,Warrick,Washington,Wayne,Wells,White,Whitley"; break;
	 case "KS": case "Kansas": return "Allen,Anderson,Atchison,Barber,Barton,Bourbon,Brown,Butler,Chase,Chautauqua,Cherokee,Cheyenne,Clark,Clay,Cloud,Coffey,Comanche,Cowley,Crawford,Decatur,Dickinson,Doniphan,Douglas,Edwards,Elk,Ellis,Ellsworth,Finney,Ford,Franklin,Geary,Gove,Graham,Grant,Gray,Greeley,Greenwood,Hamilton,Harper,Harvey,Haskell,Hodgeman,Jackson,Jefferson,Jewell,Johnson,Kearny,Kingman,Kiowa,Labette,Lane,Leavenworth,Lincoln,Linn,Logan,Lyon,Marion,Marshall,McPherson,Meade,Miami,Mitchell,Montgomery,Morris,Morton,Nemaha,Neosho,Ness,Norton,Osage,Osborne,Ottawa,Pawnee,Phillips,Pottawatomie,Pratt,Rawlins,Reno,Republic,Rice,Riley,Rooks,Rush,Russell,Saline,Scott,Sedgwick,Seward,Shawnee,Sheridan,Sherman,Smith,Stafford,Stanton,Stevens,Sumner,Thomas,Trego,Wabaunsee,Wallace,Washington,Wichita,Wilson,Woodson,Wyandotte"; break;
	 case "KY": case "Kentucky": return "Adair,Allen,Anderson,Ballard,Barren,Bath,Bell,Boone,Bourbon,Boyd,Boyle,Bracken,Breathitt,Breckinridge,Bullitt,Butler,Caldwell,Calloway,Campbell,Carlisle,Carroll,Carter,Casey,Christian,Clark,Clay,Clinton,Crittenden,Cumberland,Daviess,Edmonson,Elliott,Estill,Fayette,Fleming,Floyd,Franklin,Fulton,Gallatin,Garrard,Grant,Graves,Grayson,Green,Greenup,Hancock,Hardin,Harlan,Harrison,Hart,Henderson,Henry,Hickman,Hopkins,Jackson,Jefferson,Jessamine,Johnson,Kenton,Knott,Knox,Larue,Laurel,Lawrence,Lee,Leslie,Letcher,Lewis,Lincoln,Livingston,Logan,Lyon,Madison,Magoffin,Marion,Marshall,Martin,Mason,McCracken,McCreary,McLean,Meade,Menifee,Mercer,Metcalfe,Monroe,Montgomery,Morgan,Muhlenberg,Nelson,Nicholas,Ohio,Oldham,Owen,Owsley,Pendleton,Perry,Pike,Powell,Pulaski,Robertson,Rockcastle,Rowan,Russell,Scott,Shelby,Simpson,Spencer,Taylor,Todd,Trigg,Trimble,Union,Warren,Washington,Wayne,Webster,Whitley,Wolfe,Woodford"; break;
	 case "LA": case "Louisiana": return "Acadia,Allen,Ascension,Assumption,Avoyelles,Beauregard,Bienville,Bossier,Caddo,Calcasieu,Caldwell,Cameron,Catahoula,Claiborne,Concordia,De Soto,East Baton Rouge,East Carroll,East Feliciana,Evangeline,Franklin,Grant,Iberia,Iberville,Jackson,Jefferson,Jefferson Davis,La Salle,Lafayette,Lafourche,Lincoln,Livingston,Madison,Morehouse,Natchitoches,Orleans,Ouachita,Plaquemines,Pointe Coupee,Rapides,Red River,Richland,Sabine,Saint Bernard,Saint Charles,Saint Helena,Saint James,Saint Landry,Saint Martin,Saint Mary,Saint Tammany,St John the Baptist,Tangipahoa,Tensas,Terrebonne,Union,Vermilion,Vernon,Washington,Webster,West Baton Rouge,West Carroll,West Feliciana,Winn"; break;
	 case "MA": case "Massachusetts": return "Barnstable,Berkshire,Bristol,Dukes,Essex,Franklin,Hampden,Hampshire,Middlesex,Nantucket,Norfolk,Plymouth,Suffolk,Worcester"; break;
	 case "MD": case "Maryland": return "Allegany,Anne Arundel,Baltimore,Baltimore City,Calvert,Caroline,Carroll,Cecil,Charles,Dorchester,Frederick,Garrett,Harford,Howard,Kent,Montgomery,Prince Georges,Queen Annes,Saint Marys,Somerset,Talbot,Washington,Wicomico,Worcester"; break;
	 case "ME": case "Maine": return "Androscoggin,Aroostook,Cumberland,Franklin,Hancock,Kennebec,Knox,Lincoln,Oxford,Penobscot,Piscataquis,Sagadahoc,Somerset,Waldo,Washington,York"; break;
	 case "MI": case "Michigan": return "Alcona,Alger,Allegan,Alpena,Antrim,Arenac,Baraga,Barry,Bay,Benzie,Berrien,Branch,Calhoun,Cass,Charlevoix,Cheboygan,Chippewa,Clare,Clinton,Crawford,Delta,Dickinson,Eaton,Emmet,Genesee,Gladwin,Gogebic,Grand Traverse,Gratiot,Hillsdale,Houghton,Huron,Ingham,Ionia,Iosco,Iron,Isabella,Jackson,Kalamazoo,Kalkaska,Kent,Keweenaw,Lake,Lapeer,Leelanau,Lenawee,Livingston,Luce,Mackinac,Macomb,Manistee,Marquette,Mason,Mecosta,Menominee,Midland,Missaukee,Monroe,Montcalm,Montmorency,Muskegon,Newaygo,Oakland,Oceana,Ogemaw,Ontonagon,Osceola,Oscoda,Otsego,Ottawa,Presque Isle,Roscommon,Saginaw,Saint Clair,Saint Joseph,Sanilac,Schoolcraft,Shiawassee,Tuscola,Van Buren,Washtenaw,Wayne,Wexford"; break;
	 case "MN": case "Minnesota": return "Aitkin,Anoka,Becker,Beltrami,Benton,Big Stone,Blue Earth,Brown,Carlton,Carver,Cass,Chippewa,Chisago,Clay,Clearwater,Cook,Cottonwood,Crow Wing,Dakota,Dodge,Douglas,Faribault,Fillmore,Freeborn,Goodhue,Grant,Hennepin,Houston,Hubbard,Isanti,Itasca,Jackson,Kanabec,Kandiyohi,Kittson,Koochiching,Lac Qui Parle,Lake,Lake of the Woods,Le Sueur,Lincoln,Lyon,Mahnomen,Marshall,Martin,McLeod,Meeker,Mille Lacs,Morrison,Mower,Murray,Nicollet,Nobles,Norman,Olmsted,Otter Tail,Pennington,Pine,Pipestone,Polk,Pope,Ramsey,Red Lake,Redwood,Renville,Rice,Rock,Roseau,Saint Louis,Scott,Sherburne,Sibley,Stearns,Steele,Stevens,Swift,Todd,Traverse,Wabasha,Wadena,Waseca,Washington,Watonwan,Wilkin,Winona,Wright,Yellow Medicine"; break;
	 case "MO": case "Missouri": return "Adair,Andrew,Atchison,Audrain,Barry,Barton,Bates,Benton,Bollinger,Boone,Buchanan,Butler,Caldwell,Callaway,Camden,Cape Girardeau,Carroll,Carter,Cass,Cedar,Chariton,Christian,Clark,Clay,Clinton,Cole,Cooper,Crawford,Dade,Dallas,Daviess,Dekalb,Dent,Douglas,Dunklin,Franklin,Gasconade,Gentry,Greene,Grundy,Harrison,Henry,Hickory,Holt,Howard,Howell,Iron,Jackson,Jasper,Jefferson,Johnson,Knox,Laclede,Lafayette,Lawrence,Lewis,Lincoln,Linn,Livingston,Macon,Madison,Maries,Marion,McDonald,Mercer,Miller,Mississippi,Moniteau,Monroe,Montgomery,Morgan,New Madrid,Newton,Nodaway,Oregon,Osage,Ozark,Pemiscot,Perry,Pettis,Phelps,Pike,Platte,Polk,Pulaski,Putnam,Ralls,Randolph,Ray,Reynolds,Ripley,Saint Charles,Saint Clair,Saint Francois,Saint Louis,Saint Louis City,Sainte Genevieve,Saline,Schuyler,Scotland,Scott,Shannon,Shelby,Stoddard,Stone,Sullivan,Taney,Texas,Vernon,Warren,Washington,Wayne,Webster,Worth,Wright"; break;
	 case "MS": case "Mississippi": return "Adams,Alcorn,Amite,Attala,Benton,Bolivar,Calhoun,Carroll,Chickasaw,Choctaw,Claiborne,Clarke,Clay,Coahoma,Copiah,Covington,De Soto,Forrest,Franklin,George,Greene,Grenada,Hancock,Harrison,Hinds,Holmes,Humphreys,Issaquena,Itawamba,Jackson,Jasper,Jefferson,Jefferson Davis,Jones,Kemper,Lafayette,Lamar,Lauderdale,Lawrence,Leake,Lee,Leflore,Lincoln,Lowndes,Madison,Marion,Marshall,Monroe,Montgomery,Neshoba,Newton,Noxubee,Oktibbeha,Panola,Pearl River,Perry,Pike,Pontotoc,Prentiss,Quitman,Rankin,Scott,Sharkey,Simpson,Smith,Stone,Sunflower,Tallahatchie,Tate,Tippah,Tishomingo,Tunica,Union,Walthall,Warren,Washington,Wayne,Webster,Wilkinson,Winston,Yalobusha,Yazoo"; break;
	 case "MT": case "Montana": return "Beaverhead,Big Horn,Blaine,Broadwater,Carbon,Carter,Cascade,Chouteau,Custer,Daniels,Dawson,Deer Lodge,Fallon,Fergus,Flathead,Gallatin,Garfield,Glacier,Golden Valley,Granite,Hill,Jefferson,Judith Basin,Lake,Lewis and Clark,Liberty,Lincoln,Madison,McCone,Meagher,Mineral,Missoula,Musselshell,Park,Petroleum,Phillips,Pondera,Powder River,Powell,Prairie,Ravalli,Richland,Roosevelt,Rosebud,Sanders,Sheridan,Silver Bow,Stillwater,Sweet Grass,Teton,Toole,Treasure,Valley,Wheatland,Wibaux,Yellowstone"; break;
	 case "NC": case "North Carolina": return "Alamance,Alexander,Alleghany,Anson,Ashe,Avery,Beaufort,Bertie,Bladen,Brunswick,Buncombe,Burke,Cabarrus,Caldwell,Camden,Carteret,Caswell,Catawba,Chatham,Cherokee,Chowan,Clay,Cleveland,Columbus,Craven,Cumberland,Currituck,Dare,Davidson,Davie,Duplin,Durham,Edgecombe,Forsyth,Franklin,Gaston,Gates,Graham,Granville,Greene,Guilford,Halifax,Harnett,Haywood,Henderson,Hertford,Hoke,Hyde,Iredell,Jackson,Johnston,Jones,Lee,Lenoir,Lincoln,Macon,Madison,Martin,McDowell,Mecklenburg,Mitchell,Montgomery,Moore,Nash,New Hanover,Northampton,Onslow,Orange,Pamlico,Pasquotank,Pender,Perquimans,Person,Pitt,Polk,Randolph,Richmond,Robeson,Rockingham,Rowan,Rutherford,Sampson,Scotland,Stanly,Stokes,Surry,Swain,Transylvania,Tyrrell,Union,Vance,Wake,Warren,Washington,Watauga,Wayne,Wilkes,Wilson,Yadkin,Yancey"; break;
	 case "ND": case "North Dakota": return "Adams,Barnes,Benson,Billings,Bottineau,Bowman,Burke,Burleigh,Cass,Cavalier,Dickey,Divide,Dunn,Eddy,Emmons,Foster,Golden Valley,Grand Forks,Grant,Griggs,Hettinger,Kidder,Lamoure,Logan,McHenry,McIntosh,McKenzie,McLean,Mercer,Morton,Mountrail,Nelson,Oliver,Pembina,Pierce,Ramsey,Ransom,Renville,Richland,Rolette,Sargent,Sheridan,Sioux,Slope,Stark,Steele,Stutsman,Towner,Traill,Walsh,Ward,Wells,Williams"; break;
	 case "NE": case "Nebraska": return "Adams,Antelope,Arthur,Banner,Blaine,Boone,Box Butte,Boyd,Brown,Buffalo,Burt,Butler,Cass,Cedar,Chase,Cherry,Cheyenne,Clay,Colfax,Cuming,Custer,Dakota,Dawes,Dawson,Deuel,Dixon,Dodge,Douglas,Dundy,Fillmore,Franklin,Frontier,Furnas,Gage,Garden,Garfield,Gosper,Grant,Greeley,Hall,Hamilton,Harlan,Hayes,Hitchcock,Holt,Hooker,Howard,Jefferson,Johnson,Kearney,Keith,Keya Paha,Kimball,Knox,Lancaster,Lincoln,Logan,Loup,Madison,McPherson,Merrick,Morrill,Nance,Nemaha,Nuckolls,Otoe,Pawnee,Perkins,Phelps,Pierce,Platte,Polk,Red Willow,Richardson,Rock,Saline,Sarpy,Saunders,Scotts Bluff,Seward,Sheridan,Sherman,Sioux,Stanton,Thayer,Thomas,Thurston,Valley,Washington,Wayne,Webster,Wheeler,York"; break;
	 case "NH": case "New Hampshire": return "Belknap,Carroll,Cheshire,Coos,Grafton,Hillsborough,Merrimack,Rockingham,Strafford,Sullivan"; break;
	 case "NJ": case "New Jersey": return "Atlantic,Bergen,Burlington,Camden,Cape May,Cumberland,Essex,Gloucester,Hudson,Hunterdon,Mercer,Middlesex,Monmouth,Morris,Ocean,Passaic,Salem,Somerset,Sussex,Union,Warren"; break;
	 case "NM": case "New Mexico": return "Bernalillo,Catron,Chaves,Cibola,Colfax,Curry,De Baca,Dona Ana,Eddy,Grant,Guadalupe,Harding,Hidalgo,Lea,Lincoln,Los Alamos,Luna,McKinley,Mora,Otero,Quay,Rio Arriba,Roosevelt,San Juan,San Miguel,Sandoval,Santa Fe,Sierra,Socorro,Taos,Torrance,Union,Valencia"; break;
	 case "NV": case "Nevada": return "Carson City,Churchill,Clark,Douglas,Elko,Esmeralda,Eureka,Humboldt,Lander,Lincoln,Lyon,Mineral,Nye,Pershing,Storey,Washoe,White Pine"; break;
	 case "NY": case "New York": return "Albany,Allegany,Bronx,Broome,Cattaraugus,Cayuga,Chautauqua,Chemung,Chenango,Clinton,Columbia,Cortland,Delaware,Dutchess,Erie,Essex,Franklin,Fulton,Genesee,Greene,Hamilton,Herkimer,Jefferson,Kings,Lewis,Livingston,Madison,Monroe,Montgomery,Nassau,New York,Niagara,Oneida,Onondaga,Ontario,Orange,Orleans,Oswego,Otsego,Putnam,Queens,Rensselaer,Richmond,Rockland,Saint Lawrence,Saratoga,Schenectady,Schoharie,Schuyler,Seneca,Steuben,Suffolk,Sullivan,Tioga,Tompkins,Ulster,Warren,Washington,Wayne,Westchester,Wyoming,Yates"; break;
	 case "OH": case "Ohio": return "Adams,Allen,Ashland,Ashtabula,Athens,Auglaize,Belmont,Brown,Butler,Carroll,Champaign,Clark,Clermont,Clinton,Columbiana,Coshocton,Crawford,Cuyahoga,Darke,Defiance,Delaware,Erie,Fairfield,Fayette,Franklin,Fulton,Gallia,Geauga,Greene,Guernsey,Hamilton,Hancock,Hardin,Harrison,Henry,Highland,Hocking,Holmes,Huron,Jackson,Jefferson,Knox,Lake,Lawrence,Licking,Logan,Lorain,Lucas,Madison,Mahoning,Marion,Medina,Meigs,Mercer,Miami,Monroe,Montgomery,Morgan,Morrow,Muskingum,Noble,Ottawa,Paulding,Perry,Pickaway,Pike,Portage,Preble,Putnam,Richland,Ross,Sandusky,Scioto,Seneca,Shelby,Stark,Summit,Trumbull,Tuscarawas,Union,Van Wert,Vinton,Warren,Washington,Wayne,Williams,Wood,Wyandot"; break;
	 case "OK": case "Oklahoma": return "Adair,Alfalfa,Atoka,Beaver,Beckham,Blaine,Bryan,Caddo,Canadian,Carter,Cherokee,Choctaw,Cimarron,Cleveland,Coal,Comanche,Cotton,Craig,Creek,Custer,Delaware,Dewey,Ellis,Garfield,Garvin,Grady,Grant,Greer,Harmon,Harper,Haskell,Hughes,Jackson,Jefferson,Johnston,Kay,Kingfisher,Kiowa,Latimer,Le Flore,Lincoln,Logan,Love,Major,Marshall,Mayes,McClain,McCurtain,McIntosh,Murray,Muskogee,Noble,Nowata,Okfuskee,Oklahoma,Okmulgee,Osage,Ottawa,Pawnee,Payne,Pittsburg,Pontotoc,Pottawatomie,Pushmataha,Roger Mills,Rogers,Seminole,Sequoyah,Stephens,Texas,Tillman,Tulsa,Wagoner,Washington,Washita,Woods,Woodward"; break;
	 case "OR": case "Oregon": return "Baker,Benton,Clackamas,Clatsop,Columbia,Coos,Crook,Curry,Deschutes,Douglas,Gilliam,Grant,Harney,Hood River,Jackson,Jefferson,Josephine,Klamath,Lake,Lane,Lincoln,Linn,Malheur,Marion,Morrow,Multnomah,Polk,Sherman,Tillamook,Umatilla,Union,Wallowa,Wasco,Washington,Wheeler,Yamhill"; break;
	 case "PA": case "Pennsylvania": return "Adams,Allegheny,Armstrong,Beaver,Bedford,Berks,Blair,Bradford,Bucks,Butler,Cambria,Cameron,Carbon,Centre,Chester,Clarion,Clearfield,Clinton,Columbia,Crawford,Cumberland,Dauphin,Delaware,Elk,Erie,Fayette,Forest,Franklin,Fulton,Greene,Huntingdon,Indiana,Jefferson,Juniata,Lackawanna,Lancaster,Lawrence,Lebanon,Lehigh,Luzerne,Lycoming,McKean,Mercer,Mifflin,Monroe,Montgomery,Montour,Northampton,Northumberland,Perry,Philadelphia,Pike,Potter,Schuylkill,Snyder,Somerset,Sullivan,Susquehanna,Tioga,Union,Venango,Warren,Washington,Wayne,Westmoreland,Wyoming,York"; break;
	 case "PR": case "Puerto Rico": return "Adjuntas,Aguada,Aguadilla,Aguas Buenas,Aibonito,Anasco,Arecibo,Arroyo,Barceloneta,Barranquitas,Bayamon,Cabo Rojo,Caguas,Camuy,Canovanas,Carolina,Catano,Cayey,Ceiba,Ciales,Cidra,Coamo,Comerio,Corozal,Culebra,Dorado,Fajardo,Florida,Guanica,Guayama,Guayanilla,Guaynabo,Gurabo,Hatillo,Hormigueros,Humacao,Isabela,Jayuya,Juana Diaz,Juncos,Lajas,Lares,Las Marias,Las Piedras,Loiza,Luquillo,Manati,Maricao,Maunabo,Mayaguez,Moca,Morovis,Naguabo,Naranjito,Orocovis,Patillas,Penuelas,Ponce,Quebradillas,Rincon,Rio Grande,Sabana Grande,Salinas,San German,San Juan,San Lorenzo,San Sebastian,Santa Isabel,Toa Alta,Toa Baja,Trujillo Alto,Utuado,Vega Alta,Vega Baja,Vieques,Villalba,Yabucoa,Yauco"; break;
	 case "RI": case "Rhode Island": return "Bristol,Kent,Newport,Providence,Washington"; break;
	 case "SC": case "South Carolina": return "Abbeville,Aiken,Allendale,Anderson,Bamberg,Barnwell,Beaufort,Berkeley,Calhoun,Charleston,Cherokee,Chester,Chesterfield,Clarendon,Colleton,Darlington,Dillon,Dorchester,Edgefield,Fairfield,Florence,Georgetown,Greenville,Greenwood,Hampton,Horry,Jasper,Kershaw,Lancaster,Laurens,Lee,Lexington,Marion,Marlboro,McCormick,Newberry,Oconee,Orangeburg,Pickens,Richland,Saluda,Spartanburg,Sumter,Union,Williamsburg,York"; break;
	 case "SD": case "South Dakota": return "Aurora,Beadle,Bennett,Bon Homme,Brookings,Brown,Brule,Buffalo,Butte,Campbell,Charles Mix,Clark,Clay,Codington,Corson,Custer,Davison,Day,Deuel,Dewey,Douglas,Edmunds,Fall River,Faulk,Grant,Gregory,Haakon,Hamlin,Hand,Hanson,Harding,Hughes,Hutchinson,Hyde,Jackson,Jerauld,Jones,Kingsbury,Lake,Lawrence,Lincoln,Lyman,Marshall,McCook,McPherson,Meade,Mellette,Miner,Minnehaha,Moody,Pennington,Perkins,Potter,Roberts,Sanborn,Shannon,Spink,Stanley,Sully,Todd,Tripp,Turner,Union,Walworth,Yankton,Ziebach"; break;
	 case "TN": case "Tennessee": return "Anderson,Bedford,Benton,Bledsoe,Blount,Bradley,Campbell,Cannon,Carroll,Carter,Cheatham,Chester,Claiborne,Clay,Cocke,Coffee,Crockett,Cumberland,Davidson,Decatur,Dekalb,Dickson,Dyer,Fayette,Fentress,Franklin,Gibson,Giles,Grainger,Greene,Grundy,Hamblen,Hamilton,Hancock,Hardeman,Hardin,Hawkins,Haywood,Henderson,Henry,Hickman,Houston,Humphreys,Jackson,Jefferson,Johnson,Knox,Lake,Lauderdale,Lawrence,Lewis,Lincoln,Loudon,Macon,Madison,Marion,Marshall,Maury,McMinn,McNairy,Meigs,Monroe,Montgomery,Moore,Morgan,Obion,Overton,Perry,Pickett,Polk,Putnam,Rhea,Roane,Robertson,Rutherford,Scott,Sequatchie,Sevier,Shelby,Smith,Stewart,Sullivan,Sumner,Tipton,Trousdale,Unicoi,Union,Van Buren,Warren,Washington,Wayne,Weakley,White,Williamson,Wilson"; break;
	 case "TX": case "Texas": return "Anderson,Andrews,Angelina,Aransas,Archer,Armstrong,Atascosa,Austin,Bailey,Bandera,Bastrop,Baylor,Bee,Bell,Bexar,Blanco,Borden,Bosque,Bowie,Brazoria,Brazos,Brewster,Briscoe,Brooks,Brown,Burleson,Burnet,Caldwell,Calhoun,Callahan,Cameron,Camp,Carson,Cass,Castro,Chambers,Cherokee,Childress,Clay,Cochran,Coke,Coleman,Collin,Collingsworth,Colorado,Comal,Comanche,Concho,Cooke,Coryell,Cottle,Crane,Crockett,Crosby,Culberson,Dallam,Dallas,Dawson,De Witt,Deaf Smith,Delta,Denton,Dickens,Dimmit,Donley,Duval,Eastland,Ector,Edwards,El Paso,Ellis,Erath,Falls,Fannin,Fayette,Fisher,Floyd,Foard,Fort Bend,Franklin,Freestone,Frio,Gaines,Galveston,Garza,Gillespie,Glasscock,Goliad,Gonzales,Gray,Grayson,Gregg,Grimes,Guadalupe,Hale,Hall,Hamilton,Hansford,Hardeman,Hardin,Harris,Harrison,Hartley,Haskell,Hays,Hemphill,Henderson,Hidalgo,Hill,Hockley,Hood,Hopkins,Houston,Howard,Hudspeth,Hunt,Hutchinson,Irion,Jack,Jackson,Jasper,Jeff Davis,Jefferson,Jim Hogg,Jim Wells,Johnson,Jones,Karnes,Kaufman,Kendall,Kenedy,Kent,Kerr,Kimble,King,Kinney,Kleberg,Knox,La Salle,Lamar,Lamb,Lampasas,Lavaca,Lee,Leon,Liberty,Limestone,Lipscomb,Live Oak,Llano,Loving,Lubbock,Lynn,Madison,Marion,Martin,Mason,Matagorda,Maverick,McCulloch,McLennan,McMullen,Medina,Menard,Midland,Milam,Mills,Mitchell,Montague,Montgomery,Moore,Morris,Motley,Nacogdoches,Navarro,Newton,Nolan,Nueces,Ochiltree,Oldham,Orange,Palo Pinto,Panola,Parker,Parmer,Pecos,Polk,Potter,Presidio,Rains,Randall,Reagan,Real,Red River,Reeves,Refugio,Roberts,Robertson,Rockwall,Runnels,Rusk,Sabine,San Augustine,San Jacinto,San Patricio,San Saba,Schleicher,Scurry,Shackelford,Shelby,Sherman,Smith,Somervell,Starr,Stephens,Sterling,Stonewall,Sutton,Swisher,Tarrant,Taylor,Terrell,Terry,Throckmorton,Titus,Tom Green,Travis,Trinity,Tyler,Upshur,Upton,Uvalde,Val Verde,Van Zandt,Victoria,Walker,Waller,Ward,Washington,Webb,Wharton,Wheeler,Wichita,Wilbarger,Willacy,Williamson,Wilson,Winkler,Wise,Wood,Yoakum,Young,Zapata,Zavala"; break;
	 case "UT": case "Utah": return "Beaver,Box Elder,Cache,Carbon,Daggett,Davis,Duchesne,Emery,Garfield,Grand,Iron,Juab,Kane,Millard,Morgan,Piute,Rich,Salt Lake,San Juan,Sanpete,Sevier,Summit,Tooele,Uintah,Utah,Wasatch,Washington,Wayne,Weber"; break;
	 case "VA": case "Virginia": return "Accomack,Albemarle,Alexandria City,Alleghany,Amelia,Amherst,Appomattox,Arlington,Augusta,Bath,Bedford,Bedford City,Bland,Botetourt,Bristol,Brunswick,Buchanan,Buckingham,Buena Vista City,Campbell,Caroline,Carroll,Charles City,Charlotte,Charlottesville City,Chesapeake City,Chesterfield,Clarke,Clifton Forge City,Colonial Heights City,Covington City,Craig,Culpeper,Cumberland,Danville City,Dickenson,Dinwiddie,Emporia City,Essex,Fairfax,Fairfax City,Falls Church City,Fauquier,Floyd,Fluvanna,Franklin,Franklin City,Frederick,Fredericksburg City,Galax City,Giles,Gloucester,Goochland,Grayson,Greene,Greensville,Halifax,Hampton City,Hanover,Harrisonburg City,Henrico,Henry,Highland,Hopewell City,Isle of Wight,James City,King and Queen,King George,King William,Lancaster,Lee,Lexington City,Loudoun,Louisa,Lunenburg,Lynchburg City,Madison,Manassas City,Manassas Park City,Martinsville City,Mathews,Mecklenburg,Middlesex,Montgomery,Nelson,New Kent,Newport News City,Norfolk City,Northampton,Northumberland,Norton City,Nottoway,Orange,Page,Patrick,Petersburg City,Pittsylvania,Poquoson City,Portsmouth City,Powhatan,Prince Edward,Prince George,Prince William,Pulaski,Radford City,Rappahannock,Richmond,Richmond City,Roanoke,Roanoke City,Rockbridge,Rockingham,Russell,Salem,Scott,Shenandoah,Smyth,Southampton,Spotsylvania,Stafford,Staunton City,Suffolk City,Surry,Sussex,Tazewell,Virginia Beach City,Warren,Washington,Waynesboro City,Westmoreland,Williamsburg City,Winchester City,Wise,Wythe,York"; break;
	 case "VT": case "Vermont": return "Addison,Bennington,Caledonia,Chittenden,Essex,Franklin,Grand Isle,Lamoille,Orange,Orleans,Rutland,Washington,Windham,Windsor"; break;
	 case "WA": case "Washington": return "Adams,Asotin,Benton,Chelan,Clallam,Clark,Columbia,Cowlitz,Douglas,Ferry,Franklin,Garfield,Grant,Grays Harbor,Island,Jefferson,King,Kitsap,Kittitas,Klickitat,Lewis,Lincoln,Mason,Okanogan,Pacific,Pend Oreille,Pierce,San Juan,Skagit,Skamania,Snohomish,Spokane,Stevens,Thurston,Wahkiakum,Walla Walla,Whatcom,Whitman,Yakima"; break;
	 case "WI": case "Wisconsin": return "Adams,Ashland,Barron,Bayfield,Brown,Buffalo,Burnett,Calumet,Chippewa,Clark,Columbia,Crawford,Dane,Dodge,Door,Douglas,Dunn,Eau Claire,Florence,Fond du Lac,Forest,Grant,Green,Green Lake,Iowa,Iron,Jackson,Jefferson,Juneau,Kenosha,Kewaunee,La Crosse,Lafayette,Langlade,Lincoln,Manitowoc,Marathon,Marinette,Marquette,Menominee,Milwaukee,Monroe,Oconto,Oneida,Outagamie,Ozaukee,Pepin,Pierce,Polk,Portage,Price,Racine,Richland,Rock,Rusk,Saint Croix,Sauk,Sawyer,Shawano,Sheboygan,Taylor,Trempealeau,Vernon,Vilas,Walworth,Washburn,Washington,Waukesha,Waupaca,Waushara,Winnebago,Wood"; break;
	 case "WV": case "West Virginia": return "Barbour,Berkeley,Boone,Braxton,Brooke,Cabell,Calhoun,Clay,Doddridge,Fayette,Gilmer,Grant,Greenbrier,Hampshire,Hancock,Hardy,Harrison,Jackson,Jefferson,Kanawha,Lewis,Lincoln,Logan,Marion,Marshall,Mason,McDowell,Mercer,Mineral,Mingo,Monongalia,Monroe,Morgan,Nicholas,Ohio,Pendleton,Pleasants,Pocahontas,Preston,Putnam,Raleigh,Randolph,Ritchie,Roane,Summers,Taylor,Tucker,Tyler,Upshur,Wayne,Webster,Wetzel,Wirt,Wood,Wyoming"; break;
	 case "WY": case "Wyoming": return "Albany,Big Horn,Campbell,Carbon,Converse,Crook,Fremont,Goshen,Hot Springs,Johnson,Laramie,Lincoln,Natrona,Niobrara,Park,Platte,Sheridan,Sublette,Sweetwater,Teton,Uinta,Washakie,Weston"; break;
	 case "GU": case "Guam": return "Guam"; break;
	 case "VI": case "Virgin Islands": return "Saint Croix,Saint John,Saint Thomas"; break;
	 default: return ""; break;
	}
	</cfscript>

	<cfreturn countyList>
</cffunction>

<cffunction name="getLocalTime" access="public" returnType="struct" output="no">
	<cfargument name="gmtOffset" type="numeric" required="no" default="-8">
	<cfargument name="timeZone" type="string" required="no" default="Pacific">
	<cfargument name="daylightSavings" type="string" required="no" default="Y">

	<cfset timeStruct = StructNew()>
	<cfset serverStruct = GetTimeZoneInfo()>

	<cfset timeStruct.currentTime = "">
	<cfset timeStruct.timeZoneAbbr = "">

	<cfset timeStruct.currentTime = DateAdd("h", serverStruct.utcHourOffset + Arguments.gmtOffset, Now())>
	<cfif serverStruct.isDSTOn is "YES" and Arguments.daylightSavings is "Y">
		<cfset timeStruct.currentTime = DateAdd("h", 1, timeStruct.currentTime)>
	</cfif>

	<cfswitch expression="#Arguments.timeZone#">
	<cfcase value="Eastern,Central,Mountain,Pacific">
		<cfif serverStruct.isDSTOn is "YES" and Arguments.daylightSavings is "Y">
			<cfset timeStruct.timeZoneAbbr = Left(Arguments.timeZone, 1) & "DT">
		<cfelse>
			<cfset timeStruct.timeZoneAbbr = Left(Arguments.timeZone, 1) & "ST">
		</cfif>
	</cfcase>
	<cfcase value="Atlantic,Alaska,,Hawaii,Samoa">
		<cfset timeStruct.timeZoneAbbr = Arguments.timeZone>
	</cfcase>
	<cfdefaultcase><!--- none, GMT +10, Pacific +7, Pacific +4 --->
		<cfset timeStruct.timeZoneAbbr = "?">
	</cfdefaultcase>
	</cfswitch>

	<cfreturn timeStruct>
</cffunction>

<cffunction name="getStateNameByAbbr" access="public" output="no" returnType="string" hint="Returns full state name from abbreviation">
	<cfargument name="state" type="string" required="yes">

	<cfscript>
	switch (Arguments.state)
	{
	 case "AK": case "Alaska": return "Alaska"; break;
	 case "AL": case "Alabama": return "Alabama"; break;
	 case "AR": case "Arkansas": return "Arkansas"; break;
	 case "AZ": case "Arizona": return "Arizona"; break;
	 case "CA": case "California": return "California"; break;
	 case "CO": case "Colorado": return "Colorado"; break;
	 case "CT": case "Connecticut": return "Connecticut"; break;
	 case "DC": case "District of Columbia": return "District of Columbia"; break;
	 case "DE": case "Delaware": return "Delaware"; break;
	 case "FL": case "Florida": return "Florida"; break;
	 case "GA": case "Georgia": return "Georgia"; break;
	 case "HI": case "Hawaii": return "Hawaii"; break;
	 case "IA": case "Iowa": return "Iowa"; break;
	 case "ID": case "Idaho": return "Idaho"; break;
	 case "IL": case "Illinois": return "Illinois"; break;
	 case "IN": case "Indiana": return "Indiana"; break;
	 case "KS": case "Kansas": return "Kansas"; break;
	 case "KY": case "Kentucky": return "Kentucky"; break;
	 case "LA": case "Louisiana": return "Louisiana"; break;
	 case "MA": case "Massachusetts": return "Massachusetts"; break;
	 case "MD": case "Maryland": return "Maryland"; break;
	 case "ME": case "Maine": return "Maine"; break;
	 case "MI": case "Michigan": return "Michigan"; break;
	 case "MN": case "Minnesota": return "Minnesota"; break;
	 case "MO": case "Missouri": return "Missouri"; break;
	 case "MS": case "Mississippi": return "Mississippi"; break;
	 case "MT": case "Montana": return "Montana"; break;
	 case "NC": case "North Carolina": return "North Carolina"; break;
	 case "ND": case "North Dakota": return "North Dakota"; break;
	 case "NE": case "Nebraska": return "Nebraska"; break;
	 case "NH": case "New Hampshire": return "New Hampshire"; break;
	 case "NJ": case "New Jersey": return "New Jersey"; break;
	 case "NM": case "New Mexico": return "New Mexico"; break;
	 case "NV": case "Nevada": return "Nevada"; break;
	 case "NY": case "New York": return "New York"; break;
	 case "OH": case "Ohio": return "Ohio"; break;
	 case "OK": case "Oklahoma": return "Oklahoma"; break;
	 case "OR": case "Oregon": return "Oregon"; break;
	 case "PA": case "Pennsylvania": return "Pennsylvania"; break;
	 case "PR": case "Puerto Rico": return "Puerto Rico"; break;
	 case "RI": case "Rhode Island": return "Rhode Island"; break;
	 case "SC": case "South Carolina": return "South Carolina"; break;
	 case "SD": case "South Dakota": return "South Dakota"; break;
	 case "TN": case "Tennessee": return "Tennessee"; break;
	 case "TX": case "Texas": return "Texas"; break;
	 case "UT": case "Utah": return "Utah"; break;
	 case "VA": case "Virginia": return "Virginia"; break;
	 case "VT": case "Vermont": return "Vermont"; break;
	 case "WA": case "Washington": return "Washington"; break;
	 case "WI": case "Wisconsin": return "Wisconsin"; break;
	 case "WV": case "West Virginia": return "West Virginia"; break;
	 case "WY": case "Wyoming": return "Wyoming"; break;
	 case "GU": case "Guam": return "Guam"; break;
	 case "VI": case "Virgin Islands": return "Virgin Islands"; break;
	 default: return ""; break;
	}
	</cfscript>
</cffunction>

</cfcomponent>