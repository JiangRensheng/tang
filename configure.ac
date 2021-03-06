AC_PREREQ(2.59)
AC_INIT(tang, 7)
AC_CANONICAL_SYSTEM
AC_PROG_CC_C99
AC_PROG_SED

AM_INIT_AUTOMAKE([subdir-objects foreign no-dist-gzip dist-bzip2 parallel-tests])
AM_SILENT_RULES([yes])
AM_PROG_CC_C_O

PKG_PROG_PKG_CONFIG([0.25])

AC_CHECK_LIB([dl], [dlopen], [AC_SUBST([dl_LIBS], [-ldl])],
             [AC_CHECK_LIB([dl], [dlopen], [AC_SUBST([dl_LIBS], [-ldl])],
	                   [AC_MSG_ERROR([unable to find dlopen])])])

AC_CHECK_HEADER([http_parser.h], [],
		[AC_MSG_ERROR([http-parser required!])], [
#include <http_parser.h>
#ifndef HTTP_STATUS_MAP
#error HTTP_STATUS_MAP not defined!
#endif
])

AC_CHECK_LIB([http_parser], [http_parser_execute],
             [AC_SUBST(http_parser_LIBS, [-lhttp_parser])],
             [AC_MSG_ERROR([http-parser required!])])

PKG_CHECK_MODULES([jose], [jose >= 8])
PKG_CHECK_MODULES([systemd], [systemd])

AC_ARG_WITH([systemdsystemunitdir],
            [AS_HELP_STRING([--with-systemdsystemunitdir=DIR], [Directory for systemd service files])],
            [],
            [with_systemdsystemunitdir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd)])

AC_SUBST([systemdsystemunitdir], [$with_systemdsystemunitdir])

for ac_prog in systemd-socket-activate systemd-activate; do
    AC_CHECK_PROG([SD_ACTIVATE], [$ac_prog], [$as_dir/$ac_prog], [],
		  [$PATH$PATH_SEPARATOR$($PKG_CONFIG --variable=systemdutildir systemd)])
    test -n "$SD_ACTIVATE" && break
done

test -n "$SD_ACTIVATE" || AC_MSG_ERROR([systemd-socket-activate required!])

AC_MSG_CHECKING([systemd-socket-activate inetd flag])
if $SD_ACTIVATE --help | grep -q inetd; then
    SD_ACTIVATE="$SD_ACTIVATE --inetd"
    AC_MSG_RESULT([--inetd])
else
    AC_MSG_RESULT([(default)])
fi

AC_SUBST(SD_ACTIVATE)

TANG_CFLAGS="\
-Wall \
-Wextra \
-Werror \
-Wstrict-aliasing \
-Wchar-subscripts \
-Wformat-security \
-Wmissing-declarations \
-Wmissing-prototypes \
-Wnested-externs \
-Wpointer-arith \
-Wshadow \
-Wsign-compare \
-Wstrict-prototypes \
-Wtype-limits \
-Wunused-function \
-Wno-missing-field-initializers \
-Wno-unused-parameter \
"
AC_SUBST([TANG_CFLAGS])

AC_CHECK_PROGS(A2X, [a2x])

if test "x$A2X" = "x"; then
   AC_MSG_WARN([asciidoc / a2x not found -- man pages will not be generated and installed])
fi

AM_CONDITIONAL(HAVE_A2X, [test -n "$A2X"])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
