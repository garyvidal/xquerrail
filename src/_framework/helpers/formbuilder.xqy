xquery version "1.0-ml";
module namespace form = "http://www.xquerrail-framework.com/formbuilder";

declare default element namespace "http://www.w3.org/1999/xhtml";
(:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   Copyright 2011 - Gary Vidal

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::)

import module namespace lists = "http://www.xquerrail-framework.com/formbuilder/lists"
at "/_framework/helpers/formbuilder-lists.xqy";

import module namespace domain = "http://www.xquerrail-framework.com/domain" 
at "/_framework/domain.xqy";

import module namespace json  = "http://marklogic.com/json" 
at "/lib/json.xqy";

declare option xdmp:output "indent=yes";
declare option xdmp:output "method=xml";
declare option xdmp:ouput "omit-xml-declaration=yes";

declare variable $_form-controls := map:map();
declare variable $_form-options  := map:map();
declare variable $_form-bindings := map:map();
declare variable $_control-options := map:map();
declare variable $_request := ();

declare variable $FORM-INDEX-COUNT := "_count";
declare variable $FORM-INDEX := "_order";
declare variable $FORM-VALIDATIONS := "_validations";
declare variable $CONTROL-OPTIONS := 
 (
   control-options("text",(
      control-option("max-length","integer"),
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("trim","boolean","true"),
      control-option("bubble-error","false")
   )),
   control-options("textarea",(
      control-option("max-length","integer"),
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("trim","boolean","true"),
      control-option("bubble-error","false")
   )),
   control-options("email",(
      control-option("max-length","integer"),
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("trim","boolean","true"),
      control-option("bubble-error","false")
   )),
   control-options("password",(
      control-option("max-length","integer"),
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("trim","boolean","true"),
      control-option("bubble-error","false")
      (:Custom Option:)
   )),      
   control-options("email",(
      control-option("max-length","integer"),
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("trim","boolean","true"),
      control-option("bubble-error","false")
   )),
   control-options("search",(
      control-option("max-length","integer"),
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("trim","boolean","true"),
      control-option("bubble-error","false")
   )),   
   control-options("url",(
      control-option("max-length","integer"),
      control-option("required","boolean","true"),
      control-option("label","string","$name"),
      control-option("trim","boolean","true"),
      control-option("bubble-error","boolean","false"),
      control-option("default_protocol","choice","http://",("http://","https://","mailto:","ftp://"))
   )),
   (:Numeric field options:)
   control-options("integer",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Use xquery rounding modes:)
      control-option("rounding-mode","choice",(),("")),
      control-option("grouping","integer","")     
   )),
   control-options("money",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Custom:)
      control-option("currency","choice",(),("")),
      control-option("divisor","integer",""),
      control-option("precision","integer",""),
      control-option("grouping","integer","")
   )),
   control-options("integer",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Custom:)
      control-option("type","sequence","integer",("decimal","integer")),
      control-option("precision","integer",0)
   )),
   (:Selection Options:)
   control-options("choice",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Custom:)
      control-option("choices","sequence",(),()),
      control-option("choice-list","list",(),()),
      control-option("multiple","boolean","false"),
      control-option("expanded","boolean","false"),
      control-option("preferred-choices","sequence"),
      control-option("empty-value","string","Choose an option")
   )),  
   control-options("country",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Custom:)
      control-option("choices","sequence",(),()),
      control-option("choice-list","list",(),$lists:countries),
      control-option("multiple","boolean","false"),
      control-option("expanded","boolean","false"),
      control-option("preferred-choices","sequence"),
      control-option("empty-value","string","Choose an option")
   )),
   control-options("language",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Custom:)
      control-option("choices","sequence",(),()),
      control-option("choice-list","list",(),$lists:languages),
      control-option("multiple","boolean","false"),
      control-option("expanded","boolean","false"),
      control-option("preferred-choices","sequence"),
      control-option("empty-value","string","Choose an option")
   )),   
      control-options("locale",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Custom:)
      control-option("choices","sequence",(),()),
      control-option("choice-list","list",(),$lists:locales),
      control-option("multiple","boolean","false"),
      control-option("expanded","boolean","false"),
      control-option("preferred-choices","sequence"),
      control-option("empty-value","string","Choose an option")
   )),
   control-options("timezone",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Custom:)
      control-option("choices","sequence",(),()),
      control-option("choice-list","list",(),$lists:timezones),
      control-option("multiple","boolean","false"),
      control-option("expanded","boolean","false"),
      control-option("preferred-choices","sequence"),
      control-option("empty-value","string","Choose an option")
   )),
   control-options("language",(
      control-option("required", "boolean","true"),
      control-option("label","string","$name"),
      control-option("bubble-error","boolean","false"),
      control-option("readonly","boolean","false"),
      (:Custom:)
      control-option("choices","sequence",(),()),
      control-option("choice-list","list",(),$lists:languages),
      control-option("multiple","boolean","false"),
      control-option("expanded","boolean","false"),
      control-option("preferred-choices","sequence"),
      control-option("empty-value","string","Choose an option")
   ))
   (:Date Time Options:)
);


