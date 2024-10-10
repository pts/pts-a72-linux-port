#! /bin/sh
# by pts@fazekas.hu at Fri Mar 29 22:47:45 CET 2024
set -ex
test "${0%/*}" = "$0" || cd "${0%/*}"
test -f ../tools/nasm-0.98.39
test -f ../tools/kvikdos
export PATH="../tools:$PATH"
rm -f a72*p[0-9].com a72*p[0-9].lst a72*p[0-9].dis GENERIC.ASM 8086.ASM bad.err bad2.err bad.com

kvikdos a72.com a72.asm /a a72p0.com
cmp a72.com a72p0.com
kvikdos a72.com a72.asm /l a72p0.lst
diff a72.lst a72p0.lst
kvikdos a72.com a72.com /d a72p0.dis
diff a72.dis a72p0.dis

nasm-0.98.39 -O999999999 -w+orphan-labels -f bin -o a72n.com a72.nasm
#cmp a72.com a72n.com  # It's OK if a72n.com is different form the golden a72.com.
kvikdos a72n.com a72.asm /a a72np1.com
cmp a72.com a72np1.com
kvikdos a72n.com a72.asm /l a72np1.lst
diff a72.lst a72np1.lst
kvikdos a72n.com a72.com /d a72np1.dis
diff a72.dis a72np1.dis

nasm-0.98.39 -O999999999 -w+orphan-labels -f bin -o a72 a72l.nasm
chmod +x a72
# This `include' breaks the listing, because it adds an additional line.
#echo 'include "generic.asm"' >GENERIC.ASM  # Workaround for uppercase filename in INCLUDE in a72.asm.
#echo 'include "8086.asm"'    >8086.ASM     # Workaround for uppercase filename in INCLUDE in a72.asm.
ln -s generic.asm GENERIC.ASM
ln -s 8086.asm 8086.ASM
./a72 a72.asm /a a72np1.com
cmp a72.com a72np1.com
./a72 a72.asm /l a72np1.lst
<a72.lst >a72pp1.lst awk '{gsub(/A72[.]ASM/,"a72.asm");print}'
diff a72pp1.lst a72np1.lst
./a72 a72.com /d a72np1.dis
<a72.dis >a72pp1.dis awk '{gsub(/A72[.]COM/,"a72.com");print}'
diff a72pp1.dis a72np1.dis

rm -f bad.com
exit_code=0
./a72 bad.asm /a >bad.err || exit_code="$?"
test "$exit_code" = 2
test -f bad.com
test ! -s bad.com  # Must be empty.
diff bad.err.exp bad.err

rm -f bad.com
exit_code=0
kvikdos a72n.com bad.asm /a >bad.err || exit_code="$?"
test "$exit_code" = 2
test -f bad.com
test ! -s bad.com  # Must be empty.
<bad.err >bad2.err awk '{gsub(/BAD[.]ASM/,"bad.asm");print}'
diff bad.err.exp bad2.err

: "$0" OK.
