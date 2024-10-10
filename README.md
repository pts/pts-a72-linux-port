# pts-a72-linux-port: port of the A72 assembler to Linux i386

pts-a72-linux-port is a port of the A72 assembler to Linux i386, using NASM
0.98.39. It is based on the [source code of A72
1.05](https://github.com/swanlizard/a72/tree/155413cbc1646ef4aad05353eab9332210bb31f4).
The ported program is cross-assembler: it still targets the 16-bit 8086
(including DOS .com programs), but it runs on Linux i386 and amd64 systems,
and it's libc-independent. It is not able to assemble itself. The original
memory limitations of A72 still apply (i.e. 64 KiB in total, including
assembler code, assembler data and the symbol table).

To get the Linux i386 executable, run the following (without the leading
`$`) on a Linux i386 or amd64 system:

```
$ 1.05/compile.sh
```

This above generates the file `1.05/a72`, which is a Linux i386 executable
program. The file can be copied anywhere, and can be run as `a72` if added
to the *PATH*.

The main contribution of this port is the file `1.05/a72l.nasm`, which is
based on the [original A72 1.05 source
coude](https://github.com/swanlizard/a72/tree/155413cbc1646ef4aad05353eab9332210bb31f4),
but it was heavily modified manually, like this:

1. The source code of A72 1.05 was ported from A72 syntax to NASM 0.98.39 syntax.
2. The 16-bit code was (minimally) changed to work on 32-bit i386. This was
   very tricky to get right, because memory access on DOS 8086 and Linux i386
   are very different, and also some x86 CPU instructions don't have
   equivalent 16-bit and 32-bit counterparts. (For example, the *call*
   instruction pushes 16 bits or 32 bits to the stack, depending on the mode.)
3. Linux i386 ELF-32 headers and libc adapters (e.g. for file I/O) were added.

Compatibility notes between the original DOS A72 1.05 and the Linux port:

* The original A72 runs on DOS 8086 (and later) as a 16-bit DOS .com program.
  The Linux port runs on Linux i386 and Linux amd64 systems as a statically
  linked (libc-independent) Linux i386 executable program.
* Both the original and the Linux port target the 16-bit 8086 (including
  DOS .com programs). There is no support for e.g. 8087 (FPU), 186, 286,
  386, protected mode, 32-bit mode, 64-bit mode, MMX, SEE.
* The original is able to assemble itself (running as a 16-bit DOS .com
  program on DOS, producing a 16-bit DOS .com program file from the a72.asm
  assembly source code), the Linux port is not (because the Linux port uses
  i386 instructions).
* Both the original and the Linux port can produce output files (.com, .bin,
  .lst and .asm) which are megabytes or even gigabytes long: 2 GiB minus 1
  byte is supported by both if there is enough free space on the filesystem.
* Both the original and the Linux port can read input files which are
  megabytes or even gigabytes long (same as for output bytes).
* Both the original and the Linux port can use up to 64 KiB of memory
  (minus the assembler code, assembler data and buffers) for the symbol
  table (i.e. labels).
* The Linux port can use a little bit (about 4 KiB) more memory for the
  symbol table than the original, because it moves most of the assembler
  code outside the 64 KiB.
* The original converts filenames to uppercase, the Linux port keeps
  filenames intact. (Except for the first word of unquoted `include` and
  `incbin` filenames: both convert the first word to uppercase, e.g.
  `fOo.asm' gets converted to `FOO.asm'.)
* The original generates filename extensions (e.g. .asm, .com and .lst) in
  uppercase, the Linux port generates them in lowercase.
* The original is affected by DOS filename limitations (e.g. 8.3
  characters), the Linux port is affected by Linux filename limitations
  (depends on the filesystem, it can be hundreds or thousands of bytes).
* Maximum command-line size is 126 bytes for the original, and 254 bytes
  for the Linux port. (This also limits the filename and pathnames.)

In addition to the Linux i386 port with NASM syntax (`1.05/a72l.nasm`)
above, pts-a72-linux-port also contains a source port from A72 to NASM
syntax, still running on DOS 8086 (`1.05/a72.nasm`). This port also contains
bugfixes, which are also included in the Linux i386 port. The following bugs
have been fixed:

* Quoted include filenames (`include 'FILENAME'`, `include "FILENAME"`, also
  for `incbin`) now work (and use the original filename, not converted to
  uppercase). Previously the (incorrect) compilation error `GARBAGE PAST
  END` was reported.

Tools used for building and testing:

* Bourne shell
* AWK and other Unix utilities
* NASM 0.98.39, a Linux i386 executable program is bundled as `tools/nasm-0.98.39`
* [kvikdos](https://github.com/pts/kvikdos) DOS emulator, a Linux i386
  executable program is bundled as `tools/kvikdos`

The build process looks like this:

* A72 is built for DOS 8086 from original sources, in a DOS emulator.
* A72 is built for DOS 8086 from a lightly modified NASM source.
* A72 is built for Linux i386 from a heavily modified NASM source.
* All these programs are run with test input (original A72 sources) in
  various modes, and their output is compared to the expected golden
  outputs.
