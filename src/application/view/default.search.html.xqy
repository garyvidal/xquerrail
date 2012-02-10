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



declare default element namespace "http://www.w3.org/1999/xhtml";
<div>
   <div class="inner-page-title">
      <div style="text-align:center">
            <form method="post" action="/default/search">
                <h2>Search:<input name="q" type="text" class="small" value=""/></h2>
                <span>Type "show" to get some results. Any other query will return no results
                </span>
            </form>     
        </div>     
     </div>       
    <div class="three-column">
        <!--Middle Div-->
        <div class="three-col-mid">
            <div class="column col1">
                <div class="portlet ui-widget ui-widget-content ui-helper-clearfix ui-corner-all">
                    <div class="portlet-header ui-widget-header">Search Results<span class="ui-icon ui-icon-circle-arrow-s"></span></div>
                    <div class="portlet-content">
                       <?if exists(response:data("search_results")) ?>
                          <?pagination?>
                       <?endif?>
                            <!--Probably better to put it in a fragment-->
                            <?for response:data("search_results")//search-result ?>
                               <div class="content-box" style="padding:0">
                                   <div class="content-box-wrapper">
                                      <h3 class="title"><?this $this/title/text()?></h3>
                                      <div><?this fn:string($this/@uri)?> </div>
                                      <p class="snippet">
                                        <?this $this/snippet/*?> 
                                      </p>
                                   </div>
                               </div>
                            <?elsefor?>
                                 <div class="content-box" style="padding:0">
                                       <div class="content-box-wrapper">
                                          <h3 class="title">No Results found ...</h3>
                                       </div>
                                 </div>
                            <?endfor?>
                        <?if exists(response:data("search_results")) ?>
                           <?pagination?>
                        <?endif?>
                    </div>
                </div>
            </div>
            
            <div class="column col2">                    
                <div class="portlet ui-widget ui-widget-content ui-helper-clearfix ui-corner-all">
                    <div class="portlet-header ui-widget-header">Search Options<span class="ui-icon ui-icon-circle-arrow-s"></span></div>
                    <div class="portlet-content">
                        <ul class="side-menu">
                          <?for response:data("search_results")/facet-item/facet-value ?>
                           <li>
                                <a title="Switch to 1600px layout" id="layout1600" href="javascript:void(0);">
                                <?this $this/text()?>(<?this $this/@count?>)
                                </a>
                           </li>
                          <?elsefor?>
                          <?endfor?>
                        </ul>
                    </div>
                </div>
            </div>
            <!--Start Right Column-->
            <div class="column col3">
                <div class="portlet ui-widget ui-widget-content ui-helper-clearfix ui-corner-all">
                    <div class="portlet-header ui-widget-header">Similar Results<span class="ui-icon ui-icon-circle-arrow-s"></span></div>
                    <div class="portlet-content">
                        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.</p>
                        <p> Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.</p>
                        <p> Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.</p>
                        <p> Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus.</p>
                    </div>
                </div>
            </div>
            <!--End Right Column-->
        </div>
    </div>
    <div class="clear"></div>          
</div>