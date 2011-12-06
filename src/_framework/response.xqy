xquery version "1.0-ml";
(:~
 : Response Helper functions for REST Framework.
~:)
module namespace response = "http://www.xquerrail-framework.com/response";

declare variable $RESPONSE-HEADER := "response:header::";
declare variable $RESPONSE-PARAMETER := "response:parameter::";
declare variable $RESPONSE-CONTENT-TYPE := "response:content-type";

declare variable $CONTEXT-PREFIX := "response:context";

declare variable $RESPONSE-DOCTYPE := "response:doctype";
declare variable $RESPONSE-CODE :=  "response:code";
declare variable $RESPONSE-ENCODING := "response:encoding";
declare variable $RESPONSE-VIEW := "response:view";
declare variable $RESPONSE-REDIRECT := "response:redirect";
declare variable $RESPONSE-TEMPLATE := "response:template";
declare variable $RESPONSE-META := "response:meta::";
declare variable $RESPONSE-HTTPMETA := "response:httpmeta::";
declare variable $RESPONSE-STYLESHEET := "response:stylesheet::";
declare variable $RESPONSE-JAVASCRIPT := "response:javascript::";
declare variable $RESPONSE-COOKIE := "response:cookie::";
declare variable $RESPONSE-BODY := "response:body";
declare variable $RESPONSE-FORMAT := "response:format";
declare variable $RESPONSE-CONTROLLER := "response:controller";
declare variable $RESPONSE-ACTION := "response:action";
declare variable $SLOT-PREFIX := "slot::";

declare variable $response := 
(
  let $map := map:map()
  let $_ := map:put($map,"RESPONSE","RESPONSE")
  return
     $map
);
declare function response:initialize($resp)
{
   let $init := response:set-response($resp)
   return
   if($init) then ()
   else fn:error(xs:QName("INITIALIZATION-ERROR"),"Unable to initialize response",$resp)
};
declare function response:set-response($resp)
{
  try {
   ( xdmp:set($response,$resp),fn:true()
   , xdmp:log(("Initialised",$response)))
  } catch($ex)
  {
    xdmp:rethrow()
  }  
};

declare function response:response()
{
    $response
};
declare function response:set-format($format)
{
   map:put($response,$RESPONSE-FORMAT,$format)
};
declare function response:format()
{
   map:get($response,$RESPONSE-FORMAT)
};
declare function response:set-body($body)
{
  map:put($response,$RESPONSE-BODY,$body)
};

declare function response:body()
{
  map:get($response,$RESPONSE-BODY)
};

declare function response:set-response-code(
    $code as xs:integer,
    $message as xs:string
)
{
  map:put($response,$RESPONSE-CODE,($code,$message))
};

declare function response:response-code()
{
   map:get($response,$RESPONSE-CODE)
};

declare function response:set-content-type(
    $name as xs:string
)
{
    map:put($response,$RESPONSE-CONTENT-TYPE,$name)
};
declare function response:content-type()
{
  map:get($response,$RESPONSE-CONTENT-TYPE)
};

declare function response:set-controller($controller as xs:string)
{
   map:put($response,$RESPONSE-CONTROLLER,$controller)
};

declare function response:controller()
{
  map:get($response,$RESPONSE-CONTROLLER)
};

declare function response:set-action($action as xs:string)
{
   map:put($response,$RESPONSE-ACTION,$action)
};

declare function response:action()
{
   map:get($response,$RESPONSE-ACTION)
};

declare function response:set-view($view as xs:string)
{
  map:put($response,$RESPONSE-VIEW,$view)
};

declare function response:view()
{
 map:get($response,$RESPONSE-VIEW)  
};

declare function response:set-template($template as xs:string)
{
  map:put($response,$RESPONSE-TEMPLATE,$template)
};
declare function response:template()
{
  map:get($response,$RESPONSE-TEMPLATE)
};

declare function response:redirect($uri as xs:string)
{
   map:put($response,$RESPONSE-REDIRECT,$uri)
};

declare function response:redirect()
{
   map:get($response,$RESPONSE-REDIRECT)
};

declare function response:add-response-header($key,$value)
{
   map:put($response,fn:concat($RESPONSE-HEADER,$key),$value)
};

declare function response:response-header($key)
{
   map:get($response,fn:concat($RESPONSE-HEADER,$key))
};

declare function response:response-headers() as map:map
{
   let $headers := map:map()
   return
   (
   for $k in map:keys($response)[fn:starts-with(.,$RESPONSE-HEADER)]
   return map:put($headers,fn:replace($k,$RESPONSE-HEADER,""),map:get($response,$k)),
   $headers
   )  
};

declare function response:add-parameter(
  $key as xs:string,
  $value as xs:string
) as empty-sequence()
{
   let $pkey := fn:concat($RESPONSE-PARAMETER,$key)
   return
     map:put($response,$pkey,(map:get($response,$pkey),$value))
}; 

declare function response:set-parameter($key as xs:string,$value as xs:string)
{
   let $pkey := fn:concat($RESPONSE-PARAMETER,$key)
   return
     map:put($response,$pkey,$value)
};

declare function response:delete-parameter($key as xs:string)
{
   let $pkey := fn:concat($RESPONSE-PARAMETER,$key)
   return
   map:delete($response,$pkey)
};

declare function response:delete-parameter($key as xs:string,$value as xs:string)
{
  let $pkey := fn:concat($RESPONSE-PARAMETER,$key)
  return
    map:put($response,$pkey, map:get($response,$pkey)[. != $value])
}; 

