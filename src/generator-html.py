#!/usr/bin/python3
import os
import sys
import argparse
import datetime

# argument key , description, default value, key in html
argkeys_customer = [
    ["customerCompany", "Name of the company" , "FirmaXYZ", "REC-COMPANY"],
    ["customerName", "Name of the customer", "Max Mustermann" , "REC-NAME"],
    ["customerStreet", "Street of the customer", "Robert-Koch-Str. 12", "REC-STREET"],
    ["customerZIP", "Postal code of the customer", "12345", "REC-ZIP"],
    ["customerCity", "City of the customer", "Musterstadt", "REC-CITY"],
    # ["customerCountry", "Country of the customer", "Germany"]
]

def saveValue(lines, key, value):
    for i in range(len(lines)):
        if lines[i].startswith(key + ";"):
            lines[i] = key + ";" + value + "\n"
            return lines    
    lines.append(key + ";" + value + "\n")
    return lines


def getValue(lines, key, default=''):
    for i in range(len(lines)):
        if lines[i].startswith(key + ";"):
            return lines[i].split(";")[1].replace("\n", "")
    return default


def does_file_exist(file_path):
    return os.path.exists(file_path) and os.path.isfile(file_path)


def get_all_lines_from_file(file_path):
    if not does_file_exist(file_path):
        return []
    with open(file_path, "r") as f:
        return f.readlines()


def is_key_present(csv_lines, key):
    for line in csv_lines:
        if line.split(";")[0] == key:
            return True
    return False


# Returns the second csv field.
def get_value(csv_lines, key):
    for line in csv_lines:
        if line.split(";")[0] == key:
            return line.split(";")[1]
    return ""


def convert_to_euro_string(value):
    value = str(round(float(value), 2))
    if value.find(".") == -1:
        value += ",00"
    value = value.replace(".", ",")
    # If value ends only with one digit, add a 0
    if value[len(value) - 2] == ",":
        value += "0"
    return value + " €"
    

