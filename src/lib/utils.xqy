xquery version "1.0-ml";

module namespace util = "http://www.condenast.com/dam/2.0/lib/util";

(:~
: Generates a GUID based on the SHA1 algorithm.
: Wallclock will be used to make the GUIDs sortable.
:)
declare function util:generate-guid-element($seed as xs:int?) 
as element(uuid)
{
  let $wallclock := xdmp:wallclock-to-timestamp(fn:current-dateTime() + xdmp:elapsed-time())
  let $sha1 := xdmp:sha1(fn:string($wallclock + $seed))
  let $guid := fn:replace($sha1,"(\c{8})(\c{4})(\c{4})(\c{4})(\c{12})","$1-$2-$3-$4-$5")
  
  return 
    element uuid {
        attribute wallclock { $wallclock },
        $guid
    }
};

(:~
:
:)
declare function util:generate-guid-element() {
    util:generate-guid-element(1) 
};