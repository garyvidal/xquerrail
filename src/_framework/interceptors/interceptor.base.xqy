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



module namespace interceptor = "http://www.xquerrail-framework.com/interceptor";

(:~
 :  Register an interceptor with the global cache.
 :  Interceptors must be registered in the order in which the should 
 :  executed
~:)
declare function interceptor:register($name, $uri,$scope)
{
  ()
};

(:~
 : Deregisters a interceptor with the global cache. 
 : Interceptors must be registered in the order in which they should be executed.
 : If an interceptor is making a database update you must define your interceptor
 : with the appropriate transcation mode to ensure proper invocation.
 : @param $name - Name of the interceptor you want to deregister
~:)
declare function interceptor:deregister($name,$scope)
{
  ()
};

declare function interceptor:before-interceptors()
{
  ()
};

declare function interceptor:after-interceptors()
{
  ()
};

(:~
 : The front-controller will invoke your before interceptors
~:)
declare function interceptor:invoke-before($request,$context)
{
  ()
};

(:~
 : The system will invoke your after interceptors
~:)
declare function interceptor:invoke-after($request as map:map(),$response as map:map())
{
  ()
};
