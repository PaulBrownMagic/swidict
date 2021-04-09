:- object(swidict,
	implements(dictionaryp),
	extends(term)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-09,
		comment is 'SWI-Prolog Dictionary Interface'
	]).

	:- use_module(dicts, [
		dict_keys/2 as keys/2
	]).

	as_dictionary(Pairs, Dict) :-
		dict_pairs(Dict, _, Pairs).

	as_list(Dict, Pairs) :-
		dict_pairs(Dict, _, Pairs).

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
		is_dict(OldDict),
		get_dict(Key, OldDict, OldValue, NewDict, NewValue).

	lookup([], _).
	lookup([Key-Value|Pairs], Dict) :-
		lookup(Key, Value, Dict),
		lookup(Pairs, Dict).

	lookup(Key, Value, Dict) :-
		is_dict(Dict),
		get_dict(Key, Dict, Value).

	empty(_{}).

	previous(Dict, Key, Previous, Value) :-
		as_list(Dict, Pairs),
		list::sort(Pairs, Sorted),
		previous_(Sorted, Key, Previous, Value).
	previous_([Previous-Value, Key-_|_Pairs], Key, Previous, Value).
	previous_([K-_, K1-V|Pairs], Key, Previous, Value) :-
		K \= Key,
		K1 \= Key,
		previous_([K1-V|Pairs], Key, Previous, Value).

	next(Dict, Key, Next, Value) :-
		as_list(Dict, Pairs),
		list::sort(Pairs, Sorted),
		next_(Sorted, Key, Next, Value).
	next_([Key-_, Next-Value|_Pairs], Key, Next, Value).
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
		is_dict(OldDict),
		get_dict(Key, OldDict, OldValue),
		call(Closure, Key-OldValue, Key-NewValue),
		put_dict(Key, OldDict, NewValue, NewDict).

	size(Dict, Size) :-
		keys(Dict, Keys),
		list::length(Keys, Size).

	new(_{}).

	check(Dict) :-
		is_dict(Dict).

	valid(Dict) :-
		is_dict(Dict).

:- end_object.
