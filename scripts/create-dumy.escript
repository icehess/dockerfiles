#!/usr/bin/env escript
%%! +A0
%% -*- coding: utf-8 -*-

-mode(compile).

-export([main/1]).

-define(DEFAULT_CRED, kz_term:to_hex_binary(crypto:hash('md5', <<"admin:admin">>))).
-define(DEFAULT_HOST, "127.0.0.1:8000").
-define(URL(Opts, Path), "http://" ++ maps:get(host, Opts) ++ "/v2/" ++ Path).
-define(HEADERS, [{"Content-Type", "application/json"}]).
-define(HEADERS(Hs), props:insert_value("Content-Type", "application/json", Hs)).
-define(AUTH_HEADERS(Opts), ?HEADERS([{<<"X-Auth-Token">>, maps:get(token, Opts)}])).

-define(USER_DATA(Start, I)
       ,kz_json:from_list_recursive(
          [{<<"data">>
           ,[{<<"caller_id">>, [{<<"internal">>, [{<<"name">>,<<"Test", (kz_term:to_binary(Start + I))/binary, " Internal">>}, {<<"number">>, kz_term:to_binary(Start + I)}]}
                               ,{<<"external">>, [{<<"name">>,<<"Test", (kz_term:to_binary(Start + I))/binary, " External">>}, {<<"number">>, kz_term:to_binary(Start + I)}]}
                               ,{<<"emergency">>, [{<<"name">>,<<"Test", (kz_term:to_binary(Start + I))/binary, " External">>}, {<<"number">>, kz_term:to_binary(Start + I)}]}
                               ]
             }
            ,{<<"presence_id">>, kz_term:to_binary(Start + I)}
            ,{<<"email">>, <<"test_", (kz_term:to_binary(Start + I))/binary, "@test.com">>}
            ,{<<"priv_level">>, <<"user">>}
            ,{<<"first_name">>, <<"Test", (kz_term:to_binary(Start + I))/binary>>}
            ,{<<"last_name">>, <<"Last", (kz_term:to_binary(Start + I))/binary>>}
            ,{<<"username">>, <<"test_", (kz_term:to_binary(Start + I))/binary, "@test.com">>}
            ,{<<"password">>, <<"qwerty">>}
            ,{<<"send_email_on_creation">>, false}
            ,{<<"ui_metadata">>, [{<<"version">>, <<"4.3.0">>}
                                 ,{<<"ui">>, <<"monster-ui">>}
                                 ,{<<"origin">>,<<"voip">>}
                                 ]
             }
            ]
           }
          ,{<<"accept_charges">>, true}
          ]
         )
       ).

-define(VMBOX_DATA(Start, Int, OwnerId)
       ,kz_json:from_list_recursive(
          [{<<"data">>
           ,[{<<"mailbox">>, kz_term:to_binary(Start + Int)}
            ,{<<"name">>, <<(kz_term:to_binary(Start + Int))/binary, " VMBox">>}
            ,{<<"owner_id">>, OwnerId}
            ,{<<"ui_metadata">>
             ,[{<<"version">>,<<"4.3.0">>}
              ,{<<"ui">>,<<"monster-ui">>}
              ,{<<"origin">>,<<"voip">>}
              ]
             }
          ,{<<"accept_charges">>, true}
            ]
           }])
       ).

-define(CALLFLOW_DATA(Start, Int, OwnerId, VmBoxId)
       ,kz_json:from_list_recursive(
          [{<<"data">>
           ,[{<<"contact_list">>, [{<<"exclude">>, false}]}
            ,{<<"flow">>
             ,[{<<"children">>, [{<<"_">>, [{<<"children">>, [{}]}, {<<"data">>, [{<<"id">>, VmBoxId}]}, {<<"module">>, <<"voicemail">>}]}]}
              ,{<<"data">>, [{<<"can_call_self">>, false}, {<<"timeout">>, 20}, {<<"id">>, OwnerId}]}
              ,{<<"module">>,<<"user">>}
              ]
             }
            ,{<<"name">>,<<(kz_term:to_binary(Start + Int))/binary, " SmartPBX's Callflow">>}
            ,{<<"numbers">>, [kz_term:to_binary(Start + Int)]}
            ,{<<"owner_id">>, OwnerId}
            ,{<<"type">>, <<"mainUserCallflow">>}
            ,{<<"ui_metadata">>
             ,[{<<"version">>, <<"4.3.0">>}
              ,{<<"ui">>, <<"monster-ui">>}
              ,{<<"origin">>, <<"voip">>}
              ]
             }
            ]
           }
          ,{<<"accept_charges">>, true}
          ])
       ).

