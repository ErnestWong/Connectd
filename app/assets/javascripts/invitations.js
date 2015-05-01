namespace("C");

C.invitations =
  function() {
    var user_search = $("#user_search");
    results = [];
    obj = {
      delay: 100,
      minLength: 3,
      source: results 
    };

    user_search.autocomplete(obj);

    user_search.on("keyup change", autocomplete);

    function autocomplete() {
      var input = $(this).val();
      getAutocomplete(input);
    };

    function getAutocomplete(input) {
      params = { search: { query: input } };
      $.get("/users/autocomplete", params, function(data) {
        $.each(data, function(user) {
          debugger
          results.push({
            label: user.first_name + " " + user.last_name + "--" + user.username,
            value: user.id
          });
        });
      });
    };
  };
