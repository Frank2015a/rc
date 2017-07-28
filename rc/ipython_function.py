import types
# if not isinstance(arg, types.StringTypes):
# "iterable but not string" http://stackoverflow.com/a/1055378/3625404

# "todo, see also " ls
# use pager -- vim -- to display output of expression, similar but not solved case, How to use Pipe in ipython  http://stackoverflow.com/questions/5740835/how-to-use-pipe-in-ipython

# "ls, see also " todo

def lmap(func, *iterables):
    return list(map(func, *iterables))

def pe(arg):    # print each item if iterable, http://stackoverflow.com/a/1952481/3625404
    # TODO if no arg, print last output
    if isinstance(arg, collections.Iterable) and not isinstance(arg, types.StringTypes):
        for x in arg:
            print(x)
    else:
        print(arg)

def itype(arg):     # print type of iterable of object
    if isinstance(arg, collections.Iterable) and not isinstance(arg, types.StringTypes):
        for x in arg:
            print(type(x))
    else:
        print(type(arg))

def ishape(arg):    # print shape of iterable of numpy array-like object, eg, pandas.DataFrame
    if hasattr(arg, 'shape'):
        print(arg.shape)
    elif isinstance(arg, collections.Iterable) and not isinstance(arg, types.StringTypes):
        for x in arg:
            print(x.shape)
    else:
        raise TypeError("object has no 'shape'")

def dtypes(arg):    # print dtypes of iterable of numpy array-like object, eg, pandas.DataFrame
    if hasattr(arg, 'dtypes'):
        print(arg.dtypes)
    elif isinstance(arg, collections.Iterable) and not isinstance(arg, types.StringTypes):
        for x in arg:
            print(x.dtypes)
    else:
        raise TypeError("object has no 'dtypes'")

