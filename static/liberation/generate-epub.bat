@echo off
set dest=%1
pandoc -o %dest%/Liberation.epub pandoc_epub_title.txt 01_version.md 02_dedication.md 03_index.md 04_intro.md C1_freedom_mindset.md C2_slavery.md C3_leverage.md C4_recognizing_your_leverage.md C5_remove_obstacles.md C6_new_opportunities.md C7_communicating_optionality.md C8_freedom_hacks.md C9_let_freedom_reign.md X_A0_further_reading.md X_A1_case_study_1.md X_Z1_bio.md
