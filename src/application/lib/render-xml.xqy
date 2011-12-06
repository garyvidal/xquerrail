xquery version "0.9-ml"

module "http://www.marklogic.com/ps/lib-render-xml"

declare namespace rxml = "http://www.marklogic.com/ps/lib-render-xml"
declare namespace xhtml = "http://www.w3.org/1999/xhtml"

default function namespace = "http://www.w3.org/2003/05/xpath-functions"

define variable $REPLACEMENT-TOKEN as xs:string { " breakbreakbreak " }
define variable $CR-LF-PATTERN as xs:string { "(&#13;&#10;)|&#10;|&#13;" }

define function rxml:render($node as node())
{
  let $retval := rxml:convert($node,0)
  return $retval
}

define function rxml:passthru($x as element(), $level as xs:integer) as node()*
{
  for $z in $x/node() return rxml:convert($z, $level)
}

define function rxml:asis($x as element(), $level as xs:integer) as element()
{
  element { node-name($x) }
  {
    $x/attribute::*,
    rxml:passthru($x, $level)
  }
}

define function rxml:convert($x as node()?, $level as xs:integer)
{
  typeswitch ($x) 

    case element() return 
      if (fn:namespace-uri($x) = "http://marklogic.com/entity") then
        element span
        {
      attribute class { fn:local-name($x) },
      rxml:passthru($x, $level +1)
        }
      else 
    element xhtml:span 
    {
          attribute class {"relem"},

          text 
          {
            concat("<", name($x),         
            string-join(
              for $a in $x/attribute::*
              return 
                element xhtml:span
                {
                  attribute class {"ratt"},
                  text { concat(" ",  name($a), '="', string($a), '"') }
                }, 
                " "
            ),
            ">"
            )
          },
          rxml:passthru($x, $level + 1),
          text 
          {
            concat("</", name($x), ">")
          }
    }
        
    case document-node() return rxml:convert(($x/*[1]), $level)
    case processing-instruction() return $x

    case comment() return
      element xhtml:span
      {
        attribute class {"rcomment"},
        text { "<!-- ", string($x), " -->" }
      }

    case text() return
      element xhtml:span 
      {
        attribute class {"rtext"},
        let $new := replace($x, $CR-LF-PATTERN, $REPLACEMENT-TOKEN)
        let $new := replace($new, " ", "&nbsp;")
        let $new := replace($new, "&#9;", "&nbsp;&nbsp;&nbsp;&nbsp;")
        return
          cts:highlight(element host {$new}, cts:word-query($REPLACEMENT-TOKEN), <br/>)/node()
      }

    default return rxml:asis($x, $level)
}

define function rxml:render-table($x as node())
{
  <xhtml:h3>{local-name-from-QName(node-name($x))}</xhtml:h3>,<xhtml:br/>,
  <xhtml:table class="rxml-table">
  {
    for $e in $x/element()
    return
      element xhtml:tr
      {
    attribute class { "rxml-tr"},
    element xhtml:td
    {
      attribute class { "rxml-td"},
      local-name-from-QName(node-name($e))
    },
    
    element xhtml:td
    {
      string($e)
    }
      }
  }
  </xhtml:table>
}