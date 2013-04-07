cl-secure-swank
===============

Restict what is accepted by SWANK server.

Suppose, you have written a cool CL application, which needs to communicate with external world.
For example, it may be, that CL application is a server side of some client-server pair.
How to implement interaction between server and client?

One possible way is to reuse the SWANK protocol, which is a basis of interation between
SLIME (Superior Lisp Interaction Mode for Emacs) and superior CL.
However, exposing a port on which a SWANK server is listening to the net just like that is rather risky,
since no checking is done, when receiving an input.

In particular, anyone with a knowledge of a SWANK protocol would be able to perform READ-EVAL tricks as
well as requests to recompile certain function in the Lisp image.
Effectively, this is equivalent to opening a backdoor into the system.

This package tries to cure this drawback.

It allows (or is planned to allow) to
  * discard packages, that exceed certain length,
  * using CL-SECURE-READ to disable unwanted reader-macros,
  * restrict the range of accepted SWANK RPC codes,
  * restrict, which operators are allowed in the input.

Hopefully, all, that will be developed in this package, will be merged into SWANK package, once
it is well tested and made convenient to use.