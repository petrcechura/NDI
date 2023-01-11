


while True:
    binary_number = input("Binary number?: ")
    if len(binary_number) % 2 == 1 or binary_number == "":
        print("Wrong format!")
        continue
    max_number = pow(2, len(binary_number)/2-1)
    
    if binary_number[0] == '1': # number is negative
        result = -pow(2, len(binary_number)/2)
        string_result = str(-pow(2, len(binary_number)/2))
        for i in binary_number:
            if i == '1':
                result = result + max_number
                string_result = string_result + " + " + str(max_number)
            max_number = max_number/2
        
    elif binary_number[0] == '0': # number is positive
        result = 0
        string_result = "0"
        for i in binary_number:
            if i == '1':
                result = result + max_number
                string_result = string_result + " + " + str(max_number)
            max_number = max_number/2
        
    print("Decimal form is : "  + str(result))
    print("and a bit size: " + str(len(binary_number)))
    print("Calculation: " + string_result + "\n\n")
    

