# Building CMake projects with IAR

CMake is an open-source, cross-platform family of tools maintained and supported by Kitware. Among its many features, it essentially provides [Makefile Generators](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html#id11) and [Ninja Generators](https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html#id12) which compose scripts for cross-compiling C/C++ embedded software projects based on one or more `CMakeLists.txt` configuration files.

This tutorial offers a short introduction for those seeking information on how to start using the IAR C/C++ Compiler together with CMake from the command line. While this guide is based on the IAR Build Tools for Arm version 9.50.1 on Linux, it should work with other supported IAR products with no or minimal changes.

## Prerequisites
Before you begin, you will need to download and install the IAR product, CMake and then clone this repository.

1) Download, install and activate[^1] your IAR product

| __Product__            | __Evaluation__                                 | __IAR Customers (login required)__                |
| -                      | -                                              | -                                                 |
| IAR Build Tools        | [Contact us](https://iar.com/about/contact) | [for Arm](https://updates.iar.com/?product=BXARM) (or for others[^2]) |
| IAR Embedded Workbench | [Download](https://iar.com/downloads)          | [for Arm](https://updates.iar.com/?product=EWARM) (or for others[^2]) |
     
2) Download and install [CMake](https://github.com/Kitware/CMake/releases/latest).

3) Clone this repository to your computer. For more information, see ["Cloning a repository"](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).

## Building a Basic CMake Project
The most basic CMake project is an executable built from a single source code file. For simple projects like this, a `CMakeLists.txt` file with about half dozen of commands is all that is required.

Any project's topmost `CMakeLists.txt` must start by specifying a minimum CMake version using the [`cmake_minimum_required()`][url-help-cmake_minimum_required] command. This establishes policy settings and ensures that CMake functions used in the project are run with a compatible version of CMake.

To start a project, use the [`project()`][url-help-project] command to set the project name. This call is required with every project and should be called soon after [`cmake_minimum_required()`][url-help-cmake_minimum_required]. This command can also be used to specify other project level information such as the language(s) used or its version number.

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
target_compile_options(tutorial PRIVATE --cpu=cortex-m4)

# linker options
target_link_options(tutorial PRIVATE --semihosting)
```

### Enabling the IAR Compiler
CMake uses the host platform's default compiler. When cross-compiling embedded applications, the compiler must be set manually via [`CMAKE_<lang>_COMPILER`](https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_COMPILER.html) variables for each supported language. Additionally, it is possible to specify a build tool via [`CMAKE_MAKE_PROGRAM`]():

| Variable             | Description                               | Examples                                                                        |
| -                    | -                                         | -                                                                               |
| `CMAKE_C_COMPILER`   | Must point to the C Compiler executable   | `"C:/Program Files/..../arm/bin/iccarm.exe"`<br>`"/opt/iarsystems/bxarm/arm/bin/iccarm"`   |
| `CMAKE_CXX_COMPILER` | Must point to the C++ Compiler executable | `"C:/Program Files/..../arm/bin/iccarm.exe"`<br>`"/opt/iarsystems/bxarm/arm/bin/iccarm"`   |
| `CMAKE_ASM_COMPILER` | Must point to the Assembler executable    | `"C:/Program Files/..../arm/bin/iasmarm.exe"`<br>`"/opt/iarsystems/bxarm/arm/bin/iasmarm"` |
| `CMAKE_MAKE_PROGRAM` | Must point to the build tool executable | `"C:/Program Files/..../common/bin/ninja.exe"`<br>`"/opt/iarsystems/bxarm/common/bin/ninja"` |

CMake reads these variables from
- a separate file called "toolchain file" that you invoke with [`--toolchain /path/to/<your-iar-toolchain-file>.cmake`](tutorial/bxarm.cmake)) -or-
- invoking `cmake` with `-DCMAKE_<lang>_COMPILER=...` on the command line, during the configuration phase (useful for old CMake versions) -or-
- the user/system environment variables [`CC`](https://cmake.org/cmake/help/latest/envvar/CC.html), [`CXX`](https://cmake.org/cmake/help/latest/envvar/CXX.html) and [`ASM`](https://cmake.org/cmake/help/latest/envvar/ASM.html) which can be used to override the platform's default compiler -or-
- the IAR Embedded Workbench IDE 9.3 or later, shipped with IAR products starting from the IAR Embedded Workbench for Arm 9.50, where the available IAR toolchain environment is automatically set for CMake projects.

### Configure and Build
We are ready to build our first project! Run CMake to configure the project and then build it with your chosen build tool.

- Before starting to use CMake, make sure your compiler is working and does not run into any [license issues](#issues). Example (for Arm):
```
/path/to/iccarm --version
```

- From the terminal, navigate to the [tutorial](tutorial) directory and create a build directory:
```
mkdir build
```

- Next, navigate to that build directory and run CMake to configure the project and generate a native build system using the compiler specified in the `bxarm.cmake` toolchain file (if needed, edit the supplied toolchain file to match your tool):
```
cd build
cmake .. -G Ninja --toolchain ../bxarm.cmake
```

- Then call CMake for building the executable using the build system:
```
cmake --build .
```

## Run
Let's test the application. To run the executable you will need the non-interactive[^3] command line interface for the IAR C-SPY Debugger (`cspybat`) with the proper drivers for the desired target. Amongst the many ways of accomplishing this, let's take advantage of the `add_test()` for testing the application in a Arm Cortex-M4 simulated target.

 In this example we will use Arm. To do so, we need to change the Tutorial's `CMakeLists.txt`:
- Firstly add [`enable_testing()`](https://cmake.org/cmake/help/latest/command/enable_testing.html#command:enable_testing) to enable testing:
```cmake
enable_testing()
```

- Then use [`add_test()`](https://cmake.org/cmake/help/latest/command/add_test.html#add-test) to encapsulate the command line `cspybat` needs. In the example below, the parameters are adjusted for simulating a generic Arm Cortex-M4 target environment:
```cmake
add_test(NAME tutorialTest
         COMMAND /opt/iarsystems/bxarm/common/bin/CSpyBat
         # C-SPY drivers for the Arm simulator via command line interface
         /opt/iarsystems/bxarm/arm/bin/libarmPROC.so
         /opt/iarsystems/bxarm/arm/bin/libarmSIM2.so
         --plugin=/opt/iarsystems/bxarm/arm/bin/libarmLibsupportUniversal.so
         # The target executable (built with debug information)
         --debug_file=$<TARGET_FILE:tutorial>
         # C-SPY driver options
         --backend
           --cpu=cortex-m4
           --semihosting)
```

- Now use the [`PASS_REGULAR_EXPRESSION`](https://cmake.org/cmake/help/latest/prop_test/PASS_REGULAR_EXPRESSION.html#prop_test:PASS_REGULAR_EXPRESSION) test property to validate if the program emits the expected string to the standard output (`stdout`). In this case, verifying that the usage message is printed when an incorrect number of arguments is provided.
```cmake
set_tests_properties(tutorialTest PROPERTIES PASS_REGULAR_EXPRESSION "Hello world!")
```

- Since `CMakeLists.txt` was modified, the build system needs to be reconfigured:
```
cmake --build .
```

- And finally we call CMake's [`ctest`](https://cmake.org/cmake/help/latest/manual/ctest.1.html#manual:ctest(1)) which subsequently will execute `Tutorial.elf` using the IAR C-SPY Debugger for Arm:
```
ctest
```

## Summary
This tutorial covered the basics on using CMake with the IAR tools from the command line. Proceed to the [wiki](https://github.com/IARSystems/cmake-tutorial/wiki) for additional tips & tricks!

## Issues
Use the [CMake Issue Tracker](https://gitlab.kitware.com/cmake/cmake/-/issues/) to report CMake-related software defects.

For questions/suggestions specifically related to this tutorial:
- Try the [wiki][url-repo-wiki].
- Check for [earlier issues][url-repo-issue-old] in the issue tracker.
- If nothing helps, create a [new issue][url-repo-issue-new], describing in detail.

Do not use the issue tracker if you need technical support. The issue tracker **is not a support forum**:
- If you run into license issues, refer to [IAR Customer Care](https://iar.com/knowledge/support/licensing-faq/).
- If you run into tools issues, contact [IAR Tech Support](https://iar.com/knowledge/support/request-technical-support/).

[^1]: For more information, see the "Installation and Licensing" guide for your product. If you do not have a license, [contact us](https://iar.com/about/contact).
[^2]: CMake has built-in IAR C/C++ Compiler support for the following non-Arm architectures: 8051, AVR, MSP430, RH850, RISC-V, RL78, RX, STM8 and V850.
[^3]: For interactively debugging of executable files (`*.elf`) using the C-SPY Debugger from the IAR Embedded Workbench IDE, read [this technical note][url-iar-docs-ext-elf].

<!-- links -->
[url-repo-wiki]: https://github.com/IARSystems/cmake-tutorial/wiki
[url-repo-issue-new]: https://github.com/IARSystems/cmake-tutorial/issues/new
[url-repo-issue-old]: https://github.com/IARSystems/cmake-tutorial/issues?q=is%3Aissue+is%3Aopen%7Cclosed

[url-help-cmake_minimum_required]: https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html#command:cmake_minimum_required
[url-help-project]: https://cmake.org/cmake/help/latest/command/project.html#command:project
[url-help-add_executable]: https://cmake.org/cmake/help/latest/command/add_executable.html#command:add_executable
[url-help-target_sources]: https://cmake.org/cmake/help/latest/command/target_sources.html#target-sources
[url-help-target_compile_options]: https://cmake.org/cmake/help/latest/command/target_compile_options.html#target-compile-options
[url-help-target_link_options]: https://cmake.org/cmake/help/latest/command/target_link_options.html#target-link-options

[url-iar-docs-ext-elf]:  https://www.iar.com/knowledge/support/technical-notes/debugger/debugging-an-externally-built-executable-file/
