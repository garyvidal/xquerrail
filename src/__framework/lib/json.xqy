xquery version "1.0" encoding "UTF-8";

(: This file was generated on Fri Dec  9, 2011 16:55 by REx v5.10 which is Copyright (c) 1979-2011 by Gunther Rademacher <grd@gmx.net> :)
(: REx command line: JSON.ebnf -xquery -tree :)

(:~
 : The parser that was generated for the JSON grammar.
 :)
module namespace p="JSON";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare namespace xdmp = "http://marklogic.com/xdmp";
declare option xdmp:mapping "false";
(:~
 : The codepoint to charclass mapping for 7 bit codepoints.
 :)
declare variable $p:MAP0 as xs:integer+ :=
(
  29, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 2, 2, 2, 2,
  2, 2, 2, 2, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 2, 2, 2, 2, 2, 2, 12, 12, 12, 12, 13, 12, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 14, 15, 16, 2, 2, 2, 17, 18, 12, 12, 19, 20, 2, 2, 2, 2, 2, 21,
  2, 22, 2, 2, 2, 23, 24, 25, 26, 2, 2, 2, 2, 2, 27, 2, 28, 2, 2
);

(:~
 : The codepoint to charclass mapping for codepoints below the surrogate block.
 :)
declare variable $p:MAP1 as xs:integer+ :=
(
  54, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58,
  58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 58, 90, 122, 181, 212,
  149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149, 149,
  149, 149, 149, 149, 149, 149, 149, 149, 149, 29, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 12, 12, 12, 12, 13,
  12, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 14, 15, 16, 2, 2, 17, 18, 12, 12, 19, 20, 2, 2, 2, 2,
  2, 21, 2, 22, 2, 2, 2, 23, 24, 25, 26, 2, 2, 2, 2, 2, 27, 2, 28, 2, 2
);

(:~
 : The codepoint to charclass mapping for codepoints above the surrogate block.
 :)
declare variable $p:MAP2 as xs:integer+ :=
(
  57344, 65536, 65533, 1114111, 2, 2
);

(:~
 : The token-set-id to DFA-initial-state mapping.
 :)
declare variable $p:INITIAL as xs:integer+ :=
(
  1, 66, 3, 4, 5, 6, 7, 8, 9, 10, 11
);

(:~
 : The DFA transition table.
 :)
declare variable $p:TRANSITION as xs:integer+ :=
(
  311, 311, 311, 311, 311, 311, 311, 311, 240, 247, 311, 311, 311, 311, 311, 311, 311, 342, 311, 311, 311, 311, 311,
  311, 462, 278, 343, 311, 311, 311, 311, 311, 311, 342, 282, 311, 311, 311, 311, 311, 312, 259, 311, 311, 311, 311,
  311, 311, 311, 297, 282, 311, 311, 311, 311, 311, 311, 405, 311, 311, 311, 311, 311, 311, 311, 342, 343, 311, 311,
  311, 311, 311, 311, 271, 337, 290, 309, 311, 311, 311, 311, 320, 337, 290, 309, 311, 311, 311, 363, 342, 311, 311,
  311, 311, 311, 311, 311, 342, 311, 351, 309, 311, 311, 311, 311, 445, 311, 376, 309, 311, 311, 311, 311, 400, 311,
  311, 311, 311, 311, 311, 311, 440, 343, 311, 311, 311, 311, 311, 263, 435, 311, 311, 311, 311, 311, 311, 311, 368,
  311, 351, 309, 311, 311, 311, 311, 342, 343, 351, 309, 311, 311, 311, 311, 445, 311, 413, 309, 311, 311, 311, 311,
  327, 343, 351, 309, 311, 311, 311, 311, 342, 392, 301, 311, 311, 311, 311, 311, 358, 343, 311, 311, 311, 311, 311,
  311, 342, 460, 311, 311, 311, 311, 311, 311, 342, 311, 332, 311, 311, 311, 311, 311, 383, 343, 311, 311, 311, 311,
  311, 311, 342, 421, 311, 311, 311, 311, 311, 311, 429, 311, 311, 311, 311, 311, 311, 251, 453, 311, 311, 311, 311,
  311, 311, 389, 311, 311, 311, 311, 311, 311, 311, 0, 322, 322, 322, 322, 322, 322, 322, 0, 322, 12, 0, 0, 0, 0, 0,
  896, 896, 0, 384, 0, 0, 12, 0, 0, 0, 0, 576, 0, 0, 576, 0, 270, 270, 12, 270, 0, 271, 0, 12, 12, 192, 0, 0, 0, 0, 27,
  0, 0, 0, 31, 282, 283, 0, 0, 0, 33, 0, 13, 13, 12, 0, 0, 0, 0, 704, 0, 0, 0, 34, 12, 0, 0, 0, 0, 0, 0, 0, 0, 384, 0,
  271, 271, 12, 271, 0, 271, 0, 16, 16, 12, 0, 0, 0, 0, 32, 0, 0, 0, 0, 282, 283, 0, 0, 0, 12, 0, 0, 0, 0, 0, 31, 0, 0,
  0, 0, 0, 33, 0, 17, 17, 12, 0, 0, 0, 0, 448, 0, 0, 0, 0, 12, 0, 0, 0, 22, 31, 21, 0, 0, 0, 0, 33, 0, 18, 18, 12, 0, 0,
  0, 0, 128, 0, 0, 0, 0, 0, 28, 29, 0, 0, 512, 512, 12, 0, 0, 0, 0, 12, 0, 20, 20, 0, 31, 21, 0, 0, 0, 768, 33, 640, 23,
  0, 25, 0, 0, 0, 0, 30, 0, 832, 832, 12, 0, 0, 0, 0, 576, 12, 0, 0, 0, 0, 19, 0, 0, 0, 0, 12, 0, 21, 21, 0, 896, 0, 0,
  12, 0, 0, 0, 0, 24, 12, 0, 0, 0, 0, 0, 12, 0
);

