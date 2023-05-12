import os
import time

# if file "do" exists, then run latex
os.system("mkdir -p /tmp/rechnungs-assistent/")
while True:
    if os.path.exists("/tmp/rechnungs-assistent/do"):
        os.remove("/tmp/rechnungs-assistent/do")

        # Get home directory
        home = os.path.expanduser("~")


        # Change workind to ../latex/_main.tex
        os.chdir(f"{home}/.cache/rechnungs-assistent/latex/")

        # Run command: pdflatex -output-directory=../  _main.tex

        # Run the following command for maximum of 5 seconds
        os.system("timeout 5 pdflatex _main.tex")
        # Move the _main.pdf to invoices/currentyear/currentmonth/YYY-MM-<number>.pdf
        # os.rename("../_main.pdf", "../python/invoices/" + current_year + "/" + current_month + "/Rechnung-" + invoice_number + ".pdf")
    if os.path.exists("/tmp/rechnungs-assistent/stop"):
        os.remove("/tmp/rechnungs-assistent/stop")
        break

    # sleep 1 second
    time.sleep(1)