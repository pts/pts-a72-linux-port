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
3. Linux i385 ELF-32 headers and libc adapters (e.g. for file I/O) were added.

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