(:~
 : The DFA-state to expected-token-set mapping.
 :)
declare variable $p:EXPECTED as xs:integer+ :=
(
  24, 5, 13, 15, 23, 8240, 7820, 8092, 4, 8, 8, 8, 512, 1024, 2048, 4, 8, 8, 512, 1024, 2048, 4, 512, 4, 4, 16, 18, 80,
  272, 8208, 8212, 304
);

(:~
 : The token-string table.
 :)
declare variable $p:TOKEN as xs:string+ :=
(
  "EPSILON",
  "eof",
  "string",
  "number",
  "whitespace",
  "','",
  "':'",
  "'['",
  "']'",
  "'false'",
  "'null'",
  "'true'",
  "'{'",
  "'}'"
);

(:~
 : Match next token in input string, starting at given index, using
 : the DFA entry state for the set of tokens that are expected in
 : the current context.
 :
 : @param $input the input string.
 : @param $begin the index where to start in input string.
 : @param $token-set the expected token set id.
 : @return a sequence of three: the token code of the result token,
 : with input string begin and end positions. If there is no valid
 : token, return the negative id of the DFA state that failed, along
 : with begin and end positions of the longest viable prefix.
 :)
declare function p:match($input as xs:string,
                         $begin as xs:integer,
                         $token-set as xs:integer) as xs:integer+
{
  let $result := $p:INITIAL[1 + $token-set]
  return p:transition($input,
                      $begin,
                      $begin,
                      $begin,
                      $result,
                      $result mod 64,
                      0)
};

(:~
 : The DFA state transition function. If we are in a valid DFA state, save
 : it's result annotation, consume one input codepoint, calculate the next
 : state, and use tail recursion to do the same again. Otherwise, return
 : any valid result or a negative DFA state id in case of an error.
 :
 : @param $input the input string.
 : @param $begin the begin index of the current token in the input string.
 : @param $current the index of the current position in the input string.
 : @param $end the end index of the result in the input string.
 : @param $result the result code.
 : @param $current-state the current DFA state.
 : @param $previous-state the  previous DFA state.
 : @return a sequence of three: the token code of the result token,
 : with input string begin and end positions. If there is no valid
 : token, return the negative id of the DFA state that failed, along
 : with begin and end positions of the longest viable prefix.
 :)
