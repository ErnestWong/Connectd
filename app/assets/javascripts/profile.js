namespace("C");

C["users_show"] = 
  function() {
    var username_input = $("#username_input");
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
          updateStatus(data);
        }
      );
    }

    function updateStatus() {
      
    }
  };
