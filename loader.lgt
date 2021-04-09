:- if((
	current_logtalk_flag(prolog_dialect, swi)
)).

:- initialization((
	logtalk_load([
		meta(loader),
		dictionaries(loader),
		nested_dictionaries(loader)
	]),
	use_module(library(dicts)),
	logtalk_load([
		swidict,
		nswidict
	], [
		optimize(on)
	])

)).
:- else.

:- initialization((
	write('SWI-Prolog Backend required to use SWI-Prolog Dictionaries'), nl
)).

:- endif.
