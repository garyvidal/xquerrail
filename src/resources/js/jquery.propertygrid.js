/*
 * PropertyGrid - A revised propertyGrid control
 *
 * Author: Gary Vidal
 * Parts of this plugin are inspired by Joern Zaefferer's Tooltip plugin
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Version: r2
 * Date: 16 July 2011
 *
 */
(function( $ ){
  $.propertyGrid = {};
  $.propertyGrid.options = {
     toggle_icon : '.pg-toggle'
  };
  var PropertyGrid = {
       
  };
  var methods = {
     init : function( options ) {

       return this.each(function(){
         
         var $this = $(this),
             data = $this.data('.propertyGrid'),
             PropertyGrid = $(' <div />', {
               text : $this.attr('title')
             });
         
         // If the plugin hasn't been initialized yet
         if ( ! data ) {
           /*
             Do more setup stuff here
           */

           $(this).data('propertyGrid', {
               target : $this,
               propertyGrid : propertyGrid
           });
         }
         //Code Goes Here
         $this.append("<div>Bar</div>");
       });
     },
     destroy : function( ) {

       return this.each(function(){

         var $this = $(this),
             data = $this.data('propertyGrid');

         // Namespacing FTW
         $(window).unbind('.propertyGrid');
         data.propertyGrid.remove();
         $this.removeData('propertyGrid');

       })
     }
     ,
     addItem : function(data){
          $this.append("<span>foo</span>");
     }
     
  };

  $.fn.propertyGrid = function( method ) {
    
    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.propertyGrid' );
    }    
  
  };

})( jQuery );