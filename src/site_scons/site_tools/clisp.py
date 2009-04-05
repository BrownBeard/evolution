import SCons.Builder as Builder
import os

def exists(env):
    return env.Detect('clisp') and env.Detect('combine')

def generate(env):
    env.AppendENVPath('PATH', os.environ['HOME'] + '/bin')
    env["CLC"] = "clisp"
    env["CLCOMBINE"] = "combine"
    env["CLCFLAGS"] = ["-q", "-q"] # There might be a better way..
    env["CLSCRIPTSUFFIX"] = ""

    clisp_compiler = Builder.Builder(
            action = "$CLC $CLCFLAGS -c $SOURCE",
            src_suffix = ".lisp",
            suffix = ".fas",
            single_source = True,
            )

    clisp_linker = Builder.Builder(
            action = "$CLCOMBINE $SOURCES $TARGET",
            src_suffix = ".fas",
            suffix = "$CLSCRIPTSUFFIX",
            src_builder = clisp_compiler
            )

    env.Append(BUILDERS={"ClispProgram" : clisp_linker,
                         "ClispObject" : clisp_compiler})
