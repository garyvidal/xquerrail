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
<div id="page-content-wrapper">
    <div class="inner-page-title">
        <h2>First Form</h2>
        <span>Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...</span>
    </div>
    <div class="content-box">
        <form action="#" method="post" enctype="multipart/form-data" class="forms" name="form" >
            <ul>
                <li>
                    <label  class="desc">
                        Name ( input class="small" )
                    </label>
                    <div>
                        <input type="text" tabindex="1" maxlength="255" value="" class="field text small" name="" />
                    </div>
                </li>
                <li>
                    <label  class="desc">
                        Input ( input class="medium" )
                    </label>
                    <div>
                        <input type="text" tabindex="1" maxlength="255" value="" class="field text medium" name="" />
                    </div>
                </li>
                <li>
                    <label  class="desc">
                        Input ( input class="large" )
                    </label>
                    <div>
                        <input type="text" tabindex="1" maxlength="255" value="" class="field text large" name="" />
                    </div>
                </li>
                <li>
                    <label  class="desc">
                        Input ( input class="full" )
                    </label>
                    <div>
                        <input type="text" tabindex="1" maxlength="255" value="" class="field text full" name="" />
                    </div>
                </li>
                <li>
                    <label  class="desc">
                        Textarea  ( input class="small" )
                    </label>
                    <div>
                        <textarea tabindex="2" cols="50" rows="5" class="field textarea small" name="" ></textarea>
                    </div>
                </li>
                <li>
                    <label  class="desc">
                        Other
                    </label>
                    <div class="float-left">
                        <span>
                            <input type="text" tabindex="6" value="" class="field text" name="" />
                            <label >Example</label>
                        </span>
                    </div>
                    <div class="float-left">
                        <span>
                            <input type="text" tabindex="6" value="" class="field text" name="" />
                            <label >Example</label>
                        </span>
                    </div>
                    <div class="float-left">
                        <span>
                            <input type="text" tabindex="6" value="" class="field text" name="" />
                            <label >Example</label>
                        </span>
                    </div>
                    <div class="float-left">
                        <span>
                            <input type="text" tabindex="6" value="" class="field text" name="" />
                            <label >Example</label>
                        </span>
                    </div>
                </li>
                <li>
                    <label  class="desc">
                        Priority
                    </label>
                    <div>
                        <select tabindex="3" class="field select large" name="" > 
                            <option value="Low">
                                Low
                            </option>
                            <option value="Medium">
                                Medium
                            </option>
                            <option value="High">
                                High
                            </option>
                        </select>
                    </div>
                </li>
                <li class="date">
                    <label for="Field2" id="title2" class="desc">
                        Due Date
                    </label>
                    <span>
                        <input type="text" tabindex="5" maxlength="2" size="2" value="" class="field text" name="" />
                        <label >MM</label>
                    </span> 
                    <span class="symbol">/</span>
                    <span>
                        <input type="text" tabindex="6" maxlength="2" size="2" value="" class="field text" name="" />
                        <label >DD</label>
                    </span>
                    <span class="symbol">/</span>
                    <span>
                        <input type="text" tabindex="7" maxlength="4" size="4" value="" class="field text" name="" />
                        <label >YYYY</label>
                    </span>
                </li>
                <li>
                    <label for="Field4" id="title4" class="desc">
                        Status
                    </label>
                    <div class="col">
                        <span>
                            <input type="checkbox" tabindex="8" value="Done." class="field checkbox" name="Field4" id="Field4"/>
                            <label for="Field4" class="choice">Done.</label>
                        </span>
                    </div>
                </li>
                <li class="buttons">
                    <button class="ui-state-default ui-corner-all ui-button" type="submit">Example Button</button>
                </li>
            </ul>
        </form>
        <div class="clear"></div>
    </div>
    <br /><br />
    <div class="inner-page-title">
        <h2>Form inside a portlet</h2>
        <span>Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...</span>
    </div>
    <div class="portlet ui-widget ui-widget-content ui-helper-clearfix ui-corner-all form-container">
        <div class="portlet-header ui-widget-header">Form elements in box<span class="ui-icon ui-icon-circle-arrow-s"></span></div>
        <div class="portlet-content">
            <form action="#" method="post" enctype="multipart/form-data" class="forms" name="form" >
                <ul>
                    <li>
                        <label  class="desc">
                            Name ( input class="small" )
                        </label>
                        <div>
                            <input type="text" tabindex="1" maxlength="255" value="" class="field text small" name="" />
                        </div>
                    </li>
                    <li>
                        <label  class="desc">
                            Input ( input class="medium" )
                        </label>
                        <div>
                            <input type="text" tabindex="1" maxlength="255" value="" class="field text medium" name="" />
                        </div>
                    </li>
                    <li>
                        <label  class="desc">
                            Input ( input class="large" )
                        </label>
                        <div>
                            <input type="text" tabindex="1" maxlength="255" value="" class="field text large" name="" />
                        </div>
                    </li>
                    <li>
                        <label  class="desc">
                            Textarea  ( input class="small" )
                        </label>
                        <div>
                            <textarea tabindex="2" cols="50" rows="5" class="field textarea small" name="" ></textarea>
                        </div>
                    </li>
                    <li>
                        <label  class="desc">
                            Other
                        </label>
                        <div class="float-left">
                            <span>
                                <input type="text" tabindex="6" value="" class="field text" name="" />
                                <label >Example</label>
                            </span>
                        </div>
                        <div class="float-left">
                            <span>
                                <input type="text" tabindex="6" value="" class="field text" name="" />
                                <label >Example</label>
                            </span>
                        </div>
                        <div class="float-left">
                            <span>
                                <input type="text" tabindex="6" value="" class="field text" name="" />
                                <label >Example</label>
                            </span>
                        </div>
                        <div class="float-left">
                            <span>
                                <input type="text" tabindex="6" value="" class="field text" name="" />
                                <label >Example</label>
                            </span>
                        </div>
                    </li>
                    <li>
                        <label  class="desc">
                            Priority
                        </label>
                        <div>
                            <select tabindex="3" class="field select large" name="" > 
                                <option value="Low">
                                    Low
                                </option>
                                <option value="Medium">
                                    Medium
                                </option>
                                <option value="High">
                                    High
                                </option>
                            </select>
                        </div>
                    </li>
                    <li class="date">
                        <label for="Field2" id="title2" class="desc">
                            Due Date
                        </label>
                        <span>
                            <input type="text" tabindex="5" maxlength="2" size="2" value="" class="field text" name="" />
                            <label >MM</label>
                        </span> 
                        <span class="symbol">/</span>
                        <span>
                            <input type="text" tabindex="6" maxlength="2" size="2" value="" class="field text" name="" />
                            <label >DD</label>
                        </span>
                        <span class="symbol">/</span>
                        <span>
                            <input type="text" tabindex="7" maxlength="4" size="4" value="" class="field text" name="" />
                            <label >YYYY</label>
                        </span>
                    </li>
                    <li>
                        <label for="Field4" id="title4" class="desc">
                            Status
                        </label>
                        <div class="col">
                            <span>
                                <input type="checkbox" tabindex="8" value="" class="field checkbox" name="" />
                                <label  class="choice">Done.</label>
                            </span>
                        </div>
                    </li>
                    <li class="buttons">
                        <button class="ui-state-default float-right ui-corner-all ui-button" type="submit">Example Button Floated Right</button>
                    </li>
                </ul>
            </form>
        </div>
    </div>
    <div class="clearfix"></div>
    <i class="note">* Just a simple note here ...</i>
    <?template name="sidebar"?>
</div>/*
