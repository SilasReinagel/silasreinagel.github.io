@echo off
set dest=%1
call xcopy cover.pdf %dest%/00.pdf /y
call mdpdf 01_version.md %dest%/01.pdf --format=Letter
call mdpdf 02_dedication.md %dest%/02.pdf --format=Letter
call mdpdf 03_index.md %dest%/03.pdf --format=Letter
call mdpdf 04_intro.md %dest%/04.pdf --format=Letter
call mdpdf C1_freedom_mindset.md %dest%/04.pdf --format=Letter
call mdpdf C2_slavery.md %dest%/05.pdf --format=Letter
call mdpdf C3_leverage.md %dest%/06.pdf --format=Letter
call mdpdf C4_recognizing_your_leverage.md %dest%/07.pdf --format=Letter
call mdpdf C5_remove_obstacles.md %dest%/08.pdf --format=Letter
call mdpdf C6_new_opportunities.md %dest%/09.pdf --format=Letter
call mdpdf C7_communicating_optionality.md %dest%/10.pdf --format=Letter
call mdpdf C8_freedom_hacks.md %dest%/11.pdf --format=Letter
call mdpdf C9_conclusion.md %dest%/12.pdf --format=Letter
call mdpdf X_A1_case_study_1.md %dest%/13.pdf --format=Letter

cd %dest%
call pdftk 00.pdf 01.pdf 02.pdf 03.pdf 04.pdf 05.pdf 06.pdf 07.pdf 08.pdf 09.pdf 10.pdf 11.pdf 12.pdf cat output liberation-book.pdf
call start liberation-book.pdf
cd %~dp0

