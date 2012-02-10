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
    <script type="text/javascript" src="/web/js/flexigrid.js"></script>
    <link href="/web/css/flexigrid.css" rel="stylesheet" media="all" />
    <div class="inner-page-title">
        <?slot slot="headline"?>
           <h2>Example 1</h2>
        <?endslot?>
        <span>The most basic example with the zero configuration, with a table converted into flexigrid</span>
    </div>
    <table id="flex1" style="display:none"></table>
    <br /><br /><br />
    <div class="inner-page-title">
        <h2>Example 2</h2>
        <span>The most basic example with the zero configuration, with a table converted into flexigrid</span>
    </div>
    <table class="flexme1">
        <thead>
            <tr>
                <th width="100">Col 1</th>
                <th width="100">Col 2</th>
                <th width="100">Col 3 is a long header name</th>
                <th width="300">Col 4</th>
                
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>This is data 1 with overflowing content</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                
                <td>This is data 4</td>
            </tr>
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
                
            </tr>
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                <td>This is data 1</td>
                
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                
                <td>This is data 4</td>
            </tr>
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
                
            </tr>
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            
        </tbody>
    </table>
    <br /><br />
    <div class="inner-page-title">
        <h2>Example 2</h2>
        <span>Table converted into flexigrid with height, and width set to auto, stripes remove.</span>
    </div>
    <table class="flexme2">
        <thead>
            
            <tr>
                <th width="100">Col 1</th>
                <th width="100">Col 2</th>
                <th width="100">Col 3 is a long header name</th>
                <th width="300">Col 4</th>
            </tr>
        </thead>
        
        <tbody>
            <tr>
                <td>This is data 1 with overflowing content</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                <td>This is data 1</td>
                
                <td>This is data 2</td>
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                
                <td>This is data 3</td>
                <td>This is data 4</td>
            </tr>
            <tr>
                <td>This is data 1</td>
                <td>This is data 2</td>
                <td>This is data 3</td>
                
                <td>This is data 4</td>
            </tr>
        </tbody>
    </table>
    
    <script type="text/javascript">
			$("#flex1").flexigrid
			(
			{{
			url: 'post2.php',
			dataType: 'json',
			colModel : [
				{{display: 'ISO', name : 'iso', width : 40, sortable : true, align: 'center'}},
				{{display: 'Name', name : 'name', width : 180, sortable : true, align: 'left'}},
				{{display: 'Printable Name', name : 'printable_name', width : 120, sortable : true, align: 'left'}},
				{{display: 'ISO3', name : 'iso3', width : 130, sortable : true, align: 'left', hide: true}},
				{{display: 'Number Code', name : 'numcode', width : 80, sortable : true, align: 'right'}}
				],
			buttons : [
				{{name: 'Add', bclass: 'add', onpress : test}},
				{{name: 'Delete', bclass: 'delete', onpress : test}},
				{{separator: true}}
				],
			searchitems : [
				{{display: 'ISO', name : 'iso'}},
				{{display: 'Name', name : 'name', isdefault: true}}
				],
			sortname: "iso",
			sortorder: "asc",
			usepager: true,
			title: 'Countries',
			useRp: true,
			rp: 15,
			showTableToggleBtn: true,
			width: 700,
			height: 200
			}}
			);   

			$('.flexme1').flexigrid();
			$('.flexme2').flexigrid({{height:'auto',striped:false}});

			function test(com,grid)
						{{
							if (com=='Delete')
								{{
									confirm('Delete ' + $('.trSelected',grid).length + ' items?')
								}}
							else if (com=='Add')
								{{
									alert('Add New Item');
								}}			
						}}


</script>
    <div class="clearfix"></div>
    <?template name="sidebar" ?>
</div>
