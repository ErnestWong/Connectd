namespace("C");

C.invitations =
  function() {
    var user_search = $("#user_search");
    results = [];
    obj = {
      delay: 100,
      minLength: 2,
      source: getAutocomplete 
    };

    user_search.autocomplete(obj);

    function getAutocomplete(req, response) {
      params = { search: { query: req.term } };
      $.when(
        $.get("/users/autocomplete", params, function(data) {
          results = mapResults(data.users_results);
        })
      ).then(
        function() {
          response(results); 
        },
        function() {
          response();
        }
      );
    };

    function mapResults(data) {
      var resultArray = [];
      resultArray = _.map(data, function(user) {
        return {
          label: user.name,
          id: user.id
        };
      });
      return resultArray;
    };
  };
