@echo off
set dest=%1
call mdpdf 01_dedication.md %dest%/01.pdf
call mdpdf 02_index.md %dest%/02.pdf
call mdpdf 03_intro.md %dest%/03.pdf
call mdpdf C1_freedom_mindset.md %dest%/04.pdf
call mdpdf C2_slavery.md %dest%/05.pdf
call mdpdf C3_leverage.md %dest%/06.pdf
call mdpdf C4_recognizing_your_leverage.md %dest%/07.pdf
call mdpdf C5_remove_obstacles.md %dest%/08.pdf
call mdpdf C6_new_opportunities.md %dest%/09.pdf
call mdpdf C7_communicating_optionality.md %dest%/10.pdf
call mdpdf C8_freedom_hacks.md %dest%/11.pdf
call mdpdf C9_conclusion.md %dest%/12.pdf
call mdpdf X_A1_case_study_1.md %dest%/13.pdf

