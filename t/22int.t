use Test;
BEGIN { plan tests => 4 }
use Inline Config => DIRECTORY => './blib_test';
use Inline::Python qw(py_call_function);
use Inline Python => <<'END';

def get_int():
    return 10

def test(i):
    return type(i)

def PyVersion(): import sys; return sys.version_info[0]

END

ok(py_call_function('__main__', 'get_int'), 10, 'int arrives as int');
if (PyVersion() == 3) {
	ok(py_call_function('__main__', 'test', 4), "<class 'int'>", 'int arrives as int');
	ok(py_call_function('__main__', 'test', '4'), "<class 'str'>", 'string that looks like a number arrives as string');
	ok(py_call_function('__main__', 'test', py_call_function('__main__', 'get_int')), "<class 'int'>", 'int from python to perl to python is still an int');
}
else {
	ok(py_call_function('__main__', 'test', 4), "<type 'int'>", 'int arrives as int');
	ok(py_call_function('__main__', 'test', '4'), "<type 'str'>", 'string that looks like a number arrives as string');
	ok(py_call_function('__main__', 'test', py_call_function('__main__', 'get_int')), "<type 'int'>", 'int from python to perl to python is still an int');
}