-define(DEVICE_DATA(Start, Int, OwnerId, Realm)
       ,kz_json:from_list_recursive(
          [{<<"data">>
           ,[{<<"sip">>
             ,[{<<"password">>, <<"qwerty">>}
              ,{<<"realm">>, Realm}
              ,{<<"username">>, <<"device_", (kz_term:to_binary(Start + Int))/binary>>}
              ]
             }
            ,{<<"call_restriction">>
             ,[{<<"caribbean">>, [{<<"action">>, <<"inherit">>}]}
              ,{<<"did_us">>, [{<<"action">>, <<"inherit">>}]}
              ,{<<"emergency">>, [{<<"action">>, <<"inherit">>}]}
              ,{<<"international">>, [{<<"action">>, <<"inherit">>}]}
              ,{<<"toll_us">>, [{<<"action">>, <<"inherit">>}]}
              ,{<<"tollfree_us">>, [{<<"action">>, <<"inherit">>}]}
              ,{<<"unknown">>, [{<<"action">>, <<"inherit">>}]}
              ]
             }
            ,{<<"device_type">>, <<"sip_device">>}
            ,{<<"enabled">>, true}
            ,{<<"media">>
             ,[{<<"encryption">>, [{<<"enforce_security">>, false}]}
              ,{<<"audio">>, [{<<"codecs">>, [<<"PCMU">>, <<"PCMA">>]}]}
              ]
             }
            ,{<<"owner_id">>, OwnerId}
            ,{<<"suppress_unregister_notifications">>, true}
            ,{<<"name">>, <<"device_", (kz_term:to_binary(Start + Int))/binary>>}
            ,{<<"ignore_completed_elsewhere">>, false}
            ,{<<"ui_metadata">>
             ,[{<<"version">>, <<"4.3.0">>}
              ,{<<"ui">>, <<"monster-ui">>}
              ,{<<"origin">>, <<"voip">>}
              ]
             }
            ]
           }
          ,{<<"accept_charges">>, true}
          ])
       ).

main(Args) ->
    _ = io:setopts(user, [{encoding, unicode}]),
    _ = application:ensure_all_started(inets),
    case parse_args(Args, #{host => ?DEFAULT_HOST
                           ,cred => ?DEFAULT_CRED
                           ,start_user => 3000
                           }
                   )
    of
        #{account_id := _}=Opts ->
            io:format(":: Opts ~p~n~n", [Opts]),
            case maps:get(user, Opts, maps:get(account, Opts, undefined)) of
                'undefined' ->
                    io:format(":: no operation is given~n"),
                    io:put_chars("\n"),
                    exit(1);
                _ ->
                    get_auth_token(Opts)
            end;
        _ ->
            io:format("no account id is given~n"),
            io:put_chars("\n"),
            exit(1)
    end.

get_auth_token(#{token := _
                ,account_id := AccountId
                }=Opts) ->
    io:format(":: fetching account definition~n"),
    {ok, JObj} = http_get("accounts/" ++ AccountId, Opts),
    perform_action(Opts#{realm => kz_json:get_value(<<"realm">>, JObj)
                        });
