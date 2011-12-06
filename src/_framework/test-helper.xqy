xquery version "1.0-ml";
(:~
 : Testing Helper Functions
~:)
module namespace helper = "http://www.xquerrail-framework.com/test-helper";

declare function test:assert-empty($value as item()) {
  fn:empty($value)
};
        
declare function test:assert-all($values as item()*) {
    every $v in $values
    satisfies $v eq fn:true()
};

declare function test:assert-any($values as item()*) {
    some $v in $values 
    satisfies $v  eq fn:true()
};

declare function test:is-equal($value as item(),$compare as item()) as xs:boolean {
    $value eq $compare
};

declare function test:is-not-equal($value as item(), $compare as item())  as xs:boolean {
    $value ne $compare
};

declare function test:exists($value as item()) 
as xs:boolean
{
    if($value) then fn:true() else fn:false()
};

declare function test:is-deep-equal($value as item()*, $compare as item()*) as xs:boolean
{
    fn:deep-equal($value, $compare)
};

