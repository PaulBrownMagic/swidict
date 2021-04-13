:- object(swidict,
	implements(dictionaryp),
	extends(term)).

	:- info([
		version is 1:1:0,
		author is 'Paul Brown',
		date is 2021-04-12,
		comment is 'SWI-Prolog Dictionary Interface'
	]).

	:- use_module(dicts, [
		dict_keys/2 as keys/2
	]).

	:- use_module(library(lists), [
		member/2, memberchk/2
	]).

	as_dictionary(Pairs, Dict) :-
		dict_pairs(Dict, _, Pairs).

	as_list(Dict, Pairs) :-
		dict_pairs(Dict, _, Pairs).

	as_curly_bracketed(Dict, Curly) :-
		dict_pairs(Dict, _, Pairs),
		pairs_to_curly(Pairs, Curly).

	pairs_to_curly([], {}).
	pairs_to_curly([Pair| Pairs], {Term}) :-
		pairs_to_curly(Pairs, Pair, Term).

	pairs_to_curly([], Pair, Pair).
	pairs_to_curly([NextPair| Pairs], Pair, (Pair, RestPairs)) :-
		pairs_to_curly(Pairs, NextPair, RestPairs).

	clone(Dict, CloneDict, ClonePairs) :-
		clone(Dict, _, CloneDict, ClonePairs).

	clone(Dict, Pairs, CloneDict, ClonePairs) :-
		as_list(Dict, Pairs),
		meta::map([K-_, K-_]>>true, Pairs, ClonePairs),
		as_dictionary(ClonePairs, CloneDict).

	insert(OldDict, Key, Value, NewDict) :-
		nonvar(Key),
		put_dict(Key, OldDict, Value, NewDict).

	delete(OldDict, Key, Value, NewDict) :-
		nonvar(Key),
		del_dict(Key, OldDict, Value, NewDict).

	update(OldDict, [], OldDict).
	update(OldDict, [K-V|Pairs], NewDict) :-
		lookup(K, _, OldDict),
		put_dict(K, OldDict, V, AccDict),
		update(AccDict, Pairs, NewDict).

	update(OldDict, Key, Value, NewDict) :-
		update(OldDict, Key, _, Value, NewDict).

	update(OldDict, Key, OldValue, NewValue, NewDict) :-
		nonvar(Key),
		is_dict(OldDict),
		get_dict(Key, OldDict, OldValue, NewDict, NewValue).

	lookup(Pairs, Dict) :-
		is_dict(Dict),
		lookup2(Pairs, Dict).
	lookup2([], _).
	lookup2([Key-Value|Pairs], Dict) :-
		get_dict(Key, Dict, Value),
		lookup2(Pairs, Dict).

	lookup(Key, Value, Dict) :-
		is_dict(Dict),
		get_dict(Key, Dict, Value).

	intersection(Dict1, Dict2) :-
		is_dict(Dict1),
		is_dict(Dict2),
		Dict1 >:< Dict2.

	intersection(Dict1, Dict2, Intersection) :-
		is_dict(Dict1),
		is_dict(Dict2),
		Dict1 >:< Dict2,
		dict_pairs(Dict1, _, Pairs1),
		dict_pairs(Dict2, _, Pairs2),
		findall(Pair, (member(Pair, Pairs1), memberchk(Pair, Pairs2)), Pairs),
		dict_pairs(Intersection, _, Pairs).

	empty(Dict) :-
		is_dict(Dict),
		Dict = _{}.

	previous(Dict, Key, Previous, Value) :-
		as_list(Dict, Pairs),
		list::sort(Pairs, Sorted),
		previous_(Sorted, Key, Previous, Value).
	previous_([Previous-Value, Key-_|_Pairs], Key, Previous, Value) :- !.
	previous_([K-_, K1-V|Pairs], Key, Previous, Value) :-
		K \= Key,
		K1 \= Key,
		previous_([K1-V|Pairs], Key, Previous, Value).

	next(Dict, Key, Next, Value) :-
		as_list(Dict, Pairs),
		list::sort(Pairs, Sorted),
		next_(Sorted, Key, Next, Value).
	next_([Key-_, Next-Value|_Pairs], Key, Next, Value) :- !.
	next_([K-_|Pairs], Key, Next, Value) :-
		K \= Key,
		next_(Pairs, Key, Next, Value).

	min(Dict, Key, Value) :-
		as_list(Dict, Pairs),
		list::min(Pairs, Key-Value).

	max(Dict, Key, Value) :-
		as_list(Dict, Pairs),
		list::max(Pairs, Key-Value).

	delete_min(OldDict, Key, Value, NewDict) :-
		min(OldDict, Key, Value),
		del_dict(Key, OldDict, Value, NewDict).

	delete_max(OldDict, Key, Value, NewDict) :-
		max(OldDict, Key, Value),
		del_dict(Key, OldDict, Value, NewDict).

	values(Dict, Values) :-
		as_list(Dict, Pairs),
		pairs::values(Pairs, Values).

	:- meta_predicate(map(1, *)).
	map(Closure, Dict) :-
		as_list(Dict, Pairs),
		meta::map(Closure, Pairs).

	:- meta_predicate(map(2, *, *)).
	map(Closure, OldDict, NewDict) :-
		as_list(OldDict, Pairs),
		meta::map(Closure, Pairs, NewPairs),
		as_dictionary(NewPairs, NewDict).

	:- meta_predicate(apply(2, *, *, *)).
	apply(Closure, OldDict, Key, NewDict) :-
		lookup(Key, OldValue, OldDict),
		call(Closure, Key-OldValue, Key-NewValue),
		put_dict(Key, OldDict, NewValue, NewDict).

	size(Dict, Size) :-
		keys(Dict, Keys),
		list::length(Keys, Size).

	new(_{}).

	check(Dict) :-
		(	is_dict(Dict)
		->	true
		;	var(Dict)
		->	instantiation_error
		;	type_error(swidict, Dict)
		).

	valid(Dict) :-
		is_dict(Dict).

:- end_object.
