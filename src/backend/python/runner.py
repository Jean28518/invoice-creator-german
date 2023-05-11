import os
import time

# if file "do" exists, then run latex
while True:
    if os.path.exists("do"):

        # Change workind to ../latex/_main.tex
        os.chdir("../latex/")

        # Run command: pdflatex -output-directory=../  _main.tex
        os.system("pdflatex -output-directory=../  _main.tex")
        # Move the _main.pdf to invoices/currentyear/currentmonth/YYY-MM-<number>.pdf
        # os.rename("../_main.pdf", "../python/invoices/" + current_year + "/" + current_month + "/Rechnung-" + invoice_number + ".pdf")
        os.chdir("../python/")
        # remove file "do"
        os.remove("do")

    # sleep 1 second
    time.sleep(1)