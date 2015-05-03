namespace("C");

C["users_show"] =
  function() {
    //TODO: improve finding user id
    var userid = window.location.pathname.match(/(\d+)\/*$/)[1];
    initStatus();

    $("#username_input").bind("change paste keyup", function() {
      var input = $(this).val();
      checkUsername(input);
    });

    function initStatus() {
      $("#valid_icon").hide();
      $("#invalid_icon").hide();

      if($("#username_input").val()) {
        checkUsername($("#username_input").val());
      }
    }

    function checkUsername(input) {
      params = { id: userid ,  user: { username: input } }
      $.when(
        $.get("/users/" + userid + "/username_check", params)
      ).then(
        function(data) {
          updateStatus(data.user_errors);
        }
      );
    }

    function updateStatus(errors) {
      var valid = (errors.length == 0);

      valid ? $("#invalid_icon").hide() : $("#valid_icon").hide();
      valid ? $("#valid_icon").show() : $("#invalid_icon").show();

      $(".user-profile-form-errors").empty();

      _.each(errors, function(el, index, list) {
        $(".user-profile-form-errors").append("<p>" + el.error + "</p>");
      });
    }
  };
