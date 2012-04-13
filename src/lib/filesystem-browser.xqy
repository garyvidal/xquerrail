xquery version "1.0-ml";

module namespace browser = "http://condenast.com/dam/2.0/lib/browser";

declare default element namespace "http://www.w3.org/1999/xhtml";

declare namespace dir="http://marklogic.com/xdmp/directory";
declare variable $FS-PATH := if(xdmp:platform() eq "winnt") then "\" else "/";
declare function browser:traverse-directory($path as xs:string, $level as xs:string) {
    let $path := browser:normalize-path($path)
    return
    <div id="fs-level-{$level}" class="filesystem-directory">{
      for $entry in xdmp:filesystem-directory($path)/dir:entry
      let $type := $entry/dir:type/text()
      let $filename := $entry/dir:filename/text()
      let $path := browser:normalize-path($entry/dir:pathname/text())
      let $size := browser:convert-file-size(xs:double($entry/dir:content-length/text()),1)  
      where fn:not(fn:starts-with($filename,".")) (: Do not show hidden files :)
      return
      if($type = "file") then
        <div class="file">
          <img src="/resources/img/file-icon.png" alt="file" /> {$filename} ({$size})
        </div>
      else if ($type = "directory") then
        <div class="directory">
          <img src="/resources/img/folder-icon.png" alt="directory" /> <a href="#" onclick="return loadDir(this,'{$path}',{$level});">{$filename}</a>
        </div>
      else ()
    }</div>
};

declare function browser:convert-file-size($filesize as xs:double,$level as xs:integer) {

    let $size := browser:recursive-div(($filesize,1))
    let $label :=  ("Bytes", "KB", "MB","GB")[$size[2]]
    return
        fn:concat(fn:format-number($size[1],"0.00"), " ", $label) 
}; 

declare function browser:recursive-div($sequence as item()*) {
       if($sequence[1] gt 1024) then
           (browser:recursive-div(($sequence[1] div 1024, $sequence[2] + 1)), $sequence[2])
        else 
            ($sequence[1], $sequence[2])
};

declare function browser:normalize-path($path as xs:string) {
  let $tokenized := 
       fn:string-join(
          for $token in fn:tokenize($path,"\\|/")[. ne ""] return $token
          ,$FS-PATH
       )
       
  let $tokenized := 
    if(fn:starts-with($path, "//") or fn:starts-with($path, "\\")) 
    then fn:concat($FS-PATH, $FS-PATH, $tokenized)
    else if(fn:starts-with($path, "/") or fn:starts-with($path, "\")) 
    then fn:concat($FS-PATH, $tokenized)
    else $tokenized
    
  return 
    $tokenized
};