declare function get-control-options($name)
{
  map:get($_control-options,$name)
};

declare function control-options($name,$options)
{
 let $control :=
  <control-options name="{$name}">{$options}</control-options>
  return
     (map:put($_control-options,$name,$control),$control)
};

declare function control-option($name,$type)
{
  control-option($name,$type,(),())
}; 

declare function control-option($name,$type,$default)
{
  control-option($name,$type,$default,())
};

declare function control-option($name,$type,$default,$values)
{
  <option name="{$name}" type="{$type}" default="{$default}">
  <values>{for $v in $values 
   return 
    if($v instance of xs:anyAtomicType) then <option value="{$v}">{$v}</option>
    else $v
  }</values> 
  </option>
};

declare private function form:render-script($controls)
{
  ()
};
declare private function form:_pad-integer($int,$length){
 fn:concat(
  fn:string-join(
    for $i in (1 to $length - fn:string-length(fn:string($int)))
    return "0"
  ,""),
  fn:string($int)
)};
 
declare private function form:next-key()
{
  if(fn:not(map:get($_form-controls,$FORM-INDEX-COUNT)))
  then (
      map:put($_form-controls,$FORM-INDEX-COUNT,1),
      form:_pad-integer(1,10)
  ) else (
    map:put($_form-controls,$FORM-INDEX-COUNT,map:get($_form-controls,$FORM-INDEX-COUNT) + 1),
    form:_pad-integer(map:get($_form-controls,$FORM-INDEX-COUNT),10)
  )
};

declare private function form:add($type,$name,$value)
{
    let $next-key := fn:concat(fn:string-join((form:next-key(),$type,$name),":"))
    return
    map:put($_form-controls,$next-key,$value)
};

declare function form:bind($response)
{
  xdmp:set($form:response,$response)
};

(:!!:)
declare function form:flush()
{
  let $_ := $CONTROL-OPTIONS
  let $form-controls := 
      for $k in map:keys($_form-controls)[. ne "_count"]
      let $tokens := fn:tokenize($k,":")
      let $binding-type  := fn:subsequence($tokens,3,1)
      let $binding-name  := fn:subsequence($tokens,2,1)
      let $binding-value := map:get($_form-bindings,$k)
      let $binding-options  := map:get($_form-controls,$k)
      order by $k
      return
        form:render-control($binding-name,$binding-type,$binding-value,$binding-options,())
  let $form-script := form:render-script($form-controls)
  return
    <form name="{form:name()}" action="{form:action()}" >
    {$form-controls}
    <script type="javascript">
    $(document).ready(function(){{
      {$form-script}
    }});
    </script>
    </form>        
};

(:~
 : Form Options can be in the following form:
 : "option=value" 
 : or chained together in a single value:
 : "option1=value;option2=value2;option3=value3"
 : the parsing will figure out what is what
 : It is not necessary to quote values as they will be quoted
 : automically unless you want in or around the content
~:)
declare function form:parse-options($options)
{
 let $opts-xml := 
      for $params in $options
      for $opts in fn:tokenize($params,";")
      let $opt := fn:tokenize($opts,"=")
      return
         element {$opt[1]} {$opt[2]}
  return
    <options>
    {$opts-xml}
    </options>
};


