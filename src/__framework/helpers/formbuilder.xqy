xquery version "1.0-ml";

module namespace form = "http://www.xquerrail-framework.com/formbuilder";

declare default element namespace "http://www.w3.org/1999/xhtml";

(:
import module namespace request = "http://www.xquerrail-framework.com/request"
at "/_framework/request.xqy";
:)
import module namespace domain = "http://www.xquerrail-framework.com/domain" 
at "/_framework/domain.xqy";

import module namespace json  = "http://marklogic.com/json" 
at "/lib/json.xqy";

import module namespace response = "http://www.xquerrail-framework.com/response"
at "/_framework/response.xqy";

import module namespace base = "http://www.xquerrail-framework.com/model/base"
  at "/_framework/base/base-model.xqy";

declare option xdmp:output "indent=yes";
declare option xdmp:output "method=xml";
declare option xdmp:ouput "omit-xml-declaration=yes";

declare function form:build-form(
 $domain-model as node(),
 $response as map:map?)
as item()*
{
    let $init := response:initialize($response)
    for $field in $domain-model/(domain:attribute|domain:element|domain:container)
    return 
      form:build-form-field($field)
};

declare function form:get-field-name($field as node()) {
    domain:get-field-key($field)  
};

declare function form:build-form-field($field as node())
{
   let $value :=  form:get-value-from-response($field)
   let $type := (fn:data($field/domain:ui/@type),fn:data($field/@type))[1]
   let $label := fn:data($field/@label)
   let $repeater := 
       if(fn:data($field/domain:ui/@repeat) = 'true') then
       (
        <a href="#" onclick="return repeatAdd(this,'{domain:get-field-key($field)}', '{$label}');" class="ui-icon ui-icon-plus">+</a>,
        <a href="#" onclick="return repeatRemove(this,'{domain:get-field-key($field)}', '{$label}');" class="ui-icon ui-icon-minus">-</a>
       )
       else ()
       
   return
   typeswitch($field)
     case element(domain:container) return
        <fieldset>
            <legend>{fn:data($field/@label)}</legend>
        { 
            for $containerField in $field/(domain:attribute|domain:element|domain:container)
            return
                form:build-form-field($containerField) 
        }</fieldset>
     case element(domain:element) return
       if ($repeater and $value) then 
            for $v in $value
            return
            <div class="type_{$type}">{ (form:render-control($field,$v),$repeater) }</div>
       else
            <div class="type_{$type}">{ (form:render-control($field,$value),$repeater) }</div>
     case element(domain:attribute) return
       if ($repeater and $value) then 
            for $v in $value
            return
            <div class="type_{$type}">{ (form:render-control($field,$v),$repeater) }</div>
       else
            <div class="type_{$type}">{ (form:render-control($field,$value),$repeater) }</div>
     default return ()
};

declare function form:render-control($field,$value)
{
  let $type := (fn:data($field/domain:ui/@type),fn:data($field/@type))[1]
  let $qtype := element {xs:QName($type)} { $type }
  return
    typeswitch($qtype)

     (: Complex Element :)
      case element(schema-element) return form:render-complex($field,$value)
      case element(reference) return form:render-reference($field,$value)
      case element(grid) return form:render-grid($field,$value)

      (:Text Elements:)
      case element(string) return render-text($field,$value)
      case element(integer) return render-text($field,$value)
      case element(long) return render-text($field,$value)
      case element(decimal) return render-text($field,$value)
      case element(float) return render-text($field,$value)
      case element(anyURI) return render-text($field,$value)
      case element(yearMonth) return render-text($field,$value)
      case element(monthDay) return render-text($field,$value)
      
      case element(boolean) return render-checkbox($field,$value)
      case element(money) return form:render-money($field,$value)     
      case element(number) return form:render-number($field,$value)  
      case element(password) return form:render-password($field,$value)
      case element(email) return form:render-email($field,$value)
      case element(search) return form:render-search($field,$value)
      case element(url) return form:render-url($field,$value)
      
      (:Choice Elements:)
      case element(list) return form:render-choice($field,$value)
      case element(choice) return form:render-choice($field,$value)
      case element(entity) return form:render-entity($field,$value)
      case element(country) return form:render-country($field,$value)
      case element(locale) return form:render-locale($field,$value)
      case element(timezone) return form:render-timezone($field,$value)    
      
      (:Date Time Controls:)
      case element(date) return form:render-date($field,$value)
      case element(dateTime) return form:render-dateTime($field,$value)
      case element(time) return form:render-dateTime($field,$value)
      case element(birthday) return form:render-birthday($field,$value)
      
      (:Repeating Controls:)
      case element(collection) return form:render-collection($field,$value)
      case element(repeated) return form:render-repeated($field,$value)
      
      (:Button Controls:)
      case element(hidden) return form:render-hidden($field,$value)
      
      case element(button) return form:render-button($field,$value)
      case element(submit) return form:render-submit($field,$value)
      case element(clear) return form:render-clear($field,$value)
      
      (:Other Controls:)
      case element(csrf) return form:render-csrf($field,$value)
      case element(file) return form:render-file($field,$value)
 
      (:Custom Rendering:)
      case element() return form:render-custom($field,$value)
      
      default return <div class="error">No Render for field type {$type}.</div>
};

