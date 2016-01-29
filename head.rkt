#lang racket/base

(require racket/list)

(define (head-css)
  (map (lambda (c) `(link ((rel "stylesheet")
                           (href ,(path->string (build-path "/css" c)))
                           (type "text/css"))))
       '("bootstrap.min.css"
         "app.css")))

(define (head-js)
  (map (lambda (j) `(script ((src ,(path->string (build-path "/js" j)))
                             (type "text/javascript"))))
       '("jquery.min.js"
         "bootstrap.min.js")))

(define (ameno-head)
  `(head (meta ((charset "utf-8")))
         (meta ((http-equiv "X-UA-Compatible")
                (content "IE=edge")))
         (meta ((name "viewport")
                (content "width=device-width, initial-scale=1")))
         (title "Ameno")
         ,@(head-css)
         ,@(head-js)))

(provide ameno-head)
