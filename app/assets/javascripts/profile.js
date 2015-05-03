namespace("C");

C["users_show"] = 
  function() {
    var username_input = $("#username_input");
    var valid_icon = $("#valid_icon");
    var invalid_icon = $("#error_icon");
    var valid = false;
    valid_icon.hide();
    invalid_icon.hide();

    var userid = window.location.pathname.match(/(\d+)\/*$/)[1];

    username_input.bind("change paste keyup", function() {
      var input = $(this).val();
      checkUsername(input);
    });

    function checkUsername(input) {
      params = {  id: userid ,  user: { username: input } }
      $.when(
        $.get("/users/" + userid + "/username_check", params, function(data) {
          errors = data.user_errors;
        })
      ).then(
        function(data) {
          updateStatus(data.user_errors);
        }
      );
    }

    function updateStatus(errors) {
      valid = (errors.length == 0);

      valid ? invalid_icon.hide() : valid_icon.hide();
      valid ? valid_icon.show() : invalid_icon.show();

      $(".user-profile-form-errors").empty();

      _.each(errors, function(el, index, list) {
        $(".user-profile-form-errors").append("<p>" + el.error + "</p>");
      });
    }
  };
