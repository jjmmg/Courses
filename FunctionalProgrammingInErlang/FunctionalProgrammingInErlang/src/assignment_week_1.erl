%% @author JJMMG
%% @doc Week 1 assignment: Shapes.
%%      Define a function perimeter/1 which takes a shape and returns the perimeter of the shape.
%%      Choose a suitable representation of triangles, and augment area/1 and perimeter/1 to handle this case too.
%%      Define a function enclose/1 that takes a shape an returns the smallest enclosing rectangle of the shape.
%%      Tests provided. See assignment_week_1_tests.
%% @todo Format documentation


-module(assignment_week_1).


%% ====================================================================
%% API functions
%% ====================================================================
-export([perimeter/1, area/1, enclose/1, bits/1, bits_direct/1]).


%% ====================================================================
%% @doc perimeter function for triangle, square, rectangle, circle.
%%      For triangle guards see @reference <a href="https://en.wikipedia.org/wiki/Triangle_inequality">Triangle inequality</a>
%% @end
%% ====================================================================
perimeter({triangle, {A,B,C}}) when is_number(A), is_number(B), is_number(C), A+B>C, A+C>B, B+C>A -> A+B+C;
perimeter({square, A}) when is_number(A), A>0 -> 4*A;
perimeter({rectangle, {A,B}}) when is_number(A), is_number(B), A>0, B>0 -> 2*(A+B);
perimeter({circle, R}) when is_number(R), R>0 -> 2*math:pi()*R.


%% ====================================================================
%% @doc area function for triangle, square, rectangle, circle.
%%      For triangle guards see https://en.wikipedia.org/wiki/Triangle_inequality
%% @end
%% ====================================================================
area({triangle, {A,B,C}}) when is_number(A), is_number(B), is_number(C), A+B>C,A+C>B,B+C>A ->
	S = (A+B+C)/2,
	math:sqrt(S*(S-A)*(S-B)*(S-C));
area({square, A}) when is_number(A), A>0 -> A*A;
area({rectangle, {A, B}}) when is_number(A), is_number(B), A>0, B>0 -> A*B;
area({circle, R}) when is_number(R), R>0 -> math:pi()*R*R.


%% ====================================================================
%% @doc enclose function for triangle, square, rectangle, circle.
%%      For triangle guards see https://en.wikipedia.org/wiki/Triangle_inequality
%% @end
%% ====================================================================
enclose({triangle, {A,B,C}}) when is_number(A), is_number(B), is_number(C), A+B>C,A+C>B,B+C>A ->
  W = lists:max([A,B,C]),
  Y = area({triangle, {A,B,C}}),
  H = Y/(0.5*W),
  {rectangle, {W,H}};
enclose({square,A}) when is_number(A), A>0 -> {rectangle, {A,A}};
enclose({rectangle, {A,B}}) when is_number(A), is_number(B), A>0, B>0 -> {rectangle, {A,B}};
enclose({circle,R}) when is_number(R), R>0 ->
  D = 2*R,
  {rectangle, {D,D}}.


%% ====================================================================
%% @doc bits function in direct (bits_direct/1) and tail recursive (bits/1) forms.
%%      Performance tests where done (available in assignment_week_1_tests file)
%%      to measure the time spent counting bits in number 2#111111111111111111111111111111, for 1000000 times.
%%          tail recursion spent 702ms
%%          direct recursion spent 952ms
%%      We can see the better performance of the tail version, regarding CPU time.
%%      Although someone could say that the direct version is more readable.
%% @end
%% ====================================================================

%% Direct recursion
bits_direct(0) -> 0;
bits_direct(N) when is_number(N), N>=0 -> 1 + bits_direct(N band (N-1)).

%% Tail recursion
bits(N) when is_number(N), N>=0 -> bits(N, 0).
bits(0, Acc) -> Acc;
bits(N, Acc) -> bits(N band (N-1), Acc+1).
