
#KC extraction
================================================================================
Summary table
================================================================================
Method                                   |      Hit@4     NDCG@4 |      Hit@7     NDCG@7 |     Hit@10    NDCG@10
----------------------------------------------------------------------------------------------------------------
KG-based                                 |     0.5359     0.6573 |     0.6477     0.6473 |     0.7060     0.6567
NLP-based string similarity              |     0.1239     0.1925 |     0.1239     0.1770 |     0.1239     0.1752


# Query to course mapping

WITH all-miniLM
=== Query-Course Matching Results (153 queries) ===
  Hit rate:  0.0850 ± 0.2788
  NDCG:      0.0697 ± 0.2422

With nomic-embed-text
=== Query-Course Matching Results (153 queries) ===
  Hit rate:  0.2222 ± 0.3887
  NDCG:      0.1762 ± 0.3310

With qwen3-embedding
=== Query-Course Matching Results (153 queries) ===
  Hit rate:  0.5425 ± 0.4762
  NDCG:      0.4340 ± 0.4208

With Mistral-embed
=== Query-Course Matching Results (153 queries) ===
  Hit rate:  0.0523 ± 0.1881
  NDCG:      0.0401 ± 0.1517

  
  Student _misalignement
  Corpus of aligned questions
    TP=83  FP=0  TN=0  FN=10

============================================================
Misalignment Detection — Summary
============================================================
Method                    |   Recall | Precision |       F1
------------------------------------------------------------
KG-based                  |   0.8925 |    1.0000 |   0.9432

  Corpus of misaligned questions