:- if(current_logtalk_flag(prolog_dialect, swi)).
	:- initialization((
		set_logtalk_flag(report, warnings),
		use_module(library(dicts)),
		logtalk_load([
			meta(loader),
			dictionaries(loader),
			nested_dictionaries(loader)
		]),
		logtalk_load(lgtunit(loader)),
		logtalk_load([
			swidict,
			nswidict
		], [
			source_data(on),
			debug(on)
		]),
		logtalk_load([dictionaries(tests)], [hook(lgtunit)]),
		tests(swidict)::run,
		logtalk_load(nested_dictionaries(tests), [hook(lgtunit)]),
		tests(nswidict)::run
	)).
:- else.
	:- initialization((
		write('SWI-Prolog Backend required to use SWI-Prolog Dictionaries'), nl
	)).
:- endif.