def main():
    # get home directory
    home = os.path.expanduser("~")
    # create cache directory
    cache_dir = home + "/.cache/rechnungs-assistent/"
    config_dir = home + "/.config/rechnungs-assistent/"

    current_dir = os.path.dirname(os.path.realpath(__file__))

    # If cache directory does not exist, create it
    if not os.path.exists(cache_dir):
        os.makedirs(cache_dir)

    # If config directory does not exist, create it
    if not os.path.exists(config_dir):
        os.makedirs(config_dir)

    # If template.csv does not exist, copy the example to the config folder
    if not does_file_exist(f"{config_dir}/template.csv"):
        os.system("cp {{current_dir}}/html/template.csv.example " + config_dir + "/template.csv")

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
    parser.add_argument('--template', help='Path to the template file. Default: template.csv', default=f'{config_dir}/template.csv')
    
    # VAT
    parser.add_argument('--vat', help='VAT in percent. Default: 0', default='0')

    # Get number of payment days
    parser.add_argument('--paymentDays', help='Number of days until payment is due. Default: 14', default='14')

    # Overrice the invoice number
    parser.add_argument('--invoiceNumber', help='Invoice number if you want to override. Default: YYYY-MM-<number>', default='')

    # Path to logo
    parser.add_argument('--logo', help='Path to the logo. Default: logo.png', default='')

    # dry run
    parser.add_argument('--dryRun', help='Dry run. Do not save the pdf to the invoice Dir.', action='store_true')

    # Path to the invoice directory structure (rechnungen/currentyear/currentmonth)
    parser.add_argument('--invoiceDir', help='Path to the invoice directory structure. Default: invoices', default=f'{home}/Dokumente/Rechnungen/')

    # Parse the command-line arguments
    args = parser.parse_args()

    print("Generating invoice...")

    # Get all lines from the invoice.html template
    lines = get_all_lines_from_file(f"{current_dir}/html/invoice.html")
    if len(lines) == 0:
        print(f'Error: Could not open template file: "{current_dir}/html/invoice.html"')
        sys.exit(1)

    # Get key and value from the template.csv
    template_lines = get_all_lines_from_file(args.template)
    if len(template_lines) == 0:
        print(f'Error: Could not open template file: "{args.template}"')
        sys.exit(1)

    # Get date
    date = datetime.datetime.now().strftime("%d.%m.%Y")
    payment_date = (datetime.datetime.now() + datetime.timedelta(days=int(args.paymentDays))).strftime("%d.%m.%Y")

    # INVOICE NUMBER
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



    # Get Articles
    articles = []
    articles_string_list = args.article
    if articles_string_list != None:
        for article_string in articles_string_list:
            # Parse the article
            segments = article_string.split(";")
            if len(segments) != 3:
                print(f'Error: Wrong format for article: "{article_string}". Use: --article "<description>;<pricePerUnit>;<amount>" "<description>;<pricePerUnit>;<amount>"')
                sys.exit(1)
            articles.append(segments)

    # Get Expenses
    expenses = []
    expenses_string_list = args.expense
    if expenses_string_list != None:
        for expense_string in expenses_string_list:
            # Parse the expense
            segments = expense_string.split(";")
            if len(segments) != 2:
                print(f'Error: Wrong format for expense: "{expense_string}". Use: --expense "<description>;<price>" "<description>;<price>"')
                sys.exit(1)
            expenses.append(segments)
    
    # Get Discount
    discounts = []
    discount_string = args.discount
    if discount_string != None:
        segments = discount_string.split(";")
        if len(segments) != 2:
            print(f'Error: Wrong format for discount: "{discount_string}". Use: --discount "Discount;10"')
            sys.exit(1)
        discounts.append(segments)


    # Generate html code for articles
    # Example: 
    #   <tr>
    #     <td class="invoice-item-name">Product 1</td>
    #     <td>$10.00</td>
    #     <td>1</td>
    #     <td>$10.00</td>
    #   </tr>
    table_html = ""
    for article in articles:
        table_html += f'<tr><td class="invoice-item-name">{article[0]}</td><td>{convert_to_euro_string(article[1])}</td><td>{article[2]}</td><td>{convert_to_euro_string(float(article[1]) * float(article[2]))}</td></tr>\n'

    for expense in expenses:
        table_html += f'<tr><td class="invoice-item-name">{expense[0]}</td><td> - </td><td> - </td><td>{convert_to_euro_string(expense[1])}</td></tr>\n'

    for discount in discounts:
        table_html += f'<tr><td class="invoice-item-name">{discount[0]}</td><td> - </td><td> - </td><td>- {convert_to_euro_string(discount[1])}</td></tr>\n'
    
    # Calculate sum
    sum_netto = 0
    for article in articles:
        # Article price per unit * amount
        sum_netto += float(article[1]) * float(article[2])
    for expense in expenses:
        # Expense price
        sum_netto += float(expense[1])
    for discount in discounts:
        # Discount price
        sum_netto -= float(discount[1])
    
    vat = float(args.vat)
    vat_sum = sum_netto * (vat / 100)
    sum_brutto = sum_netto + vat_sum


    # Generate html for sender info
    sen_info_description = ""
    sen_info_data = ""
    if is_key_present(template_lines, "SEN-NAME") and is_key_present(template_lines, "SEN-STREET") and is_key_present(template_lines, "SEN-CITY"):
        sen_info_description += "Anschrift <br> <br> <br> <br>"
        sen_name = get_value(template_lines, "SEN-NAME")
        sen_street = get_value(template_lines, "SEN-STREET")
        sen_zip = get_value(template_lines, "SEN-ZIP")
        sen_city = get_value(template_lines, "SEN-CITY")
        sen_info_data += f"{sen_name} <br> {sen_street} <br> {sen_zip} {sen_city} <br> <br>"
    if is_key_present(template_lines, "SEN-EMAIL"):
        sen_info_description += "E-Mail <br>"
        sen_email = get_value(template_lines, "SEN-EMAIL")
        sen_info_data += f"<a style=\"color: grey; text-decoration: none;\" href=\"mailto:{sen_email}\">{sen_email}</a> <br>"
    if is_key_present(template_lines, "SEN-PHONE"):
        sen_info_description += "Telefon <br>"
        sen_phone = get_value(template_lines, "SEN-PHONE")
        sen_info_data += f"<a style=\"color: grey; text-decoration: none;\" href=\"tel:{sen_phone}\">{sen_phone}</a> <br>"
    if is_key_present(template_lines, "SEN-WEBSITE"):
        sen_info_description += "Website <br>"
        sen_website = get_value(template_lines, "SEN-WEBSITE")
        sen_info_data += f"<a style=\"color: grey; text-decoration: none;\" href=\"{sen_website}\">{sen_website}</a> <br>"
    sen_info_description += "<br>"
    sen_info_data += "<br>"
    if is_key_present(template_lines, "SEN-TAX-ID"):
        sen_info_description += "Ust-IdNr. <br>"
        sen_tax_id = get_value(template_lines, "SEN-TAX-ID")
        sen_info_data += f"{sen_tax_id} <br>"
    sen_info_description += "<br>"
    sen_info_data += "<br>"
    if is_key_present(template_lines, "MONEY-INSTITUTE"):
        sen_info_description += "Institut <br>"
        sen_money_institute = get_value(template_lines, "MONEY-INSTITUTE")
        sen_info_data += f"{sen_money_institute} <br>"
    if is_key_present(template_lines, "IBAN"):
        sen_info_description += "IBAN <br>"
        sen_iban = get_value(template_lines, "IBAN")
        sen_info_data += f"{sen_iban} <br>"
    if is_key_present(template_lines, "BIC"):
        sen_info_description += "BIC <br>"
        sen_bic = get_value(template_lines, "BIC")
        sen_info_data += f"{sen_bic} <br>"
    

    # Replace all keys with the values (GENERATE THE HTML FILE)
    for i in range(len(lines)):
        # Template data
        for j in range(len(template_lines)):
            lines[i] = lines[i].replace("#!" + template_lines[j].split(";")[0], template_lines[j].split(";")[1].replace("\n", ""))


        # Customer data
        for j in range(len(argkeys_customer)):
            if type(args.__dict__[argkeys_customer[j][0]]) == str and args.__dict__[argkeys_customer[j][0]] != "":
                lines[i] = lines[i].replace("#!" + argkeys_customer[j][3], args.__dict__[argkeys_customer[j][0]])

        # Date
        lines[i] = lines[i].replace("#!DATE", date)
        lines[i] = lines[i].replace("#!PAY-DATE", payment_date)

        # Invoice number
        lines[i] = lines[i].replace("#!INVOICE-NUM", invoice_number)

        # Sum with VAT
        lines[i] = lines[i].replace("#!SUM-WITHOUT-VAT", convert_to_euro_string(sum_netto))
        lines[i] = lines[i].replace("#!VAT-PERCENT", str(vat) + " %")
        lines[i] = lines[i].replace("#!VAT-ADDITION", convert_to_euro_string(vat_sum))
        lines[i] = lines[i].replace("#!SUM-WITH-VAT", convert_to_euro_string(sum_brutto))

        # Table
        lines[i] = lines[i].replace("#!ITEMS", table_html)

        # Sender info
        lines[i] = lines[i].replace("#!SEN-INFO-DESCRIPTION", sen_info_description)
        lines[i] = lines[i].replace("#!SEN-INFO-DATA", sen_info_data)

    # Remove all lines that have a #!
    for i in range(len(lines)):
        if lines[i].find("#!") != -1:
            lines[i] = ""

    # Save .html file to cache
    f = open(f"{cache_dir}/invoice.html", "w")
    f.writelines(lines)
    f.close()

    # Copy logo to cache dir.
    if args.logo != "":
        if not os.path.exists(args.logo):
            print(f'Error: Could not open logo file: "{args.logo}"')
            # Copy the default logo
            os.system(f"cp {current_dir}/html/logo.png {cache_dir}/logo.png")
        else:
            os.system(f"cp {args.logo} {cache_dir}/logo.png")
    else:
        # Copy the default logo
        os.system(f"cp {current_dir}/html/logo.png {cache_dir}/logo.png")


    print_path = f"{invoice_dir}/Rechnung-{invoice_number}.pdf"
    if args.dryRun:
        print("Dry run. Not saving the pdf to the invoice Dir.")
        print_path = f"{cache_dir}/Rechnung.pdf"

    # Check if chromium folder is present next to the script
    chromium_exec = ""
    if os.path.exists(f"{current_dir}/chromium"):
        chromium_exec = f"{current_dir}/chromium/chrome"
    else:
        chromium_exec = "chromium"


    os.system(f"{chromium_exec} --no-sandbox --headless --disable-gpu --print-to-pdf={print_path} --no-margins --no-pdf-header-footer  file://{cache_dir}/invoice.html ")

    pass

if __name__ == "__main__":
    main()