get_auth_token(#{username := Username
                ,password := Password
                ,acc_name := AccountName
                }=Opts) ->
    Creds = list_to_binary([Username, ":", Password]),
    MD5 = kz_term:to_hex_binary(crypto:hash('md5', Creds)),
    Data = kz_json:from_list_recursive([{<<"data">>, [{<<"credentials">>, MD5}
                                                     ,{<<"account_name">>, AccountName}
                                                     ]}]),
    io:format(":: performing authentication...~n"),
    case kz_http:put(?URL(Opts, "user_auth"), ?HEADERS, kz_json:encode(Data)) of
        {'ok', 201, _, Resp} ->
            Decoded = kz_json:decode(Resp),
            case kz_json:get_value(<<"status">>, Decoded) of
                <<"success">> ->
                    io:format(":: auth: ~p~n~n", [kz_json:get_value(<<"auth_token">>, Decoded)]),
                    get_auth_token(Opts#{token => kz_term:to_list(kz_json:get_value(<<"auth_token">>, Decoded))});
                _ ->
                    io:put_chars([":: unable to authenticate:\n", kz_json:encode(Decoded, [pretty]), "\n"]),
                    io:put_chars("\n"),
                    exit(1)
            end;
        _Error ->
            io:format(":: unable to authenticate:~n~p~n", [_Error]),
            io:put_chars("\n"),
            exit(1)
    end;
get_auth_token(_) ->
    io:format(":: no auth token or any password/username/account_name are given~n"),
    io:put_chars("\n"),
    exit(1).

perform_action(#{account := _}) ->
    io:format("creating account is not implemented~n"),
    io:put_chars("\n"),
    exit(1);
perform_action(#{user := Count
                ,account_id := AccountId
                }=Opts) ->
    io:format(":: creating ~b users~n~n", [Count]),
    safety_first({"users", AccountId}, Opts, Count);
perform_action(_)  ->
    io:format(":: no operation is given~n"),
    io:put_chars("\n"),
    exit(1).

safety_first(Operation, Opts, Count) when Count > 0 ->
    Ints = lists:seq(1, Count),
    safety_first(Operation, Opts, #{}, Ints);
safety_first(_, _, _) ->
    io:format("please set counts bigger than zero~n"),
    io:put_chars("\n"),
    exit(1).

safety_first(_, _, _, []) ->
    io:format(":: finished!~n");
safety_first(Operation, Opts, IdsMap, [Int | Ints]) ->
    try perform_operation(Operation, Int, IdsMap, Opts) of
        NewMap -> safety_first(Operation, Opts, NewMap, Ints)
    catch
        throw:{'error', NewMap} ->
            rollback(NewMap, Opts),
            io:put_chars("\n"),
            exit(1);
        _E:_T ->
            io:format("error safety: ~p:~p~n", [_E, _T]),
            ST = erlang:get_stacktrace(),
            io:format("ST: ~p~n~n", [ST]),
            io:put_chars("\n"),
            rollback(IdsMap, Opts),
            io:put_chars("\n"),
            exit(1)
    end.

internal_safety_first(Operation, Int, IdsMap, Opts) ->
    try perform_operation(Operation, Int, IdsMap, Opts)
    catch
        throw:{'error', NewMap} ->
            throw({'error', NewMap});
        _E:_T ->
            io:format("error internal_safety: ~p:~p~n", [_E, _T]),
            ST = erlang:get_stacktrace(),
            io:format("ST: ~p~n~n", [ST]),
            io:put_chars("\n"),
            throw({'error', IdsMap})
    end.

perform_operation({"users", AccountId}, Int, IdsMap, #{start_user := Start}=Opts) ->
    io:format("~b:~n", [Int]),
    Data = ?USER_DATA(Start, Int),
    Url = "accounts/" ++ AccountId ++ "/users",
    Map0 = create_object("users", Url, Data, IdsMap, Opts),
    Id = hd(maps:get("users", Map0)),
    Map1 = internal_safety_first({"vmboxes", Id}, Int, Map0, Opts),
    Map2 = internal_safety_first({"callflows", Id, hd(maps:get("vmboxes", Map1))}, Int, Map1, Opts),
    internal_safety_first({"devices", Id}, Int, Map2, Opts);
perform_operation({"vmboxes", OwnerId}, Int, IdsMap, #{account_id := AccountId
                                                      ,start_user := Start
                                                      }=Opts) ->
    Data = ?VMBOX_DATA(Start, Int, OwnerId),
    Url = "accounts/" ++ AccountId ++ "/vmboxes",
    create_object("vmboxes", Url, Data, IdsMap, Opts);
perform_operation({"callflows", OwnerId, VmBoxId}, Int, IdsMap, #{account_id := AccountId
                                                                 ,start_user := Start
                                                                 }=Opts) ->
    Data = ?CALLFLOW_DATA(Start, Int, OwnerId, VmBoxId),
    Url = "accounts/" ++ AccountId ++ "/callflows",
    create_object("callflows", Url, Data, IdsMap, Opts);
perform_operation({"devices", OwnerId}, Int, IdsMap, #{account_id := AccountId
                                                      ,start_user := Start
                                                      ,realm := Realm
                                                      }=Opts) ->
    Data = ?DEVICE_DATA(Start, Int, OwnerId, Realm),
    Url = "accounts/" ++ AccountId ++ "/devices",
    create_object("devices", Url, Data, IdsMap, Opts).

