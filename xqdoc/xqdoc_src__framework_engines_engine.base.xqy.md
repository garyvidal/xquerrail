# library module: http://www.xquerrail-framework.com/engine
  Performs core engine for transformation and base implementation for   different format engines ~



## Table of Contents

* Variables: [$engine-transformer](#var_engine-transformer), [$visitor](#var_visitor), [$_child-engine-tags](#var__child-engine-tags), [$_helpers](#var__helpers), [$_for_vars](#var__for_vars)
* Functions: [set-engine-transformer\#1](#func_set-engine-transformer_1), [register-tags\#1](#func_register-tags_1), [tag-is-registered\#1](#func_tag-is-registered_1), [consume\#1](#func_consume_1), [visit\#1](#func_visit_1), [visited\#1](#func_visited_1), [transform-if\#1](#func_transform-if_1), [process-for-this\#2](#func_process-for-this_2), [process-for-context\#2](#func_process-for-context_2), [transform-for\#1](#func_transform-for_1), [transform-has_slot\#1](#func_transform-has_slot_1), [transform-slot\#1](#func_transform-slot_1), [template-uri\#1](#func_template-uri_1), [view-exists\#1](#func_view-exists_1), [view-uri\#2](#func_view-uri_2), [render-template\#1](#func_render-template_1), [render-partial\#1](#func_render-partial_1), [render-view\#0](#func_render-view_0), [transform-template\#1](#func_transform-template_1), [transform-view\#1](#func_transform-view_1), [transform-dynamic\#1](#func_transform-dynamic_1), [transform\#1](#func_transform_1)


## Variables

### <a name="var_engine-transformer"/> $engine-transformer
```xquery
$engine-transformer as  xdmp:function?
```

### <a name="var_visitor"/> $visitor
```xquery
$visitor as 
```

### <a name="var__child-engine-tags"/> $_child-engine-tags
```xquery
$_child-engine-tags as 
```

### <a name="var__helpers"/> $_helpers
```xquery
$_helpers as 
```

### <a name="var__for_vars"/> $_for_vars
```xquery
$_for_vars as 
```
  The for iterator requires a global stack 




## Functions

### <a name="func_set-engine-transformer_1"/> set-engine-transformer\#1
```xquery
set-engine-transformer($func as xdmp:function
)
```
  To allow your engine to route transform calls from base  You must register your engines transformer function in  order for the base engine to route any functions you will handle ~


#### Params

* func as  xdmp:function


### <a name="func_register-tags_1"/> register-tags\#1
```xquery
register-tags($tagnames as xs:QName*
)
```
  Register any custom tags you will be overriding from custom engine ~


#### Params

* tagnames as  xs:QName\*


### <a name="func_tag-is-registered_1"/> tag-is-registered\#1
```xquery
tag-is-registered(
  $tag as xs:string
)
```
  Check to see if a tag has been registered with the engine ~


#### Params

* tag as  xs:string


### <a name="func_consume_1"/> consume\#1
```xquery
consume($node
)
```
  Marks that a node has been visited during transformation  When building custom tag that requires a closing tag   ensure that you consume the results you process or you  will find duplicate or spurious output results  ~


#### Params

* node as 


### <a name="func_visit_1"/> visit\#1
```xquery
visit($node
)
```

#### Params

* node as 


### <a name="func_visited_1"/> visited\#1
```xquery
visited($node
)
```
   Returns boolean value of whether a node has been visited. ~


#### Params

* node as 


### <a name="func_transform-if_1"/> transform-if\#1
```xquery
transform-if($node as node()
)
```
  Transforms an if tag for processing ~


#### Params

* node as  node()


### <a name="func_process-for-this_2"/> process-for-this\#2
```xquery
process-for-this(
   $this-tag as processing-instruction("this"),
   $this
)
```
  The for tag must handle its one process  and return the context to the user ~


#### Params

* this-tag as  processing-instruction("this")

* this as 


### <a name="func_process-for-context_2"/> process-for-context\#2
```xquery
process-for-context($nodes,$context
)
```
  The for tag must handle its one process  and return the context to the user ~


#### Params

* nodes as 

* context as 


### <a name="func_transform-for_1"/> transform-for\#1
```xquery
transform-for(
   $for-tag as processing-instruction("for")
)
```

#### Params

* for-tag as  processing-instruction("for")


### <a name="func_transform-has_slot_1"/> transform-has_slot\#1
```xquery
transform-has_slot($node as node()
)
```

#### Params

* node as  node()


### <a name="func_transform-slot_1"/> transform-slot\#1
```xquery
transform-slot($node as node()
)
```

#### Params

* node as  node()


### <a name="func_template-uri_1"/> template-uri\#1
```xquery
template-uri($name
)
```

#### Params

* name as 


### <a name="func_view-exists_1"/> view-exists\#1
```xquery
view-exists($view-uri as xs:string
) as  xs:boolean
```

#### Params

* view-uri as  xs:string


#### Returns
*  xs:boolean

### <a name="func_view-uri_2"/> view-uri\#2
```xquery
view-uri($controller,$action
)
```

#### Params

* controller as 

* action as 


### <a name="func_render-template_1"/> render-template\#1
```xquery
render-template($response
)
```

#### Params

* response as 


### <a name="func_render-partial_1"/> render-partial\#1
```xquery
render-partial($response
)
```
  Partial rendering intercepts a call and routes only the view, even if a template is defined.  This is to support ajax type calls for rendering views in a frame or container ~


#### Params

* response as 


### <a name="func_render-view_0"/> render-view\#0
```xquery
render-view(
)
```

### <a name="func_transform-template_1"/> transform-template\#1
```xquery
transform-template($node
)
```

#### Params

* node as 


### <a name="func_transform-view_1"/> transform-view\#1
```xquery
transform-view($node
)
```

#### Params

* node as 


### <a name="func_transform-dynamic_1"/> transform-dynamic\#1
```xquery
transform-dynamic($node as node()
)
```

#### Params

* node as  node()


### <a name="func_transform_1"/> transform\#1
```xquery
transform($node as item()
)
```

#### Params

* node as  item()






*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
