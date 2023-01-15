-module(home_handler).
-export([init/2]).

init(Req0, Opts) ->
    Headers = #{<<"content-type">> => <<"text/plain">>},
    Body = <<"Hello World">>,
    Req = cowboy_req:reply(200, Headers, Body, Req0),
    {ok, Req, Opts}.
