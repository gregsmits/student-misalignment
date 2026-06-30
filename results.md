================================================================================
Summary table
================================================================================
Method                                   |      Hit@4     NDCG@4 |      Hit@7     NDCG@7 |     Hit@10    NDCG@10
----------------------------------------------------------------------------------------------------------------
NLP-based prompt                         |     0.1866     0.2151 |     0.1954     0.2064 |     0.2510     0.2376
NLP-based prompt with CoT                |     0.1599     0.2373 |     0.2465     0.2647 |     0.2634     0.2614
NLP-based prompt with self-reflection    |     0.2583     0.3900 |     0.0000     0.0000 |     0.1833     0.2119
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