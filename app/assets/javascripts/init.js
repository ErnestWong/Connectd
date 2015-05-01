$(document).ready(function() {
  controller = $("body").data("controller");
  action = $("body").data("action");

  //Controller and action JS
  if(isFunction(C[controller])) {
    C[controller]();
  }

  if(C["#{controller}_#{action}"]) {
    C["#{controller}_#{action}"]();
  }
});

function isFunction(fn) {
  return typeof fn === "function";
}
