xquery version "1.0-ml";
module namespace tag = "http://www.xquerrail-framework.com/tag";
import module namespace response = "http://www.xquerrail-framework.com/response"
   at "/_framework/response.xqy";
declare default element namespace "http://www.w3.org/1999/xhtml";

declare function tag:type()
{
   "inline"
};

declare function tag:buffers()
{
   "tag:pagination"
};

declare function tag:apply($node,$response)
{
  let $results := response:data("search_results")
  let $count := xs:integer($results/*:count)
  let $page := xs:integer(($results/*:page,1)[1])
  let $pagesize := xs:integer($results/*:pagesize)
  let $pages := fn:ceiling($count div $pagesize)
  return
  <div style="text-align:center">
    <ul class="pagination">
        {if($page eq 1) then () else <li class="previous-off">&laquo;Previous</li>}
        <li class="active">1</li>
        <li><a href="#">2</a></li>
        <li><a href="#">3</a></li>
        <li><a href="#">4</a></li>
        <li><a href="#">5</a></li>
        <li><a href="#">6</a></li>
        <li><a href="#">7</a></li>
        <li><a href="#">8</a></li>
        <li><a href="#">9</a></li>
        <li><a href="#">10</a></li>
        {if($page eq $pages) then () else <li class="next"><a href="#">Next &raquo;</a></li>}
        <li>Page {$page} of {$pages}</li>
    </ul>
    
    <div class="clearfix"></div>
  </div>
};








                                   