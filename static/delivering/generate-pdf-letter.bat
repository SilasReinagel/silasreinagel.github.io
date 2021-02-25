@echo off
set dest=%1
call xcopy cover.pdf %dest%/000.pdf /y
call mdpdf 01_title.md %dest%/001.pdf --format=Letter
call mdpdf 02_copyright.md %dest%/002.pdf --format=Letter
call mdpdf 03_epigraph.md %dest%/003.pdf --format=Letter
call mdpdf 04_dedication.md %dest%/004.pdf --format=Letter
call mdpdf 05_index.md %dest%/005.pdf --format=Letter
call mdpdf 06_acknowledgments.md %dest%/006.pdf --format=Letter
call mdpdf 07_intro.md %dest%/007.pdf --format=Letter
call mdpdf C1_no_fluff.md %dest%/010.pdf --format=Letter
call mdpdf C2_iron_triangle.md %dest%/020.pdf --format=Letter
call mdpdf C3_project_momentum.md %dest%/030.pdf --format=Letter
call mdpdf C4_project_predictability.md %dest%/040.pdf --format=Letter
call mdpdf C5_essential_tools.md %dest%/050.pdf --format=Letter
call mdpdf C6_agile_good_and_bad.md %dest%/060.pdf --format=Letter
call mdpdf C7_kanban_good_and_bad.md %dest%/070.pdf --format=Letter
call mdpdf C8_scrum_good_and_bad.md %dest%/080.pdf --format=Letter
call mdpdf C9_assembling_your_team.md %dest%/090.pdf --format=Letter
call mdpdf C10_motivating_your_team.md %dest%/100.pdf --format=Letter
call mdpdf C11_communicating_results.md %dest%/110.pdf --format=Letter
call mdpdf C12_all_the_secrets.md %dest%/120.pdf --format=Letter
call mdpdf X_A1_story_core_competencies.md %dest%/130.pdf --format=Letter
call mdpdf X_Z1_bio.md %dest%/140.pdf --format=Letter
call xcopy cover_back.pdf %dest%/999.pdf /y

cd %dest%
mkdir book
call pdftk *.pdf cat output book/delivering-book.pdf
call start book/delivering-book.pdf
cd %~dp0