declare function p:transition($input as xs:string,
                              $begin as xs:integer,
                              $current as xs:integer,
                              $end as xs:integer,
                              $result as xs:integer,
                              $current-state as xs:integer,
                              $previous-state as xs:integer) as xs:integer+
{
  if ($current-state = 0) then
    let $result := $result idiv 64
    return
      if ($result != 0) then
      (
        $result - 1,
        $begin,
        $end
      )
      else
      (
        - $previous-state,
        $begin,
        $current - 1
      )
  else
    let $c0 := (string-to-codepoints(substring($input, $current, 1)), 0)[1]
    let $c1 :=
      if ($c0 < 128) then
       (: $p:MAP0[1 + $c0]:)
         fn:subsequence($p:MAP0,$c0 + 1,1)
      else if ($c0 < 55296) then
        let $c1 := $c0 idiv 32
        let $c2 := $c1 idiv 32
        return (:$p:MAP1[1 + $c0 mod 32 + $p:MAP1[1 + $c1 mod 32 + $p:MAP1[1 + $c2]]]:)
         fn:subsequence($p:MAP1,   
              1 + $c0 mod 8 + fn:subsequence($p:MAP1,1 + $c2 mod 32,1) + fn:subsequence($p:MAP1,1 + $c2,1)
           ,1)
      else
        p:map2($c0, 1, 2)
    let $current := $current + 1
    let $i0 := 64 * $c1 + $current-state - 1
    let $i1 := $i0 idiv 8
(:    let $next-state := $p:TRANSITION[$i0 mod 8 + $p:TRANSITION[$i1 + 1] + 1]
:)    
     let $next-state := fn:subsequence($p:TRANSITION, $i0 mod 8 + fn:subsequence($p:TRANSITION,$i1 + 1,1) + 1,1)
      return
      if ($next-state > 63) then
        p:transition($input, $begin, $current, $current, $next-state, $next-state mod 64, $current-state)
      else
        p:transition($input, $begin, $current, $end, $result, $next-state, $current-state)
};

(:~
 : Recursively translate one 32-bit chunk of an expected token bitset
 : to the corresponding sequence of token strings.
 :
 : @param $result the result of previous recursion levels.
 : @param $chunk the 32-bit chunk of the expected token bitset.
 : @param $base-token-code the token code of bit 0 in the current chunk.
 : @return the set of token strings.
 :)
declare function p:token($result as xs:string*,
                         $chunk as xs:integer,
                         $base-token-code as xs:integer) as xs:string*
{
  if ($chunk = 0) then
    $result
  else
    p:token
    (
      ($result, if ($chunk mod 2 != 0) then $p:TOKEN[$base-token-code] else ()),
      if ($chunk < 0) then $chunk idiv 2 + 2147483648 else $chunk idiv 2,
      $base-token-code + 1
    )
};

(:~
 : Calculate expected token set for a given DFA state as a sequence
 : of strings.
 :
 : @param $state the DFA state.
 : @return the set of token strings
 :)
declare function p:expected-token-set($state as xs:integer) as xs:string*
{
  if ($state > 0) then
    for $t in 0 to 0
    let $i0 := $t * 34 + $state - 1
    let $i1 := $i0 idiv 8
    return p:token((), $p:EXPECTED[$i0 mod 8 + $p:EXPECTED[$i1 + 1] + 1], $t * 32 + 1)
  else
    ()
};

(:~
 : Classify codepoint by doing a tail recursive binary search for a
 : matching codepoint range entry in MAP2, the codepoint to charclass
 : map for codepoints above the surrogate block.
 :
 : @param $c the codepoint.
 : @param $lo the binary search lower bound map index.
 : @param $hi the binary search upper bound map index.
 : @return the character class.
 :)
declare function p:map2($c as xs:integer, $lo as xs:integer, $hi as xs:integer) as xs:integer
{
  if ($lo > $hi) then
    0
  else
    let $m := ($hi + $lo) idiv 2
    return
      if ($p:MAP2[$m] > $c) then
        p:map2($c, $lo, $m - 1)
      else if ($p:MAP2[2 + $m] < $c) then
        p:map2($c, $m + 1, $hi)
      else
        $p:MAP2[4 + $m]
};

(:~
 : The index of the parser state for accessing the combined
 : (i.e. level > 1) lookahead code.
 :)
declare variable $p:lk := 1;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the token that has been shifted.
 :)
declare variable $p:b0 := 2;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the token that has been shifted.
 :)
declare variable $p:e0 := 3;

(:~
 : The index of the parser state for accessing the code of the
 : level-1-lookahead token.
 :)
declare variable $p:l1 := 4;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the level-1-lookahead token.
 :)
declare variable $p:b1 := 5;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the level-1-lookahead token.
 :)
declare variable $p:e1 := 6;

(:~
 : The index of the parser state for accessing the token code that
 : was expected when an error was found.
 :)
