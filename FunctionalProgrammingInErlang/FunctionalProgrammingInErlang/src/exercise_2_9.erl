%% @author JJMMG
%% @doc @todo Add description to exercise_2_9.

-module(exercise_2_9).

%% ====================================================================
%% API functions
%% ====================================================================
-export([double/1, evens/1, median/1, modes/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================

%% Transforming list elements
%% Define an Erlang function double/1 to double the elements of a list of numbers.
%double(L) -> lists:map(fun(X) -> 2*X end, L).
%double(L) -> [2*X || X <- L].
double(L) -> double(L, []).
double([], Acc) -> lists:reverse(Acc);
double([X|Xs], Acc) -> double(Xs, [2*X|Acc]).


%% Filtering lists
%% Define a function evens/1 that extracts the even numbers from a list of integers.
%evens(L) -> lists:filter(fun(X) -> X rem 2 =:= 0 end, L).
%evens(L) -> [X || X <- L, X rem 2 =:= 0].
evens(L) -> evens(L, []).
evens([], Acc) -> lists:reverse(Acc);
evens([X|Xs], Acc) when X rem 2 =:= 0 -> evens(Xs, [X|Acc]); 
evens([_X|Xs], Acc) -> evens(Xs, Acc). 


%% Going further
%% If you want to try some other recursions on lists try to define functions to give:
%%   the median of a list of numbers: this is the middle element when the list is ordered (if the list is of even length you should average the middle two)
%%   the modes of a list of numbers: this is a list consisting of the numbers that occur most frequently in the list; if there is is just one, this will be a list with one element only
median(Unsorted) ->
    Sorted = lists:sort(Unsorted),
    Length = length(Sorted),
    Mid = Length div 2,
    Rem = Length rem 2,
    (lists:nth(Mid+Rem, Sorted) + lists:nth(Mid+1, Sorted)) / 2.

% @todo finish modes
modes(List) ->
    Sorted = lists:sort(List),
	io:format("~p~n~n", [Sorted]),
	lists:sort(fun({_,A}, {_,B}) -> A >= B end, count_equals(tl(Sorted), {hd(Sorted), 1}, [])).

count_equals([], {E,C}, Acc) -> [{E,C} | Acc];
count_equals([X|Xs], {E,C}, Acc) ->
	case X of
		E -> count_equals(Xs, {E,1+C}, Acc);
		_ -> count_equals(Xs, {X,1}, [{E,C} | Acc])
	end.

%exercise_2_9:modes(lists:seq(0,10) ++ lists:seq(1,9) ++ lists:seq(2,8) ++ lists:seq(3,7) ++ lists:seq(4,6) ++ [5]).