declare function form:get-value-from-response($field as element()) {

    let $model := $field/ancestor::domain:model
    let $name := fn:data($model/@name)
    let $ns := fn:data($model/@namespace)[1]
    
    (: Verify you only pull the approprite node just incase the body is a sequence :)
    let $node := response:body()[fn:local-name(.) = $name and fn:namespace-uri(.) = $ns]
    
    let $value := domain:get-field-value($model, domain:get-field-key($field), $node )
    return 
        $value
};

declare function form:get-value-by-name-from-response($name as xs:string) {
    let $value := response:body()//*[fn:string(fn:node-name(.)) = $name]
    return 
        $value
};

declare function form:render-before($field)
{
  if($field/@label and fn:not($field/domain:ui/@type = "hidden")) 
  then 
    <label for="{form:get-field-name($field)}" class="desc">
        {fn:data($field/@label)}
    </label> 
  else ()
}; 

declare function form:render-after($field)
{
    ()
};

declare function form:render-attributes($field)
{(
  if($field/domain:constraint/@required) 
  then attribute required{fn:boolean($field/domain:constraint/@required)} 
  else (),
  
  if($field/domain:constraint/@maxlength) 
  then attribute maxlength {fn:data($field/domain:constraint/@maxlength)} 
  else (),
  
  if($field/@editable = 'false') 
  then attribute readonly { 'readonly' } 
  else (),
  
  if($field/domain:navigation/@editable = 'false') 
  then attribute readonly { "readonly" } 
  else ()
)};

declare function form:render-values($field,$value)
{
 let $list  := $field/ancestor::domain:model/domain:optionlist[@name = $field/domain:constraint/@inList]
 return 
 if($list) then
    for $option in $list/domain:option
    return
        <option value="{$option/text()}">
            {   if($value = $option/text()) then
                    attribute selected {"selected" }
                else (),
                (fn:data($option/@label),$option/text())[1]
            }
        </option>
 else 
    if(fn:data($field/@type = "boolean")) 
    then
        (   
            attribute value {"true"},
            if($value eq "true") 
            then attribute checked {"checked"}
            else ()
        )
    else
        attribute value {$value}
};

declare function form:render-custom($field,$value)
{
  ()
};
(:~
 : Function binds controls to their respective request data 
 : from the request map;
~:)
declare function form:render-text($field,$value)
{
  (
       form:render-before($field), 
       if($field/domain:constraint/@inList) then
       <select name="{form:get-field-name($field)}"  class="form select">
       {form:render-attributes($field)}
       {form:render-values($field,$value)}
       </select>
       else 
       <input name="{form:get-field-name($field)}" type="text" class="form text">
       {form:render-attributes($field)}
       {form:render-values($field,$value)}
       </input>
       ,
       form:render-after($field)
  )
};

declare function form:render-checkbox($field,$value)
{
  (
       form:render-before($field), 
       <input name="{form:get-field-name($field)}" type="checkbox">
       {form:render-attributes($field)}
       {form:render-values($field,$value)}
       </input>,
       form:render-after($field)
  )
};

