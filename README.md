# Tutorial <br>Building and testing with the IAR tools in CMake

[CMake][url-cm-home] is an open-source, cross-platform family of tools maintained and supported by [Kitware][url-cm-kitware]. CMake is used to control the software compilation process - using simple configuration files - to generate native build scripts for a selected build system, like ninja, make, etc. For detailed documentation, visit the [CMake Documentation Page][url-cm-docs].

This tutorial serves as a very basic-level guide to using CMake together with the __IAR C/C++ compilers__ to cross-compile embedded software applications for the supported target architectures.
The core ideas presented were inspired by [Technical Note 190701][url-iar-docs-tn190701].


## Prerequisites
This tutorial assumes that:

* You are familiar with using the IAR and Kitware tools on the command line.

* This repository is cloned to the development computer (it can also be downloaded as a zip archive by clicking the __Code__ button).

* The required tools are already installed on the system, according to the table below:

| __Tool__                                | __Windows-based systems__                                                                         | __Linux-based systems__                                            |
|-----------------------------------------|---------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| IAR C/C++ Compiler for...               | `Arm`, `RISC-V`, `RL78`, `RX`, `RH850`,<br>`8051`, `AVR`, `MSP430`, `STM8` or `V850`              | `Arm`, `RISC-V`, `RL78`, `RX` or `RH850`                           |
| [CMake 3.23+](https://cmake.org)        | Download and install the [latest][url-cmake-dl] for `-windows-x86_x64.msi`                        | Use the [Kitware APT repository](https://apt.kitware.com/) or,<br> if suitable, the distribution-provided package |
| [Ninja 1.10+](https://ninja-build.org)  | Download the latest [ninja-win.zip][url-ninja-dl] and extract "ninja.exe" to a directory belonging to the `PATH` environment variable (like `C:\Windows\`) | Usually, the distribution-provided package should be enough |

>:penguin: Recent **Linux distributions** offer relatively up-to-date packages for `cmake` and `ninja`. Once installed, these executables are normally found on the default search path, so that both can be executed directly from anywhere in the system. You can follow the official [Kitware's APT repository](https://apt.kitware.com/) instructions so you can use it with your package manager to stay always up-to-date.
>
>:thought_balloon: On **Windows-based systems**, the `cmake-<version>-windows-x86_x64.msi` installer wizard will offer you the choice of _adding the CMake directory to the system PATH for all users_ so that CMake can be executed from anywhere in your system. For the `ninja.exe` executable from the [`ninja-win.zip`](https://github.com/ninja-build/ninja/releases/latest) binary distribution archive, you can extract it to the CMake's `bin` directory inside its installation directory, or any other potential directory belonging to the `PATH` environment variable (like `C:\Windows\`). The same recommendation applies for when using CMake with alternative generators. For example, when using `cmake -G "Unix Makefiles"`, instead of `ninja.exe` you will need to use `make.exe` to build. In such a scenario, if the `make.exe` program cannot be found, CMake will fail immediately when you try to run the toolchain configuration step, returning with a fatal error message (for example, "`CMAKE_MAKE_PROGRAM not found`").


## Building Projects
To use CMake to build a project developed with an IAR compiler, you need at least:
* A toolchain file
* A `CMakeLists.txt` file
* The application source code

### Configuring the toolchain file
By default, CMake uses what it assumes to be the host platform's default compiler. When the application targets an embedded platform (known as cross-compiling), a toolchain file `<toolchain-file>.cmake` can be used to specify the intended toolchain's location to its compiler and assembler. This section provides a simple generic template for the __IAR C/C++ compilers__.

In the [`examples/iar-toolchain.cmake`](examples/iar-toolchain.cmake) file:
* Set the `TOOLKIT` variable to the compiler's target architecture.
```cmake
# Action: Set the TOOLKIT variable
# Examples: arm, riscv, rh850, rl78, rx, stm8, 430, 8051, avr or v850
# Alternative: override the default TOOLKIT (/path/to/installation/<arch>)
set(TOOLKIT arm)
```
>:bulb: The default toolchain file will search for an available compiler on the default installation paths. You can also use the `TOOLKIT` variable to set a specific installation directory (for example, `C:/IAR/EWARM/N.nn`).
   
### A minimal project
A CMake project is defined by one or more `CMakeLists.txt` file(s). This is how a simple `hello-world` project can be configured for the Arm target architecture:

* Change the directory to the `hello-world` project:
```
cd /path/to/cmake-tutorial/examples/arm/hello-world
```

* Verify the contents of the `CMakeLists.txt` file:

https://github.com/IARSystems/cmake-tutorial/blob/985f597765bd1186867b4157af3d1afde6531943/examples/arm/hello-world/CMakeLists.txt#L1-L16

> :bulb: Adjust the target compiling/linking options for architectures other than __arm__. 

* Verify the contents of the `main.c` source file:

https://github.com/IARSystems/cmake-tutorial/blob/985f597765bd1186867b4157af3d1afde6531943/examples/arm/hello-world/main.c#L1-L9
   
###  Configuring the build system generator
Once you have created the minimal project with a suitable toolchain file, invoke CMake to configure the build environment for cross-compiling, choosing the _build system generator_ and _toolchain file_ to use for the project.

In this example, take advantage of the `"Ninja Multi-Config"` generator option. This option can be used to generate build configurations for "Debug" and "Release" purposes. The general recommendation when using CMake is to perform an "out-of-source" build, which means creating a subdirectory for the output files.
 
 * Use the following command to generate the scripts for the build system inside the `_builds` subdirectory:
```
cmake -B_builds -G "Ninja Multi-Config" --toolchain /path/to/iar-toolchain.cmake
```
>:bulb: The `cmake --help` command provides more information.   

<details><summary><b>Expected output example</b> (click to expand):</summary>
   
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

>:warning: If by mistake the configuration step fails (for example, because of using the wrong option, the wrong selection, etc.), you might have to remove the `_builds` subdirectory before you try again. This helps CMake to avoid potential cache misses interference during the new attempt.

### Building the project
* Once the `_builds` tree is configured, use CMake with the `--build` flag to build the project:
```
cmake --build _builds
```
>:bulb: The `cmake --help` command provides more information.   

<details><summary><b>Expected output example</b> (click to unfold):</summary>
   
>```
>[2/2] Linking C executable Debug\hello-world.elf
>```
   
</details>   
  
In the minimal example, we had an initial overview of what you need to bootstrap a CMake project for a simple executable file. Targets created from actual embedded software projects will typically require preprocessor symbols, compiler options, linker options and extended options. Additional project examples for the target architectures supported by CMake are provided as reference in the "[Examples](#examples)" section of this tutorial.


## Examples
Now that you know how to use CMake to _configure_ and _build_ embedded projects developed with the IAR tools, you can start to explore how projects can be configured in greater detail.
   
In this section you will find descriptions for the provided [examples](examples). Each __architecture__ (__`<arch>`__) subdirectory contains multiple examples.
   
Optionally, each example's `CMakeLists.txt` file for target architectures contains the line `include(/path/to/iar-cspy-<arch>.cmake)` at the end, as an example that illustrates how to use CTest to invoke the __IAR C-SPY command line utility__ ([`cspybat.exe`][url-iar-docs-cspybat]) to perform automated tests using [macros][url-iar-docs-macros].

### Example 1 - Mixing C and assembler source code
The `examples/<arch>/mix-c-asm` example project demonstrates the basic concepts of building a single executable file (`mixLanguages`) using __C__ and __assembler__ source code.

It also shows how to use `target_compile_definitions()` to set preprocessor symbols that can be used in the target source code.


### Example 2 - Creating and using libraries
The `examples/<arch>/using-libs` example project demonstrates some advanced features and building one executable file (`myProgram`) linked with a static library file (`myMath`) using __C__ source code.

The top-level directory contains a `CMakeLists.txt` file that will add the `lib` and the `app` subdirectories, each one containing its own `CMakeLists.txt`.
   
The `myMath` library file is located in the `lib` subdirectory. The library contains functions that take two integer parameters to perform basic arithmetic on, returning another integer as the result.

The `myProgram` executable file is located in the `app` subdirectory. The application performs arithmetic operations using the functions in the `myMath` library.

It also shows:
* How to use `set_target_properties()` to propagate configuration details across the target options.
* How to set `target_link_options()` to create a map file of the executable file.
* How to use `add_custom_command()` for generating `.bin`/`.hex`/`.srec` output using the `ielftool` utility. 

   
### Testing the examples
CTest is an extension of CMake that can help you perform automated tests. With CTest, you can execute the target application directly on your host PC, evaluating its exit code.
   
When cross-compiling, it is not possible to execute the target application directly on your host PC. However, you can execute the target application using the __IAR C-SPY Debugger__ and, for example, a custom function that wraps the required parameters (for example, `iar_cspy_add_test()`). A module named `iar-cspy-<arch>.cmake` is included in the `CMakeLists.txt` files for target architectures and illustrates the concept.
   
>:warning: This section requires the __IAR C-SPY command line utility__ (`cspybat.exe`), which is installed with __IAR Embedded Workbench__.   

* Test the desired project example (*built with debug information*) by executing:
 ```
 ctest --test-dir _builds --build-config Debug --output-on-failure --timeout 10
 ```
>:bulb: The `ctest --help` command provides more information.   
   
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
When target applications are built with _debug information_, they can be debugged with the __IAR C-SPY Debugger__, directly in the __IAR Embedded Workbench__ IDE.

The [Debugging an Externally Built Executable file][url-iar-docs-ext-elf] Technical Note has instructions for setting up a __debug-only__ project.
   
## Issues
Did you find an issue or do you have a question related to the __cmake-tutorial__ tutorial?
- Visit the [cmake-tutorial wiki](https://github.com/IARSystems/cmake-tutorial/wiki).
- Check the public issue tracker for [earlier issues][url-repo-issue-old].
   - If you are reporting a [new][url-repo-issue-new] issue, please describe it in detail.   

## Conclusion
This tutorial provides information on how to start building embedded software projects and, also, on how to perform automated tests when using the IAR tools with CMake. When you have understood the core ideas presented here, a world of possibilities opens up. Such a setup might be useful depending on your organization's needs, and can be used as a starting point for particular customizations.

<!-- links -->
[url-repo-home]:         https://github.com/IARSystems/cmake-tutorial
[url-repo-issue-new]:    https://github.com/IARSystems/cmake-tutorial/issues/new
[url-repo-issue-old]:    https://github.com/IARSystems/cmake-tutorial/issues?q=is%3Aissue+is%3Aopen%7Cclosed
   
[url-iar-docs-tn190701]: https://www.iar.com/knowledge/support/technical-notes/general/using-cmake-with-iar-embedded-workbench/
[url-iar-docs-macros]:   https://wwwfiles.iar.com/arm/webic/doc/EWARM_DebuggingGuide.ENU.pdf#page=417
[url-iar-docs-cspybat]:  https://wwwfiles.iar.com/arm/webic/doc/EWARM_DebuggingGuide.ENU.pdf#page=503
[url-iar-docs-ext-elf]:  https://www.iar.com/knowledge/support/technical-notes/debugger/debugging-an-externally-built-executable-file/
   
[url-cmake-dl]:          https://github.com/kitware/cmake/releases/latest
[url-ninja-dl]:          https://github.com/ninja-build/ninja/releases/latest

[url-gh-docs-notify]:    https://docs.github.com/en/github/managing-subscriptions-and-notifications-on-github/setting-up-notifications/about-notifications
   
[url-cm-home]:           https://cmake.org
[url-cm-docs]:           https://cmake.org/documentation
[url-cm-docs-genex]:     https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
[url-cm-docs-ctest]:     https://cmake.org/cmake/help/latest/manual/ctest.1.html
[url-cm-wiki]:           https://gitlab.kitware.com/cmake/community/-/wikis/home
[url-cm-kitware]:        https://kitware.com
