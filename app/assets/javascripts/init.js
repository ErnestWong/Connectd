$(document).ready(function() {
  controller = $("body").data("controller");
  action = $("body").data("action");
  controller_action = controller + "_" + action;

  //Controller and action JS
  if(isFunction(C[controller])) {
    C[controller]();
  }

  if(C[controller_action]) {
    C[controller_action]();
  }
});

function isFunction(fn) {
  return typeof fn === "function";
}