declare function form:render-before($name,$type,$value,$options)
{
  if($options/label) 
  then <label for="{$name}" class="desc">{(fn:data($options/label),fn:data($name))[1]}</label> 
  else ()
   
};
declare function form:render-after($name,$type,$value,$options)
{
  <br/>
};

declare function form:render-attributes($name,$type,$value,$options)
{(
  if($options/required) then attribute required{fn:true()} else (),
  if($options/maxlength) then attribute maxlength {fn:data($options/maxlength)} else (),
  if($options/readonly) then attribute readonly {fn:data($options/readonly)} else (),
  if($options/*:editable/text() = 'false') then attribute readonly { "readonly" } else (),
  if($options/*:class) then attribute class {} else ()
)};

declare function form:render-values($name,$type,$value,$options)
{
 let $control-options := get-control-options($type)/option
 return
 ( 
 (:First bind any attributes values or it will blow up:)
  if($control-options[@name eq "choice-list"]) 
  then 
    for $choice at $pos in ($value,$control-options[@name eq "choice-list"]/*)
    return 
    if($choice/@value eq $value) 
    then element {fn:node-name($choice)} {$choice/@*,attribute checked{"checked"},$choice/node()}
    else $value
  else attribute value {$value},
  $control-options[@name eq "choice-list"]/values/*
 )
};
declare function form:render-custom(
   $name as xs:string,
   $type as xs:string, 
   $value as xs:string*,
   $options
){
  ()   
};

(:~
 : Function binds controls to their respective request data 
 : from the request map;
~:)
declare function form:render-text($name,$type,$value,$options)
{
  (
       form:render-before($name,$type,$value,$options),
       <div>       
         <input name="{$name}" type="{($type,'text')[1]}" class="field text large">
       
       {form:render-attributes($name,$type,$value,$options)}
       {form:render-values($name,$type,$value,$options)}
       </input>
       </div>,
       form:render-after($name,$type,$value,$options)
  )
};

(:~
 : Renders a money field
~:)
declare function form:render-money($name,$type,$value,$options)
{(
           form:render-before($name,$type,$value,$options), 
           <input name="{$name}" type="text">
           {form:render-attributes($name,$type,$value,$options)}
           {form:render-values($name,$type,$value,$options)}
           </input>,
           form:render-after($name,$type,$value,$options)
)};

declare function form:render-number($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="text">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-password($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="password">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-email($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="text">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-search($name,$type,$value,$options)
{(
       form:render-before($name,$type,$value,$options), 
       <input name="{$name}" type="text">
       {form:render-attributes($name,$type,$value,$options)}
       {form:render-values($name,$type,$value,$options)}
       </input>,
       form:render-after($name,$type,$value,$options)
)};

declare function form:render-url($name,$type,$value,$options)
{
  (
       form:render-before($name,$type,$value,$options), 
       <input name="{$name}" type="text">
       {form:render-attributes($name,$type,$value,$options)}
       {form:render-values($name,$type,$value,$options)}
       </input>,
       form:render-after($name,$type,$value,$options)
  )
};

declare function form:render-choice($name,$type,$value,$options)
{(
       form:render-before($name,$type,$value,$options), 
       <select name="{$name}" class="field select large">
       {form:render-attributes($name,$type,$value,$options)}
       {form:render-values($name,$type,$value,$options)}
       </select>,
       form:render-after($name,$type,$value,$options)
)};

(:~
 : Render Entity 
~:)
declare function form:render-entity($name,$type,$value,$options)
{(
       form:render-before($name,$type,$value,$options), 
       <select name="{$name}">
       {form:render-attributes($name,$type,$value,$options)}
       {form:render-values($name,$type,$value,$options)}
       </select>,
       form:render-after($name,$type,$value,$options)
)};

(:~
 : Render Countries
~:)
declare function form:render-country($name,$type,$value,$options)
{(
       form:render-before($name,$type,$value,$options), 
       <select name="{$name}">
       {form:render-attributes($name,$type,$value,$options)}
       {form:render-values($name,$type,$value,$options)}
       </select>,
       form:render-after($name,$type,$value,$options)
)};

(:~
 : Renders Locales 
~:)
declare function form:render-locale($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <select name="{$name}">
       {form:render-attributes($name,$type,$value,$options)}
       {form:render-values($name,$type,$value,$options)}
   </select>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-timezone($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <select name="{$name}">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </select>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-date($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="text" class="date">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-dateTime($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="text" class="date">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)  
)};

declare function form:render-birthday($name,$type,$value,$options)
{(  
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="text">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-collection($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="text">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-repeated($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="text">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-hidden($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="hidden">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-button($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <button name="{$name}" type="button">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </button>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-submit($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <button name="{$name}" type="submit">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </button>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-clear($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <button name="{$name}" type="clear">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </button>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-file($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" type="file">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-csrf($name,$type,$value,$options)
{(
   form:render-before($name,$type,$value,$options), 
   <input name="{$name}" id="CSRFToken" type="hidden">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </input>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-complex($name,$type,$value,$options)
{(
  form:render-before($name,$type,$value,$options), 
  <div class="complextextarea">
    {if ($options/editor/text() = 'ckeditor') 
     then <script src="/resources/js/ckeditor.js">//</script> 
     else ()}
    <textarea name="{$name}" id="{$name}">
        { if ($options/editor/text() = 'ckeditor') then attribute class {"ckeditor"} else () }
        { form:render-attributes($name,$type,$value,$options) }
        { $value }
     </textarea>
     { if($options/editor/text() = 'codemirror') then
          <script type="text/javascript">
               var {$name}_editor = CodeMirror.fromTextArea(document.getElementById("{$name}"), {{
                   mode: {{name: "xml", alignCDATA: true }},
                   lineNumbers: true
               }});
               codeMirrors['{$name}_editor'] = {$name}_editor;
          </script>
        else () 
     }
   </div>,
   form:render-after($name,$type,$value,$options)
)};

declare function form:render-grid($name,$type,$value,$options,$ui) {

   let $instance :=
      <json type="array">{
       for $option in $ui/domain:gridOptions/domain:gridOption
       return
         <option type="object">{(
           for $att in $option/@*
           let $localname := fn:local-name($att)
           return
               element { $localname } {
                   if($localname = 'editable') 
                   then attribute boolean { fn:data($att) }
                   else fn:data($att)
               },
             
           for $node in $option/node()
           return 
               element {fn:local-name($node)} {
                 attribute type { "object" },
                 for $att in $node/@*
                 return
                   element { fn:local-name($att)} {
                     fn:data($att)
                   }
               }
         )}</option>
      }</json>
   
   let $gridOptions :=  json:xmlToJSON($instance)
   
   let $labels := 
     <labels type="array">{
       for $label in  fn:data($ui/domain:gridOptions/domain:gridOption/@label)
       return
       <string type="string">{$label}</string>
     }</labels>
   
   let $gridLabels := json:xmlToJSON($labels)
   
   let $values := json:xmlToJSON(<json type="array">{$value}</json>)
   return
   (
     form:render-before($name,$type,$value,$options), 
      <div class="complexGridWrapper">
           <table id="{$name}" class="complexGrid"></table>
           <div id="{$name}_pager"></div>
           <script type="text/javascript">
              var {$name}_names = {$gridLabels};
              var {$name}_options = {$gridOptions};
              var {$name}_values = {$values};
              
              var selectedRow = null; 
              //buildJqGrid('{$name}',{$name}_names,{$name}_options,{$name}_values);
           </script>
       </div>,
      form:render-after($name,$type,$value,$options)
   )
};

declare function form:render-reference($name,$type,$value,$options) {
    <div class="referenceSelect">
           { form:render-before($name,$type,$value,$options) }
           <select id="{$name}" name="{$name}" class="field select large">
            <option value="">Please select a value</option>
            { 
               if($options/occurence/text() = ("*","+")) then
                   (attribute multiple { "multiple" },
                   attribute class { "multiselect" })
                else ()
            }
           <!-- Ajax to Load in options -->
           </select>
           <!-- Call script to load multiselect box with options -->
           <script type="text/javascript"> 
               var selected = [
                   {
                     for $node at $pos in $value
                     return ( 
                         fn:concat('"',fn:data($node/@ref-id),'"'),
                         if($pos = fn:count($value/node())) then () else ","
                     )
                   }
               ]
               populateRelatedOptions("{$name}", selected, "{$options/occurence/text()}");
           </script>
           { form:render-after($name,$type,$value,$options) }
    </div>
};
declare function form:render-query($name,$type,$value,$options,$ui)
{(
   form:render-before($name,$type,$value,$options), 
   <textarea id="field_{$name}" name="{$name}" class="field textarea large" style="">
   {form:render-attributes($name,$type,$value,$options)}
   {form:render-values($name,$type,$value,$options)}
   </textarea>,
   <script type="text/javascript">
       var {$name}_query = 
       CodeMirror.fromTextArea(jQuery("#field_{$name}"), {{
           mode: {{name: "xquery", alignCDATA: true }},
           lineNumbers: true
       }});
       codeMirrors['{$name}'] = {$name}_query;
    </script>
   
)};
declare function form:render-control($name,$type,$value,$opts,$ui)
{
  let $options := form:parse-options($opts)
  let $qtype := element {xs:QName($type)} {$options}
  return
    typeswitch($qtype)

     (: Complex Element :)
      case element(schema-element) return form:render-complex($name,$type,$value,$options)
      case element(reference) return form:render-reference($name,$type,$value,$options)
      case element(grid) return form:render-grid($name,$type,$value,$options,$ui)
      case element(query) return form:render-query($name,$type,$value,$options,$ui)

     (:Text Elements:)
      case element(string) return render-text($name,$type,$value,$options)
      case element(integer) return render-text($name,$type,$value,$options)
      case element(long) return render-text($name,$type,$value,$options)
      case element(decimal) return render-text($name,$type,$value,$options)
      case element(float) return render-text($name,$type,$value,$options)
      case element(anyURI) return render-text($name,$type,$value,$options)
      case element(yearMonth) return render-text($name,$type,$value,$options)
      case element(monthDay) return render-text($name,$type,$value,$options)

      case element(money) return form:render-money($name,$type,$value,$options)     
      case element(number) return form:render-number($name,$type,$value,$options)  
      case element(password) return form:render-password($name,$type,$value,$options)
      case element(email) return form:render-email($name,$type,$value,$options)
      case element(search) return form:render-search($name,$type,$value,$options)
      case element(url) return form:render-url($name,$type,$value,$options)
      
      case element(boolean) return form:render-text($name,'checkbox',$value,$options)
      
      (:Choice Elements:)
      case element(choice) return form:render-choice($name,$type,$value,$options)
      case element(entity) return form:render-entity($name,$type,$value,$options)
      case element(country) return form:render-country($name,$type,$value,$options)
      case element(locale) return form:render-locale($name,$type,$value,$options)
      case element(timezone) return form:render-timezone($name,$type,$value,$options)    
      
      (:Date Time Controls:)
      case element(date) return form:render-date($name,$type,$value,$options)
      case element(dateTime) return form:render-dateTime($name,$type,$value,$options)
      case element(time) return form:render-dateTime($name,$type,$value,$options)
      case element(birthday) return form:render-birthday($name,$type,$value,$options)
      
      (:Repeating Controls:)
      case element(collection) return form:render-collection($name,$type,$value,$options)
      case element(repeated) return form:render-repeated($name,$type,$value,$options)
      
      (:Button Controls:)
      case element(hidden) return form:render-hidden($name,$type,$value,$options)
      case element(button) return form:render-button($name,$type,$value,$options)
      case element(submit) return form:render-submit($name,$type,$value,$options)
      case element(clear) return form:render-clear($name,$type,$value,$options)
      
      (:Other Controls:)
      case element(csrf) return form:render-csrf($name,$type,$value,$options)
      case element(file) return form:render-file($name,$type,$value,$options)
 
      (:Custom Rendering:)
      case element() return form:render-custom($name,$type,$value,$options)
      
      default return ()  
};
declare function form:name($name)
{
   map:put($_form-options,"FORM-NAME",$name)
};
declare function form:name()
{
  (map:get($_form-options,"FORM-NAME"),"post")[1]
};

(:Form Options:)
declare function form:method($method)
{
   map:put($_form-options,"FORM-METHOD",$method)
};
declare function form:method()
{
  (map:get($_form-options,"FORM-METHOD"),"post")[1]
};

declare function form:action($action)
{
   map:put($_form-options,"FORM-ACTION",($action))
};
declare function form:action()
{
  map:get($_form-options,"FORM-ACTION")
};

declare function form:target($target)
{
   map:put($_form-options,"FORM-TARGET",$target)
};
declare function form:target()
{
  map:get($_form-options,"FORM-TARGET")
};

declare function form:accept-charset($charset)
{
  map:put($_form-options,"FORM-ACCEPT-CHARSET",$charset)
};
declare function form:accept-charset()
{
  map:get($_form-options,"FORM-ACCEPT-CHARSET")
};

declare function form:accept($charset)
{
  map:put($_form-options,"FORM-CHARSET",$charset)
};
declare function form:accept()
{
  map:get($_form-options,"FORM-CHARSET")
};

declare function form:enctype($enctype)
{
   map:put($_form-options,"FORM-ENCTYPE",$enctype)
};

declare function form:enctype()
{
   map:get($_form-options,"FORM-ENCTYPE")
};

(:Generic Method for adding Form Data:)
declare function form:add-custom($name,$type,$opts as xs:string*)
{
  fn:error(xs:QName("NOT-IMPLEMENTED"),"Custom Data is implemented")
};

(:Text Fields:)
declare function form:text($name,$options as xs:string*)
{
   form:add($name,'text',$options)
};

declare function form:textarea($name,$options as xs:string*)
{
    form:add($name,'textarea',$options)
};
declare function form:email($name,$options as xs:string*)
{
  form:add($name,'email',$options)
};

declare function form:money($name,$options as xs:string*)
{
  form:add($name,'money',$options)
};
declare function form:number($name,$options as xs:string*)
{
  form:add($name,'number',$options)
};

declare function form:password($name,$options as xs:string*)
{
   form:add($name,'password',$options)
};

(:Customized Templates:)
declare function form:search($name,$options as xs:string*)
{
  form:add($name,'search',$options) 
};

declare function form:url($name,$options as xs:string*)
{
  form:add($name,'url',$options)
};

(:Choice Elements:)
declare function form:choice($name,$options as xs:string*,$choices as item()*)
{
  form:add($name,'choice',$options)
};

declare function form:entity($name,$options as xs:string*,$choices as item()*)
{
  form:add($name,'entity',$options)
};

declare function form:country($name,$options as  xs:string*)
{
  form:add($name,'country',$options)
};

declare function form:locale($name,$options as xs:string*)
{
  form:add($name,'locale',$options)
};

declare function form:timezone($name,$options as xs:string*)
{
  form:add($name,'timezone',$options)
};

declare function form:language($name,$options as xs:string*)
{
  form:add($name,'language',$options)
};

(:Date and Time:)
declare function form:date($name,$options as xs:string*)
{
  form:add($name,'date',$options)
};

declare function form:dateTime($name,$options as xs:string*)
{
  form:add($name,'dateTime',$options)
};

declare function form:time($name,$options as xs:string*)
{
  form:add($name,'time',$options)

};

declare function form:birthday($name,$options as xs:string*)
{
  form:add($name,'birthday',$options)
};

(:Other Types:)
declare function form:checkbox($name,$options as xs:string*)
{
   form:add($name,'checkbox',$options)
};

declare function form:radio($name,$options as xs:string*)
{
   form:add($name,'radio',$options)
};

declare function form:file($name,$options as xs:string*)
{  
  form:add($name,'file',$options)
};

(:Field Groups:)
declare function form:collection($name,$options as xs:string*)
{
    form:add($name,'collection',$options)
};

declare function form:repeated($name,$options as xs:string*)
{
  form:add($name,'repeated',$options)
};

declare function form:hidden($name,$options as xs:string*)
{
  form:add($name,'hidden',$options)
};

declare function form:button($name,$options as xs:string*)
{
  form:add($name,'button',$options)
};

declare function form:submit($name,$options as xs:string*)
{
 form:add($name,'submit',$options)
};

declare function form:validation($name,$options as xs:string*)
{
   form:add($name,'validation',$options)
};

declare function form:csrf($name,$options as xs:string*)
{ 
   form:add($name,'csrf',$options)
};