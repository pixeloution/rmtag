rmtag
=====

Bulk Deletion of Git Tags. This should be run from within a git project in order to delete tags. You must have ruby installed on your system for this to work.

If you copy this file to your `/usr/bin` directory and make it executable (or anything else in your PATH) you can use it like any other tool:

    rmtag --test 0 3

Strictly speaking, `--test` isn't required but it makes me feel better to type it.
    

**NAME**
  
    rmtag

**SYNOPSIS**
  
    rmtag --execute minVersion maxVersion
    rmtag --test minVersion maxVersion

**DESCRIPTION**
  
    when run within a directory version controlled by git, deletes all tags
    between minVersion and maxVersion, including exact
    matches for minVersion and maxVersion

**OPTIONS**    
  
    -h, --help
    show this help file

    -e, --execute
    run the commands generated by the program

    -t, --test
    only output the commands to stdout, do not run them. this is the default mode
    if --execute is not specified.