declare variable $p:error := 7;

(:~
 : The index of the parser state that points to the first entry
 : used for collecting action results.
 :)
declare variable $p:result := 8;

(:~
 : Create a textual error message from a parsing error.
 :
 : @param $input the input string.
 : @param $error the parsing error descriptor.
 : @return the error message.
 :)
declare function p:error-message($input as xs:string, $error as element(error)) as xs:string
{
  let $begin := xs:integer($error/@b)
  let $context := string-to-codepoints(substring($input, 1, $begin - 1))
  let $linefeeds := index-of($context, 10)
  let $line := count($linefeeds) + 1
  let $column := ($begin - $linefeeds[last()], $begin)[1]
  return
    if ($error/@o) then
      concat
      (
        "syntax error, found ", $p:TOKEN[$error/@o + 1], "&#10;",
        "while expecting ", $p:TOKEN[$error/@x + 1], "&#10;",
        "after scanning ", string($error/@e - $begin), " characters at line ",
        string($line), ", column ", string($column), "&#10;",
        "...", substring($input, $begin, 32), "..."
      )
    else
      let $expected := p:expected-token-set($error/@s)
      return
        concat
        (
          "lexical analysis failed&#10;",
          "while expecting ",
          "["[exists($expected[2])],
          string-join($expected, ", "),
          "]"[exists($expected[2])],
          "&#10;",
          "after scanning ", string($error/@e - $begin), " characters at line ",
          string($line), ", column ", string($column), "&#10;",
          "...", substring($input, $begin, 32), "..."
        )
};

(:~
 : Shift one token, i.e. compare lookahead token 1 with expected
 : token and in case of a match, shift lookahead tokens down such that
 : l1 becomes the current token, and higher lookahead tokens move down.
 : When lookahead token 1 does not match the expected token, raise an
 : error by saving the expected token code in the error field of the
 : parser state.
 :
 : @param $code the expected token.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:shift($code as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else if ($state[$p:l1] = $code) then
  (
  (:  $state[position() >= $p:l1 and position() <= $p:e1],:)
    fn:subsequence($state, $p:l1,$p:e1 - $p:l1 + 1),
    0,
    $state[$p:e1],
    $state[position() >= $p:e1],
    if ($state[$p:e0] != $state[$p:b1]) then
      text {substring($input, $state[$p:e0], $state[$p:b1] - $state[$p:e0])}
    else
      (),
    let $name := $p:TOKEN[1 + $state[$p:l1]]
    let $content := substring($input, $state[$p:b1], $state[$p:e1] - $state[$p:b1])
    return
      if (starts-with($name, "'")) then
		    element TOKEN {$content}
	    else
	      element {$name} {$content}
  )
  else
  (
    $state[position() < $p:error],
    element error
    {
      attribute b {$state[$p:b1]},
      attribute e {$state[$p:e1]},
      if ($state[$p:l1] < 0) then
        attribute s {- $state[$p:l1]}
      else
        (attribute o {$state[$p:l1]}, attribute x {$code})
    },
    $state[position() > $p:error]
  )
};

(:~
 : Use p:match to fetch the next token, but skip any leading
 : whitespace.
 :
 : @param $input the input string.
 : @param $begin the index where to start.
 : @param $token-set the valid token set id.
 : @return a sequence of three values: the token code of the result
 : token, with input string positions of token begin and end.
 :)
declare function p:matchW($input as xs:string,
                          $begin as xs:integer,
                          $token-set as xs:integer) as xs:integer+
{
  let $match := p:match($input, $begin, $token-set)
  return
    if ($match[1] = 4) then                                 (: whitespace^token :)
      p:matchW($input, $match[3], $token-set)
    else
      $match
};

(:~
 : Lookahead one token on level 1 with whitespace skipping.
 :
 : @param $set the code of the DFA entry state for the set of valid tokens.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:lookahead1W($set as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:l1] != 0) then
    $state
  else
    let $match := p:matchW($input, $state[$p:b1], $set)
    return
    (
      $match[1],
      (:$state[position() > $p:lk and position() < $p:l1],:)
      subsequence($state,$p:lk + 1,$p:l1 - $p:lk - 1),
      $match,
      $state[position() > $p:e1]
    )
};

