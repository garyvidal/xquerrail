xquery version "1.0-ml";

module namespace interceptor = "http://www.xquerrail-framework.com/interceptor/ml-security";

declare function interceptor:name()
{
  xs:QName("interceptor:ml-security")
};

declare function interceptor:implements() as xs:QName*
{
   (
     xs:QName("interceptor:before-request"),
     xs:QName("interceptor:after-request"),
     xs:QName("interceptor:before-response"),
     xs:QName("interceptor:after-response")
   )
};

declare function interceptor:before-request($request as map:map)
{
  ()
};

declare function interceptor:after-request($response as map:map)
{
  ()
};

declare function interceptor:before-response($response as map:map)
{
  ()
};
declare function interceptor:after-response($response as map:map)
{ 
  ()
}; 

