;;;; cl-secure-swank.asd

(asdf:defsystem #:cl-secure-swank
  :serial t
  :description "Restrict, what is allowed, when SWANK server reads requests."
  :author "Alexander Popolitov <popolit@gmail.com>"
  :license "GPLv3"
  :depends-on (#:swank #:cl-secure-read #:iterate)
  :components ((:file "package")
               (:file "cl-secure-swank")))

