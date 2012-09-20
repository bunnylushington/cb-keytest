-module(keytest_main_controller, [Req]).
-compile(export_all).

%% NB: failing tests might cause crashes.
test('GET', []) ->
    %% -- serial keytype CRUD test.
    S1 = serialkey:new(id, <<"s key one">>), {ok, SavedS1} = S1:save(),
    S2 = serialkey:new(id, <<"s key two">>), {ok, SavedS2} = S2:save(),
    FoundS1 = boss_db:find(SavedS1:id()),
    FoundS2 = boss_db:find(SavedS2:id()),
    NewS1 = SavedS1:set(name, <<"new name">>), {ok, NewSavedS1} = NewS1:save(),
    NewS2 = SavedS2:set(name, <<"new name">>), {ok, NewSavedS2} = NewS2:save(),
    ok = boss_db:delete(SavedS1:id()), undefined = boss_db:find(SavedS1:id()),
    ok = boss_db:delete(SavedS2:id()), undefined = boss_db:find(SavedS2:id()),

    %% -- uuid keytype CRUD test.
    U1 = uuidkey:new(id, <<"u key one">>), {ok, SavedU1} = U1:save(),
    U2 = uuidkey:new(id, <<"u key two">>), {ok, SavedU2} = U2:save(),
    FoundU1 = boss_db:find(SavedU1:id()),
    FoundU2 = boss_db:find(SavedU2:id()),
    NewU1 = SavedU1:set(name, <<"new name">>), {ok, NewSavedU1} = NewU1:save(),
    NewU2 = SavedU2:set(name, <<"new name">>), {ok, NewSavedU2} = NewU2:save(),
    ok = boss_db:delete(SavedU1:id()), undefined = boss_db:find(SavedU1:id()),
    ok = boss_db:delete(SavedU2:id()), undefined = boss_db:find(SavedU2:id()),

    %% -- serial keytype relation test.
    

    {ok, [{results, 
           [
            % serial CRUD.
            eq_result(FoundS1, SavedS1, "Serial One"),
            eq_result(FoundS2, SavedS2, "Serial Two"),
            eq_result(is_integer(list_to_integer(id_only(FoundS1))), 
                      "Serial One Int Key"),
            eq_result(is_integer(list_to_integer(id_only(FoundS2))), 
                      "Serial Two Int Key"),
            eq_result(NewS1, NewSavedS1, "Update Serial One"),
            eq_result(NewS2, NewSavedS2, "Update Serial Two"),

            % uuid CRUD.
            eq_result(FoundU1, SavedU1, "UUID One"),
            eq_result(FoundU2, SavedU2, "UUID Two"),
            eq_result(uuid:is_v4(id_only(FoundU1)), "UUID One v4 Key"),
            eq_result(uuid:is_v4(id_only(FoundU2)), "UUID Two v4 Key"),
            eq_result(NewU1, NewSavedU1, "Update UUID One"),
            eq_result(NewU2, NewSavedU2, "Update UUID Two")
           ]}]}.


eq_result(T1, Msg) ->
    io_lib:format("~p:      ~p~n", [T1, Msg]).
eq_result(T1, T2, Msg) ->
    io_lib:format("~p:      ~p~n     ~p =:= ~p~n", [T1 =:= T2, Msg, T1, T2]).

id_only(Rec) ->
    [_, ID] = re:split(Rec:id(), "-", [{parts, 2}, {return, list}]),
    ID.

