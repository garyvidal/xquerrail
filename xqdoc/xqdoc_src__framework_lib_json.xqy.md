# library module: JSON
  The parser that was generated for the JSON grammar. 



## Table of Contents

* Variables: [$MAP0](#var_MAP0), [$MAP1](#var_MAP1), [$MAP2](#var_MAP2), [$INITIAL](#var_INITIAL), [$TRANSITION](#var_TRANSITION), [$EXPECTED](#var_EXPECTED), [$TOKEN](#var_TOKEN), [$lk](#var_lk), [$b0](#var_b0), [$e0](#var_e0), [$l1](#var_l1), [$b1](#var_b1), [$e1](#var_e1), [$error](#var_error), [$result](#var_result)
* Functions: [match\#3](#func_match_3), [transition\#7](#func_transition_7), [token\#3](#func_token_3), [expected-token-set\#1](#func_expected-token-set_1), [map2\#3](#func_map2_3), [error-message\#2](#func_error-message_2), [shift\#3](#func_shift_3), [matchW\#3](#func_matchW_3), [lookahead1W\#3](#func_lookahead1W_3), [lookahead1\#3](#func_lookahead1_3), [reduce\#3](#func_reduce_3), [parse-array-1\#2](#func_parse-array-1_2), [parse-array\#2](#func_parse-array_2), [parse-pair\#2](#func_parse-pair_2), [parse-object-1\#2](#func_parse-object-1_2), [parse-object\#2](#func_parse-object_2), [parse-value\#2](#func_parse-value_2), [parse-json\#2](#func_parse-json_2), [parse-json\#1](#func_parse-json_1), [_parse\#1](#func__parse_1), [clean\#1](#func_clean_1), [parse\#1](#func_parse_1)


## Variables

### <a name="var_MAP0"/> $MAP0
```xquery
$MAP0 as  xs:integer+
```
  The codepoint to charclass mapping for 7 bit codepoints. 


### <a name="var_MAP1"/> $MAP1
```xquery
$MAP1 as  xs:integer+
```
  The codepoint to charclass mapping for codepoints below the surrogate block. 


### <a name="var_MAP2"/> $MAP2
```xquery
$MAP2 as  xs:integer+
```
  The codepoint to charclass mapping for codepoints above the surrogate block. 


### <a name="var_INITIAL"/> $INITIAL
```xquery
$INITIAL as  xs:integer+
```
  The token-set-id to DFA-initial-state mapping. 


### <a name="var_TRANSITION"/> $TRANSITION
```xquery
$TRANSITION as  xs:integer+
```
  The DFA transition table. 


### <a name="var_EXPECTED"/> $EXPECTED
```xquery
$EXPECTED as  xs:integer+
```
  The DFA-state to expected-token-set mapping. 


### <a name="var_TOKEN"/> $TOKEN
```xquery
$TOKEN as  xs:string+
```
  The token-string table. 


### <a name="var_lk"/> $lk
```xquery
$lk as 
```
  The index of the parser state for accessing the combined  (i.e. level > 1) lookahead code. 


### <a name="var_b0"/> $b0
```xquery
$b0 as 
```
  The index of the parser state for accessing the position in the  input string of the begin of the token that has been shifted. 


### <a name="var_e0"/> $e0
```xquery
$e0 as 
```
  The index of the parser state for accessing the position in the  input string of the end of the token that has been shifted. 


### <a name="var_l1"/> $l1
```xquery
$l1 as 
```
  The index of the parser state for accessing the code of the  level-1-lookahead token. 


### <a name="var_b1"/> $b1
```xquery
$b1 as 
```
  The index of the parser state for accessing the position in the  input string of the begin of the level-1-lookahead token. 


### <a name="var_e1"/> $e1
```xquery
$e1 as 
```
  The index of the parser state for accessing the position in the  input string of the end of the level-1-lookahead token. 


### <a name="var_error"/> $error
```xquery
$error as 
```
  The index of the parser state for accessing the token code that  was expected when an error was found. 


### <a name="var_result"/> $result
```xquery
$result as 
```
  The index of the parser state that points to the first entry  used for collecting action results. 




## Functions

### <a name="func_match_3"/> match\#3
```xquery
match($input as xs:string,
                         $begin as xs:integer,
                         $token-set as xs:integer
) as  xs:integer+
```
  Match next token in input string, starting at given index, using  the DFA entry state for the set of tokens that are expected in  the current context.   


#### Params

* input as  xs:string the input string.

* begin as  xs:integer the index where to start in input string.

* token-set as  xs:integer the expected token set id.


#### Returns
*  xs:integer+: a sequence of three: the token code of the result token, with input string begin and end positions. If there is no valid token, return the negative id of the DFA state that failed, along with begin and end positions of the longest viable prefix.

### <a name="func_transition_7"/> transition\#7
```xquery
transition($input as xs:string,
                              $begin as xs:integer,
                              $current as xs:integer,
                              $end as xs:integer,
                              $result as xs:integer,
                              $current-state as xs:integer,
                              $previous-state as xs:integer
) as  xs:integer+
```
  The DFA state transition function. If we are in a valid DFA state, save  it's result annotation, consume one input codepoint, calculate the next  state, and use tail recursion to do the same again. Otherwise, return  any valid result or a negative DFA state id in case of an error.   


#### Params

* input as  xs:string the input string.

* begin as  xs:integer the begin index of the current token in the input string.

* current as  xs:integer the index of the current position in the input string.-state the current DFA state.

* end as  xs:integer the end index of the result in the input string.

* result as  xs:integer the result code.

* current-state as  xs:integer the current DFA state.

* previous-state as  xs:integer the previous DFA state.


#### Returns
*  xs:integer+: a sequence of three: the token code of the result token, with input string begin and end positions. If there is no valid token, return the negative id of the DFA state that failed, along with begin and end positions of the longest viable prefix.

### <a name="func_token_3"/> token\#3
```xquery
token($result as xs:string*,
                         $chunk as xs:integer,
                         $base-token-code as xs:integer
) as  xs:string*
```
  Recursively translate one 32-bit chunk of an expected token bitset  to the corresponding sequence of token strings.   


#### Params

* result as  xs:string\* the result of previous recursion levels.

* chunk as  xs:integer the 32-bit chunk of the expected token bitset.

* base-token-code as  xs:integer the token code of bit 0 in the current chunk.


#### Returns
*  xs:string\*: the set of token strings.

### <a name="func_expected-token-set_1"/> expected-token-set\#1
```xquery
expected-token-set($state as xs:integer
) as  xs:string*
```
  Calculate expected token set for a given DFA state as a sequence  of strings.   


#### Params

* state as  xs:integer the DFA state.


#### Returns
*  xs:string\*: the set of token strings

### <a name="func_map2_3"/> map2\#3
```xquery
map2($c as xs:integer, $lo as xs:integer, $hi as xs:integer
) as  xs:integer
```
  Classify codepoint by doing a tail recursive binary search for a  matching codepoint range entry in MAP2, the codepoint to charclass  map for codepoints above the surrogate block.   


#### Params

* c as  xs:integer the codepoint.

* lo as  xs:integer the binary search lower bound map index.

* hi as  xs:integer the binary search upper bound map index.


#### Returns
*  xs:integer: the character class.

### <a name="func_error-message_2"/> error-message\#2
```xquery
error-message($input as xs:string, $error as element(error)
) as  xs:string
```
  Create a textual error message from a parsing error.   


#### Params

* input as  xs:string the input string.

* error as  element(error) the parsing error descriptor.


#### Returns
*  xs:string: the error message.

### <a name="func_shift_3"/> shift\#3
```xquery
shift($code as xs:integer, $input as xs:string, $state as item()+
) as  item()+
```
  Shift one token, i.e. compare lookahead token 1 with expected  token and in case of a match, shift lookahead tokens down such that  l1 becomes the current token, and higher lookahead tokens move down.  When lookahead token 1 does not match the expected token, raise an  error by saving the expected token code in the error field of the  parser state.   


#### Params

* code as  xs:integer the expected token.

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_matchW_3"/> matchW\#3
```xquery
matchW($input as xs:string,
                          $begin as xs:integer,
                          $token-set as xs:integer
) as  xs:integer+
```
  Use p:match to fetch the next token, but skip any leading  whitespace.   


#### Params

* input as  xs:string the input string.

* begin as  xs:integer the index where to start.

* token-set as  xs:integer the valid token set id.


#### Returns
*  xs:integer+: a sequence of three values: the token code of the result token, with input string positions of token begin and end.

### <a name="func_lookahead1W_3"/> lookahead1W\#3
```xquery
lookahead1W($set as xs:integer, $input as xs:string, $state as item()+
) as  item()+
```
  Lookahead one token on level 1 with whitespace skipping.   


#### Params

* set as  xs:integer the code of the DFA entry state for the set of valid tokens.

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_lookahead1_3"/> lookahead1\#3
```xquery
lookahead1($set as xs:integer, $input as xs:string, $state as item()+
) as  item()+
```
  Lookahead one token on level 1.   


#### Params

* set as  xs:integer the code of the DFA entry state for the set of valid tokens.

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_reduce_3"/> reduce\#3
```xquery
reduce($state as item()+, $name as xs:string, $count as xs:integer
) as  item()+
```
  Reduce the result stack. Pop $count element, wrap them in a  new element named $name, and push the new element.   


#### Params

* state as  item()+ the parser state.

* name as  xs:string the name of the result node.

* count as  xs:integer the number of child nodes.


#### Returns
*  item()+: the updated parser state.

### <a name="func_parse-array-1_2"/> parse-array-1\#2
```xquery
parse-array-1($input as xs:string, $state as item()+
) as  item()+
```
  Parse the 1st loop of production array (zero or more). Use  tail recursion for iteratively updating the parser state.   


#### Params

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_parse-array_2"/> parse-array\#2
```xquery
parse-array($input as xs:string, $state as item()+
) as  item()+
```
  Parse array.   


#### Params

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_parse-pair_2"/> parse-pair\#2
```xquery
parse-pair($input as xs:string, $state as item()+
) as  item()+
```
  Parse pair.   


#### Params

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_parse-object-1_2"/> parse-object-1\#2
```xquery
parse-object-1($input as xs:string, $state as item()+
) as  item()+
```
  Parse the 1st loop of production object (zero or more). Use  tail recursion for iteratively updating the parser state.   


#### Params

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_parse-object_2"/> parse-object\#2
```xquery
parse-object($input as xs:string, $state as item()+
) as  item()+
```
  Parse object.   


#### Params

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_parse-value_2"/> parse-value\#2
```xquery
parse-value($input as xs:string, $state as item()+
) as  item()+
```
  Parse value.   


#### Params

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_parse-json_2"/> parse-json\#2
```xquery
parse-json($input as xs:string, $state as item()+
) as  item()+
```
  Parse json.   


#### Params

* input as  xs:string the input string.

* state as  item()+ the parser state.


#### Returns
*  item()+: the updated parser state.

### <a name="func_parse-json_1"/> parse-json\#1
```xquery
parse-json($s as xs:string
) as  item()*
```
  Parse start symbol json from given string.   


#### Params

* s as  xs:string the string to be parsed.


#### Returns
*  item()\*: the result as generated by parser actions.

### <a name="func__parse_1"/> _parse\#1
```xquery
_parse($node as node()
)
```
  Recursively converts Parse Tree into XML representation of json object  ~


#### Params

* node as  node()


### <a name="func_clean_1"/> clean\#1
```xquery
clean($string
)
```

#### Params

* string as 


### <a name="func_parse_1"/> parse\#1
```xquery
parse($input as xs:string
)
```
  Converts JSON to XML ~


#### Params

* input as  xs:string






*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
