<cfif URL.control is "image" and Not ListFind("listImageDirectories,createImageDirectory,deleteImageDirectory", Variables.doAction)>
	<cflocation url="index.cfm?method=image.listImageDirectories&error_image=invalidControl" AddToken="No">
<cfelseif URL.control is not "image" and ListFind("listImageDirectories,createImageDirectory,deleteImageDirectory", Variables.doAction)>
	<cflocation url="index.cfm?method=image.listImageDirectories&error_image=invalidControl" AddToken="No">
</cfif>

