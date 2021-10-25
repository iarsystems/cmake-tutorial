# Tutorial<br>Building and testing with the IAR Systems tools in CMake

If you end up with a question or suggestion specifically related to [__this tutorial__][url-repo-home], you might be interested in verifying if it was already discussed in [earlier issues][url-repo-issue-old]. If you could not find what you are looking for, feel free to [create a new issue][url-repo-issue-new]. 

It is possible to receive [notifications][url-gh-docs-notify] about updates to this tutorial directly in your GitHub inbox by starting to __watch__ this repository. 

## Introduction
[CMake][url-cm-home] is a cross-platform, open-source _build system generator_. CMake is maintained and supported by [Kitware][url-cm-kitware]. It is developed in collaboration with a productive community of contributors.

For full documentation visit the [CMake Documentation Page][url-cm-docs].

The core ideas in this tutorial, inspired by the [Technical Note 190701][url-iar-docs-tn190701], serve as a mini-guide on how CMake can be used alongside the __IAR C/C++ Compiler__ to cross-compile embedded software applications.

__This tutorial assumes that the reader is familiar with the usage of the IAR Systems tools, as well as with the Kitware tools, from their respective command-line interfaces.__


## Required tools
The required tools are similar either if __Windows__ or __Linux__ is being used:
| __Tool__       | __Windows__ | __Linux__ |
|----------------|-------------|-----------|
| IAR C/C++ Compiler for...  | `Arm`, `RISC-V`, `RL78`, `RX`, `RH850`,<br/>`8051`, `AVR`, `MSP430`, `STM8` or `V850` | `Arm`, `RISC-V`, `RL78`, `RX` or `RH850` |
| CMake          | v3.22 or later | v3.22 or later |
| Build engine   | [__Ninja__](https://ninja-build.org)  | [__Ninja__](https://ninja-build.org) |

>:warning: In order to conveniently execute __cmake__ and __ninja__ from anywhere in your system, without specifying their respective full paths, make sure their locations are in the `PATH` variable of your operating system.


## Examples
In this section you will find examples on how `CMakeLists.txt` files can be created to build __executable__ targets as well as __library__ targets. 

The examples work with all the architectures supported in CMake.

__CMake 3__ has been described as the beginning of the "Modern CMake" age. Since then, it has been advised to avoid variables in favor of targets and properties. The commands __add_compile_options()__, __include_directories()__, __link_directories()__, __link_libraries()__, that were at the core of __CMake 2__, should now be replaced by target-specific commands.

The __CMakeLists.txt__ in the examples use expressions that look like this `$<...>`. Those are the so-called [_generator expressions_][url-cm-docs-genex] (or _genex_, for short) and they allow us to express our intentions in many powerful ways.

>:warning: In order to get the all the examples, you can clone this repository __or__, if you want to get only the files from a single example, click on its respective link in the examples' titles and get it bundled in a __zip__ archive.


### Example 1 - [Mixing C and Assembly][url-repo-example1]
The [mix-c-asm](examples/mix-c-asm) project demonstrates the basic concepts on how to build a single executable target (__mixLanguages__) using __C__ and __Assembly__ sources.

It also shows:
* How to use __target_compile_definitions()__ to set preprocessor symbols that can be used in the target's sources. 
* __Windows-only__: How to execute the target using the [IAR C-SPY Debugger Simulator][url-iar-docs-cspybat] via CTest.

Each `<arch>` has its own __CMakeLists.txt__. The file is located in the respective `<arch>` folder and has further comments. Below you will find the direct links to each of them:

| [`430`][430-ex1] | [`8051`][8051-ex1] | [`arm`][arm-ex1] | [`avr`][avr-ex1] | [`riscv`][riscv-ex1] | [`rx`][rx-ex1] | [`rh850`][rh850-ex1] | [`rl78`][rl78-ex1] | [`stm8`][stm8-ex1] | [`v850`][v850-ex1] |
| - | - | - | - | - | - | - | - | - | - |

Instructions for [building](#building-projects) and [testing](#testing-projects) these projects are provided below.


### Example 2 - [Creating and using libraries][url-repo-example2]
The [using-libs](examples/using-libs) project demonstrates some advanced features and how to build one executable target (__myProgram__) linked against a static library target (__myMath__) using __C__ sources.

It also shows:
* How to use __set_target_properties()__ to propagate configuration details across the target options.
* How to set __target_linker_options()__ to create a map file of the executable.
* How to use __add_custom_target()__ for executing `ielftool` and generate an `.ihex`|`.srec`|`.bin` output. 
* __Windows-only__: How to execute the target using the [IAR C-SPY Debugger Simulator][url-iar-docs-cspybat] via CTest.

The __myMath__ library target is located in the __lib__ subdirectory. The library contains functions which take two integer parameters to perform basic arithmetic over them, returning another integer as result. 

The __myProgram__ executable target is located in the __app__ subdirectory. The program performs arithmetic operations using the __myMath__'s library functions.

For each architecture, the project uses 3 __CMakeLists.txt__. These files have further comments. 

* The __CMakeLists.txt__ in the __top-level__ directory:

| [`430`][430-ex2-t] | [`8051`][8051-ex2-t] | [`arm`][arm-ex2-t] | [`avr`][avr-ex2-t] | [`riscv`][riscv-ex2-t] | [`rx`][rx-ex2-t] | [`rh850`][rh850-ex2-t] | [`rl78`][rl78-ex2-t] | [`stm8`][stm8-ex2-t] | [`v850`][v850-ex2-t] |
| - | - | - | - | - | - | - | - | - | - |

* The __lib/CMakeLists.txt__ for the __library__ target:

| [`430`][430-ex2-l] | [`8051`][8051-ex2-l] | [`arm`][arm-ex2-l] | [`avr`][avr-ex2-l] | [`riscv`][riscv-ex2-l] | [`rx`][rx-ex2-l] | [`rh850`][rh850-ex2-l] | [`rl78`][rl78-ex2-l] | [`stm8`][stm8-ex2-l] | [`v850`][v850-ex2-l] |
| - | - | - | - | - | - | - | - | - | - |

* The __app/CMakeLists.txt__ for the __executable__ target:

| [`430`][430-ex2-a] | [`8051`][8051-ex2-a] | [`arm`][arm-ex2-a] | [`avr`][avr-ex2-a] | [`riscv`][riscv-ex2-a] | [`rx`][rx-ex2-a] | [`rh850`][rh850-ex2-a] | [`rl78`][rl78-ex2-a] | [`stm8`][stm8-ex2-a] | [`v850`][v850-ex2-a] |
| - | - | - | - | - | - | - | - | - | - |

Instructions for [building](#building-projects) and [testing](#testing-projects) these projects are provided below.


## Building Projects

### Configuring the toolchain file
When cross-compiling applications with CMake, an appropriate `<toolchain-file>.cmake` must be specified. 
This file contains the toolchain's location for its compiler and assembler.

This section provides a simple example of a generic __toolchain file__ for CMake that can be used along with the __IAR C/C++ Compiler__.

On the [examples/iar-toolchain.cmake](examples/iar-toolchain.cmake) file, perform the following changes to match your system:
* Update [__CMAKE_SYSTEM_PROCESSOR__](examples/iar-toolchain.cmake#L11) with one of the valid compiler's target `<arch>`:
>`430`, `8051`, `arm`, `avr`, `riscv`, `rx`, `rh850`, `rl78`, `stm8` or `v850`.

* Update [__IAR_INSTALL_DIR__](examples/iar-toolchain.cmake#L14) to point to the location where the corresponding IAR tools are __installed__ on __your__ system:
>__Windows__ examples:
>```
>"C:/Program\ Files/IAR\ Systems/Embedded\ Workbench\ 9.0"
>```
>```
>"C:/IAR_Systems/EWARM/9.10.2"
>```
>__Linux__ examples:
>```
>"/opt/iarsystems/bxarm-9.10.2"
>```
>```
>"/opt/iarsystems/bxarm"
>```
> __Notes__
> * If the __IAR_INSTALL_DIR__ contains blank spaces, it might be necessary to escape them using backslashes `\ ` or, instead, use `\\`.
> * __Do not__ include `<arch>/bin` on the __IAR_INSTALL_DIR__ variable. The `<arch>` will be automatically added in the [__TOOLKIT_DIR__](https://github.com/IARSystems/cmake-tutorial/blob/1.0.0/examples/iar-toolchain.cmake#L17) variable using __CMAKE_SYSTEM_PROCESSOR__. The `/bin` sub-directory will be hardcoded to the ephemeral `PATH` environment variable used internally while CMake is running.

* When using the __IAR Assembler__ for `430`, `8051`, `avr` or `v850` architecture, update [__CMAKE_ASM_COMPILER__](examples/iar-toolchain.cmake#L29) to:
>`"a${CMAKE_SYSTEM_PROCESSOR}"`


###  Generate a <i>Project Buildsystem</i>
The general syntax to generate the input files for a native build system is: 
```
cmake -G <generator> -B <build-dir> --toolchain <file>
```

|__Option__     | __Explanation__                                                                                                         | 
| :------------ | :---------------------------------------------------------------------------------------------------------------------- |
| `-B`          | Explicitly specify a build directory.                                                                                   |
| `-G`          | Specify a generator name.                                                                                               |
| `--toolchain` | Specify the toolchain file `[CMAKE_TOOLCHAIN_FILE]`                                                                     |

In this example we will use the __Ninja__ generator. Once the toolchain file is modified, inside each example's __architecture__ subdirectory, use the following command to generate the build scripts in the `_builds`  sub-directory:
```
cmake -G "Ninja Multi-Config" -B_builds --toolchain ../../iar-toolchain.cmake
```
The expected output is similar to:
>```
>-- The C compiler identification is IAR <ARCH> <VERSION>
>-- Detecting C compiler ABI info
>-- Detecting C compiler ABI info - done
>-- Check for working C compiler: C:/<install-path>/<arch>/bin/icc<arch>.exe - skipped
>-- Detecting C compile features
>-- Detecting C compile features - done
>-- Configuring done
>-- Generating done
>-- Build files have been written to: C:/<...>/cmake-tutorial/examples/<example>/<arch>/_builds
>```

>:warning: Once the `_builds` is configured, there is no need to re-run the configuration step, except if there are changes to the toolchain file.

>:warning: If for some reason the configuration step fails, try removing the `_builds` subdirectory before running it again, in order to avoid any potential cache misses.  

### Build the project
The general syntax to __build__ a project through CMake is:
```
cmake --build <build-dir> --config <cfg> [extra-options]
```
|__Option__                            | __Explanation__                                                                     | 
| :----------------------------------- | :---------------------------------------------------------------------------------- |
| `--build`                            | Build a CMake-generated project binary tree.                                        |
| `--config`                           | For multi-configuration tools, choose `<cfg>`.                                      |
| `--parallel [<jobs>]`                | Build in parallel using the given number of `<jobs>`.                               |
| `--clean-first`                      | Build target 'clean' first, then build.<br> (To clean only, use `--target clean`.)  |
| `--verbose`                          | Enable verbose output - if supported - including the build commands to be executed. |

Once the build tree is configured, inside each example's __architecture__ subdirectory, use the following command line to build the project:
```
cmake --build _builds --config <Debug|Release>
```

### Convert the output
Optionally, there is an additional target named __ielftool__ for the [using-libs](examples/using-libs) examples.

The __ielftool__ target executes the __IAR ELF Tool__ in order to convert the default ELF output to the selected format. The output format parameter can be set to the preferred format in the target's __FORMAT__ property which accepts formats such as _Intel-extended_, _Motorola S-record_ or _binary_.

Inside each architecture's project example directory, the following command can be used to create the additional output: 
```
cmake --build _builds --config <Debug|Release> --target=ielftool
```

>:warning: The __ielftool__ target is not available for architectures using the UBROF format, created by the __IAR XLINK Linker__. 


## Testing Projects
__CTest__ is an extension of CMake that can help when performing automated tests.

The __enable_testing()__ command in the CMakeLists.txt file enables CTest. Once CTest is enabled, the __add_test()__ command can be used with executable targets.

In its conception, a test in CTest allows desktop software developers to execute the target directly on the host computer, evaluating its exit code. 

Although, in cross-compiling scenarios, it is not possible to execute embedded software for the target architecture directly from the host computer. So we need a slightly different concept in order to execute embedded software from CTest.

The situation narrows down to the following question: what about if we can execute from a simulator, or perhaps, directly from the target itself? 

Here is where the  __IAR C-SPY Debugger__ comes into play. One possibility for us is to create custom macros in the __CMakeLists.txt__ of the executable targets. In the examples, the custom macro named __add_test_cspy()__ illustrates such a concept. The custom macro will create the command line to execute the target with [`CSpyBat.exe`][url-iar-docs-cspybat].

The syntax for the __add_test_cspy()__ in the examples is simple:
```cmake 
add_test_cspy(TESTNAME EXPECTED_VALUE)
```
|__Parameter__                   | __Explanation__                                                                     | 
| :----------------------------- | :---------------------------------------------------------------------------------- |
| `TESTNAME`                     | A name for the test.                                                                |
| `EXPECTED_VALUE`               | Output anything outputted by the test program if the test should fail.              |

The general syntax to __test__ one of the example projects using __CTest__ is:
```
ctest --test-dir _builds --build-config Debug --output-on-failure --timeout 10
```
|__Option__                      | __Explanation__                                                                     | 
| :----------------------------- | :---------------------------------------------------------------------------------- |
| `--test-dir`                   | Specify the directory in which to look for tests.                                   |
| `--output-on-failure`          | Output anything outputted by the test program if the test should fail.              |
| `--timeout <seconds>`          | Set the default test timeout.                                                       |

>:warning: When testing, make sure to use targets built with __debug information__.

### How it works?
In the CMakeLists.txt for the executable targets, the __add_test_cspy()__ macro composes the command-line which will invoke __IAR C-SPY Debugger__. The flags `--macro=<file>.mac` and `--macro-param="variable=value"` are appended to the command-line. These flags forward the test parameters to the example's  __[C-SPY Macro][url-iar-docs-macros] file__ (`test.mac`), which will monitor the function's result and then print out a `__message` with __PASS__ or __FAIL__. Whenever CTest detects a message containing __PASS__, it will consider the test successful. This feature shows how powerful and flexible a C-SPY Macro can be. The general syntax in the C-SPY macro system resembles parts of the C Language itself. One of the favorable aspects of using such macros like this, is that they do __not__ impose code overhead to the target executable itself.

__Example 1__ - expected output:
>```
>Internal ctest changing into directory: C:/<...>/cmake-tutorial/examples/mix-c-asm/<arch>/_builds
   >Test project C:/<...>/cmake-tutorial/examples/mix-c-asm/</arch>/_builds
>    Start 1: test_mynum
>1/1 Test #1: test_mynum .......................   Passed    0.19 sec
>
>100% tests passed, 0 tests failed out of 1
>
>Total Test time (real) =   0.20 sec
>```

__Example 2__ - expected output:
>```
>Internal ctest changing into directory: C:/<...>/cmake-tutorial/examples/using-libs/<arch>/_builds
>Test project C:/<...>/cmake-tutorial/examples/using-libs/<arch>/_builds
>    Start 1: test_add
>1/3 Test #1: test_add .........................   Passed    0.44 sec
>    Start 2: test_sub
>2/3 Test #2: test_sub .........................***Failed  Required regular expression not found. Regex=[PASS]  0.44 sec
>-- app debug output begin --
>40 + 2 = 42
>-- C-SPY TEST:test_sub. Expected: 38 Result: FAIL
>40 - 2 = 39
>40 * 2 = 80
>-- app debug output end --
>
>    Start 3: test_mul
>3/3 Test #3: test_mul .........................   Passed    0.44 sec
>
>67% tests passed, 1 tests failed out of 3
>
>Total Test time (real) =   1.34 sec
>
>The following tests FAILED:
>          2 - test_sub (Failed)
>Errors while running CTest
>```

>:warning: The __IAR C-SPY Debugger__ is only available on Windows.


## Debugging
When executable targets are built with __debug information__, they can be debugged with the __IAR C-SPY Debugger__, directly from the __IAR Embedded Workbench__ IDE.

The [Debugging an Externally Built Executable file][url-iar-docs-ext-elf] Technical Note has the instructions for setting up a __debug-only__ project.

## Conclusion
This tutorial provided information on how to start building embedded software projects and, also, on how to perform automated tests when using the IAR Systems' tools with CMake. Once the core ideas presented here are mastered, the possibilities are only limited by the developer's mind. Such a setup might be useful depending on each organization's needs and can be used as a starting point for particular customizations.

<!-- links -->
[url-repo-home]:         https://github.com/IARSystems/cmake-tutorial
[url-repo-issue-new]:    https://github.com/IARSystems/cmake-tutorial/issues/new
[url-repo-issue-old]:    https://github.com/IARSystems/cmake-tutorial/issues?q=is%3Aissue+is%3Aopen%7Cclosed
[url-repo-example1]:     https://github.com/IARSystems/cmake-tutorial/releases/download/1.0.0/iar-cmake-tutorial-example1-mix-c-asm.zip
[url-repo-example2]:     https://github.com/IARSystems/cmake-tutorial/releases/download/1.0.0/iar-cmake-tutorial-example2-using-libs.zip
   
[url-iar-docs-tn190701]: https://www.iar.com/knowledge/support/technical-notes/general/using-cmake-with-iar-embedded-workbench/
[url-iar-docs-macros]:   https://wwwfiles.iar.com/arm/webic/doc/EWARM_DebuggingGuide.ENU.pdf#page=421
[url-iar-docs-cspybat]:  https://wwwfiles.iar.com/arm/webic/doc/EWARM_DebuggingGuide.ENU.pdf#page=505
[url-iar-docs-ext-elf]:  https://www.iar.com/knowledge/support/technical-notes/debugger/debugging-an-externally-built-executable-file/

[url-gh-docs-notify]:    https://docs.github.com/en/github/managing-subscriptions-and-notifications-on-github/setting-up-notifications/about-notifications
   
[url-cm-home]:           https://cmake.org
[url-cm-docs]:           https://cmake.org/documentation
[url-cm-docs-genex]:     https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
[url-cm-docs-ctest]:     https://cmake.org/cmake/help/latest/manual/ctest.1.html
[url-cm-wiki]:           https://gitlab.kitware.com/cmake/community/-/wikis/home
[url-cm-kitware]:        https://kitware.com

  
<!-- EXAMPLE 1 -->
[430-ex1]:               examples/mix-c-asm/430/CMakeLists.txt
[8051-ex1]:              examples/mix-c-asm/8051/CMakeLists.txt
[arm-ex1]:               examples/mix-c-asm/arm/CMakeLists.txt
[avr-ex1]:               examples/mix-c-asm/avr/CMakeLists.txt
[riscv-ex1]:             examples/mix-c-asm/riscv/CMakeLists.txt
[rx-ex1]:                examples/mix-c-asm/rx/CMakeLists.txt
[rl78-ex1]:              examples/mix-c-asm/rl78/CMakeLists.txt
[rh850-ex1]:             examples/mix-c-asm/rh850/CMakeLists.txt
[stm8-ex1]:              examples/mix-c-asm/stm8/CMakeLists.txt
[v850-ex1]:              examples/mix-c-asm/v850/CMakeLists.txt
  
  
 <!-- EXAMPLE 2 - Top -->
[430-ex2-t]:             examples/using-libs/430/CMakeLists.txt
[8051-ex2-t]:            examples/using-libs/8051/CMakeLists.txt
[arm-ex2-t]:             examples/using-libs/arm/CMakeLists.txt
[avr-ex2-t]:             examples/using-libs/avr/CMakeLists.txt
[riscv-ex2-t]:           examples/using-libs/riscv/CMakeLists.txt
[rx-ex2-t]:              examples/using-libs/rx/CMakeLists.txt
[rl78-ex2-t]:            examples/using-libs/rl78/CMakeLists.txt
[rh850-ex2-t]:           examples/using-libs/rh850/CMakeLists.txt
[stm8-ex2-t]:            examples/using-libs/stm8/CMakeLists.txt
[v850-ex2-t]:            examples/using-libs/v850/CMakeLists.txt
 

 <!-- EXAMPLE 2 - library -->
[430-ex2-l]:             examples/using-libs/430/lib/CMakeLists.txt
[8051-ex2-l]:            examples/using-libs/8051/lib/CMakeLists.txt
[arm-ex2-l]:             examples/using-libs/arm/lib/CMakeLists.txt
[avr-ex2-l]:             examples/using-libs/avr/lib/CMakeLists.txt
[riscv-ex2-l]:           examples/using-libs/riscv/lib/CMakeLists.txt
[rx-ex2-l]:              examples/using-libs/rx/lib/CMakeLists.txt
[rl78-ex2-l]:            examples/using-libs/rl78/lib/CMakeLists.txt
[rh850-ex2-l]:           examples/using-libs/rh850/lib/CMakeLists.txt
[v850-ex2-l]:            examples/using-libs/v850/lib/CMakeLists.txt
[stm8-ex2-l]:            examples/using-libs/stm8/lib/CMakeLists.txt
 
<!-- EXAMPLE 2 - Application -->
[430-ex2-a]:             examples/using-libs/430/app/CMakeLists.txt
[8051-ex2-a]:            examples/using-libs/8051/app/CMakeLists.txt
[arm-ex2-a]:             examples/using-libs/arm/app/CMakeLists.txt
[avr-ex2-a]:             examples/using-libs/avr/app/CMakeLists.txt
[riscv-ex2-a]:           examples/using-libs/riscv/app/CMakeLists.txt
[rx-ex2-a]:              examples/using-libs/rx/app/CMakeLists.txt
[rl78-ex2-a]:            examples/using-libs/rl78/app/CMakeLists.txt
[rh850-ex2-a]:           examples/using-libs/rh850/app/CMakeLists.txt
[v850-ex2-a]:            examples/using-libs/v850/app/CMakeLists.txt
[stm8-ex2-a]:            examples/using-libs/stm8/app/CMakeLists.txt
  

