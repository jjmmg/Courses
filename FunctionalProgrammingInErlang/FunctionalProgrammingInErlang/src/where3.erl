-module(where3).
-export([palin/1,nopunct/1,palindrome/1, test_map/0, print_words_lines/1]).

% palindrome problem
%
% palindrome("Madam I\'m Adam.") = true

palindrome(Xs) ->
    palin(nocaps(nopunct(Xs))).

nopunct([]) ->
    [];
nopunct([X|Xs]) ->
    case lists:member(X,".,\ ;:\t\n\'\"") of
	true ->
	    nopunct(Xs);
	false ->
	    [ X | nopunct(Xs) ]
    end.

nocaps([]) ->
    [];
nocaps([X|Xs]) ->
    [ nocap(X) | nocaps(Xs) ].

nocap(X) ->
    case $A =< X andalso X =< $Z of
	true ->
	    X+32;
	false ->
	    X
    end.

% literal palindrome

palin(Xs) ->
    Xs == reverse(Xs).

reverse(Xs) ->
    shunt(Xs,[]).

shunt([],Ys) ->
    Ys;
shunt([X|Xs],Ys) ->
    shunt(Xs,[X|Ys]).


test_map() ->
	Ls = get_file_contents("D:/Users/JJMMG/git/FunctionalProgrammingInErlang/data/kk.txt"),
	W_map = add_lines(Ls, 1, #{}),
	print_words_lines(W_map).

add_lines([], _L_nbr, W_maps) -> W_maps;
add_lines([L|Ls], L_nbr, W_maps) ->
	io:format("L (~p): ~p~n", [L_nbr, L]),
	Ws = add_words(string:tokens(clear_line(L), " "), L_nbr, W_maps),
	add_lines(Ls, 1+L_nbr, Ws).

add_words([], _L_nbr, W_maps) -> W_maps;
add_words([W|Ws], L_nbr, W_maps) ->
	W_maps_new = maps:update_with(W, fun(S) -> ordsets:add_element(L_nbr, S) end, ordsets:add_element(L_nbr, ordsets:new()), W_maps),
	add_words(Ws, L_nbr, W_maps_new).

clear_line(L) ->
	L1 = re:replace(string:to_lower(L), "[^a-z]", " ", [global, {return, list}]), % lowercase, no puntuation 
    L2 = re:replace(L1, "\\b\\w{1,2}\\b", "", [global, {return, list}]), % remove short words
    string:strip(re:replace(L2, "\\s+", " ", [global, {return, list}])). % one space betwen words
 
% Get the contents of a text file into a list of lines.
% Each line has its trailing newline removed.
get_file_contents(Name) ->
	{ok,File} = file:open(Name,[read]),
	Rev = get_all_lines(File,[]),
	lists:reverse(Rev).


% Auxiliary function for get_file_contents.
get_all_lines(File,Partial) ->
	case io:get_line(File,"") of
		eof -> file:close(File),
			   Partial;
		Line -> {Strip,_} = lists:split(length(Line)-1,Line),
				get_all_lines(File,[Strip|Partial])
	end.

print_words_lines(W_map) ->
%	io:format("Result: ~p~n", [lists:keymap(fun ordsets:to_list/1, 2, maps:to_list(W_map))]).
	io:format("Result: ~p~n", [lists:keymap(fun process_lines/1, 2, maps:to_list(W_map))]).

process_lines(Set) when not is_list(Set) -> process_lines(ordsets:to_list(Set));
process_lines([L|Ls]) -> process_lines(L, L, Ls, []).

process_lines(First, Last, [], Acc) -> lists:reverse([{First,Last}|Acc]);
process_lines(First, Last, [Current|Ls], Acc) when Current =:= 1+Last -> process_lines(First, Current, Ls, Acc);
process_lines(First, Last, [Current|Ls], Acc) -> process_lines(Current, Current, Ls, [{First,Last}|Acc]).


