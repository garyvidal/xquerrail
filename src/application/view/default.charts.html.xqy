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
    <script type="text/javascript" src="/web/js/charts.js"></script>
    <link href="/web/css/charts.css" rel="stylesheet" media="all" />
    <div class="inner-page-title">
        <h2>Charts</h2>
        <span>Create charts from tables on the fly.</span>
    </div>
    <div class="content-box">
        <table>
            <caption>2009 Individual Sales by Category</caption>
            <thead>
                <tr>
                    <td></td>
                    <th>food</th>
                    <th>auto</th>
                    <th>household</th>
                    
                    <th>furniture</th>
                    <th>kitchen</th>
                    <th>bath</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>Mary</th>
                    <td>150</td>
                    <td>160</td>
                    <td>40</td>
                    <td>120</td>
                    <td>30</td>
                    <td>70</td>
                </tr>
                <tr>
                    <th>Tom</th>
                    <td>3</td>
                    <td>40</td>
                    <td>30</td>
                    
                    <td>45</td>
                    <td>35</td>
                    <td>49</td>
                </tr>
                <tr>
                    <th>Brad</th>
                    <td>10</td>
                    
                    <td>180</td>
                    <td>10</td>
                    <td>85</td>
                    <td>25</td>
                    <td>79</td>
                </tr>
                
                <tr>
                    <th>Kate</th>
                    <td>40</td>
                    <td>80</td>
                    <td>90</td>
                    <td>25</td>
                    
                    <td>15</td>
                    <td>119</td>
                </tr>		
            </tbody>
        </table>
    </div>
    <div id="charts">
    </div>
    <div class="clearfix"></div>

    <script type="text/javascript">
			$(document).ready(function(){{
				//make some charts
				$('table').visualize({{type: 'pie', pieMargin: 10, title: '2009 Total Sales by Individual'}});	
				$('table').visualize({{type: 'line'}});
				$('table').visualize({{type: 'area'}});
				$('table').visualize();
			}});
		</script>
    <?template name="sidebar" ?>
</div>
