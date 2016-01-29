#lang racket

(require web-server/servlet)
(provide/contract (start (request? . -> . response?)))

(define (start request)
  (render-main-page request))

; render-main-page: request -> doesn't return
; Generate the main page where
;
(define (render-main-page request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "Ameno"))
            (body
             (h1 "Paste DNA here")
             (form ((action ,(embed/url process-dna-handler)))
                   (textarea ((name "dna")))
                   (input ((type "submit"))))))))
  (define (process-dna-handler request)
    (define bindings (request-bindings request))
    (render-music-page
     (extract-binding/single 'dna bindings)
     (redirect/get)))
  (send/suspend/dispatch response-generator))

(define (render-music-page dna-text request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "Ameno"))
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

;; Translation


(require web-server/servlet-env)
(serve/servlet start
               #:launch-browser? #f
               #:quit? #f
               #:listen-ip #f
               #:port 8000
               #:extra-files-paths
               (list (build-path (current-directory) "htdocs"))
               #:servlet-path
               "/servlets/AMENO.rkt")
