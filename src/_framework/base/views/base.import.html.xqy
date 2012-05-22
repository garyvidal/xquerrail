xquery version "1.0-ml";
<div >
 <div class="inner-page-title ">
        <div class="toolbar">
          <h2>Import </h2>
        </div>
    </div>
    <form>
     <div id="import-view" class="import-view content-box">    
             <label for="import-file">File Upload:
               <input type="file" name="import-file" id="import-file" class="field file medium" />
             </label><br/>
             <label for="import-format">File Upload Format:
                 <select id="import-format" name="format" class="field select medium">
                     <option value="xml">Xml Format (.xml)</option>
                     <option value="csv">Comma Seperated Values Format (*.csv)</option>
                     <option value="tab">Tab Delimited Format (*.txt|*.tab)</option>
                     <option value="excel">Excel 2007+ Format (*.xslx)</option>
                 </select>
             </label>
             <div class="buttonset">
                <input type="submit" value="upload"></input>
             </div>
        </div>
  </form>      
  <script type="text/javascript">
     initializeForm();
  </script>  
</div> 