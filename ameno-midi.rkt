#lang racket

(require web-server/servlet)
(provide/contract (start (request? . -> . response?)))

(require "head.rkt")

(define (start request)
  (render-main-page request))

; render-main-page: request -> doesn't return
; Generate the main page html
(define (render-main-page request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html ,(ameno-head)
            (body
             (h1 "Paste DNA here")
             (form ((action ,(embed/url process-dna-handler)))
                   (div ((class "form-group"))
                        (div ((class "col-md-6")))
                        (textarea ((class "form-control")
                                   (rows "5")
                                   (name "dna")))
                        (input ((type "submit")
                                (class "btn btn-default")))))))))
  (define (process-dna-handler request)
    (define bindings (request-bindings request))
    (render-music-page
     (extract-binding/single 'dna bindings)
     (redirect/get)))
  (send/suspend/dispatch response-generator))

(define (render-music-page dna-text request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html ,(ameno-head)
            (body
             (h1 "Enjoy the tune")
             (p ,dna-text)
             (a ((href ,(embed/url back-handler)))
                "Go again")))))
  (define (back-handler request)
    (render-main-page request))
  (send/suspend/dispatch response-generator))

;; Transcription
; A -> U
; T -> A
; C -> G
; G -> C

(require web-server/servlet-env)
(serve/servlet start
               #:launch-browser? #f
               #:quit? #f
               #:listen-ip #f
               #:port 8000
               #:extra-files-paths
               (list (build-path (current-directory) "lib"))
               #:servlet-path
               "/servlets/AMENO.rkt")
