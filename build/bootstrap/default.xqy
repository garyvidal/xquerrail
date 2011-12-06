xquery version "1.0-ml";

(: create forests and databases :)

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare function local:safe-forest-create($config, $forest-name, $data-dir)
{
  if ($forest-name = xdmp:forest-name(xdmp:forests())) then 
    $config  (: forest already exists :)
  else 
    admin:forest-create($config, $forest-name, xdmp:host(), $data-dir)
};

declare function local:safe-database-create($config, $database-name)
{
  if ($database-name = xdmp:database-name(xdmp:databases())) then 
    $config  (: database already exists :)
  else 
    admin:database-create($config, $database-name, xdmp:database("Security"), xdmp:database("Schemas"))
};

let $config := admin:get-configuration()

let $config := local:safe-forest-create($config, "pce", "/local/Marklogic")
let $config := local:safe-forest-create($config, "pce-modules", "/local/Marklogic")
let $config := local:safe-forest-create($config, "pce-triggers", "/local/Marklogic")
    
let $config := local:safe-database-create($config, "pce")
let $config := local:safe-database-create($config, "pce-modules")
let $config := local:safe-database-create($config, "pce-triggers")

return admin:save-configuration($config)
;


(: Attach forests to databases. Must be in a separate transaction from database / forest creation :)

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare function local:safe-database-attach-forest($config, $database-name, $forest-name)
{
  if (fn:not($database-name = xdmp:database-name(xdmp:databases()))) then 
    fn:error(xs:QName("error"), fn:concat("Database ", $database-name, " does not exist"))
  else if (fn:not($forest-name = xdmp:forest-name(xdmp:forests()))) then
    fn:error(xs:QName("error"), fn:concat("Forest ", $forest-name, " does not exist"))
  else if ($forest-name = xdmp:forest-name(xdmp:database-forests(xdmp:database($database-name)))) then
    $config (: forest already attached :)
  else
    admin:database-attach-forest($config, xdmp:database($database-name), xdmp:forest($forest-name))
};

let $config := admin:get-configuration()
let $config := local:safe-database-attach-forest($config, "pce", "pce")
let $config := local:safe-database-attach-forest($config, "pce-modules", "pce-modules")
let $config := local:safe-database-attach-forest($config, "pce-triggers", "pce-triggers")
return admin:save-configuration($config)

;


import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
declare namespace db="http://marklogic.com/xdmp/database";

declare function local:safe-database-set-triggers-database($config, $database-name, $triggers-database-name)
{
  let $triggers-db-id := admin:database-get-triggers-database($config, xdmp:database($database-name))
  return
    if ($triggers-db-id = 0 or xdmp:database-name($triggers-db-id) ne $triggers-database-name) then
      admin:database-set-triggers-database($config, xdmp:database($database-name), xdmp:database($triggers-database-name))
    else
      $config
};

declare function local:safe-database-add-range-element-index($config, $database-name, $rangespec)
{
  try {
    admin:database-add-range-element-index($config, xdmp:database($database-name), $rangespec)
  } 
  catch ($e) {
    $config
  }
};

(: $includes is a sequence of alternating namespaces and element names. Assumes no attributes and weights of 1.0 :)
declare function local:safe-database-add-field($config, $database-name, $field-name, $incl-root, $includes)
{
  let $fieldspec := admin:database-field($field-name, $incl-root)
  let $config := 
    try {admin:database-add-field($config, xdmp:database($database-name), $fieldspec)} 
    catch ($e) {$config}
  
  return local:safe-database-field-includes($config, $database-name, $field-name, $includes)
};

declare function local:safe-database-field-includes($config, $database-name, $field-name, $includes)
{
  if (fn:count($includes) = 0) then
    $config
  else if (fn:count($includes) >= 2) then
    let $fieldspec := admin:database-included-element($includes[1], $includes[2], 1.0, "", "", "")
    let $config :=
      try {admin:database-add-field-included-element($config, xdmp:database($database-name), $field-name, $fieldspec)} 
      catch ($e) {$config}
    return (: recurse :)
      local:safe-database-field-includes($config, $database-name, $field-name, fn:subsequence($includes, 3))
  else
    fn:error(xs:QName("error"), "Odd number of field includes")
};

let $config := admin:get-configuration()

