@echo off
set dest=%1
call mdpdf 00_title.md %dest%/00.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/00_Fill.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf 01_version.md %dest%/01.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/01_Fill.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf 02_dedication.md %dest%/02.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/02_Fill.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf 03_index.md %dest%/03.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/03_Fill.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf 04_intro.md %dest%/04.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/04_Fill.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C1_freedom_mindset.md %dest%/10.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/11.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C2_slavery.md %dest%/20.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C3_leverage.md %dest%/30.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C4_recognizing_your_leverage.md %dest%/40.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C5_remove_obstacles.md %dest%/50.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/50_Fill.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C6_new_opportunities.md %dest%/60.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C7_communicating_optionality.md %dest%/70.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/71.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C8_freedom_hacks.md %dest%/80.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf C9_let_freedom_reign.md %dest%/90.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/91.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf X_A0_further_reading.md %dest%/92.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf blank_page.md %dest%/93.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf X_A1_case_study_1.md %dest%/95.pdf --format=A5 --style=paperback_style.css --border=34
call mdpdf X_Z1_bio.md %dest%/97.pdf --format=A5 --style=paperback_style.css --border=34

cd %dest%
call pdftk *.pdf cat output book/liberation-book.pdf
call cpdf -scale-to-fit "152.4mm 228.6mm" book/liberation-book.pdf -o book/liberation-book.pdf
call start book/liberation-book.pdf
cd %~dp0