(:~
 : Lookahead one token on level 1.
 :
 : @param $set the code of the DFA entry state for the set of valid tokens.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:lookahead1($set as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:l1] != 0) then
    $state
  else
    let $match := p:match($input, $state[$p:b1], $set)
    return
    (
      $match[1],
      (:$state[position() > $p:lk and position() < $p:l1],:)
      fn:subsequence($state,$p:lk + 1,$p:l1 - $p:lk - 1),
      $match,
      $state[position() > $p:e1]
    )
};

(:~
 : Reduce the result stack. Pop $count element, wrap them in a
 : new element named $name, and push the new element.
 :
 : @param $state the parser state.
 : @param $name the name of the result node.
 : @param $count the number of child nodes.
 : @return the updated parser state.
 :)
declare function p:reduce($state as item()+, $name as xs:string, $count as xs:integer) as item()+
{
  (:$state[position() <= $count],:)
  fn:subsequence($state,1,$count),
  element {$name}
  {
    (:$state[position() > $count]:)
    fn:subsequence($state,$count + 1)
  }
};

(:~
 : Parse the 1st loop of production array (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-array-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1W(7, $input, $state)          (: whitespace^token | ',' | ']' :)
    return
      if ($state[$p:l1] != 5) then                          (: ',' :)
        $state
      else
        let $state := p:shift(5, $input, $state)            (: ',' :)
        let $state := p:lookahead1W(1, $input, $state)      (: EPSILON | whitespace^token :)
        let $state := p:parse-value($input, $state)
        return p:parse-array-1($input, $state)
};

(:~
 : Parse array.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-array($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:shift(7, $input, $state)                  (: '[' :)
  let $state := p:lookahead1W(10, $input, $state)           (: string | number | whitespace^token | '[' | ']' |
                                                               'false' | 'null' | 'true' | '{' :)
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:l1] != 8) then                       (: ']' :)
      let $state := p:parse-value($input, $state)
      let $state := p:parse-array-1($input, $state)
      return $state
    else
      $state
  let $state := p:lookahead1W(4, $input, $state)            (: whitespace^token | ']' :)
  let $state := p:shift(8, $input, $state)                  (: ']' :)
  return p:reduce($state, "array", $count)
};

