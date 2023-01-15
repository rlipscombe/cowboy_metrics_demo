-module(cowboy_metrics_demo_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", home_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(
        http,
        [{port, 8190}],
        #{env => #{dispatch => Dispatch}}
    ),
    cowboy_metrics_demo_sup:start_link().

stop(_State) ->
    ok.