(: Set some database options :)
let $config := admin:database-set-word-searches($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-three-character-searches($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-three-character-word-positions($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-fast-element-character-searches($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-trailing-wildcard-searches($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-trailing-wildcard-word-positions($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-fast-element-trailing-wildcard-searches($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-two-character-searches($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-one-character-searches($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-uri-lexicon($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-collection-lexicon($config, xdmp:database("pce"), fn:true())
let $config := admin:database-set-directory-creation($config, xdmp:database("pce"), "manual")

(: Add word lexicon :)
let $lexspec := admin:database-word-lexicon("http://marklogic.com/collation/codepoint")
let $config := try {admin:database-add-word-lexicon($config, xdmp:database("pce"), $lexspec)} catch ($e) {$config}

(: Set triggers database :)
let $config := local:safe-database-set-triggers-database($config, "pce", "pce-triggers")

(: remove any existing range indexes :)
let $remove-existing :=
  let $dbid := xdmp:database("pce")
  for $x in admin:database-get-range-element-indexes($config, $dbid)
  return
    xdmp:set($config, admin:database-delete-range-element-index($config, $dbid, $x))

(: Add range indexes :)
let $rangespec := admin:database-range-element-index("string", "http://pcenamespace", "discipline", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("string", "http://pcenamespace", "US_states", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("string", "http://purl.org/dc/elements/1.1/", "language", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("string", "http://purl.org/dc/elements/1.1/", "title", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("string", "http://purl.org/dc/elements/1.1/", "identifier", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("int", "http://pcenamespace", "from-grade", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("int", "http://pcenamespace", "to-grade", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("dateTime", "http://purl.org/dc/terms/", "created", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("dateTime", "http://purl.org/dc/terms/", "modified", "http://marklogic.com/collation/", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("string", "http://pcenamespace", "term-value", "http://marklogic.com/collation/en/S1", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $rangespec := admin:database-range-element-index("string", "http://pcenamespace", "topic-value", "http://marklogic.com/collation/en/S1", fn:false())
let $config := local:safe-database-add-range-element-index($config, "pce", $rangespec)

let $remove-existing-fields :=
  let $dbid := xdmp:database("pce")
  for $x as xs:string in admin:database-get-fields($config, $dbid)/db:field-name[. != ""]
  return
    xdmp:set($config, admin:database-delete-field($config, $dbid, $x))

(: Add fields and their includes :)
let $config := local:safe-database-add-field($config, "pce", "title", fn:false(), 
  ("http://purl.org/dc/elements/1.1/", "title"))

let $config := local:safe-database-add-field($config, "pce", "std-title", fn:false(), 
  ("http://pcenamespace", "std_statement",
   "http://pcenamespace", "statement"))

let $config := local:safe-database-add-field($config, "pce", "vocabulary-terms", fn:false(), 
  ("http://pcenamespace", "highlighted",
   "http://pcenamespace", "secondary"))

let $config := local:safe-database-add-field($config, "pce", "objectives", fn:false(), 
  ("http://pcenamespace", "objective"))

let $config := local:safe-database-add-field($config, "pce", "learning-goals", fn:false(), 
  ("http://pcenamespace", "learning-goal"))
  
let $config := local:safe-database-add-field($config, "pce", "standards", fn:false(), 
  ("http://pcenamespace", "std_statement",
   "http://pcenamespace", "std_statement_guiding_material",
   "http://pcenamespace", "std_statement_notes",
   "http://pcenamespace", "partialstd_statement",
   "http://pcenamespace", "std_statement_not_covered",
   "http://pcenamespace", "partialstd_statement_guiding_material",
   "http://pcenamespace", "US_states")) 
     
let $config := local:safe-database-add-field($config, "pce", "state", fn:false(), 
  ("http://pcenamespace", "US_states"))
  
let $config := local:safe-database-add-field($config, "pce", "standard-number", fn:false(), 
  ("http://purl.org/dc/elements/1.1/", "identifier",
   "http://pcenamespace", "standard-id")) 

let $config := local:safe-database-add-field($config, "pce", "standard-text", fn:false(), 
  ("http://pcenamespace", "std_statement",
   "http://pcenamespace", "statement")) 

return admin:save-configuration($config)


(:

This requires more thought. I need to bootstrap this in some way since there may not be any pce stuff created yet.

import module namespace cvt = "http://marklogic.com/cpf/convert" at "/MarkLogic/conversion/convert.xqy";
import module namespace deploy = "http://www.marklogic.com/deploy" at "deploy.xqy";

for $schema in somehow-get-the-schemas()
let $uri := fn:concat("/", cvt:basename(xdmp:node-uri($schema)))
return
  deploy:insert-schema($uri, $schema)
;
:)
(:
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace deploy = "http://www.marklogic.com/deploy" at "deploy.xqy";

let $domain-name := "pce-content-ingest"
let $domain-description := "ingest for all pce content"
let $document-scope := "directory"
let $uri := "/incoming/"
let $depth := "infinity"
let $modules-database := xdmp:database("pce-modules")
let $root := "/"
let $triggers-db := admin:database-get-triggers-database(admin:get-configuration(), xdmp:database())
return
    deploy:insert-domain($domain-name, $domain-description, $document-scope, $uri, $depth, $modules-database, $root, $triggers-db);
    
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace deploy = "http://www.marklogic.com/deploy" at "deploy.xqy";

let $domain-name := "pce-content-ingest"
let $domain-description := "ingest for all pce content"
let $document-scope := "directory"
let $uri := "/incoming/"
let $depth := "infinity"
let $modules-database := xdmp:database("pce-modules")
let $root := "/"
let $triggers-db := admin:database-get-triggers-database(admin:get-configuration(), xdmp:database())
return
    deploy:insert-domain($domain-name, $domain-description, $document-scope, $uri, $depth, $modules-database, $root, $triggers-db)
:)