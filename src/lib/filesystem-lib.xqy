xquery version "1.0-ml";

module namespace fs = "http://condenast.com/dam/2.0/lib/filesystem";

declare namespace dir = "http://marklogic.com/xdmp/directory";

declare variable $files := map:map();
declare variable $inserts := map:map();
declare variable $list-of-namespaces := (
    "pam"   , "http://prismstandard.org/namespaces/pam/1.0/",
    "dc"    , "http://purl.org/dc/elements/1.1/",
    "prism" , "http://prismstandard.org/namespaces/basic/1.2/",
    "pur"   , "http://prismstandard.org/namespaces/pur/2.1/",
    "pim"   , "http://prismstandard.org/namespaces/pim",
    "xmp"   , "http://ns.adobe.com/xap/1.0/",
    "xap"   , "http://ns.adobe.com/xap/1.0/",
    "xapMM" , "http://ns.adobe.com/xap/1.0/mm/",
    "photoshop" , "http://ns.adobe.com/photoshop/1.0/",
    "xmtpg" , "http://ns.adobe.com/xap/1.0/t/pg/",
    "xmpdm" , "http://ns.adobe.com/xmp/1.0/DynamicMedia/",
    "pdf"   , "http://ns.adobe.com/pdf/1.3/",
    "crs"   , "http://ns.adobe.com/camera-raw-settings/1.0/",
    "tiff"  , "http://ns.adobe.com/tiff/1.0/",
    "exif"  , "http://ns.adobe.com/exif/1.0/",
    "aux"   , "http://ns.adobe.com/exif/1.0/aux/"
);
declare function fs:extract-metadata($binary) {
  let $list-of-xmp-names := ("xmpMM:InstanceID","xmpMM:OriginalDocumentID")
  let $doc := xdmp:document-filter($binary)
        
  return
  xdmp:with-namespaces($list-of-namespaces,
  for $m in $doc//*:meta
  let $localname := 
      if(fn:matches($m/@content,"(\i\c*):\s(.*)")) 
      then fn:replace($m/@content,"(\i\c*):\s(.*)","$1") 
      else fn:data($m/@name)
  let $qname := 
     if($list-of-namespaces[. eq $m/@name]) 
     then fn:concat($m/@name,":",$localname)
     else $localname
  return
     element {$qname} {
       if(fn:matches($m/@content,"(\i\c*):\s(.*)")) 
       then fn:normalize-space(fn:replace($m/@content,"(\i\c*):\s(.*)","$2")) 
       else fn:data($m/@content)
     })
};

declare function fs:normalize-path(
   $path as xs:string
) as xs:string {    
    fs:normalize-path($path, 2)
};


declare function fs:normalize-path($path as xs:string, $offset as xs:integer) {
  let $tokenized := 
       fn:string-join(
          for $token in fn:tokenize($path,"\\|/")[. ne ""][$offset to fn:last()] return $token
          ,"/"
       )
  return 
    if(fn:starts-with($path, "//")) then
        if(fn:starts-with($tokenized,"/")) 
        then fn:concat("/",$tokenized)
        else fn:concat("//",$tokenized)
    else if(fn:starts-with($tokenized,"/")) then
        $tokenized 
    else 
        fn:concat("/",$tokenized)
};

declare function fs:filesystem-walker($path)
{
  for $entry in $path/dir:entry
  return
    if($entry/dir:type eq "directory") 
    then (
      fs:filesystem-walker(xdmp:filesystem-directory(fn:concat($entry/dir:pathname)))
    )
    else if($entry/dir:type eq "file")
    then map:put($files, $entry/dir:pathname,$entry)
    else ()
};

declare private function fs:build-manifest($path as xs:string,$entries as map:map) {
  let $save-path := fn:concat(fs:normalize-path($path),".xml")
  let $assets :=   
      for $dkey in map:keys($entries)
      let $entry     := map:get($entries,$dkey)
      let $path      := $entry/dir:pathname
      let $filename  := $entry/dir:filename  
      let $binary    := () (: xdmp:external-binary($entry/dir:pathname,1,$entry/dir:content-length/xs:integer(.)) :)
      let $sha1      := () (: xdmp:sha1($binary) :)
      let $format    := xdmp:uri-format($filename)
      let $mimetype  := xdmp:uri-content-type($filename)
      let $fileFilter  := 
          if($format eq "binary")       
          then () (: fs:extract-metadata($binary)  :)
          else ()
      return 
          <asset>
              <createDate>{fn:current-dateTime()}</createDate>
              <fileModified>{fn:data($entry/dir:last-modified)}</fileModified>
              <assetId>{xdmp:md5(fn:string($path))}</assetId>
              <document-hash type="sha1">{$sha1}</document-hash>
              <container type="storage">
                  <fileName>{fn:data($filename)}</fileName>
                  <fileType>{$format}</fileType>
                  <fileSize>{fn:data($entry/dir:content-length)}</fileSize>
                  <mimeType>{$mimetype}</mimeType>
                  <systemPath>{fs:normalize-path(fn:data($entry/dir:pathname),1)}</systemPath>
                  <relativePath>{fs:normalize-path($entry/dir:pathname)}</relativePath>
                  <thumbnail></thumbnail>
                  <fileFilter>{$fileFilter}</fileFilter>
              </container>
          </asset>
          
   return 
     <file-manifest>
         <manifestId>{xdmp:random()}</manifestId>
         <requestId>{xdmp:random()}</requestId>
         <requested>{fn:current-dateTime()}</requested>
         <processed>{fn:current-dateTime() + xdmp:elapsed-time()}</processed>
         <entries>{map:count($entries)}</entries>
         <elapsedTime>{xdmp:elapsed-time()}</elapsedTime>
         <physicalPath>{$path}</physicalPath>
         <relativePath>{$save-path}</relativePath>
         <assets>{$assets}</assets>
     </file-manifest>
};

declare function fs:filesystem-manifest($path as xs:string){

    if($path) then
        let $walked := (fs:filesystem-walker(xdmp:filesystem-directory($path)),$files)
        return fs:build-manifest($path,$walked)
    else ()    
};

declare function fs:filesystem-file-manifest($path as xs:string) {
    let $tokens := fn:tokenize($path,"/")
    let $p := fn:string-join($tokens[1 to fn:last() - 1],"/")
    let $walked := (fs:filesystem-walker(xdmp:filesystem-directory($p)),$files)
    let $map := map:map()
    let $_ := map:put($map,$path, map:get($walked,$path))
    return fs:build-manifest($path,$map)
};