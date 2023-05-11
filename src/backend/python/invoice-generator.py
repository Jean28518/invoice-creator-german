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
    # Create the parser
    parser = argparse.ArgumentParser(description='German invoice generator.')

    # Add arguments for customer data
    for i in range(len(argkeys_customer)):
        parser.add_argument('--' + argkeys_customer[i][0], help=argkeys_customer[i][1])


    # Add article arguments with price, amount and description
    parser.add_argument('--article', nargs='+', help='One or more articles. Format: --article "<description>;<pricePerUnit>;<amount>" "<description>;<pricePerUnit>;<amount>"')
    # Expense arguments
    parser.add_argument('--expense', nargs='+', help='One or more expenses. Format: --expense "<description>;<price>" "<description>;<price>"')
    # Discount
    parser.add_argument('--discount', help='Discount in euro. Format: --discount "Discount;25"')

    # Path to the template file
    parser.add_argument('--template', help='Path to the template file. Default: template.tex', default='template.tex')

    # Get number of payment days
    parser.add_argument('--paymentDays', help='Number of days until payment is due. Default: 14', default='14')

    # Overrice the invoice number
    parser.add_argument('--invoiceNumber', help='Invoice number if you want to override. Default: YYYY-MM-<number>', default='')

    # Path to logo
    parser.add_argument('--logo', help='Path to the logo. Default: logo.png', default='logo.png')

    # Parse the command-line arguments
    args = parser.parse_args()

    ## CUSTOMER DATA
    lines = get_all_lines_from_file("../latex/_data.tex")

    # Save the values
    for i in range(len(argkeys_customer)):
        if args.__dict__[argkeys_customer[i][0]] != None:
            lines = saveValue(lines, argkeys_customer[i][0], args.__dict__[argkeys_customer[i][0]])
        else:
            # Save default value
            lines = saveValue(lines, argkeys_customer[i][0], argkeys_customer[i][2])


    ## INVOICE NUMBER
    # Ensure that this directory exists: invoices/currentyear/currentmonth
    current_year = datetime.datetime.now().strftime("%Y")
    current_month = datetime.datetime.now().strftime("%m")
    if not os.path.exists("invoices"):
        os.mkdir("invoices")
    if not os.path.exists("invoices/" + current_year):
        os.mkdir("invoices/" + current_year)
    if not os.path.exists("invoices/" + current_year + "/" + current_month):
        os.mkdir("invoices/" + current_year + "/" + current_month)

    # Generate invoice number from amount of files in the invoice folder Format: YYYY-MM-<number>
    number = len(os.listdir("invoices/" + current_year + "/" + current_month)) + 1
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
    f = open("../latex/_data.tex", "w")
    f.writelines(lines)
    f.close()

    ## ARTICLES
    # \Fee{Musterdienstleistung 1}{30.00}{4}
    lines = ["\ProjectTitle{Projekttitel}\n"]
    articles = args.article
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
    f = open("../latex/_invoice.tex", "w")
    f.writelines(lines)
    f.close()



    # Copy template.tex to ../latex/_template.tex. Avoid Systemcall because of win compatibility
    lines = get_all_lines_from_file(args.template)
    if len(lines) == 0:
        print(f'Error: Could not open template file: "{args.template}"')
        sys.exit(1)
    f = open("../latex/_template.tex", "w")
    f.writelines(lines)
    f.close()

    # Copy logo to ../latex/_logo.png. Avoid Systemcall because of win compatibility
    if args.logo != None:
        if not os.path.exists(args.logo):
            print(f'Error: Could not open logo file: "{args.logo}"')
            sys.exit(1)
        # Read binary from logo.png
        f = open(args.logo, "rb")
        binary = f.readlines()
        f = open("../latex/logo.png", "wb")
        f.writelines(binary)
        f.close()
    

    # Change workind to ../latex/_main.tex
    os.chdir("../latex/")

    # Run command: pdflatex -output-directory=../  _main.tex
    os.system("pdflatex -output-directory=../  _main.tex")
    # Move the _main.pdf to invoices/currentyear/currentmonth/YYY-MM-<number>.pdf
    os.rename("../_main.pdf", "../python/invoices/" + current_year + "/" + current_month + "/Rechnung-" + invoice_number + ".pdf")
    pass

if __name__ == "__main__":
    main()