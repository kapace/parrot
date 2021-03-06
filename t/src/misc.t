#! perl
# Copyright (C) 2001-2010, Parrot Foundation.

use strict;
use warnings;
use lib qw( . lib ../lib ../../lib );
use Test::More;
use Parrot::Test;
use File::Spec::Functions;

plan skip_all => 'src/parrot_config.o does not exist' unless -e catfile(qw/src parrot_config.o/);

plan tests => 3;

=head1 NAME

t/src/misc.t - Parrot miscellaneous utilities

=head1 SYNOPSIS

    % prove t/src/misc.t

=head1 DESCRIPTION

Parrot miscellanea

=cut

sub linedirective
{
    # Provide a #line directive for the C code in the heredoc
    # starting immediately after where this sub is called.
    my $linenum = shift() + 1;
    return "#line " . $linenum . ' "' . __FILE__ . '"' . "\n";
}

c_output_is(linedirective(__LINE__) . <<'CODE', <<'OUTPUT', "Parrot_vsnprintf" );

#include <stdio.h>
#include <stdlib.h>

#include "parrot/parrot.h"
#include "parrot/embed.h"
#include "parrot/misc.h"

void fail(const char *msg);

void fail(const char *msg)
{
    fprintf(stderr, "failed: %s\n", msg);
    exit(EXIT_FAILURE);
}

int main(int argc, const char **argv)
{
    Parrot_Interp interp;
    interp = Parrot_new(NULL);
    if (! interp)
        fail("Cannot create parrot interpreter");
    char buf[11];
    Parrot_snprintf(interp, buf, 11, "test%d", 123456);
    puts(buf);

    Parrot_destroy(interp);
    return 0;
}
CODE
test123456
OUTPUT

c_output_is(linedirective(__LINE__) . <<'CODE', <<'OUTPUT', "Parrot_vsnprintf with len 0" );

#include <stdio.h>
#include <stdlib.h>

#include "parrot/parrot.h"
#include "parrot/embed.h"
#include "parrot/misc.h"

void fail(const char *msg);

void fail(const char *msg)
{
    fprintf(stderr, "failed: %s\n", msg);
    exit(EXIT_FAILURE);
}

int main(int argc, const char **argv)
{
    Parrot_Interp interp;
    interp = Parrot_new(NULL);
    if (! interp)
        fail("Cannot create parrot interpreter");
    char *buf = "unchanged";
    Parrot_snprintf(interp, buf, 0, "");

    if (buf == "unchanged") puts("Done");
    else fail(buf);

    Parrot_destroy(interp);
    return 0;
}
CODE
Done
OUTPUT

c_output_is(linedirective(__LINE__) . <<'CODE', <<'OUTPUT', "Parrot_secret_snprintf", ( todo => "Parrot_secret_snprintf is more sprintf than snprintf"));

#include <stdio.h>
#include <stdlib.h>

#include "parrot/misc.h"

void fail(const char *msg);

void fail(const char *msg)
{
    fprintf(stderr, "failed: %s\n", msg);
    exit(EXIT_FAILURE);
}

int main(int argc, const char **argv)
{
    char buf[10];
    /*
    int res = Parrot_secret_snprintf(buf, 10, "12345678901234567890");
    if (res == 20) puts("Done");
    else fail("snprintf len mismatch");
    */
    printf("THE FAILZ");
    return 0;
}
CODE
Done
OUTPUT

