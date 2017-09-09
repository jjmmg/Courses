%% @author JJMMG
%% @doc To run all the tests: eunit:test(assignment_week_1).
%% To run the perimeter tests: eunit:test({generator, fun assignment_week_1_tests:perimeter_test_/0}).
%% To run the area tests: eunit:test({generator, fun assignment_week_1_tests:area_test_/0}).
%% To run the enclose tests: eunit:test({generator, fun assignment_week_1_tests:enclose_test_/0}).
%% To run the bits tests eunit:test({generator, fun assignment_week_1_tests:bits_test_/0}).
%% @end


-module(assignment_week_1_tests).


%% ====================================================================
%% API functions
%% ====================================================================
-export([bits_performance/3]).

-include_lib("eunit/include/eunit.hrl").

-import(assignment_week_1, [perimeter/1, area/1, enclose/1, bits/1, bits_direct/1]).


%% ====================================================================
%% Help functions for generating error tets for each shape.
%% ====================================================================
test_error_triangle(F) ->
	[?_assertError(function_clause, F({triangle, {0,1,2}})), % zero arg
	 ?_assertError(function_clause, F({triangle, {-6,2,4}})), % neg arg
	 ?_assertError(function_clause, F({triangle, {5,8,3}})), % invalid triangle
	 ?_assertError(function_clause, F({triangle, {a,8,3}})) % invalid arg type
	].

test_error_square(F) ->
	[?_assertError(function_clause, F({square, 0})), % zero arg
	 ?_assertError(function_clause, F({square, -6})), % neg arg
	 ?_assertError(function_clause, F({square, a})) % invalid arg type
	].

test_error_rectangle(F) ->
	[?_assertError(function_clause, F({rectangle, {0,0}})), % zero arg
	 ?_assertError(function_clause, F({rectangle, {-6,2}})), % neg arg
	 ?_assertError(function_clause, F({rectangle, a})) % invalid arg type
	].

test_error_circle(F) ->
	[?_assertError(function_clause, F({circle, 0})), % zero arg
	 ?_assertError(function_clause, F({circle, -6})), % neg arg
	 ?_assertError(function_clause, F({circle, a})) % invalid arg type
	].


%% ====================================================================
%% perimeter tests
%% ====================================================================
perimeter_test_() ->
	[test_perimeter_triangle(),
	 test_error_triangle(fun assignment_week_1:perimeter/1),
	 test_perimeter_square(),
	 test_error_square(fun assignment_week_1:perimeter/1),
	 test_perimeter_rectangle(),
	 test_error_rectangle(fun assignment_week_1:perimeter/1),
	 test_perimeter_circle(),
	 test_error_circle(fun assignment_week_1:perimeter/1),
	 test_perimeter_extra()
	].

test_perimeter_triangle() -> [?_assertEqual(17, perimeter({triangle, {4,8,5}}))].
test_perimeter_square() -> [?_assertEqual(28, perimeter({square, 7}))].
test_perimeter_rectangle() -> [?_assertEqual(24.8, perimeter({rectangle, {4.4,8}}))].
test_perimeter_circle() -> [?_assertEqual(144.51326206513048, perimeter({circle, 23}))].
test_perimeter_extra() -> [?_assertError(function_clause, perimeter({badger, 0}))].


%% ====================================================================
%% area tests
%% ====================================================================
area_test_() ->
	[test_area_triangle(),
	 test_error_triangle(fun assignment_week_1:area/1),
	 test_area_square(),
	 test_error_square(fun assignment_week_1:area/1),
	 test_area_rectangle(),
	 test_error_rectangle(fun assignment_week_1:area/1),
	 test_area_circle(),
	 test_error_circle(fun assignment_week_1:area/1),
	 test_area_extra()
	].

test_area_triangle() -> [?_assertEqual(8.181534085976786, area({triangle, {4,8,5}}))].
test_area_square() -> [?_assertEqual(49, area({square, 7}))].
test_area_rectangle() -> [?_assertEqual(35.2, area({rectangle, {4.4,8}}))].
test_area_circle() -> [?_assertEqual(1661.9025137490005, area({circle, 23}))].
test_area_extra() -> [?_assertError(function_clause, area({badger, 0}))].

 
%% ====================================================================
%% enclose tests
%% ====================================================================
enclose_test_() ->
	[test_enclose_triangle(),
	 test_error_triangle(fun assignment_week_1:enclose/1),
	 test_enclose_square(),
	 test_error_square(fun assignment_week_1:enclose/1),
	 test_enclose_rectangle(),
	 test_error_rectangle(fun assignment_week_1:enclose/1),
	 test_enclose_circle(),
	 test_error_circle(fun assignment_week_1:enclose/1),
	 test_enclose_extra()
	].

test_enclose_triangle() -> [?_assertMatch({rectangle, {8,2.0453835214941964}}, enclose({triangle, {4,8,5}}))].
test_enclose_square() -> [?_assertMatch({rectangle, {7,7}}, enclose({square, 7}))].
test_enclose_rectangle() -> [?_assertMatch({rectangle, {4.4,8}}, enclose({rectangle, {4.4,8}}))].
test_enclose_circle() -> [?_assertMatch({rectangle, {46,46}}, enclose({circle, 23}))].
test_enclose_extra() -> [?_assertError(function_clause, enclose({badger, 0}))].


%% ====================================================================
%% bits tests
%% ====================================================================
bits_test_() ->
	[?_assertEqual(3, bits(7)),
	 ?_assertEqual(1, bits(8)),
	 ?_assertEqual(0, bits(0)),
	 ?_assertError(function_clause, bits(-786125371263)),
	 ?_assertError(function_clause, bits(a))
	].

%% ====================================================================
%% Check performance of direct and tail versions for bits function
%% ====================================================================

%% Run F function T times, measuring the CPU time spent.
-define(PERF(F, T),
		statistics(runtime),
		[F || _ <- lists:seq(0, T)],
		{_, CPUTime} = statistics(runtime),
		io:format("CPU Time: ~pms~n", [CPUTime])).

bits_performance(tail, Nbr, Times) ->
	?PERF(bits(Nbr), Times);
bits_performance(direct, Nbr, Times) ->
	?PERF(bits_direct(Nbr), Times).
