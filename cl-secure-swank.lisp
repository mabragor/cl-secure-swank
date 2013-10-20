;;;; cl-secure-swank.lisp

(in-package #:cl-secure-swank)

(defun discard-input (stream length)
  "Discards LENGTH bytes from STREAM."
  (let* ((buf-len 4096) ; reasonable
	 (buf (make-array buf-len :element-type '(unsigned-byte 8))))
    (iter (while (> length buf-len))
	  (read-sequence buf stream)
	  (decf length buf-len))
    (read-sequence buf stream :end length)))

(defun remove-invalid-rpcs (invalid-rpcs all-rpcs)
  (iter (for (kwds args handler) in all-rpcs)
        (let ((it (remove-if (lambda (x)
                               (member x invalid-rpcs))
                             (if (listp kwds) kwds `(,kwds)))))
          (if it
              (collect `(,it ,args ,handler))))))
              
(in-package :swank)

(defvar *packet-critical-length* nil
  "Length, after which a packet is discarded. When NIL, packets are not discarded because of their length.")

(defvar *macrochar-whitelist* '(:allow-read-eval))
(defvar *macrochar-blacklist* '(:t))

(defmacro with-macrochar-secured-reader (&body body)
  `(let ((*reader* (cl-secure-read::secure-read-from-string-lambda swank-reader-from-string
                                                                   :blacklist *macrochar-blacklist*
                                                                   :whitelist *macrochar-whitelist*)))
     ,@body))

(defmacro with-swank-rpcs-disabled (lst &body body)
  "Disable some rpcs from the list of default ones."
  `(let ((*valid-rpcs* (cl-secure-swank::remove-invalid-rpcs lst *valid-rpcs*)))
     ,@body))

(export '(*packet-critival-length* *macrochar-whitelist* *macrochar-blacklist*
          with-macrochar-secured-reader with-swank-rpcs-disabled))
        

(in-package #:swank-rpc)

(defun read-packet (stream)
  (let ((length (parse-header stream)))
    (if (and swank::*packet-critical-length* (> length packet-critical-length))
	(progn (cl-secure-swank:discard-input stream length)
	       "")
	(let ((octets (read-chunk stream length)))
	  (handler-case (swank-backend:utf8-to-string octets)
	    (error (c) 
	      (error 'swank-reader-error 
		     :packet (asciify octets)
		     :cause c)))))))
	  
