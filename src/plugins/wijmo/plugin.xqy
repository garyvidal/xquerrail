xquery version "1.0-ml";

module namespace plugin = "http://www.xquerrail-framework.com/plugin/wijmo";

declare function plugin:name()
{
   "wijmo"
};
declare function plugin:tags()
{
  ("wijmo","wijcontainer","wijgrid")
};

declare function plugin:formats() {
   "html"
};

declare function plugin:controller()
{
   "wijmo-controller.xqy"
};

declare function plugin:default-action()
{  
   "default"
};
