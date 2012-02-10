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

module namespace interceptor = "http://www.xquerrail-framework.com/interceptor";

declare function interceptor:name()
{
  xs:QName("interceptor:profiler")
};
declare function interceptor:implements() as xs:QName*
{
   (
     xs:QName("interceptor:invoke-after"),
     xs:QName("interceptor:invoke-before")
   )
};
declare function interceptor:invoke-before($request as map:map)
{
  ()
};
declare function interceptor:invoke-after($response as map:map)
{
  ()
};