create_object(Endpoint, Url, Data, IdsMap, Opts) ->
    case http_put(Url, Data, Opts) of
        {'ok', JObj} ->
            case kz_doc:id(JObj) of
                'undefined' -> IdsMap;
                Id -> IdsMap#{Endpoint => [Id | maps:get(Endpoint, IdsMap, [])]}
            end;
        {'error', JObj} ->
            case kz_doc:id(JObj) of
                'undefined' -> throw({'error', IdsMap});
                Id -> throw({'error', IdsMap#{Endpoint => [Id | maps:get(Endpoint, IdsMap, [])]}})
            end
    end.

rollback(IdsMap, Opts) ->
    _ = maps:map(fun(K, V) ->
                         io:format(":: rolling back ~s~n", [K]),
                         do_rollback(K, V, Opts)
                 end
                ,IdsMap
                ),
    'ok'.

do_rollback(_, [], _) ->
    'ok';
do_rollback(Endpoint, [Id | Ids], #{account_id := AccountId}=Opts) ->
    _ = http_delete("accounts/" ++ AccountId ++ "/" ++ Endpoint ++ "/" ++ Id, Opts),
    do_rollback(Endpoint, Ids, Opts).

http_put(Url, Data, Opts) ->
    execute_request(put, [201], Url, Data, Opts).

http_delete(Url, Opts) ->
    execute_request(delete, [200], Url, [], Opts).

http_get(Url, Opts) ->
    execute_request(get, [200], Url, [], Opts).

execute_request(Method, Expected, Path, Data0, Opts) ->
    io:format("   - ~s ~s: ", [Method, Path]),
    Data = case Data0 of
               [] -> [];
               _ -> kz_json:encode(Data0)
            end,
    case kz_http:req(Method, ?URL(Opts, Path), ?AUTH_HEADERS(Opts), Data) of
        {'ok', Status, _, Resp} ->
            Decoded = try_decode_resp(Resp),
            RespData = kz_json:get_json_value(<<"data">>, Decoded, kz_json:new()),
            case lists:member(Status, Expected) of
                'true' ->
                    case kz_json:get_value(<<"status">>, Decoded) of
                        <<"success">> ->
                            io:format("~b (~s)~n", [Status, kz_doc:id(RespData)]),
                            {'ok', RespData};
                        _ ->
                            io:format("failed (~s)~n Resp ~p~n~n", [kz_json:id(RespData), kz_json:delete_key(<<"auth_token">>, Decoded)]),
                            {'error', RespData}
                    end;
                'false' ->
                    io:format("got ~b not ~w~n Resp ~p~n~n", [Status, Expected, kz_json:delete_key(<<"auth_token">>, Decoded)]),
                    {'error', RespData}
            end;
        _Error ->
            io:format("error~n Resp ~p~n", [_Error]),
            {'error', kz_json:new()}
    end.

try_decode_resp(Resp) ->
    try kz_json:decode(Resp)
    catch _:_ -> kz_json:new()
    end.

parse_args([], Acc) ->
    Acc;
parse_args(["--create-account", Count | Rest], Acc) ->
    try kz_term:to_integer(Count) of
        Int -> parse_args(Rest, Acc#{account => maps:get(account, Acc, 0) + Int})
    catch
        _:_ ->
            io:format("must be specify an integer for number of account~n"),
            exit(1)
    end;
parse_args(["--auth-token", AuthToken | Rest], Acc) ->
    case AuthToken of
        "--"++_ ->
            io:format("invalid auth token~n"),
            exit(1);
        _ -> parse_args(Rest, Acc#{token => AuthToken})
    end;
parse_args(["--create-user", Count | Rest], Acc) ->
    try kz_term:to_integer(Count) of
        Int -> parse_args(Rest, Acc#{user => maps:get(user, Acc, 0) + Int})
    catch
        _:_ ->
            io:format("must be specify an integer for number of user~n"),
            exit(1)
    end;
parse_args(["--start-user", Count | Rest], Acc) ->
    try kz_term:to_integer(Count) of
        Int -> parse_args(Rest, Acc#{start_user => Int})
    catch
        _:_ ->
            io:format("must be specify an integer for start user~n"),
            exit(1)
    end;
parse_args(["--account-id", AccountId | Rest], Acc) ->
    case AccountId of
        "--"++_ ->
            io:format("invalid account id~n"),
            exit(1);
        _ -> parse_args(Rest, Acc#{account_id_b => kz_term:to_binary(AccountId)
                                  ,account_id => AccountId
                                  })
    end;
parse_args(["--username", Username | Rest], Acc) ->
    case Username of
        "--"++_ ->
            io:format("invalid api username~n"),
            exit(1);
        _ -> parse_args(Rest, Acc#{username => Username})
    end;
parse_args(["--password", Password | Rest], Acc) ->
    case Password of
        "--"++_ ->
            io:format("invalid api password~n"),
            exit(1);
        _ -> parse_args(Rest, Acc#{password => Password})
    end;
parse_args(["--account-name", AccountName | Rest], Acc) ->
    case AccountName of
        "--"++_ ->
            io:format("invalid api account name~n"),
            exit(1);
        _ -> parse_args(Rest, Acc#{acc_name => AccountName})
    end;
parse_args(["--host", Host | Rest], Acc) ->
    case Host of
        "--"++_ ->
            io:format("invalid api base host~n"),
            exit(1);
        _ -> parse_args(Rest, Acc#{host => Host})
    end;
parse_args([_ | Rest], Acc) ->
    parse_args(Rest, Acc).

