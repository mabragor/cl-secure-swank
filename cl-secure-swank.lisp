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

(in-package :swank-rpc)

(defvar packet-critical-length nil
  "Length, after which a packet is discarded. When NIL, packets are not discarded because of their length.")

(defun read-packet (stream)
  (let ((length (parse-header stream)))
    (if (and packet-critical-length (> length packet-critical-length))
	(progn (cl-secure-swank:discard-input stream length)
	       "")
	(let ((octets (read-chunk stream length)))
	  (handler-case (swank-backend:utf8-to-string octets)
	    (error (c) 
	      (error 'swank-reader-error 
		     :packet (asciify octets)
		     :cause c)))))))
	  
    
    

