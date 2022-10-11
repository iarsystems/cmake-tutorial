# Tutorial <br>Building and testing with the IAR Systems tools in CMake

[CMake][url-cm-home] is an open-source, cross-platform family of tools maintained and supported by [Kitware][url-cm-kitware]. CMake is used to control the software compilation process through simple configuration files to generate native build scripts for a chosen build system (e.g. ninja, make, etc.). For full documentation visit the [CMake Documentation Page][url-cm-docs].

This tutorial serves as a mini-guide on the ways CMake can be used alongside the __IAR C/C++ Compilers__ to cross-compile embedded software applications for the supported target architectures.
The core ideas presented were inspired by the [Technical Note 190701][url-iar-docs-tn190701].


## Pre-requisites
This tutorial assumes that:

* __The reader is familiar with the usage of the IAR Systems tools, as well as with the Kitware tools, from their respective command-line interfaces.__

* This repository is cloned to the development computer (alternatively it can be downloaded as a zip archive via the __Code__ button).

* The required tools are already installed in the system, according to the table below:

| __Tool__       | __Windows-based systems__ | __Linux-based systems__ |
|----------------|---------------------------|-------------------------|
| IAR C/C++ Compiler for...  | `Arm`, `RISC-V`, `RL78`, `RX`, `RH850`, <br>`8051`, `AVR`, `MSP430`, `STM8` or `V850` | `Arm`, `RISC-V`, `RL78`, `RX` or `RH850` |
| CMake          | v3.23 or later | v3.23 or later |
| Build engine   | [__Ninja__](https://ninja-build.org)  | [__Ninja__](https://ninja-build.org) |

>:bulb: On Linux-based systems, [`cmake`](https://cmake.org/install/) and [`ninja`](https://ninja-build.org/#:~:text=Getting%20Ninja,system%27s%20package%20manager) are normally found on the default search path so that both can be executed directly from anywhere in the system. Although, on Windows-based systems, this is not always the case. It is recommended that their respective locations are on the search path, defined by the __PATH__ environment variable. The same recommendation applies for when using `cmake.exe` with other generators such as `"Unix Makefiles"` that relies on `make.exe` as build system. Under such a scenario, if the `make.exe` program cannot be found, CMake will fail immediately during the toolchain configuration step with a corresponding error message (e.g. "_CMAKE_MAKE_PROGRAM not found_").


## Building Projects
To build a project developed with the IAR Compiler using CMake we need at least
* A toolchain file
* A CMakeLists.txt file
* The source code

### Configuring the toolchain file
By default, CMake uses what it assumes to be the host platform's default compiler. When the application targets an embedded platform (known as cross-compiling), a toolchain file `<toolchain-file>.cmake` can be used to indicate the desired toolchain's location for its compiler and assembler. This section provides a simple generic template for the __IAR C/C++ Compilers__.

On the [examples/iar-toolchain.cmake](examples/iar-toolchain.cmake) file from the repository you have cloned, set the following variables to match the product installed in your system:
* Set `CMAKE_SYSTEM_PROCESSOR`:

https://github.com/IARSystems/cmake-tutorial/blob/2c476dc240bf2c0c86bf144863eccdba0c0d38de/examples/iar-toolchain.cmake#L3-L5

* Set `IAR_INSTALL_DIR`:

https://github.com/IARSystems/cmake-tutorial/blob/2c476dc240bf2c0c86bf144863eccdba0c0d38de/examples/iar-toolchain.cmake#L7-L8

<details> <summary><b>Notes on IAR_INSTALL_DIR</b> (Click to unfold)</summary>

>Below you will find some general examples for Windows and Linux:
> 
>| IAR_INSTALL_DIR example for     | Windows tools                                               | Linux tools                         |
>| ------------------------------- | ----------------------------------------------------------- | ----------------------------------- |
>| a typical installation location | `"C:/Program Files/IAR Systems/Embedded Workbench N.n"`     | `"/opt/iarsystems/bx<arch>-N.nn.n"` |
>| a custom installation location  | `"C:/IAR_Systems/EWARM/N.nn.n"`                             | Not applicable                      | 
> * Replace `N.nn[.n]` or `<arch>` by the actual version or package of the active product.
> * The __IAR_INSTALL_DIR__ is used to set the [__TOOLKIT_DIR__](https://github.com/IARSystems/cmake-tutorial/blob/v2022.06/examples/iar-toolchain.cmake#L17) variable.
> * The __TOOLKIT_DIR__ variable is used to set the [PATH](https://github.com/IARSystems/cmake-tutorial/blob/v2022.06/examples/iar-toolchain.cmake#L20-L24) environment variable with the `bin` directory so that the compiler can be found on the search path. Setting the PATH with this method lasts for the time CMake is running.
   
</details>
   
### A minimal project
A project is defined by one or more CMakeLists.txt file(s). Let's understand how a project can be configured with a simple example for the Arm target architecture. 

* Inside the [examples/arm](examples/arm) directory, create a new subdirectory named __hello-world__:
```
> cd /path/to/cmake-tutorial/examples/arm
> mkdir hello-world
> cd hello-world   
```   
* Create the __CMakeLists.txt__ file:
```cmake
# CMake requires to set its minimum required version
cmake_minimum_required(VERSION 3.23)

# Set the project name, enabling its required languages (e.g. ASM, C and/or CXX)   
project(simpleProject LANGUAGES C)

# Add a executable target named "hello-world"
add_executable(hello-world
   # Target sources
   main.c)
   
# Set the target's compiler options
target_compile_options(hello-world PRIVATE --cpu=Cortex-M4 --fpu=VFPv4_sp --dlib_config normal)   
   
# Set the target's linker options
target_link_options(hello-world PRIVATE --semihosting --config ${TOOLKIT_DIR}/config/linker/ST/stm32f407xG.icf)
```
> :bulb: Adjust the target compile/link options for architectures other than __arm__. 

* Finally create a simple __main.c__ source file:
```c
#include <intrinsics.h>
#include <stdio.h>
   
void main() {
   while (1) {
     printf("Hello world!\n");
     __no_operation();
   }
}   
```
   
###  Configuring the build system generator
Once we have our minimal project with a suitable toolchain file, we invoke CMake to configure our build environment for when cross-compiling, choosing which _build system generator_ and which _toolchain file_ should be used for the project.

In this example we will take advantage of the `"Ninja Multi-Config"` generator option. This option can be used to generate build configurations for "Debug" and "Release" purposes. The general recommendation when using CMake is to perform an "out-of-source" build, which means creating a subdirectory for the output files.
 
 * Use the following command to generate the scripts for the build system inside the `_builds` subdirectory:
```
cmake -B_builds -G "Ninja Multi-Config" --toolchain /path/to/iar-toolchain.cmake
```
>:bulb: Use `cmake --help` for more information.   

<details><summary><b>Expected output example</b> (click to unfold):</summary>
   
>```
>-- The C compiler identification is IAR ARM N.nn
>-- Detecting C compiler ABI info
>-- Detecting C compiler ABI info - done
>-- Check for working C compiler: /path/to/toolkit_dir/bin/iccarm.exe - skipped
>-- Detecting C compile features
>-- Detecting C compile features - done
>-- Configuring done
>-- Generating done
>-- Build files have been written to: /path/to/cmake-tutorial/examples/arm/hello-world/_builds
>```
   
</details>

>:warning: If for some mistake the configuration step fails (e.g. wrong option, wrong selection, etc.), it might be necessary to remove the `_builds` subdirectory before trying again. This helps CMake to avoid potential cache misses interfering during a new attempt.

### Building the project
* Once the `_builds` tree is configured, use CMake with the `--build` flag to build the project:
```
cmake --build _builds
```
>:bulb: Use `cmake --help` for more information.   

<details><summary><b>Expected output example</b> (click to unfold):</summary>
   
>```
>[2/2] Linking C executable Debug\hello-world.elf
>```
   
</details>   
  
In the minimal example we had an initial overview of what is needed to bootstrap a CMake project for a simple executable. Targets created from actual embedded software projects will typically require preprocessor symbols, compiler flags, linker flags and extended options. Additional project examples for the target architectures supported in CMake are provided as reference in the "[Examples](#examples)" section of this tutorial.


## Examples
Now that you know how to _configure_ and _build_ embedded projects developed with the IAR tools using CMake, you can start to explore how projects can be configured in greater detail using the previously acquired knowledge.
   
In this section you will find descriptions for the provided [examples](examples). Each __architecture__ (__\<arch\>__) subdirectory contains multiple examples.
   
Optionally, each example's CMakeLists.txt for executable targets comes with a line `include(/path/to/iar-cspy-<arch>.cmake)` in the end as an example that illustrates how to use CTest to invoke the __IAR C-SPY Command-line Utility__ ([`cspybat.exe`][url-iar-docs-cspybat]) to perform automated tests using [macros][url-iar-docs-macros].

### Example 1 - Mixing C and Assembly
The __examples/\<arch\>/mix-c-asm__ example project demonstrates the basic concepts on how to build a single executable target (__mixLanguages__) using __C__ and __Assembly__ sources.

It also shows:
* How to use `target_compile_definitions()` to set preprocessor symbols that can be used in the target's sources. 


### Example 2 - Creating and using libraries
The __examples/\<arch\>/using-libs__ example project demonstrates some advanced features and how to build one executable target (__myProgram__) linked against a static library target (__myMath__) using __C__ sources.

The top-level directory contains a __CMakeLists.txt__ file that will add the __lib__ and the __app__ subdirectories, each one containing its own __CMakeLists.txt__.
   
The __myMath__ library target is located in the __lib__ subdirectory. The library contains functions which take two integer parameters to perform basic arithmetic over them, returning another integer as result. 

The __myProgram__ executable target is located in the __app__ subdirectory. The program performs arithmetic operations using the __myMath__'s library functions.

It also shows:
* How to use `set_target_properties()` to propagate configuration details across the target options.
* How to set `target_link_options()` to create a map file of the executable.
* How to use `add_custom_command()` for generating .bin/.hex/.srec outputs using `ielftool`. 

   
### Testing the examples
CTest is an extension of CMake that can help when performing automated tests. In its conception, a test in CTest allows desktop software developers to execute the target directly on the host computer, evaluating its exit code.
   
When cross-compiling, it is not possible to execute the target executable directly from the host computer. However it is possible to execute the target with the __IAR C-SPY Debugger__ using, for example, a custom function that wraps the needed parameters (e.g. `iar_cspy_add_test()`). A module named `iar-cspy-<arch>.cmake` was included in the CMakeLists.txt files for executable targets and illustrates such a concept.
   
>:warning: This section requires the __IAR C-SPY Command Line Utility__ (`cspybat.exe`), which is available with the __IAR Embedded Workbench__ products.   

* Test the desired project example (*built with debug information) by executing:
 ```
 ctest --test-dir _builds --build-config Debug --output-on-failure --timeout 10
 ```
>:bulb: Use `ctest --help` for more information.
   
<details><summary>Expected output - <b>Example 1</b> (click to unfold):</summary>
   
>```
>Internal ctest changing into directory: C:/path/to/cmake-tutorial/examples/<arch>/mix-c-asm/_builds
>Test project C:/path/to/cmake-tutorial/examples/<arch>/mix-c-asm/_builds
>    Start 1: test_mynum
>1/1 Test #1: test_mynum .......................   Passed    0.20 sec
>
>100% tests passed, 0 tests failed out of 1
>
>Total Test time (real) =   0.25 sec
>```
   
</details>   
   
<details><summary>Expected output - <b>Example 2</b> (click to unfold):</summary>
   
>```
>Internal ctest changing into directory: C:/path/to/cmake-tutorial/examples/<arch>/using-libs/_builds
>Test project C:/path/to/cmake-tutorial/examples/<arch>/using-libs/_builds
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
   
</details>      

 
## Debugging
When executable targets are built with _debug information_, they can be debugged with the __IAR C-SPY Debugger__, directly from the __IAR Embedded Workbench__ IDE.

The [Debugging an Externally Built Executable file][url-iar-docs-ext-elf] Technical Note has the instructions for setting up a __debug-only__ project.
   
## Issues
Found an issue or have a suggestion related to the [__cmake-tutorial__][url-repo-home] tutorial? Feel free to use the public issue tracker.
- Do not forget to take a look at [earlier issues][url-repo-issue-old].
- If creating a [new][url-repo-issue-new] issue, please describe it in detail.   

## Conclusion
This tutorial provided information on how to start building embedded software projects and, also, on how to perform automated tests when using the IAR Systems' tools with CMake. Once the core ideas presented here are mastered, the possibilities are only limited by the developer's mind. Such a setup might be useful depending on each organization's needs and can be used as a starting point for particular customizations.

<!-- links -->
[url-repo-home]:         https://github.com/IARSystems/cmake-tutorial
[url-repo-issue-new]:    https://github.com/IARSystems/cmake-tutorial/issues/new
[url-repo-issue-old]:    https://github.com/IARSystems/cmake-tutorial/issues?q=is%3Aissue+is%3Aopen%7Cclosed
   
[url-iar-docs-tn190701]: https://www.iar.com/knowledge/support/technical-notes/general/using-cmake-with-iar-embedded-workbench/
[url-iar-docs-macros]:   https://wwwfiles.iar.com/arm/webic/doc/EWARM_DebuggingGuide.ENU.pdf#page=417
[url-iar-docs-cspybat]:  https://wwwfiles.iar.com/arm/webic/doc/EWARM_DebuggingGuide.ENU.pdf#page=503
[url-iar-docs-ext-elf]:  https://www.iar.com/knowledge/support/technical-notes/debugger/debugging-an-externally-built-executable-file/

[url-gh-docs-notify]:    https://docs.github.com/en/github/managing-subscriptions-and-notifications-on-github/setting-up-notifications/about-notifications
   
[url-cm-home]:           https://cmake.org
[url-cm-docs]:           https://cmake.org/documentation
[url-cm-docs-genex]:     https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
[url-cm-docs-ctest]:     https://cmake.org/cmake/help/latest/manual/ctest.1.html
[url-cm-wiki]:           https://gitlab.kitware.com/cmake/community/-/wikis/home
[url-cm-kitware]:        https://kitware.com
