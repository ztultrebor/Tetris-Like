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

(define PIECECOLOR "blue")
(define BACKGROUNDCOLOR "white")
(define UNITCELLSIZE 16)
(define NCELLSHORIZ 24)
(define NCELLSVERT 30)
(define CANVASWIDTH (* NCELLSHORIZ UNITCELLSIZE))
(define CANVASHEIGHT (* NCELLSVERT UNITCELLSIZE))
(define SNAKESTARTPT (make-point
                      (* (quotient NCELLSHORIZ 2) UNITCELLSIZE)
                      (* (quotient NCELLSVERT 2) UNITCELLSIZE)))
(define SPACER 1)
(define SEGMENTSIZE (- UNITCELLSIZE SPACER))
(define CURVATURE 4)
(define PULLBACK (- SEGMENTSIZE CURVATURE CURVATURE))
(define PIECE
  (beside
   (rectangle SPACER SEGMENTSIZE "solid" BACKGROUNDCOLOR)
   (above
    (rectangle SEGMENTSIZE SPACER "solid" BACKGROUNDCOLOR)
    (overlay/align
     "left" "bottom" (circle CURVATURE "solid" PIECECOLOR)
     (overlay/align
      "right" "bottom" (circle CURVATURE "solid" PIECECOLOR)
      (overlay/align
       "right" "top" (circle CURVATURE "solid" PIECECOLOR)
       (overlay/align
        "left" "top" (circle CURVATURE "solid" PIECECOLOR)
        (overlay
         (rectangle SEGMENTSIZE PULLBACK "solid" PIECECOLOR)
         (rectangle PULLBACK SEGMENTSIZE "solid" PIECECOLOR)))))))))
(define CANVAS  (empty-scene CANVASWIDTH CANVASHEIGHT BACKGROUNDCOLOR))
(define GAMEBOARD
  (overlay CANVAS
           (rectangle (+ CANVASWIDTH UNITCELLSIZE)
                      (+ CANVASHEIGHT UNITCELLSIZE) "solid" "yellow")))


; functions


(define (main sg)
  ; Tetris -> Tetris
  ; run the game
  (big-bang sg
    [on-tick update-game 1/7]
    [to-draw render-game]
    [on-key sidle-piece]
    [stop-when overwhelmed? game-over]))


(define (update-game tg)
  ; !!!
  ; Tetris -> Tetris
  ; move the active piece
  tg)


(define (render-game tg)
  ; !!!
  ; Tetris -> Tetris
  ; render the state of the game on screen
  CANVAS)


(define (sidle-piece tg ke)
  ; Tetris -> Tetris
  ; user controls the sideways motion of the active
  ; piece with left ande right keys
  tg)


(define (overwhelmed? tg)
  ; Tetris -> Boolean
  ; returns #t when the the sediment piles up too high
  #f)


(define (game-over tg)
  ; Tetris -> Tetris
  ; render a game-over screen
  (render-game tg))


; actions
(define STARTETRIS (make-tetris (make-point 0 0) (list (make-point 0 0))))

(main STARTETRIS)