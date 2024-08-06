
;; voteinn
;; a transparent and secure voting system where votes are recorded on the blockchain to ensure reliable results

;; Define the data variables
(define-data-var total-votes uint u0)
(define-map votes principal uint)
(define-map candidates (string-ascii 50) uint)
(define-data-var voting-open bool true)

;; Function to register a candidate
(define-public (register-candidate (name (string-ascii 50)))
    (begin
        (asserts! (is-eq tx-sender contract-owner) (err u1))
        (ok (map-set candidates name u0))
    )
)

;; Function to cast a vote
(define-public (cast-vote (candidate (string-ascii 50)))
    (let ((current-votes (default-to u0 (map-get? candidates candidate))))
        (asserts! voting-open (err u2))
        (asserts! (is-none (map-get? votes tx-sender)) (err u3))
        (map-set votes tx-sender u1)
        (map-set candidates candidate (+ current-votes u1))
        (var-set total-votes (+ (var-get total-votes) u1))
        (ok true)
    )
)

;; Function to get the number of votes for a candidate
(define-read-only (get-votes (candidate (string-ascii 50)))
    (ok (default-to u0 (map-get? candidates candidate)))
)

;; Function to get the total number of votes
(define-read-only (get-total-votes)
    (ok (var-get total-votes))
)

;; Function to close voting
(define-public (close-voting)
    (begin
        (asserts! (is-eq tx-sender contract-owner) (err u4))
        (var-set voting-open false)
        (ok true)
    )
)

;; Define the contract owner
(define-constant contract-owner tx-sender)