(:~
 : Parse pair.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-pair($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:lookahead1(0, $input, $state)             (: string :)
  let $state := p:shift(2, $input, $state)                  (: string :)
  let $state := p:lookahead1W(3, $input, $state)            (: whitespace^token | ':' :)
  let $state := p:shift(6, $input, $state)                  (: ':' :)
  let $state := p:lookahead1W(1, $input, $state)            (: EPSILON | whitespace^token :)
  let $state := p:parse-value($input, $state)
  return p:reduce($state, "pair", $count)
};

(:~
 : Parse the 1st loop of production object (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-object-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1W(8, $input, $state)          (: whitespace^token | ',' | '}' :)
    return
      if ($state[$p:l1] != 5) then                          (: ',' :)
        $state
      else
        let $state := p:shift(5, $input, $state)            (: ',' :)
        let $state := p:lookahead1W(1, $input, $state)      (: EPSILON | whitespace^token :)
        let $state := p:parse-pair($input, $state)
        return p:parse-object-1($input, $state)
};

(:~
 : Parse object.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-object($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:shift(12, $input, $state)                 (: '{' :)
  let $state := p:lookahead1W(6, $input, $state)            (: string | whitespace^token | '}' :)
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:l1] = 2) then                        (: string :)
      let $state := p:parse-pair($input, $state)
      let $state := p:parse-object-1($input, $state)
      return $state
    else
      $state
  let $state := p:lookahead1W(5, $input, $state)            (: whitespace^token | '}' :)
  let $state := p:shift(13, $input, $state)                 (: '}' :)
  return p:reduce($state, "object", $count)
};

(:~
 : Parse value.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-value($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:lookahead1(9, $input, $state)             (: string | number | '[' | 'false' | 'null' | 'true' | '{' :)
  let $state :=
    if ($state[$p:l1] = 2) then                             (: string :)
      let $state := p:shift(2, $input, $state)              (: string :)
      return $state
    else if ($state[$p:l1] = 3) then                        (: number :)
      let $state := p:shift(3, $input, $state)              (: number :)
      return $state
    else if ($state[$p:l1] = 12) then                       (: '{' :)
      let $state := p:parse-object($input, $state)
      return $state
    else if ($state[$p:l1] = 7) then                        (: '[' :)
      let $state := p:parse-array($input, $state)
      return $state
    else if ($state[$p:l1] = 11) then                       (: 'true' :)
      let $state := p:shift(11, $input, $state)             (: 'true' :)
      return $state
    else if ($state[$p:l1] = 9) then                        (: 'false' :)
      let $state := p:shift(9, $input, $state)              (: 'false' :)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:shift(10, $input, $state)             (: 'null' :)
      return $state
  return p:reduce($state, "value", $count)
};

(:~
 : Parse json.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-json($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:lookahead1W(1, $input, $state)            (: EPSILON | whitespace^token :)
  let $state := p:parse-value($input, $state)
  let $state := p:lookahead1W(2, $input, $state)            (: eof | whitespace^token :)
  let $state := p:shift(1, $input, $state)                  (: eof :)
  return p:reduce($state, "json", $count)
};
(: End :)
(:~
 : Parse start symbol json from given string.
 :
 : @param $s the string to be parsed.
 : @return the result as generated by parser actions.
 :)
declare function p:parse-json($s as xs:string) as item()*
{
  let $state := p:parse-json($s, (0, 1, 1, 0, 1, 0, false()))
  let $error := $state[$p:error]
  return
    if ($error) then
      element ERROR {$error/@*, p:error-message($s, $error)}
    else
      $state[position() >= $p:result]
};

(:~
 : Recursively converts Parse Tree into XML representation of json object
 :
~:)
(:
declare function p:_parse($node as node())
{
   typeswitch($node)
    case element(json) return for $n in $node/node() return  p:_parse($n)
    case element(object) return for $n in $node/node() return  p:_parse($n)
    case element(value) return for $n in $node/node() return  p:_parse($n)
    case element(pair) return
      let $nname := p:clean($node/(string|number))
      return
      if($node/value/array) 
      then for $n in $node/node() return p:_parse($n) 
      else
            element {$nname}
            {
              if($node/value/(string|number)) 
              then p:clean($node/value/(string|number))
              else for $n in $node/node() return p:_parse($n)
            }
    case element(array) return  
        let $parent := fn:string($node/../../(string|number))
        let $name := if($parent) then p:clean($parent) else "item"
        return
          if($node/value/object) 
          then element {$name}{for $n in $node/value return p:_parse($n)}
          else if($node/value/array) 
          then element items {for $n in $node/element() return p:_parse($n)} 
          else 
              for $n in $node/value/(string|number)
              return 
              element {$name}{p:clean($n)}
    default return ()
};
:)
declare function p:_parse($node as node())
{
   typeswitch($node)
    case element(pair) return
      element item {
       if($node/value/(string|number|TOKEN)) then 
       (  
         attribute name {p:clean($node/string)},
         if($node/value/number) then attribute xsi:type {"xs:integer"} 
         else if($node/value[TOKEN = ("false","true")]) then attribute xsi:type{"xs:boolean"} 
         else if($node/value[TOKEN = "null"]) then attribute xsi:nillable{fn:true()} 
         else attribute type{"xs:string"},
         if($node/value/TOKEN ne "null") then 
            p:clean(fn:string($node/value/(string|number|TOKEN)))
         else ()
       )
       else (
       attribute type{ fn:local-name($node/value/element()[1])},
       for $n in $node/value return p:_parse($n)
       )}
    case element(object) return for $n in $node/node() return p:_parse($n)
    case element(TOKEN) return ()
    case element(eof) return ()
    case element(value) return  

       if($node/(string|number|TOKEN)) then 
       (  
     element value {
         if($node/number) then attribute xsi:type {"xs:integer"} 
         else if($node[TOKEN = ("false","true")]) then attribute xsi:type{"xs:boolean"} 
         else if($node[TOKEN = "null"]) then attribute xsi:nillable{fn:true()} 
         else attribute type{"xs:string"},
         if($node/TOKEN ne "null") then 
            p:clean($node)
         else ()
       }) else for $n in $node/node() return p:_parse($n)
       
    case element(array) return for $n in $node/node() return p:_parse($n)
    case element() return element {fn:node-name($node)} {for $n in $node/node() return p:_parse($n)}
    default return $node
};
declare  function p:clean($string)
{
  fn:replace(fn:replace($string,"^&quot;|^'",""),"&quot;$|'$","")
};
(:~
 : Converts JSON to XML
~:)
declare function p:parse($input as xs:string)
{
   let $parse := p:parse-json($input)
   return
     p:_parse($parse)
};