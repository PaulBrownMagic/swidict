:- object(nswidict,
    implements(nested_dictionary_protocol),
    extends(private::swidict)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-09,
		comment is 'Nested Dictionary implementation based on the AVL tree implementation.',
		see_also is [nrbtree, nbintree, navltree, swidict]
	]).

	:- include(nested_dictionaries(nested_dictionary)).

:- end_object.