declare function form:render-money($field,$value)
{(
           form:render-before($field), 
           <input name="{form:get-field-name($field)}" type="text">
           {form:render-attributes($field)}
           {form:render-values($field,$value)}
           </input>,
           form:render-after($field)
)};

declare function form:render-number($field,$value)
{
(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="text">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)
};
declare function form:render-password($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="password">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-email($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="text">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-search($field,$value)
{(
       form:render-before($field), 
       <input name="{form:get-field-name($field)}" type="text">
       {form:render-attributes($field)}
       {form:render-values($field,$value)}
       </input>,
       form:render-after($field)
)};

declare function form:render-url($field,$value)
{(
       form:render-before($field), 
       <input name="{form:get-field-name($field)}" type="text">
       {form:render-attributes($field)}
       {form:render-values($field,$value)}
       </input>,
       form:render-after($field)
)};

declare function form:render-choice($field,$value)
{(
       form:render-before($field), 
       <select name="{form:get-field-name($field)}">
       {form:render-attributes($field)}
       {form:render-values($field,$value)}
       </select>,
       form:render-after($field)
)};

declare function form:render-entity($field,$value)
{(
       form:render-before($field), 
       <select name="{form:get-field-name($field)}">
       {form:render-attributes($field)}
       {form:render-values($field,$value)}
       </select>,
       form:render-after($field)
)};

declare function form:render-country($field,$value)
{(
       form:render-before($field), 
       <select name="{form:get-field-name($field)}">
       {form:render-attributes($field)}
       {form:render-values($field,$value)}
       </select>,
       form:render-after($field)
)};

declare function form:render-locale($field,$value)
{(
    form:render-before($field), 
    <select name="{form:get-field-name($field)}">
    {form:render-attributes($field)}
    {form:render-values($field,$value)}
    </select>,
    form:render-after($field)
)};

declare function form:render-timezone($field,$value)
{(
   form:render-before($field), 
   <select name="{form:get-field-name($field)}">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </select>,
   form:render-after($field)
)};

declare function form:render-date($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="text" class="date">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-dateTime($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="text" class="date">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)  
)};

declare function form:render-birthday($field,$value)
{(  
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="text">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-collection($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="text">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-repeated($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="text">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-hidden($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="hidden">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-button($field,$value)
{(
   form:render-before($field), 
   <button name="{form:get-field-name($field)}" type="button">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </button>,
   form:render-after($field)
)};

declare function form:render-submit($field,$value)
{(
   form:render-before($field), 
   <button name="{form:get-field-name($field)}" type="submit">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </button>,
   form:render-after($field)
)};

declare function form:render-clear($field,$value)
{(
   form:render-before($field), 
   <button name="{form:get-field-name($field)}" type="clear">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </button>,
   form:render-after($field)
)};

declare function form:render-file($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" type="file">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-csrf($field,$value)
{(
   form:render-before($field), 
   <input name="{form:get-field-name($field)}" id="CSRFToken" type="hidden">
   {form:render-attributes($field)}
   {form:render-values($field,$value)}
   </input>,
   form:render-after($field)
)};

declare function form:render-complex($field,$value) 
{
(
  form:render-before($field), 
  <div class="complextextarea">
    <textarea name="{form:get-field-name($field)}" id="{fn:data($field/@name)}">
        { if ($field/domain:navigation/@editor = 'ckeditor') then attribute class {"ckeditor"} else () }
        { form:render-attributes($field) }
        {(: xdmp:xslt-invoke("/application/lib/xslt/removespaces.xsl",document{ $value }) :)}
        { $value/node() }
     </textarea>
     { if($field/domain:navigation/@editor = 'codemirror') then
          <script type="text/javascript">
               var {fn:data($field/@name)}_editor = CodeMirror.fromTextArea(document.getElementById("{fn:data($field/@name)}"), {{
                   mode: {{name: "xml", alignCDATA: true }},
                   lineNumbers: true
               }});
               codeMirrors['{fn:data($field/@name)}_editor'] = {fn:data($field/@name)}_editor;
          </script>
        else () 
     }
   </div>,
   form:render-after($field)
)};

declare function form:render-grid($field,$value) {
   let $fieldKey := form:get-field-name($field)
   let $instance :=
      <json type="array">{
       for $gridColumn in $field/domain:ui/domain:gridColumns/domain:gridColumn
       return
         <option type="object">{(
           for $att in $gridColumn/@*
           let $localname := fn:local-name($att)
           return
               element { $localname } {
                   if($localname = 'editable') 
                   then attribute boolean { fn:data($att) }
                   else fn:data($att)
               },
             
           for $node in $gridColumn/node()
           return 
               element {fn:local-name($node)} {
                 attribute type { "object" },
                 for $att in $node/@*
                 return
                   element { fn:local-name($att)} {
                     fn:normalize-space(fn:data($att))
                   }
               }
         )}</option>
      }</json>
   
   let $gridOptions :=  json:xmlToJSON($instance)
   let $labels := 
     <labels type="array">{
       for $label in  fn:data($field/domain:ui/domain:gridOptions/domain:gridOption/@label)
       return
       <string type="string">{$label}</string>
     }</labels>
   
   let $gridLabels := json:xmlToJSON($labels)
   
 
   let $values := json:xmlToJSON(
     <json type="array">{
         for $node in $value/element()
         return
         <item type="object">{$node/node()}</item>
     }</json>)
   
   return
   (
     form:render-before($field), 
      <div class="complexGridWrapper">
           <table id="{$fieldKey}" class="complexGrid"></table>
           <div id="{$fieldKey}_pager"></div>
           <script type="text/javascript">
              var {fn:data($field/@name)}_names = {$gridLabels};
              var {fn:data($field/@name)}_options = {$gridOptions};
              var {fn:data($field/@name)}_values = {$values};
              
              var selectedRow = null; 
              buildJqGrid('{$fieldKey}',{fn:data($field/@name)}_names,{fn:data($field/@name)}_options,{fn:data($field/@name)}_values);
           </script>
       </div>,
      form:render-after($field)
   )
};

declare function form:render-reference($field,$value) {
    let $application := response:application()
    let $modelName := fn:tokenize(fn:data($field/@reference),":")[2]
    let $reference := fn:data($field/@reference)
    let $refTokens := fn:tokenize($reference,":")
    let $refParent   := $refTokens[1]
    let $refType     := $refTokens[2]
    let $refAction   := $refTokens[3]
    
    return
    <div class="referenceSelect">
           { form:render-before($field) }
           
           <select id="{fn:data($field/@name)}SelectBox" name="{form:get-field-name($field)}">
            { 
               if($field/@occurence = "*") then
                   (attribute multiple { "multiple" },
                   attribute class { "multiselect" })
                else ()
            }
            <option value="">Please select {fn:data($field/@label)}</option> 
            {
                (: Build Model Refrences using the lookup feature in the base model :)
                if($refParent = 'model') then
                     let $lookups := base:lookup(domain:get-domain-model($modelName),map:map())
                     for $lookup in $lookups/*:lookup
                     let $key := $lookup/*:key/text()
                     let $label := $lookup/*:label/text()
                     return 
                       element option {
                            attribute value {$key},
                            if(fn:data($value[@ref = $refType]/@ref-id) = $key) 
                            then attribute selected { "selected" } 
                            else (),               
                            $label
                       }
                (: Build Abstract Model References using the base model functions :)       
                else if($refParent = 'application') then  
                    if($refParent eq "application" and $refType eq "model")
                    then 
                      let $domains := xdmp:value(fn:concat("domain:model-",$refAction))
                      for $model in $domains
                      let $key := fn:data($model/@name)
                      let $label := fn:data($model/@label)
                      return
                          element option {
                              attribute value { $key },
                              if($value/@ref-id = $key) 
                              then attribute selected { "selected" }
                              else (),
                              $label
                          }
                     else ()
                else ()
             }
           </select>
           
           {
            (: Allow the multi select javascript pane if it is a multiple occurence :)
            if($field/@occurence = "*") then 
               <script type="text/javascript">
                   jQuery("#{fn:data($field/@name)}SelectBox").multiselect();
               </script>
            else ()
           }
           
           { form:render-after($field) }
    </div>
};
