*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem
Library  String

Resource  resources.robot
Suite Setup  Run Keywords   Navigate To Home Page   Delete Invoice If Exists
Suite Teardown  Run Keywords    Close Browser


*** Test Cases ***
Create an Invoice
    Click Add Invoice
    ${invoiceNumber}=    Create Invoice Number
    Set Suite Variable  ${invoiceNumber}
    Input Text  invoice   ${invoiceNumber}
    Input Text  company   my example company
    Input Text  type   plumbing
    Input Text  price   34.00
    Input Text  dueDate   2018-10-31
    Input Text  comment   Unclogged Drain
    Select From List By Value   selectStatus    Past Due
    Click Button    createButton
    Page Should Contain     ${invoiceNumber}
    ${invoice_count}=   Get Element Count     //a[@href="#/editInvoice"]
    :FOR    ${invoice}    IN RANGE    0  ${invoice_count}
    \    ${invoice_id}=    Get Text   (//a[@href="#/editInvoice"])[${invoice + 1}]
    \    Log To Console     ${invoice_id}



*** Keywords ***
Navigate To Home Page
    # Requires Chromedriver in Path (See earlier Excercise)
    Open Browser    ${SiteUrl}		${Browser}
    Set Selenium Speed    1.5 Seconds


Click Add Invoice
    Click Link  Add Invoice
    Page Should Contain Element     invoiceNo_add

Delete Invoice
    [Arguments]  ${invoice_element}
    Click Link  ${invoice_element}
    Click Button    deleteButton

Create Invoice Number
    ${RANUSER}    Generate Random String    10    [LETTERS]
    [Return]    ${RANUSER}

Delete Invoice If Exists
    ${invoice_count}=   Get Element Count    css:[id^='invoiceNo_paulm'] > a
    Run Keyword If      ${invoice_count} > 0    Delete Invoice  css:[id^='invoiceNo_paulm'] > a
