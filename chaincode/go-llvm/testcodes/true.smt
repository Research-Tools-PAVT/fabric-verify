(set-info :original "./testcodes/test.true.bc")
(set-info :authors "SeaHorn v.0.1.0-rc3")
(declare-rel verifier.error (Bool Bool Bool ))
(declare-rel main@entry ())
(declare-rel main@.lr.ph.preheader (Int Int ))
(declare-rel main@.lr.ph (Int Int Int ))
(declare-rel main@verifier.error.loopexit (Int ))
(declare-rel main@verifier.error (Int ))
(declare-rel main@verifier.error.split ())
(declare-var main@%_7_0 Bool )
(declare-var main@%_6_0 Bool )
(declare-var main@%_1_0 Bool )
(declare-var main@%_3_0 Bool )
(declare-var main@%_0_0 Int )
(declare-var main@%_2_0 Int )
(declare-var main@%k.0.i.lcssa_0 Int )
(declare-var main@%j.0.i2_0 Int )
(declare-var main@%k.0.i1_0 Int )
(declare-var main@%_4_0 Int )
(declare-var main@%_5_0 Int )
(declare-var main@%j.0.i2_1 Int )
(declare-var main@%k.0.i1_1 Int )
(declare-var main@%.lcssa_0 Int )
(rule (verifier.error false false false))
(rule (verifier.error false true true))
(rule (verifier.error true false true))
(rule (verifier.error true true true))
(rule main@entry)
(rule (=> (and main@entry
         true
         (= main@%_1_0 (> main@%_0_0 0))
         main@%_1_0
         (= main@%_3_0 (> main@%_2_0 main@%_0_0))
         main@%_3_0
         main@%_1_0)
    (main@.lr.ph.preheader main@%_0_0 main@%_2_0)))
(rule (=> (and main@entry
         true
         (= main@%_1_0 (> main@%_0_0 0))
         main@%_1_0
         (= main@%_3_0 (> main@%_2_0 main@%_0_0))
         main@%_3_0
         (not main@%_1_0)
         (= main@%k.0.i.lcssa_0 main@%_2_0))
    (main@verifier.error main@%k.0.i.lcssa_0)))
(rule (=> (and (main@.lr.ph.preheader main@%_0_0 main@%_2_0)
         true
         (= main@%j.0.i2_0 0)
         (= main@%k.0.i1_0 main@%_2_0))
    (main@.lr.ph main@%j.0.i2_0 main@%k.0.i1_0 main@%_0_0)))
(rule (=> (and (main@.lr.ph main@%j.0.i2_0 main@%k.0.i1_0 main@%_0_0)
         true
         (= main@%_4_0 (+ main@%j.0.i2_0 1))
         (= main@%_5_0 (+ main@%k.0.i1_0 (- 1)))
         (= main@%_6_0 (< main@%_4_0 main@%_0_0))
         main@%_6_0
         (= main@%j.0.i2_1 main@%_4_0)
         (= main@%k.0.i1_1 main@%_5_0))
    (main@.lr.ph main@%j.0.i2_1 main@%k.0.i1_1 main@%_0_0)))
(rule (=> (and (main@.lr.ph main@%j.0.i2_0 main@%k.0.i1_0 main@%_0_0)
         true
         (= main@%_4_0 (+ main@%j.0.i2_0 1))
         (= main@%_5_0 (+ main@%k.0.i1_0 (- 1)))
         (= main@%_6_0 (< main@%_4_0 main@%_0_0))
         (not main@%_6_0)
         (= main@%.lcssa_0 main@%_5_0))
    (main@verifier.error.loopexit main@%.lcssa_0)))
(rule (=> (and (main@verifier.error.loopexit main@%.lcssa_0)
         true
         (= main@%k.0.i.lcssa_0 main@%.lcssa_0))
    (main@verifier.error main@%k.0.i.lcssa_0)))
(rule (=> (and (main@verifier.error main@%k.0.i.lcssa_0)
         true
         (= main@%_7_0 (> main@%k.0.i.lcssa_0 (- 1)))
         (not main@%_7_0))
    main@verifier.error.split))
(query main@verifier.error.split)

