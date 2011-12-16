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
  try {
  (:Do something interesting:)
  } catch($ex) {
      (::)
  }
  
};
declare function interceptor:invoke-after($request as map:map,$response as map:map)
{
  ()
};

