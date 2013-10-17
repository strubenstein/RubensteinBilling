<!---

tag:      cf_imageinfo
	renamed cf_imageInfo.cfm by Steven Rubenstein

version:  1.1 2003-07-09

by:       Michael Teator
Updated:  Tom Halter (email@tomhalter.com)

updates:  http://www.stopstaringatme.com/?action=code&snippet=cf_imageinfo

about:    custom tag to read image file information for GIF, JPEG and
          PNG files.  extremely fast... processes most images in 10
          to 30ms on reasonable systems.  cf_imageinfo also processes
          JPEGs with embedded thumbnail preview images properly.
          cffile may need to be enabled on the server for this tag to
          function properly.

use:      <cf_imageinfo file="path/file.ext">

returns:  structure "imageinfo" with the following keys:
            filename  - filename
            width     - image width in pixels
            height    - image height in pixels
            type      - image type (GIF8xx, JPEG, PNG)
            size      - image file size in bytes
            
          if there is an error, CF_IMAGEINFO will throw one of the 
          following error types:
            ImageInfo.MissingAttribute
            ImageInfo.UnrecognizedFile
            ImageInfo.BadHeader
            
          read the CFTRY/CFCATCH documentation for information on
          recognizing and dealing with these exceptions.
          
          on error, the imageinfo structure may or may not exist.

example:  <cf_imageinfo file="images/logo.gif">
          <cfoutput>
            #imageinfo.filename# is a
            #imageinfo.size# byte
            #imageinfo.width# x #imageinfo.height#
            #imageinfo.type# file.
          </cfoutput>

--->

<cfsilent>
<!--- check for attribute existance --->
<cfif not isdefined("attributes.file")>
  <cfthrow type="ImageInfo.MissingAttribute"
           message="Attribute set validation error in tag CF_IMAGEINFO"
           detail="The tag has an invalid attribute combination: the following required attributes have not been provided: (FILE).">
</cfif>

<!--- read in the image file --->
<cftry>
	<cffile action="read" file="#attributes.file#" variable="image">
	<cfcatch type="any">
		<cfset image="">
	</cfcatch>
</cftry>

<cfscript>
  size = len(image);
  if (size ge 4) {
    imagesig = left(image, 4);
    // ---- JPEG/EXIF ----
    if (imagesig is "#chr(255)##chr(216)##chr(255)##chr(224)#" or imagesig is "#chr(255)##chr(216)##chr(255)##chr(225)#") {
      type = "JPEG";
      filepos = 1;
      while (filepos le (size - 1)) {
        if (asc(mid(image, filepos, 1)) is 255) {
          marker = asc(mid(image, filepos + 1, 1));
          filepos = filepos + 2;
          // switch on marker type
          switch (marker) {
            // start of frame
            case "192": case "193": case "194": case "195": case "198": case "199":
            case "201": case "202": case "203": case "205": case "206": case "207": {
              height = (asc(mid(image, filepos + 3, 1)) * 256) + asc(mid(image, filepos + 4, 1));
              width = (asc(mid(image, filepos + 5, 1)) *256) + asc(mid(image, filepos + 6, 1));
              filepos = filepos + (asc(mid(image, filepos, 1)) * 256) + asc(mid(image, filepos + 1, 1));
              break;
            }
            // start of image
            case "216": {
              break;
            }
            // end of image
            case "217": {
              filepos = size;
              break;
            }
            // start of scan
            case "218": {
              filepos = size;
              break;
            }
            // skip over any others
            default: {
              filepos = filepos + (asc(mid(image, filepos, 1)) * 256) + asc(mid(image, filepos + 1, 1));
            }
          }
        } else {
          error_message = "BadHeader,JPEG Header Possibly Corrupt,There has been a problem with reading the JPEG header.";
          filepos = size;
        }
      }
      // check to make sure image information block was located
      if (not isdefined("height")) {
        error_message = "BadHeader,JPEG SOFn Not Found,Could not find image information header marker.";
      }
    // ---- PNG ----
    } else if (imagesig is "#chr(137)#PNG") {
      type = "PNG";
      if (size gt 33) {
        // only extracting 3 of the 4 size bytes... who's gonna have a web image
        // larger than 16777216 pixels :)
        width = (asc(mid(image, 18, 1)) * 65536) + (asc(mid(image, 19, 1)) * 256) + asc(mid(image, 20, 1));
        height = (asc(mid(image, 22, 1)) * 65536) + (asc(mid(image, 23, 1)) * 256) + asc(mid(image, 24, 1));
      } else {
        error_message = "Badheader,PNG Header Possibly Corrupt,There has been a problem with reading the PNG header.";
      }
    // ---- GIF ----
    } else if (imagesig is "GIF8") {
      if (size gt 10) {
        type = mid(image, 1, 6);
        width = asc(mid(image, 7, 1)) + (asc(mid(image, 8, 1)) * 256);
        height = asc(mid(image, 9, 1)) + (asc(mid(image, 10, 1)) * 256);
      } else {
        error_message = "BadHeader,GIF Header Possibly Corrupt,There has been a problem with reading the GIF header.";
      }
    // unsupported file type
    } else {
      error_message = "UnrecognizedFile,Format Not Recognized,Could not determine the format of the file #attributes.file#";
    }
  // file was too small
  } else {
    error_message = "UnrecognizedFile,Format Not Recognized,Could not determine the format of the file or file was not found: #attributes.file#";
  }
  // if no errors, set up imageinfo structure in the caller
  if (not isdefined("error_message")) {
    caller.imageinfo = structnew();
    structinsert(caller.imageinfo, "filename", attributes.file);
    structinsert(caller.imageinfo, "type", type);
    structinsert(caller.imageinfo, "height", height);
    structinsert(caller.imageinfo, "width", width);
    structinsert(caller.imageinfo, "size", size);
  }
</cfscript>

<!--- throw a cold fusion error if we had problems --->
<cfif isdefined("error_message")>
  <cfthrow type="ImageInfo.#listgetat(error_message, 1)#" message="CF_IMAGEINFO: #listgetat(error_message, 2)#" detail="#listgetat(error_message, 3)#">
</cfif>
</cfsilent>
