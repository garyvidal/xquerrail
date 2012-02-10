(:
 : Copyright 2011 - Gary Vidal
 :
 : Licensed     under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :    http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)




xquery version "1.0-ml";

import module namespace parser = "http://www.xquerrail-framework.com/reflection" 
      at "../lib/reflection.xqy";
      
declare namespace dir =   "http://marklogic.com/xdmp/directory";
declare namespace error = "http://marklogic.com/xdmp/error";
declare namespace html =  "http://www.w3.org/1999/xhtml";
declare namespace t    =  "http://marklogic.com/ps/test";

declare namespace test = "http://marklogic.com/litmus/testsuite";
declare namespace internal = "http://marklogic.com/litmus/internal";

declare option xdmp:output "indent=yes";

declare variable $FS-PATH  as xs:string := if(xdmp:platform() eq "winnt") then "\" else "/";
declare variable $TEST-NS := "http://marklogic.com/litmus/testsuite";
declare variable $BEFORE-NS := "http://marklogic.com/litmus/before";
declare variable $AFTER-NS  := "http://marklogic.com/litmus/after";

declare variable $db-id as xs:unsignedLong := xdmp:modules-database();
declare variable $root as xs:string := xdmp:modules-root();

declare function internal:clean($string)
{
   fn:replace($string,"^&quot;|&quot;$|^'|'$","")
};

declare function internal:reduce-expr-tree($tree)
{
   ()
};

declare function internal:parse-testsuite($suite,$module-uri as xs:string)
{
  let $module := 
  	if($db-id eq 0) then 
  	  xdmp:document-get($module-uri) else 
  	  xdmp:eval(fn:concat("fn:doc(",$module-uri,")")/node(),(),<options xmlns="xdmp:eval"><database>{xdmp:modules-database()}</database></options>)
  let $hash := xdmp:hash64($module)
  let $ptree := parser:parse-XQuery($module)
  let $description := $ptree/Module/VersionDecl/text()
  let $version := $ptree/Module/VersionDecl/StringLiteral/internal:clean(.)
  let $moduledecl := $ptree/Module/LibraryModule/ModuleDecl
  let $prefix     := $moduledecl/NCName/NCName/fn:string()
  let $module-uri  := $moduledecl/URILiteral/StringLiteral/fn:replace(.,"^&quot;|&quot;$|^'|'$","")
  let $default-func-ns := $ptree/Prolog/DefaultNamespaceDecl[TOKEN[3] eq "function"]/fn:replace(.,"^&quot;|&quot;$|^'|'$","") 
  let $test-vars := 
      for $v in $ptree//VarDecl
      let $var-decl := $v/QName/FunctionName/QName/fn:string()
      let $name := 
      	if(fn:contains($var-decl,":")) 
      	then fn:tokenize($var-decl,":")[2] 
      	else $var-decl
      where $prefix = fn:tokenize($var-decl,":")[1] or fn:not(fn:contains($var-decl,":"))
      return
         <variable name="{$name}" prefix="{$v/QName/FunctionName/QName/fn:string()}" external="{$v/TOKEN = 'external'}" type="{$v/TypeDeclaration/fn:string()}">{
           ($v/ExprSingle/internal:clean(fn:normalize-space(.)))
         }</variable>
  let $ns-decl := 
  	for $ns in $ptree//NamespaceDecl
  	return 
  	  <ns prefix="{$ns/NCName/NCName}" uri="{$ns/URILiteral/fn:replace(.,"^&quot;|&quot;$|^'|'$","")}"/> 
  let $is-testsuite := $module-uri eq $TEST-NS or $default-func-ns eq $TEST-NS
  let $test-functions := 
  	for $tf in $ptree//FunctionDecl
  	let $is-private := $tf/TOKEN[2] eq "private"
  	let $fn-name := fn:normalize-space($tf/FunctionName/QName/fn:string())
  	let $name := 
  		if(fn:contains($fn-name,":"))
  		then fn:tokenize($fn-name,":")[2]
  		else $fn-name
  	where $prefix = fn:tokenize($fn-name,":")[1] or fn:not(fn:contains($name,":"))
  	return
  	   if($name = ("setup","teardown")) then
  	      if($name eq "setup") then
  	        <setup name="{$name}" function="{$fn-name}"/>
  	      else
  	        <teardown name="{$name}" function="{$fn-name}"/>
  	   else if(not($is-private)) then
  	      <test name="{$name}" function="{$fn-name}"/>
  	   else ()
  return  
  (
     <hash>{$hash}</hash>,
     <version-decl>{$version}</version-decl>,
     <module-uri>{$module-uri}</module-uri>,
     <comment>{$description}</comment>,
     if($test-vars[@name eq "name"]) then <name>{$test-vars[@name eq "name"]/text()}</name> else $suite,
     if($test-vars[@name eq "description"]) then <description>{$test-vars[@name = "description"]/text()}</description> else (),
     <is-testsuite>{$is-testsuite}</is-testsuite>, 
     $ns-decl,
     $test-functions/(self::setup|self::teardown),
     <tests>
     {
        $test-functions/self::test
     }
     </tests>
  )
};
 
let $suite-ignore-list := (".svn", "CVS", "sample-test", "_img", "_js")
let $test-ignore-list := (".svn", "CVS", "setup.xqy", "teardown.xqy", "suite-setup.xqy", "suite-teardown.xqy")

let $suites as xs:string* := 
        if ($db-id = 0) then
             xdmp:filesystem-directory(fn:concat($root, $FS-PATH, "testsuites"))/dir:entry[dir:type = "file" and fn:not(dir:filename = $suite-ignore-list)]/dir:filename
        else
          let $uris := 
            try {
              xdmp:eval('cts:uri-match("/testsuites/*")', (), <options xmlns="xdmp:eval"><database>{$db-id}</database></options>)
            }
            catch($ex) {
              xdmp:eval('xdmp:directory("/testsuites/", "infinity")/xdmp:node-uri(.)', (), <options xmlns="xdmp:eval"><database>{$db-id}</database></options>)
            }
          return
            $uris      
for $suite as xs:string in $suites
let $filepath :=
 if($db-id eq 0) then
    fn:concat($root, if(fn:ends-with($root,$FS-PATH)) then "" else $FS-PATH,"testsuites", $FS-PATH,$suite)   
 else 
    fn:concat("/testsuites/",$suite)

let $module := 
	if($db-id eq 0) then
		fn:concat("file:///",fn:replace($filepath,"\\","/")) 
	else 
		$filepath
let $info := internal:parse-testsuite($suite,$module)  
return 
  <testsuite name="{$suite}" location="{$filepath}">{
     $info
  }</testsuite>