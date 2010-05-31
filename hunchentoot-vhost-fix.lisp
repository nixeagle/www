(in-package :hunchentoot-vhost)

;;; This is a copy from hunchentoot-vhost.lisp tweaked to let me define
;;; actual functions as define-easy-handler does.
(defmacro define-easy-virtual-handler (virtual-host description lambda-list &body body)
  "Defines an easy-virtual-handler for use with a given
virtual-host. See hunchentoot:define-easy-handler for documentation of
the description and lambda-list arguments."
  (destructuring-bind (name
                       &key uri
                       (server-names t)
                       (default-parameter-type ''string)
                       (default-request-type :both))
      (if (atom description)
          (list description)
          description)
    (hunchentoot::with-unique-names (fn)
      `(let ((,fn (defun ,name (&key ,@(loop for part in lambda-list
                                     collect
                                     (hunchentoot::make-defun-parameter
                                      part
                                      default-parameter-type
                                      default-request-type)))
                    ,@body)))
         (declare (ignore ,fn))
         ,@(when uri
                 (list
                  (hunchentoot::with-rebinding (uri)
                    `(progn
                       (setf (virtual-host-easy-handler-alist ,virtual-host)
                             (delete-if (lambda (list)
                                          (equal ,uri (first list)))
                                        (virtual-host-easy-handler-alist ,virtual-host)))
                       (push (list ,uri ,server-names ',name)
                             (virtual-host-easy-handler-alist ,virtual-host))))))))))
;;; END

