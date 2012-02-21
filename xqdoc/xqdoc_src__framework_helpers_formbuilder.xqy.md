# library module: http://www.xquerrail-framework.com/formbuilder


## Table of Contents

* Variables: [$_form-controls](#var__form-controls), [$_form-options](#var__form-options), [$_form-bindings](#var__form-bindings), [$_control-options](#var__control-options), [$_request](#var__request), [$FORM-INDEX-COUNT](#var_FORM-INDEX-COUNT), [$FORM-INDEX](#var_FORM-INDEX), [$FORM-VALIDATIONS](#var_FORM-VALIDATIONS), [$CONTROL-OPTIONS](#var_CONTROL-OPTIONS)
* Functions: [ get-control-options\#1](#func_ get-control-options_1), [ control-options\#2](#func_ control-options_2), [ control-option\#2](#func_ control-option_2), [ control-option\#3](#func_ control-option_3), [ control-option\#4](#func_ control-option_4), [bind\#1](#func_bind_1), [flush\#0](#func_flush_0), [parse-options\#1](#func_parse-options_1), [render-before\#4](#func_render-before_4), [render-after\#4](#func_render-after_4), [render-attributes\#4](#func_render-attributes_4), [render-values\#4](#func_render-values_4), [render-custom\#4](#func_render-custom_4), [render-text\#4](#func_render-text_4), [render-money\#4](#func_render-money_4), [render-number\#4](#func_render-number_4), [render-password\#4](#func_render-password_4), [render-email\#4](#func_render-email_4), [render-search\#4](#func_render-search_4), [render-url\#4](#func_render-url_4), [render-choice\#4](#func_render-choice_4), [render-entity\#4](#func_render-entity_4), [render-country\#4](#func_render-country_4), [render-locale\#4](#func_render-locale_4), [render-timezone\#4](#func_render-timezone_4), [render-date\#4](#func_render-date_4), [render-dateTime\#4](#func_render-dateTime_4), [render-birthday\#4](#func_render-birthday_4), [render-collection\#4](#func_render-collection_4), [render-repeated\#4](#func_render-repeated_4), [render-hidden\#4](#func_render-hidden_4), [render-button\#4](#func_render-button_4), [render-submit\#4](#func_render-submit_4), [render-clear\#4](#func_render-clear_4), [render-file\#4](#func_render-file_4), [render-csrf\#4](#func_render-csrf_4), [render-complex\#4](#func_render-complex_4), [render-grid\#5](#func_render-grid_5), [render-reference\#4](#func_render-reference_4), [render-query\#5](#func_render-query_5), [render-control\#5](#func_render-control_5), [name\#1](#func_name_1), [name\#0](#func_name_0), [method\#1](#func_method_1), [method\#0](#func_method_0), [action\#1](#func_action_1), [action\#0](#func_action_0), [target\#1](#func_target_1), [target\#0](#func_target_0), [accept-charset\#1](#func_accept-charset_1), [accept-charset\#0](#func_accept-charset_0), [accept\#1](#func_accept_1), [accept\#0](#func_accept_0), [enctype\#1](#func_enctype_1), [enctype\#0](#func_enctype_0), [add-custom\#3](#func_add-custom_3), [text\#2](#func_text_2), [textarea\#2](#func_textarea_2), [email\#2](#func_email_2), [money\#2](#func_money_2), [number\#2](#func_number_2), [password\#2](#func_password_2), [search\#2](#func_search_2), [url\#2](#func_url_2), [choice\#3](#func_choice_3), [entity\#3](#func_entity_3), [country\#2](#func_country_2), [locale\#2](#func_locale_2), [timezone\#2](#func_timezone_2), [language\#2](#func_language_2), [date\#2](#func_date_2), [dateTime\#2](#func_dateTime_2), [time\#2](#func_time_2), [birthday\#2](#func_birthday_2), [checkbox\#2](#func_checkbox_2), [radio\#2](#func_radio_2), [file\#2](#func_file_2), [collection\#2](#func_collection_2), [repeated\#2](#func_repeated_2), [hidden\#2](#func_hidden_2), [button\#2](#func_button_2), [submit\#2](#func_submit_2), [validation\#2](#func_validation_2), [csrf\#2](#func_csrf_2)


## Variables

### <a name="var__form-controls"/> $_form-controls
```xquery
$_form-controls as 
```

### <a name="var__form-options"/> $_form-options
```xquery
$_form-options as 
```

### <a name="var__form-bindings"/> $_form-bindings
```xquery
$_form-bindings as 
```

### <a name="var__control-options"/> $_control-options
```xquery
$_control-options as 
```

### <a name="var__request"/> $_request
```xquery
$_request as 
```

### <a name="var_FORM-INDEX-COUNT"/> $FORM-INDEX-COUNT
```xquery
$FORM-INDEX-COUNT as 
```

### <a name="var_FORM-INDEX"/> $FORM-INDEX
```xquery
$FORM-INDEX as 
```

### <a name="var_FORM-VALIDATIONS"/> $FORM-VALIDATIONS
```xquery
$FORM-VALIDATIONS as 
```

### <a name="var_CONTROL-OPTIONS"/> $CONTROL-OPTIONS
```xquery
$CONTROL-OPTIONS as 
```



## Functions

### <a name="func_ get-control-options_1"/>  get-control-options\#1
```xquery
 get-control-options($name
)
```

#### Params

* name as 


### <a name="func_ control-options_2"/>  control-options\#2
```xquery
 control-options($name,$options
)
```

#### Params

* name as 

* options as 


### <a name="func_ control-option_2"/>  control-option\#2
```xquery
 control-option($name,$type
)
```

#### Params

* name as 

* type as 


### <a name="func_ control-option_3"/>  control-option\#3
```xquery
 control-option($name,$type,$default
)
```

#### Params

* name as 

* type as 

* default as 


### <a name="func_ control-option_4"/>  control-option\#4
```xquery
 control-option($name,$type,$default,$values
)
```

#### Params

* name as 

* type as 

* default as 

* values as 


### <a name="func_bind_1"/> bind\#1
```xquery
bind($response
)
```

#### Params

* response as 


### <a name="func_flush_0"/> flush\#0
```xquery
flush(
)
```

### <a name="func_parse-options_1"/> parse-options\#1
```xquery
parse-options($options
)
```
  Form Options can be in the following form:  "option=value"   or chained together in a single value:  "option1=value;option2=value2;option3=value3"  the parsing will figure out what is what  It is not necessary to quote values as they will be quoted  automically unless you want in or around the content ~


#### Params

* options as 


### <a name="func_render-before_4"/> render-before\#4
```xquery
render-before($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-after_4"/> render-after\#4
```xquery
render-after($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-attributes_4"/> render-attributes\#4
```xquery
render-attributes($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-values_4"/> render-values\#4
```xquery
render-values($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-custom_4"/> render-custom\#4
```xquery
render-custom(
   $name as xs:string,
   $type as xs:string, 
   $value as xs:string*,
   $options
)
```

#### Params

* name as  xs:string

* type as  xs:string

* value as  xs:string\*

* options as 


### <a name="func_render-text_4"/> render-text\#4
```xquery
render-text($name,$type,$value,$options
)
```
  Function binds controls to their respective request data   from the request map; ~


#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-money_4"/> render-money\#4
```xquery
render-money($name,$type,$value,$options
)
```
  Renders a money field ~


#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-number_4"/> render-number\#4
```xquery
render-number($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-password_4"/> render-password\#4
```xquery
render-password($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-email_4"/> render-email\#4
```xquery
render-email($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-search_4"/> render-search\#4
```xquery
render-search($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-url_4"/> render-url\#4
```xquery
render-url($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-choice_4"/> render-choice\#4
```xquery
render-choice($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-entity_4"/> render-entity\#4
```xquery
render-entity($name,$type,$value,$options
)
```
  Render Entity  ~


#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-country_4"/> render-country\#4
```xquery
render-country($name,$type,$value,$options
)
```
  Render Countries ~


#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-locale_4"/> render-locale\#4
```xquery
render-locale($name,$type,$value,$options
)
```
  Renders Locales  ~


#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-timezone_4"/> render-timezone\#4
```xquery
render-timezone($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-date_4"/> render-date\#4
```xquery
render-date($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-dateTime_4"/> render-dateTime\#4
```xquery
render-dateTime($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-birthday_4"/> render-birthday\#4
```xquery
render-birthday($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-collection_4"/> render-collection\#4
```xquery
render-collection($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-repeated_4"/> render-repeated\#4
```xquery
render-repeated($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-hidden_4"/> render-hidden\#4
```xquery
render-hidden($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-button_4"/> render-button\#4
```xquery
render-button($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-submit_4"/> render-submit\#4
```xquery
render-submit($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-clear_4"/> render-clear\#4
```xquery
render-clear($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-file_4"/> render-file\#4
```xquery
render-file($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-csrf_4"/> render-csrf\#4
```xquery
render-csrf($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-complex_4"/> render-complex\#4
```xquery
render-complex($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-grid_5"/> render-grid\#5
```xquery
render-grid($name,$type,$value,$options,$ui
)
```

#### Params

* name as 

* type as 

* value as 

* options as 

* ui as 


### <a name="func_render-reference_4"/> render-reference\#4
```xquery
render-reference($name,$type,$value,$options
)
```

#### Params

* name as 

* type as 

* value as 

* options as 


### <a name="func_render-query_5"/> render-query\#5
```xquery
render-query($name,$type,$value,$options,$ui
)
```

#### Params

* name as 

* type as 

* value as 

* options as 

* ui as 


### <a name="func_render-control_5"/> render-control\#5
```xquery
render-control($name,$type,$value,$opts,$ui
)
```

#### Params

* name as 

* type as 

* value as 

* opts as 

* ui as 


### <a name="func_name_1"/> name\#1
```xquery
name($name
)
```

#### Params

* name as 


### <a name="func_name_0"/> name\#0
```xquery
name(
)
```

### <a name="func_method_1"/> method\#1
```xquery
method($method
)
```

#### Params

* method as 


### <a name="func_method_0"/> method\#0
```xquery
method(
)
```

### <a name="func_action_1"/> action\#1
```xquery
action($action
)
```

#### Params

* action as 


### <a name="func_action_0"/> action\#0
```xquery
action(
)
```

### <a name="func_target_1"/> target\#1
```xquery
target($target
)
```

#### Params

* target as 


### <a name="func_target_0"/> target\#0
```xquery
target(
)
```

### <a name="func_accept-charset_1"/> accept-charset\#1
```xquery
accept-charset($charset
)
```

#### Params

* charset as 


### <a name="func_accept-charset_0"/> accept-charset\#0
```xquery
accept-charset(
)
```

### <a name="func_accept_1"/> accept\#1
```xquery
accept($charset
)
```

#### Params

* charset as 


### <a name="func_accept_0"/> accept\#0
```xquery
accept(
)
```

### <a name="func_enctype_1"/> enctype\#1
```xquery
enctype($enctype
)
```

#### Params

* enctype as 


### <a name="func_enctype_0"/> enctype\#0
```xquery
enctype(
)
```

### <a name="func_add-custom_3"/> add-custom\#3
```xquery
add-custom($name,$type,$opts as xs:string*
)
```

#### Params

* name as 

* type as 

* opts as  xs:string\*


### <a name="func_text_2"/> text\#2
```xquery
text($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_textarea_2"/> textarea\#2
```xquery
textarea($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_email_2"/> email\#2
```xquery
email($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_money_2"/> money\#2
```xquery
money($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_number_2"/> number\#2
```xquery
number($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_password_2"/> password\#2
```xquery
password($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_search_2"/> search\#2
```xquery
search($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_url_2"/> url\#2
```xquery
url($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_choice_3"/> choice\#3
```xquery
choice($name,$options as xs:string*,$choices as item()*
)
```

#### Params

* name as 

* options as  xs:string\*

* choices as  item()\*


### <a name="func_entity_3"/> entity\#3
```xquery
entity($name,$options as xs:string*,$choices as item()*
)
```

#### Params

* name as 

* options as  xs:string\*

* choices as  item()\*


### <a name="func_country_2"/> country\#2
```xquery
country($name,$options as  xs:string*
)
```

#### Params

* name as 

* options as   xs:string\*


### <a name="func_locale_2"/> locale\#2
```xquery
locale($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_timezone_2"/> timezone\#2
```xquery
timezone($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_language_2"/> language\#2
```xquery
language($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_date_2"/> date\#2
```xquery
date($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_dateTime_2"/> dateTime\#2
```xquery
dateTime($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_time_2"/> time\#2
```xquery
time($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_birthday_2"/> birthday\#2
```xquery
birthday($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_checkbox_2"/> checkbox\#2
```xquery
checkbox($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_radio_2"/> radio\#2
```xquery
radio($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_file_2"/> file\#2
```xquery
file($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_collection_2"/> collection\#2
```xquery
collection($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_repeated_2"/> repeated\#2
```xquery
repeated($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_hidden_2"/> hidden\#2
```xquery
hidden($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_button_2"/> button\#2
```xquery
button($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_submit_2"/> submit\#2
```xquery
submit($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_validation_2"/> validation\#2
```xquery
validation($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*


### <a name="func_csrf_2"/> csrf\#2
```xquery
csrf($name,$options as xs:string*
)
```

#### Params

* name as 

* options as  xs:string\*






*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
