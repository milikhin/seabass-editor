"""
Provides function to run executables
"""
import subprocess
import shlex
import re

def exec_cmd(command_string, cwd='/home/phablet', nowait=False):
    """
    Executes given subprocess, returns iterable list of stdout lines

    Keyword arguments:
    command_string -- cmd string to execute
    """
    cmd_args = shlex.split(command_string)
    with subprocess.Popen(cmd_args,
                          stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT,
                          universal_newlines=True,
                          cwd=cwd) as process:
        if nowait is True:
            return

        for stdout_line in iter(process.stdout.readline, ''):
            yield strip_color(stdout_line)
        return_code = process.wait()
        if return_code:
            raise subprocess.CalledProcessError(return_code, command_string)

def strip_color(s): # pylint: disable=invalid-name
    """
    Remove ANSI color/style sequences from a string. The set of all possible
    ANSI sequences is large, so does not try to strip every possible one. But
    does strip some outliers seen not just in text generated by this module, but
    by other ANSI colorizers in the wild. Those include `\x1b[K` (aka EL or
    erase to end of line) and `\x1b[m`, a terse version of the more common
    `\x1b[0m`.

    from: https://github.com/jonathaneunice/colors
    """
    return re.sub('\x1b\\[(K|.*?m)', '', s)
