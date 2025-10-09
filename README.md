# Building CMake projects with IAR

[![CI](https://github.com/iarsystems/cmake-tutorial/actions/workflows/ci.yml/badge.svg)](https://github.com/iarsystems/cmake-tutorial/actions/workflows/ci.yml) [![Code Analysis](https://github.com/iarsystems/cmake-tutorial/actions/workflows/codeql.yml/badge.svg)](https://github.com/iarsystems/cmake-tutorial/actions/workflows/codeql.yml)

CMake is an open-source, cross-platform family of tools maintained and supported by Kitware. Among its many features, it essentially provides [Makefile Generators](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html#id11) and [Ninja Generators](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html#id12) which compose scripts for cross-compiling C/C++ embedded software projects based on one or more `CMakeLists.txt` configuration files.

This tutorial offers a short introduction for those seeking information on how to start using the IAR C/C++ Compiler together with CMake from the command line. For diving deeper, consider visiting the [__cmake-tutorial wiki__](https://github.com/iarsystems/cmake-tutorial/wiki).


## Prerequisites
Before you begin, you will need to download and install the IAR product, CMake and then clone this repository.

1) Download, install and activate[^1] your IAR product

| Product                  | For Evaluation                                                                 | For IAR Subscribers
| -                        | -                                                                              | -
| IAR Build Tools (CX) ☁️  | [Contact us](https://iar.com/about/contact)                                    | for [Arm](https://updates.iar.com/?product=CXARM)<br>for [RISC-V](https://updates.iar.com/?product=CXRISCV)<br>for [Renesas RL78](https://updates.iar.com/?product=CXRL78)<br>for [Renesas RX](https://updates.iar.com/?product=CXRX)<br>
| IAR Build Tools (BX)     | [Contact us](https://iar.com/about/contact)                                    | for [Arm](https://updates.iar.com/?product=BXARM)[^2] (or for others[^3])
| IAR Embedded Workbench   | [Try now](https://www.iar.com/embedded-development-tools/free-trials)          | for [Arm](https://updates.iar.com/?product=EWARM)[^2] (or for others[^3])
     
2) Download and install [CMake](https://github.com/Kitware/CMake/releases/latest).

3) Clone this repository to your computer. For more information, see ["Cloning a repository"](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).

## Building a Basic CMake Project
>[!NOTE]
>While this guide is based on the IAR Build Tools for Arm (CXARM) 9.70.1 on Linux, it should work with other supported IAR products with no or minimal changes.

The most basic CMake project is an executable built from a single source code file. For simple projects like this, a `CMakeLists.txt` file with about half dozen of commands is all that is required.

Any project's topmost `CMakeLists.txt` must start by specifying a minimum CMake version using the [`cmake_minimum_required()`][url-help-cmake_minimum_required] command. This establishes policy settings and ensures that CMake functions used in the project are run with a compatible version of CMake.

To start a project, use the [`project()`][url-help-project] command to set the project name. This call is required with every project and should be called soon after `cmake_minimum_required()`. This command can also be used to specify other project level information such as the language(s) used or its version number.

Use the [`add_executable()`][url-help-add_executable] command to tell CMake to create an executable using the specified source code files.

Then use [`target_sources()`][url-help-target_sources] to list the source files required to build the target.

Use [`target_compile_options()`][url-help-target_compile_options] for setting up the compiler options to build the target.

And finally, set your target's linker options with [`target_link_options()`][url-help-target_link_options]:

```cmake
# set the minimum required version of CMake to be 3.20
cmake_minimum_required(VERSION 3.20)

# set the project name
project(Tutorial)

# add the executable target
add_executable(tutorial)

# target sources
target_sources(tutorial PRIVATE tutorial.c)

# compiler options
target_compile_options(tutorial PRIVATE
  --dlib_config full
  --cpu=cortex-m4)

# linker options
target_link_options(tutorial PRIVATE
  --cpu=cortex-m4
  --semihosting)
```

### Enabling the IAR Compiler
CMake uses the host platform's default compiler. When cross-compiling embedded applications, the compiler must be set manually via [`CMAKE_<lang>_COMPILER`](https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER.html) variables for each supported language. Additionally, it is possible to specify a build tool via [`CMAKE_MAKE_PROGRAM`]():

| Variable             | Description                               | Examples (for Arm)
| -                    | -                                         | -
| `CMAKE_C_COMPILER`   | Must point to the C Compiler executable   | `"/opt/iar/cxarm/arm/bin/iccarm"`<br>`"/opt/iarsystems/bxarm/arm/bin/iccarm"`<br>`"C:/iar/..../arm/bin/iccarm.exe"`
| `CMAKE_CXX_COMPILER` | Must point to the C++ Compiler executable | `"/opt/iar/cxarm/arm/bin/iccarm"`<br>`"/opt/iarsystems/bxarm/arm/bin/iccarm"`<br>`"C:/iar/..../arm/bin/iccarm.exe"`<br>`"${CMAKE_C_COMPILER}"`
| `CMAKE_ASM_COMPILER` | Must point to the Assembler executable    | `"/opt/iar/cxarm/arm/bin/iasmarm"`<br>`"/opt/iarsystems/bxarm/arm/bin/iasmarm"`<br>`"C:/iar/..../arm/bin/iasmarm.exe"`
| `CMAKE_MAKE_PROGRAM` | Must point to the build tool executable   | `"/opt/iar/cxarm/common/bin/ninja"`<br>`"/opt/iarsystems/bxarm/common/bin/ninja"`<br>`"C:/iar/..../common/bin/ninja.exe"`

During the configuration phase, CMake reads these variables from:
- a separate file called "toolchain file" that you invoke `cmake` with `--toolchain /path/to/<filename>.cmake` (see provided example files [cxarm.cmake](tutorial/cxarm.cmake), [bxarm.cmake](tutorial/bxarm.cmake) and [ewarm.cmake](tutorial/ewarm.cmake)) -or-
- the [`CMAKE_TOOLCHAIN_FILE`](https://cmake.org/cmake/help/latest/variable/CMAKE_TOOLCHAIN_FILE.html) variable, when you invoke `cmake` with `-DCMAKE_TOOLCHAIN_FILE=/path/to/<filename>.cmake` (useful for CMake < 3.21) -or-
- invoking `cmake` with `-DCMAKE_<lang>_COMPILER=/path/to/icc<target>` -or-
- the user/system environment variables [`CC`](https://cmake.org/cmake/help/latest/envvar/CC.html), [`CXX`](https://cmake.org/cmake/help/latest/envvar/CXX.html) and [`ASM`](https://cmake.org/cmake/help/latest/envvar/ASM.html) which can be used to override the platform's default compiler -or-
- the IAR Embedded Workbench IDE 9.3 or later, shipped with IAR products starting from the IAR Embedded Workbench for Arm 9.50, where the available IAR toolchain environment is automatically set for CMake projects (See [this article](https://github.com/IARSystems/cmake-tutorial/wiki/Building-and-Debugging-from-the-Embedded-Workbench) for details).

### Configure and Build
We are ready to build our first project! Run CMake to configure the project and then build it with your chosen build tool.

- Before starting to use CMake, make sure your compiler is working properly. Below you will find an oneliner that will try to compile a simple module:
```console
$ echo "main(){}" | /opt/iar/cxarm/arm/bin/iccarm --output $(mktemp) -

   IAR ANSI C/C++ Compiler V9.70.1.475/LNX for ARM
   Copyright 1999-2025 IAR Systems AB.
   LMS Cloud License (LMSC 1.5.0)
 
 4 bytes of CODE memory

Errors: none
Warnings: none
```

- From the terminal, navigate to the [tutorial](tutorial) directory and create a build directory:
```
mkdir build
```

- Next, navigate to that build directory and run CMake to configure the project and generate a native build system using the compiler specified in the `cxarm.cmake` toolchain file (if needed, edit the supplied toolchain file to match your tool):
```
cd build
cmake .. -G Ninja --toolchain ../cxarm.cmake
```

- Then call CMake for building the executable using the build system:
```
cmake --build .
```

## Run
Let's test the application. To run the executable you will need the non-interactive[^4] command line interface for the IAR C-SPY Debugger (`cspybat`) with the proper drivers for the desired target. Amongst the many ways of accomplishing this, let's take advantage of the `add_test()` for testing the application in a Arm Cortex-M4 simulated target.

This section is interactive. In this example we will use Arm. So, you will need to update your Tutorial's `CMakeLists.txt`:
- Firstly add [`enable_testing()`](https://cmake.org/cmake/help/latest/command/enable_testing.html) to enable testing:
```cmake
enable_testing()
```

- Then use [`add_test()`](https://cmake.org/cmake/help/latest/command/add_test.html) to encapsulate the command line `cspybat` needs. In the example below, the parameters are adjusted for simulating a generic Arm Cortex-M4 target environment:
```cmake
add_test(NAME tutorialTest
         COMMAND /opt/iar/cxarm/common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         /opt/iar/cxarm/arm/bin/libarmPROC.so
         /opt/iar/cxarm/arm/bin/libarmSIM2.so
         --plugin=/opt/iar/cxarm/arm/bin/libarmLibsupportUniversal.so
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:tutorial>
         # C-SPY driver options
         --backend
           --cpu=cortex-m4
           --semihosting)
```
>[!TIP]
>- Read this [article](https://github.com/iarsystems/cmake-tutorial/wiki/CTest-with-IAR-Embedded-Workbench-for-Arm) for the specifics when driving tests from IAR Embedded Workbench for Arm.

- Now use the [`PASS_REGULAR_EXPRESSION`](https://cmake.org/cmake/help/latest/prop_test/PASS_REGULAR_EXPRESSION.html) test property to validate if the program emits the expected string to the standard output (`stdout`). In this case, verifying that `printf()` prints the expected message.
```cmake
set_tests_properties(tutorialTest PROPERTIES PASS_REGULAR_EXPRESSION "Hello world!")
```

- Since `CMakeLists.txt` was modified, the build system needs to be reconfigured. Rebuilding the project will automatically force reconfiguration, creating the `CTestTestfile.cmake` file:
```
cmake --build .
```

- And finally we call CMake's [`ctest`](https://cmake.org/cmake/help/latest/manual/ctest.1.html) which subsequently will execute `Tutorial.elf` using the IAR C-SPY Debugger for Arm:
```
ctest
```

## Summary
This tutorial covered the basics on using CMake with the IAR tools from the command line. Proceed to the [wiki](https://github.com/IARSystems/cmake-tutorial/wiki) for additional interactive examples, tips & tricks!

[__` Follow us `__](https://github.com/iarsystems) on GitHub to get updates about tutorials like this and more.


## Issues
For reporting CMake software defects use the [CMake Issue Tracker](https://gitlab.kitware.com/cmake/cmake/-/issues/).

For technical support contact [IAR Customer Support][url-iar-customer-support].

For questions related to this tutorial: try the [wiki][url-repo-wiki] or check [earlier issues][url-repo-issue-old]. If those don't help, create a [new issue][url-repo-issue-new] with detailed information.

[^1]: For more information, see the "Installation and Licensing" guide for your product. If you are not a subscriber yet, [contact us](https://iar.com/about/contact).
[^2]: For downloading the installers, IAR Subscribers must first perform login on [IAR MyPages](https://mypages.iar.com/s/login).
[^3]: CMake has built-in IAR C/C++ Compiler support for the following non-Arm architectures: 8051, AVR, MSP430, RH850, RISC-V, RL78, RX, STM8 and V850.
[^4]: For interactively debugging of executable files (`*.elf`) using the C-SPY Debugger from the IAR Embedded Workbench IDE, read [this wiki article][url-wiki-ide-build-debug].


<!-- links -->
[url-iar-customer-support]: https://iar.my.site.com/mypages/s/contactsupport

[url-repo-wiki]: https://github.com/IARSystems/cmake-tutorial/wiki
[url-repo-issue-new]: https://github.com/IARSystems/cmake-tutorial/issues/new
[url-repo-issue-old]: https://github.com/IARSystems/cmake-tutorial/issues?q=is%3Aissue+is%3Aopen%7Cclosed

[url-help-cmake_minimum_required]: https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html
[url-help-project]: https://cmake.org/cmake/help/latest/command/project.html
[url-help-add_executable]: https://cmake.org/cmake/help/latest/command/add_executable.html
[url-help-target_sources]: https://cmake.org/cmake/help/latest/command/target_sources.html
[url-help-target_compile_options]: https://cmake.org/cmake/help/latest/command/target_compile_options.html
[url-help-target_link_options]: https://cmake.org/cmake/help/latest/command/target_link_options.html

[url-wiki-ide-build-debug]: https://github.com/IARSystems/cmake-tutorial/wiki/Building-and-Debugging-from-the-Embedded-Workbench
