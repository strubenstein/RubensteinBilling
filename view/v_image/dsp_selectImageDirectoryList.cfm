<cfoutput>
<p class="MainText">
The URL to your main image directory is:<br>
#Variables.companyImageDirectoryURL#/<br>
You may upload images to this directory or create sub-directories.
</p>

<cfif ArrayLen(Variables.imageDirectoryArray) is 0>
	<p class="ErrorMessage">You have no image subdirectories, just the main images directory.</p>
<cfelse>
	<table border="1" cellspacing="0" cellpadding="2">
	<tr class="TableHeader" valign="bottom">
		<th>Directory Name</th>
		<th>Date Created</th>
		<th>## Images</th>
		<cfif ListFind(Variables.permissionActionList, "deleteImageDirectory")>
			<th>Delete</th>
		</cfif>
	</tr>
	<cfloop Index="count" From="1" To="#ArrayLen(Variables.imageDirectoryArray)#">
		<tr class="MainText" valign="top"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>#Variables.imageDirectoryArray[count].directoryName#</td>
		<td><cfif Not IsDate(Variables.imageDirectoryArray[count].directoryDateCreated)>-<cfelse>#DateFormat(Variables.imageDirectoryArray[count].directoryDateCreated, "mm-dd-yy")#</cfif></td>
		<td>#Variables.imageDirectoryArray[count].directoryFileCount#</td>
		<cfif ListFind(Variables.permissionActionList, "deleteImageDirectory")>
			<td class="SmallText">
				<cfif Variables.imageDirectoryArray[count].directoryFileCount is not 0>
					-
				<cfelse>
					<a href="index.cfm?method=image.deleteImageDirectory&directoryName=#URLEncodedFormat(Variables.imageDirectoryArray[count].directoryName)#" class="plainlink">Delete</a>
				</cfif>
			</td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>

