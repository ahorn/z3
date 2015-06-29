(set-option :fixedpoint.engine datalog)
(set-option :fixedpoint.datalog.transform_rules false)

; identifier for a router
(define-sort router_t () (_ BitVec 2))

; large enough to avoid overflow in addition
(define-sort cost_t () (_ BitVec 5))

; direct cost between two routers
(declare-rel link (router_t router_t cost_t))

(declare-rel sh_path (router_t router_t cost_t))
(declare-rel path (router_t router_t cost_t))

; final minimum cost between two routers
(declare-rel shortest_path (router_t router_t cost_t))

(declare-var x router_t)
(declare-var y router_t)
(declare-var z router_t)

(declare-var c1 cost_t)
(declare-var c2 cost_t)
(declare-var c3 cost_t)

(rule (link #b00 #b11 #b00011)) ; A -> D [3]
(rule (link #b01 #b00 #b00001)) ; B -> A [1]
(rule (link #b01 #b11 #b00001)) ; B -> D [1]
(rule (link #b10 #b01 #b00011)) ; C -> B [3]
(rule (link #b10 #b00 #b00010)) ; C -> A [2]

(rule (=> (link x y c1) (path x y c1)))

(rule (=>
  (and (sh_path x y c1) (link y z c2) (= (bvadd c1 c2) c3))
  (path x z c3)))

(rule (=>
  (and (path x y c1) (min c1))
  (sh_path x y c1)))

(rule (=>
  (and (sh_path x y c1) (min c1))
  (shortest_path x y c1)))

; What are the computed costs from C to D?
(query (shortest_path #b10 #b11 #b00101) :print-answer true)
