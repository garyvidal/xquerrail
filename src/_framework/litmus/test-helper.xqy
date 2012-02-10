(:
 : Copyright 2011 - Gary Vidal
 :
 : Licensed     under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 :    http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)



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

