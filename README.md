# SWI-Dict
- ![Workflow Status](https://github.com/PaulBrownMagic/swidict/actions/workflows/main.yml/badge.svg)

Using SWI-Prolog for your Logtalk backend and want to try using the SWI-Prolog
dictionaries with the Logtalk dictionary protocol (or nested_dictionary
protocol) so you can swap implementations around easily? These are the objects
you're looking for.

- `swidict` is the regular flat dict. Tags are ignored.
- `nswidict` is the nested dictionary interface to `swidict`

It should go without saying, but you need SWI-Prolog as your backend if you're
using these. But if you need to change backend and you've been strict about
only using the dictionary protocol, then you can switch to the default `avltree`, `bintree`, or `rbtree` implementations easily. For example, by using a `uses/2` directive to make it a
single line change:

```logtalk
:- uses(swidict, [...]).
```

Or if you want to make the change at runtime (at the expense of static binding):

```logtalk
:- object(my_object(_Dict_)).

    :- uses(_Dict_, [...]).
    ...
```

**NB** For all tests to pass you need to be running Logtalk >= 3.46.0
