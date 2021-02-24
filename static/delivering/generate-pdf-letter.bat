@echo off
set dest=%1
call xcopy cover.pdf %dest%/000.pdf /y
call mdpdf 01_version.md %dest%/001.pdf --format=Letter
call mdpdf 02_dedication.md %dest%/002.pdf --format=Letter
call mdpdf 03_index.md %dest%/003.pdf --format=Letter
call mdpdf 04_intro.md %dest%/004.pdf --format=Letter
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

cd %dest%
mkdir book
call pdftk *.pdf cat output book/delivering-book.pdf
call start book/delivering-book.pdf
cd %~dp0
