#!/usr/bin/python3
import os
import sys
import argparse
import datetime

# \newcommand{\customerCompany}{Firma XYZ} %ggf. Firma
# \newcommand{\customerName}{Max Mustermann} % Name
# \newcommand{\customerStreet}{Robert-Koch-Str. 12} % Straße
# \newcommand{\customerZIP}{12345} % Postleitzahl
# \newcommand{\customerCity}{Musterstadt} % Ort
argkeys_customer = [
    ["customerCompany", "Name of the company" , "FirmaXYZ"],
    ["customerName", "Name of the customer", "Max Mustermann"],
    ["customerStreet", "Street of the customer", "Robert-Koch-Str. 12"],
    ["customerZIP", "Postal code of the customer", "12345"],
    ["customerCity", "City of the customer", "Musterstadt"],
    ["customerCountry", "Country of the customer", "Germany"]
]




def saveValue(lines, key, value):
    for i in range(len(lines)):
        if lines[i].startswith("\\newcommand{\\" + key + "}"):
            lines[i] = "\\newcommand{\\" + key + "}{" + value + "}\n"
            return lines    
    lines.append("\\newcommand{\\" + key + "}{" + value + "}\n")
    return lines

def does_file_exist(file_path):
    return os.path.exists(file_path) and os.path.isfile(file_path)

def get_all_lines_from_file(file_path):
    if not does_file_exist(file_path):
        return []
    with open(file_path, "r") as f:
        return f.readlines()
    
