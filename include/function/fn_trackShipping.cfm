<cffunction Name="fn_TrackShipping" Output="Yes">
	<cfargument Name="shippingCarrier" Type="string" Required="Yes">
	<cfargument Name="trackingNumber" Type="string" Required="Yes">

	<cfoutput>
	<cfswitch expression="#Arguments.shippingCarrier#">
	<cfcase value="Airborne">
		<form method="post" action="http://track.airborne.com/TrackByNbr.asp">
		<input type="hidden" name="hdnPostType" value="init">
		<input type="hidden" name="hdnRefPage" value="0">
		<input type="hidden" name="hdnTrackMode" value="nbr">
		<input type="hidden" name="txtTrackNbrs" value="#HTMLEditFormat(Arguments.trackingNumber)#">
		<a href="javascript:document.theForm.submit();">#Arguments.trackingNumber#</a>
		</form>
		<!--- <a href="http://track.airborne.com/TrackByNbr.asp?hdnPostType=init&hdnRefPage=0&hdnTrackMode=nbr&txtTrackNbrs=#URLEncodedFormat(Arguments.trackingNumber)#" target="track">#Arguments.trackingNumber#</a> --->
	</cfcase>
	<cfcase value="FedEx">
		<a href="http://www.fedex.com/cgi-bin/tracking?tracknumbers=#URLEncodedFormat(Arguments.trackingNumber)#&action=track&language=english&cntry_code=us" target="track">#Arguments.trackingNumber#</a>
	</cfcase>
	<cfcase value="UPS">
		<a href="http://wwwapps.ups.com/etracking/tracking.cgi?tracknum=#URLEncodedFormat(Arguments.trackingNumber)#" target="track">#Arguments.trackingNumber#</a>
	</cfcase>
	<cfcase value="USPS">
		<a href="http://trkcnfrm1.smi.usps.com/netdata-cgi/db2www/cbd_243.d2w/output?strOrigTrackNum=#URLEncodedFormat(Arguments.trackingNumber)#&CAMEFROM=OK" target="track">#Arguments.trackingNumber#</a>
	</cfcase>
	</cfswitch>
	</cfoutput>
</cffunction>

