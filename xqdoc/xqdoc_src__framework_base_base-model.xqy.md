# library module: http://www.xquerrail-framework.com/model/base
  Model : Base  


Author:    
Version:     ~

## Table of Contents

* Variables: [$collation](#var_collation)
* Functions: [create-id\#0](#func_create-id_0), [get-root-node\#1](#func_get-root-node_1), [get-id-from-params\#2](#func_get-id-from-params_2), [create\#2](#func_create_2), [get\#2](#func_get_2), [update\#2](#func_update_2), [delete\#2](#func_delete_2), [lookup\#2](#func_lookup_2), [list\#2](#func_list_2), [build-search-options\#1](#func_build-search-options_1), [search\#2](#func_search_2), [reference\#2](#func_reference_2), [get-references\#2](#func_get-references_2), [validate\#2](#func_validate_2), [put\#2](#func_put_2), [post\#2](#func_post_2)


## Variables

### <a name="var_collation"/> $collation
```xquery
$collation as 
```



## Functions

### <a name="func_create-id_0"/> create-id\#0
```xquery
create-id(
) as  xs:string
```
  Generate a random id   


#### Returns
*  xs:string: a random string

### <a name="func_get-root-node_1"/> get-root-node\#1
```xquery
get-root-node($doc as node()
) as  node()
```
  returns the root element of a given node ~


#### Params

* doc as  node()


#### Returns
*  node()

### <a name="func_get-id-from-params_2"/> get-id-from-params\#2
```xquery
get-id-from-params($domain-model as element(domain:model), $params as map:map
) as  xs:string?
```
  Gets the idfield from a given param or UUID as default ~


#### Params

* domain-model as  element(domain:model)

* params as  map:map


#### Returns
*  xs:string?

### <a name="func_create_2"/> create\#2
```xquery
create($domain-model as element(domain:model), $params as map:map
) as  element()?
```
  Create packageType  


#### Params

* domain-model as  element(domain:model) the model of the document

* params as  map:map the values to fill into the element


#### Returns
*  element()?

### <a name="func_get_2"/> get\#2
```xquery
get($domain-model as element(domain:model), $params as map:map
) as  element()?
```
  Retrieves a model document by id  


#### Params

* domain-model as  element(domain:model) the model of the document

* params as  map:map the values to pull the id from


#### Returns
*  element()?: the document ~

### <a name="func_update_2"/> update\#2
```xquery
update($domain-model as element(domain:model), $params as map:map
) as  element()?
```
  Update Operation packageType  


#### Params

* domain-model as  element(domain:model) the model of the document

* params as  map:map the values to fill into the element


#### Returns
*  element()?

### <a name="func_delete_2"/> delete\#2
```xquery
delete($domain-model as element(domain:model),$params as map:map
) as  xs:boolean
```
  Deletes the model document  


#### Params

* domain-model as  element(domain:model) the model of the document

* params as  map:map the values to fill into the element


#### Returns
*  xs:boolean: xs:boolean denoted whether delete occurred

### <a name="func_lookup_2"/> lookup\#2
```xquery
lookup($domain-model as element(domain:model), $params as map:map
)
```
  Returns a key value pair of lookup values for use in populating comboboxes from a model  You must define your key/keyLabel attributes on the model for this to work. ~


#### Params

* domain-model as  element(domain:model)

* params as  map:map


### <a name="func_list_2"/> list\#2
```xquery
list($domain-model as element(domain:model), $params as map:map
) as  element(list)?
```
  Returns a list of model instances  


#### Params

* domain-model as  element(domain:model)

* params as  map:map


#### Returns
*  element(list)?: element({model})\*

### <a name="func_build-search-options_1"/> build-search-options\#1
```xquery
build-search-options($domain-model as element(domain:model)
) as  element(search:options)
```
  Build search options for a given domain model  


#### Params

* domain-model as  element(domain:model) the model of the content type


#### Returns
*  element(search:options): search options for the given model

### <a name="func_search_2"/> search\#2
```xquery
search($domain-model as element(domain:model), $params as map:map
) as  element(search:response)
```
  Provide search interface for the model  


#### Params

* domain-model as  element(domain:model) the model of the content type

* params as  map:map the values to fill into the search


#### Returns
*  element(search:response): search response element ~

### <a name="func_reference_2"/> reference\#2
```xquery
reference($domain-model as element(domain:model), $params as map:map
) as  element()?
```
   This function will create a sequence of nodes that represent each  model for inlining in other references.   


#### Params

* domain-model as  element(domain:model)

* params as  map:map


#### Returns
*  element()?: a sequence of packageType

### <a name="func_get-references_2"/> get-references\#2
```xquery
get-references($reference as element(domain:element), $params as map:map
) as  element()*
```
  This function will call the appropriate reference type model to build   a relationship between two models types.  


#### Params

* reference as  element(domain:element) is the reference element that is used to contain the references

* params as  map:map the params items to build the relationship


#### Returns
*  element()\*

### <a name="func_validate_2"/> validate\#2
```xquery
validate($domain-model as element(domain:model), $params as map:map
) as  element(validationError)*
```
   This is a function that will validate the params with the domain model  


#### Params

* domain-model as  element(domain:model) the model to validate against

* params as  map:map the params to validate


#### Returns
*  element(validationError)\*: return a set of validation errors if any occur.

### <a name="func_put_2"/> put\#2
```xquery
put($domain-model as element(domain:model), $body as node()
)
```
  Provides the ability to put a new document in the database. ~


#### Params

* domain-model as  element(domain:model)

* body as  node()


### <a name="func_post_2"/> post\#2
```xquery
post($domain-model as element(domain:model), $body as node()
)
```
  Provides the ability to post an update to an existing model in the database ~


#### Params

* domain-model as  element(domain:model)

* body as  node()






*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
