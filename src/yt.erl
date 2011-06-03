-module(yt).
-compile(export_all).
-include_lib("yaws/include/yaws.hrl").
-include_lib("yaws/include/yaws_api.hrl").


start() ->
    {ok, spawn(?MODULE, run, [])}.

run() ->
    Id = "embedded",
    GconfList = [{id, Id}],
    Docroot = "/tmp",
    SconfList = [
                 {port, 8888},
                 {servername, "foobar"},
                 {listen, {0,0,0,0}},
                 {docroot, Docroot},
                 {revproxy,[
                            {"/revtest",
                             #url{scheme="http",
                                  host="127.0.0.1",
                                  port=80}}
                           ]}
                ],
    {ok, SCList, GC, ChildSpecs} =
        yaws_api:embedded_start_conf(Docroot, SconfList, GconfList, Id),
    [supervisor:start_child(yt_sup, Ch) || Ch <- ChildSpecs],
    yaws_api:setconf(GC, SCList),
    {ok, self()}.
