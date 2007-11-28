# test include statement
.include "subflags.pir"

# test .HLL statement
.HLL "PIRC", "pircgroup"
.pragma n_operators 1


.sub main
# test local declarations
    .local pmc x, y, z
    .local string a, b, c
    .local int i, j
    .local num pi

# test simple expressions
    i = 42
    pi = 3.14
    a = "Hello World"
    b = 'hello world'

# test conditional statements
    if x < y goto X
    unless y > x goto Y

# test multiple labels
X:
Y:
Z:
# test simple function call
    foo(1,2,3)
    .local pmc x, a, b, c
    x = foo(1, 2, 3)
    (a, b, c) = foo()
    $P0 = foo()
    P0 = foo()
    $S0 = foo()
    S0 = foo()
    $I0 = foo()
    I0 = foo()
    $N0 = foo()
    N0 = foo()

    .local pmc I
    .local int P, S, N
    I = P.bar()
    N = S.'bar'()

# test return statements
    .return (1)
    .return (x :flat)
    .return (x :named('z'))
    .return (a, b, c)
    .return (a :flat, b, c :flat :named)

# test yield statements

    .yield (1)
    .yield (a :flat)
    .yield (x :named)
    .yield (b :named('b'))
    .yield (d, e, f)
.end
#
# comments
.sub foo
    .param pmc args :slurpy
    .local int i
    i = args[0]
    print i

# test long return statement
    .begin_return
    .end_return

    .begin_return
    .return p :flat :named('myP')
    .end_return

# test long yield statement
    .begin_yield
    .end_yield

    .begin_yield
    .return q :flat
    .return r :named('myR')
    .return s :flat :named
    .end_yield

    x = null
    null x

# test long subcall
    .begin_call
    .call Y
    .end_call

    .begin_call
    .arg y :flat
    .arg z :named('z')
    .call Z
    .result P0 :slurpy
    .local pmc x
    .result x
    .end_call


.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
