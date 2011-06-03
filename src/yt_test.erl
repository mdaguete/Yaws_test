-module(yt_test).

%% API
-export([test_embedded/0,
         test_standalone/0
        ]).


test_embedded() ->
    test("http://localhost:8888/revtest/index.html",10).


test_standalone() ->
    test("http://localhost:8000/revtest/index.html",100).



test(Uri,Times) ->
    ibrowse:start_link(),
    lists:map(
      fun(I) ->
              Result= case ibrowse:send_req(Uri, [], get) of
                          {ok,Status,_RH,_RB} ->
                              {ok,Status};
                          Value -> Value
                      end,
              io:format("test [~p]: ~p\n", [I,Result]),
              Result
      end,
      lists:seq(1,Times)
     ).
