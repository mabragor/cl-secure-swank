cl-secure-swank
===============

Restict what is accepted by SWANK server.

Roadmap
  * (done) discard incoming packages, that exceed certain length,
  * (done in git-clone of slime directly) using CL-SECURE-READ to disable unwanted reader-macros,
  * (done in slime) restrict the range of accepted SWANK RPC codes,
  * restrict, which operators are allowed in the input.

When your brand-new-cool-CL application needs to communicate with external world,
you are tempted to invent your own brand-new-cool-socket-based protocol.

You may not want to do the job twice.
You may consider reusing SWANK protocol, which underlies interaction of EMACS's SLIME mode with
the lisp core.

However, SWANK protocol effectively allows to execute arbitrary lisp-code on the server,
thus providing a backdoor, if socket is exposed to the internet.

This package tries to cure this drawback by allowing to customize, what swank will accept, and what it
will not.

Now it heavily relies on fixes I proposed to SLIME, if they are accepted, this package will start to work.