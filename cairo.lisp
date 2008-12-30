(in-package :cl-cairo2)

;; is this really needed? OS should set this up properly
#+darwin (pushnew "/usr/local/lib/" *foreign-library-directories*)
#+darwin (pushnew "/opt/local/lib/" *foreign-library-directories*)

;;;; The library search order should look like below because on Mac both
;;;; 'darwin' and 'unix' are defined in *feature* and we want to load .dylib
;;;; version of library.

(define-foreign-library :libcairo
	(cffi-features:darwin	"libcairo.dylib")
  	(:or (cffi-features:unix "libcairo.so.2") (cffi-features:unix "libcairo.so"))
	(cffi-features:windows	"libcairo-2.dll"))
	 
(load-foreign-library :libcairo)

(defun deg-to-rad (deg)
  "Convert degrees to radians."
  (* deg (/ pi 180.0d0)))

(defgeneric destroy (object)
  (:documentation "Destroys Cairo object."))
(export 'destroy)

;;;;
;;;;  commonly used macros/functions
;;;;

(defun prepend-intern (prefix name &key (replace-dash t) (suffix ""))
  "Create and intern symbol PREFIXNAME from NAME, optionally
  replacing dashes in name.  PREFIX is converted to upper case.
  If given, suffix is appended at the end."
  (let ((name-as-string (symbol-name name)))
    (when replace-dash
      (setf name-as-string (substitute #\_ #\- name-as-string))
            suffix (substitute #\_ #\- suffix))
    (intern (concatenate 'string (string-upcase prefix)
			 name-as-string (string-upcase suffix)))))

(defun copy-double-vector-to-pointer (vector pointer)
  "Copies vector of double-floats to a memory location."
  (dotimes (i (length vector))
    (setf (mem-aref pointer :double i) (coerce (aref vector i) 'double-float))))

(defun copy-pointer-to-double-vector (length pointer)
  "Copies the contents of a memory location to a vector of a double-floats."
  (let ((vector (make-array length)))
    (dotimes (i length vector)
      (setf (aref vector i) (mem-aref pointer :double i)))))
