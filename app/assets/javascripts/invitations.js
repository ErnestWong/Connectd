namespace("C");

C.invitations =
  function() {
    var user_search = $("#user_search");

    user_search.autocomplete({
      source: results 
    });

    user_search.on("keyup change", autocomplete);

    function autocomplete() {
      var input = $(this).val();
      getAutocomplete(input);
    };

    function getAutocomplete(input) {
      $.get("/users/autocomplete", params, function(data) {
        console.log(data);
        results = data;
      });
    };
  };
