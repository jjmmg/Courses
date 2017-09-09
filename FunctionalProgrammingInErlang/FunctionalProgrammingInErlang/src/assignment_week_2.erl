%% @author JJMMG
%% @doc @todo Add description to assignment_week_2.

-module(assignment_week_2).

-export([index_file/1]).

index_file(File) ->
	Raw_lines = get_file_contents(File),

	%% Create a dictionary with the format: Word : [L1, L2, ..., Ln], where Word is every valid word
	%% in the text, and Li every line where it was found.
	%% With fold I traverse the list of line index and text lines, result of the zip,
	%% using an empty map as the accumulator.
	Dict_words_lines = lists:foldl(fun process_line/2,
								   orddict:new(),
								   lists:zip(lists:seq(1, length(Raw_lines)), Raw_lines)),

	%% Transform dict values (list of lines) into the format asked in the assignment
	List_words_lines = orddict:to_list(orddict:map(fun transform_dict_values/2, Dict_words_lines)),
	io:format("Result: ~p~n", [List_words_lines]).


%% ====================================================================
%% @doc add/update the entry in the dictionary for every word in a line,
%%      adding the line number (only once per line).  
%% @end
%% ====================================================================
process_line({L_nbr,L_raw}, Dict) ->
	lists:foldl(fun (W, D) ->
						 % orddict:update traverses the whole dict.
						 orddict:update(W,
										fun(S) -> ordsets:add_element(L_nbr, S) end,
										ordsets:add_element(L_nbr, ordsets:new()),
										D)
				end,
				Dict,
				string:tokens(format_line(L_raw), " ")).


%% ====================================================================
%% @doc format a text line by:
%%      changing to lowercase
%%      remove any puntuation
%%      remove short words
%%      force one space betwen words
%% @end
%% ====================================================================
format_line(L) ->
	L1 = re:replace(string:to_lower(L), "[^a-z]", " ", [global, {return, list}]), % lowercase, no puntuation 
    L2 = re:replace(L1, "\\b\\w{1,2}\\b", "", [global, {return, list}]), % remove short words
    string:strip(re:replace(L2, "\\s+", " ", [global, {return, list}])). % one space betwen words


%% ====================================================================
%% @doc tranform a dictionary with the format:
%%          Word : [L1, L2, ..., Ln]
%%      where Word is every valid word in the text, and Li every line where
%%      it was found, into a dictionary with the format:
%%          Word : [{L1,L2}, {L3,L3}, ..., {Ln,Ln}]
%%      where Word is every valid word in the text, and the tuple {Li,Lj} represents
%%      an interval of lines where Word was found. When this tuple has the form {Li,Li}
%%      represents one line alone, Li.
%% @end
%% ====================================================================
transform_dict_values(_K, V) -> transform_dict_values(ordsets:to_list(V)).
transform_dict_values([L|Ls]) -> transform_dict_values(L, L, Ls, []). % The empty list case is not needed.
transform_dict_values(First, Last, [], Acc) -> lists:reverse([{First,Last}|Acc]);
transform_dict_values(First, Last, [Current|Ls], Acc) when Current =:= 1+Last -> transform_dict_values(First, Current, Ls, Acc);
transform_dict_values(First, Last, [Current|Ls], Acc) -> transform_dict_values(Current, Current, Ls, [{First,Last}|Acc]).


%% ====================================================================
% Get the contents of a text file into a list of lines.
% Each line has its trailing newline removed.
%% ====================================================================
get_file_contents(Name) ->
	{ok,File} = file:open(Name,[read]),
	Rev = get_all_lines(File,[]),
	lists:reverse(Rev).


%% ====================================================================
%% Auxiliary function for get_file_contents.
%% ====================================================================
get_all_lines(File,Partial) ->
	case io:get_line(File,"") of
		eof -> file:close(File),
			   Partial;
		Line -> {Strip,_} = lists:split(length(Line)-1,Line),
				get_all_lines(File,[Strip|Partial])
	end.


%% ====================================================================
%% Show the contents of a list of strings.
%% Can be used to check the results of calling get_file_contents.
%% ====================================================================
show_file_contents([L|Ls]) ->
	io:format("~s~n",[L]),
	show_file_contents(Ls);
show_file_contents([]) ->
	ok.    