declare function response:parameter($key)
{
   map:get($response,fn:concat($RESPONSE-PARAMETER,$key))  
};

declare function response:get-data($key)
{
   map:get($response,$key)
};

declare function response:set-data($key,$value)
{
  map:put($response,$key,$value)
};
declare function response:data($key)
{
  response:get-data($key)
};
declare function response:add-data($key,$value)
{
  map:put($response,$key,(map:get($response,$key),$value))
};
declare function response:slots()
{
  for $slot in map:keys($response)[fn:starts-with(.,$SLOT-PREFIX)]
  return
     fn:replace($slot,$SLOT-PREFIX,"")
};

declare function response:set-slot($key,$value)
{
   map:put($response,fn:concat($SLOT-PREFIX,$key),$value)  
};

declare function response:has-slot($key)
{
  fn:exists(map:get($response,fn:concat($SLOT-PREFIX,$key)))
};

declare function response:slot($key)
{
   map:get($response,fn:concat($SLOT-PREFIX,$key))  
};

declare function response:set-title($value)
{
  map:put($response,"TITLE",$value)  
};
declare function response:title()
{
  map:get($response,"TITLE")
};
(:~META~:)
declare function response:add-meta($key,$value)
{
  map:put($response,fn:concat($RESPONSE-META,$key),$value) 
};

declare function response:add-meta($key as xs:string,$value as xs:string,$append as xs:boolean)
{
 let $mkey := fn:concat($RESPONSE-META,$key)
 return
 if($append)
 then  map:put($response,$mkey,(map:get($response,$mkey),$value))
 else  map:put($response,$mkey,$value)   
};

declare function response:meta($key)
{
   map:get($response,fn:concat($RESPONSE-META,$key))
};

declare function response:meta-keys()
{
   for $n in map:keys($response)[fn:starts-with(.,$RESPONSE-META)]
   return
      fn:replace($n,$RESPONSE-META,"")
};

declare function response:metas()
{
   for $key in response:meta-keys()
   for $m  in response:meta($key)
   return 
    element meta{
      attribute name{$key},
      attribute content {$m}
    }
};
(:~HTTP META~:)
declare function response:add-httpmeta($key,$value)
{
  map:put($response,fn:concat($RESPONSE-HTTPMETA,$key),$value) 
};

declare function response:add-httpmeta($key as xs:string,$value as xs:string,$append as xs:boolean)
{
 let $mkey := fn:concat($RESPONSE-HTTPMETA,$key)
 return
 if($append)
 then  map:put($response,$mkey,(map:get($response,$mkey),$value))
 else  map:put($response,$mkey,$value)   
};

declare function response:httpmeta($key)
{
   map:get($response,fn:concat($RESPONSE-HTTPMETA,$key))
};

declare function response:httpmeta-keys()
{
   for $n in map:keys($response)[fn:starts-with(.,$RESPONSE-HTTPMETA)]
   return
      fn:replace($n,$RESPONSE-HTTPMETA,"")
};

declare function response:httpmetas()
{
   for $key in response:httpmeta-keys()
   for $m  in response:httpmeta($key)
   return 
    element meta{
      attribute http-equiv{$key},
      attribute content {$m}
    }
};
(:Cookies:)
declare function response:add-cookie($name)
{
  ()
};

declare function response:cookies()
{
  ()
};

declare function response:cookie($name)
{
  ()
};
declare function response:remove-cookie($name)
{
  ()
};

(:Javascript Response Functions:)
declare function response:javascripts()
{
  for $k in map:keys($response)[fn:starts-with(.,$RESPONSE-JAVASCRIPT)]
  return
     fn:substring-after($k,$RESPONSE-JAVASCRIPT)
};

declare function response:add-javascript(
$name, 
$options as element(response:options)
) {
   map:put($response,fn:concat($RESPONSE-JAVASCRIPT,$name),
   (<script type="text/javascript" src="{fn:concat("/resources/js",$name,".js")}">//</script>,
     $options
     )
   )  
};

declare function response:add-javascript($name)
{
   map:put($response,fn:concat($RESPONSE-JAVASCRIPT,$name),
   <script type="text/javascript" src="{fn:concat("/resources/js",$name,".js")}">//</script>
   
   )
};

declare function response:remove-javascript($name)
{
  map:delete($response,fn:concat($RESPONSE-JAVASCRIPT,$name))
};

declare function response:clear-javascripts()
{
  for $k in map:keys($response)[fn:starts-with(.,$RESPONSE-JAVASCRIPT)]
  return map:delete($response,$k)
};

(:Stylesheets:)
declare function response:stylesheets()
{
  for $k in map:keys($response)[fn:starts-with(.,$RESPONSE-STYLESHEET)]
  return
     fn:substring-after($k,$RESPONSE-STYLESHEET)
};
declare function response:add-stylesheet($name)
{
   map:put($response,fn:concat($RESPONSE-STYLESHEET,$name),
         <link rel="stylesheet" href="/resources/css/{$name}.css" type="text/css" media="all" />
   )
};
declare function response:add-stylesheet($name as xs:string,$params as xs:string*)
{
   map:put($response,fn:concat($RESPONSE-STYLESHEET,$name),
         <link rel="stylesheet" href="/resources/css/{$name}.css" type="text/css" media="all" />
   )
};
declare function response:remove-stylesheet($name)
{
  map:delete($response,fn:concat($RESPONSE-STYLESHEET,$name))
};

declare function response:clear-stylesheets()
{
  for $k in map:keys($response)[fn:starts-with(.,$RESPONSE-STYLESHEET)]
  return map:delete($response,$k)
};



