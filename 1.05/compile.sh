#! /bin/sh
# by pts@fazekas.hu at Fri Mar 29 22:47:45 CET 2024
set -ex
test "${0%/*}" = "$0" || cd "${0%/*}"
test -f ../tools/nasm-0.98.39
test -f ../tools/kvikdos
export PATH="../tools:$PATH"
rm -f a72*p[0-9].com a72*p[0-9].lst a72*p[0-9].dis

kvikdos a72.com a72.asm /a a72p0.com
cmp a72.com a72p0.com
kvikdos a72.com a72.asm /l a72p0.lst
diff a72.lst a72p0.lst
kvikdos a72.com a72.com /d a72p0.dis
diff a72.dis a72p0.dis

: "$0" OK.
