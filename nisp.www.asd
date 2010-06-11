(asdf:defsystem :nisp.www
  :depends-on (:hunchentoot
               :hunchentoot-vhost
               :parenscript
               :cl-who
               :nutils
               :nisp.i
               :css
               ;; dependent on me
               :nisp.global
               )
  :serial t
  :components
  ((:file "hunchentoot-vhost-fix")
   (:file "hunchentoot-alpha")
   (:file "ninthbit")
   (:module :main
            :components
            ((:file "main")))))
