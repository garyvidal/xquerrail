# library module: http://www.xquerrail-framework.com/response
  Response Helper function wrapper. ~



## Table of Contents

* Variables: [$CONTENT-TYPE](#var_CONTENT-TYPE), [$CONTEXT](#var_CONTEXT), [$DOCTYPE](#var_DOCTYPE), [$CODE](#var_CODE), [$ENCODING](#var_ENCODING), [$VIEW](#var_VIEW), [$REDIRECT](#var_REDIRECT), [$TEMPLATE](#var_TEMPLATE), [$BODY](#var_BODY), [$APPLICATION](#var_APPLICATION), [$FORMAT](#var_FORMAT), [$CONTROLLER](#var_CONTROLLER), [$ACTION](#var_ACTION), [$ERROR](#var_ERROR), [$PARTIAL](#var_PARTIAL), [$FLASH](#var_FLASH), [$BASE](#var_BASE), [$MODEL](#var_MODEL), [$HEADER](#var_HEADER), [$PARAMETER](#var_PARAMETER), [$SLOT-PREFIX](#var_SLOT-PREFIX), [$META](#var_META), [$HTTPMETA](#var_HTTPMETA), [$STYLESHEET](#var_STYLESHEET), [$JAVASCRIPT](#var_JAVASCRIPT), [$COOKIE](#var_COOKIE), [$response](#var_response)
* Functions: [initialize\#1](#func_initialize_1), [initialize\#2](#func_initialize_2), [set-response\#1](#func_set-response_1), [set-base\#1](#func_set-base_1), [base\#0](#func_base_0), [set-response\#2](#func_set-response_2), [set-flash\#2](#func_set-flash_2), [flash\#0](#func_flash_0), [flush\#0](#func_flush_0), [response\#0](#func_response_0), [error\#0](#func_error_0), [set-error\#2](#func_set-error_2), [has-error\#0](#func_has-error_0), [set-format\#1](#func_set-format_1), [format\#0](#func_format_0), [set-body\#1](#func_set-body_1), [body\#0](#func_body_0), [set-response-code\#2](#func_set-response-code_2), [response-code\#0](#func_response-code_0), [set-content-type\#1](#func_set-content-type_1), [content-type\#0](#func_content-type_0), [set-application\#1](#func_set-application_1), [application\#0](#func_application_0), [set-controller\#1](#func_set-controller_1), [controller\#0](#func_controller_0), [set-action\#1](#func_set-action_1), [action\#0](#func_action_0), [partial\#0](#func_partial_0), [set-partial\#1](#func_set-partial_1), [set-view\#1](#func_set-view_1), [view\#0](#func_view_0), [set-template\#1](#func_set-template_1), [template\#0](#func_template_0), [redirect\#2](#func_redirect_2), [redirect\#1](#func_redirect_1), [redirect\#0](#func_redirect_0), [add-response-header\#2](#func_add-response-header_2), [response-header\#1](#func_response-header_1), [response-headers\#0](#func_response-headers_0), [add-para\#2](#func_add-para_2), [set-param\#2](#func_set-param_2), [delete-param\#1](#func_delete-param_1), [delete-param\#2](#func_delete-param_2), [param\#1](#func_param_1), [get-data\#1](#func_get-data_1), [set-data\#2](#func_set-data_2), [data\#1](#func_data_1), [add-data\#2](#func_add-data_2), [slots\#0](#func_slots_0), [set-slot\#2](#func_set-slot_2), [has-slot\#1](#func_has-slot_1), [slot\#1](#func_slot_1), [set-title\#1](#func_set-title_1), [title\#0](#func_title_0), [add-meta\#2](#func_add-meta_2), [add-meta\#3](#func_add-meta_3), [meta\#1](#func_meta_1), [meta-keys\#0](#func_meta-keys_0), [metas\#0](#func_metas_0), [add-httpmeta\#2](#func_add-httpmeta_2), [add-httpmeta\#3](#func_add-httpmeta_3), [httpmeta\#1](#func_httpmeta_1), [httpmeta-keys\#0](#func_httpmeta-keys_0), [httpmetas\#0](#func_httpmetas_0), [add-cookie\#1](#func_add-cookie_1), [cookies\#0](#func_cookies_0), [cookie\#1](#func_cookie_1), [remove-cookie\#1](#func_remove-cookie_1), [javascripts\#0](#func_javascripts_0), [add-javascript\#3](#func_add-javascript_3), [add-javascript\#1](#func_add-javascript_1), [remove-javascript\#1](#func_remove-javascript_1), [clear-javascripts\#0](#func_clear-javascripts_0), [stylesheets\#0](#func_stylesheets_0), [add-stylesheet\#1](#func_add-stylesheet_1), [add-stylesheet\#2](#func_add-stylesheet_2), [remove-stylesheet\#1](#func_remove-stylesheet_1), [clear-stylesheets\#0](#func_clear-stylesheets_0), [set-model\#1](#func_set-model_1), [model\#0](#func_model_0)


## Variables

### <a name="var_CONTENT-TYPE"/> $CONTENT-TYPE
```xquery
$CONTENT-TYPE as 
```

### <a name="var_CONTEXT"/> $CONTEXT
```xquery
$CONTEXT as 
```

### <a name="var_DOCTYPE"/> $DOCTYPE
```xquery
$DOCTYPE as 
```

### <a name="var_CODE"/> $CODE
```xquery
$CODE as 
```

### <a name="var_ENCODING"/> $ENCODING
```xquery
$ENCODING as 
```

### <a name="var_VIEW"/> $VIEW
```xquery
$VIEW as 
```

### <a name="var_REDIRECT"/> $REDIRECT
```xquery
$REDIRECT as 
```

### <a name="var_TEMPLATE"/> $TEMPLATE
```xquery
$TEMPLATE as 
```

### <a name="var_BODY"/> $BODY
```xquery
$BODY as 
```

### <a name="var_APPLICATION"/> $APPLICATION
```xquery
$APPLICATION as 
```

### <a name="var_FORMAT"/> $FORMAT
```xquery
$FORMAT as 
```

### <a name="var_CONTROLLER"/> $CONTROLLER
```xquery
$CONTROLLER as 
```

### <a name="var_ACTION"/> $ACTION
```xquery
$ACTION as 
```

### <a name="var_ERROR"/> $ERROR
```xquery
$ERROR as 
```

### <a name="var_PARTIAL"/> $PARTIAL
```xquery
$PARTIAL as 
```

### <a name="var_FLASH"/> $FLASH
```xquery
$FLASH as 
```

### <a name="var_BASE"/> $BASE
```xquery
$BASE as 
```

### <a name="var_MODEL"/> $MODEL
```xquery
$MODEL as 
```

### <a name="var_HEADER"/> $HEADER
```xquery
$HEADER as 
```

### <a name="var_PARAMETER"/> $PARAMETER
```xquery
$PARAMETER as 
```

### <a name="var_SLOT-PREFIX"/> $SLOT-PREFIX
```xquery
$SLOT-PREFIX as 
```

### <a name="var_META"/> $META
```xquery
$META as 
```

### <a name="var_HTTPMETA"/> $HTTPMETA
```xquery
$HTTPMETA as 
```

### <a name="var_STYLESHEET"/> $STYLESHEET
```xquery
$STYLESHEET as 
```

### <a name="var_JAVASCRIPT"/> $JAVASCRIPT
```xquery
$JAVASCRIPT as 
```

### <a name="var_COOKIE"/> $COOKIE
```xquery
$COOKIE as 
```

### <a name="var_response"/> $response
```xquery
$response as 
```
  Response Map used to store all response information ~




## Functions

### <a name="func_initialize_1"/> initialize\#1
```xquery
initialize($response
)
```

#### Params

* response as 


### <a name="func_initialize_2"/> initialize\#2
```xquery
initialize(
    $response as map:map,
    $request as map:map?
)
```
  Initializes a response and returns a new response object 


#### Params

* response as  map:map

* request as  map:map?


### <a name="func_set-response_1"/> set-response\#1
```xquery
set-response($_response
)
```

#### Params

* _response as 


### <a name="func_set-base_1"/> set-base\#1
```xquery
set-base($isbase as xs:boolean
)
```

#### Params

* isbase as  xs:boolean


### <a name="func_base_0"/> base\#0
```xquery
base(
)
```

### <a name="func_set-response_2"/> set-response\#2
```xquery
set-response($_response as map:map,$_request as map:map?
)
```
  Sets the response object for convenience features 


#### Params

* _response as  map:map

* _request as  map:map?


### <a name="func_set-flash_2"/> set-flash\#2
```xquery
set-flash($name as xs:string,$message as xs:string
)
```
  The Flash message is a convenient may to store information   between requests redirects for validation and other things.  THe flash object is cleared between request/response calls.  


#### Params

* name as  xs:string as xs:string ~

* message as  xs:string


### <a name="func_flash_0"/> flash\#0
```xquery
flash(
)
```

### <a name="func_flush_0"/> flush\#0
```xquery
flush(
)
```
  In order to Route the request you must flush the map at the end   of a controller response.  The map is used by the dispatcher   finalize the rendering process. ~


### <a name="func_response_0"/> response\#0
```xquery
response(
)
```
  


### <a name="func_error_0"/> error\#0
```xquery
error(
)
```

### <a name="func_set-error_2"/> set-error\#2
```xquery
set-error($code as xs:string,$ex as element()
)
```

#### Params

* code as  xs:string

* ex as  element()


### <a name="func_has-error_0"/> has-error\#0
```xquery
has-error(
)
```

### <a name="func_set-format_1"/> set-format\#1
```xquery
set-format($format
)
```

#### Params

* format as 


### <a name="func_format_0"/> format\#0
```xquery
format(
)
```

### <a name="func_set-body_1"/> set-body\#1
```xquery
set-body($body
)
```

#### Params

* body as 


### <a name="func_body_0"/> body\#0
```xquery
body(
)
```

### <a name="func_set-response-code_2"/> set-response-code\#2
```xquery
set-response-code(
    $code as xs:integer,
    $message as xs:string
)
```

#### Params

* code as  xs:integer

* message as  xs:string


### <a name="func_response-code_0"/> response-code\#0
```xquery
response-code(
)
```

### <a name="func_set-content-type_1"/> set-content-type\#1
```xquery
set-content-type(
    $name as xs:string
)
```

#### Params

* name as  xs:string


### <a name="func_content-type_0"/> content-type\#0
```xquery
content-type(
)
```

### <a name="func_set-application_1"/> set-application\#1
```xquery
set-application($application as xs:string
)
```

#### Params

* application as  xs:string


### <a name="func_application_0"/> application\#0
```xquery
application(
)
```

### <a name="func_set-controller_1"/> set-controller\#1
```xquery
set-controller($controller as xs:string
)
```

#### Params

* controller as  xs:string


### <a name="func_controller_0"/> controller\#0
```xquery
controller(
)
```

### <a name="func_set-action_1"/> set-action\#1
```xquery
set-action($action as xs:string
)
```

#### Params

* action as  xs:string


### <a name="func_action_0"/> action\#0
```xquery
action(
)
```

### <a name="func_partial_0"/> partial\#0
```xquery
partial(
)
```

### <a name="func_set-partial_1"/> set-partial\#1
```xquery
set-partial($view as xs:boolean
)
```

#### Params

* view as  xs:boolean


### <a name="func_set-view_1"/> set-view\#1
```xquery
set-view($view as xs:string
)
```

#### Params

* view as  xs:string


### <a name="func_view_0"/> view\#0
```xquery
view(
)
```

### <a name="func_set-template_1"/> set-template\#1
```xquery
set-template($template as xs:string
)
```

#### Params

* template as  xs:string


### <a name="func_template_0"/> template\#0
```xquery
template(
)
```

### <a name="func_redirect_2"/> redirect\#2
```xquery
redirect($controller as xs:string,$action as xs:string
)
```

#### Params

* controller as  xs:string

* action as  xs:string


### <a name="func_redirect_1"/> redirect\#1
```xquery
redirect($uri as xs:string
)
```

#### Params

* uri as  xs:string


### <a name="func_redirect_0"/> redirect\#0
```xquery
redirect(
)
```

### <a name="func_add-response-header_2"/> add-response-header\#2
```xquery
add-response-header($key,$value
)
```

#### Params

* key as 

* value as 


### <a name="func_response-header_1"/> response-header\#1
```xquery
response-header($key
)
```

#### Params

* key as 


### <a name="func_response-headers_0"/> response-headers\#0
```xquery
response-headers(
) as  map:map
```

#### Returns
*  map:map

### <a name="func_add-para_2"/> add-para\#2
```xquery
add-para(
  $key as xs:string,
  $value as xs:string
) as  empty-sequence()
```

#### Params

* key as  xs:string

* value as  xs:string


#### Returns
*  empty-sequence()

### <a name="func_set-param_2"/> set-param\#2
```xquery
set-param($key as xs:string,$value as xs:string
)
```

#### Params

* key as  xs:string

* value as  xs:string


### <a name="func_delete-param_1"/> delete-param\#1
```xquery
delete-param($key as xs:string
)
```

#### Params

* key as  xs:string


### <a name="func_delete-param_2"/> delete-param\#2
```xquery
delete-param($key as xs:string,$value as xs:string
)
```

#### Params

* key as  xs:string

* value as  xs:string


### <a name="func_param_1"/> param\#1
```xquery
param($key
)
```

#### Params

* key as 


### <a name="func_get-data_1"/> get-data\#1
```xquery
get-data($key
)
```

#### Params

* key as 


### <a name="func_set-data_2"/> set-data\#2
```xquery
set-data($key,$value
)
```

#### Params

* key as 

* value as 


### <a name="func_data_1"/> data\#1
```xquery
data($key
)
```

#### Params

* key as 


### <a name="func_add-data_2"/> add-data\#2
```xquery
add-data($key,$value
)
```

#### Params

* key as 

* value as 


### <a name="func_slots_0"/> slots\#0
```xquery
slots(
)
```

### <a name="func_set-slot_2"/> set-slot\#2
```xquery
set-slot($key,$value
)
```

#### Params

* key as 

* value as 


### <a name="func_has-slot_1"/> has-slot\#1
```xquery
has-slot($key
)
```

#### Params

* key as 


### <a name="func_slot_1"/> slot\#1
```xquery
slot($key
)
```

#### Params

* key as 


### <a name="func_set-title_1"/> set-title\#1
```xquery
set-title($value
)
```
  ~


#### Params

* value as 


### <a name="func_title_0"/> title\#0
```xquery
title(
)
```
  Set the title for the given response page ~


### <a name="func_add-meta_2"/> add-meta\#2
```xquery
add-meta($key,$value
)
```
 META~  ~


#### Params

* key as 

* value as 


### <a name="func_add-meta_3"/> add-meta\#3
```xquery
add-meta($key as xs:string,$value as xs:string,$append as xs:boolean
)
```

#### Params

* key as  xs:string

* value as  xs:string

* append as  xs:boolean


### <a name="func_meta_1"/> meta\#1
```xquery
meta($key
)
```

#### Params

* key as 


### <a name="func_meta-keys_0"/> meta-keys\#0
```xquery
meta-keys(
)
```

### <a name="func_metas_0"/> metas\#0
```xquery
metas(
)
```

### <a name="func_add-httpmeta_2"/> add-httpmeta\#2
```xquery
add-httpmeta($key,$value
)
```
HTTP META~


#### Params

* key as 

* value as 


### <a name="func_add-httpmeta_3"/> add-httpmeta\#3
```xquery
add-httpmeta($key as xs:string,$value as xs:string,$append as xs:boolean
)
```

#### Params

* key as  xs:string

* value as  xs:string

* append as  xs:boolean


### <a name="func_httpmeta_1"/> httpmeta\#1
```xquery
httpmeta($key
)
```

#### Params

* key as 


### <a name="func_httpmeta-keys_0"/> httpmeta-keys\#0
```xquery
httpmeta-keys(
)
```

### <a name="func_httpmetas_0"/> httpmetas\#0
```xquery
httpmetas(
)
```

### <a name="func_add-cookie_1"/> add-cookie\#1
```xquery
add-cookie($name
)
```

#### Params

* name as 


### <a name="func_cookies_0"/> cookies\#0
```xquery
cookies(
)
```

### <a name="func_cookie_1"/> cookie\#1
```xquery
cookie($name
)
```

#### Params

* name as 


### <a name="func_remove-cookie_1"/> remove-cookie\#1
```xquery
remove-cookie($name
)
```

#### Params

* name as 


### <a name="func_javascripts_0"/> javascripts\#0
```xquery
javascripts(
)
```

### <a name="func_add-javascript_3"/> add-javascript\#3
```xquery
add-javascript(
$name as xs:string,
$position as xs:string,
$options as element(response:options)
)
```

#### Params

* name as  xs:string

* position as  xs:string

* options as  element(response:options)


### <a name="func_add-javascript_1"/> add-javascript\#1
```xquery
add-javascript($name
)
```

#### Params

* name as 


### <a name="func_remove-javascript_1"/> remove-javascript\#1
```xquery
remove-javascript($name
)
```

#### Params

* name as 


### <a name="func_clear-javascripts_0"/> clear-javascripts\#0
```xquery
clear-javascripts(
)
```

### <a name="func_stylesheets_0"/> stylesheets\#0
```xquery
stylesheets(
)
```

### <a name="func_add-stylesheet_1"/> add-stylesheet\#1
```xquery
add-stylesheet($name
)
```

#### Params

* name as 


### <a name="func_add-stylesheet_2"/> add-stylesheet\#2
```xquery
add-stylesheet($name as xs:string,$params as xs:string*
)
```

#### Params

* name as  xs:string

* params as  xs:string\*


### <a name="func_remove-stylesheet_1"/> remove-stylesheet\#1
```xquery
remove-stylesheet($name
)
```

#### Params

* name as 


### <a name="func_clear-stylesheets_0"/> clear-stylesheets\#0
```xquery
clear-stylesheets(
)
```

### <a name="func_set-model_1"/> set-model\#1
```xquery
set-model($model as element(domain:model)?
)
```

#### Params

* model as  element(domain:model)?


### <a name="func_model_0"/> model\#0
```xquery
model(
)
```





*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
