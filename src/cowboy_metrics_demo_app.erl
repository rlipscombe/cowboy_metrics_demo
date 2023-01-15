-module(cowboy_metrics_demo_app).

-behaviour(application).

-export([start/2, stop/1]).

-include_lib("kernel/include/logger.hrl").

-define(PORT, 8190).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_', [{"/", home_handler, []}]}]),
    {ok, _} =
        cowboy:start_clear(http,
                           [{port, ?PORT}],
                           #{env => #{dispatch => Dispatch},
                             stream_handlers => [cowboy_metrics_h, cowboy_stream_h],
                             metrics_callback => fun metrics_callback/1}),
    ?LOG_INFO("Cowboy server listening on port ~p", [?PORT]),

    cowboy_metrics_demo_sup:start_link().

metrics_callback(_Metrics =
                     #{req := #{method := Method, path := Path},
                       req_start := ReqStart,
                       req_end := ReqEnd,
                       req_body_length := ReqBodyLength,
                       resp_start := RespStart,
                       resp_end := RespEnd,
                       resp_body_length := RespBodyLength,
                       resp_status := StatusCode}) ->
    ?LOG_DEBUG(#{method => Method,
                 path => Path,
                 req_elapsed_us => erlang:convert_time_unit(ReqEnd - ReqStart, native, microsecond),
                 req_body_length => ReqBodyLength,
                 resp_elapsed_us =>
                     erlang:convert_time_unit(RespEnd - RespStart, native, microsecond),
                 resp_body_length => RespBodyLength,
                 resp_status => StatusCode,
                 elapsed_us => erlang:convert_time_unit(RespEnd - ReqStart, native, microsecond)}),
    ok.

stop(_State) ->
    ok.
