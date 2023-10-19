import csv
import sys

def parse_csv_to_execute(fname:str, execute_name:str, replace_null: bool = False) -> None:
    """ DOC STRING
    - Prends un nom de fichier (pas absolu) et écrit un execute statement
    en plgsql pour produire une requête avec le format csv donné. 'Escape' 
    le header du fichier CSV.
    
    - Note : Il est possible de remplacer les '-' par NULL avec le troisième 
    paramètre (False par défaut).
    
    - Exemple: execute_name est le nom de la requête à retourner: EXECUTE ins_table (); ...
    
    """


    open_file = open(fname, 'r')
    csv_file = csv.reader(open_file, delimiter=',')
    next(csv_file)

    result = ""
    for row in csv_file:
        ligne_courante = ""
        for value in row:
            value = value.strip()    
            value = "'" + value + "'," 
            ligne_courante += value
        
        ligne_courante = ligne_courante.rstrip(',')
        ligne_courante = ligne_courante.replace('"', '')
        
        # à discuter avec JC
        if (replace_null):
            ligne_courante = ligne_courante.replace("'-'", "NULL")
        
        result += f"EXECUTE {execute_name}({ligne_courante});\n"
        
    open_file.close()

    return result

def write_to_file(content:str, fname:str):
    f = open(fname, "w")
    f.write(content)
    f.close()
    




if __name__ == "__main__":
    args = sys.argv
    
    output = parse_csv_to_execute("states.csv", "ins_states", replace_null=True)
    
    write_to_file(output, "result.txt")