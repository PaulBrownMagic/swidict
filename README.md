# SWI-Dict

Using SWI-Prolog for your Logtalk backend and want to try using the SWI-Prolog
dictionaries with the Logtalk dictionary protocol (or nested_dictionary
protocol) so you can swap implementations around easily? These are the objects
you're looking for.

- `swidict` is the regular flat dict. Tags are ignored.
- `nswidict` is the nested dictionary interface to `swidict`

It should go without saying, but you need SWI-Prolog as your backend if you're
using these. But if you need to change backend and you've been strict about
only using the dictionary protocol, then you can switch to `avltree`, `bintree`
or `rbtree` easily.

**NB** For all tests to pass you need to be running Logtalk >= 3.46.0
