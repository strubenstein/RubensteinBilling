<cfoutput>
<p class="TableText">
<cfloop Index="count" From="1" To="#ArrayLen(Variables.productCategoryIDArray)#">
	<cfset Variables.count1 = count>
	<cfloop Index="count2" From="1" To="#ArrayLen(Variables.productCategoryIDArray[Variables.count1])#">
		<a href="index.cfm/method/category.viewCategory/categoryID/#Variables.productCategoryIDArray[Variables.count1][count2]#.cfm" class="bluelink">#Variables.productCategoryTitleArray[Variables.count1][count2]#</a><cfif count2 lt ArrayLen(Variables.productCategoryIDArray[Variables.count1])> / <cfelse><br></cfif>
	</cfloop>
</cfloop>
</p>
</cfoutput>
