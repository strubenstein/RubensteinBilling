<cfoutput>
<div style="width: 125">
<cfmenu name="menu" type="horizontal" fontsize="14">
    <!--- The ColdFusion menu item has a pop-up menu. --->
    <cfmenuitem name="recentItems" display="Recent Items">
	<cfif Not StructKeyExists(Session, "recentPagesArray") or ArrayLen(Session.recentPagesArray) is 0>
        <cfmenuitem name="devcenter" href="" display="(No Recent Items)"/>
	<cfelse>
		<cfloop Index="count" From="1" To="#ArrayLen(Session.recentPagesArray)#"><cfmenuitem href="#Session.recentPagesArray[count].url#" display="#HTMLEditFormat(Left(Session.recentPagesArray[count].text, 100))#"/></cfloop>
	</cfif>
    </cfmenuitem>
</cfmenu>
</div>
</cfoutput>