def main():
    # get home directory
    home = os.path.expanduser("~")
    # create cache directory
    cache_dir = home + "/.cache/rechnungs-assistent/"
    config_dir = home + "/.config/rechnungs-assistent/"

    # If cache directory does not exist, create it
    if not os.path.exists(cache_dir):
        os.makedirs(cache_dir)

    # If conig directory does not exist, create it
    if not os.path.exists(config_dir):
        os.makedirs(config_dir)

    # If template.tex does not exist, copy the example to the config folder
    if not does_file_exist(f"{config_dir}/template.tex"):
        os.system("cp latex/template.tex.example " + config_dir + "/template.tex")

    print("Generating invoice...")
    # Create the parser
    parser = argparse.ArgumentParser(description='German invoice generator.')

    # Add arguments for customer data
    for i in range(len(argkeys_customer)):
        # make them mandatory
        parser.add_argument('--' + argkeys_customer[i][0], help=argkeys_customer[i][1])


    # Add article arguments with price, amount and description
    parser.add_argument('--article', nargs='+', help='One or more articles. Format: --article "<description>;<pricePerUnit>;<amount>" "<description>;<pricePerUnit>;<amount>"')
    # Expense arguments
    parser.add_argument('--expense', nargs='+', help='One or more expenses. Format: --expense "<description>;<price>" "<description>;<price>"')
    # Discount
    parser.add_argument('--discount', help='Discount in euro. Format: --discount "Discount;25"')

    # Path to the template file
    parser.add_argument('--template', help='Path to the template file. Default: template.tex', default=f'{config_dir}/template.tex')

    # Get number of payment days
    parser.add_argument('--paymentDays', help='Number of days until payment is due. Default: 14', default='14')

    # Overrice the invoice number
    parser.add_argument('--invoiceNumber', help='Invoice number if you want to override. Default: YYYY-MM-<number>', default='')

    # Path to logo
    parser.add_argument('--logo', help='Path to the logo. Default: logo.png', default='')

    # dry run
    parser.add_argument('--dryRun', help='Dry run. Do not generate the pdf.', action='store_true')

    # Path to the invoice directory structure (rechnungen/currentyear/currentmonth)
    parser.add_argument('--invoiceDir', help='Path to the invoice directory structure. Default: invoices', default=f'{home}/Dokumente/Rechnungen/')

    # Parse the command-line arguments
    args = parser.parse_args()


    # copy all latex files to cache directory
    os.system("cp -r latex/ " + cache_dir)


    ## CUSTOMER DATA
    lines = get_all_lines_from_file(f"{cache_dir}/latex/_data.tex")

    # Save the values
    for i in range(len(argkeys_customer)):
        if args.__dict__[argkeys_customer[i][0]] != None:
            lines = saveValue(lines, argkeys_customer[i][0], args.__dict__[argkeys_customer[i][0]])
        else:
            # Save default value
            lines = saveValue(lines, argkeys_customer[i][0], argkeys_customer[i][2])
    

    # Serch for line with \newcommand{\adress1} and replace it with \newcommand{\adress1}{\customerCompany \\ \customerName} if customerCompany and customerName are not empty
    # otherwise replace it with \newcommand{\adress1}{\customerCompany \customerName} that we don't have an unnecessary line break
    for i in range(len(lines)):
        if lines[i].startswith("\\newcommand{\\adressOne}"):
            if args.customerCompany == None or args.customerName == None or args.customerCompany == "" or args.customerName == "":
                lines[i] = "\\newcommand{\\adressOne}{\customerCompany \customerName}\n"
            else:
                lines[i] = "\\newcommand{\\adressOne}{\customerCompany \\\\ \customerName}\n"
            break


    ## INVOICE NUMBER
    # Ensure that this directory exists: invoices/currentyear/currentmonth
    current_year = datetime.datetime.now().strftime("%Y")
    current_month = datetime.datetime.now().strftime("%m")
    
    # if the invoice directory does not exist, create it
    invoice_dir = args.invoiceDir + "/" + current_year + "/" + current_month
    if not os.path.exists(invoice_dir):
        os.makedirs(invoice_dir)


    # Generate invoice number from amount of files in the invoice folder Format: YYYY-MM-<number>
    number = len(os.listdir(invoice_dir)) + 1
    invoice_number = datetime.datetime.now().strftime("%Y-%m-") + str(number)
    if args.invoiceNumber != "":
        invoice_number = args.invoiceNumber
    # Get current date in format DD.M.YYYY
    date = datetime.datetime.now().strftime("%d.%m.%Y")
    # Get payment date in format DD.M.YYYY
    payment_date = (datetime.datetime.now() + datetime.timedelta(days=int(args.paymentDays))).strftime("%d.%m.%Y")

    saveValue(lines, "invoiceDate", date)
    saveValue(lines, "payDate", payment_date)
    saveValue(lines, "invoiceReference", invoice_number)
    

    # Write the file
    f = open(f"{cache_dir}/latex/_data.tex", "w")
    f.writelines(lines)
    f.close()

    ## ARTICLES
    # \Fee{Musterdienstleistung 1}{30.00}{4}
    lines = ["\ProjectTitle{Projekttitel}\n"]
    articles = args.article
    if articles != None:
        for article in articles:
            # Parse the article
            segments = article.split(";")
            if len(segments) != 3:
                print(f'Error: Wrong format for article: "{article}". Use: --article "<description>;<pricePerUnit>;<amount>" "<description>;<pricePerUnit>;<amount>"')
                sys.exit(1)
            # Save to ../latex/_invoice.tex
            lines.append("\\Fee{" + segments[0] + "}{" + segments[1] + "}{" + segments[2] + "}\n")

    ## EXPENSES
    expenses = args.expense
    # \EBCi{Hotel, 12 Nächte} {2400.00}
    if expenses != None:
        for expense in expenses:
            # Parse the expense
            segments = expense.split(";")
            if len(segments) != 2:
                print(f'Error: Wrong format for expense: "{expense}". Use: --expense "<description>;<price>" "<description>;<price>"')
                sys.exit(1)
            # Save to ../latex/_invoice.tex
            lines.append("\\EBCi{" + segments[0] + "}{" + segments[1] + "}\n")

    ## DISCOUNT
    discount = args.discount
    # \Discount{Discount}{10}
    if discount != None:
        segments = discount.split(";")
        if len(segments) != 2:
            print(f'Error: Wrong format for discount: "{discount}". Use: --discount "Discount;10"')
            sys.exit(1)
        # Save to ../latex/_invoice.tex
        lines.append("\\Discount{" + segments[0] + "}{" + segments[1] + "}\n")

    # Save file
    f = open(f"{cache_dir}/latex/_invoice.tex", "w")
    f.writelines(lines)
    f.close()



    # Copy .config/template.tex to configfolder/latex/_template.tex. Avoid Systemcall because of win compatibility
    lines = get_all_lines_from_file(args.template)
    if len(lines) == 0:
        print(f'Error: Could not open template file: "{args.template}"')
        sys.exit(1)
    f = open(f"{cache_dir}/latex/_template.tex", "w")
    f.writelines(lines)
    f.close()

    # Copy logo to ../latex/_logo.png. Avoid Systemcall because of win compatibility
    if args.logo != "":
        if not os.path.exists(args.logo):
            print(f'Error: Could not open logo file: "{args.logo}"')
            sys.exit(1)
        # Read binary from logo.png
        f = open(args.logo, "rb")
        binary = f.readlines()
        f = open("/latex/logo.png", "wb")
        f.writelines(binary)
        f.close()
    
    print("invoice-number: " + invoice_number)

    if args.dryRun:
        sys.exit(0)

    # Change workind to /latex/_main.tex
    os.chdir(f"{cache_dir}/latex/")

    # Run command: pdflatex -output-directory=../  _main.tex
    os.system("pdflatex  _main.tex")
    # Move the _main.pdf to invoices/currentyear/currentmonth/YYY-MM-<number>.pdf
    os.system(f"mv _main.pdf {invoice_dir}/Rechnung-{invoice_number}.pdf")
    pass

if __name__ == "__main__":
    main()