-module(cowboy_metrics_demo_app).

-behaviour(application).

-export([start/2, stop/1]).

-include_lib("kernel/include/logger.hrl").

-define(PORT, 8190).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_', [{"/", home_handler, []}]}]),
    {ok, _} = cowboy:start_clear(http, [{port, ?PORT}], #{env => #{dispatch => Dispatch}}),
    ?LOG_INFO("Cowboy server listening on port ~p", [?PORT]),

    cowboy_metrics_demo_sup:start_link().

stop(_State) ->
    ok.
