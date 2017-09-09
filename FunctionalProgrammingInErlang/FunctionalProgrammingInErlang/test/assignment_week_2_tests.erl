%% @author JJMMG
%% @doc @todo Add description to assignment_week_2_tests.


-module(assignment_week_2_tests).


%% ====================================================================
%% API functions
%% ====================================================================

-export([dickens_test/0, gettysburg_test/0, dickens_performance/1, gettysburg_performance/1]).


%% ====================================================================
%% Test
%%
%% assignment_week_2_tests:gettysburg_test().
%% assignment_week_2_tests:dickens_test().
%% assignment_week_2_tests:gettysburg_performance(100).
%% assignment_week_2_tests:dickens_performance(1).
%% ====================================================================

%% Run F function T times, measuring the CPU time spent.
-define(PERF(F, T),
		statistics(runtime),
		[F || _ <- lists:seq(0, T)],
		{_, CPUTime} = statistics(runtime),
		io:format("CPU Time: ~pms~n", [CPUTime])).

dickens_performance(Times) ->
	?PERF(dickens_test(), Times).

gettysburg_performance(Times) ->
	?PERF(gettysburg_test(), Times).

dickens_test() ->
	assignment_week_2:index_file("D:/Users/JJMMG/git/FunctionalProgrammingInErlang/data/dickens-christmas.txt").

gettysburg_test() ->
	assignment_week_2:index_file("D:/Users/JJMMG/git/FunctionalProgrammingInErlang/data/gettysburg-address.txt").
