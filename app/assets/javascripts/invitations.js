namespace("C");

C.invitations =
  function() {
    var user_search = $("#user_search");
    var user_id_search = $("#user_id_search");

    var obj = {
      delay: 100,
      minLength: 2,
      source: getAutocomplete,
      select: handleSelect
    };

    user_search.autocomplete(obj);

    function handleSelect(event, ui) {
      if(ui.item) {
        event.preventDefault();
        $("#user_search").val(ui.item.label);
        $("#user_id_search").val(ui.item.value);
      }
    };

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
          value: user.id
        };
      });
      return resultArray;
    };
  };
