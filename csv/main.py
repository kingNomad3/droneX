import csv

# nom du statement execute
nom_statement = "ins_technical_specifications"
result = ""
replace_null = False
# Faire attention, le résultat n'est pas assuré


# nom du fichier!
open_file = open('technical_specifications.csv', 'r')
csv_file = csv.reader(open_file, delimiter=',')

# skip le header
next(csv_file)

# traverse les inserts
for row in csv_file:
    
    buffer = ""
    
    for value in row:
        value = value.strip()    
        value = "'" + value + "'," 
        buffer += value
    
    buffer = buffer.rstrip(',')
    buffer = buffer.replace('"', '')
    
    # à discuter avec JC
    if (replace_null):
        buffer = buffer.replace("'-'", "NULL")
    
    result += f"EXECUTE {nom_statement}({buffer});\n"
    
    
open_file.close()

f = open("test.txt", "w")
f.write(result)
f.close()



