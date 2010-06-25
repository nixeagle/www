;;; nothing for now until vhost is fixed up.
(defpackage #:nixeagle.www.main
  (:use :cl :hunchentoot :hunchentoot-vhost :nutils :cl-who :parenscript :css)
  (:shadowing-import-from :parenscript :switch :var))

(in-package :nixeagle.www.main)

(defparameter *main*
  (hunchentoot-vhost:make-virtual-host "main" '("test.nixeagle.net"
                                                "test.nixeagle.org"
                                                "nixeagle.net")))
#+ nisp-vps
(add-virtual-host *main* (assoc-value cl-user::*root-ports* 80))
#+ nisp-devel
(progn
 (add-virtual-host *main* www::*nisp-1337-acceptor*)
 (add-virtual-host *main* www::*nisp-8080-acceptor*)
 (add-virtual-host *main* www::*nisp-6667-acceptor*))
(defun front-page-css ()
  (css ()
    ((:body) :font-size 12pt
     :font-family '("DejaVu Sans" "Bitstream Vera Sans"
                    "Verdana" "Helvetica" "sans-serif")
     :height 100%
    #+ () (:background-color \#ffeedd)
     (:background-color white)
     (:color black))
#+ ()    ((:ul) (:color white)
     :background-color \#367C48)
  #+ ()  ((:a) (:color lightblue))))

(define-easy-virtual-handler *main*
    (front-page :uri "/")
    ()
  (with-html-output-to-string (*standard-output* nil :indent t)
    (:html
     (:head
      (:title "nixeagle's site")
      (:style :type "text/css"
              (front-page-css)))
     (:body
      (:p "My projects are:")
      (:ul
       (:li (htmlize-github-project "nisp" "Bunch of various lisp things."))
       (:li (htmlize-github-project "nass" "Attempt at a lisp assembler. Sorta working 16 bit x86 assembly."))
       (:li (htmlize-github-project "cl-github" "Implementation of the github v2 API in common lisp."))
       (:li (htmlize-github-project "php-serialization" "Serialize to and from php's serialize() format."))
       (:li (htmlize-github-project "convert" "Generic conversion utility for common lisp"))
       (:li (htmlize-github-project "ooc-mode" "Emacs major mode for ooc-lang."))
       (:li (htmlize-github-project "binary-data" "Common lisp binary data handling library."))
       (:li (htmlize-github-project "loki" "Implementation of Ioke in common lisp."))
       (:li (htmlize-github-project "nutils" "Common lisp utilities extending alexandria."))
       (:li (htmlize-github-project "cl-css" "Lisp to CSS translator."))
       (:li (htmlize-github-project "ooc-mode"
                                    "Emacs major mode for ooc.")))
      (:p "Useful links")
      (:ul
       (:li (:a :href "http://cvs.savannah.gnu.org/viewvc/*checkout*/emacs/etc/refcards/refcard.pdf?revision=1.1&root=emacs" "GNU Emacs Reference Card")))))))

(defun htmlize-github-project (name summary &key (stream *standard-output*))
  "Generate html form suitable for a list entry."
  (with-html-output (stream)
    (:a :href (conc "http://github.com/nixeagle/" name) (str name))
    ": " (str summary)))

(with-output-to-string (*standard-output*)
  (htmlize-github-project "hi" "hi"))

(defun html-list (list &key (stream *standard-output*)
                  (list-type :ul))
  (declare ((member :ul :ol) list-type))
  (with-html-output (stream)
    (list-type
     (dolist (item list)
       (htm
        (:li (str item)))))))

;;; END
