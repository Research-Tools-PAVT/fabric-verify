(set-info :original "test.ll")
(set-info :authors "SeaHorn v.10.0.0-rc0")
(declare-rel verifier.error (Bool Bool Bool ))
(declare-rel main@_sm2 (Bool ))
(declare-rel main@_call6 (Bool ))
(declare-rel main@_12 (Bool ))
(declare-rel main@.split (Bool ))
(declare-var main@%_br7_0 Int )
(declare-var main@%sm2_0 (Array Int Int) )
(declare-var main@%sm3_0 (Array Int Int) )
(declare-var main@%_call_0 Int )
(declare-var main@%_sm_0 Int )
(declare-var main@%sm_0 (Array Int Int) )
(declare-var main@%sm1_0 (Array Int Int) )
(declare-var main@%_4_0 Int )
(declare-var main@%_5_0 Bool )
(declare-var main@%_call4_0 Int )
(declare-var main@%_7_0 Int )
(declare-var main@%_call5_0 Int )
(declare-var main@%_9_0 Int )
(declare-var main@%_br_0 Bool )
(declare-var error.flag_0 Bool )
(declare-var error.flag_1 Bool )
(rule (verifier.error false false false))
(rule (verifier.error false true true))
(rule (verifier.error true false true))
(rule (verifier.error true true true))
(rule (=> (not error.flag_0) (main@_sm2 error.flag_0)))
(rule (=> (and (main@_sm2 error.flag_0)
         (not error.flag_0)
         (> main@%_call_0 0)
         (> main@%_sm_0 0)
         (= main@%sm_0 (store main@%sm2_0 main@%_call_0 0))
         (= main@%sm1_0 (store main@%sm3_0 main@%_sm_0 90))
         (= main@%_4_0 (select main@%sm1_0 main@%_sm_0))
         (= main@%_5_0 (> main@%_4_0 0))
         (= main@%_call4_0 (ite main@%_5_0 1 0))
         (or error.flag_0 main@%_5_0)
         (= main@%_7_0 (select main@%sm1_0 main@%_sm_0))
         (= main@%_call5_0 (+ main@%_7_0 50))
         (= main@%_9_0 (select main@%sm1_0 main@%_sm_0))
         (= main@%_br_0 (> main@%_call5_0 main@%_9_0))
         (or error.flag_0 main@%_br_0))
    (main@_12 error.flag_0)))
(rule (=> (and (main@_sm2 error.flag_0)
         (not error.flag_0)
         (> main@%_call_0 0)
         (> main@%_sm_0 0)
         (= main@%sm_0 (store main@%sm2_0 main@%_call_0 0))
         (= main@%sm1_0 (store main@%sm3_0 main@%_sm_0 90))
         (= main@%_4_0 (select main@%sm1_0 main@%_sm_0))
         (= main@%_5_0 (> main@%_4_0 0))
         (= main@%_call4_0 (ite main@%_5_0 1 0))
         (or error.flag_0 main@%_5_0)
         (= main@%_7_0 (select main@%sm1_0 main@%_sm_0))
         (= main@%_call5_0 (+ main@%_7_0 50))
         (= main@%_9_0 (select main@%sm1_0 main@%_sm_0))
         (= main@%_br_0 (> main@%_call5_0 main@%_9_0))
         (or error.flag_0 (not main@%_br_0))
         (verifier.error true error.flag_0 error.flag_1))
    (main@_call6 error.flag_1)))
(rule (=> (and (main@_12 error.flag_0) (not error.flag_0) (= main@%_br7_0 1))
    (main@.split error.flag_0)))
(rule (=> (and (main@_sm2 error.flag_0) error.flag_0) (main@.split error.flag_0)))
(rule (=> (and (main@_call6 error.flag_0) error.flag_0) (main@.split error.flag_0)))
(rule (=> (and (main@_12 error.flag_0) error.flag_0) (main@.split error.flag_0)))
(query (main@.split true))
