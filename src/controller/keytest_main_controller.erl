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
    H1 = hacker:new(id, <<"jwz">>),   {ok, SavedH1} = H1:save(),
    H2 = hacker:new(id, <<"guido">>), {ok, SavedH2} = H2:save(),
    
    P1 = project:new(id, <<"emacs">>, SavedH1:id()),
    {ok, SavedP1} = P1:save(),
    P2 = project:new(id, <<"netscape">>, SavedH1:id()),
    {ok, SavedP2} = P2:save(),
    P3 = project:new(id, <<"snakes">>, SavedH2:id()),
    {ok, SavedP3} = P3:save(),
    
    ok = boss_db:delete(SavedH1:id()),
    undefined = boss_db:find(SavedH1:id()),
    undefined = boss_db:find(SavedP1:id()),
    undefined = boss_db:find(SavedP2:id()),
    
    {project, _, _, _} = boss_db:find(SavedP3:id()),
    {hacker, _, _} = boss_db:find(SavedH2:id()),
    ok = boss_db:delete(SavedP3:id()),
    ok = boss_db:delete(SavedH2:id()),

    %% -- uuid keytype relation test.
    A1 = author:new(id, <<"joe">>, <<"smith">>), {ok, SavedA1} = A1:save(),
    A2 = author:new(id, <<"bob">>, <<"jones">>), {ok, SavedA2} = A2:save(),
    
    B1 = book:new(id, <<"joe's book">>, SavedA1:id()),
    {ok, SavedB1} = B1:save(),
    B2 = book:new(id, <<"joe's other book">>, SavedA1:id()),
    {ok, SavedB2} = B2:save(),
    B3 = book:new(id, <<"bob's book">>, SavedA2:id()),
    {ok, SavedB3} = B3:save(),

    ok = boss_db:delete(SavedA1:id()),
    undefined = boss_db:find(SavedA1:id()),
    undefined = boss_db:find(SavedB1:id()),
    undefined = boss_db:find(SavedB2:id()),
    
    {book, _, _, _} = boss_db:find(SavedB3:id()),
    {author, _, _, _} = boss_db:find(SavedA2:id()),
    ok = boss_db:delete(SavedB3:id()),
    ok = boss_db:delete(SavedA2:id()),
    


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

