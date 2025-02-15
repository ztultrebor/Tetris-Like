;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname tetris) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)


; data definitions

(define-struct tetris [piece sediment])
; A Tetris is a [Point ListOfPoints]
; It consists of a Point that determines the location of the piece
; the player is controlling, as well as a ListOfPoints that give the
; locations of all the pieces that have previously landed
#;
(define (fn-on-tetris tg)
  ... (fn-on-point tetris-piece) ... (fn-on-list-of-points tetris-sediment))


; A Sediment is a ListOfPoints
; Each point describes a location on the game board on
; which an old piece has settled
#;
(define (fn-on-sediment sd)
  (cond
    [(empty? sd) ...]
    [(empty? (rest sd)) ...]
    [else ... (fn-on-point (first sd)) ... (fn-on-sediment (rest sd))]))


(define-struct point [x y])
; A Point is a [N N]
; It consists of two natural numbers that correspond to x and y
; positions on the game board
#;
(define (fn-on-point p)
  ... (point-x p) ... (point-y p))



; constants

(define (make-piece color)
  ; String -> Img
  ; implement piece design as a function
  (beside
   (rectangle SPACER SEGMENTSIZE "solid" BACKGROUNDCOLOR)
   (above
    (rectangle SEGMENTSIZE SPACER "solid" BACKGROUNDCOLOR)
    (overlay/align
     "left" "bottom" (circle CURVATURE "solid" color)
     (overlay/align
      "right" "bottom" (circle CURVATURE "solid" color)
      (overlay/align
       "right" "top" (circle CURVATURE "solid" color)
       (overlay/align
        "left" "top" (circle CURVATURE "solid" color)
        (overlay
         (rectangle SEGMENTSIZE PULLBACK "solid" color)
         (rectangle PULLBACK SEGMENTSIZE "solid" color)))))))))

(define PIECECOLOR "blue")
(define SEDIMENTCOLOR "gray")
(define BACKGROUNDCOLOR "white")
(define UNITCELLSIZE 16)
(define NCELLSHORIZ 24)
(define NCELLSVERT 30)
(define CANVASWIDTH (* NCELLSHORIZ UNITCELLSIZE))
(define CANVASHEIGHT (* NCELLSVERT UNITCELLSIZE))
(define STARTPOINT (make-point (quotient NCELLSHORIZ 2) 0))
(define SPACER 1)
(define SEGMENTSIZE (- UNITCELLSIZE SPACER))
(define CURVATURE 4)
(define PULLBACK (- SEGMENTSIZE CURVATURE CURVATURE))
(define SEDIMENTPIECE (make-piece SEDIMENTCOLOR))
(define ACTIVEPIECE (make-piece PIECECOLOR))
(define GAMEBOARD  (empty-scene CANVASWIDTH CANVASHEIGHT BACKGROUNDCOLOR))


; functions


(define (main sg)
  ; Tetris -> Tetris
  ; run the game
  (big-bang sg
    [on-tick update-game 1/7]
    [to-draw render-game]
    [on-key sidle-piece]
    [stop-when done? game-over]))


(define (update-game tg)
  ; !!!
  ; Tetris -> Tetris
  ; move the active piece
  (cond
    [(= (point-y (tetris-piece tg)) NCELLSVERT)
     (make-tetris STARTPOINT (cons (tetris-piece tg) (tetris-sediment tg)))]
    [(member?
      (make-point (point-x (tetris-piece tg)) (add1 (point-y (tetris-piece tg))))
      (tetris-sediment tg))
     (make-tetris STARTPOINT (cons (tetris-piece tg) (tetris-sediment tg)))]
    [else
     (make-tetris (make-point (point-x (tetris-piece tg))
                              (add1 (point-y (tetris-piece tg))))
                  (tetris-sediment tg))]))


(define (render-game tg)
  ; Tetris -> Tetris
  ; render the state of the game on screen
  (render-sediment (tetris-sediment tg) (render-piece (tetris-piece tg))))


(define (render-sediment sd bkgd)
  ; ListOfPoints Img -> Img
  ; render the piled-up pieces on screen
  (cond
    [(empty? sd) bkgd]
    [else (place-image SEDIMENTPIECE
                       (unit-conversion (point-x (first sd)))
                       (unit-conversion (point-y (first sd)))
                       (render-sediment (rest sd) bkgd))]))


(define (render-piece p)
  ; Point Img -> Img
  ; render the active piec on screen
  (place-image ACTIVEPIECE
               (unit-conversion (point-x p))
               (unit-conversion (point-y p))
               GAMEBOARD))


(define (sidle-piece tg ke)
  ; Tetris -> Tetris
  ; user controls the sideways motion of the active
  ; piece with left and right keys
  (cond
    [(and (key=? "left" ke) (> (point-x (tetris-piece tg)) 1))
     (make-tetris
      (make-point (sub1 (point-x (tetris-piece tg)))
                  (point-y (tetris-piece tg)))
      (tetris-sediment tg))]
    [(and (key=? "right" ke) (< (point-x (tetris-piece tg)) NCELLSHORIZ))
     (make-tetris
      (make-point (add1 (point-x (tetris-piece tg)))
                  (point-y (tetris-piece tg)))
      (tetris-sediment tg))]
    [else tg]))


(define (done? sd)
  ; Tetris -> Boolean
  ; returns #t when the the sediment piles up too high
  (overwhelmed? (tetris-sediment sd)))

  
(define (overwhelmed? sd)
  ; ListOfPoints -> Boolean
  ; returns #t if any piece is at the top of the screen, at y-position 1
  (and
   (not (empty? sd))
   (or
    (= (point-y (first sd)) 1)
    (overwhelmed? (rest sd)))))


(define (game-over tg)
  ; Tetris -> Tetris
  ; render a game-over screen
  (render-game tg))


(define (unit-conversion n)
  ; Number -> Number
  ; converts a board position to a pixel location suitable for rendering
  (* (- n 1/2) UNITCELLSIZE))


; actions
(define STARTETRIS (make-tetris STARTPOINT '()))

(main STARTETRIS)