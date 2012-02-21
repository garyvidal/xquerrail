# library module: http://www.xquerrail-framework.com/request
  This request controls all serialization of request map   - All HTTP request elements in a single map:map type. ~



## Table of Contents

* Variables: [$BODY](#var_BODY), [$BODY-XML](#var_BODY-XML), [$BODY-TEXT](#var_BODY-TEXT), [$BODY-BINARY](#var_BODY-BINARY), [$METHOD](#var_METHOD), [$CONTENT-TYPE](#var_CONTENT-TYPE), [$BODY-TYPE](#var_BODY-TYPE), [$PROTOCOL](#var_PROTOCOL), [$USERNAME](#var_USERNAME), [$USERID](#var_USERID), [$PATH](#var_PATH), [$URL](#var_URL), [$CONTEXT](#var_CONTEXT), [$APPLICATION](#var_APPLICATION), [$CONTROLLER](#var_CONTROLLER), [$ACTION](#var_ACTION), [$FORMAT](#var_FORMAT), [$ROUTE](#var_ROUTE), [$VIEW](#var_VIEW), [$PARTIAL](#var_PARTIAL), [$HEADER-PREFIX](#var_HEADER-PREFIX), [$PARAM-PREFIX](#var_PARAM-PREFIX), [$PARAM-CONTENT-TYPE-PREFIX](#var_PARAM-CONTENT-TYPE-PREFIX), [$PARAM-FILENAME-PREFIX](#var_PARAM-FILENAME-PREFIX)
* Functions: [hex-decode\#1](#func_hex-decode_1), [hex-decode\#2](#func_hex-decode_2), [request\#0](#func_request_0), [initialize\#1](#func_initialize_1), [parse\#1](#func_parse_1), [application\#0](#func_application_0), [controller\#0](#func_controller_0), [action\#0](#func_action_0), [format\#0](#func_format_0), [route\#0](#func_route_0), [view\#0](#func_view_0), [method\#0](#func_method_0), [path\#0](#func_path_0), [protocol\#0](#func_protocol_0), [body\#0](#func_body_0), [body-type\#0](#func_body-type_0), [partial\#0](#func_partial_0), [params\#0](#func_params_0), [param-names\#0](#func_param-names_0), [param\#1](#func_param_1), [param\#2](#func_param_2), [param-as\#3](#func_param-as_3), [params-as-map\#0](#func_params-as-map_0), [param-filename\#1](#func_param-filename_1), [param-content-type\#2](#func_param-content-type_2), [get-headers\#0](#func_get-headers_0), [get-header\#1](#func_get-header_1), [get-header\#2](#func_get-header_2), [locale\#0](#func_locale_0), [content-length\#0](#func_content-length_0), [user-agent\#0](#func_user-agent_0), [referer\#0](#func_referer_0), [encoding\#0](#func_encoding_0), [connection\#0](#func_connection_0), [authorization\#0](#func_authorization_0), [cookies\#0](#func_cookies_0), [cookie\#1](#func_cookie_1), [build-query\#1](#func_build-query_1), [parse-query\#0](#func_parse-query_0)


## Variables

### <a name="var_BODY"/> $BODY
```xquery
$BODY as 
```

### <a name="var_BODY-XML"/> $BODY-XML
```xquery
$BODY-XML as 
```

### <a name="var_BODY-TEXT"/> $BODY-TEXT
```xquery
$BODY-TEXT as 
```

### <a name="var_BODY-BINARY"/> $BODY-BINARY
```xquery
$BODY-BINARY as 
```

### <a name="var_METHOD"/> $METHOD
```xquery
$METHOD as 
```

### <a name="var_CONTENT-TYPE"/> $CONTENT-TYPE
```xquery
$CONTENT-TYPE as 
```

### <a name="var_BODY-TYPE"/> $BODY-TYPE
```xquery
$BODY-TYPE as 
```

### <a name="var_PROTOCOL"/> $PROTOCOL
```xquery
$PROTOCOL as 
```

### <a name="var_USERNAME"/> $USERNAME
```xquery
$USERNAME as 
```

### <a name="var_USERID"/> $USERID
```xquery
$USERID as 
```

### <a name="var_PATH"/> $PATH
```xquery
$PATH as 
```

### <a name="var_URL"/> $URL
```xquery
$URL as 
```

### <a name="var_CONTEXT"/> $CONTEXT
```xquery
$CONTEXT as 
```

### <a name="var_APPLICATION"/> $APPLICATION
```xquery
$APPLICATION as 
```

### <a name="var_CONTROLLER"/> $CONTROLLER
```xquery
$CONTROLLER as 
```

### <a name="var_ACTION"/> $ACTION
```xquery
$ACTION as 
```

### <a name="var_FORMAT"/> $FORMAT
```xquery
$FORMAT as 
```

### <a name="var_ROUTE"/> $ROUTE
```xquery
$ROUTE as 
```

### <a name="var_VIEW"/> $VIEW
```xquery
$VIEW as 
```

### <a name="var_PARTIAL"/> $PARTIAL
```xquery
$PARTIAL as 
```

### <a name="var_HEADER-PREFIX"/> $HEADER-PREFIX
```xquery
$HEADER-PREFIX as 
```

### <a name="var_PARAM-PREFIX"/> $PARAM-PREFIX
```xquery
$PARAM-PREFIX as 
```

### <a name="var_PARAM-CONTENT-TYPE-PREFIX"/> $PARAM-CONTENT-TYPE-PREFIX
```xquery
$PARAM-CONTENT-TYPE-PREFIX as 
```

### <a name="var_PARAM-FILENAME-PREFIX"/> $PARAM-FILENAME-PREFIX
```xquery
$PARAM-FILENAME-PREFIX as 
```



## Functions

### <a name="func_hex-decode_1"/> hex-decode\#1
```xquery
hex-decode($hexBin as xs:hexBinary
) as  xs:string
```
  Decodes a binary request into s string ~


#### Params

* hexBin as  xs:hexBinary


#### Returns
*  xs:string

### <a name="func_hex-decode_2"/> hex-decode\#2
```xquery
hex-decode($hexBin as xs:hexBinary, $length as xs:integer
) as  xs:string
```

#### Params

* hexBin as  xs:hexBinary

* length as  xs:integer


#### Returns
*  xs:string

### <a name="func_request_0"/> request\#0
```xquery
request(
)
```
  Returns the map:map of the request ~


### <a name="func_initialize_1"/> initialize\#1
```xquery
initialize($_request
)
```
   Wraps the http response into a map:map   Accessing the map can be used the following keys   map:get($response, "field:xxx")   Accessors:       request:header::xxxx       request:field::xxxx       request:body ~


#### Params

* _request as 


### <a name="func_parse_1"/> parse\#1
```xquery
parse($parameters
) as  map:map
```
   Parses the map pulling all the required information from http request  ~


#### Params

* parameters as 


#### Returns
*  map:map

### <a name="func_application_0"/> application\#0
```xquery
application(
)
```
  Get the application from the request ~


### <a name="func_controller_0"/> controller\#0
```xquery
controller(
)
```
   Gets the controller from the request ~


### <a name="func_action_0"/> action\#0
```xquery
action(
)
```
   Gets that action Parameters of the request ~


### <a name="func_format_0"/> format\#0
```xquery
format(
)
```
  Selects the file format of the requestt ~


### <a name="func_route_0"/> route\#0
```xquery
route(
)
```
  Gets the route selected for the request ~


### <a name="func_view_0"/> view\#0
```xquery
view(
)
```
  Gets the view selected for the request ~


### <a name="func_method_0"/> method\#0
```xquery
method(
)
```
  Returns the method for a given request  the method returns the http verb such as POST,GET,DELETE  etc. ~


### <a name="func_path_0"/> path\#0
```xquery
path(
)
```
   Get the original Path of the request ~


### <a name="func_protocol_0"/> protocol\#0
```xquery
protocol(
)
```
   Get the protocal of the request ~


### <a name="func_body_0"/> body\#0
```xquery
body(
)
```
  Returns the body element of an http:request. Use the request:body-type()   function to determine the underlying datatype ~


### <a name="func_body-type_0"/> body-type\#0
```xquery
body-type(
)
```
   Returns the body type of the given request such as (xml, binary, text)  ~


### <a name="func_partial_0"/> partial\#0
```xquery
partial(
)
```
  Returns if a request is a partial request common in ajax calls ~


### <a name="func_params_0"/> params\#0
```xquery
params(
) as  map:map
```
   Returns the list of parameters of just parameters in a map ~


#### Returns
*  map:map

### <a name="func_param-names_0"/> param-names\#0
```xquery
param-names(
)
```
  Returns a list parameter names from request as sequence of string values ~


### <a name="func_param_1"/> param\#1
```xquery
param($name as xs:string
)
```
   Gets a parameter value by name ~


#### Params

* name as  xs:string


### <a name="func_param_2"/> param\#2
```xquery
param($name as xs:string,$default as item()*
)
```
  Retrieves a field if it is available and returns.  If field does not exist returns default. ~


#### Params

* name as  xs:string

* default as  item()\*


### <a name="func_param-as_3"/> param-as\#3
```xquery
param-as(
    $name as xs:string,
    $type as xs:string,
    $default as item()
) as  item()*
```
  Returns a parameter casted as the type you specify.  Use the generic type of the asset to resolve as the underlying type ~


#### Params

* name as  xs:string

* type as  xs:string

* default as  item()


#### Returns
*  item()\*

### <a name="func_params-as-map_0"/> params-as-map\#0
```xquery
params-as-map(
)
```
   Returns the parameters of the request as a map ~


### <a name="func_param-filename_1"/> param-filename\#1
```xquery
param-filename($name as xs:string
)
```
   Returns the filename for the param ~


#### Params

* name as  xs:string


### <a name="func_param-content-type_2"/> param-content-type\#2
```xquery
param-content-type(
$request as map:map,
$field as xs:string
)
```
   Returns the associated content-type for the given param   In cases where the request has multipart/mime data on the form   you can extract the type based request from client ~


#### Params

* request as  map:map

* field as  xs:string


### <a name="func_get-headers_0"/> get-headers\#0
```xquery
get-headers(
)
```
  Gets a all response header object ~


### <a name="func_get-header_1"/> get-header\#1
```xquery
get-header($name as xs:string
)
```
  Gets a specific header parameter by name    


#### Params

* name as  xs:string - Name of the header parameter (ie. Content-Length) ~


### <a name="func_get-header_2"/> get-header\#2
```xquery
get-header($name as xs:string,$default as xs:anyAtomicType
)
```
   Gets a specific header parameter by name and its default value if not present   


#### Params

* name as  xs:string - Name of the header parameter (ie. Content-Length)

* default as  xs:anyAtomicType


### <a name="func_locale_0"/> locale\#0
```xquery
locale(
)
```
  Returns the given Accept-Language from the HTTP request ~


### <a name="func_content-length_0"/> content-length\#0
```xquery
content-length(
)
```
  Returns the Content-Length header param ~


### <a name="func_user-agent_0"/> user-agent\#0
```xquery
user-agent(
)
```
  Returns the User-Agent header from a given request ~


### <a name="func_referer_0"/> referer\#0
```xquery
referer(
)
```
  Returns the Referer header from a given request ~


### <a name="func_encoding_0"/> encoding\#0
```xquery
encoding(
)
```
  Returns the Accept-Encoding header from a given request ~


### <a name="func_connection_0"/> connection\#0
```xquery
connection(
)
```
  Returns the Connection header from a given request ~


### <a name="func_authorization_0"/> authorization\#0
```xquery
authorization(
)
```
  Returns the Authorization Header from the request ~


### <a name="func_cookies_0"/> cookies\#0
```xquery
cookies(
)
```
  Returns the Cookies from the request ~


### <a name="func_cookie_1"/> cookie\#1
```xquery
cookie($name
)
```
  Returns the Cookies by name from the request  


#### Params

* name as  - name of cookie ~


### <a name="func_build-query_1"/> build-query\#1
```xquery
build-query($params
)
```
   Using JQGrid you can parse a query from field using simple language, parses from JSON into CTS Query ~


#### Params

* params as 


### <a name="func_parse-query_0"/> parse-query\#0
```xquery
parse-query(
)
```
  Returns the parse Query from JQGrid  ~






*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
